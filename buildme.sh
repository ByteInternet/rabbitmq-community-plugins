#!/bin/bash

set -e
set -x

if which git-dch; then
    GIT_DCH="git-dch"
elif which gbp; then
    GIT_DCH="gbp dch"
fi

if which git-buildpackage; then
    GIT_BUILD="git-buildpackage"
elif which gbp; then
    GIT_BUILD="gbp buildpackage"
fi


echo Updating changelog
export version=$(date "+%Y%m%d.%H%M")
$GIT_DCH --debian-tag="%(version)s" --new-version=$version --debian-branch master --release --commit

echo Building package
$GIT_BUILD --git-pbuilder --git-dist=wheezy --git-arch=amd64 --git-ignore-branch

echo Tagging and pushing tags
git tag $version
git push origin master
git push --tags
