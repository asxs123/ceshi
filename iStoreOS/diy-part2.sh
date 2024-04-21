#!/bin/bash
#
# Copyright (c) 2019-2023 SmallProgram <https://github.com/smallprogram>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/smallprogram/OpenWrtAction
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

is_wsl2op=$1

# Modify default IP
sed -i 's/192.168.1.1/192.168.1.3/g' package/base-files/files/bin/config_generate

# 修改主机名字，把 iStore OS 修改你喜欢的就行（不能纯数字或者使用中文）
# sed -i 's/OpenWrt/iStore OS/g' package/base-files/files/bin/config_generate

###### 取消bootstrap为默认主题 ######
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

rm -rf ./package/lean/luci-app-adguardhome
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git ./package/lean/luci-app-adguardhome

git clone https://github.com/sirpdboy/luci-app-ddns-go.git ./package/ddns-go

git clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git ./package/luci-app-unblockneteasemusic

# mosdns
# drop mosdns and v2ray-geodata packages that come with the source
find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
find ./ | grep Makefile | grep mosdns | xargs rm -f
rm -rf ./feeds/luci/applications/luci-app-mosdns/
rm -rf ./feeds/packages/net/mosdns/
rm -rf ./package/custom_packages/mosdns
rm -rf ./feeds/packages/net/v2ray-geodata/
git clone https://github.com/sbwml/luci-app-mosdns -b v5 ./package/custom_packages/mosdns
git clone https://github.com/sbwml/v2ray-geodata ./package/custom_packages/v2ray-geodata

# rm -rf ./feeds/packages/lang/golang
# git clone https://github.com/sbwml/packages_lang_golang -b 20.x ./feeds/packages/lang/golang
# git clone https://github.com/sbwml/luci-app-alist ./package/alist


# if [ ! -d "./package/lean/luci-app-argon-config" ]; then git clone -b 18.06 https://github.com/jerrykuku/luci-app-argon-config.git ./package/lean/luci-app-argon-config;   else cd ./package/lean/luci-app-argon-config; git stash; git stash drop; git pull; cd ..; cd ..; cd ..; fi;
# if [ ! -d "./package/lean/luci-app-adguardhome" ]; then git clone https://github.com/rufengsuixing/luci-app-adguardhome.git ./package/lean/luci-app-adguardhome;   else cd ./package/lean/luci-app-adguardhome; git stash; git stash drop; git pull; cd ..; cd ..; cd ..; fi;
# git clone https://github.com/jerrykuku/lua-maxminddb.git
# git clone https://github.com/jerrykuku/luci-app-vssr.git
# git clone https://github.com/lisaac/luci-app-dockerman.git


# Reset drive type
# sed -i 's/(dmesg | grep .*/{a}${b}${c}${d}${e}${f}/g' package/lean/autocore/files/x86/autocore
# sed -i '/h=${g}.*/d' package/lean/autocore/files/x86/autocore
# sed -i 's/echo $h/echo $g/g' package/lean/autocore/files/x86/autocore

# Close running yards
# sed -i 's/console=tty0//g'  target/linux/x86/image/Makefile


rm -rf ./feeds/third/luci-theme-argon/htdocs/luci-static/argon/background/
mkdir -p ./feeds/third/luci-theme-argon/htdocs/luci-static/argon/background/

