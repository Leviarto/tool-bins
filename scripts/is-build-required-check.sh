#!/bin/bash -e

### Arguments #################################################################

args=("$@")
TOOL_NAME="${args[0]}"
OS_NAME_WITH_VERSION="${args[1]}"
FILE_EXTENSION="${args[2]}"

### Functions #################################################################

source scripts/fn/gh.sh
source scripts/fn/tool.sh
source scripts/fn/general.sh
source scripts/fn/logging.sh

### Main ######################################################################

printH1 'Check if Build is Required'

gh auth status

declare -a releaseAssetNames=()
mapfile -t releaseAssetNames < <(ghReleaseAssetNames)
printH2 'Existing release assets:'
for name in "${releaseAssetNames[@]}"; do
  printInfo "${name}"
done

tagName=$(toolName="${TOOL_NAME}" toolTagName)
assetFilename=$( \
  toolName="${TOOL_NAME}" \
  tagName="${tagName}" \
  osNameWithVersion="${OS_NAME_WITH_VERSION}" \
  fileExtension="${FILE_EXTENSION}" \
  toolAssetFilename \
)
printH2 'New asset name:'
printInfo "${assetFilename}"

declare isReleaseAssetExists=$(haystackRef=releaseAssetNames needle="${assetFilename}" inStrArray)
declare isBuildRequired='false'
if [[ 'false' == "${isReleaseAssetExists}" ]] ; then
  isBuildRequired='true'
fi

printSuccess "isBuildRequired: ${isBuildRequired}"

# return
echo "IS_BUILD_REQUIRED=${isBuildRequired}" >> "$GITHUB_OUTPUT"
