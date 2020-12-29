$ignore_lines = [",", "Installed", "Vulnerable"]

$vulnerable_packages = []

$detections_list = node.normal.to_hash()["HOST_LIST_VM_DETECTION_OUTPUT"]["RESPONSE"]["HOST_LIST"]["HOST"]

# List of the packages required version that are need to be updated
def get_packages_list(detections)
  detections.each do |detection|
    if detection["SEVERITY"].to_i >= node.default["qualys"]["severity_level"]
      packages = detection["RESULTS"].split("\n")
      packages.each do |pkgs|
        unless (pkgs.length==0) || (pkgs.match? Regexp.union($ignore_lines))
          pkg = pkgs.split(" ").select { |p| p.length>0 }
          pkg_name = pkg[0]
          pkg_installed_version = pkg[1]
          pkg_required_version = pkg[2]
          $vulnerable_packages.push([pkg_name, pkg_required_version])
          log("Package name: #{pkg_name}, Installed version: #{pkg_installed_version}, Required version: #{pkg_required_version}")
        end
      end
    end
  end
end

begin
  $detections_list.each do |detections|
    detections = detections["DETECTION_LIST"]["DETECTION"]
    get_packages_list detections
  end
rescue
  detections = $detections_list["DETECTION_LIST"]["DETECTION"]
  get_packages_list detections
end

# Update the packages
$vulnerable_packages.each do |pkg|
  pkg_name = pkg[0]
  pkg_required_version = pkg[1]

  log("Installing package #{pkg_name} version: #{pkg_required_version}")

  begin
    yum_package pkg_name do
      flush_cache [:before]
      package_name pkg_name
      version pkg_required_version
      action :install
      ignore_failure :quiet
    end
    yum_package pkg_name do
      flush_cache [:before]
      package_name pkg_name
      action :upgrade
      ignore_failure :quiet
    end
  rescue
    bash 'skip-broken' do
      code <<-EOH
        yum install --skip-broken #{pkg_name}-#{pkg_required_version}
      EOH
    end
  end
end

# Attributes clean-up
node.normal["HOST_LIST_VM_DETECTION_OUTPUT"] = {}
