packages = ["epel-release", "git", "unzip", "zip"]
packages.each do |pkg|
  package pkg do
    action :install
  end
end
