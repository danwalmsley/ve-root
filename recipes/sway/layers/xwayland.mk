LAYER:=xwayland
include $(DEFINE_LAYER)

XWAYLAND_GIT_REF?=master

bdir:=xwayland

xwayland:=$(LSTAMP)/$(bdir)

DEB_PACKAGES += x11proto-core-dev
DEB_PACKAGES += xtrans-dev
DEB_PACKAGES += libpixman-1-dev
DEB_PACKAGES += libxkbfile-dev
DEB_PACKAGES += libxfont-dev
DEB_PACKAGES += libudev-dev
DEB_PACKAGES += libdrm-dev
DEB_PACKAGES += libdri2-dev
DEB_PACKAGES += xutils-dev libgl1-mesa-dev libmd-dev x11proto-xcmisc-dev x11proto-bigreqs-dev x11proto-randr-dev \
				x11proto-fonts-dev x11proto-video-dev x11proto-composite-dev \
				x11proto-record-dev x11proto-scrnsaver-dev x11proto-resource-dev \
				x11proto-xf86dri-dev x11proto-present-dev x11proto-xinerama-dev \
				libxkbfile-dev libxfont-dev libpixman-1-dev x11proto-render-dev
DEB_PACKAGES += libepoxy-dev
DEB_PACKAGES += libgles2-mesa-dev libxcb-composite0-dev libxcursor-dev \
				  libcairo2-dev libgbm-dev libpam0g-dev
DEB_PACKAGES += mesa-common-dev libxshmfence-dev

$(L) += $(xwayland)

$(call git_clone, $(bdir), https://github.com/freedesktop/xorg-xserver, $(XWAYLAND_GIT_REF))

include $(BUILD_LAYER)

$(xwayland): bdir:=$(bdir)
$(xwayland):
	mkdir -p $(builddir)/$(bdir)
	cd $(srcdir)/$(bdir) && meson $(builddir)/$(bdir) --buildtype=release  -Dipv6=true -Dxvfb=false -Dxdmcp=false -Dxcsecurity=true -Ddri3=true -Dglamor=true
	cd $(builddir)/$(bdir) && ninja -j $(shell nproc)
	cd $(builddir)/$(bdir) && sudo ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)

