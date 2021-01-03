require File.expand_path('../../../spec_helper', __dir__)

RSpec.describe Wechatpay::Api::V3::Client do
  let(:client) do
     Wechatpay::Api::V3::Client.new 'app_id', 'mch_id', rsa_key: rsa_key
  end

  let(:rsa_key) do
    <<~KEY
      -----BEGIN PRIVATE KEY-----
      MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDc8N6Pv+jNkq9g
      kx8LvtqUE9Dgm395+p9ng9cBEcbr4LAeh3ExX9evVPm6TW7R+Bik7EwikBS+1f5f
      jCbozMCmqTMjq+lKSv47h2+G3G7kHLFGCc1DrrNnhqT0JoHouZmMJbYJUAN8DbGw
      iQo+wXQGHxAidNRKPxiuy5UL9c4GL2fcXDvH1ZcMXBpFTQO5/BYOtjhBH9HqY+yl
      bu9zOlce2cmHQ+PsvGpjLmavaIZJSfDEVH0vx4XBY+hbWwT3vRA/S+CaCx20gF59
      8DRr+X7Kpd/ayPXsfapcpcKcbwM70nqgdg/U6uveHL25uT1DAF5AmdNYKnq8qGGc
      vs3RCOutAgMBAAECggEBAJVQx+j4dpov7wxigVHLyybV+Y1CKbXDFeW8aRrU683P
      zNblDC+lKTvaPueUmzeV5vnWpGGbZBnQv5fNPSKJ9gzsPp51+TT3V7fdgRbwdJT/
      eyLtTubV83McwPAr8hHZFRdtCQhkJea5zoOTKfRdg077wUi4EhyXZdQDzBgIKBNu
      xtYPWCsJFAO7G0Y64idZK+FPeof+rLvldpzw0dp/tKskx/OzwURDLkxcxfVzV95t
      OujQKzv5YyzlJ9nI/ldNJoO5lMok4vdHYM9T82BhPDQ8+KCJimFIJkOQwGMwr3o/
      n7jWQcmB3CrdXNbEeYV8vXAODY0AkC3lr6gRecUQwRUCgYEA8DtYVj7QViPoKcfp
      xacD4GYiZn0MYSFj2y6ur04JNgVacpweK9KbtYtKlxxDekESGEsEZvfAlo9czwTu
      mTOrwkZniqMlqVxuG0rFJCaJ30fMocNkIy0StG258S7Xr89/55dVwyDkGmiroVrJ
      6hPQbRUJmeIilHsd1+EE5zMLl78CgYEA63FgM4Ev8C+vMgtKWg2zwCBItDpE4Mqm
      9iPCh3BuoIZ+Q48FtzkxQ0OZVBcsqz4HadVu7aj7LVQL8DI694j57Pw87BVBJx90
      ZlxtSsA7wZTLWqWvDkDeUFnMWLPXHA6s1ZVZFwDGYR2IDCJadGnbq7awmasISprd
      iPRVlD/pd5MCgYBxq4L2/C3UNJVL/74LuiVJbspkOFM9OnFnasVZSdFt8EaF6H0W
      O0dWNZyLt+Ht3RBU0lo45o4IL7m4cxr6/soM2QdxQBU39/ZZj52Mp3ehYPXgrPWa
      917cZPcQuhtwovxgdukrtUp5fIGJjc3wpoN+ue+bErdODptmZKDPTQX1PQKBgDOS
      EuNVMb3ng/VvOar+A1ha+fHYLYwbd3TEonBuNR0eOHvt0O+wLFUyclxT8ynTHWaW
      JIUUFWh5V2AWcIoVy8CYA3Qmt62tGx7ssdfEwZIGWICTeAOkO83XzYXEZqKzqDHk
      U65RMiLFiC44PB3xrfcvvgD60Ice4tWDx1cApM/XAoGAQkP3L3YLqCdxwy6rQUNW
      l6QO8PNRPsdJ5N/6a9vZ58RHdJWlpQMbrBMiBhaRGylGlgpe/Q/kf6VB/cf82C6G
      RDA2t0gMfiqZ/zBOhwGnKCJIMJup4fVQ77SchbRDGohMy666TCH1VXxdpI/V6y9V
      HxJ+pz0jRBU8Ul+Nn4qjP8c=
      -----END PRIVATE KEY-----
    KEY
  end

  let(:body) { nil }
  let(:path) { '/v3/certificates' }
  let(:method) { 'GET' }
  let(:timestamp) { 1554208460 }
  let(:rnd) { '593BEC0C930BF1AFEB40B4A08C8FB242' }
  let(:signature) { 'XGHnYxdaYCCk9XF1nwSDZZHil6451ExdOeCtie5Qia1P4xxdy/Zqx+l/MYAGX24gqU6TWZReBFNpOi64/vH4kbcD7GLgjn9lCVXaad+fQHfIa9zjCvzquiHjeWM4guTzIKJ9tXjzaZQU7bLqh4j39ocMf6ONP+UBSKI+PIp9sxWi7ZO69rVsTSxWk7C5LpPIyG/cW9/ivxWVpCtdL0fxomvK3PVOVAbFN7wsm4KDStc2Ci8k/yTYMEK9/VJsgjcZtAzu/BCa/Sxqsep/p2m0ud8aWSkXXILHv77eVvioF+eHcdGLTHEjH9SsgdYg11PQ7EJ+CP5TYx+4eWTL+RELrQ==' }

  context :sign do
    it :sign do
      s = client.sign_with(body, method, path, timestamp, rnd)
      expect(s).to eq(signature)
    end

    it :authorization_header do
      header = client.authorization_header(method, path, body)
      expect(header).to match /WECHATPAY2/
    end

    it :get do
      stub_request(:get, /path/).and_return body: '{"ok": 1}'
      client.get '/path?a=1', b: 2
    end

    it :post do
      stub_request :post, /path/
      client.post '/path?a=1', c: 3
    end
  end
end
