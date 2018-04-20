# Flatpak runtime and apps

This repository contains the Liri platform and SDK for Flatpak
plus the apps.

## Versioning

Nightly builds result in the `master` OSTree branch while stable builds are versioned.

## Usage

Type the following command to build all runtimes, then export and publish them.
Replace `<METADATA>` with either `stable-metadata.yml` or `unstable-metadata.yml`.
Replace `<TYPE>` with either `runtime` or `app` depending on what you want to build.
Replace `<GPG_KEY>` with your GPG key.
Replace `<DEST>` with your publishing destination.

```sh
./flatpak-build --repo=runtime-repo --metadata=<METADATA> --type=<TYPE> build
./flatpak-build --repo=runtime-repo --metadata=<METADATA> --type=<TYPE> export --gpg-key=<GPG_KEY>
./flatpak-build --repo=runtime-repo --metadata=<METADATA> --type=<TYPE> sync --gpg-key=<GPG_KEY> --dest=<DEST>
```
