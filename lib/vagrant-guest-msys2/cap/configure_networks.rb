require "log4r"
require_relative "../guest_network"

module VagrantPlugins
  module GuestMSYS2
    module Cap
      module ConfigureNetworks
        @@logger = Log4r::Logger.new("vagrant::guest::windows::configure_networks")

        def self.configure_networks(machine, networks)
          @@logger.debug("Networks: #{networks.inspect}")
          @@logger.debug("communicator: #{machine.config.vm.communicator.inspect}")
          
          guest_network = GuestNetwork.new(machine.communicate)
          network_adapters = guest_network.network_adapters()
          @@logger.debug("network_adapters: #{network_adapters}")
          
          return
        end
      end
    end
  end
end
