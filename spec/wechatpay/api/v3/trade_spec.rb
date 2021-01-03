require File.expand_path('../../../spec_helper', __dir__)

RSpec.describe Wechatpay::Api::V3::Trade do

  let(:client) { Wechatpay::Api::V3::Client.new 'app_id', 'mch_id', key: key }
  let(:key) { '1' * 32 }
  let(:nonce) { 'fdasflkja484' }
  let(:associated_data) { '' }
  let(:headers) do
    {}
  end
  let(:ciphertext) do
    <<~TEXT
      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
    TEXT
  end

  let(:payload) do
    <<~JSON
      {
        "resource": { 
          "ciphertext": "#{ciphertext.strip}",
          "nonce": "#{nonce}",
          "associated_data": "#{associated_data}"
        }
      }
    JSON
  end

  it :notice do
    allow_any_instance_of(Wechatpay::Api::V3::Client).to receive(:verify).and_return(true)
    expect(client.notice(headers, payload)).to be_a(Hash)
  end
end
