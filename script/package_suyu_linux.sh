#!/bin/bash -ex
cd ${WORKSPACE}/suyu/build
for EXE in suyu; do
    EXE_PATH="bin/$EXE"
    # Copy debug symbols out
    objcopy --only-keep-debug $EXE_PATH $EXE_PATH.debug
    # Add debug link and strip debug symbols
    objcopy -g --add-gnu-debuglink=$EXE_PATH.debug $EXE_PATH $EXE_PATH.out
    # Overwrite original with stripped copy
    mv $EXE_PATH.out $EXE_PATH
done

find bin/ -type f -not -regex '.*.debug' -exec strip -g {} ';'

DESTDIR="$PWD/AppDir" ninja install
rm -vf AppDir/usr/bin/suyu-cmd AppDir/usr/bin/suyu-tester

# Download tools needed to build an AppImage
wget -nc https://gitlab.com/suyu-emu/ext-linux-bin/-/raw/main/appimage/deploy-linux.sh
wget -nc https://gitlab.com/suyu-emu/ext-linux-bin/-/raw/main/appimage/exec-x86_64.so
wget -nc https://gitlab.com/suyu-emu/AppImageKit-checkrt/-/raw/old/AppRun.sh

chmod 755 \
    deploy-linux.sh \
    AppRun.sh \
    exec-x86_64.so \

export APPIMAGE_EXTRACT_AND_RUN=1

mkdir -p AppDir/usr/optional
mkdir -p AppDir/usr/optional/libstdc++
mkdir -p AppDir/usr/optional/libgcc_s

# Deploy suyu's needed dependencies
DEPLOY_QT=1 ./deploy-linux.sh AppDir/usr/bin/suyu AppDir

# Workaround for libQt5MultimediaGstTools indirectly requiring libwayland-client and breaking Vulkan usage on end-user systems
find AppDir -type f -regex '.*libwayland-client\.so.*' -delete -print

# Workaround for building suyu with GCC 10 but also trying to distribute it to Ubuntu 18.04 et al.
# See https://github.com/darealshinji/AppImageKit-checkrt
cp exec-x86_64.so AppDir/usr/optional/exec.so
cp AppRun.sh AppDir/AppRun
cp --dereference /usr/lib/x86_64-linux-gnu/libstdc++.so.6 AppDir/usr/optional/libstdc++/libstdc++.so.6
cp --dereference /lib/x86_64-linux-gnu/libgcc_s.so.1 AppDir/usr/optional/libgcc_s/libgcc_s.so.1

####################################################

cd ${WORKSPACE}/suyu

GITDATE=$DATE
GITREV=$VERSION
ARTIFACTS_DIR="$PWD/artifacts"
RELEASE_NAME=${RELEASE_TYPE}

mkdir -p "${ARTIFACTS_DIR}/"

APPIMAGE_NAME="suyu-linux-${RELEASE_NAME}-${GITDATE}-${GITREV}.AppImage"
BASE_NAME="suyu-linux"
REV_NAME="${BASE_NAME}-${GITDATE}-${GITREV}"
ARCHIVE_NAME="${REV_NAME}.tar.xz"
COMPRESSION_FLAGS="-cJvf"

DIR_NAME="${BASE_NAME}-${RELEASE_NAME}"

mkdir "$DIR_NAME"

cp build/bin/suyu-cmd "$DIR_NAME"
if [ "${RELEASE_NAME}" != "early-access" ] && [ "${RELEASE_NAME}" != "mainline" ]; then
    cp build/bin/suyu "$DIR_NAME"
fi

# Build an AppImage
cd build

wget -nc https://gitlab.com/suyu-emu/ext-linux-bin/-/raw/main/appimage/appimagetool-x86_64.AppImage
chmod 755 appimagetool-x86_64.AppImage

# if FUSE is not available, then fallback to extract and run
if ! ./appimagetool-x86_64.AppImage --version; then
    export APPIMAGE_EXTRACT_AND_RUN=1
fi

# Don't let AppImageLauncher ask to integrate EA
if [ "${RELEASE_NAME}" = "mainline" ] || [ "${RELEASE_NAME}" = "early-access" ]; then
    echo "X-AppImage-Integrate=false" >> AppDir/dev.suyu_emu.suyu.desktop
fi

./appimagetool-x86_64.AppImage AppDir "${APPIMAGE_NAME}"
echo "AppImage created: ${PWD}/${APPIMAGE_NAME}"
cd ..

# Copy the AppImage and update info to the artifacts directory and avoid compressing it
cp "build/${APPIMAGE_NAME}" "${ARTIFACTS_DIR}/"
if [ -f "build/${APPIMAGE_NAME}.zsync" ]; then
    cp "build/${APPIMAGE_NAME}.zsync" "${ARTIFACTS_DIR}/"
fi

# Copy the AppImage to the general release directory and remove git revision info
if [ "${RELEASE_NAME}" = "mainline" ] || [ "${RELEASE_NAME}" = "early-access" ]; then
    echo "Copying AppImage to release directory"
    cp "build/${APPIMAGE_NAME}" "${DIR_NAME}/suyu-${RELEASE_NAME}.AppImage"
fi

cp "build/${APPIMAGE_NAME}" "${WORKSPACE}/"