PREFIX=/opt/Qt5.12
DESTDIR=../qt-everywhere-src-5.12.6
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
	-skip qtwayland \
	-skip qtwebengine \
	-skip qtscript \
	-no-pch \
	-no-gtk \
	-no-xcb \
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

ifeq ($(QTWAYLAND), 1)
# QT_CONFIG_COMMON+=
else
QT_CONFIG_COMMON+=-skip qtwayland
endif

QT_CONFIG_ARMV6:=-platform linux-rpi-g++ $(QT_CONFIG_COMMON)

QT_CONFIG_ARMV7:=-platform linux-rpi2-g++ $(QT_CONFIG_COMMON)

QT_CONFIG_ARMV8:=-platform linux-rpi3-g++ $(QT_CONFIG_COMMON)

QT_CONFIG_ARMV7_VC4:=-platform linux-rpi-vc4-g++ $(QT_CONFIG_COMMON)

QT_CONFIG_ARMV8_VC4:=-platform linux-rpi4-v3d-g++ $(QT_CONFIG_COMMON)

all:
	@echo "Run: make install DESTDIR=qt-source-root"
	@echo "DESTDIR defaults to: [$(DESTDIR)]"

install: mkspecs

mkspecs:
	install -m 644 common/raspberrypi.conf $(DESTDIR)/$(MKSPECS)/common
	cp -a linux-rpi2-g++ linux-rpi3-g++ linux-rpi-g++ linux-rpi-vc4-g++ linux-rpi4-v3d-g++ $(DESTDIR)/$(MKSPECS)/

diff: diff-common diff-linux-rpi-g++ diff-linux-rpi2-g++ diff-linux-rpi3-g++ diff-linux-rpi4-v3d-g++

diff-common:
	diff -u common/raspberrypi.conf $(DESTDIR)/qtbase/mkspecs/common/raspberrypi.conf

diff-%:
	diff -u -r $* $(DESTDIR)/qtbase/mkspecs/$*

configure-rpi: configure-armv6

configure-rpi1: configure-armv6

configure-rpi2: configure-armv7

configure-rpi3: configure-armv8

configure-rpi4: configure-armv8-vc4

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


