all:

install:
	mkdir -p $(DESTDIR)/etc/dracut.conf.d/
	mkdir -p $(DESTDIR)/usr/bin/
	mkdir -p $(DESTDIR)/usr/sbin/
	mkdir -p $(DESTDIR)/usr/share/nanolx/
	mkdir -p $(DESTDIR)/usr/share/nanolx/sources.d/
	mkdir -p $(DESTDIR)/usr/share/nanolx/apt.d/
	mkdir -p $(DESTDIR)/usr/share/applications/
	mkdir -p $(DESTDIR)/usr/share/plymouth/themes/
	mkdir -p $(DESTDIR)/usr/lib/systemd/system/
	mkdir -p $(DESTDIR)/opt/Citrix/ICAClient/
	mkdir -p $(DESTDIR)/boot/efi/EFI/refind/themes/
	install -m644 apt/*.sources $(DESTDIR)/usr/share/nanolx/sources.d/
	install -m644 apt/pinning $(DESTDIR)/usr/share/nanolx/apt.d/
	install -m644 apt/99nanolx.conf $(DESTDIR)/usr/share/nanolx/apt.d/
	install -m644 plymouth/fonts.conf $(DESTDIR)/etc/dracut.conf.d/
	install -m755 scripts/mksbuild $(DESTDIR)/usr/bin/
	install -m755 scripts/repokit $(DESTDIR)/usr/bin/
	install -m755 scripts/nanolx-apt $(DESTDIR)/usr/sbin/
	install -m644 scripts/nanolx-apt.conf $(DESTDIR)/usr/share/nanolx/
	install -m755 scripts/nanolx-ctx $(DESTDIR)/usr/sbin/
	install -m755 scripts/nanolx-refind $(DESTDIR)/usr/sbin/
	install -m755 scripts/nanolx-skel $(DESTDIR)/usr/sbin/
	install -m755 scripts/nanolx-pam-yubikey $(DESTDIR)/usr/sbin/
	install -m755 scripts/nanolx-orbit $(DESTDIR)/usr/sbin/
	install -m644 scripts/nanolx-orbit.conf $(DESTDIR)/usr/share/nanolx/
	install -m644 citrix/*.desktop $(DESTDIR)/usr/share/applications/
	install -m755 citrix/wfica*.sh $(DESTDIR)/opt/Citrix/ICAClient/
	install -m755 citrix/*.service $(DESTDIR)/usr/lib/systemd/system/
	cp -r skel/ $(DESTDIR)/usr/share/nanolx/
	cp -r refind/rEFInd-digital-void/ $(DESTDIR)/boot/efi/EFI/refind/themes/
	cp -r plymouth/debian-mac-style/ $(DESTDIR)/usr/share/plymouth/themes/

clean:
