module VagrantPlugins
  module DNS
    # Environment data to build up and persist through the middleware chain
    class Env

      # Returns a scoped vagrant ui
      #
      # @return [Vagrant::UI::Interface]
      attr_accessor :ui

      # Returns the tmp path for this plugin.
      #
      # @return [Pathname]
      attr_accessor :tmp_path

      attr_accessor :daemon_path

      attr_accessor :config_file

      attr_accessor :dns_server

      def initialize
        @ui = ::Vagrant::UI::Colored.new("dns")
      end

      def tmp_path
        @tmp_path || raise("@tmp_path has not been set")
      end
    end
  end
end
