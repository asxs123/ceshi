# #!/bin/bash
# #
# # Copyright (c) 2019-2023 SmallProgram <https://github.com/smallprogram>
# #
# # This is free software, licensed under the MIT License.
# # See /LICENSE for more information.
# #
# # https://github.com/smallprogram/OpenWrtAction
# # File name: diy-part2.sh
# # Description: OpenWrt DIY script part 2 (After Update feeds)
# #

# is_wsl2op=$1

# # Modify default IP
# sed -i 's/192.168.1.1/192.168.1.200/g' package/base-files/files/bin/config_generate

# # Modify default passwd
# sed -i '/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF./ d' package/lean/default-settings/files/zzz-default-settings

# ###### 取消bootstrap为默认主题 ######
# sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# # Add Theme
# rm -rf ./feeds/luci/themes/luci-theme-argon
# git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git ./feeds/luci/themes/luci-theme-argon

# rm -rf ./package/lean/luci-app-argon-config
# git clone -b 18.06 https://github.com/jerrykuku/luci-app-argon-config.git ./package/lean/luci-app-argon-config

# rm -rf ./package/lean/luci-app-adguardhome
# git clone https://github.com/rufengsuixing/luci-app-adguardhome.git ./package/lean/luci-app-adguardhome

# git clone https://github.com/sirpdboy/luci-app-ddns-go.git ./package/ddns-go

# # mosdns

# # find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
# # find ./ | grep Makefile | grep mosdns | xargs rm -f
# rm -rf ./feeds/luci/applications/luci-app-mosdns/
# rm -rf ./feeds/packages/net/mosdns/
# rm -rf ./package/custom_packages/mosdns
# # rm -rf feeds/packages/net/v2ray-geodata/
# git clone https://github.com/sbwml/luci-app-mosdns -b v5 ./package/custom_packages/mosdns
# # git clone https://github.com/sbwml/v2ray-geodata ./package/custom_packages/v2ray-geodata


# rm -rf ./feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/background
# mkdir -p ./feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/background

# if [ ! -n "$is_wsl2op" ]; then
#     # Add default login background
#     cp -r $GITHUB_WORKSPACE/source/video/* ./feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/background/
#     cp -r $GITHUB_WORKSPACE/source/img/* ./feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/background/

#     # Inject download package
#     mkdir -p $GITHUB_WORKSPACE/openwrt/dl
#     cp -r $GITHUB_WORKSPACE/library/* $GITHUB_WORKSPACE/openwrt/dl/

#     # Fixed qmi_wwan_f complie error
#     # cp -r $GITHUB_WORKSPACE/patches/qmi_wwan_f.c $GITHUB_WORKSPACE/openwrt/package/wwan/driver/fibocom_QMI_WWAN/src/qmi_wwan_f.c

# else
#     # Add default login background
#     cp -r /home/$USER/OpenWrtAction/source/video/* ./feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/background/
#     cp -r /home/$USER/OpenWrtAction/source/img/* ./feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/background/

#     # Inject download package
#     mkdir -p dl
#     cp -r /home/$USER/OpenWrtAction/library/* dl/

#     # Fixed qmi_wwan_f complie error
#     # cp -r ../OpenWrtAction/patches/qmi_wwan_f.c ./package/wwan/driver/fibocom_QMI_WWAN/src/qmi_wwan_f.c
# fi


# echo -e "预置Clash内核"
# mkdir -p feeds/OpenClash/luci-app-openclash/root/etc/openclash/core
# core_path="feeds/OpenClash/luci-app-openclash/root/etc/openclash/core"
# # goe_path="luci-app-openclash/root/etc/openclash"

# CLASH_DEV_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/dev/clash-linux-amd64.tar.gz"
# CLASH_TUN_URL=$(curl -fsSL https://api.github.com/repos/vernesong/OpenClash/contents/master/premium\?ref\=core | grep download_url | grep $1 | awk -F '"' '{print $4}' | grep "v3" )
# CLASH_META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-amd64.tar.gz"
# # GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
# # GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"

# wget -qO- $CLASH_DEV_URL | tar xOvz > $core_path/clash
# wget -qO- $CLASH_TUN_URL | gunzip -c > $core_path/clash_tun
# wget -qO- $CLASH_META_URL | tar xOvz > $core_path/clash_meta
# # wget -qO- $GEOIP_URL > $goe_path/GeoIP.dat
# # wget -qO- $GEOSITE_URL > $goe_path/GeoSite.dat

# chmod +x $core_path/clash*


# git clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git ./package/luci-app-unblockneteasemusic
# # echo -e "预置unblockneteasemusic内核"
# # NAME="package/luci-app-unblockneteasemusic/root/usr/share/unblockneteasemusic" && mkdir -p $NAME/core
# # echo "$(uclient-fetch -qO- 'https://api.github.com/repos/UnblockNeteaseMusic/server/commits?sha=enhanced&path=precompiled' | jsonfilter -e '@[0].sha')">"$NAME/core_local_ver"
# # curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/precompiled/app.js -o $NAME/core/app.js
# # curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/precompiled/bridge.js -o $NAME/core/bridge.js
# # curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/ca.crt -o $NAME/core/ca.crt
# # curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/server.crt -o $NAME/core/server.crt
# # curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/server.key -o $NAME/core/server.key


# echo -e "预置adguardhome内核"
# mkdir -p package/lean/luci-app-adguardhome/root/usr/bin/AdGuardHome
# adgcore="package/lean/luci-app-adguardhome/root/usr/bin/AdGuardHome"
# ADG_CORE_URL="https://github.com/AdguardTeam/AdGuardHome/releases/download/$(uclient-fetch -qO- 'https://api.github.com/repos/AdguardTeam/AdGuardHome/releases' | jsonfilter -e '@[0].tag_name')/AdGuardHome_linux_amd64.tar.gz"
# wget -qO- $ADG_CORE_URL | tar xOvz > $adgcore/AdGuardHome
# chmod +x $adgcore/AdGuardHome