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

echo ">>> KICK COMPILATION"
cat $WORKDIR/sys/bloc.ref

case $opt in
	toolchain)
		if [ ! -d $BLOC ];then
			mkdir -p $BLOC
		fi

		tools/build/make.py --debug --bootstrap-toolchain -j16 \
			TARGET=$TARGET TARGET_ARCH=$TARGET_ARCH \
			WITH_LLVM_TARGET_AARCH64=yes WITH_LLVM_TARGET_ARM=yes WITHOUT_LIB32=yes \
			kernel-toolchain
		;;
	kernel)
		if [ ! -d $BLOC ];then
			mkdir -p $BLOC
		fi

		tools/build/make.py --debug --bootstrap-toolchain -j16 \
			TARGET=$TARGET TARGET_ARCH=$TARGET_ARCH KERNCONF=$KERNCONF \
			WITH_LLVM_TARGET_AARCH64=yes WITH_LLVM_TARGET_ARM=yes WITHOUT_LIB32=yes \
			buildkernel

		if [ ! -d $BLOC/kernel ];then
			mkdir -p $BLOC/kernel
		fi

		if [ -e $BLOC$WORKDIR/$TARGET.$TARGET_ARCH/sys/$KERNCONF/kernel ];then
			cp $BLOC$WORKDIR/$TARGET.$TARGET_ARCH/sys/$KERNCONF/kernel* $BLOC/kernel -rf
			echo ">>> kernel copied under $BLOC/kernel."
			echo "--------------------------------------------------------------"
		fi

		;;
	userspace)
		if [ ! -d $BLOC ];then
			mkdir -p $BLOC
		fi

		tools/build/make.py --debug --bootstrap-toolchain -j16 \
			TARGET=$TARGET TARGET_ARCH=$TARGET_ARCH \
			WITH_LLVM_TARGET_AARCH64=yes WITH_LLVM_TARGET_ARM=yes WITHOUT_LIB32=yes \
			buildworld
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

echo
echo ">>> DONE COMPILATION"
