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
          hook.after  ::Vagrant::Action::Builtin::Provision,      Action.start
        end
      end

      name "vagrant-dns"

      action_hook(:rubydns_provision, :machine_action_up,        &method(:provision))
      action_hook(:rubydns_provision, :machine_action_provision, &method(:provision))
      action_hook(:rubydns_cleanup,   :machine_action_halt) do |hook|
        hook.after(::Vagrant::Action::Builtin::GracefulHalt,
          VagrantPlugins::DNS::Action.clean)
      end

      config(:dns) do
        require_relative "config"
        Config
      end

      command(:dns) do
        require_relative "command"
        Command
      end
    end
  end
end
