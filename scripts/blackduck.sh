#!/bin/bash

set -e

# Function to install JRE
install_jre() {


JRE_VERSION="21.0.5" # You can change this to the desired version
JRE_TAR="sapmachine-jre-${JRE_VERSION}_linux-x64_bin.tar.gz"
# resolves to https://github.com/SAP/SapMachine/releases/download/sapmachine-21.0.5/sapmachine-jre-21.0.5_linux-x64_bin.tar.gz
JRE_URL="https://github.com/SAP/SapMachine/releases/download/sapmachine-$JRE_VERSION/$JRE_TAR"
echo "Downloading and installing sapmachine at ... " $JRE_URL

wget $JRE_URL
tar -xzf $JRE_TAR
rm $JRE_TAR

ls -lah

export JAVA_HOME=$(pwd)/sapmachine-jre-21.0.5
export PATH=$JAVA_HOME/bin:$PATH

ls -lah $JAVA_HOME

# echo "Installing Java Runtime Environment..."
# sudo apt-get update
# sudo apt-get install -y openjdk-11-jre

echo "Java installation completed."
$JAVA_HOME/bin/java -version
}

# Function to download the Black Duck Detect script
download_detect_tool() {
echo "Downloading Black Duck Detect tool..."
DETECT_URL="https://detect.synopsys.com/detect9.sh" # Official Detect download URL
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
