# A Virtual Machine for Ruby on Rails Core Development with Oracle Database

## Introduction

This project provides Oracle Database support on top of rails-dev-box. 

## Requirements

* [VirtualBox](https://www.virtualbox.org)

* [Vagrant 1.1+](http://vagrantup.com)

* VirtualBox needs support for 64-bit guests

## How To Build The Virtual Machine

Building the virtual machine is this easy:

* Download [Oracle Database 11g Express Edition](http://www.oracle.com/technetwork/products/express-edition/overview/index.html) for Linux x64. The file name is `oracle-xe-11.2.0-1.0.x86_64.rpm.zip`.

```sh
    host $ git clone https://github.com/yahonda/rails-dev-box-runs-oracle.git
    host $ cp oracle-xe-11.2.0-1.0.x86_64.rpm.zip rails-dev-box-runs-oracle/puppet/modules/oracle/files/.
    host $ cd rails-dev-box-runs-oracle
    host $ vagrant up
```

That's it.

After the installation has finished, you can access the virtual machine with:

```sh
    host $ vagrant ssh
    Welcome to Ubuntu 12.04 LTS (GNU/Linux 3.2.0-23-generic x86_64)
    ...
    vagrant@rails-dev-box:~$ sqlplus system/manager@localhost/XE
```

Port 3000 in the host computer is forwarded to port 3000 in the virtual machine. Thus, applications running in the virtual machine can be accessed via localhost:3000 in the host computer. 

Similarly, Oracle's default network listener port 1521 in the host computer is forwarded to port 1521 in the virtual machine. Oracle tools in the host computer can connect to the database in the virtual machine:

```sh
    host $ sqlplus system/manager@localhost/XE
```

## What's In The Box

* Everthing in [rails-dev-box](https://github.com/rails/rails-dev-box)

* Oracle Database 11g Express Edition

## How to clone Rails repositories and execute unit tests

Just clone your Rails fork in the very directory of the Rails development box in the host computer:

    host $ ls
    README.md   Vagrantfile puppet
    host $ git clone -b 3-2-stable https://github.com/rails/rails.git rails

Vagrant mounts that very directory as _/vagrant_ within the virtual machine:

    vagrant@rails-dev-box:~$ ls /vagrant
    puppet  rails  README.md  Vagrantfile

## Execute ActiveRecord 3.2 unit tests with Oracle enhanced adapter

Just execute as described steps below. 

    vagrant@rails-dev-box:~$ cd /vagrant/rails/activerecord
    vagrant@rails-dev-box:/vagrant/rails/activerecord$ bundle
    vagrant@rails-dev-box:/vagrant/rails/activerecord$ rake test_oracle

## How to clone the Oracle enhanced repository and execute unit tests

Clone the oracle-enhanced repository as you do Rails.

    host $ ls
    README.md   Vagrantfile puppet rails

    host $ git clone https://github.com/rsim/oracle-enhanced.git

    host $ ls
    oracle-enhanced README.md   Vagrantfile puppet rails

## Execute Oracle enhanced adapter unit tests with Rails 3.2.x

Just execute as described steps below. 

    vagrant@rails-dev-box:~$ cd /vagrant/oracle-enhanced
    vagrant@rails-dev-box:/vagrant/oracle-enhanced $ export RAILS_GEM_VERSION=3.2.14
    vagrant@rails-dev-box:/vagrant/oracle-enhanced$ bundle
    vagrant@rails-dev-box:/vagrant/oracle-enhanced$ rspec

## How about Rails 4.0?

Compared with Rails 3.2 tests, Rails 4 still have some failures. This is the reason why rails-dev-box-runs-oracle is there. Here are steps to execute unit tests with Rails 4. Enjoy!

## How to clone Rails repositories and execute unit tests

Just clone your Rails fork in the very directory of the Rails development box in the host computer:

    host $ ls
    README.md   Vagrantfile puppet
    host $ git clone -b 4-0-stable https://github.com/rails/rails.git rails
    host $ git clone https://github.com/rsim/oracle-enhanced.git

## Execute ActiveRecord 4 unit tests with Oracle enhanced adapter

Just execute as described steps below. 

    vagrant@rails-dev-box:~$ bundle config local.activerecord-oracle_enhanced-adapter /vagrant/oracle-enhanced
    vagrant@rails-dev-box:~$ bundle config disable_local_branch_check true
    vagrant@rails-dev-box:~$ cd /vagrant/oracle-enhanced
    vagrant@rails-dev-box:/vagrant/oracle-enhanced$ git checkout rails4
    vagrant@rails-dev-box:/vagrant/oracle-enhanced$ cd /vagrant/rails/activerecord
    vagrant@rails-dev-box:/vagrant/rails/activerecord$ bundle
    vagrant@rails-dev-box:/vagrant/rails/activerecord$ rake test_oracle

## How to execute Oracle enhanced adapter unit tests with Rails 4.0.0

Just execute as described steps below. 

    vagrant@rails-dev-box:~$ cd /vagrant/oracle-enhanced
    vagrant@rails-dev-box:/vagrant/oracle-enhanced $ export RAILS_GEM_VERSION=4.0.0
    vagrant@rails-dev-box:/vagrant/oracle-enhanced$ bundle
    vagrant@rails-dev-box:/vagrant/oracle-enhanced$ rspec

## Notes

If your host is behind a firewall and 'vagrant up' gets errors running apt-get or installing RVM, then create ~/.vagrant.d/Vagrantfile to update the virtual machine's proxy settings:

```sh
    # ~/.vagrant.d/Vagrantfile
    Vagrant.configure('2') do |config|
      config.vm.provision :shell, :inline => "echo 'Acquire::http::proxy \"http://proxy.example.com:80/\";' >> /etc/apt/apt.conf"
      config.vm.provision :shell, :inline => "echo 'Acquire::https::proxy \"http://proxy.example.com:80/\";' >> /etc/apt/apt.conf"
      config.vm.provision :shell, :inline => "echo 'export http_proxy=http://proxy.example.com:80/' > /etc/profile.d/vagrant_proxy.sh"
      config.vm.provision :shell, :inline => "echo 'export https_proxy=http://proxy.example.com:80/' >> /etc/profile.d/vagrant_proxy.sh"
    end
```

Change the proxy name and port to be your network's proxy.

## Acknowledgements

This project is based on [rails-dev-box](https://github.com/rails/rails-dev-box) 
and [vagrant-ubuntu-oracle-xe](https://github.com/hilverd/vagrant-ubuntu-oracle-xe).

Thanks to everyone who contributes to these projects.

## Questions

Please email me yasuo.honda@gmail.com

