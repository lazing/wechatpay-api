module Wechatpay
  module Api
    class Error < StandardError; end
    module V2
    end

    def self.client(appid = 'origin_id')
      var = "@v#{appid}"
      if instance_variable_defined?(var)
        instance_variable_get(var)
      elsif block_given?
        c = yield(V2::Client)
        instance_variable_set var, c
      else
        raise Error, :not_initialized
      end
    end
  end
end

require 'wechatpay/api/v2/client'
