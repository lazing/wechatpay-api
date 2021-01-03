require 'multi_json'

module Wechatpay
  module Api
    module V3
      module Trade

        def notice(headers, payload)
          raise :verify_fail unless verify(headers, payload)

          data = MultiJson.load(payload, symbolize_keys: true)
          r = data[:resource]
          text = decrypt r[:ciphertext], r[:nonce], r[:associated_data]
          MultiJson.load(text, symbolize_keys: true)
        end
      end

      Client.include Trade
    end
  end
end

