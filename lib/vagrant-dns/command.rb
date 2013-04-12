module VagrantPlugins
  module DNS
    class Command < ::Vagrant.plugin("2", :command)
      INSTALL_PATH = "/etc/resolver".freeze

      def execute
        tmp_dns_path = File.join @env.tmp_path, DNS.namespace
        options      = {}

        opts = OptionParser.new do |o|
          o.banner = "Usage: vagrant destroy [vm-name]"
          o.separator ""

          o.on("-f", "--install", "Install dns resolver on mac.") do |f|
            begin
              if File.directory?(INSTALL_PATH)
                @env.ui.info "Existed install dir #{INSTALL_PATH}"
              else
                @env.ui.info "Creating install dir #{INSTALL_PATH}"
                FileUtils.mkdir_p(INSTALL_PATH)
              end

              registered_resolvers = Dir[File.join(tmp_dns_path, "resolver", "*")]

              @env.ui.info "Installing DNS resolvers #{registered_resolvers} to #{INSTALL_PATH}"

              FileUtils.ln_s(registered_resolvers, INSTALL_PATH, force: true)

            rescue Errno::EACCES => e
              @env.ui.error "vagrant-dns needs superuser access to manipulate DNS settings"
              @env.ui.error "DNS resolvers not installed"

            rescue Errno::EEXIST => e
              @env.ui.error "#{INSTALL_PATH} exists. Please remove it first to force override"
            end
          end
        end

        # Parse the options
        argv = parse_options(opts)
      end
    end
  end
end
