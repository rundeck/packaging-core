#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

set -xeuo pipefail

shopt -s globstar

main() {
    local COMMAND="${1}"
    shift

    case "${COMMAND}" in
        build) build "${@}" ;;
        sign) sign "${@}" ;;
        publish) publish "${@}" ;;
    esac
}

build() {
    local RELEASE_NUM="1"

    bash packaging/scripts/travis-build.sh fetch_artifacts
    (
        cd packaging
        ./gradlew \
            -PpackageRelease=$RELEASE_NUM \
            clean packageArtifacts
    )
}

sign() {
    bash packaging/scripts/sign-packages.sh
}

publish() {
    (
        cd packaging
        for PACKAGE in deb rpm; do
            ./gradlew --info \
                -PpackagePrefix="rundeck-" \
                -PpackageType=$PACKAGE \
                -PpackageOrg=rundeck \
                -PpackageRevision=1 \
                bintrayUpload
        done
    )

    if [[ ! -z "${UPSTREAM_TAG}" ]] ; then
        for PACKAGE in deb rpm; do
            aws s3 sync --dryrun --exclude=* --include=*.$PACKAGE packaging/build/distributions/ s3://download.rundeck.org/$PACKAGE/
        done
    fi
}

main "${@}"