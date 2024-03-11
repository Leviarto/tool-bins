#!/bin/bash -e

### Functions #################################################################

source scripts/fn/git.sh
source scripts/fn/gh.sh
source scripts/fn/tool.sh
source scripts/fn/logging.sh

#
# Update given manifest file with remote repo info.
#
# Currently updates tagName property with tagName from latest release of repoUrl.
#
# Arguments:
#   • manifestFile - The filename path to the manifest.json of one tool folder.
#
toolUpdateManifest() {
  local repoUrl=$(cat "${manifestFile}" | jq --raw-output '.repoUrl')
  local tagNameRegEx=$(propName='tagNameRegEx' toolsConfig)
  tagNameRegEx=${tagNameRegEx//\\/\\\\}  # double escape backslashes for jq filter regex

  # fetch latest release
  local latestRelease=$(gh release view -R "${repoUrl}" --json 'name,tagName,isDraft,isPrerelease,publishedAt')

  # check for valid format of tag name
  local isValidVersionTagName=$(printf "${latestRelease}" | jq ".tagName | test(\"^${tagNameRegEx}\$\")?")
  if [[ 'true' != "${isValidVersionTagName}" ]] ; then
    printf 'Newest release of remote repo has an invalid version tag name.'
    return
  fi

  # check that it's not a preprelease or draft
  local isPrerelease=$(printf "${latestRelease}" | jq --raw-output '.isPrerelease')
  local isDraft=$(printf "${latestRelease}" | jq --raw-output '.isDraft')
  if [[ 'true' == "${isPrerelease}" || 'true' == "${isDraft}" ]] ; then
    printf 'Newest release of remote repo is a prerelease or draft.'
    return
  fi

  # check that the tag name differs from current manifest
  local remoteTagName=$(printf "${latestRelease}" | jq --raw-output '.tagName')
  local manifestTagName=$(cat "${manifestFile}" | jq --raw-output '.tagName')
  if [[ "${remoteTagName}" == "${manifestTagName}" ]] ; then
    printf 'Newest release tag name of remote repo is equal to current manifest.'
    return
  fi

  # update json with jq and write back to same file
  cat "${manifestFile}" | jq ".tagName = \"${remoteTagName}\"" > "${manifestFile}.tmp" \
    && mv "${manifestFile}.tmp" "${manifestFile}"
}

#
# Check that the given file exists and is a valid json file (checked with jq).
#
# Arguments:
#   • filenamePath - The filename path to the json file to validate.
#
# Output:
#   'true' if valid, 'false' otherwise.
#
isValidJsonFile() {
  if [[ -s "${filenamePath}" && 0 -eq $(cat "${filenamePath}" | jq empty > /dev/null 2>&1 ; echo $?) ]] ; then
    printf 'true'
    return
  fi
  printf 'false'
}

### Main ######################################################################

printH1 'Update Tool Manifest'

gh auth status

gitSetupUserNameAndEmail
printH2 'Git user config'
printf 'user.name: ' && git config user.name
printf 'user.email: ' && git config user.email

printH2 'Update tool manifests...'
for toolFolder in tools/*/ ; do
  manifestFilenamePath="${toolFolder}/manifest.json"
  printf '\n' && printInfo ">> ${manifestFilenamePath}"

  tumReturn=$(manifestFile="${manifestFilenamePath}" toolUpdateManifest)
  if [[ '' == "${tumReturn}" ]] ; then
    printMinorSuccess 'JSON updated'
    if [[ 'true' == $(filenamePath="${manifestFilenamePath}" isValidJsonFile) ]] ; then
      cat "${manifestFilenamePath}"
      commitMessage='bot: update tag name' filenamePath="${manifestFilenamePath}" gitCommitAndPushFile
      printMinorSuccess 'Commit and push: Success'
    else
      printMinorError "Manifest file \"${manifestFilenamePath}\" is not valid or missing."
    fi
  else
    printMinorError 'JSON not updated'
  fi
  if [[ '' != "${tumReturn}" ]] ; then
    printMinorWarning "Reason: ${tumReturn}"
  fi
done



