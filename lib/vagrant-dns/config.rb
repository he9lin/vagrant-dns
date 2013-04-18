module VagrantPlugins
  module DNS
    class Config < ::Vagrant.plugin("2", :config)
      # Enable the use of this plugin
      #
      # @return [Boolean]
      attr_accessor :enabled

      # Configures DNS patterns
      #
      # Usage example:
      #
      #   config.dns.patterns = [/^.*promojam.dev$/, /^.*coca-cola.dev$/]
      #
      # @return [Array]
      attr_accessor :patterns

      # Configures tlds, taking an Array or a String as its argument.
      #
      # Usage example:
      #
      #   config.dns.tlds = ["dev", "dom"]
      #   config.dns.tld = "dev"
      #
      def tld=(tlds)
        @tlds = Array(tlds)
      end
      alias :tlds= :tld=

      # @return [Array]
      attr_reader :tlds

      def initialize
        super

        @enabled = false
      end

    end
  end
end
