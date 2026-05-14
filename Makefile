all:

install:
	mkdir -p $(DESTDIR)/etc/apt/sources.list.d/
	mkdir -p $(DESTDIR)/etc/apt/preferences.d/
	mkdir -p $(DESTDIR)/usr/bin/
	mkdir -p $(DESTDIR)/usr/sbin/
	mkdir -p $(DESTDIR)/usr/share/applications/
	mkdir -p $(DESTDIR)/opt/Citrix/ICAClient/
	mkdir -p $(DESTDIR)/usr/lib/systemd/system/
	install -m644 apt/*.sources $(DESTDIR)/etc/apt/sources.list.d/
	install -m644 apt/apt.conf $(DESTDIR)/etc/apt/apt.conf
	install -m644 apt/pinning $(DESTDIR)/etc/apt/preferences.d/
	install -m755 scripts/mksbuild $(DESTDIR)/usr/bin/
	install -m755 scripts/repokit $(DESTDIR)/usr/bin/
	install -m755 scripts/apt-getkeys $(DESTDIR)/usr/sbin/
	install -m755 scripts/nanolx-skel $(DESTDIR)/usr/sbin/
	install -m644 citrix/*.desktop $(DESTDIR)/usr/share/applications/
	install -m755 citrix/wfica*.sh $(DESTDIR)/opt/Citrix/ICAClient/
	install -m755 citrix/nanolx-ctx $(DESTDIR)/usr/sbin/
	install -m755 citrix/*.service $(DESTDIR)/usr/lib/systemd/system/
	cp -r skel_nano $(DESTDIR)/etc/

clean:
