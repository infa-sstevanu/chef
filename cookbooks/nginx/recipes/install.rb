include_recipe 'base-config::setlocale'

package 'epel-release' do
  action :install
end

package 'nginx' do
  action :install
end

cookbook_file '/etc/nginx/conf.d/virtual_host.conf' do
  source 'virtual_host.conf'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

service 'nginx' do
  action :restart
end
