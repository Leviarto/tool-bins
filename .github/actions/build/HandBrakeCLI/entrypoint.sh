#!/bin/bash -e

source scripts/fn/logging.sh
source scripts/fn/general.sh
source scripts/fn/tool.sh

###############################################################################

toolName=HandBrakeCLI
osName="${1}"
archiveExt=tar.gz
repoUrl=$(toolName="${toolName}" toolRepoUrl)
tagName=$(toolName="${toolName}" toolTagName)
assetFilename=$( \
  toolName="${toolName}" \
  tagName="${tagName}" \
  osNameWithVersion="${osName}" \
  fileExtension="${archiveExt}" \
  toolAssetFilename \
)

###############################################################################

mkdir -p temp/dist
cd temp

(
  git config --global advice.detachedHead false
  # checkout source for the given tagname (using --depth 1 to omit history)
  git clone --depth 1 --branch "${tagName}" "${repoUrl}" HandBrake
  cd HandBrake
  # build the binary (will be partly dynamically linked)
  # --launch-jobs=0 : match CPU count
  # --launch : launch build, capture log and wait for completion
  ./configure --launch-jobs=0 --launch --disable-gtk --disable-gst \
    --enable-x265 --enable-numa --enable-nvenc --enable-nvdec --enable-vce --enable-qsv
)
cp "HandBrake/build/${toolName}" "dist/${toolName}"

printH2 'Collect license and attribution files'
declare -a licenseFiles=('LICENSE*' 'license*' 'License*' 'COPYING*' 'AUTHORS*' 'THANKS*' 'NEWS*')
from='HandBrake' to='dist' filesRef=licenseFiles \
collectFiles

printH2 'Collect shared libraries'
srcBin="dist/${toolName}" libsFolder='dist/libs' \
collectSharedLibs

printH2 'Make shared libs loader shim'
folderPath='dist' libsFolderName='libs' binFilename="${toolName}" \
makeSharedLibsLoaderShim

printH2 'Make archive for upload'
cd dist
GZIP=-9 tar -czvf "../${assetFilename}" .
