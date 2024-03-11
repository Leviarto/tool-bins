ANSI_ESCAPE_TPL='\e[%sm%s\e[0m'

ANSI_STYLE_BOLD='1'
ANSI_STYLE_FAINT='2'
ANSI_STYLE_ITALIC='3'
ANSI_STYLE_UNDERLINE='4'

ANSI_COLOR_BLACK='30'
ANSI_COLOR_RED='31'
ANSI_COLOR_GREEN='32'
ANSI_COLOR_YELLOW='33'
ANSI_COLOR_BLUE='34'
ANSI_COLOR_MAGENTA='35'
ANSI_COLOR_CYAN='36'
ANSI_COLOR_GRAY='90'
ANSI_COLOR_WHITE='97'

printBold() {
  printf "${ANSI_ESCAPE_TPL}\n" "${ANSI_STYLE_BOLD}" "${1}"
}
printItalic() {
  printf "${ANSI_ESCAPE_TPL}\n" "${ANSI_STYLE_ITALIC}" "${1}"
}
printUnderline() {
  printf "${ANSI_ESCAPE_TPL}\n" "${ANSI_STYLE_UNDERLINE}" "${1}"
}

printH1() {
  printf "\n${ANSI_ESCAPE_TPL}\n\n" "${ANSI_STYLE_BOLD};${ANSI_STYLE_UNDERLINE};${ANSI_COLOR_MAGENTA}" "# ${1} #"
}
printH2() {
  printf "\n${ANSI_ESCAPE_TPL}\n" "${ANSI_STYLE_BOLD};${ANSI_COLOR_CYAN}" "${1}"
}

printInfo() {
  printf "${ANSI_ESCAPE_TPL}\n" "${ANSI_COLOR_WHITE}" "${1}"
}

printError() {
  printf "\n${ANSI_ESCAPE_TPL}\n" "${ANSI_STYLE_BOLD};${ANSI_COLOR_RED}" "Error: ${1}"
}
printWarning() {
  printf "\n${ANSI_ESCAPE_TPL}\n" "${ANSI_STYLE_BOLD};${ANSI_COLOR_YELLOW}" "${1}"
}
printSuccess() {
  printf "\n${ANSI_ESCAPE_TPL}\n" "${ANSI_STYLE_BOLD};${ANSI_COLOR_GREEN}" "${1}"
}

printMinorError() {
  printf "${ANSI_ESCAPE_TPL}\n" "${ANSI_COLOR_RED}" "${1}"
}
printMinorWarning() {
  printf "${ANSI_ESCAPE_TPL}\n" "${ANSI_COLOR_YELLOW}" "${1}"
}
printMinorSuccess() {
  printf "${ANSI_ESCAPE_TPL}\n" "${ANSI_COLOR_GREEN}" "${1}"
}
