REPO=repo
SDK=sdk
ARGS="--user"
FREEDESKTOP_SDK_VERSION="1.6"

all: $(REPO)/config io.liri.Sdk.json
	flatpak-builder --force-clean --ccache --build-only --disable-updates --require-changes --repo=$(REPO) --subject="Build of io.liri.Sdk, `date`" ${EXPORT_ARGS} $(SDK) io.liri.Sdk.json

update: $(REPO)/config io.liri.Sdk.json
	flatpak-builder --force-clean --ccache --require-changes --repo=$(REPO) --subject="Build of io.liri.Sdk, `date`" ${EXPORT_ARGS} $(SDK) io.liri.Sdk.json

fetch:
	flatpak-builder --download-only --disable-updates $(SDK) io.liri.Sdk.json

export:
	flatpak build-update-repo $(REPO) ${EXPORT_ARGS}

$(REPO)/config:
	ostree init --mode=archive-z2 --repo=$(REPO)

remotes:
	flatpak remote-add $(ARGS) gnome --from https://sdk.gnome.org/gnome.flatpakrepo --if-not-exists

deps:
	flatpak install $(ARGS) gnome org.freedesktop.Platform.Locale $(FREEDESKTOP_SDK_VERSION); true
	flatpak install $(ARGS) gnome org.freedesktop.Sdk.Locale $(FREEDESKTOP_SDK_VERSION); true
	flatpak install $(ARGS) gnome org.freedesktop.Platform $(FREEDESKTOP_SDK_VERSION); true
	flatpak install $(ARGS) gnome org.freedesktop.Sdk $(FREEDESKTOP_SDK_VERSION); true

check:
	@json-glib-validate *.json

clean:
	@rm -rf $(SDK) .flatpak-builder
