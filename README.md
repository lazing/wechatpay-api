# wechatpay-api
Yet Another wechatpay sdk for ruby 另一个微信支付Ruby SDK。
APIv3 接口版本V3

公众号API SDK: https://github.com/lazing/wechat-api

# Install

```ruby
gem 'wechatpay-api', '~>0.1'
```


or

```ruby
gem install wechatpay-api
```

# Usage

## Prepare

Essential configure items and datus from wechat pay 需要从微信支付获取的必要配置项目

  * appid - 公众号ID
  * mchid - 商户号
  * key - 32 bytes secret key to encrypt and decrypt 32字节加解密key
  * cert_no - APIv3 certification serial no. 从微信支付获取的APIv3证书序列号
  * cert - APIv3 certification private key pem, content as string. 从微信支付获取的APIv3证书私钥，内容作为文本输入

## Configuration and direct usage

```ruby
# initialize with a file like wechatpay-api.rb inside rails config initilizers
Wechatpay::Api.client do |klass|
  klass.new 'appid', 'mchid', key: 'key', cert: 'apiv3 certification...', cert_no: 'cert_no'
end

# next in anywhere needs, using get or post, will sign automatic. response body 
response_body_as_hash_symbolized = Wechatpay::Api.client.get '/path', params
response_body_as_hash_symbolized = Wechatpay::Api.client.post '/path', hash_as_body, headers

# check incoming request
Wechatpay::Api.client.verify headers, body
```

## JSAPI Helper Example

```ruby
# initilized somehow Wechatpay::Api.client do |klass| ..... end
# reference the client
client = Wechatpay::Api.client 
# STEP 1. after generate your own order object, start prepay
prepay_id = client.js_prepay(openid, out_trade_no, description, total_amount, **opts)

# STEP 2. get signature for WXJS SDK call
timestamp = Time.now.to_i
nonce = SecureRandom.hex
package = "prepay_id=#{prepay_id}"
signature = client.js_sign(package, timestamp, nonce)

# STEP 3. expose to view and start payment

# STEP 4. build a API endpoint to receive wechat payment notice
# request header and body

decrypted_hash = client.notice(headers, body)

```

