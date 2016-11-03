module VagrantPlugins
  module GuestMSYS2
    module Cap
      class Powershell
        def self.powershell_installed(machine)
          machine.communicate.test('which powershell')
        end
        
        def self.powershell_install(machine)
          machine.ui.info I18n.t("vagrant-guest-msys2.info.run_powershell_install")
          script = <<-EOH.gsub(/^ {12}/, '')
            set -e
            OS_VERSION=`echo '' | wmic os get version | grep -o '^[0-9]*\\.[0-9]*'`
            OS_ARCH=`regtool -l get '\\HKLM\\SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Environment\\PROCESSOR_ARCHITECTURE' | tr '[:upper:]' '[:lower:]'`
            
            if [ "$OS_VERSION" = "5.1" -a "$OS_ARCH" = "x86" ]; then # Windows XP 32-bit
              pacman -S --noconfirm wget
              
              if ! (regtool -l get '\\HKLM\\SOFTWARE\\Microsoft\\NET Framework Setup\\NDP\\v2.0.50727\\SP' | grep -q "1"); then
                wget --no-verbose --no-check-certificate "https://download.microsoft.com/download/0/8/c/08c19fa4-4c4f-4ffb-9d6c-150906578c9e/NetFx20SP1_x86.exe" -O "/tmp/NetFx20SP1_x86.exe"
                /tmp/NetFx20SP1_x86.exe //passive //norestart
                rm /tmp/NetFx20SP1_x86.exe
              fi
              
              if ! (regtool -l get '\\HKLM\\SOFTWARE\\Microsoft\\PowerShell\\1\\PowerShellEngine\\PowerShellVersion' | grep -q "2\\.0"); then
                  wget --no-verbose --no-check-certificate "https://download.microsoft.com/download/E/C/E/ECE99583-2003-455D-B681-68DB610B44A4/WindowsXP-KB968930-x86-ENG.exe" -O "/tmp/WindowsXP-KB968930-x86-ENG.exe"
                  /tmp/WindowsXP-KB968930-x86-ENG.exe //passive //norestart
                  rm /tmp/WindowsXP-KB968930-x86-ENG.exe
              fi
            else
              (>&2 echo Unsupported OS $OS_VERSION $OS_ARCH)
            fi
            
            if [ -f "c:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe" -a ! -f /bin/powershell ]; then
                echo '#!/bin/sh'$'\\n''"c:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe" -inputformat none $@' > /bin/powershell
                chmod 755 /bin/powershell
            fi
            
            which powershell
          EOH
          machine.communicate.execute(script)
        end
        
        def self.powershell_check(machine)
          if machine.guest.capability?(:powershell_installed)
            installed = machine.guest.capability(:powershell_installed)
            if !installed
              if machine.guest.capability?(:powershell_install)
                machine.guest.capability(:powershell_install)
              end
              installed = machine.guest.capability(:powershell_installed)
              raise Errors::PowershellNotInstalledInGuest if !installed
            end
          end
        end
      end
    end
  end
end
