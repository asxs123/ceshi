#!/bin/bash
#
# Copyright (c) 2019-2023 SmallProgram <https://github.com/smallprogram>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/smallprogram/OpenWrtAction
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

rm -rf ${GITHUB_WORKSPACE}/openwrt/feeds/packages/net/xray-core
cp -Rf ${GITHUB_WORKSPACE}/openwrt/feeds/mypackages/xray-core ${GITHUB_WORKSPACE}/openwrt/feeds/packages/net/xray-core
# rm -rf ${GITHUB_WORKSPACE}/openwrt/feeds/packages/trojan-go
# rm -rf ${GITHUB_WORKSPACE}/openwrt/feeds/packages/v2ray-core
# rm -rf ${GITHUB_WORKSPACE}/openwrt/feeds/packages/v2ray-geodata

rm -rf ${GITHUB_WORKSPACE}/openwrt/feeds/third/luci-app-baidupcs-web

rm -rf ${GITHUB_WORKSPACE}/openwrt/feeds/third_party/luci-app-LingTiGameAcc

# 更换golang版本
rm -rf ${GITHUB_WORKSPACE}/openwrt/feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x ${GITHUB_WORKSPACE}/openwrt/feeds/packages/lang/golang
export GOPROXY=https://goproxy.io
export GO111MODULE=on

# 更换glib2版本及依赖
rm -rf ${GITHUB_WORKSPACE}/openwrt/feeds/packages/libs/glib2
cp -Rf ${GITHUB_WORKSPACE}/build/Share/glib2 ${GITHUB_WORKSPACE}/openwrt/feeds/packages/libs/glib2
rm -rf ${GITHUB_WORKSPACE}/openwrt/feeds/packages/libs/pcre2
cp -Rf ${GITHUB_WORKSPACE}/build/Share/pcre2 ${GITHUB_WORKSPACE}/openwrt/feeds/packages/libs/pcre2

if [[ ! -d "${GITHUB_WORKSPACE}/openwrt/feeds/packages/lang/rust" ]]; then
  cp -Rf ${GITHUB_WORKSPACE}/build/Share/rust ${GITHUB_WORKSPACE}/openwrt/feeds/packages/lang/rust
fi