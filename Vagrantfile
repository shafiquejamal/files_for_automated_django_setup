# encoding: utf-8
# This file originally created at http://rove.io/0a2858f59327b8cfc1b3abae1dbcb00d

# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # config.vm.box = "opscode-ubuntu-12.04_chef-11.4.0"
  config.vm.box = "shafiquejamal/nginx-uwsgi-django_02April2014"
  # config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_chef-11.4.0.box"
  config.vm.box_url = "https://vagrantcloud.com/shafiquejamal/nginx-uwsgi-django_02April2014/version/1/provider/aws.box"

  config.vm.network :forwarded_port, host: 8000, guest: 80
  config.vm.network :forwarded_port, host: 8443, guest: 443
  config.ssh.forward_agent = true

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks"]
    chef.add_recipe :apt
    chef.add_recipe 'postgresql::server'
    chef.add_recipe 'nginx'
    chef.add_recipe 'python'
    chef.add_recipe 'git'
    chef.json = {
      :postgresql => {
        :config   => {
          :listen_addresses => "*",
          :port             => "5432"
        },
        :pg_hba   => [
          {
            :type   => "local",
            :db     => "postgres",
            :user   => "postgres",
            :addr   => nil,
            :method => "trust"
          },
          {
            :type   => "host",
            :db     => "all",
            :user   => "all",
            :addr   => "0.0.0.0/0",
            :method => "md5"
          },
          {
            :type   => "host",
            :db     => "all",
            :user   => "all",
            :addr   => "::1/0",
            :method => "md5"
          }
        ],
        :password => {
          :postgres => "password"
        }
      },
      :nginx      => {
        :dir                => "/etc/nginx",
        :log_dir            => "/var/log/nginx",
        :binary             => "/usr/sbin/nginx",
        :user               => "www-data",
        :init_style         => "runit",
        :pid                => "/var/run/nginx.pid",
        :worker_connections => "1024"
      },
      :git        => {
        :prefix => "/usr/local"
      }
    }
  end
end
