#!/bin/bash

#######################################################
#                      _____     __  __
#           /\/\ /\/\ / __  \/\ / _\/__\
#           \ - \\ \ \\ \/ // // _\/  \
#            \/\/ \__/\_/\/ \__\__\\/\/ ⇒ 2025
#
#                  - Hustle Embedded -
#######################################################

PWD=`pwd`
BLOC=${PWD}/out

opt=$1

case $opt in
	toolchain)
		if [ ! -d $BLOC ];then
			mkdir -p $BLOC
		fi

		MAKEOBJDIRPREFIX=$BLOC tools/build/make.py --bootstrap-toolchain -j16 \
						 TARGET=arm64 TARGET_ARCH=aarch64 WITH_LLVM_TARGET_AARCH64=yes \
						 WITH_LLVM_TARGET_ARM=yes WITHOUT_LIB32=yes kernel-toolchain
		;;
	kernel)
		if [ ! -d $BLOC ];then
			mkdir -p $BLOC
		fi

		MAKEOBJDIRPREFIX=$BLOC tools/build/make.py --bootstrap-toolchain -j16 \
						 TARGET=arm64 TARGET_ARCH=aarch64 WITH_LLVM_TARGET_AARCH64=yes \
						 WITH_LLVM_TARGET_ARM=yes WITHOUT_LIB32=yes KERNCONF=DOMU buildkernel
		;;
	userspace)
		if [ ! -d $BLOC ];then
			mkdir -p $BLOC
		fi

		MAKEOBJDIRPREFIX=$BLOC tools/build/make.py --bootstrap-toolchain -j16 \
						 TARGET=arm64 TARGET_ARCH=aarch64 WITH_LLVM_TARGET_AARCH64=yes \
						 WITH_LLVM_TARGET_ARM=yes WITHOUT_LIB32=yes buildworld
		;;
	clean)
		rm -rf $BLOC
		;;
	*)
		echo "${0} userspace    - build userspace"
		echo "${0} toolchain    - build kernel toolchain"
		echo "${0} kernel       - build kernel"
		echo "${0} clean        - clean kernel"
		;;
esac
