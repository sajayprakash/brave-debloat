#!/usr/bin/env bash

set -euo pipefail

PLIST_DIR="/Library/Managed Preferences"
PLIST_PATH="${PLIST_DIR}/com.brave.Browser.plist"

if [[ $(uname -s) != "Darwin" ]]; then
  printf 'This script is only supported on macOS.\n' >&2
  exit 1
fi

ensure_root() {
  if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
    printf 'This script will run with privileged permissions to add Brave preferences.\n'
    exec sudo "$0" "$@"
  fi
}

add_pref() {
  local key="$1"
  local value="$2"

  /usr/libexec/PlistBuddy -c "Delete :${key}" "$PLIST_PATH" 2>/dev/null || true
  /usr/libexec/PlistBuddy -c "Add :${key} bool ${value}" "$PLIST_PATH"
}

main() {
  ensure_root "$@"

  mkdir -p "$PLIST_DIR"
  chown root:wheel "$PLIST_DIR"
  chmod 755 "$PLIST_DIR"

  if [[ ! -f "$PLIST_PATH" ]]; then
    /usr/bin/plutil -create xml1 "$PLIST_PATH"
  fi

  add_pref BraveAIChatEnabled false
  add_pref BraveNewsDisabled true
  add_pref BravePlaylistEnabled false
  add_pref BraveRewardsDisabled true
  add_pref BraveSpeedreaderEnabled false
  add_pref BraveStatsPingEnabled false
  add_pref BraveTalkDisabled true
  add_pref TorDisabled true
  add_pref BraveVPNDisabled true
  add_pref BraveWalletDisabled true
  add_pref BraveWaybackMachineEnabled false
  add_pref BraveWebDiscoveryEnabled false
  add_pref BraveP3AEnabled false

  chown root:wheel "$PLIST_PATH"
  chmod 644 "$PLIST_PATH"

  killall cfprefsd 2>/dev/null || true

  printf '%s\n' 'Applied Brave preferences:'
  printf '%s\n' '  Disabled Leo'
  printf '%s\n' '  Disabled News'
  printf '%s\n' '  Disabled Playlist'
  printf '%s\n' '  Disabled Rewards'
  printf '%s\n' '  Disabled Speedreader'
  printf '%s\n' '  Disabled Stats, crash logs, and privacy-preserving product analytics (P3A)'
  printf '%s\n' '  Disabled Talk'
  printf '%s\n' '  Disabled Tor'
  printf '%s\n' '  Disabled VPN'
  printf '%s\n' '  Disabled Wallet'
  printf '%s\n' '  Disabled Wayback Machine'
  printf '%s\n' '  Disabled Web Discovery Project'

  echo "Brave managed preferences written to: $PLIST_PATH"
}

main "$@"
