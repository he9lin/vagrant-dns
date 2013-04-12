require "pathname"
require "vagrant/action/builder"

require_relative "env"

module VagrantPlugins
  module DNS
    module Action
      class << self
        def setup
          @setup ||= ::Vagrant::Action::Builder.new.tap do |b|
            b.use ::Vagrant::Action::Builtin::EnvSet, dns: VagrantPlugins::DNS::Env.new
            b.use SetupEnv
            b.use CreateResolvers
            b.use CreateDaemonsDir
            b.use RegisterPatterns
          end
        end

        def clean
          @clean ||= ::Vagrant::Action::Builder.new.tap do |b|
            b.use ::Vagrant::Action::Builtin::EnvSet, dns: VagrantPlugins::DNS::Env.new
            b.use SetupEnv
            b.use StopDNSServer
          end
        end

        def start
          @start ||= ::Vagrant::Action::Builder.new.tap do |b|
            b.use ::Vagrant::Action::Builtin::EnvSet, dns: VagrantPlugins::DNS::Env.new
            b.use SetupEnv
            b.use StartDNSServer
          end
        end
      end

      action_root = Pathname.new(File.expand_path("../action", __FILE__))
      autoload :SetupEnv,         action_root.join("setup_env")
      autoload :CreateResolvers,  action_root.join("create_resolvers")
      autoload :CreateDaemonsDir, action_root.join("create_daemons_dir")
      autoload :RegisterPatterns, action_root.join("register_patterns")
      autoload :StartDNSServer,   action_root.join("start_dns_server")
      autoload :StopDNSServer,    action_root.join("stop_dns_server")
    end
  end
end
