module VagrantPlugins
  module DNS
    class Config < ::Vagrant.plugin("2", :config)
      # config.dns.tld = "dev"
      # config.dns.tlds = ["dev", "dom"]
      #
      def tld=(tlds)
        @tlds = Array(tlds)
      end
      alias :tlds= :tld=

      attr_reader :tlds

      # config.dns.patterns = [/^.*promojam.dev$/, /^.*coca-cola.dev$/]
      #
      attr_accessor :patterns
    end
  end
end
