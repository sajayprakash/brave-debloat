#!/usr/bin/env bash

set -euo pipefail

PLIST_PATH="/Library/Managed Preferences/com.brave.Browser.plist"

if [[ $(uname -s) != "Darwin" ]]; then
  printf 'This script is only supported on macOS.\n' >&2
  exit 1
fi

ensure_root() {
  if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
    printf 'This script will run with privileged permissions to remove Brave preferences.\n'
    exec sudo "$0" "$@"
  fi
}

delete_key() {
  /usr/libexec/PlistBuddy -c "Delete :$1" "$PLIST_PATH" 2>/dev/null || true
}

remove_pref() {
  delete_key "$1"
}

plist_has_entries() {
  local output
  output=$(/usr/libexec/PlistBuddy -c "Print" "$PLIST_PATH" 2>/dev/null || true)
  [[ -n "$output" ]]
}

main() {
  ensure_root "$@"

  if [[ ! -f "$PLIST_PATH" ]]; then
    echo "No managed Brave plist found at $PLIST_PATH"
    exit 0
  fi

  remove_pref BraveAIChatEnabled
  remove_pref BraveNewsDisabled
  remove_pref BravePlaylistEnabled
  remove_pref BraveRewardsDisabled
  remove_pref BraveSpeedreaderEnabled
  remove_pref BraveStatsPingEnabled
  remove_pref BraveTalkDisabled
  remove_pref TorDisabled
  remove_pref BraveVPNDisabled
  remove_pref BraveWalletDisabled
  remove_pref BraveWaybackMachineEnabled
  remove_pref BraveWebDiscoveryEnabled
  remove_pref BraveP3AEnabled
  remove_pref PasswordManagerEnabled
  remove_pref AutofillCreditCardEnabled
  remove_pref AutofillAddressEnabled
  remove_pref HighEfficiencyModeEnabled
  remove_pref MemorySaverModeSavings
  remove_pref DnsOverHttpsMode
  remove_pref DnsOverHttpsTemplates

  if ! plist_has_entries; then
    rm -f "$PLIST_PATH"
  fi

  killall cfprefsd 2>/dev/null || true

  echo "Brave managed preferences cleared from: $PLIST_PATH"
}

main "$@"
