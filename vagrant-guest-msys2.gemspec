# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "vagrant-guest-msys2/version"

Gem::Specification.new do |s|
  s.name          = "vagrant-guest-msys2"
  s.version       = VagrantPlugins::GuestMSYS2::VERSION
  s.platform      = Gem::Platform::RUBY
  s.license       = "GPL-2.0"
  s.authors       = ["Tobias", "et al"]
  s.email         = "tsmolka@gmail.com"
  s.summary       = "MSYS2 guest for Vagrant"
  s.description   = "Adds MSYS2 (https://sourceforge.net/p/msys2/wiki/Home/) as a guest for Vagrant. "
  s.homepage      = "https://github.com/tsmolka/vagrant-guest-msys2"
  s.required_rubygems_version = ">= 1.3.6"
  root_path       = File.dirname(__FILE__)
  
  s.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  s.require_path  = 'lib'
end

