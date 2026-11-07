# fontctl

<img width="1335" height="1642" alt="Screenshot 2026-11-07 at 23 31 11" src="https://github.com/user-attachments/assets/5a28138b-b8b1-422b-8932-0f48e9290a01" />

`fontctl` manages macOS font registrations with CoreText. It reads OTF and TTF
files directly from a chosen collection without copying them into a system font
directory or running a background service.

## Requirements

- macOS 13 or later
- Swift 5.9 or later to build from source

## Installation

Install the Xcode Command Line Tools first if `swift --version` is unavailable: `xcode-select --install`. Then run:

```sh
curl -fL -o fontctl-1.2.4.tar.gz https://raw.githubusercontent.com/backlogdrifter/fontctl/main/fontctl-1.2.4.tar.gz
tar -xzf fontctl-1.2.4.tar.gz
cd fontctl-1.2.4
swift build -c release --product fontctl
mkdir -p "$HOME/.local/bin"
install -m 755 .build/release/fontctl "$HOME/.local/bin/fontctl"
ln -sf fontctl "$HOME/.local/bin/fctl"
export PATH="$HOME/.local/bin:$PATH"
fctl --version
```

To make the command available in new Terminal sessions, add `export PATH="$HOME/.local/bin:$PATH"` to `~/.zprofile` if that directory is not already in your PATH. Set your font collection with `fctl root set "/path/to/Fonts"`; installation alone does not register fonts.

## Build

```sh
swift build -c release --product fontctl
swift run fontctl-checks
```

The CLI is at `.build/release/fontctl`. The integration check uses only the
included synthetic test font and an isolated state file:

```sh
./scripts/build.sh
./scripts/integration.sh
```

## Use

Choose a collection before scanning or activating fonts:

```sh
fontctl root set "/path/to/Fonts"
fontctl scan
fontctl activate --dry-run
fontctl activate
fontctl status
fontctl list
fontctl authors
fontctl sync
```

`fontctl help` describes all commands and options. The installation steps above also create the short `fctl` command.

Each font family is a direct subfolder of the collection. Only OTF and TTF
files directly inside those folders are scanned. Symlinks and nested folders
are skipped. The collection must remain available while its fonts are in use.

Activation is persistent by default. Use `--scope session` for temporary
registration. Run `fontctl deactivate` before changing the registration scope
or removing the CLI if it still owns active registrations. `sync` reconciles
the collection with managed registrations; it stops before making changes if
the collection is unavailable. Registrations made by other tools are left
alone.

State is stored in `~/Library/Application Support/fontctl/state.json` with a
journal. `--json` produces machine-readable output, `--verbose` shows details,
and `--no-progress` disables the interactive indicator.

## License

MIT. The synthetic font in `Tests/Fixtures` is released under CC0, as noted in
its README.
