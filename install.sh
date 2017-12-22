#!/usr/bin/env bash
SR_LIB=$(python -c "import speech_recognition as sr, os.path as p; print(p.dirname(sr.__file__))")
apt-get install --yes unzip
unzip -o zh-CN.zip -d "$SR_LIB"
mv -f $SR_LIB/pocketsphinx-data/* $SR_LIB
chmod --recursive a+r "$SR_LIB/zh-CN/"
