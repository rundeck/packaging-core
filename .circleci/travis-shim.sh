#!/usr/bin/env bash
export TRAVIS_BRANCH=${CIRCLE_UPSTREAM_BRANCH:-}
export UPSTREAM_BUILD_NUMBER=${CIRCLE_UPSTREAM_PIPELINE_NUMBER:-}
export UPSTREAM_BRANCH=${CIRCLE_UPSTREAM_BRANCH:-}
export UPSTREAM_TAG=${CIRCLE_UPSTREAM_TAG:-}
export TRAVIS_BUILD_NUMBER=${CIRCLE_PIPELINE_NUM:-}
export TRAVIS_COMMIT=${CIRCLE_SHA1:-}

#S3_ARTIFACT_BASE="s3://rundeck-ci-artifacts/oss/circle/rundeck"
#ECR_IMAGE_PREFIX="circle"