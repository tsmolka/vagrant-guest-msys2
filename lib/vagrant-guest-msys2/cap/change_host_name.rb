require "vagrant-guest-msys2/util/cap_helpers"

module VagrantPlugins
  module GuestMSYS2
    module Cap
      module ChangeHostName
          def self.change_host_name(machine, name)
            change_host_name_and_wait(machine, name, machine.config.vm.graceful_halt_timeout)
          end

          def self.change_host_name_and_wait(machine, name, sleep_timeout)
            machine.guest.capability(:powershell_check) if machine.guest.capability?(:powershell_check)
            
            escaped_name = name.gsub("'", "''")
            
            # If the configured name matches the current name, then bail
            # We cannot use %ComputerName% because it truncates at 15 chars
            return if machine.communicate.test(Util::CapHelpers.wrap_powershell("if ([System.Net.Dns]::GetHostName() -eq '#{escaped_name}') { exit 0 } exit 1"))
            
            # Rename and reboot host if rename succeeded
            script = <<-EOH.gsub(/^ {14}/, '')
              $computer = Get-WmiObject -Class Win32_ComputerSystem
              $retval = $computer.rename('#{escaped_name}').returnvalue
              if ($retval -eq 0) {
                shutdown -r -t 5 -f -d p:4:1 -c "Vagrant Rename Computer"
              }
              exit $retval
            EOH
            machine.ui.info I18n.t("vagrant-guest-msys2.info.run_change_host_name", host: name)
            machine.communicate.execute(Util::CapHelpers.wrap_powershell(script))

            # Don't continue until the machine has shutdown and rebooted
            machine.ui.info I18n.t("vagrant-guest-msys2.info.run_wait_for_reboot", host: name)
            sleep(sleep_timeout)
          end
        end
    end
  end
end
