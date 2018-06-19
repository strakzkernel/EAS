#!/bin/bash
source "env.sh";

sudo apt-get update -y
sudo add-apt-repository --yes ppa:webupd8team/java
sudo apt-get install oracle-java9-installer
sudo apt install oracle-java9-set-default
sudo apt-get install -y libncurses5-dev
sudo apt-get install -y git-core gnupg flex bison gperf
sudo apt-get install -y build-essential
sudo apt-get install -y zip
sudo apt-get install -y curl 
sudo apt-get install -y libc6-dev
sudo apt-get install -y libncurses5-dev:i386 
sudo apt-get install -y x11proto-core-dev libx11-dev:i386 libreadline6-dev:i386
sudo apt-get install -y libgl1-mesa-glx:i386 libgl1-mesa-dev 
sudo apt-get install -y g++-multilib tofrodos python-markdown
sudo apt-get install -y libxml2-utils xsltproc zlib1g-dev:i386
sudo  ln -s /usr/lib/i386-linux-gnu/mesa/libGL.so.1 /usr/lib/i386-linux-gnu/libGL.so
sudo apt-get install -y ccache &&echo 'export PATH="/usr/lib/ccache:$PATH"' | tee -a ~/.bashrc &&source ~/.bashrc && echo $PATH
export USE_CCACHE=1
export ARCH=arm64
export KD=$HOME/EAS
cd $HOME/EAS

kernel_dir=${HOME}/SK
export V="-😂🐼-v7-EAS"
export CONFIG_FILE="strakz_defconfig"
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER=ReVaNtH
export KBUILD_BUILD_HOST=StRaKz
export TOOL_CHAIN_PATH="${HOME}/gcc8opt/bin/aarch64-opt-linux-android-"
export CLANG_TCHAIN="${HOME}/clang/bin/clang"
export IMAGE2="${OUTDIR}/arch/${ARCH}/boot/Image.gz";
export CLANG_VERSION="$(${CLANG_TCHAIN} --version | head -n 1 | cut -d'(' -f1,4)"
export LD_LIBRARY_PATH="${TOOL_CHAIN_PATH}/../lib"
export PATH=$PATH:${TOOL_CHAIN_PATH}
export builddir="${kernel_dir}/SK/anykernel"
#export modules_dir="zip/system/lib/modules"
export ZIPPER_DIR="${kernel_dir}/zip"
export ZIP_NAME="StRaKz-KeRnEl™${V}_Oreo.zip"
export ZIPNAME="StRaKz-KeRnEl™${V}_Oreo.zip"
export FINAL_ZIP=${HOME}/SK/SK/anykernel/${ZIPNAME}
export IMAGE="arch/arm64/boot/Image.gz-dtb";
JOBS="-j4"
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
    rm -rf ${kernel_dir}/SK/anykernel/${ZIP_NAME}
    mv ${ZIPPER_DIR}/${ZIP_NAME} ${kernel_dir}/SK/anykernel/${ZIP_NAME}
}

make_a_fucking_defconfig
compile
cp -v "${IMAGE2}" "${HOME}/SK/anykernel/";
cd ${HOME}/SK/anykernel/;
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
