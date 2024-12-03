#!/bin/bash

set -e

# Function to install JRE
install_jre() {
echo "Installing Java Runtime Environment..."
sudo apt-get update
sudo apt-get install -y openjdk-11-jre
echo "Java installation completed."
java -version
}

# Function to download the Black Duck Detect script
download_detect_tool() {
echo "Downloading Black Duck Detect tool..."
DETECT_URL="https://detect.synopsys.com/detect.sh" # Official Detect download URL
wget $DETECT_URL -O detect.sh
chmod +x detect.sh
echo "Black Duck Detect tool downloaded."
}

# Function to run Black Duck scan
run_blackduck_scan() {
echo "Running Black Duck scan..."
./detect.sh --blackduck.url="https://your-blackduck-server" --blackduck.api.token="YOUR_API_TOKEN" --detect.project.name="your-project-name" --detect.project.version.name="your-version-name"
echo "Black Duck scan completed."
}

# Main script execution
install_jre
download_detect_tool
run_blackduck_scan
