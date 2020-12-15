require 'faraday'
require 'multi_json'
require 'openssl'
require 'logger'
require 'nokogiri'
require 'nori'
require 'gyoku'
require 'securerandom'

require 'wechatpay/api/v2/pay'

module Wechatpay
  module Api
    module V2
      class Client

        include Pay

        attr_reader :appid, :mch_id, :key
        attr_accessor :logger, :site

        def initialize(appid, mch_id, **opts)
          @appid = appid
          @mch_id = mch_id
          @key = opts[:key]
          @site = opts[:site] || 'https://api.mch.weixin.qq.com'

          @logger = Logger.new(STDOUT)
        end

        def post(url, params, headers = {})
          data = sign(merge(params))
          response = connection.post url, xml(data), headers
          logger.debug { { response: response } }
          handle(response.body)
        end

        def verify(response)
          sign = response.delete(:sign)
          test = sign(response)
          logger.debug { { result: test } }
          sign == test[:sign]
        end

        def parse(body)
          parser.parse(body)
        end

        private

        def requires(params, keys)
          actual = params.keys.map(&:to_sym)
          return if keys == (actual & keys)

          raise Wechatpay::Api::Error, "missing params #{keys - actual}"
        end

        def connection
          Faraday.new(url: @site) do |conn|
            conn.request :retry
            conn.response :logger
            conn.response :raise_error
            conn.adapter :net_http
          end
        end

        def handle(body)
          response = parse(body) 
          check(response)
          response
        end

        def parser
          Nori.new
        end

        def check(res)
          return if res['xml']['result_code'] == 'SUCCESS'

          handle_error(res['xml']['err_code'], res)
        rescue NoMethodError
          logger.warn { res.inspect }
          raise Error, 'Bad Response'
        end

        def handle_error(error_code, response)
          raise ERRORS[error_code] || PayError, response.inspect
        end

        def xml(hash)
          Gyoku.xml({ xml: hash }, key_converter: :none)
        end

        def sign(params)
          ordered = trim_and_sort(params)
          keystr = format('key=%<key>s', key: key)
          origin = ordered.map { |k, v| [k, v].join('=') }.push(keystr).join('&')
          sign = Digest::MD5.hexdigest(origin).upcase
          logger.debug { format('origin: %s, sign: %s', origin, sign) }
          params.merge(sign: sign)
        end

        def trim_and_sort(params)
          params.delete_if { |_k, v| v.to_s.blank? }
          Hash[params.sort]
        end

        def merge(params)
          { mch_id: @mch_id, nonce_str: nonce_str }.merge(params)
        end

        def nonce_str
          SecureRandom.hex
        end
      end
    end
  end
end
