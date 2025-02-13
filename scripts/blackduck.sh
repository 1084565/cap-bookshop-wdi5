#!/bin/bash
set -eu

# Runs Black Duck scan in current directory after downloading java 
# and synosys detect script.

JRE_VERSION="21.0.5" 
JRE_TAR="sapmachine-jre-${JRE_VERSION}_linux-x64_bin.tar.gz"
JRE_URL="https://github.com/SAP/SapMachine/releases/download/sapmachine-$JRE_VERSION/$JRE_TAR"

DETECT_URL="https://detect.blackduck.com/detect10.sh" # Official Detect download URL

install_jre() {
  echo "Downloading and installing sapmachine from " $JRE_URL
  
  wget --quiet $JRE_URL
  tar -xzf $JRE_TAR

  export JAVA_HOME=$(pwd)/sapmachine-jre-${JRE_VERSION}
  $JAVA_HOME/bin/java -version

  echo "Java installation complete."
}

download_detect_tool() {
  echo "Downloading Black Duck Detect tool from " $DETECT_URL

  wget --quiet $DETECT_URL -O detect.sh
  chmod +x detect.sh
  
  echo "Black Duck Detect tool download complete."
}

run_blackduck_scan() {
  echo "Running Black Duck scan..."

  ./detect.sh --blackduck.url="$BD_SERVER" --blackduck.api.token="$BD_API_TOKEN" --detect.project.name="$BD_PROJECT_NAME" --detect.project.version.name="$BD_PROJECT_VERSION"
  echo "Black Duck scan completed."
}

# Main script execution
install_jre
download_detect_tool
run_blackduck_scan
