require 'multi_json'
require 'singleton'

module Wechatpay
  module Api
    module V3
      class Cert
        include Singleton

        attr_accessor :expires_at, :serial_no, :cert

        def update(json)
          expire_time = DateTime.parse(json[:expire_time])
          return unless expires_at.nil? || expire_time > expires_at

          @serial_no = json[:serial_no]
          @expires_at = expire_time
          ec = json[:encrypt_certificate]
          @cert = yield(ec[:ciphertext], ec[:nonce], ec[:associated_data])
        end

        def load
          return false if cert.nil? || expires_at < DateTime.now

          self
        end
      end
    end
  end
end
