# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

trusty_box = 'puppetlabs/ubuntu-14.04-64-nocm'

base_dir = File.dirname(__FILE__)

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  master_box = trusty_box
  master_name = 'vectrex-devbox'
  master_memory = '2048'

  config.vm.define master_name, primary: true do |master|

    # Every Vagrant development environment requires a box. You can search for
    # boxes at https://atlas.hashicorp.com/search.
    master.vm.box = master_box
    master.vm.hostname = master_name

    master.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", master_memory]
      v.name = master_name
    end

    master.vm.provider "vmware_fusion" do |v|
      v.vmx["memsize"] = master_memory
      v.name = master_name
    end


    master.vm.provision "shell", privileged: true, inline: <<-SHELL
      killall puppet
      usermod -G adm,sudo vagrant
    SHELL

    master.vm.provision "shell", privileged: true, inline: <<-SHELL
      apt-get update
      apt-get install gcc-multilib lib32stdc++6 dos2unix
    SHELL

    # Get puppet bootstrapped via shell, so that we can use a barer base image,
    # more reflecting our own deployment strategy.
    #
    master.vm.provision "shell", privileged: false, inline: <<-SHELL
      if [ -f /vagrant/vagrant/VIM_EDITING ]; then
        echo 'set editing-mode vi' > ~/.inputrc
      fi
    SHELL

  end

end
