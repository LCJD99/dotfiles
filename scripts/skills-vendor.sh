#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(git rev-parse --show-toplevel)"
REGISTRY_FILE="$ROOT_DIR/skills/vendors.txt"

usage() {
  cat <<'EOF'
Usage:
  skills-vendor.sh add <name> <repo_url> [branch]
  skills-vendor.sh sync <name>
  skills-vendor.sh sync-all
  skills-vendor.sh list

Registry format:
  name|repo_url|branch
EOF
}

ensure_registry() {
  if [ ! -f "$REGISTRY_FILE" ]; then
    mkdir -p "$ROOT_DIR/skills"
    printf '%s\n' '# name|repo_url|branch' > "$REGISTRY_FILE"
  fi
}

get_vendor_line() {
  local name="$1"
  awk -F '|' -v name="$name" 'NF>=3 && $1==name {print $0}' "$REGISTRY_FILE"
}

append_registry() {
  local name="$1"
  local url="$2"
  local branch="$3"
  printf '%s|%s|%s\n' "$name" "$url" "$branch" >> "$REGISTRY_FILE"
}

commit_registry_update() {
  local name="$1"
  git add "$REGISTRY_FILE"
  git commit -m "chore(skills): register vendor $name" -- "$REGISTRY_FILE"
}

sync_one() {
  local name="$1"
  local line

  line="$(get_vendor_line "$name")"
  if [ -z "$line" ]; then
    printf 'Vendor not found: %s\n' "$name" >&2
    exit 1
  fi

  IFS='|' read -r reg_name reg_url reg_branch <<EOF
$line
EOF

  if [ ! -d "$ROOT_DIR/skills/vendor/$reg_name" ] || [ -z "$(ls -A "$ROOT_DIR/skills/vendor/$reg_name" 2>/dev/null || true)" ]; then
    git subtree add --prefix="skills/vendor/$reg_name" "$reg_url" "$reg_branch" --squash
  else
    git subtree pull --prefix="skills/vendor/$reg_name" "$reg_url" "$reg_branch" --squash
  fi
}

cmd_add() {
  local name="$1"
  local url="$2"
  local branch="${3:-main}"

  ensure_registry

  if [ -n "$(get_vendor_line "$name")" ]; then
    printf 'Vendor already exists in registry: %s\n' "$name" >&2
    exit 1
  fi

  append_registry "$name" "$url" "$branch"
  commit_registry_update "$name"
  sync_one "$name"
}

cmd_sync() {
  local name="$1"
  ensure_registry
  sync_one "$name"
}

cmd_sync_all() {
  ensure_registry
  while IFS='|' read -r name _url _branch; do
    if [ -z "$name" ] || [ "${name#\#}" != "$name" ]; then
      continue
    fi
    sync_one "$name"
  done < "$REGISTRY_FILE"
}

cmd_list() {
  ensure_registry
  awk -F '|' 'NF>=3 && $1 !~ /^#/ {printf "%-20s %-8s %s\n", $1, $3, $2}' "$REGISTRY_FILE"
}

if [ "$#" -lt 1 ]; then
  usage
  exit 1
fi

case "$1" in
  add)
    if [ "$#" -lt 3 ]; then
      usage
      exit 1
    fi
    cmd_add "$2" "$3" "${4:-main}"
    ;;
  sync)
    if [ "$#" -ne 2 ]; then
      usage
      exit 1
    fi
    cmd_sync "$2"
    ;;
  sync-all)
    cmd_sync_all
    ;;
  list)
    cmd_list
    ;;
  *)
    usage
    exit 1
    ;;
esac
