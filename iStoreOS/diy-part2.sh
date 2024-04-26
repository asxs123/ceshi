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

# 修改默认 IP，把 192.168.1.3 修改你的就行
sed -i 's/192.168.1.1/192.168.1.3/g' package/base-files/files/bin/config_generate

# 修改主机名字，把 iStore OS 修改你喜欢的就行（不能纯数字或者使用中文）
# sed -i 's/OpenWrt/iStore OS/g' package/base-files/files/bin/config_generate

###### 取消bootstrap为默认主题 ######
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile



# 添加adguardhome
rm -rf ./package/lean/luci-app-adguardhome
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git ./package/lean/luci-app-adguardhome
# 添加ddns-go
git clone https://github.com/sirpdboy/luci-app-ddns-go.git ./package/ddns-go
# 添加unblockneteasemusic
git clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git ./package/luci-app-unblockneteasemusic



# # 因为部分软件包需要用到 upx，而官方 SDK 镜像中没有包含，所以自行安装
# sudo apt-get update
# sudo apt-get install upx -y
# cp /usr/bin/upx staging_dir/host/bin
# cp /usr/bin/upx-ucl staging_dir/host/bin

# 更换golang版本
rm -rf ${GITHUB_WORKSPACE}/openwrt/feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x ${GITHUB_WORKSPACE}/openwrt/feeds/packages/lang/golang

# # 更换glib2版本及依赖
# rm -rf ${HOME_PATH}/feeds/packages/libs/glib2
# cp -Rf ${HOME_PATH}/build/common/Share/glib2 ${HOME_PATH}/feeds/packages/libs/glib2
# rm -rf ${HOME_PATH}/feeds/packages/libs/pcre2
# cp -Rf ${HOME_PATH}/build/common/Share/pcre2 ${HOME_PATH}/feeds/packages/libs/pcre2




# 判断CPU架构
if [[ `grep -c "CONFIG_ARCH=\"x86_64\"" ${GITHUB_WORKSPACE}/openwrt/.config` -eq '1' ]]; then
  Arch="linux_amd64"
  Archclash="linux-amd64"
  echo "CPU架构：amd64"
elif [[ `grep -c "CONFIG_ARCH=\"i386\"" ${GITHUB_WORKSPACE}/openwrt/.config` -eq '1' ]]; then
  Arch="linux_386"
  Archclash="linux-386"
  echo "CPU架构：X86 32"
elif [[ `grep -c "CONFIG_ARCH=\"aarch64\"" ${GITHUB_WORKSPACE}/openwrt/.config` -eq '1' ]]; then
  Arch="linux_arm64"
  Archclash="linux-arm64"
  echo "CPU架构：arm64"
elif [[ `grep -c "CONFIG_arm_v7=y" ${GITHUB_WORKSPACE}/openwrt/.config` -eq '1' ]]; then
  Arch="linux_armv7"
  Archclash="linux-armv7"
  echo "CPU架构：armv7"
elif [[ `grep -c "CONFIG_ARCH=\"arm\"" ${GITHUB_WORKSPACE}/openwrt/.config` -eq '1' ]] && [[ `grep -c "CONFIG_arm_v7=y" ${GITHUB_WORKSPACE}/openwrt/.config` -eq '0' ]] && [[ `grep "CONFIG_TARGET_ARCH_PACKAGES" "${GITHUB_WORKSPACE}/openwrt/.config" |grep -c "vfp"` -eq '1' ]]; then
  Arch="linux_armv6"
  Archclash="linux-armv6"
  echo "CPU架构：armv6"
elif [[ `grep -c "CONFIG_ARCH=\"arm\"" ${GITHUB_WORKSPACE}/openwrt/.config` -eq '1' ]] && [[ `grep -c "CONFIG_arm_v7=y" ${GITHUB_WORKSPACE}/openwrt/.config` -eq '0' ]] && [[ `grep "CONFIG_TARGET_ARCH_PACKAGES" "${GITHUB_WORKSPACE}/openwrt/.config" |grep -c "vfp"` -eq '0' ]]; then
  Arch="linux_armv5"
  Archclash="linux-armv5"
  echo "CPU架构：armv6"
