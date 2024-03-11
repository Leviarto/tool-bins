###############################################################################
## Git Functions
## ============================================================================
## Functions which utilize git to change repo files.
###############################################################################

#
# Set user.name and user.email with git config to github-actions[bot].
#
gitSetupUserNameAndEmail() {
  git config user.name 'github-actions[bot]'
  git config user.email '41898282+github-actions[bot]@users.noreply.github.com'
}

#
# Commit changes for one file and push to origin.
#
# Arguments:
#   • commitMessage - The commit message to use for the commit.
#   • filenamePath - The file which changes are committed.
#
gitCommitAndPushFile() {
  if [[ "$ACT" == true ]] ; then
    echo "git commit -m \"${commitMessage}\" \"${filenamePath}\""
    echo 'git push'
  else
    git commit -m "${commitMessage}" "${filenamePath}"
    git push
  fi
}
