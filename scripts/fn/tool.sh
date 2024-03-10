###############################################################################
## Tool Functions
## ============================================================================
## Functions working with the tool specific manifests
## and other tool related stuff.
###############################################################################

#
# Fetch value by field name from tool manifest for the given tool name.
#
# @private
#
# Arguments:
#   • tooName - Tool name used to fetch the manifest.
#   • fieldName - Key name of json manifest to fetch the value from.
#
# Output:
#   The raw field value.
#
_toolManifest() {
  printf $(cat tools/${toolName}/manifest.json | jq --raw-output ".${fieldName}")
}

#
# Fetch repo url from tool manifest for the given tool.
#
# Arguments:
#   • toolName - Tool name used to fetch the manifest.
#
# Output:
#   The repo url.
#
toolRepoUrl() {
  printf $(toolName=${toolName} fieldName=repoUrl _toolManifest)
}

#
# Fetch tag name from tool manifest for the given tool.
#
# Arguments:
#   • toolName - Tool name used to fetch the manifest.
#
# Output:
#   The tag name.
#
toolTagName() {
  printf $(toolName=${toolName} fieldName=tagName _toolManifest)
}

#
# Fetch setting for number of builds to keep from tool manifest for the given tool.
#
# Arguments:
#   • toolName - Tool name used to fetch the manifest.
#
# Output:
#   The integer number for builds to keep.
#
toolKeepBuilds() {
  printf $(toolName=${toolName} fieldName=keepBuilds _toolManifest)
}

#
# Make asset filename.
#
# Using the asset filename template from tools configuration,
# filling in the given arguments to build the output string with envsubst.
#
# Arguments:
#   • toolName - The tool name which is used to build the filename and to fetch the configuration.
#   • tagName - Tag name used to build the filename.
#   • osNameWithVersion - The OS name including version, like used for the build action folder.
#   • fileExtension - The filename extension (which indicates the archive type).
#
# Output:
#   The tool asset filename.
#
toolAssetFilename() {
  local assetFilenameTemplate=$(cat tools/config.json | jq --raw-output '.assetFilenameTemplate')

  printf $assetFilenameTemplate | \
    tool=${toolName} \
    tag=${tagName} \
    os=${osNameWithVersion} \
    ext=${fileExtension} \
    envsubst
}

