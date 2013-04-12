require "vagrant-dns/dns_server"

module VagrantPlugins
  module DNS
    module Action
      class StartDNSServer
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:dns].ui.info "Restarting dns server..."
          env[:dns].dns_server.restart!

          @app.call(env)
        end
      end
    end
  end
end
