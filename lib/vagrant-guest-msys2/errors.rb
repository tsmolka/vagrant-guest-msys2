module VagrantPlugins
  module GuestMSYS2
    module Errors
      # A convenient superclass for all our errors.
      class MSYS2Error < Vagrant::Errors::VagrantError
        error_namespace("vagrant-guest-msys2.errors")
      end

      class RenameComputerFailed < MSYS2Error
        error_key(:rename_computer_failed)
      end
      
      class PowershellNotInstalledInGuest < MSYS2Error
        error_key(:powershell_not_installed_in_guest)
      end
      
      class PowershellInstallationFailed < MSYS2Error
        error_key(:powershell_installation_failed)
      end
      
    end
  end
end
