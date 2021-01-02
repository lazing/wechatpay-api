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

    it :update_certs do
      key = <<~KEY
        -----BEGIN PRIVATE KEY-----
        MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC8GFDzYjTWjtJc
        8WLKyos/P/b+DZc7ywXrxZYpQ3x0jekFrd62Na4M2q1zHGKO5wUEd7u4F+GP9rXp
        UCCeSKVqY+acA1xAHdldaJlUAscN4PYDvrixCQDMDw5ImbVNvjyKOOQkwnyKWc+3
        yc4SVs2ir4v2e3/F0NkjmTfAFSpY0xsuqzJh3XMTblnwei9eagp5a1FcAAwk2WBs
        cP5qBPZhafrsbl/uqP1vu5nUVeRCIdNnojHA6soZeRTdmZNzhSZz0nzqFHwoaIu/
        XY9WFxise+P//GjrJOddFi4K9Zo9O3YnCluqsRWOS8RgeVmHHxElkl4R59yknqHl
        6M7pKjXFAgMBAAECggEBAIg6MD7ljJEspWzNIpju8sTfZdqAK10R4HrvAp9mEjg0
        I2WKlLdwz1rd8ithjnwjEz42HY3qNeJXc07ESqt4v9z696Vcxa5mL+x3+jyfOl1x
        5Zu2wPrvI1WnPdgVAvuIYT5Wj92TwjFNdKSOkyIzHgHKlFry/QpfBTTEHl2OtrnX
        A/mgdPyGist9qY9mqu9qkutTl7hCqWm2wUe+M8yExrs2NkdusoEb0eZ+xQUjPNp0
        Kw0uC0zJiPMw9cx91wbl0Ufy5kpr7ual4K3v1mqkatEdkv2QeZFDzneeIMWaJHp+
        qfh4HifbpEVPg+J8LkIHdUTot1l9OfB/om2C23FhHaECgYEA8kNKdG+7GfCTf7gg
        Wz+JUeluOFIQ5NuUqnYvlk8qz2mSAuayF7Rp0O73aNaHDxD7PQyQnOmeive/RYka
        BVYtQ7dBdRsHpv3vCo0UyJkWxL8agGwilIsnyOECT9etFeZHWB2r4k8XsXJG/Qvo
        f3aZC1B/e1UUcscmutShcelkn3kCgYEAxsK4QhXc5+PGq3xNPQy4gW5hG7b5u1WW
        DKXsQeNv0Eultybk/2PbAFQ2f1DKRn5qykbOEw3SMx88CkXK0sOLEYwuUX4KEcpg
        GCj3jfK1yxZUrRFi4x3c8XaZnNKJO4Tv9jzVNRqWcK0rFPPs+Sl7BL8Kp2XU8WYH
        AeIH1ulMua0CgYBP3z2h6+Bs6fNHTYZlbyov9l0fdncZbQezt6lyzgEYRv8bs8GN
        rS6h8tdhGjGHFxsuAoF/KkraGFpYa55HmiTsSXPsTxATz27LNL5gcJCgJz1uj7hK
        7yIbyYuAlWP8b2KgO5Aa2ea+2yVqck2iEJDeuRh+qgtG2D/9ovLjYoaJSQKBgG2z
        DNVUkb7epUkCavLV8YNmM2yDeaPeYdmLPjFDYPQavFSwv9UA/N9am1V7dpifrzsD
        BzvW9fvHMnENAht/V2MQ9oN9x/r3sj/DZJZQretv4L5AiU6GreoLJk86mAlknrhN
        7PLJQNzhhpSi6FjAfygodK3dc0DkqdttMBx6WSFlAoGBAJ5bBCftHAWpQ50GT/ul
        X2+fzIAJmgUUEHzTsj0vslFjO0Elq9XK/F/nQ21CVlgiaayBnK0TqnB3/rnQrPqO
        iO/MI68nzL32nOJCuoGjJH3d0lKE3Zq7ETbQRESuXRKgEChIDPJWLVbnDnRxjaJL
        nVqsnxMnBPkdSfwu/qh45aDA
        -----END PRIVATE KEY-----
      KEY
      serial_no = '27A837A45BD9E88ABEEBF8A420435AFF32FA1A7F'
      aes_key = '73qbY766FqqSCrgq2MSCj59F9Rss992Q'
      client = Wechatpay::Api::V3::Client.new 'wxdf5b88098221e11d', '1559818841', key: aes_key, rsa_key: key, serial_no: serial_no
      WebMock.disable!
      client.update_certs
      client.cert
      WebMock.enable!
    end
  end
end
