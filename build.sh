#!/bin/bash
source "env.sh";

kernel_dir=${HOME}/EAS
export V="EAS-1.5"
export CONFIG_FILE="mido_defconfig"
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER=ReVaNtH
export KBUILD_BUILD_HOST=StRaKz
export TOOL_CHAIN_PATH="/home/travis/UBER/bin/aarch64-linux-android-"
export CLANG_TCHAIN="/home/travis/clang/clang-4679922/bin/clang"
export IMAGE2="${OUTDIR}/arch/${ARCH}/boot/Image.gz";
export CLANG_VERSION="$(${CLANG_TCHAIN} --version | head -n 1 | cut -d'(' -f1,4)"
export LD_LIBRARY_PATH="${TOOL_CHAIN_PATH}/../lib"
export PATH=$PATH:${TOOL_CHAIN_PATH}
export builddir="${kernel_dir}/mateng"
#export modules_dir="zip/system/lib/modules"
export ZIPPER_DIR="${kernel_dir}/zip"
export ZIP_NAME="StRaKz-KeRnEl™${V}_Oreo.zip"
export ZIPNAME="StRaKz-KeRnEl™${V}_Oreo.zip"
export FINAL_ZIP=${HOME}/EAS/zip/${ZIPNAME}
export IMAGE="arch/arm64/boot/Image.gz-dtb";
JOBS="-j8"
cd $kernel_dir
make clean && make mrproper

make_a_fucking_defconfig() {
	make $CONFIG_FILE
}

compile() {
	PATH=${BIN_FOLDER}:${PATH} make \
	O=${out_dir} \
	CC="${CLANG_TCHAIN}" \
	CLANG_TRIPLE=aarch64-linux-gnu- \
	CROSS_COMPILE=${TOOL_CHAIN_PATH} \
    KBUILD_COMPILER_STRING="${CLANG_VERSION}" \
	HOSTCC="${CLANG_TCHAIN}" \
    $JOBS
}

zipit () {
    if [[ ! -f "${IMAGE}" ]]; then
        echo -e "Build failed :P";
        exit 1;
    else
        echo -e "Build Succesful!";
    fi
    echo "**** Copying zImage ****"
    cp arch/arm64/boot/Image.gz-dtb ${ZIPPER_DIR}/tools/
    echo "**** Copying modules ****"

    cd ${ZIPPER_DIR}/
    zip -r9 ${ZIP_NAME} * -x README ${ZIP_NAME}
    rm -rf ${kernel_dir}/mateng/${ZIP_NAME}
    mv ${ZIPPER_DIR}/${ZIP_NAME} ${kernel_dir}/mateng/${ZIP_NAME}
}

make_a_fucking_defconfig
compile
cp -v "${IMAGE2}" "${HOME}/EAS/zip/";
cd ${HOME}/EAS/zip/;
zip -r9 ${FINAL_ZIP} *;
cd -;

if [ -f "$FINAL_ZIP" ];
then
echo -e "$ZIPNAME zip can be found at $FINAL_ZIP";
echo -e "Uploading ${ZIPNAME} to https://transfer.sh/";
transfer "${FINAL_ZIP}";
else
echo -e "Zip Creation Failed =(";
fi # FINAL_ZIP check
zipit
cd ${kernel_dir}
