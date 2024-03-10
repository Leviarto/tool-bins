#!/bin/bash -e

### Arguments #################################################################

args=("$@")
TOOL_NAME="${args[0]}"
OS_NAME_WITH_VERSION="${args[1]}"
FILE_EXTENSION="${args[2]}"

### Functions #################################################################

source scripts/fn/gh.sh
source scripts/fn/tool.sh
source scripts/fn/logging.sh

### Main ######################################################################

printH1 'Upload Build as Release Asset'

gh auth status

tagName=$(toolName="${TOOL_NAME}" toolTagName)
assetFilename=$( \
  toolName="${TOOL_NAME}" \
  tagName="${tagName}" \
  osNameWithVersion="${OS_NAME_WITH_VERSION}" \
  fileExtension="${FILE_EXTENSION}" \
  toolAssetFilename \
)

printH2 "Upload asset \"${assetFilename}\""
file="temp/${assetFilename}" ghReleaseUploadAsset

printSuccess "Finished uploading the release assets."
