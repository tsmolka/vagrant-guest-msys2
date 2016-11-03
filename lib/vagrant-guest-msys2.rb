require "vagrant-guest-msys2/plugin"

module VagrantPlugins
  module GuestMSYS2
    lib_path = Pathname.new(File.expand_path('../vagrant-guest-msys2', __FILE__))
    autoload :Errors, lib_path.join('errors')
    
    # This returns the path to the source of this plugin.
    #
    # @return [Pathname]
    def self.source_root
      @source_root ||= Pathname.new(File.expand_path('../../', __FILE__))
    end
  end
end
