require "pathname"
require "vagrant/action/builder"

module VagrantPlugins
  module DNS
    module Action
      class << self
        def setup
          @setup ||= ::Vagrant::Action::Builder.new.tap do |b|
            # b.use ::Vagrant::Action::Builtin::EnvSet, rubydns: RubyDNS::Vagrant::Env.new
            b.use RubyDNS::Vagrant::Action::SetResolvers
            # b.use RubyDNS::Vagrant::Action::SetDaemonEnv
            # b.use RubyDNS::Vagrant::Action::RegisterPatterns
            # b.use RubyDNS::Vagrant::Action::InstallResolvers
          end
        end
      end

      action_root = Pathname.new(File.expand_path("../action", __FILE__))
      autoload :CreateResolvers,  action_root.join("create_resolvers")
      # autoload :CreateDaemonDir,  action_root.join("create_daemon_dir")
      # autoload :RegisterPatterns, action_root.join("register_patterns")
      # autoload :InstallResolvers, action_root.join("install_resolvers")
      # autoload :StartDNSServer,   action_root.join("start_dns_server")
    end
  end
end
