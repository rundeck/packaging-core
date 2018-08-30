#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

set -xeuo pipefail

shopt -s globstar

main() {
    local COMMAND="${1}"
    shift

    case "${COMMAND}" in
        build) build "${@}" ;;
        publish) publish "${@}" ;;
    esac
}

build() {
    bash packaging/scripts/travis-build.sh build
}

publish() {
    (
        cd packaging
        ./gradlew --info \
            -PpackageOrg=rundeck \
            -PpackageRevision=1 \
            bintrayUpload
    )
}

main "${@}"