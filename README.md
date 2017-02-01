# A Virtual Machine for Ruby on Rails Core Development

## Introduction

**Please note this VM is not designed for Rails application development, only Rails core development.**

This project automates the setup of a development environment for working on Ruby on Rails itself. Use this virtual machine to work on a pull request with everything ready to hack and run the test suites.

## Requirements

* [VirtualBox](https://www.virtualbox.org)

* [Vagrant](http://vagrantup.com)

* [Oracle Database Patch Set 12.1.0.2 for Linux x86-64](http://support.oracle.com)

* [OPatch 12.2.0.1.8](http://support.oracle.com)

* [COMBO OF OJVM COMPONENT 12.1.0.2.161018 DBPSU + DBPSU 12.1.0.2.161018 (OCT2016)](http://support.oracle.com)

* [Oracle Instant Cient for Linux x86-64 Instant Client Package - Basic](http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html)
* [Oracle Instant Cient for Linux x86-64 Instant Client Package - SQL\*Plus](http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html)

* [Oracle Instant Cient for Linux x86-64 Instant Client Package - Instant Client Package - SDK](http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html)

## How To Build The Virtual Machine

Building the virtual machine is this easy:

    host $ git clone -b runs_oracle_on_docker https://github.com/yahonda/rails-dev-box.git
    host $ cd rails-dev-box
    host $ cp /path/to/p17694377_121020_Linux-x86-64_1of8.zip .
    host $ cp /path/to/p17694377_121020_Linux-x86-64_2of8.zip .
    host $ cp /path/to/p6880880_121010_Linux-x86-64.zip .
    host $ cp /path/to/p24433133_121020_Linux-x86-64.zip .
    host $ cp /path/to/oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm .
    host $ cp /path/to/oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm .
    host $ cp /path/to/oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm .
    host $ vagrant up

That's it.

After the installation has finished, you can access the virtual machine with

    host $ vagrant ssh
    Welcome to Ubuntu 16.10 (GNU/Linux 4.8.0-26-generic x86_64)
    ...
    ubuntu@rails-dev-box:~$

Port 3000 in the host computer is forwarded to port 3000 in the virtual machine. Thus, applications running in the virtual machine can be accessed via localhost:3000 in the host computer. Be sure the web server is bound to the IP 0.0.0.0, instead of 127.0.0.1, so it can access all interfaces:

    bin/rails server -b 0.0.0.0

## What's In The Box

* Development tools

* Git

* Ruby 2.3

* Bundler

* SQLite3, MySQL, and Postgres

* Databases and users needed to run the Active Record test suite

* System dependencies for nokogiri, sqlite3, mysql, mysql2, and pg

* Memcached

* Redis

* RabbitMQ

* An ExecJS runtime

## Recommended Workflow

The recommended workflow is

* edit in the host computer and

* test within the virtual machine.

Just clone your Rails fork into the rails-dev-box directory on the host computer:

    host $ ls
    bootstrap.sh MIT-LICENSE README.md Vagrantfile
    host $ git clone git@github.com:<your username>/rails.git

Vagrant mounts that directory as _/vagrant_ within the virtual machine:

    ubuntu@rails-dev-box:~$ ls /vagrant
    bootstrap.sh MIT-LICENSE rails README.md Vagrantfile

Install gem dependencies in there:

    ubuntu@rails-dev-box:~$ cd /vagrant/rails
    ubuntu@rails-dev-box:/vagrant/rails$ bundle

We are ready to go to edit in the host, and test in the virtual machine.

This workflow is convenient because in the host computer you normally have your editor of choice fine-tuned, Git configured, and SSH keys in place.

## Virtual Machine Management

When done just log out with `^D` and suspend the virtual machine

    host $ vagrant suspend

then, resume to hack again

    host $ vagrant resume

Run

    host $ vagrant halt

to shutdown the virtual machine, and

    host $ vagrant up

to boot it again.

You can find out the state of a virtual machine anytime by invoking

    host $ vagrant status

Finally, to completely wipe the virtual machine from the disk **destroying all its contents**:

    host $ vagrant destroy # DANGER: all is gone

Please check the [Vagrant documentation](http://docs.vagrantup.com/v2/) for more information on Vagrant.

## Faster Rails test suites

The default mechanism for sharing folders is convenient and works out the box in
all Vagrant versions, but there are a couple of alternatives that are more
performant.

### rsync

Vagrant 1.5 implements a [sharing mechanism based on rsync](https://www.vagrantup.com/blog/feature-preview-vagrant-1-5-rsync.html)
that dramatically improves read/write because files are actually stored in the
guest. Just throw

    config.vm.synced_folder '.', '/vagrant', type: 'rsync'

to the _Vagrantfile_ and either rsync manually with

    vagrant rsync

or run

    vagrant rsync-auto

for automatic syncs. See the post linked above for details.

### NFS

If you're using Mac OS X or Linux you can increase the speed of Rails test suites with Vagrant's NFS synced folders.

With an NFS server installed (already installed on Mac OS X), add the following to the Vagrantfile:

    config.vm.synced_folder '.', '/vagrant', type: 'nfs'
    config.vm.network 'private_network', ip: '192.168.50.4' # ensure this is available

Then

    host $ vagrant up

Please check the Vagrant documentation on [NFS synced folders](http://docs.vagrantup.com/v2/synced-folders/nfs.html) for more information.

## Troubleshooting

On `vagrant up`, it's possible to get this error message:

```
The box 'ubuntu/yakkety64' could not be found or
could not be accessed in the remote catalog. If this is a private
box on HashiCorp's Atlas, please verify you're logged in via
vagrant login. Also, please double-check the name. The expanded
URL and error message are shown below:

URL: ["https://atlas.hashicorp.com/ubuntu/yakkety64"]
Error:
```

And a known work-around (https://github.com/Varying-Vagrant-Vagrants/VVV/issues/354) can be:

    sudo rm /opt/vagrant/embedded/bin/curl

## License

Released under the MIT License, Copyright (c) 2012–<i>ω</i> Xavier Noria.
