#!/bin/bash
gitbook build
rm -rf ../frannyzhao.github.io/*
cp -rf _book/* ../frannyzhao.github.io/

