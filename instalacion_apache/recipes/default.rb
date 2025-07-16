#
# Cookbook:: instalacion_apache
# Recipe:: default
#
# Copyright:: 2025, The Authors, All Rights Reserved.
#
#

apt_package 'apache2' do
  action :install
end

service 'apache2' do
  action [:enable, :start]
end

file '/var/www/html/index.html' do
  content '<html>
 	      <body>
   	      <h1>Hello from Chef on <%= node[:platform] %></h1>
 	      </body>
          </html>'
  mode '0644'
end

