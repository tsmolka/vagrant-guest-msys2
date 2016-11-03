begin
  require 'vagrant'
rescue LoadError
  raise 'The vagrant-guest-msys2 plugin must be run within Vagrant.'
end

module VagrantPlugins
  module GuestMSYS2
    class Plugin < Vagrant.plugin("2")
      name "MSYS2 guest"
      description "MSYS2 guest support."

      guest('msys2') do
        init!
        
        require File.expand_path("../guest", __FILE__)
        Guest
      end

      guest_capability("msys2", "halt") do
        require_relative "cap/halt"
        Cap::Halt
      end
      
      guest_capability("msys2", "insert_public_key") do
        require_relative "cap/insert_public_key"
        Cap::InsertPublicKey
      end
      
      guest_capability("msys2", "remove_public_key") do
        require_relative "cap/remove_public_key"
        Cap::RemovePublicKey
      end

      guest_capability("msys2", "rsync_installed") do
        require_relative "cap/rsync"
        Cap::RSync
      end
      
      guest_capability("msys2", "rsync_install") do
        require_relative "cap/rsync"
        Cap::RSync
      end
      
      guest_capability("msys2", "rsync_command") do
        require_relative "cap/rsync"
        Cap::RSync
      end
      
      guest_capability("msys2", "rsync_pre") do
        require_relative "cap/rsync"
        Cap::RSync
      end
      
      guest_capability("msys2", "rsync_post") do
        require_relative "cap/rsync"
        Cap::RSync
      end
      
      protected

      def self.init!
        return if defined?(@_init)
        I18n.load_path << File.expand_path('locales/en.yml', VagrantPlugins::GuestMSYS2.source_root)
        I18n.reload!
        @_init = true
      end
    
    end
  end
end
