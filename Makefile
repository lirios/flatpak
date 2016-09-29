all: repo clean io.liri.Sdk.json
	xdg-app-builder --ccache --build-only --disable-updates --require-changes --repo=repo --subject="Build of io.liri.Sdk, `date`" ${EXPORT_ARGS} sdk io.liri.Sdk.json

update: repo clean io.liri.Sdk.json
	xdg-app-builder --ccache --require-changes --repo=repo --subject="Build of io.liri.Sdk, `date`" ${EXPORT_ARGS} sdk io.liri.Sdk.json

fetch:
	xdg-app-builder --download-only --disable-updates sdk io.liri.Sdk.json

repo:
	ostree init --mode=archive-z2 --repo=repo

clean:
	@rm -rf sdk
