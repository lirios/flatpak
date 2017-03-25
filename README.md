Liri apps platform and SDK for Flatpak
=====

This is the Liri platform and SDK to build Flatpak apps against.

## Build

Type the following command to build, export the repository and sign the commit with GPG:

```sh
./export
```

If you want to perform only a build and use the `repo` locally:

```sh
make build
```

## Versioning

Nightly builds result in the `master` OSTree branch while stable builds are versioned.
