require "vagrant-dns/dns_server"

module VagrantPlugins
  module DNS
    module Action
      class StopDNSServer
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:dns].ui.info "Stopping dns server..."
          env[:dns].dns_server.stop!

          @app.call(env)
        end
      end
    end
  end
end

