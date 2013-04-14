module VagrantPlugins
  module DNS
    class DNSServer
      def initialize(options)
        @config  = options.fetch(:config) { raise "" }
        @dir     = options.fetch(:dir) { raise "" }
        @log_dir = options.fetch(:dir, @dir)

        @run_options = {
          dir_mode: :normal,
          dir: @dir,
          log_output: true,
          log_dir: @log_dir,
        }
      end

      def start!
        run! @run_options.merge ARGV: ["start"]
      end

      def stop!
        run! @run_options.merge ARGV: ["stop"]
      end

      def run!(run_options)
        require "daemons"

        Daemons.run_proc("vagrant-dns", run_options) do
          require 'rubydns'
          require 'rubydns/system'

          # Here the registry file has been created, so we can read it and
          # respond!
          registry = YAML.load(File.read(@config))
          std_resolver = RubyDNS::Resolver.new(RubyDNS::System::nameservers)

          RubyDNS::run_server(listen: VagrantPlugins::DNS.listen) do
            registry.each do |pattern, ip|
              match(Regexp.new(pattern), Resolv::DNS::Resource::IN::A) \
                do |transaction, match_data|
                  transaction.respond!(ip)
                end
            end

            otherwise do |transaction|
              transaction.passthrough!(std_resolver) do |reply, reply_name|
                puts reply
                puts reply_name
              end
            end
          end
        end
      end

      def restart!
        stop!
        start!
      end
    end
  end
end
