export TRAVIS_BRANCH=${CIRCLE_BRANCH:-}
export TRAVIS_TAG=${CIRCLE_TAG:-}
export TRAVIS_BUILD_NUMBER=${CIRCLE_PIPELINE_NUM:-}
export TRAVIS_COMMIT=${CIRCLE_SHA1:-}

export UPSTREAM_BUILD_NUMBER=${CIRCLE_UPSTREAM_PIPELINE_NUMBER:-}
export UPSTREAM_BRANCH=${CIRCLE_UPSTREAM_BRANCH:-}
export UPSTREAM_TAG=${CIRCLE_UPSTREAM_TAG:-}

export PRO_S3_ARTIFACT_BASE="s3://rundeck-ci-artifacts/pro/circle"

export S3_ARTIFACT_BASE="s3://rundeck-ci-artifacts/oss/circle/rundeck"
export RDPRO_S3_ARTIFACT_BASE="s3://rundeck-ci-artifacts/pro/circle/rundeckpro"
export ECR_IMAGE_PREFIX="circle"

export ECR_REPO=481311893001.dkr.ecr.us-west-2.amazonaws.com/rundeckpro/enterprise