elif [[ `grep -c "CONFIG_ARCH=\"mips\"" ${GITHUB_WORKSPACE}/openwrt/.config` -eq '1' ]]; then
  Arch="linux_mips_softfloat"
  Archclash="linux-mips-softfloat"
  echo "CPU架构：mips"
elif [[ `grep -c "CONFIG_ARCH=\"mips64\"" ${GITHUB_WORKSPACE}/openwrt/.config` -eq '1' ]]; then
  Arch="linux_mips64_softfloat"
  Archclash="linux-mips64"
  echo "CPU架构：mips64"
elif [[ `grep -c "CONFIG_ARCH=\"mipsel\"" ${GITHUB_WORKSPACE}/openwrt/.config` -eq '1' ]]; then
  Arch="linux_mipsle_softfloat"
  Archclash="linux-mipsle-softfloat"
  echo "CPU架构：mipsel"
elif [[ `grep -c "CONFIG_ARCH=\"mips64el\"" ${GITHUB_WORKSPACE}/openwrt/.config` -eq '1' ]]; then
  Arch="linux_mips64le_softfloat"
  Archclash="linux-mips64le"
  echo "CPU架构：mips64el"
else
  echo "不了解您的CPU为何架构"
fi

echo "正在执行：给openclash下载核心"
rm -rf ${GITHUB_WORKSPACE}/openwrt/files/etc/openclash/core
rm -rf ${GITHUB_WORKSPACE}/openwrt/clash-neihe && mkdir -p ${GITHUB_WORKSPACE}/openwrt/clash-neihe
mkdir -p ${GITHUB_WORKSPACE}/openwrt/files/etc/openclash/core
cd ${GITHUB_WORKSPACE}/openwrt/clash-neihe
wget -q https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-${Archclash}.tar.gz -O meta.tar.gz
wget -q https://raw.githubusercontent.com/vernesong/OpenClash/core/master/dev/clash-${Archclash}.tar.gz -O clash.tar.gz
wget -q https://raw.githubusercontent.com/vernesong/OpenClash/core/master/core_version -O core_version
TUN="$(cat core_version |grep -v "^v\|^V\|^a" |grep -E "[0-9]+.[0-9]+.[0-9]+")"
wget -q https://raw.githubusercontent.com/vernesong/OpenClash/core/master/premium/clash-${Archclash}-${TUN}.gz -O clash_tun.gz
tar -zxvf clash.tar.gz -O > clash
if [[ $? -eq 0 ]];then
  mv -f ${GITHUB_WORKSPACE}/openwrt/clash-neihe/clash ${GITHUB_WORKSPACE}/openwrt/files/etc/openclash/core/clash
  sudo chmod +x ${GITHUB_WORKSPACE}/openwrt/files/etc/openclash/core/clash
  echo "OpenClash增加dev内核成功"
else
  echo "OpenClash增加dev内核失败"
fi
tar -zxvf meta.tar.gz -O > clash_meta
if [[ $? -eq 0 ]];then
  mv -f ${GITHUB_WORKSPACE}/openwrt/clash-neihe/clash_meta ${GITHUB_WORKSPACE}/openwrt/files/etc/openclash/core/clash_meta
  sudo chmod +x ${GITHUB_WORKSPACE}/openwrt/files/etc/openclash/core/clash_meta
  echo "OpenClash增加meta内核成功"
else
  echo "OpenClash增加meta内核失败"
fi
gzip -d clash_tun.gz
if [[ $? -eq 0 ]];then
  mv -f ${GITHUB_WORKSPACE}/openwrt/clash-neihe/clash_tun ${GITHUB_WORKSPACE}/openwrt/files/etc/openclash/core/clash_tun
  sudo chmod +x ${GITHUB_WORKSPACE}/openwrt/files/etc/openclash/core/clash_tun
  echo "clash"
  echo "OpenClash增加tun内核成功"
else
  echo "OpenClash增加tun内核失败"
fi
cd ${GITHUB_WORKSPACE}/openwrt
rm -rf ${GITHUB_WORKSPACE}/openwrt/clash-neihe

