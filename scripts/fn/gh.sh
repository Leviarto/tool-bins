###############################################################################
## GitHub Functions
## ============================================================================
## Functions which utilize the github api through gh.
## All functions use the hardcoded repo 'leviarto/media-tools-bin' with release tag 'v1.0.0' for now.
###############################################################################

#
# Explicit GitHub CLI login with provided token.
#
# Arguments (positional):
#   • $1 (token) - The github token.
#
ghLogin() {
  local token="${1}"
  echo "${token}" | gh auth login --with-token
}

#
# Fetch the filenames of all release assets.
#
# Output:
#   Writes one filename per line.
#
ghReleaseAssetNames() {
  gh release view 'v1.0.0' -R 'leviarto/media-tools-bin' --json 'id,name,tagName,url,apiUrl,uploadUrl,assets' |
  jq --raw-output '.assets[]? | .name'
}

#
# Make regex to test for asset filename match.
#
# Arguments:
#   • toolName - Tool name which becomes a part of the regex.
#   • osNameWithVersion - OS name which becomes a part of the regex.
#   • fileExtension - File extension which becomes a part of the regex.
#
# Output:
#   Regex to test for the asset filename.
#
ghReleaseAssetTestRegEx() {
  local assetFilenameTestRegEx=$(cat tools/config.json | jq --raw-output '.assetFilenameTestRegEx')

  printf $assetFilenameTestRegEx | \
    tool=${toolName} \
    os=${osNameWithVersion} \
    ext=${fileExtension} \
    envsubst
}

#
# Fetch asset information objects, filtered by arguments and sorted descending by name.
#
# Arguments:
#   • toolName - Tool name which becomes a part of the asset file name filter.
#   • osNameWithVersion - OS name which becomes a part of the asset file name filter.
#   • fileExtension - File extension which becomes a part of the asset file name filter.
#
# Output:
#   Formatted JSON array of objects with asset information.
#
ghReleaseAssetsByNamePatternAsJson() {
  local testRegEx=$(ghReleaseAssetTestRegEx)  # arguments are inherited
  testRegEx=${testRegEx//\\/\\\\}  # double escape backslashes for jq filter regex
  gh release view 'v1.0.0' -R 'leviarto/media-tools-bin' --json 'id,name,tagName,url,apiUrl,uploadUrl,assets' |
  jq '.assets? | sort_by(.name) | reverse' |
  jq "map(select(.name | test(\"^${testRegEx}\$\")?))"
}

#
# Delete release asset by name.
#
# Arguments:
#   • assetName - The asset name to select the asset to delete.
#
ghReleaseDeleteAssetByName() {
  gh release delete-asset 'v1.0.0' "${assetName}" -R 'leviarto/media-tools-bin' --yes
}

#
# Upload release asset.
#
# Arguments:
#   • file - The file to upload as asset. Existing assets with same filename will be replaced by this one.
#
ghReleaseUploadAsset() {
  gh release upload 'v1.0.0' "${file}" -R 'leviarto/media-tools-bin' --clobber
}
