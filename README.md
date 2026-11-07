# fontctl

`fontctl` manages macOS font registrations with CoreText. It reads OTF and TTF
files directly from a chosen collection without copying them into a system font
directory or running a background service.

## Requirements

- macOS 13 or later
- Swift 5.9 or later to build from source

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

`fontctl help` describes all commands and options. `fctl` is an equivalent
short command when installed by the Homebrew formula.

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