echo "正在执行：给adguardhome下载核心"
rm -rf ${GITHUB_WORKSPACE}/openwrt/AdGuardHome && rm -rf ${GITHUB_WORKSPACE}/openwrt/files/usr/bin
wget -q https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest -O AdGuardHome.api
# wget -q https://github.com/281677160/common/releases/download/API/AdGuardHome.api -O AdGuardHome.api
if [[ $? -ne 0 ]];then
  curl -fsSL https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest -o AdGuardHome.api
fi
latest_ver="$(grep -E 'tag_name' 'AdGuardHome.api' |grep -E 'v[0-9.]+' -o 2>/dev/null)"
rm -rf AdGuardHome.api
wget -q https://github.com/AdguardTeam/AdGuardHome/releases/download/${latest_ver}/AdGuardHome_${Arch}.tar.gz
if [[ -f "AdGuardHome_${Arch}.tar.gz" ]]; then
  tar -zxvf AdGuardHome_${Arch}.tar.gz -C ${GITHUB_WORKSPACE}/openwrt
  echo "核心下载成功"
else
  echo "下载核心失败"
fi
mkdir -p ${GITHUB_WORKSPACE}/openwrt/files/usr/bin
if [[ -f "${GITHUB_WORKSPACE}/openwrt/AdGuardHome/AdGuardHome" ]]; then
  mv -f ${GITHUB_WORKSPACE}/openwrt/AdGuardHome ${GITHUB_WORKSPACE}/openwrt/files/usr/bin/
  sudo chmod +x ${GITHUB_WORKSPACE}/openwrt/files/usr/bin/AdGuardHome/AdGuardHome
  echo "增加AdGuardHome核心完成"
else
  echo "增加AdGuardHome核心失败"
fi
rm -rf ${GITHUB_WORKSPACE}/openwrt/{AdGuardHome_${Arch}.tar.gz,AdGuardHome}

echo "预置unblockneteasemusic内核"
mkdir -p ${GITHUB_WORKSPACE}/openwrt/files/usr/share/unblockneteasemusic
NAME="${GITHUB_WORKSPACE}/openwrt/files/usr/share/unblockneteasemusic" && mkdir -p $NAME/core
echo "" > "$NAME/core_local_ver"
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/precompiled/app.js -o $NAME/core/app.js
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/precompiled/bridge.js -o $NAME/core/bridge.js
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/ca.crt -o $NAME/core/ca.crt
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/server.crt -o $NAME/core/server.crt
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/server.key -o $NAME/core/server.key

echo "添加默认登录壁纸"
mkdir -p ${GITHUB_WORKSPACE}/openwrt/files/www/luci-static/argon/background/
cp -r $GITHUB_WORKSPACE/source/video/* ${GITHUB_WORKSPACE}/openwrt/files/www/luci-static/argon/background/
cp -r $GITHUB_WORKSPACE/source/img/* ${GITHUB_WORKSPACE}/openwrt/files/www/luci-static/argon/background/


# 修改passwall依赖
# 取消shadowsocksr-libev的libopenssl-legacy依赖
# if [[ -d "${GITHUB_WORKSPACE}/openwrt/feeds/passwall_packages/shadowsocksr-libev" ]]; then
#   echo "取消shadowsocksr-libev的libopenssl-legacy依赖"
#   curl -o ${GITHUB_WORKSPACE}/openwrt/feeds/passwall_packages/shadowsocksr-libev/Makefile https://raw.githubusercontent.com/281677160/common/main/Share/shadowsocksr-libev/Makefile
# fi
# 降低shadowsocks-rust版本,最新版本编译不成功
# if [[ -d "${GITHUB_WORKSPACE}/openwrt/feeds/passwall_packages/shadowsocks-rust" ]]; then
#   echo "降低shadowsocks-rust版本,最新版本编译不成功"
#   curl -o ${GITHUB_WORKSPACE}/openwrt/feeds/passwall_packages/shadowsocks-rust/Makefile https://raw.githubusercontent.com/281677160/common/main/Share/shadowsocks-rust/Makefile
# fi



# rm -rf ${GITHUB_WORKSPACE}/openwrt/package/feeds/third/luci-app-baidupcs-web
# rm -rf ${GITHUB_WORKSPACE}/openwrt/feeds/third/luci-app-baidupcs-web