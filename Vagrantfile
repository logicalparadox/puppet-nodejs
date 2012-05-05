# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "ubuntu-12.04"
  config.vm.host_name = 'nodejs'
  config.vm.share_folder "nodejs", "/tmp/vagrant-puppet/modules/nodejs", "."
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "test"
    puppet.manifest_file = "vagrant.pp"
    puppet.options = ["--modulepath", "/tmp/vagrant-puppet/modules"]
  end
end
