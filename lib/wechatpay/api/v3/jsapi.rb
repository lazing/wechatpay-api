
module Wechatpay
  module Api
    module V3
      module JSAPI
        def js_prepay(openid, out_trade_no, description, total_amount, **opts)
          # TODO: implement
        end

        def js_sign(prepay_id)
          # TODO: jsapi need a sign
        end
      end

      Client.include JSAPI
    end
  end
end

