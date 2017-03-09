require "vagrant/util/template_renderer"
require "vagrant-guest-msys2/util/cap_helpers"

module VagrantPlugins
  module GuestMSYS2
    module Cap
      class MountSharedFolder
        def self.mount_virtualbox_shared_folder(machine, name, guestpath, options)
          mount_shared_folder(machine, name, guestpath, "\\\\vboxsrv\\")
        end

        def self.mount_vmware_shared_folder(machine, name, guestpath, options)
          mount_shared_folder(machine, name, guestpath, "\\\\vmware-host\\Shared Folders\\")
        end

        def self.mount_parallels_shared_folder(machine, name, guestpath, options)
          mount_shared_folder(machine, name, guestpath, "\\\\psf\\")
        end

        def self.mount_smb_shared_folder(machine, name, guestpath, options)
          machine.communicate.execute("cmdkey -add:#{options[:smb_host]} -user:#{options[:smb_username]} -pass:#{options[:smb_password]}")
          mount_shared_folder(machine, name, guestpath, "\\\\#{options[:smb_host]}\\")
        end

        protected

        def self.mount_shared_folder(machine, name, guestpath, vm_provider_unc_base)
          name = name.gsub(/[\/\/]/,'_').sub(/^_/, '')
          path = File.expand_path("../../scripts/mount_volume.ps1", __FILE__)
          script = Vagrant::Util::TemplateRenderer.render(path, options: {
            mount_point: guestpath,
            share_name: name,
            vm_provider_unc_path: vm_provider_unc_base + name,
          })
          machine.communicate.execute(Util::CapHelpers.wrap_powershell(script))
        end
      end
    end
  end
end