if [ ! -n "$is_wsl2op" ]; then
    # Add default login background
    cp -r $GITHUB_WORKSPACE/source/video/* ./feeds/third/luci-theme-argon/htdocs/luci-static/argon/background/
    cp -r $GITHUB_WORKSPACE/source/img/* ./feeds/third/luci-theme-argon/htdocs/luci-static/argon/background/

    # Inject download package
    mkdir -p $GITHUB_WORKSPACE/openwrt/dl
    cp -r $GITHUB_WORKSPACE/library/* $GITHUB_WORKSPACE/openwrt/dl/

    # Fixed qmi_wwan_f complie error
    # cp -r $GITHUB_WORKSPACE/patches/qmi_wwan_f.c $GITHUB_WORKSPACE/openwrt/package/wwan/driver/fibocom_QMI_WWAN/src/qmi_wwan_f.c

else
    # Add default login background
    cp -r /home/$USER/OpenWrtAction/source/video/* ./feeds/third/luci-theme-argon/htdocs/luci-static/argon/background/
    cp -r /home/$USER/OpenWrtAction/source/img/* ./feeds/third/luci-theme-argon/htdocs/luci-static/argon/background/

    # Inject download package
    mkdir -p dl
    cp -r /home/$USER/OpenWrtAction/library/* dl/

    # Fixed qmi_wwan_f complie error
    # cp -r ../OpenWrtAction/patches/qmi_wwan_f.c ./package/wwan/driver/fibocom_QMI_WWAN/src/qmi_wwan_f.c
fi

echo -e "预置Clash内核"
mkdir -p feeds/OpenClash/luci-app-openclash/root/etc/openclash/core
core_path="feeds/OpenClash/luci-app-openclash/root/etc/openclash/core"
# goe_path="luci-app-openclash/root/etc/openclash"

CLASH_DEV_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/dev/clash-linux-amd64.tar.gz"
# CLASH_TUN_URL=$(curl -fsSL https://api.github.com/repos/vernesong/OpenClash/contents/master/premium\?ref\=core | grep download_url | grep $1 | awk -F '"' '{print $4}' | grep "v3" )
CLASH_TUN_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/premium/clash-linux-amd64-$(curl -fsSL https://raw.githubusercontent.com/vernesong/OpenClash/core/master/core_version | grep -v "^v\|^V\|^a" | grep -E "[0-9]+.[0-9]+.[0-9]+").gz"
echo -e $CLASH_TUN_URL
CLASH_META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-amd64.tar.gz"
# GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
# GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"

wget -qO- $CLASH_DEV_URL | tar xOvz > $core_path/clash
wget -qO- $CLASH_TUN_URL | gunzip -c > $core_path/clash_tun
wget -qO- $CLASH_META_URL | tar xOvz > $core_path/clash_meta
# wget -qO- $GEOIP_URL > $goe_path/GeoIP.dat
# wget -qO- $GEOSITE_URL > $goe_path/GeoSite.dat

chmod +x $core_path/clash*


echo -e "预置adguardhome内核"

rm -rf package/lean/luci-app-adguardhome/root/usr/bin/AdGuardHome
mkdir -p package/lean/luci-app-adguardhome/root/usr/bin
adgcore="package/lean/luci-app-adguardhome/root/usr/bin"

# ADG_CORE_URL="https://github.com/AdguardTeam/AdGuardHome/releases/download/$(uclient-fetch -qO- 'https://api.github.com/repos/AdguardTeam/AdGuardHome/releases' | jsonfilter -e '@[0].tag_name')/AdGuardHome_linux_amd64.tar.gz"
ADG_CORE_URL="https://github.com/AdguardTeam/AdGuardHome/releases/download/$(curl -s 'https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest' | grep -E 'tag_name' | grep -E 'v[0-9.]+' -o 2>/dev/null)/AdGuardHome_linux_amd64.tar.gz"
echo -e $ADG_CORE_URL
wget -qO- $ADG_CORE_URL
if [[ -f "AdGuardHome_amd64.tar.gz" ]]; then
  tar -zxvf AdGuardHome_amd64.tar.gz -C $adgcore
  echo "核心下载成功"
else
  echo "下载核心失败"
fi
if [[ -f "$adgcore/AdGuardHome/AdGuardHome" ]]; then
  sudo chmod +x $adgcore/AdGuardHome/AdGuardHome
  echo "增加AdGuardHome核心完成"
else
  echo "增加AdGuardHome核心失败"
fi


echo -e "预置unblockneteasemusic内核"
NAME="package/luci-app-unblockneteasemusic/root/usr/share/unblockneteasemusic" && mkdir -p $NAME/core
# echo "$(uclient-fetch -qO- 'https://api.github.com/repos/UnblockNeteaseMusic/server/commits?sha=enhanced&path=precompiled' | jsonfilter -e '@[0].sha')">"$NAME/core_local_ver"
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/precompiled/app.js -o $NAME/core/app.js
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/precompiled/bridge.js -o $NAME/core/bridge.js
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/ca.crt -o $NAME/core/ca.crt
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/server.crt -o $NAME/core/server.crt
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/server.key -o $NAME/core/server.key