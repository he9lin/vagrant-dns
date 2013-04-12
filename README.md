# Vagrant dns plugin

A Vagrant **1.1.x** plugin to manage DNS records on **Mac systems**. It is
heavily based on https://github.com/BerlinVagrant/vagrant-dns (which doesn't
seem to support Vagrant 1.1.x currently), so credit goes to the author of that
lib.

## TODOs

* Add specs
* Add config validation
* Add DNS resolver uninstall command
* Add Vagrant destroy action hook to clean dns tmp path

## Installation

It is only used as a plugin for Vagrant, so to install:

    $ vagrant plugin install lh-vagrant-dns

## Usage

    Vagrant.configure("2") do |config|

      # Configure DNS tlds
      config.dns.tld = "dev"
      # or config.dns.tlds = ["dev", "stag"]

      # This will be used to construct dns patterns, unless if
      # config.dns.patterns option is explicity defined. Otherwise, given tld
      # to be 'dev', we would get DNS pattern /^.*machine.dev$/
      config.vm.hostname = "machine"

      config.dns.patterns = [/^.*mysite.dev$/, /^.*myothersite.dev$/]

      config.vm.network :private_network, ip: "33.33.33.100"
    end

After `vagrant up`, install DNS resolver on mac:

    $ sudo vagrant dns --install

Now, `vagrant halt` stops a DNS server, while `vagrant up` or `vagrant provision`
starts a DNS server.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
