Vagrant.configure("2") do |config|

  config.vm.define "master" do |centos_master|
    centos_master.vm.box = "bento/centos-7.2"
    centos_master.vm.network "private_network", ip: "10.0.0.10"
    centos_master.vm.hostname = "master"
    centos_master.vm.network :forwarded_port, guest: 8080, host: 8080
    # centos_master.vm.network :forwarded_port, guest: 2379, host: 2379 
    centos_master.vm.provider "virtualbox" do |vb|      
      vb.memory = "2048"
      vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
    end
    centos_master.vm.provision "shell", inline: "nmcli connection reload; systemctl restart network.service"
  end

  config.vm.define "node1" do |centos_node1|
    centos_node1.vm.box = "bento/centos-7.2"
    centos_node1.vm.network "private_network", ip: "10.0.0.11"
    centos_node1.vm.hostname = "node1"        
    centos_node1.vm.provider "virtualbox" do |vb|      
      vb.memory = "2048"
      vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
    end
    centos_node1.vm.provision "shell", inline: "nmcli connection reload; systemctl restart network.service"
  end

  #config.vm.define "node2" do |centos_node2|
  #  centos_node2.vm.box = "bento/centos-7.2"
  #  centos_node2.vm.network "private_network", ip: "10.0.0.12"
  #  centos_node2.vm.hostname = "node2"
  #  centos_node2.vm.provider "virtualbox" do |vb|      
  #    vb.memory = "1024"
  #    vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
  #  end
  #  centos_node2.vm.provision "shell", inline: "nmcli connection reload; systemctl restart network.service"     
  #end
  
end
