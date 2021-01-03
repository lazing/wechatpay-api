
module Wechatpay
  module Api
    module V3
      module JSAPI
        def js_prepay(openid, out_trade_no, description, total_amount, **opts)
          data = {
            appid: appid, mchid: mch_id, description: description,
            out_trade_no: out_trade_no, amount: { total: total_amount, currency: 'CNY' },
            payer: { openid: openid }
          }.merge(opts)
          res = post '/v3/pay/transactions/jsapi', data
          res[:prepay_id]
        end

        def js_sign(package, timestamp, nonce)
          str = [appid, timestamp, nonce, package].join("\n") + "\n"
          sign_content(str)
        end
      end

      Client.include JSAPI
    end
  end
end

