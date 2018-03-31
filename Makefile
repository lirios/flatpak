# Override with e.g. `make ARCH=i386`
ARCH ?= $(shell flatpak --default-arch)

# OSTree local repository location
REPO ?= repo

# SDK location
SDK ?= sdk

# flatpak arguments
ARGS = "--user"

# GPG key to sign commits
GPGKEY = 7D98B067FFEFDAA5F8941D4CDFA98DBF970012EE

#
# SDK Versions setup here
#
# RUNTIME_BRANCH:       The version (branch) of platform and SDK to produce
# FREEDESKTOP_VERSION:  The org.freedesktop.Platform and org.freedesktop.Sdk version to build against
#
RUNTIME_BRANCH = 1.0
FREEDESKTOP_VERSION = 1.6
KDE_VERSION = 5.10

SUBST_FILES=io.liri.Sdk.json os-release issue issue.net io.liri.Sdk.appdata.xml io.liri.Platform.appdata.xml
define subst-metadata
	@echo -n "Generating files: ${SUBST_FILES}... ";
	@for file in ${SUBST_FILES}; do 					\
	  file_source=$${file}.in; 						\
	  sed                                                                   \
	      -e 's/@@RUNTIME_ARCH@@/${ARCH}/g' 				\
	      -e 's/@@RUNTIME_BRANCH@@/${RUNTIME_BRANCH}/g' 			\
	      -e 's/@@FREEDESKTOP_VERSION@@/${FREEDESKTOP_VERSION}/g' 		\
	      -e 's/@@KDE_VERSION@@/${KDE_VERSION}/g' 				\
	      $$file_source > $$file.tmp && mv $$file.tmp $$file || exit 1;	\
	done
	@echo "Done.";
endef

all: $(REPO)/config $(patsubst %,%.in,$(SUBST_FILES))
	$(call subst-metadata)
	flatpak-builder --force-clean --ccache --require-changes --repo=$(REPO) --arch=$(ARCH) --subject="Build of io.liri.Sdk, `date`" --gpg-sign=$(GPGKEY) ${EXPORT_ARGS} $(SDK) io.liri.Sdk.json

build: $(REPO)/config $(patsubst %,%.in,$(SUBST_FILES))
	$(call subst-metadata)
	flatpak-builder --force-clean --ccache --build-only --disable-updates --require-changes --repo=$(REPO) --arch=$(ARCH) --subject="Build of io.liri.Sdk, `date`" $(SDK) io.liri.Sdk.json

fetch:
	flatpak-builder --download-only --disable-updates $(SDK) io.liri.Sdk.json

gpgkey:
	@rm -f key.gpg
	gpg --output key.gpg --export $(GPGKEY)
	base64 --wrap=0 < key.gpg > key.gpg.base64

export:
	flatpak build-update-repo $(REPO) --gpg-sign=$(GPGKEY) --prune --prune-depth=20 ${EXPORT_ARGS}

$(REPO)/config:
	ostree init --mode=archive-z2 --repo=$(REPO)

remotes:
	flatpak remote-add $(ARGS) flathub --from https://flathub.org/repo/flathub.flatpakrepo --if-not-exists

deps: remotes
	flatpak update $(ARGS) org.kde.Platform.Locale $(KDE_VERSION) || flatpak install $(ARGS) flathub org.kde.Platform.Locale $(KDE_VERSION)
	flatpak update $(ARGS) org.kde.Sdk.Locale $(KDE_VERSION) || flatpak install $(ARGS) flathub org.kde.Sdk.Locale $(KDE_VERSION)
	flatpak update $(ARGS) org.kde.Platform $(KDE_VERSION) || flatpak install $(ARGS) flathub org.kde.Platform $(KDE_VERSION)
	flatpak update $(ARGS) org.kde.Sdk $(KDE_VERSION) || flatpak install $(ARGS) flathub org.kde.Sdk $(KDE_VERSION)

check: $(patsubst %,%.in,io.liri.Sdk.json)
	@$(call subst-metadata)
	@json-glib-validate *.json

clean:
	@rm -rf $(SDK) .flatpak-builder

.PHONY: fetch export remotes deps check clean
