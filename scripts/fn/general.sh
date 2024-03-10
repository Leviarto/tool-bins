###############################################################################
## General Functions
## ============================================================================
## Collection of multi-purpose helper functions.
###############################################################################

#
# Check if string is contained in array of strings.
#
# Arguments:
#   • haystackRef - The nameref to the array of strings to search in.
#   • needle - The string to search for.
#
# Output:
#   'true' if found, 'false' otherwise.
#
inStrArray() {
  local -n _haystackRef="${haystackRef}"
  for elem in "${_haystackRef[@]}" ; do
    if [ "${elem}" == "${needle}" ] ; then
      printf 'true'
      return 0
    fi
  done
  printf 'false'
}

#
# Copy files from one to another folder if they match the given glob patterns.
#
# Arguments:
#   • from - The source folder to search for the files.
#   • to - The destination folder to copy found files.
#   • filesRef - Nameref to array of file names to match as strings (my contain simple glob patterns).
#
collectFiles() {
  local -n _filesRef="${filesRef}"
  for f in "${_filesRef[@]}"; do
    find "${from}" -maxdepth 1 -type f -name "${f}" -exec cp -v '{}' "${to}" \;
  done
}

#
# Collect all dynamically linked shared libs for a given binary.
#
# Arguments:
#   • srcBin - The source binary file to check for dynamically linked shared libs.
#   • libsFolder - The folder path to create (if not exists) and copy the found libs into.
#
collectSharedLibs() {
  mkdir -p "${libsFolder}"

  # use ldd to find dynamically linked libs;
  # the awk substr check validates a third token as an absolute path (starting with "/"),
  # which is empty for magic libs (like linux-vdso.so and ld-linux-x86-65.so) or false for "not found"
  ldd "$srcBin" |
  awk '{if(substr($3,0,1)=="/") print $3}' |
  sort |

  # copy the libs selection to the chosen libs folder
  xargs -d '\n' -I{} cp -v -L {} "${libsFolder}"
}

#
# Creates a "run.sh" file which sets the LD_LIBRARY_PATH to the given libs folder
# and calls the given executable passing through arguments.
#
# Arguments:
#   • folderPath - Path to put the run.sh shim file.
#   • libsFolderName - Folder name with the libs to reference with LD_LIBRARY_PATH within the folderPath folder.
#   • binFilename - The executable filename to call within the folderPath folder.
#
makeSharedLibsLoaderShim() {
  local shimFilenamePath="${folderPath}/run.sh"

  cat > "${shimFilenamePath}" <<EOF
#!/bin/bash

LD_LIBRARY_PATH=./${libsFolderName} ./${binFilename} "\$@"

EOF
}
