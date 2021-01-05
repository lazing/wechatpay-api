require 'base64'
require 'faraday'
require 'multi_json'
require 'openssl'
require 'logger'
require 'securerandom'

module Wechatpay
  module Api
    module V3
      class Client

        attr_reader :rsa_key, :serial_no, :mch_id, :appid, :key
        attr_accessor :logger, :site

        SCHEMA = 'WECHATPAY2-SHA256-RSA2048'.freeze

        def initialize(appid, mch_id, **opts)
          @appid = appid
          @mch_id = mch_id
          @rsa_key = OpenSSL::PKey::RSA.new opts[:cert] if opts[:cert]
          @serial_no = opts[:cert_no]
          @key = opts[:key]
          @site = opts[:site] || 'https://api.mch.weixin.qq.com'

          @logger = Logger.new(STDOUT)
        end

        def connection
          Faraday.new(url: @site) do |conn|
            conn.request :retry
            conn.response :logger
            # conn.response :raise_error
            conn.adapter :net_http
          end
        end

        def get(path, params = nil)
          resp = connection.get(path, params) do |req|
            path = req.path
            path = [req.path, Faraday::Utils.build_query(req.params)].join('?') unless params.nil? || params.empty?
            req.headers['Authorization'] = authorization_header('GET', path, nil)
            req.headers['Accept'] = 'application/json'
          end
          handle resp
        end

        def post(path, data, **headers)
          body = data.is_a?(Hash) ? MultiJson.dump(data) : data
          resp = connection.post(path, body, headers) do |req|
            req.headers['Content-Type'] = 'application/json'
            req.headers['Authorization'] = authorization_header('POST', path, body)
            req.headers['Accept'] = 'application/json'
          end
          handle resp
        end

        def verify(headers, body)
          sha256 = OpenSSL::Digest::SHA256.new
          key = cert.certificate.public_key
          sign = Base64.strict_decode64(headers['Wechatpay-Signature'])
          data = %w[Wechatpay-Timestamp Wechatpay-Nonce].map { |k| headers[k] }
          key.verify sha256, sign, data.append(body).join("\n") + "\n"
        end

        def cert
          Wechatpay::Api::V3::Cert.instance.load || update_certs
        end

        def update_certs
          certs = get('/v3/certificates')[:data]
          certs.map do |raw|
            Wechatpay::Api::V3::Cert.instance.update(raw, &method(:decrypt))
          end
          Wechatpay::Api::V3::Cert.instance
        end

        def handle(resp)
          logger.debug { "HANDLE RESPONSE: #{resp.inspect}" }
          raise :response_error unless resp.success?

          data = resp.body
          raise :empty_body unless data && !data.empty?

          MultiJson.load data, symbolize_keys: true
        end

        def sign_with(body, method, path, timestamp, rnd)
          str = [method, path, timestamp, rnd, body].join("\n") + "\n"
          logger.debug { "Sign Content: #{str.inspect}" }
          sign_content(str)
        end

        def sign_content(content)
          digest = OpenSSL::Digest::SHA256.new
          signed = rsa_key.sign(digest, content)
          Base64.strict_encode64 signed
        end

        def authorization_header(http_method, path, body)
          [SCHEMA, authorization_params(http_method, path, body)].join ' '
        end

        def authorization_params(http_method, path, body)
          timestamp = Time.now.to_i
          rnd = SecureRandom.hex
          signature = sign_with(body, http_method, path, timestamp, rnd)
          [
            "mchid=\"#{mch_id}\"", "serial_no=\"#{serial_no}\"", "nonce_str=\"#{rnd}\"",
            "timestamp=\"#{timestamp}\"", "signature=\"#{signature}\""
          ].join(',')
        end

        def decrypt(cipher_text, nonce, auth_data)
          raise :cipher_text_invalid if cipher_text.nil?

          data = Base64.strict_decode64(cipher_text)
          dec = decipher(data, nonce, auth_data)
          dec.update(data[0, data.length - 16]).tap { |s| logger.debug "DEC: #{s}" } + dec.final
        end

        def decipher(data, nonce, auth_data)
          cipher = OpenSSL::Cipher.new 'aes-256-gcm'
          cipher.decrypt
          cipher.key = key
          cipher.iv = nonce
          cipher.padding = 0
          cipher.auth_data = auth_data
          cipher.auth_tag = data[-16, 16]
          cipher
        end
      end
    end
  end
end
