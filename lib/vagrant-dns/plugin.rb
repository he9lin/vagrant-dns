begin
  require "vagrant"
rescue LoadError
  raise "The Vagrant DNS plugin must be run within Vagrant."
end

# This is a sanity check to make sure no one is attempting to install
# this into an early Vagrant version.
if Vagrant::VERSION < "1.1.0"
  raise "The Vagrant DNS plugin is only compatible with Vagrant 1.1+"
end

module VagrantPlugins
  module DNS
    class Plugin < ::Vagrant.plugin("2")
      class << self
        def provision(hook)
          hook.before ::Vagrant::Action::Builtin::ConfigValidate, Action.setup
          # hook.after  ::Vagrant::Action::Builtin::Provision,      Action.start
        end
      end

      name "rubydns-vagrant"

      action_hook(:rubydns_provision, :machine_action_up,        &method(:provision))
      action_hook(:rubydns_provision, :machine_action_provision, &method(:provision))
      # action_hook(:rubydns_cleanup,   :machine_action_destroy) do |hook|
      #   # @todo this should be appended to the middleware stack instead of hooked
      #   # in after the Virtualbox specific destroy step but there is a bug in
      #   # Vagrant (1.1.0) which causes appended middleware to run multiple times.
      #   hook.after(
      #     VagrantPlugins::ProviderVirtualBox::Action::DestroyUnusedNetworkInterfaces,
      #     RubyDNS::Vagrant::Action.clean)
      # end
      config(:berkshelf) do
        require_relative "config"
        Config
      end
    end
  end
end
