ignore_lines = [",", "Installed", "Vulnerable"]

vulnerable_packages = []

detections_list = node.normal.to_hash()["HOST_LIST_VM_DETECTION_OUTPUT"]["RESPONSE"]["HOST_LIST"]["HOST"]

# List of the packages that are needs to be patched
begin
  detections = detections_list["DETECTION_LIST"]["DETECTION"]
  detections.each do |detection|
    if detection["SEVERITY"].to_i >= node.default["qualys"]["severity_level"]
      packages = detection["RESULTS"].split("\n")
      packages.each do |pkgs|
        unless (pkgs.length==0) || (pkgs.match? Regexp.union(ignore_lines))
          pkg = pkgs.split(" ").select { |p| p.length>0 }
          vulnerable_packages.push([pkg[0], pkg[2]])
        end
      end
    end
  end  
rescue
  log(detections_list.length)
  detections_list.each do |detections|
    detections = detections["DETECTION_LIST"]["DETECTION"]
    detections.each do |detection|
      if detection["SEVERITY"].to_i >= node.default["qualys"]["severity_level"]
        packages = detection["RESULTS"].split("\n")
        packages.each do |pkgs|
          unless (pkgs.length==0) || (pkgs.match? Regexp.union(ignore_lines))
            pkg = pkgs.split(" ").select { |p| p.length>0 }
            vulnerable_packages.push([pkg[0], pkg[2]])
          end
        end
      end
    end
  end
end

# Update the packages
vulnerable_packages.each do |pkg|
  begin
    pkg_name = pkg[0]
    pkg_version = pkg[2]
    
    log(pkg)
    yum_package pkg_name do
      flush_cache [:before]
      package_name pkg_name
      version pkg_version
      action :install
    end
  rescue
  end
end

# Attributes clean-up
node.normal["HOST_LIST_VM_DETECTION_OUTPUT"] = {}
