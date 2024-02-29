#!/bin/zsh

cat /dev/null > output.txt

show_help() {
  echo "Usage: ./lab1.sh <action> <arguments> [directory]"
  echo "Actions:"
  echo "  search-regex <pattern> [directory] - Search files by name using a regular expression pattern"
  echo "  search-list <directory> <name1> <name2> ... - Search files by name using a list of names"
  echo "  perform <action> [directory] <search_string> - Perform actions on found files"
  echo "    Available actions: list, checksum, bytes"
  echo "  help - Show this help message"
}

if [[ "$1" == "help" ]]; then
  show_help
  exit 0
fi

search_files_by_regex() {
  local pattern="$1"
  local directory="${2:-.}"
  find "$directory" -type f -regex "$pattern" -exec ls -l {} \;
}

search_files_by_list() {
  local names=("$@")
  local directory="${names[1]}"
  shift
  find "$directory" -type f \( -name "${names[2]}" $(printf -- "-o -name %s " "${names[@]:3}") \) -exec ls -l {} \;
}

perform_actions() {
  local action="$1"
  shift
  local directory="${1:-.}"
  local search_string="$2"
  case "$action" in
    "list")
      while IFS= read -r file; do
        local first_line=$(head -n 1 "$file")
        if [[ "$first_line" == "$search_string" ]]; then
          echo "Listing file: $file" | tee -a output.txt
          cat -n "$file" | tee -a output.txt
        fi
      done <<< "$(find "$directory" -type f)"
      ;;
    "checksum")
      local total_checksum=0
      while IFS= read -r file; do
        local checksum=$(cksum "$file" | awk '{print $1}')
        echo "Checksum of $file: $checksum" | tee -a output.txt
        ((total_checksum += checksum))
      done <<< "$(find "$directory" -type f)"
      echo "Total checksum: $total_checksum" | tee -a output.txt
      ;;
    "bytes")
      local total_bytes=0
      while IFS= read -r file; do
        local bytes=$(wc -c < "$file")
        echo "Bytes of $file: $bytes" | tee -a output.txt
        ((total_bytes += bytes))
      done <<< "$(find "$directory" -type f)"
      echo "Total bytes: $total_bytes" | tee -a output.txt
      ;;
    *)
      echo "Invalid action: $action" | tee -a output.txt
      ;;
  esac
}

action="$1"
shift

case "$action" in
  "search-regex")
    search_files_by_regex "$@"
    ;;
  "search-list")
    search_files_by_list "$@"
    ;;
  "perform")
    perform_actions "$@"
    ;;
  *)
    echo "Invalid action: $action" | tee -a output.txt
    ;;
esac
