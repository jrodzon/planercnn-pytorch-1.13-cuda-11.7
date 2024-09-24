#!/bin/bash

WORKDIR="roi_align_installation"
GITHUB_URL="https://github.com/longcw/RoIAlign.pytorch"

mkdir $WORKDIR

git clone $GITHUB_URL $WORKDIR

cd $WORKDIR

python setup.py install
./test.sh

cd ..
rm -rf $WORKDIR
