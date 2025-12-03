#!/bin/sh
# PassWall URLTest 多选补丁一键安装脚本
# 适用于 PassWall 25.12.1 及以下版本
# GitHub: https://github.com/junhong-l/openwrt-passwall

DOWNLOAD_URL="https://github.com/junhong-l/openwrt-passwall/releases/download/25.12.1-1-patch/Edit.zip"
TMP_DIR="/tmp/passwall_patch"
ZIP_FILE="$TMP_DIR/Edit.zip"

# 目标路径
UTIL_SINGBOX="/usr/lib/lua/luci/passwall/util_sing-box.lua"
SINGBOX="/usr/lib/lua/luci/model/cbi/passwall/client/type/sing-box.lua"
URLTEST_HTM="/usr/lib/lua/luci/view/passwall/cbi/urltest_multivalue.htm"

echo "========================================"
echo "PassWall URLTest 多选补丁安装脚本"
echo "========================================"

# 检查依赖
if ! command -v wget >/dev/null 2>&1 && ! command -v curl >/dev/null 2>&1; then
    echo "错误: 需要 wget 或 curl"
    exit 1
fi

if ! command -v unzip >/dev/null 2>&1; then
    echo "正在安装 unzip..."
    opkg update && opkg install unzip
fi

# 创建临时目录
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

# 下载补丁文件
echo "正在下载补丁文件..."
if command -v curl >/dev/null 2>&1; then
    curl -L -o "$ZIP_FILE" "$DOWNLOAD_URL"
else
    wget -O "$ZIP_FILE" "$DOWNLOAD_URL"
fi

if [ ! -f "$ZIP_FILE" ]; then
    echo "错误: 下载失败"
    exit 1
fi

# 解压
echo "正在解压..."
cd "$TMP_DIR"
unzip -o "$ZIP_FILE"

# 查找解压后的文件目录
if [ -d "$TMP_DIR/Edit" ]; then
    PATCH_DIR="$TMP_DIR/Edit"
else
    PATCH_DIR="$TMP_DIR"
fi

# 创建目标目录（如果不存在）
mkdir -p "$(dirname "$URLTEST_HTM")"

# 替换文件
echo "正在替换文件..."
if [ -f "$PATCH_DIR/util_sing-box.lua" ]; then
    sed -i 's/\r$//' "$PATCH_DIR/util_sing-box.lua"
    cp "$PATCH_DIR/util_sing-box.lua" "$UTIL_SINGBOX"
    echo "  ✓ util_sing-box.lua"
else
    echo "  ✗ util_sing-box.lua 未找到"
fi

if [ -f "$PATCH_DIR/sing-box.lua" ]; then
    sed -i 's/\r$//' "$PATCH_DIR/sing-box.lua"
    cp "$PATCH_DIR/sing-box.lua" "$SINGBOX"
    echo "  ✓ sing-box.lua"
else
    echo "  ✗ sing-box.lua 未找到"
fi

if [ -f "$PATCH_DIR/urltest_multivalue.htm" ]; then
    sed -i 's/\r$//' "$PATCH_DIR/urltest_multivalue.htm"
    cp "$PATCH_DIR/urltest_multivalue.htm" "$URLTEST_HTM"
    echo "  ✓ urltest_multivalue.htm"
else
    echo "  ✗ urltest_multivalue.htm 未找到"
fi

# 清理 LuCI 缓存
echo "正在清理缓存..."
rm -rf /tmp/luci-*

# 清理临时文件
rm -rf "$TMP_DIR"

echo "========================================"
echo "补丁安装完成！"
echo "请刷新浏览器页面（Ctrl+F5）查看效果"
echo "========================================"
