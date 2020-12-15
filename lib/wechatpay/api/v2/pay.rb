module Wechatpay
  module Api
    module V2
      module Pay

        def unifiedorder(params)
          requires(params, %i[body out_trade_no total_fee spbill_create_ip notify_url trade_type])
          post('/pay/unifiedorder', params)
        end

        def jsapi_params(params)
          requires(params, %i[prepayid])

          data = {
            appId: appid,
            package: format('prepay_id=%<prepayid>s', params),
            nonceStr: nonce_str,
            timeStamp: Time.now.to_i,
            signType: 'MD5'
          }
          sign(data)
        end
      end
    end
  end
end