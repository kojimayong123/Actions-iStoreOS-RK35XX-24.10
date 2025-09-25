#!/bin/bash
#===============================================
# Description: DIY script
# File name: diy-script.sh
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#===============================================

# 修改uhttpd配置文件，启用nginx
# sed -i "/.*uhttpd.*/d" .config
# sed -i '/.*\/etc\/init.d.*/d' package/network/services/uhttpd/Makefile
# sed -i '/.*.\/files\/uhttpd.init.*/d' package/network/services/uhttpd/Makefile
sed -i "s/:80/:81/g" package/network/services/uhttpd/files/uhttpd.config
sed -i "s/:443/:4443/g" package/network/services/uhttpd/files/uhttpd.config
cp -a $GITHUB_WORKSPACE/configfiles/etc/* package/base-files/files/etc/
# ls package/base-files/files/etc/


# 追加binder内核参数
echo "CONFIG_PSI=y
CONFIG_KPROBES=y" >> target/linux/rockchip/armv8/config-6.6

# 追加AM40型号
echo -e "\\ndefine Device/smart_am40
  DEVICE_VENDOR := SMART
  DEVICE_MODEL := AM40
  SOC := rk3399
  DEVICE_PACKAGES := wpad-mbedtls kmod-rtw88-8822be kmod-bluetooth kmod-usb-dwc3 \
  kmod-sound-soc-simple-card kmod-sound-soc-rockchip kmod-sound-soc-hdmi-codec \
  kmod-drm-rockchip kmod-drm-panfrost kmod-extcon-usbc-virtual-pd rockchip-cdn-dp-firmware
endef
TARGET_DEVICES += smart_am40" >> target/linux/rockchip/image/armv8.mk

wget https://github.com/retro98boy/openwrt/tree/24.10/target/linux/rockchip/patches-6.6/501-add-smart-am40.patch
cp -f 501-add-smart-am40.patch target/linux/rockchip/patches-6.6/

# 集成CPU性能跑分脚本
cp -f $GITHUB_WORKSPACE/configfiles/coremark/coremark-arm64 package/base-files/files/bin/coremark-arm64
cp -f $GITHUB_WORKSPACE/configfiles/coremark/coremark-arm64.sh package/base-files/files/bin/coremark.sh
chmod 755 package/base-files/files/bin/coremark-arm64
chmod 755 package/base-files/files/bin/coremark.sh


# 复制dts设备树文件到指定目录下
cp -f $GITHUB_WORKSPACE/configfiles/dts/rk3588-orangepi-5-plus.dts target/linux/rockchip/dts/rk3588/rk3588-orangepi-5-plus.dts


# iStoreOS-settings
git clone --depth=1 -b main https://github.com/xiaomeng9597/istoreos-settings package/default-settings


# 定时限速插件
git clone --depth=1 https://github.com/sirpdboy/luci-app-eqosplus package/luci-app-eqosplus
