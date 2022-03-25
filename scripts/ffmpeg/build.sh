#!/usr/bin/env bash

case $ANDROID_ABI in
  x86)
    # Disabling assembler optimizations, because they have text relocations
    EXTRA_BUILD_CONFIGURATION_FLAGS=--disable-asm
    ;;
  x86_64)
    EXTRA_BUILD_CONFIGURATION_FLAGS=--x86asmexe=${FAM_YASM}
    ;;
esac

if [ "$FFMPEG_GPL_ENABLED" = true ] ; then
    EXTRA_BUILD_CONFIGURATION_FLAGS="$EXTRA_BUILD_CONFIGURATION_FLAGS --enable-gpl"
fi

# Preparing flags for enabling requested libraries
ADDITIONAL_COMPONENTS=
for LIBARY_NAME in ${FFMPEG_EXTERNAL_LIBRARIES[@]}
do
  ADDITIONAL_COMPONENTS+=" --enable-$LIBARY_NAME"
done

# Referencing dependencies without pkgconfig
DEP_CFLAGS="-I${BUILD_DIR_EXTERNAL}/${ANDROID_ABI}/include"
DEP_LD_FLAGS="-L${BUILD_DIR_EXTERNAL}/${ANDROID_ABI}/lib $FFMPEG_EXTRA_LD_FLAGS"

./configure \
  --prefix=${BUILD_DIR_FFMPEG}/${ANDROID_ABI} \
  --enable-cross-compile \
  --target-os=android \
  --arch=${TARGET_TRIPLE_MACHINE_ARCH} \
  --sysroot=${SYSROOT_PATH} \
  --cc=${FAM_CC} \
  --cxx=${FAM_CXX} \
  --ld=${FAM_LD} \
  --ar=${FAM_AR} \
  --as=${FAM_CC} \
  --nm=${FAM_NM} \
  --ranlib=${FAM_RANLIB} \
  --strip=${FAM_STRIP} \
  --extra-cflags="-O3 -fPIC $DEP_CFLAGS" \
  --extra-ldflags="$DEP_LD_FLAGS" \
  --enable-shared \
  --enable-static \
  --disable-runtime-cpudetect \
  --disable-debug \
  --disable-stripping \
  --disable-ffmpeg \
  --disable-ffplay \
  --disable-ffserver \
  --disable-ffprobe \
  --disable-encoders \
  --disable-muxers \
  --disable-devices \
  --disable-protocols \
  --enable-avfilter \
  --disable-network \
  --enable-avdevice \
  --disable-asm \
  --disable-filters \
  --enable-filter=crop \
  --disable-decoders \
  --enable-version3 \
  --enable-gpl \
  --enable-nonfree \
  --enable-neon \
  --enable-protocol=file \
  --enable-swscale \
  --disable-demuxers \
  --enable-demuxer=flv \
  --enable-demuxer=h261 \
  --enable-demuxer=h263 \
  --enable-demuxer=h264 \
  --enable-demuxer=hevc \
  --enable-demuxer=m4v \
  --enable-demuxer=mov \
  --enable-demuxer=mpegps \
  --enable-demuxer=mpegts \
  --enable-demuxer=mpegtsraw \
  --enable-demuxer=mpegvideo \
  --enable-decoder=h264 \
  --enable-decoder=mpeg4 \
  --enable-decoder=hevc \
  --enable-decoder=hevc_mediacodec \
  --disable-parsers \
  --enable-parser=h264 \
  --enable-parser=mpeg4video \
  --enable-parser=mpegvideo \
  --enable-asm \
  --enable-neon \
  --disable-xlib \
  --disable-zlib \
  --disable-v4l2_m2m \
  --enable-jni \
  --enable-mediacodec \
  --enable-decoder=hevc_mediacodec \
  --enable-decoder=mpeg2_mediacodec \
  --enable-decoder=mpeg4_mediacodec \
  --enable-decoder=h264_mediacodec \
  --disable-hwaccels \
  --enable-hwaccel=hevc_mediacodec \
  --enable-hwaccel=mpeg2_mediacodec \
  --enable-hwaccel=mpeg4_mediacodec \
  --enable-hwaccel=h264_mediacodec \
  --disable-bsfs \
  --enable-bsf=dump_extradata \
  --enable-bsf=extract_extradata \
  --enable-bsf=h264_mp4toannexb \
  --enable-bsf=hevc_mp4toannexb \
  --enable-bsf=imx_dump_header \
  --enable-bsf=mov2textsub \
  --enable-bsf=mpeg4_unpack_bframes \
  --enable-bsf=remove_extradata \
  --enable-bsf=text2movsub \
  --enable-encoder=mjpeg \
  --disable-indev=v4l2 \
  --pkg-config=${PKG_CONFIG_EXECUTABLE} \
  ${EXTRA_BUILD_CONFIGURATION_FLAGS} \
  $ADDITIONAL_COMPONENTS || exit 1

${MAKE_EXECUTABLE} clean
${MAKE_EXECUTABLE} -j${HOST_NPROC}
${MAKE_EXECUTABLE} install
