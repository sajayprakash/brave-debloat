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
  local type="$2"
  local value="$3"

  /usr/libexec/PlistBuddy -c "Delete :${key}" "$PLIST_PATH" 2>/dev/null || true
  /usr/libexec/PlistBuddy -c "Add :${key} ${type} ${value}" "$PLIST_PATH"
}

main() {
  ensure_root "$@"

  mkdir -p "$PLIST_DIR"
  chown root:wheel "$PLIST_DIR"
  chmod 755 "$PLIST_DIR"

  if [[ ! -f "$PLIST_PATH" ]]; then
    /usr/bin/plutil -create xml1 "$PLIST_PATH"
  fi

  add_pref BraveAIChatEnabled bool false
  add_pref BraveNewsDisabled bool true
  add_pref BravePlaylistEnabled bool false
  add_pref BraveRewardsDisabled bool true
  add_pref BraveSpeedreaderEnabled bool false
  add_pref BraveStatsPingEnabled bool false
  add_pref BraveTalkDisabled bool true
  add_pref TorDisabled bool true
  add_pref BraveVPNDisabled bool true
  add_pref BraveWalletDisabled bool true
  add_pref BraveWaybackMachineEnabled bool false
  add_pref BraveWebDiscoveryEnabled bool false
  add_pref BraveP3AEnabled bool false
  add_pref PasswordManagerEnabled bool false
  add_pref AutofillCreditCardEnabled bool false
  add_pref AutofillAddressEnabled bool false
  add_pref HighEfficiencyModeEnabled bool true
  add_pref MemorySaverModeSavings integer 1
  add_pref DnsOverHttpsMode string secure
  add_pref DnsOverHttpsTemplates string https://security.cloudflare-dns.com/dns-query{?dns}

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
  printf '%s\n' '  Disabled Password Manager'
  printf '%s\n' '  Disabled payment methods autofill'
  printf '%s\n' '  Disabled addresses autofill'
  printf '%s\n' '  Enabled High Efficiency mode'
  printf '%s\n' '  Set Memory Saver to balanced'
  printf '%s\n' '  Set Secure DNS to Cloudflare'

  echo "Brave managed preferences written to: $PLIST_PATH"
}

main "$@"
