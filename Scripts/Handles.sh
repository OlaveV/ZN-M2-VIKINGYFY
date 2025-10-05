#!/bin/bash

PKG_PATH="$GITHUB_WORKSPACE/wrt/package/"

#修改qca-nss-drv启动顺序
NSS_DRV="../feeds/nss_packages/qca-nss-drv/files/qca-nss-drv.init"
if [ -f "$NSS_DRV" ]; then
	echo " "

	sed -i 's/START=.*/START=85/g' $NSS_DRV

	cd $PKG_PATH && echo "qca-nss-drv has been fixed!"
fi

#修改qca-nss-pbuf启动顺序
NSS_PBUF="./kernel/mac80211/files/qca-nss-pbuf.init"
if [ -f "$NSS_PBUF" ]; then
	echo " "

	sed -i 's/START=.*/START=86/g' $NSS_PBUF

	cd $PKG_PATH && echo "qca-nss-pbuf has been fixed!"
fi

#修复Rust编译失败
RUST_FILE=$(find ../feeds/packages/ -maxdepth 3 -type f -wholename "*/rust/Makefile")
if [ -f "$RUST_FILE" ]; then
	echo " "

	sed -i 's/ci-llvm=true/ci-llvm=false/g' $RUST_FILE

	cd $PKG_PATH && echo "rust has been fixed!"
fi

#修复DiskMan编译失败
DM_FILE="./luci-app-diskman/applications/luci-app-diskman/Makefile"
if [ -f "$DM_FILE" ]; then
	echo " "

	sed -i 's/fs-ntfs/fs-ntfs3/g' $DM_FILE
	sed -i '/ntfs-3g-utils /d' $DM_FILE

	cd $PKG_PATH && echo "diskman has been fixed!"
fi
