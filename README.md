## 描述
passwall 在urltest的时候可以多选和搜索节点

## 前提
必须已经安装passwall，最好已经启动使用外面的节点

## 版本
passwall 25.12.1-1版本

## 操作文件
- 更新luci-app-passwall/luasrc/model/cbi/passwall/client/type/sing-box.lua
- 更新luci-app-passwall/luasrc/passwall/util_sing-box.lua
- 添加luci-app-passwall/luasrc/view/passwall/cbi/urltest_multivalue.htm

## 使用方法
1、复制patch_passwall.sh到openwrt任意目录
2、chmod +x patch_passwall.sh
3、./patch_passwall.sh
