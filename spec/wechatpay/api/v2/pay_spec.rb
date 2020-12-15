require File.expand_path('../../../spec_helper', __dir__)

RSpec.describe Wechatpay::Api::V2::Pay do
  subject do
    Wechatpay::Api::V2::Client.new\
      'wxd930ea5d5a258f4f', '10000100',
      key: '192006250b4c09247ec02edce69f6a2d', sign_key: 'sign_key'
  end

  context :jsapi do

    it :missing_params do
      expect do
        subject.unifiedorder a: 1
      end.to raise_error Wechatpay::Api::Error
    end

    it :unifiedorder do
      response = <<-XML
        <xml>
          <return_code><![CDATA[SUCCESS]]></return_code>
          <return_msg><![CDATA[OK]]></return_msg>
          <appid><![CDATA[wx2421b1c4370ec43b]]></appid>
          <mch_id><![CDATA[10000100]]></mch_id>
          <nonce_str><![CDATA[IITRi8Iabbblz1Jc]]></nonce_str>
          <openid><![CDATA[oUpF8uMuAJO_M2pxb1Q9zNjWeS6o]]></openid>
          <sign><![CDATA[7921E432F65EB8ED0CE9755F0E86D72F]]></sign>
          <result_code><![CDATA[SUCCESS]]></result_code>
          <prepay_id><![CDATA[wx201411101639507cbf6ffd8b0779950874]]></prepay_id>
          <trade_type><![CDATA[JSAPI]]></trade_type>
        </xml>
      XML
      stub_request(:post, /unifiedorder/).and_return(body: response)

      res = subject.unifiedorder\
        body: 'a',
        out_trade_no: 'out_trade_no',
        total_fee: 20.4,
        spbill_create_ip: '127.0.0.1',
        notify_url: '/none',
        trade_type: 'JSAPI'
      
      # pp { { response: response } }
      expect(res['xml']).to include('return_code' => 'SUCCESS')
    end

    it :jsapi_params do
      params = subject.jsapi_params(prepayid: 'wx201411101639507cbf6ffd8b0779950874')
      pp params
      expect(params).to have_key(:sign)
    end
  end
end