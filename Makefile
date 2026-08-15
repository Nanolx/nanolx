all:

clean:
	./make clean

install:
	./make install
	# plymouth
	install -m644 plymouth/fonts.conf $(DESTDIR)/etc/dracut.conf.d/
	cp -r plymouth/debian-mac-style/ $(DESTDIR)/usr/share/plymouth/themes/
	install -m644 citrix/*.desktop $(DESTDIR)/usr/share/applications/
	# citrix
	install -m755 citrix/*.service $(DESTDIR)/usr/lib/systemd/system/
	install -m755 citrix/wfica*.sh $(DESTDIR)/opt/Citrix/ICAClient/
	# rEFInd themes
	cp -r refind/rEFInd-digital-void/ $(DESTDIR)/boot/efi/EFI/refind/themes/
	# Cursors
	cp -r icons/ $(DESTDIR)/usr/share/
	# Kvantum Design
	cp -r themes/Kvantum/* $(DESTDIR)/usr/share/Kvantum/
	# KWin
	cp -r themes/aurorae/* $(DESTDIR)/usr/share/aurorae/themes/
	cp -r themes/effects/* $(DESTDIR)/usr/share/kwin/effects/
	cp -r kwin/* $(DESTDIR)/usr/share/kwin/scripts/
	# Plasma
	cp -r themes/plasma/ $(DESTDIR)/usr/share/
	cp -r themes/color-schemes/ $(DESTDIR)/usr/share/
	cp -r plasmoids/ $(DESTDIR)/usr/share/plasma/
	# Konsole
	cp -r themes/konsole/ $(DESTDIR)/usr/share/
	# Wallpapers
	cp -r wallpapers/ $(DESTDIR)/usr/share/
	# sddm
	cp -r sddm/* $(DESTDIR)/usr/share/sddm/themes/
	# libjpeg8
	install -m644 lib/libjpeg.so.8.2.2 $(DESTDIR)/usr/lib/x86_64-linux-gnu/
	ln -sf $(DESTDIR)/usr/lib/x86_64-linux-gnu/libjpeg.so.8.2.2 \
		$(DESTDIR)/usr/lib/x86_64-linux-gnu/libjpeg.so.8

update-conf:
	./make updateconf