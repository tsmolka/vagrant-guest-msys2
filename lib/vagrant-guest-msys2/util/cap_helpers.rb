module VagrantPlugins
  module GuestMSYS2
    module Util
      module CapHelpers
        def self.wrap_powershell(script)
          wrapped = <<-EOH.gsub(/^ {12}/, '')
            cat << 'EOF' | powershell -InputFormat none -Command - 
            #{script}
            EOF
          EOH
          wrapped
        end
      end
    end
  end
end
