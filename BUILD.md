# PassWall 打包指南

## 前置条件

1. 已配置好 OpenWrt SDK 环境
2. SDK 路径示例：`/home/user/openwrt-sdk`

## 打包步骤

### 1. 进入 SDK 目录

```bash
cd /home/user/openwrt-sdk
```

### 2. 复制整个 luci-app-passwall 到 package 目录

将本地修改的项目复制到 SDK，**并转换换行符**：

```bash
# 复制整个目录
cp -r /path/to/openwrt-passwall/luci-app-passwall package/

# 转换所有文件的换行符 (CRLF -> LF)
# find package/luci-app-passwall -type f \( -name "*.lua" -o -name "*.htm" -o -name "*.sh" -o -name "Makefile" -o -name "*.po" \) -exec sed -i 's/\r$//' {} \;

# 或使用 dos2unix（需要先安装: apt install dos2unix）
find package/luci-app-passwall -type f \( -name "*.lua" -o -name "*.htm" -o -name "*.sh" -o -name "Makefile" -o -name "*.po" \) -exec dos2unix {} \;
```

### 3. 更新 feeds（获取依赖）

```bash
./scripts/feeds update -a
./scripts/feeds install -a
```

### 4. 配置编译选项

```bash
make menuconfig
```

选择：
- `LuCI` -> `Applications` -> `luci-app-passwall`

### 5. 编译

```bash
make package/luci-app-passwall/compile V=s
```

### 6. 获取 ipk 文件

编译完成后，ipk 文件位于：

```bash
ls bin/packages/*/base/luci-app-passwall*.ipk
```

## 快速脚本

创建一键打包脚本 `build_passwall.sh`：

```bash
#!/bin/bash
SDK_PATH="/home/user/openwrt-sdk"
LOCAL_PATH="/path/to/openwrt-passwall/luci-app-passwall"

cd "$SDK_PATH"

# 复制项目
rm -rf package/luci-app-passwall
cp -r "$LOCAL_PATH" package/

# 转换换行符
find package/luci-app-passwall -type f \( -name "*.lua" -o -name "*.htm" -o -name "*.sh" -o -name "Makefile" -o -name "*.po" \) -exec sed -i 's/\r$//' {} \;

# 编译
make package/luci-app-passwall/compile V=s

# 显示结果
echo "=== 编译完成 ==="
find bin/packages -name "luci-app-passwall*.ipk" -ls
```

## 本次修改的文件清单

| 本地文件 | OpenWrt 目标路径 |
|---------|-----------------|
| `luasrc/passwall/util_sing-box.lua` | `/usr/lib/lua/luci/passwall/util_sing-box.lua` |
| `luasrc/model/cbi/passwall/client/type/sing-box.lua` | `/usr/lib/lua/luci/model/cbi/passwall/client/type/sing-box.lua` |
| `luasrc/view/passwall/cbi/urltest_multivalue.htm` | `/usr/lib/lua/luci/view/passwall/cbi/urltest_multivalue.htm` |

## feeds vs package 目录说明

| 方式 | 适用场景 |
|-----|---------|
| `package/` | 本地项目，直接放入即可编译，**推荐** |
| `feeds/` | 通过 feeds.conf.default 配置的远程仓库源 |
