# Brave Debloat

This project aims to debloat Brave Browser and provide a Brave Origin-like experience without having to manually check and toggle settings. It also adds a few nice tweaks to make the browser experience better.

## How to Run

### macOS

Clone the repo locally

```bash
git clone https://github.com/sajayprakash/brave-debloat
```

Run the debloat script from `scripts/macos`:

```bash
./scripts/macos/debloat-brave-macos.sh
```

To undo the changes, run:

```bash
./scripts/macos/undo-debloat-brave-macos.sh
```

### Windows

Download `scripts/windows/debloat-brave-windows.reg` and open it to apply the changes.

### Linux

Just use Brave Origin from the [Brave](https://brave.com/) website, it is free on Linux!

## How it works

The scripts leverage Brave's group policies and enterprise management features. Learn more at [Brave's Group Policy documentation](https://support.brave.app/hc/en-us/articles/360039248271-Group-Policy) and [Chrome Enterprise policy list](https://chromeenterprise.google/policies/).

## Features Disabled

Brave Origin reference: [What is Brave Origin?](https://support.brave.app/hc/en-us/articles/38561489788173-What-is-Brave-Origin)

- Leo
- News
- Playlist
- Rewards
- Speedreader
- Stats, crash logs, and privacy-preserving product analytics (P3A)
- Talk
- Tor
- VPN
- Wallet
- Wayback Machine
- Web Discovery Project
- Password Manager
- Payment methods autofill
- Addresses autofill

## Extra Tweaks

- High Efficiency mode enabled
- Memory Saver set to balanced
- Secure DNS set to Cloudflare (Blocks Malware)
- Warn before quitting enabled (MacOS only)
