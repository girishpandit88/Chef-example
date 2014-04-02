# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
 

  config.vm.hostname = "myface-berkshelf"
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.network :private_network, ip: "33.33.33.10"
  config.omnibus.chef_version = :latest

  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      :mysql => {
        :server_root_password => 'rootpass',
        :server_debian_password => 'debpass',
        :server_repl_password => 'replpass'
      }
    }

    chef.run_list = [
        "recipe[myface::default]"
    ]
  end
end
