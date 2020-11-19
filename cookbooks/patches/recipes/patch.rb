include_recipe 'base-config::setlocale'
include_recipe 'base-pkg::install'

node_hash = node.normal.to_hash
detections = node_hash["HOST_LIST_VM_DETECTION_OUTPUT"]["RESPONSE"]["HOST_LIST"]["HOST"]["DETECTION_LIST"]["DETECTION"]
severity_level = node_hash["qualys"]["severity_level"]

detections.each do |detection|
  if detection["SEVERITY"].to_i >= severity_level.to_i
    log detection["RESULTS"]
  end
end
