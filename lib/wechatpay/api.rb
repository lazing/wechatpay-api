module Wechatpay
  module Api
    class Error < StandardError; end
    module V3; end

    def self.client(appid = 'origin_id')
      var = "@v#{appid}"
      if block_given?
        c = yield(V3::Client)
        instance_variable_set var, c
      elsif instance_variable_defined?(var)
        instance_variable_get(var)
      else
        raise Error, :not_initialized
      end
    end
  end
end

require 'wechatpay/api/v3/client'
require 'wechatpay/api/v3/trade'
require 'wechatpay/api/v3/jsapi'
require 'wechatpay/api/v3/cert'
