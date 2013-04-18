module VagrantPlugins
  module DNS
    module Action
      # Write dns patterns to ~/.vagrant.d/dns/config file.
      class RegisterPatterns
        def initialize(app, env)
          @app = app
        end

        def call(env)
          unless env[:machine].config.dns.enabled
            return @app.call(env)
          end

          config_file = env[:dns].config_file
          registry    = File.exists?(config_file) ? \
                          YAML.load(File.read(config_file)) : {}
          opts        = prepare_opts(env[:machine].config)
          patterns    = opts[:patterns] || default_patterns(opts)
          networks    = opts[:networks].select { |i| i[0] == :private_network }
                                       .flatten

          ip = networks.empty? ? '127.0.0.1' : networks[1][:ip]

          patterns.each do |p|
            p = p.source if p.respond_to? :source # Regexp#to_s is unusable
            registry[p] = ip
          end

          env[:dns].ui.info "Registering patterns #{registry}"

          File.open(config_file, "w") { |f| f << YAML.dump(registry) }

          @app.call(env)
        end

        private

        def prepare_opts(config)
          {
            tlds:      config.dns.tlds,
            patterns:  config.dns.patterns,
            host_name: config.vm.hostname,
            networks:  config.vm.networks
          }
        end

        def default_patterns(opts)
          if opts[:host_name]
            opts[:tlds].map { |tld| /^.*#{opts[:host_name]}.#{tld}$/ }
          else
            env[:dns].ui.warn 'TLD but no host_name given. No patterns will \
                               be configured.'
            []
          end
        end
      end
    end
  end
end
