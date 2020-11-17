include_recipe 'base-config::setlocale'

package 'epel-release' do
  action :install
end

package 'nginx' do
  action :install
end

bash 'test_file' do
  code <<-EOH
    echo "test file" > /home/vagrant/test_file.txt
  EOH
end
