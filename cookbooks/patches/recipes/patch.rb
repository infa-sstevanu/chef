# include_recipe 'base-config::setlocale'
# include_recipe 'base-pkg::install'

vulnerable_packages = []

detections = node.normal.to_hash()["HOST_LIST_VM_DETECTION_OUTPUT"]["RESPONSE"]["HOST_LIST"]["HOST"]["DETECTION_LIST"]["DETECTION"]

# List of the packages that are need to be patched
detections.each do |detection|
  if detection["SEVERITY"].to_i >= node.default["qualys"]["severity_level"]
    packages = detection["RESULTS"].split("\n")
    packages.each do |pkgs|
      unless pkgs.include?("Installed")
        pkg = pkgs.split(" ").select { |p| p.length>0 }
        vulnerable_packages.push([pkg[0], pkg[2]])
      end
    end
  end
end

vulnerable_packages.each do |pkg|
  # package pkg do
  #   action :install
  # end
  #log pkg
  pkg_name = pkg[0]
  pkg_version = pkg[2]

  yum_package pkg_name do
    flush_cache [:before]
    package_name pkg_name
    version pkg_version
    action :install
  end
end
