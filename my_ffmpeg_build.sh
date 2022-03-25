#!/usr/bin/env bash
export ANDROID_SDK_HOME="/Users/cuishaobin/Library/Android/sdk"
export ANDROID_NDK_HOME="/Users/cuishaobin/Library/Android/sdk/ndk/21.4.7075529"

source ./ffmpeg-android-maker.sh --android-api-level=22 --source-tar=3.4.9 --target-abis=arm64-v8a,x86_64