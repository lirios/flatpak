#!/bin/bash
# SPDX-FileCopyrightText: 2020 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
#
# SPDX-License-Identifier: CC0-1.0

set -e

app_id=$1

if [ -z "$app_id" ]; then
    echo "Usage: $0 [app_id]"
    exit 1
fi

flatpak remote-add flathub --from https://flathub.org/repo/flathub.flatpakrepo --user --if-not-exists

now=$(date +"%Y-%m-%d %H:%M:%S")

flatpak-builder build ${app_id}.yaml \
    --gpg-sign=${CI_GPG_KEYID} \
    --gpg-homedir=${HOME}/.gnupg \
    --force-clean \
    --subject="Build of ${app_id} at ${now}" \
    --install-deps-from=flathub \
    --install --user \
    --repo=repo
