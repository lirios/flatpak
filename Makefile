ARGS="--user"
FREEDESKTOP_SDK_VERSION="1.4"

all: repo clean io.liri.Sdk.json
	flatpak-builder --ccache --build-only --disable-updates --require-changes --repo=repo --subject="Build of io.liri.Sdk, `date`" ${EXPORT_ARGS} sdk io.liri.Sdk.json

update: repo clean io.liri.Sdk.json
	flatpak-builder --ccache --require-changes --repo=repo --subject="Build of io.liri.Sdk, `date`" ${EXPORT_ARGS} sdk io.liri.Sdk.json

fetch:
	flatpak-builder --download-only --disable-updates sdk io.liri.Sdk.json

repo:
	ostree init --mode=archive-z2 --repo=repo

remotes:
	wget http://sdk.gnome.org/keys/gnome-sdk.gpg
	flatpak remote-add $(ARGS) --gpg-import=gnome-sdk.gpg gnome http://sdk.gnome.org/repo/
	rm *.gpg

deps:
	flatpak install $(ARGS) gnome org.freedesktop.Platform $(FREEDESKTOP_SDK_VERSION); true
	flatpak install $(ARGS) gnome org.freedesktop.Sdk $(FREEDESKTOP_SDK_VERSION); true
	flatpak install $(ARGS) gnome org.freedesktop.Sdk.Locale $(FREEDESKTOP_SDK_VERSION); true
	flatpak install $(ARGS) gnome org.freedesktop.Platform.Locale $(FREEDESKTOP_SDK_VERSION); true

check:
	@json-glib-validate *.json

clean:
	@rm -rf sdk
