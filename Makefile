all: repo org.hawaiios.Sdk.json
	xdg-app-builder --ccache --build-only --disable-updates --require-changes --repo=repo --subject="Build of org.hawaiios.Sdk, `date`" ${EXPORT_ARGS} sdk org.hawaiios.Sdk.json

update: repo org.hawaiios.Sdk.json
	xdg-app-builder --ccache --require-changes --repo=repo --subject="Build of org.hawaiios.Sdk, `date`" ${EXPORT_ARGS} sdk org.hawaiios.Sdk.json

fetch:
	xdg-app-builder --download-only --disable-updates sdk org.hawaiios.Sdk.json

repo:
	ostree init --mode=archive-z2 --repo=repo

clean:
	@rm -rf sdk
