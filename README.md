# Flatpak runtime and apps

This repository contains the Liri apps Flatpaks.

## Versioning

Nightly builds result in the `master` OSTree branch while stable builds are in the `stable` branch.

## Usage

Type the following command to build all apps and then export them.
Replace `<CHANNEL>` with either `channel-stable.yaml` or `channel-unstable.yaml`.
Replace `<GPG_KEY>` with your GPG key.

```sh
./flatpak-build --repo=repo --channel=<CHANNEL> --export --gpg-sign=<GPG_KEY>
```
