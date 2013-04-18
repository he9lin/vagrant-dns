module VagrantPlugins
  module DNS
    module Action
      class CreateDaemonsDir
        def initialize(app, env)
          @app = app
        end

        def call(env)
          unless env[:machine].config.dns.enabled
            return @app.call(env)
          end

          daemon_path = env[:dns].daemon_path

          if File.directory?(daemon_path)
            env[:dns].ui.info "Existed daemons dir #{daemon_path}"
          else
            env[:dns].ui.info "Creating daemons dir #{daemon_path}"
            FileUtils.mkdir_p(daemon_path)
          end

          @app.call(env)
        end
      end
    end
  end
end
