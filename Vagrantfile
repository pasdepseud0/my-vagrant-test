# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"

  # Spécifier l'adresse IP
  config.vm.network "public_network", ip: "IP"

  config.vm.provider "vmware_desktop" do |v|
    v.cpus = 2
    v.memory = 2048
  end

  # Provisionner Docker
  config.vm.provision "docker" do |d|
    d.pull_images "nginx:latest"
  end

  # Rendre le script provision.sh exécutable et l'exécuter
  config.vm.provision "shell", inline: <<-SHELL
    chmod +x /vagrant/provision.sh
    /vagrant/provision.sh
  SHELL
end
