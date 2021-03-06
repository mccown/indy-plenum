#!/bin/bash -xe

if [ "$1" = "--help" ] ; then
  echo "Usage: $0 <path-to-repo-folder> <release-version-dotted>"
  exit 0
fi

repo="$1"
version_dotted="$2"

pushd $repo

echo -e "\nSetting version to $version_dotted"
bash -ex ./bump_version.sh $version_dotted
cat plenum/__version__.json

echo -e "\nGenerating manifest"
bash -ex ./generate_manifest.sh
cat plenum/__manifest__.json

echo -e "\nAdapt the dependencies for the Canonical archive"
sed -i "s~ujson==1.33~ujson==1.33-1build1~" setup.py
sed -i "s~prompt_toolkit==0.57~prompt_toolkit==0.57-1~" setup.py
sed -i "s~msgpack-python==0.4.6~msgpack==0.4.6-1build1~" setup.py
popd

echo -e "\nFinished preparing $repo for publishing\n"
