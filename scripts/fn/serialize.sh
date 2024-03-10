###############################################################################
## Serialize Functions
## ============================================================================
## Functions to serialize arrays (or other data) to strings
## and revert serialized strings to restore the original data structure.
###############################################################################

#
# Check if globbing is enabled or was disabled with "set -f".
#
# @private
#
# Output:
#   'true' if globbing is enabled, 'false' otherwise.
#
_isEnabledGlobbing() {
  if [[ -z "${-//[^f]/}" ]] ; then
    printf 'true'
    return 0
  fi
  printf 'false'
}

#
# Serialize array to TAB delimited string for easy argument passing.
#
# Overwrites the desired variable with the serialized content.
#
# Arguments (positional):
#   • 1 (arrayVarName) - The variable name ot the array to serialize.
#
serializeArray() {
  local -n _arrNameRef=${1}
  local ifs=$IFS; IFS=$'\t'
  _arrNameRef="${_arrNameRef[*]}"
  IFS=$ifs
}

#
# Converts TAB delimed serialized string back to array.
#
# Overwrites the desired string variable with an array of strings.
#
# Arguments (positional):
#   • 1 (arrayVarName) - The variable name ot the serialized array.
#
unserializeArray() {
  local -n _arrNameRef=${1}
  local isGlobbing=$(_isEnabledGlobbing)
  if [ 'true' == "${isGlobbing}" ] ; then
    set -f
  fi
  local ifs=$IFS; IFS=$'\t'
  _arrNameRef=($_arrNameRef)
  IFS=$ifs
  if [ 'true' == "${isGlobbing}" ] ; then
    set +f
  fi
}
