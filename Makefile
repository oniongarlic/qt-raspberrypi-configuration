DESTDIR=../qt-everywhere-src-5.12.3

all:
	@echo "Run: make install DESTDIR=qt-source-root"
	@echo "DESTDIR defaults to: [$(DESTDIR)]"

install:
	install -m 644 common/raspberrypi.conf $(DESTDIR)/qtbase/mkspecs/common/
	cp -a linux-rpi2-g++ linux-rpi3-g++ linux-rpi-g++ linux-rpi-vc4-g++ $(DESTDIR)/qtbase/mkspecs/

diff: diff-common diff-linux-rpi-g++ diff-linux-rpi2-g++ diff-linux-rpi3-g++

diff-common:
	diff -u common/raspberrypi.conf $(DESTDIR)/qtbase/mkspecs/common/raspberrypi.conf

diff-%:
	diff -u -r $* $(DESTDIR)/qtbase/mkspecs/$*
