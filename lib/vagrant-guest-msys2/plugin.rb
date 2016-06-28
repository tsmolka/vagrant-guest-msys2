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
        require File.expand_path("../guest", __FILE__)
        Guest
      end

      guest_capability("msys2", "halt") do
        require_relative "cap/halt"
        Cap::Halt
      end
      
      guest_capability("msys2", "insert_public_key") do
        require Vagrant.source_root.join('plugins/guests/linux/cap/insert_public_key') 
        VagrantPlugins::GuestLinux::Cap::InsertPublicKey
      end
      
      guest_capability("msys2", "remove_public_key") do
        require Vagrant.source_root.join('plugins/guests/linux/cap/remove_public_key')
        VagrantPlugins::GuestLinux::Cap::RemovePublicKey
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
      
    end
  end
end
