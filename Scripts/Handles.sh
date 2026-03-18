#!/bin/bash

PKG_PATH="$GITHUB_WORKSPACE/wrt/package/"

# 1. 修改 qca-nss-drv 启动顺序 
NSS_DRV="../feeds/nss_packages/qca-nss-drv/files/qca-nss-drv.init"
if [ -f "$NSS_DRV" ]; then
    echo "正在修复 qca-nss-drv 启动顺序..."
    sed -i 's/START=.*/START=85/g' $NSS_DRV
    echo "qca-nss-drv has been fixed!"
fi

# 2. 修改 qca-nss-pbuf 启动顺序 
NSS_PBUF="./kernel/mac80211/files/qca-nss-pbuf.init"
if [ -f "$NSS_PBUF" ]; then
    echo "正在修复 qca-nss-pbuf 启动顺序..."
    sed -i 's/START=.*/START=86/g' $NSS_PBUF
    echo "qca-nss-pbuf has been fixed!"
fi

# 3. 修复 Rust 编译失败 
RUST_FILE=$(find ../feeds/packages/ -maxdepth 3 -type f -wholename "*/rust/Makefile")
if [ -f "$RUST_FILE" ]; then
    echo "正在修复 Rust 编译环境..."
    sed -i 's/ci-llvm=true/ci-llvm=false/g' $RUST_FILE
    echo "rust has been fixed!"
fi

# 4. 修复 DiskMan 编译失败 (重点修复逻辑) 
DM_FILE="./luci-app-diskman/applications/luci-app-diskman/Makefile"
if [ -f "$DM_FILE" ]; then
    echo "正在修复 DiskMan 依赖冲突..."
    
    # 使用 \b 确保精确匹配 fs-ntfs，防止重复替换为 ntfs33
    sed -i 's/\bfs-ntfs\b/fs-ntfs3/g' $DM_FILE
    
    # 删除旧的工具依赖 
    sed -i '/ntfs-3g-utils /d' $DM_FILE
    
    echo "diskman has been fixed!"
fi

# 返回包目录确认状态
cd $PKG_PATH
