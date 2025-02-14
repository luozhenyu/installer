#!/usr/bin/env bash
set -euxo pipefail

# Copy build scripts into a directory within the container. Avoids polluting the mounted
# directory and permission errors.
mkdir /home/builder/workspace
cp -R /home/builder/build/generated/packaging /home/builder/workspace

# Build package and set distributions it supports.
# $VERSIONS are container env. variables
cd /home/builder/workspace/packaging
dpkg-buildpackage -us -uc -b
changestool /home/builder/workspace/*.changes setdistribution ${VERSIONS}

# Copy resulting files into mounted directory where artifacts should be placed.
mv /home/builder/workspace/*.{deb,changes,buildinfo} /home/builder/out
