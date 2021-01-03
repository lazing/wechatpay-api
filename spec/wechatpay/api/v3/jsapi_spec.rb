require File.expand_path('../../../spec_helper', __dir__)

RSpec.describe Wechatpay::Api::V3::JSAPI do

  let(:client) { Wechatpay::Api::V3::Client.new 'app_id', 'mch_id' }

  it :sign do
    allow_any_instance_of(Wechatpay::Api::V3::Client).to receive(:rsa_key).and_return(OpenSSL::PKey::RSA.new 2048)
    expect(client.js_sign('prepay_id=xxxxx', Time.now.to_i, 'nonce')).not_to be_nil
  end
end
