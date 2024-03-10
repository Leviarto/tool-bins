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

printH1 'Determine Old Assets and Delete Them'

gh auth status

printH2 "Configuration for \"${TOOL_NAME}\""
declare keepNBuilds=$(toolName="${TOOL_NAME}" toolKeepBuilds)
printInfo "- Keep ${keepNBuilds} builds."

declare -a assetNames=()
mapfile -t assetNames < <( \
  toolName="${TOOL_NAME}" osNameWithVersion="${OS_NAME_WITH_VERSION}" fileExtension="${FILE_EXTENSION}" \
  ghReleaseAssetsByNamePatternAsJson | jq --raw-output '.[].name' \
)
printH2 "Found ${#assetNames[@]} assets for \"${TOOL_NAME}\" on \"${OS_NAME_WITH_VERSION}\":"
for name in "${assetNames[@]}"; do
  printInfo "${name}"
done

declare -a trashAssets=("${assetNames[@]:keepNBuilds}")
printH2 "Trash ${#trashAssets[@]} assets:"
for name in "${trashAssets[@]}"; do
  printInfo "${name}"
  assetName="${name}" ghReleaseDeleteAssetByName
done

printSuccess "Finished cleaning up old assets."
