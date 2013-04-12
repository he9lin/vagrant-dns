module VagrantPlugins
  module DNS
    module Action
      class SetupEnv
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:dns].tmp_path    = File.join(env[:tmp_path], DNS.namespace)
          env[:dns].daemon_path = File.join(env[:dns].tmp_path, "daemon")
          env[:dns].config_file = File.join(env[:dns].tmp_path, "config")
          env[:dns].dns_server  = DNSServer.new \
                                    dir:    env[:dns].daemon_path,
                                    config: env[:dns].config_file

          @app.call(env)
        end
      end
    end
  end
end
