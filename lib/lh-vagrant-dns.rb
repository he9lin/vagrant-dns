require "pathname"
require "vagrant-dns/plugin"

module VagrantPlugins
  module DNS
    lib_path = Pathname.new(File.expand_path("../vagrant-dns", __FILE__))

    autoload :Action, lib_path.join("action")
    # autoload :Errors, lib_path.join("errors")

    # This returns the path to the source of this plugin.
    #
    # @return [Pathname]
    def self.source_root
      @source_root ||= Pathname.new(File.expand_path("../../", __FILE__))
    end

    # Returns the default interfaces that a ruby dns server listens to.
    #
    # @return [Array]
    def self.listen
      @listen ||= [[:udp, "127.0.0.1", 5300]]
    end

    def self.namespace
      @namespace ||= "dns"
    end
  end
end
