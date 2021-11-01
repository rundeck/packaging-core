#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

UPSTREAM_TAG="${UPSTREAM_TAG:-}"

DRY_RUN="${DRY_RUN:-true}"

set -euo pipefail

shopt -s globstar

main() {
    local COMMAND="${1}"
    shift

    case "${COMMAND}" in
        build) build "${@}" ;;
        sign) sign "${@}" ;;
        test) test_packages "${@}" ;;
        publish) publish "${@}" ;;
        publish_war) publish_war "${@}" ;;
    esac
}

build() {
    local RELEASE_NUM="1"

    bash packaging/scripts/circle-build.sh fetch_artifacts
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

test_packages() {
    bash packaging/scripts/circle-build.sh test
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
                publish
        done
    )
}

publish_war() {
    (
        cd packaging
        ./gradlew --info \
            -PpackageType=war \
            -PpackageOrg=rundeck \
            -PpackageRevision=1 \
            publishWar
    )
}

publish_to_s3() {
    (
        cd packaging
        # This is a flag that doesn't take a value
        S3_DRY_RUN="--dryrun"
        if [[ "$DRY_RUN" != true ]] ; then
            S3_DRY_RUN=""
        fi

        if [[ -n "${UPSTREAM_TAG}" ]] ; then
            for PACKAGE in deb rpm; do
                aws s3 sync "${S3_DRY_RUN}" --exclude=* --include=*.$PACKAGE packaging/build/distributions/ s3://download.rundeck.org/$PACKAGE/
            done
        fi
    )
}

main "${@}"
