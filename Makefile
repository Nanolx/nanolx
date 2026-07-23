all:

clean:

install:
	# plymouth
	mkdir -p $(DESTDIR)/etc/dracut.conf.d/
	install -m644 plymouth/fonts.conf $(DESTDIR)/etc/dracut.conf.d/
	mkdir -p $(DESTDIR)/usr/share/plymouth/themes/
	cp -r plymouth/debian-mac-style/ $(DESTDIR)/usr/share/plymouth/themes/
	mkdir -p $(DESTDIR)/usr/share/applications/
	install -m644 citrix/*.desktop $(DESTDIR)/usr/share/applications/
	# citrix
	mkdir -p $(DESTDIR)/usr/lib/systemd/system/
	install -m755 citrix/*.service $(DESTDIR)/usr/lib/systemd/system/
	mkdir -p $(DESTDIR)/opt/Citrix/ICAClient/
	install -m755 citrix/wfica*.sh $(DESTDIR)/opt/Citrix/ICAClient/
	# rEFInd themes
	mkdir -p $(DESTDIR)/boot/efi/EFI/refind/themes/
	cp -r refind/rEFInd-digital-void/ $(DESTDIR)/boot/efi/EFI/refind/themes/
	# user scripts
	mkdir -p $(DESTDIR)/usr/bin/
	for bscript in mksbuild repokit; do \
		install -m755 scripts/$$bscript $(DESTDIR)/usr/bin/; \
	done
	# sbin scripts
	mkdir -p $(DESTDIR)/usr/sbin/
	for sscript in apt backup ctx orbit pam-yubikey refind skel; do \
		install -m755 scripts/nanolx-$$sscript $(DESTDIR)/usr/sbin/; \
	done
	# apt sources and configuration files
	mkdir -p $(DESTDIR)/usr/share/nanolx/skel/
	for skel in bashrc bash_logout profile bashstyle-ng.ini conkyrc ; do \
		install -m644 skel/.$$skel $(DESTDIR)/usr/share/nanolx/skel/; \
	done
	mkdir -p $(DESTDIR)/usr/share/nanolx/sources.d/
	install -m644 apt/*.sources $(DESTDIR)/usr/share/nanolx/sources.d/
	mkdir -p $(DESTDIR)/usr/share/nanolx/apt.d/
	install -m644 apt/pinning $(DESTDIR)/usr/share/nanolx/apt.d/
	install -m644 apt/99nanolx $(DESTDIR)/usr/share/nanolx/apt.d/
	for conf in scripts/*.conf scripts/pulseaudio-dummy scripts/*.json; do \
		install -m644 $$conf $(DESTDIR)/usr/share/nanolx/; \
	done
	install -m644 scripts/nanolx-backup.service scripts/nanolx-backup.timer \
		$(DESTDIR)/usr/share/nanolx/
	# manpages
	mkdir -p $(DESTDIR)/usr/share/man/man1/
	for man in man/*.1; do \
		gzip $$man -c > $$man.gz; \
		install -m644 $$man.gz $(DESTDIR)/usr/share/man/man1/; \
		rm $$man.gz; \
	done
	# Cursors
	cp -r icons/ $(DESTDIR)/usr/share/
	# Kvantum Design
	mkdir -p $(DESTDIR)/usr/share/Kvantum/
	cp -r themes/Kvantum/* $(DESTDIR)/usr/share/Kvantum/
	# KWin
	mkdir -p $(DESTDIR)/usr/share/aurorae/themes/
	cp -r themes/aurorae/* $(DESTDIR)/usr/share/aurorae/themes/
	mkdir -p $(DESTDIR)/usr/share/kwin/effects/
	cp -r themes/effects/* $(DESTDIR)/usr/share/kwin/effects/
	mkdir -p $(DESTDIR)/usr/share/kwin/scripts/
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
	mkdir -p $(DESTDIR)/usr/share/sddm/themes/
	cp -r sddm/* $(DESTDIR)/usr/share/sddm/themes/
	# libjpeg8
	mkdir -p $(DESTDIR)/usr/lib/x86_64-linux-gnu/
	install -m644 lib/libjpeg.so.8.2.2 $(DESTDIR)/usr/lib/x86_64-linux-gnu/
	ln -sf $(DESTDIR)/usr/lib/x86_64-linux-gnu/libjpeg.so.8.2.2 \
		$(DESTDIR)/usr/lib/x86_64-linux-gnu/libjpeg.so.8
	# systemd service
	mkdir -p $(DESTDIR)/etc/systemd/user/
	install -m755 systemd/ydotoold.service $(DESTDIR)/etc/systemd/user/

update-conf:
	mkdir -p $(DESTDIR)/usr/share/nanolx/
	for conf in scripts/*.conf; do \
		install -m644 $$conf $(DESTDIR)/usr/share/nanolx/; \
	done
