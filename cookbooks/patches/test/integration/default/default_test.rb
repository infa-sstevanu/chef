# InSpec test for recipe nginx::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec/resources/

describe command('grep -nr "* hard core 0" /etc/security/limits.conf') do
  its('exit_status') { should eq 0 }
end
