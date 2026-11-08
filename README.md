# fontctl

<img width="1335" height="1642" alt="fontctl running in Terminal" src="https://github.com/user-attachments/assets/5a28138b-b8b1-422b-8932-0f48e9290a01" />

`fontctl` manages macOS font registrations with CoreText. It reads OTF and TTF files directly from a chosen collection without copying them into a system font directory or running a background service.

> I’m a designer, and I built fontctl to manage my font collection without copying files or keeping a font manager running. Built with the help of Codex, it’s now part of my daily workflow. I’m sharing it for others who want the same straightforward setup.

## Requirements

- macOS 13 or later
- Swift 5.9 or later to build from source

## Install from source

If `swift --version` is unavailable, install the Xcode Command Line Tools first:

```sh
xcode-select --install
```

Once Swift is available, run the following commands to download the source archive, build the CLI, and install it in `~/.local/bin`.

This also creates `fctl` as a shorter name for `fontctl`. Both commands run the same tool.

```sh
curl -fL -o fontctl-1.2.4.tar.gz [https://raw.githubusercontent.com/backlogdrifter/fontctl/main/fontctl-1.2.4.tar.gz](https://raw.githubusercontent.com/backlogdrifter/fontctl/main/fontctl-1.2.4.tar.gz)
tar -xzf fontctl-1.2.4.tar.gz
cd fontctl-1.2.4
swift build -c release --product fontctl
mkdir -p "$HOME/.local/bin"
install -m 755 .build/release/fontctl "$HOME/.local/bin/fontctl"
ln -sf fontctl "$HOME/.local/bin/fctl"
export PATH="$HOME/.local/bin:$PATH"
fctl --version
```

To make the command available in new Terminal sessions, add the following line to `~/.zprofile` if that directory is not already in your PATH:

```sh
export PATH="$HOME/.local/bin:$PATH"
```

Installation alone does not register any fonts. Choose a collection and activate its fonts as described below.

## Set up your collection

Each font family must be a direct subfolder of the collection:

```text
Fonts/
├── Family One/
│   ├── FamilyOne-Regular.otf
│   └── FamilyOne-Bold.otf
└── Family Two/
    └── FamilyTwo-Regular.ttf
```

Only OTF and TTF files directly inside those family folders are scanned. Files placed directly in the collection root, symlinks, and nested folders are not scanned.

The collection must remain available while its fonts are in use.

## Use

Choose your collection, scan it, and preview activation before making changes:

```sh
fontctl root set "/path/to/Fonts"
fontctl scan
fontctl activate --dry-run
```

Activate the fonts and inspect the result:

```sh
fontctl activate
fontctl status
fontctl list
```

You can also list authors and reconcile the collection with managed registrations:

```sh
fontctl authors
fontctl sync
```

`sync` stops before making changes if the collection is unavailable. Registrations made by other tools are left alone.

Run `fontctl help` for all commands and options. You can use `fctl` instead of `fontctl` throughout.

### Registration scope

Activation is persistent by default. For temporary registration, use:

```sh
fontctl activate --scope session
```

Run `fontctl deactivate` before changing the registration scope.

### State and output

State is stored in `~/Library/Application Support/fontctl/state.json` with a journal.

- `--json` produces machine-readable output.
- `--verbose` shows details.
- `--no-progress` disables the interactive indicator.

## Uninstall

Before removing the CLI, deactivate any registrations it still owns:

```sh
fontctl deactivate
```

If you installed it using the instructions above, remove the executable and its short command:

```sh
rm "$HOME/.local/bin/fontctl" "$HOME/.local/bin/fctl"
```

## Build and checks

From the project directory, build the CLI and run the checks:

```sh
swift build -c release --product fontctl
swift run fontctl-checks
```

The executable is at `.build/release/fontctl`.

To build and run the integration check:

```sh
./scripts/build.sh
./scripts/integration.sh
```

The integration check uses only the included synthetic test font and an isolated state file.

## License

MIT. The synthetic font in `Tests/Fixtures` is released under CC0, as noted in its README.
