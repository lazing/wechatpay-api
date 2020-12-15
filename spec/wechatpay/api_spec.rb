require File.expand_path('../../spec_helper', __FILE__)

RSpec.describe Wechatpay::Api do

  it :client do

    client = described_class.client do |klass|
      klass.new 'appid', 'mch_id', key: 'key'
    end

    expect(described_class.client).to eq(client)
  end
  
end
