# InSpec test for recipe nginx::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec/resources/

describe package('nginx') do
  it { should be_installed }
end

describe port(80) do
  it { should be_listening }
end

describe file('/etc/nginx/conf.d/virtual_host.conf') do
  it { should exist }
end

describe http('http://127.0.0.1') do
  its('status') { should cmp 200 }
end

describe http('http://127.0.0.1',
              method: 'GET',
              headers: {'Host' => 'some.domain.local'}) do
  its('status') { should cmp 502 }
end
