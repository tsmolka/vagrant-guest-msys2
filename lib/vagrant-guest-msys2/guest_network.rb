require "log4r"
require "vagrant-guest-msys2/util/cap_helpers"

module VagrantPlugins
  module GuestMSYS2
    # Manages the remote Windows guest network.
    class GuestNetwork      
      def initialize(communicator)
        @logger       = Log4r::Logger.new("vagrant::guest::msys2::guestnetwork")
        @communicator = communicator
      end

      # Returns an array of all NICs on the guest. Each array entry is a
      # Hash of the NICs properties.
      #
      # @return [Array]
      def network_adapters
        @logger.debug("querying network adapters")
        
        # Note: without JSON escape because MACAddress and NetConnectionID 
        # can't contain invalid characters
        cmd = <<-EOH.gsub(/^ {10}/, '')
          $adapters = Get-WmiObject -Class Win32_NetworkAdapter -Filter "MACAddress IS NOT NULL"
          [string[]] $json= $()
          foreach ($adapter in $adapters) {
            $json += "{`
              `"mac_address`": `"$($adapter.MACAddress)`",`
              `"net_connection_id`": `"$($adapter.NetConnectionID)`",`
              `"interface_index`": $([int]$adapter.InterfaceIndex),`
              `"index`": $([int]$adapter.Index)`
            }"
          }
          Write-Host "[$($json -Join ",")]"
        EOH
        
        output = ""
        @communicator.execute(Util::CapHelpers.wrap_powershell(cmd)) do |type, line|
          output = output + "#{line}" if type == :stdout && !line.nil?
        end
        
        adapters = []
        JSON.parse(output).each do |nic|
          adapters << nic.inject({}){ |memo,(k,v)| memo[k.to_sym] = v; memo }
        end

        @logger.debug("#{adapters.inspect}")
        return adapters
      end

      # Checks to see if the specified NIC is currently configured for DHCP.
      #
      # @return [Boolean]
      def is_dhcp_enabled(nic_index)
        cmd = <<-EOH
          if (Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "Index=#{nic_index} and DHCPEnabled=True") {
            exit 0
          }
          exit 1
        EOH
        @communicator.test(Util::CapHelpers.wrap_powershell(cmd))
      end

      # Configures the specified interface for DHCP
      #
      # @param [Integer] The interface index.
      # @param [String] The unique name of the NIC, such as 'Local Area Connection'.
      def configure_dhcp_interface(nic_index, net_connection_id)
        @logger.info("Configuring NIC #{net_connection_id} for DHCP")
        if !is_dhcp_enabled(nic_index)
          netsh = "netsh interface ip set address \"#{net_connection_id}\" dhcp"
          @communicator.execute(netsh)
        end
      end

      # Configures the specified interface using a static address
      #
      # @param [Integer] The interface index.
      # @param [String] The unique name of the NIC, such as 'Local Area Connection'.
      # @param [String] The static IP address to assign to the specified NIC.
      # @param [String] The network mask to use with the static IP.
      def configure_static_interface(nic_index, net_connection_id, ip, netmask)
        @logger.info("Configuring NIC #{net_connection_id} using static ip #{ip}")
        #netsh interface ip set address "Local Area Connection 2" static 192.168.33.10 255.255.255.0
        netsh = "netsh interface ip set address \"#{net_connection_id}\" static #{ip} #{netmask}"
        @communicator.execute(netsh)
      end

      # Sets all networks on the guest to 'Work Network' mode. This is
      # to allow guest access from the host via a private IP on Win7
      # https://github.com/WinRb/vagrant-windows/issues/63
      def set_all_networks_to_work
        @logger.info("Setting all networks to 'Work Network'")
        
        cmd = <<-EOH            
          # Get network connections
          $networkListManager = [Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]"{DCB00C01-570F-4A9B-8D69-199FDBA5723B}"))
          $connections = $networkListManager.GetNetworkConnections()

          # Set network location to Private for all networks
          $connections | % {$_.GetNetwork().SetCategory(1)}
        EOH
        
        @communicator.execute(Util::CapHelpers.wrap_powershell(cmd))
      end
    end
  end
end
