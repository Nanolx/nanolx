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
	for sscript in apt ctx orbit pam-yubikey refind skel; do \
		install -m755 scripts/nanolx-$$sscript $(DESTDIR)/usr/sbin/; \
	done
	# apt sources configuration
	mkdir -p $(DESTDIR)/usr/share/nanolx/skel/
	for skel in bashrc bash_logout profile bashstyle-ng.ini conkyrc ; do \
		install -m644 skel/.$$skel $(DESTDIR)/usr/share/nanolx/skel/; \
	done
	mkdir -p $(DESTDIR)/usr/share/nanolx/sources.d/
	install -m644 apt/*.sources $(DESTDIR)/usr/share/nanolx/sources.d/
	mkdir -p $(DESTDIR)/usr/share/nanolx/apt.d/
	install -m644 apt/pinning $(DESTDIR)/usr/share/nanolx/apt.d/
	install -m644 apt/99nanolx $(DESTDIR)/usr/share/nanolx/apt.d/
	for conf in apt orbit; do \
		install -m644 scripts/nanolx-$$conf.conf $(DESTDIR)/usr/share/nanolx/; \
	done
	# manpages
	mkdir -p $(DESTDIR)/usr/share/man/man1/
	for man in man/nanolx*.1; do \
		gzip $$man -c > $$man.gz; \
		install -m644 $$man.gz $(DESTDIR)/usr/share/man/man1/; \
		rm $$man.gz; \
	done

