QTVERSION=5.15.2
PREFIX=/opt/Qt/$(QTVERSION)
DESTDIR=../qt-everywhere-src-$(QTVERSION)
MKSPECS=qtbase/mkspecs

XCB=0
GTK=0
QTWAYLAND=0
QTWEBENGINE=0
QTSCRIPT=0
MAPBOXGL=0

PKG_CONFIG_LIBDIR=/usr/lib/arm-linux-gnueabihf/pkgconfig:/usr/share/pkgconfig
export PKG_CONFIG_LIBDIR

QT_CONFIG_COMMON:=-v -optimized-tools \
	-prefix $(PREFIX) \
	-opengl es2 -eglfs \
	-opensource -confirm-license -release \
	-reduce-exports \
	-force-pkg-config \
	-nomake examples -no-compile-examples \
	-skip qtscript \
	-no-pch \
	-no-feature-geoservices_mapboxgl \
	-qt-pcre \
	-ssl \
	-evdev \
	-system-freetype \
	-fontconfig \
	-glib \
	-sctp \
	-recheck-all \
	-qpa eglfs

ifeq ($(XCB), 1)
QT_CONFIG_COMMON+=-xcb
else
QT_CONFIG_COMMON+=-no-xcb
endif

ifeq ($(GTK), 1)
QT_CONFIG_COMMON+=-gtk
else
QT_CONFIG_COMMON+=-no-gtk
endif

ifneq ($(QTWAYLAND), 1)
QT_CONFIG_COMMON+=-skip qtwayland
endif

ifneq ($(QTWEBENGINE), 1)
QT_CONFIG_COMMON+=-skip qtwebengine
endif

QT_CONFIG_ARMV6:=-platform linux-rpi-g++ $(QT_CONFIG_COMMON)

QT_CONFIG_ARMV7:=-platform linux-rpi2-g++ $(QT_CONFIG_COMMON)

QT_CONFIG_ARMV8:=-platform linux-rpi3-g++ $(QT_CONFIG_COMMON)

QT_CONFIG_ARMV7_VC4:=-platform linux-rpi2-vc4-g++ $(QT_CONFIG_COMMON)

QT_CONFIG_ARMV8_VC4:=-platform linux-rpi4-v3d-g++ $(QT_CONFIG_COMMON)

QT_CONFIG_ARMV8_64:=-platform linux-rpi64-vc4-g++ $(QT_CONFIG_COMMON)

all:
	@echo "Run: make install DESTDIR=qt-source-root"
	@echo "DESTDIR defaults to: [$(DESTDIR)]"

install: mkspecs

mkspecs:
	install -m 644 common/raspberrypi.conf $(DESTDIR)/$(MKSPECS)/common
	cp -a linux-rpi2-g++ linux-rpi3-g++ linux-rpi-g++ linux-rpi2-vc4-g++ linux-rpi4-v3d-g++ linux-rpi64-vc4-g++ $(DESTDIR)/$(MKSPECS)/

diff: diff-common diff-linux-rpi-g++ diff-linux-rpi2-g++ diff-linux-rpi3-g++ diff-linux-rpi4-v3d-g++

diff-common:
	diff -u common/raspberrypi.conf $(DESTDIR)/qtbase/mkspecs/common/raspberrypi.conf

diff-%:
	diff -u -r $* $(DESTDIR)/qtbase/mkspecs/$*

configure-rpi: configure-armv6

configure-rpi1: configure-armv6

configure-rpi2: configure-armv7

configure-rpi2-vc4: configure-armv7-vc4

configure-rpi3: configure-armv8

configure-rpi4: configure-armv8-vc4

configure-rpi4-vc4: configure-armv8-vc4

configure-rpi64: configure-armv8-64

configure-armv6: mkspecs
	mkdir -p ../build-qt-armv6 && cd ../build-qt-armv6 && $(DESTDIR)/configure $(QT_CONFIG_ARMV6)

configure-armv7: mkspecs
	mkdir -p ../build-qt-armv7 && cd ../build-qt-armv7 && $(DESTDIR)/configure $(QT_CONFIG_ARMV7)

configure-armv7-vc4: mkspecs
	mkdir -p ../build-qt-armv7-vc4 && cd ../build-qt-armv7-vc4 && $(DESTDIR)/configure $(QT_CONFIG_ARMV7_VC4)

configure-armv8: mkspecs
	mkdir -p ../build-qt-armv8 && cd ../build-qt-armv8 && $(DESTDIR)/configure $(QT_CONFIG_ARMV8)

configure-armv8-vc4: mkspecs
	mkdir -p ../build-qt-armv8-vc4 && cd ../build-qt-armv8-vc4 && $(DESTDIR)/configure $(QT_CONFIG_ARMV8_VC4)

configure-armv8-64: mkspecs
	mkdir -p ../build-qt-armv8-64 && cd ../build-qt-armv8-64 && $(DESTDIR)/configure $(QT_CONFIG_ARMV8_64)

build-armv6: configure-armv6
	make -C ../build-qt-armv6 -j4

build-armv7: configure-armv7
	make -C ../build-qt-armv7 -j4

build-armv7-vc4: configure-armv7-vc4
	make -C ../build-qt-armv7-vc4 -j4

build-armv8: configure-armv8
	make -C ../build-qt-armv8 -j4

build-armv8-vc4: configure-armv8-vc4
	make -C ../build-qt-armv8-vc4 -j4

build-armv8-64: configure-armv8-64
	make -C ../build-qt-armv8-64 -j4

install-base-depends:
	apt install build-essential libfontconfig1-dev libdbus-1-dev libfreetype6-dev libicu-dev libinput-dev libxkbcommon-dev libsqlite3-dev libssl-dev libpng-dev libjpeg-dev libglib2.0-dev libraspberrypi-dev -y

install-alsa-depends:
	apt install libasound2-dev -y

install-x11-depends:
	apt install libx11-dev libxcb1-dev libxkbcommon-x11-dev libx11-xcb-dev libxext-dev -y

install-wayland-depends:
	apt install libwayland-dev -y

install-gstreamer-depends:
	apt install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-plugins-bad libgstreamer-plugins-bad1.0-dev gstreamer1.0-pulseaudio gstreamer1.0-tools gstreamer1.0-alsa 

install-vc4-depends:
	apt install libgles2-mesa-dev libgbm-dev -y
