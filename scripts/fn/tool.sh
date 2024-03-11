###############################################################################
## Tool Functions
## ============================================================================
## Functions working with the tool specific manifests
## and other tool related stuff.
###############################################################################

#
# Read config property from tools general configuration.
#
# Arguments:
#   • propName - The json property key.
#
# Output:
#   The raw property value.
#
toolsConfig() {
  printf $(cat tools/config.json | jq --raw-output ".${propName}")
}

#
# Fetch value by property name from tool manifest for the given tool name.
#
# @private
#
# Arguments:
#   • tooName - Tool name used to fetch the manifest.json.
#   • propName - The json property key.
#
# Output:
#   The raw property value.
#
_toolManifestProp() {
  printf $(cat tools/${toolName}/manifest.json | jq --raw-output ".${propName}")
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
  printf $(toolName=${toolName} propName=repoUrl _toolManifestProp)
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
  printf $(toolName=${toolName} propName=tagName _toolManifestProp)
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
  printf $(toolName=${toolName} propName=keepBuilds _toolManifestProp)
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

