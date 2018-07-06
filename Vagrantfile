$script = <<-SCRIPT
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose build
SCRIPT

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
#  config.vm.box = "ubuntu/xenial64"
  config.vm.box = "centos/7"
  config.vm.define "docker-machine" do |cfg|
    cfg.vm.provider :virtualbox do |vb, override|
      override.vm.network :private_network, ip: "192.168.33.10"
      override.vm.network "forwarded_port", guest: 5820, host: 5820
      override.vm.network "forwarded_port", guest: 5000, host: 5000
      override.vm.hostname = "docker-machine"
      vb.name = "docker-machine"
      vb.customize ["modifyvm", :id, "--memory", 4096, "--cpus", 1, "--hwvirtex", "on"]
    end # end provider
  end # end config
  
  config.vm.provision "docker",
    images: ["kmlchauhan/centos7-jdk8:1.10","clariah/brwsr:latest"]

  config.vm.provision "file", source: "~/docker/stardog", destination: "$HOME/stardog"
  config.vm.provision "shell", inline: $script

end
