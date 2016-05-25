all:

install:
	mkdir -p $(DESTDIR)/etc/apt/sources.list.d/
	mkdir -p $(DESTDIR)/etc/apt/preferences.d/
	mkdir -p $(DESTDIR)/etc/default/
	mkdir -p $(DESTDIR)/etc/sysctl.d/
	mkdir -p $(DESTDIR)/etc/privoxy/
	mkdir -p $(DESTDIR)/etc/initramfs-tools/hooks/
	mkdir -p $(DESTDIR)/etc/decryptkeydevice/
	mkdir -p $(DESTDIR)/usr/bin/
	mkdir -p $(DESTDIR)/usr/sbin/
	install -m644 apt/*.list $(DESTDIR)/etc/apt/sources.list.d/
	install -m644 apt/apt.conf $(DESTDIR)/etc/apt/apt.conf
	install -m644 apt/pinning $(DESTDIR)/etc/apt/preferences.d/
	install -m755 apt/apt-getkeys $(DESTDIR)/usr/sbin/
	install -m644 privoxy/privoxy-blacklist $(DESTDIR)/etc/default/
	install -m644 privoxy/config* $(DESTDIR)/etc/privoxy/
	install -m755 privoxy/privoxy-blocklist $(DESTDIR)/usr/sbin/
	install -m755 privoxy/privoxy-switch $(DESTDIR)/usr/sbin/
	install -m755 scripts/mksbuild $(DESTDIR)/usr/bin/
	install -m755 scripts/sufffix $(DESTDIR)/usr/bin/
	install -m755 scripts/wiiconvert $(DESTDIR)/usr/bin/
	install -m755 scripts/gfxrename $(DESTDIR)/usr/bin/
	install -m755 scripts/dump_bookmarks_nextbrowser $(DESTDIR)/usr/bin/
	install -m755 scripts/repokit $(DESTDIR)/usr/bin/
	install -m644 sysctl/* $(DESTDIR)/etc/sysctl.d/
	install -m755 decryptkeydevice/decryptkeydevice.hook \
		$(DESTDIR)/etc/initramfs-tools/hooks/
	install -m755 decryptkeydevice/decryptkeydevice_keyscript.sh \
		$(DESTDIR)/etc/decryptkeydevice/
	install -m644 decryptkeydevice/decryptkeydevice.conf \
		$(DESTDIR)/etc/decryptkeydevice/
	cp -r skel_nano $(DESTDIR)/etc/

clean:
