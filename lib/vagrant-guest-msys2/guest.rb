require "vagrant"

module VagrantPlugins
  module GuestMSYS2
    class Guest < Vagrant.plugin("2", :guest)
      def detect?(machine)
        machine.communicate.test("uname -o | grep -i msys")
      end
    end
  end
end
