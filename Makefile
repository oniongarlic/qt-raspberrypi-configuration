DESTDIR=qt-everywhere-src-5.12.3

all:
	@echo "Run: make install DESTDIR=qt-source-root"
	@echo "DESTDIR defaults to: [$(DESTDIR)]"

install:
	install -m 644 common/raspberrypi.conf $(DESTDIR)/qtbase/mkspecs/common/
	cp -a linux-rpi2-g++ linux-rpi3-g++ linux-rpi-g++ $(DESTDIR)/qtbase/mkspecs/

diff-common:
	diff -u common/raspberrypi.conf $(DESTDIR)/qtbase/mkspecs/common/raspberrypi.conf
