#!/bin/bash

rm -r src/bundle/output
mkdir src/bundle/output/app -p
pushd src/function && zip -r ../bundle/output/app/function.zip . && popd
pushd logic && zip -r ../src/bundle/output/app/logic.zip . && popd
mkdir src/bundle/output/arm -p
cp -r src/arm src/bundle/output