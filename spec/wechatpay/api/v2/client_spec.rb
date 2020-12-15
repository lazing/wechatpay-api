require File.expand_path('../../../spec_helper', __dir__)

RSpec.describe Wechatpay::Api::V2::Client do
  subject do
    Wechatpay::Api::V2::Client.new\
      'wxd930ea5d5a258f4f', '10000100',
      key: '192006250b4c09247ec02edce69f6a2d', sign_key: 'sign_key'
  end

  context :basic do
    it :trim_and_sort do
      expect(
        subject.send(:trim_and_sort, b: 2, c: 3, a: 1).values
      ).to start_with(1)
    end

    it :sign do
      params = {
        appid: 'wxd930ea5d5a258f4f',
        mch_id: 10_000_100,
        device_info: 1000,
        body: 'test',
        nonce_str: 'ibuaiVcKdpRxkhJA'
      }
      allow(subject).to receive(:nonce_str).and_return('ibuaiVcKdpRxkhJA')
      expect(subject.send(:sign, params)[:sign]).to eq('9A0A8659F005D6984697E2CA0A9CF3B7')
    end

    it :xml do
      expect(subject.send(:xml, b_1: 2, a: 1)).to match(/xml/)
    end

    it :post do
      expect do
        stub_request(:post, /api/).and_return(body: '<xml><result_code>SUCCESS</result_code></xml>')
        subject.post '/', a: 1
      end.not_to raise_error
    end

    it :verify do
      response = { a: 1, sign: '05A8262EF14793F0004DE3EBB14AC453' }
      expect(subject.verify(response)).to be_truthy
    end
  end
end
