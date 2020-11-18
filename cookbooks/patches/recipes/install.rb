include_recipe 'base-config::setlocale'
include_recipe 'base-pkg::install'

# Disable core dumps
execute 'disable_core_dumps' do
  command 'echo "* hard core 0" >> /etc/security/limits.conf'
end

execute 'disable_suid_dumpable' do
  command 'echo "fs.suid_dumpable = 0" >> /etc/sysctl.conf'
end
