# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'
MASTERS = 3
SUBNET = '192.168.42'


Vagrant.require_version '>= 1.5.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  # If this value is a shorthand to a box in Vagrant Cloud then
  # config.vm.box_url doesn't need to be specified.
  config.vm.box = 'ubuntu/trusty64'
  base_ip = "#{SUBNET}.1"
  master_ips = MASTERS.times.collect { |n| base_ip + "#{n}" }
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  #config.omnibus.chef_version = 'latest'
  config.berkshelf.enabled = true
  config.cache.auto_detect = true
  #config.berkshelf.berksfile_path = "./cookbooks/mdc_deployer/Berksfile"
  
  config.chef_zero.enabled = true
  config.chef_zero.chef_repo_path = '.'
  
  local_ip = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address
  
  
  (0..MASTERS - 1).each do |i|
    config.vm.define "mesos-master#{i}" do |master|
      master.vm.hostname = "mesos-master#{i}"
      master_ip = master_ips[i]
      master.vm.network "private_network", ip: "#{master_ip}"
      master.vm.provider :virtualbox do |vb|
        vb.customize ['modifyvm', :id, '--memory', '2048']
        (0..1).each do |d|
          vb.customize ['createhd',
                  '--filename', "disk-#{i}-#{d}",
                  '--size', '8000']
          vb.customize ['storageattach', :id,
                        '--storagectl', 'SATAController',
                        '--port', 3 + d,
                        '--device', 0,
                        '--type', 'hdd',
                        '--medium', "disk-#{i}-#{d}.vdi"]
        end
      end
      master.vm.provision "hostmanager"
      master.vm.provision "shell", inline: "sed -ri 's/^127\..\+mesos-master#{i}//g' /etc/hosts"

      master.vm.provision "shell", inline: "dpkg -i /vagrant/tmp/chef-latest_amd64.deb"

      master.vm.provision :chef_client do |chef|
        chef.chef_server_url = "http://192.168.42.1:8889"
        chef.validation_key_path = '.chef/test.pem'
        chef.environment = 'mdc_cluster'
        
        chef.provisioning_path = '/etc/chef'
        #chef.arguments = '-L /var/log/vagrant_run.log'
        chef.attempts = 2
        
        chef.add_recipe('ntp')
        chef.add_role('ceph-mon')
        chef.add_role('ceph-osd')
        chef.add_role('ceph-mds')
        chef.add_role('ceph-radosgw')
        chef.add_recipe('ceph::cephfs')
        chef.add_role('mesos-master')
        chef.add_role('mesos-slave')
        chef.add_recipe('mesos::marathon')
      end    
    end
  end
end
