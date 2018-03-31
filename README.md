Liri apps platform and SDK for Flatpak
=====

This is the Liri platform and SDK to build Flatpak apps against.

## Versioning

Nightly builds result in the `master` OSTree branch while stable builds are versioned.

## Usage

Type the following command to build all runtimes, then export and publish them.
Replace `<METADATA>` with either `stable-metadata.yml` or `unstable-metadata.yml`.
Replace `<GPG_KEY>` with your GPG key.
Replace `<DEST>` with your publishing destination.

```sh
./flatpak-build --repo=runtime-repo --metadata=<METADATA> build
./flatpak-build --repo=runtime-repo --metadata=<METADATA> export --gpg-key=<GPG_KEY>
./flatpak-build --repo=runtime-repo --metadata=<METADATA> sync --gpg-key=<GPG_KEY> --dest=<DEST>
```
