bash 'setlocale' do
  code <<-EOH
    echo "LANG=en_US.utf-8" >> /etc/environment
    echo "LC_ALL=en_US.utf-8" >> /etc/environment
  EOH
end
