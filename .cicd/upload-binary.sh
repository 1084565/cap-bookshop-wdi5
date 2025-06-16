#!/bin/bash
set -euo pipefail

# Set variables
JFROG_CLI_URL="https://releases.jfrog.io/artifactory/jfrog-cli/v2-jf/2.77.0/jfrog-cli-linux-amd64/jf"
JFROG_CLI_PATH="./jfrog"
ARTIFACTORY_URL="https://int.repositories.cloud.sap"
REPO="your-repo"
ARTIFACT_PATH="path/to/artifact"
ARTIFACT_NAME="your-artifact.tar.gz"
CONFIG_NAME="my-artifactory"
USERNAME="${JF_USER}"
PASSWORD="${JF_PASSWORD}"

# Download JFrog CLI
echo "Downloading JFrog CLI..."
curl -L $JFROG_CLI_URL -o $JFROG_CLI_PATH

# Make the JFrog CLI executable
echo "Setting up JFrog CLI..."
chmod +x $JFROG_CLI_PATH

# Verify the installation
if [ -x $JFROG_CLI_PATH ]; then
    echo "JFrog CLI installation verified."
else
    echo "JFrog CLI installation failed."
    exit 1
fi

# Configure JFrog CLI with Artifactory credentials
echo "Configuring JFrog CLI..."
$JFROG_CLI_PATH config add $CONFIG_NAME --artifactory-url=$ARTIFACTORY_URL --user=$USERNAME --password=$PASSWORD

# Upload the artifact
echo "Uploading artifact..."
$JFROG_CLI_PATH rt u $ARTIFACT_PATH $REPO/$ARTIFACT_NAME --config=$CONFIG_NAME

# Check upload status
if [ $? -eq 0 ]; then
  echo "Upload successful"
else
  echo "Upload failed"
  exit 1
fi
