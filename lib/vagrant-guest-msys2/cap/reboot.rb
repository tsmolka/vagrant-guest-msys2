module VagrantPlugins
  module GuestWindows
    module Cap
      class Reboot
        def self.wait_for_reboot(machine)
          return if machine.config.vm.communicator != :ssh
          
          script  = File.expand_path("../../scripts/reboot_detect.ps1", __FILE__)
          script  = File.read(script)
          while machine.communicate.execute(script, error_check: false) != 0
            sleep 10
          end

          # This re-establishes our symbolic links if they were
          # created between now and a reboot
          machine.communicate.execute("net use", error_check: false)
        end
      end
    end
  end
end
