#!/bin/bash

#######################################################
#                      _____     __  __
#           /\/\ /\/\ / __  \/\ / _\/__\
#           \ - \\ \ \\ \/ // // _\/  \
#            \/\/ \__/\_/\/ \__\__\\/\/ ⇒ 2025
#
#                  - Hustle Embedded -
#######################################################

WORKDIR=`pwd`
BLOC=${WORKDIR}/out

opt=$1

export TARGET=arm64
export TARGET_ARCH=aarch64
export KERNCONF=DOMU
export MAKEOBJDIRPREFIX=$BLOC
DESTDIR=$BLOC/install

echo ">>> KICK COMPILATION"
cat $WORKDIR/sys/bloc.ref

case $opt in
	toolchain)
		if [ ! -d $BLOC ];then
			mkdir -p $BLOC
		fi

		MAKEOBJDIRPREFIX=$MAKEOBJDIRPREFIX tools/build/make.py --debug --bootstrap-toolchain -j16 \
			TARGET=$TARGET TARGET_ARCH=$TARGET_ARCH \
			WITH_LLVM_TARGET_AARCH64=yes WITH_LLVM_TARGET_ARM=yes WITHOUT_LIB32=yes \
			WITHOUT_TESTS=yes NO_DOC=yes \
			kernel-toolchain
		;;
	kernel)
		if [ ! -d $BLOC ];then
			mkdir -p $BLOC
		fi

		MAKEOBJDIRPREFIX=$MAKEOBJDIRPREFIX tools/build/make.py --debug --bootstrap-toolchain -j16 \
			TARGET=$TARGET TARGET_ARCH=$TARGET_ARCH KERNCONF=$KERNCONF \
			WITH_LLVM_TARGET_AARCH64=yes WITH_LLVM_TARGET_ARM=yes WITHOUT_LIB32=yes \
			WITHOUT_TESTS=yes NO_DOC=yes \
			buildkernel
		;;
	userspace)
		if [ ! -d $BLOC ];then
			mkdir -p $BLOC
		fi

		MAKEOBJDIRPREFIX=$MAKEOBJDIRPREFIX tools/build/make.py --debug --bootstrap-toolchain -j16 \
			TARGET=$TARGET TARGET_ARCH=$TARGET_ARCH \
			WITH_LLVM_TARGET_AARCH64=yes WITH_LLVM_TARGET_ARM=yes WITHOUT_LIB32=yes \
			WITHOUT_TESTS=yes NO_DOC=yes \
			buildworld
		;;
	install)
		if [ ! -d $DESTDIR ];then
			mkdir -p $DESTDIR
		fi

		MAKEOBJDIRPREFIX=$MAKEOBJDIRPREFIX tools/build/make.py --debug --bootstrap-toolchain -j16 \
			TARGET=$TARGET TARGET_ARCH=$TARGET_ARCH KERNCONF=$KERNCONF \
			WITH_LLVM_TARGET_AARCH64=yes WITH_LLVM_TARGET_ARM=yes WITHOUT_LIB32=yes \
			WITHOUT_TESTS=yes NO_DOC=yes \
			DESTDIR=$DESTDIR installkernel

		MAKEOBJDIRPREFIX=$MAKEOBJDIRPREFIX tools/build/make.py --debug --bootstrap-toolchain -j16 \
			TARGET=$TARGET TARGET_ARCH=$TARGET_ARCH KERNCONF=$KERNCONF \
			WITH_LLVM_TARGET_AARCH64=yes WITH_LLVM_TARGET_ARM=yes WITHOUT_LIB32=yes \
			WITHOUT_TESTS=yes NO_DOC=yes \
			DESTDIR=$DESTDIR installworld
		;;
	remove)
		rm -rf $BLOC
		;;
	*)
		echo "${0} userspace    - build userspace + toolchain (time-consuming)"
		echo "${0} toolchain    - build kernel toolchain (only)"
		echo "${0} kernel       - build kernel"
		echo "${0} install      - install kernel + userspace"
		echo "${0} remove       - remove all built targets (toolchains + userspace + kernel) [cautious]"
		;;
esac

echo
echo ">>> DONE COMPILATION"
