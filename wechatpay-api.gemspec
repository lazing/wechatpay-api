# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'wechatpay/api/version'

Gem::Specification.new do |s|
  s.name          = 'wechatpay-api'
  s.version       = Wechatpay::Api::VERSION
  s.authors       = ['lazing']
  s.email         = ['lazing@gmail.com']
  s.homepage      = 'https://github.com/lazing/wechatpay-api'
  s.licenses      = ['MIT']
  s.summary       = '[summary]'
  s.description   = '[description]'

  s.files         = Dir.glob('{bin/*,lib/**/*,[A-Z]*}')
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
end
