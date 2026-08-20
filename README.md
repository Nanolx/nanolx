# Nanolx

`Nanolx` is a set of meta-packages, wich I use to aid in syncing the package
selection between my machine and machines that are maintained by me.

They can be safely used by anyone on `Debian GNU/Linux` as they won't remove
or change existing packages. As of version 4.2 no configuration changes to
`/etc` are done automatically, configuration is stored in `/usr/share/nanolx/`
and you can use the provided scripts I use to keep my systems organized (see
[Scripts](#scripts) below) to adjust as you like.

addtionally `Nanolx` contains the default set of themes I prefer to use, see
the nanolx-themes package below


While I'm not actively asking for donations, a tip is always welcome.

[![Liberapay](https://img.shields.io/badge/Liberapay-F6C915?logo=liberapay&color=a80030)](https://liberapay.com/nanolx)

## Release Information

see [debian/changelog](https://gitlab.com/Nanolx/nanolx/-/blob/master/debian/changelog?ref_type=heads) for changes

- Version:    4.13.2
- Release:    20260816

## Git repository access

You can access the source from

- [GitLab Repository](https://gitlab.com/Nanolx/nanolx)

## Installation on Debian GNU/Linux

Get the signing key for my [apt repository]({{< ref "photonic.md" >}}), located at:

[https://www.nanolx.org/apt/photonic2026.asc](https://www.nanolx.org/apt/photonic2026.asc)

and save it as:
* /etc/apt/trusted.gpg.d/nanolx2026.asc

create:
* /etc/apt/sources.list.d/nanolx.sources

with the following content:

    Types: deb deb-src
    URIs: https://apt.nanolx.org/
    Suites: photonic
    Components: main
    Signed-By: /etc/apt/trusted.gpg.d/nanolx2026.asc

then proceed to install. Install either

- `nanolx-base` + selected individual packages
    - `nanolx-base` only requires `nanolx-apt-sources` and `nanolx-apt-tools`
- `nanolx-full` for all packages except nanolx-citrix-config

**Note:** `Nanolx` is built to be used with `Debian Sid` (unstable), additionally
some of the sub-packages may depend on packages only available from the `deb-multimedia`
or my own `photonic` repository, so both are considered required for `nanolx-full`.

See also: `nanolx-apt` Script below.

## For non Debian GNU/Linux-Users

On `Debian`-based distributions (like `Ubuntu`) you'll likely not be able to
meet all dependecies of the meta-packages. In that case you can use

    [./]make install

to install included scripts (see below), configuration and themes. If you only
want to install the scripts, use

    [./]make scripts

and if you only want to update the configuration files the scripts, use

    [./]make updateconf

On non Debian-based distributions you'll be able to use the scripts:

* `hugo-push`
* `nanolx-backup` (if `systemd` is in use)
* `nanolx-ctx`
* `nanolx-gtksettings-kde`
* `nanolx-skel`
* `nanolx-pam-yubikey`
* `nanolx-refind`

you may want to install them manually if desired.

## License

`nanolx` itself is licensed under the GNU GPL v3 (or newer). Individual files,
like plymouth / rEFInd themes, plasmoids, etc. may differ in licensing.

For a full overview consult

[debian/copyright](https://gitlab.com/Nanolx/nanolx/-/blob/master/debian/copyright?ref_type=heads)

## Packages

consult [debian/control](https://gitlab.com/Nanolx/nanolx/-/blob/master/debian/control?ref_type=heads) for full description and pulled packages.

1. `nanolx-full`
    * pulls all packages below, except `nanolx-citrix-config`
2. `nanolx-base`
    * base-package pulling `nanolx-apt-sources` and `nanolx-apt-tools`
3. `nanolx-admin`
    * pulls cli and gui tools for system administration, like gkdebconf, localepurge, packagesearch or cruft-ng.
4. `nanolx-apt-sources`
    * provides additional, curated, apt repositories - which are not enabled by default, see the `nanolx-apt` [Script](#scripts) below.
5. `nanolx-apt-tools`
    * pulls nanolx-apt-sources and additional tools regarding apt, like gdebi, reprepro, debdelta.
6. `nanolx-cli`
    * pulls a collection of command line utilities, like rsync, mc, unp, plocate, bashstyle-ng and more.
7. `nanolx-x11`
    * pulls a small collection of ui tools, like psensor, conky, libgtk-nocsd0 and KDE/Plasma.
8. `nanolx-security`
    * pulls a collection of security related tools, like psad, lynis, rkhunter, clamav.
9. `nanolx-net`
    * pulls a collection of networking and connectivity tools, like firefox, thunderbird, kvirc, syncthing or nextcloud-desktop.
10. `nanolx-media-codecs`
    * pulls additional codes for gstreamer, aswell as libdvdcss2 and libbluray2.
11. `nanolx-media-cli`
    * pulls cli media tools, like lame, sox, flac, streamripper or cdparanoia.
12. `nanolx-media-x11`
    * pulls ui media tools, like audacity, geeqie, okular, gimp, k3b and more.
13. `nanolx-devel-cli`
    * pulls cli development tools, like ccache, schroot, sbuild, gcc/g++, lintian, gdb, code checking tools and more.
14. `nanolx-devel-android`
    * pulls android related tools, like adb, fastboot, gradle and more.
15. `nanolx-devel-x11`
    * pulls ui development tools, like cambalache, geany, bluefish, qownnotes and more.
16. `nanolx-games`
    * pulls a collection of games, including FreedroidRPG, Globulation2, Pingus, Supertuxkart, Lincity-NG, Neverball, Lutris Launcher and Zelda fan games.
17. `nanolx-games-emu`
    * pulls a collection of emulators, including dosbox, retroarch and more.
18. `nanolx-office`
    * pulls a collection of office related packages, like libreoffice, okular, gnucash or scantpaper.
19. `nanolx-yubikey`:
    * collection of Yubikey related tools.
20. `nanolx-themes`
    * this package provides the default theme collection I use, see [Themes](#themes) below.
    * use `konsave -i /usr/share/nanolx/Nanolx.knsv` followed by `konsave -a Nanolx` to apply the full KDE theme suite.
21. `nanolx-citrix-config`
    * see [Citrix](#citrix) below.

## Scripts

`Nanolx` includes a set of scripts, all ship their own manpage and bash completion.

1. `nanolx-base`
    1. `nanolx-backup`   create and manage `systemd` timers for rsync backups alternatively create backup triggers for when a specific device/partition was plugged in (sends desktop notifications).
    2. `nanolx-skel`     enable / disable nanolx skel (`/usr/share/nanolx/skel`) for newly created users instead of `/etc/skel`.
        * **Note**: you most likely don't want that.
    3. `conky-on-second-screen`  this uses ydotool to force conky on second screen this part of the nanolx skel files, so not in /usr see skel/bin if you want to check it.
2. `nanolx-apt-sources`
    1. `nanolx-apt`      manages additional repository configurations, including key handling, aswell as matching pinning and minor apt configuration changes (the latter both optional). Currently known repos are:
        - debian (rolls-out full suite stable->experimental)
        - nanolx
        - liquorix
        - i2p
        - winehq
        - deb-multimedia
        - mozilla
3. `nanolx-apt-tools`
    1. `repokit`         personal wrapper script for reprepro with config file support and many features.
    2. `nanolx-orbit`    manages installation of 3rdparty packages, including checking sha256sums.
        - citrix-usb (stable)
        - citrix-epa (stable)
        - citrix-beta (GCC 11 tech preview)
        - citrix-usb-beta (GCC 11 tech preview)
        - zoom
        - zoom-vdi plugin
4. `nanolx-citrix-config`
    1. `nanolx-ctx`      script to disable (or enable [...]) citrix telemetry and running the included system check script. It also allows to install or uninstall the webkit2gtk-4.0 bundled with citrix, which is required for full citrix operation (stable citrix version), but no longer shipped with Debian (or Ubuntu). It has more features, be sure to check out, if you use citrix.
5. `nanolx-net`
    1. `hugo-push`     simple script to build a hugo website and push it to webspace using lftp, uses a configuration file.
6. `nanolx-yubikey`
    1. `nanolx-pam-yubikey`  script to enable password-less logins when a recognized Yubikey is plugged in, using PAM, currently hooked-into PAM modules:
        - login
        - sddm
        - su
        - sudo
        - sudo-i
        - polkit-1
        - kde

        optionally, the script allows to lock the session, as soon as the Yubikey is plugged out.
7. `nanolx-themes`
    1. `nanolx-refind`   simple script to manage rEFInd bootloader themes, supports showing installed themes, setting theme, showing current theme in use or reverting to default.
8. `nanolx-x11`
    1. `nanolx-gtksettings-kde`     This scripts reads KDE's theme, icon, font, toolbar settings and creates Gtk3 (through ini file) and Gtk4 (through gsettings) configuration, as close as possible. Note that Adwaita apps may ignore some settings, additionally you may apply those settings to `root` aswell (imagine opening `Synaptic` at night without beeing blinded).

## Themes

Use `konsave -i /usr/share/nanolx/Nanolx.knsv` followed by `konsave -a Nanolx` to apply the full KDE theme suite.

The package `nanolx-themes` contains:

- Plymouth:   debian mac style
- rEFInd:     rEFInd digital void
- Cursors:    Empty Butterfly
- Qt:         Midnight Bright Kvantum
- Icons:      Tela (red and red dark)
- sddm:       Pixel Rainy Room
- wall:       Matrixrain (Plasma 6)
- splash:     Infinity (Plasma Splash 6)
- KWin:
    - effects:
        - Aura glow (burn my windows)
        - Geometry Changes
    - scripts:
        - KNeko
        - KZones
        - Remember Window Positions
- Plasmoids:  AndromedaLauncher, Advanced Separator, Panel Colorizer
- Nothing for Plasma, KWin, Konsole, including color schemes and wallpapers
- Kate/KDevelop color schemes: revolunti / revolunti night

## Citrix

The package `nanolx-citrix-config` is not automatically pulled by `nanolx-full`,
as it requires citrix, zoom, incl. plugins to be already installed.

For that purpose see the `nanolx-orbit` script, which is bundled with `nanolx-apt-tools`.
`nanolx-citrix-config` provides additional system integrations (Menu entries, `systemd` services), as per

[https://aur.archlinux.org/packages/icaclient](https://aur.archlinux.org/packages/icaclient)

The following only applies to stable Citrix versions which still use old libaries,
current Beta version use GCC 11 and newer libraries, so those tricks are now longer
required:

If Citrix Workspace fails to start, webkitgtk2-4.0 is likely missing, as it's no
longer shipped with Debian (or Ubuntu). Citrix bundles it's own version, so you
may choose to install that version using `nanolx-ctx`, at your own risk, via:

`nanolx-ctx load-webkit`

Additionally `nanolx-ctx` features more useful commands, you might want to check.

Citrix requires libjpeg8 to run, which is not provided by Debian. Installing
libjpeg-turbo8 from Ubuntu conflicts with installing libjpegturbo0 (which is
required by Krita), `nanolx-citrix-config` ships the libjpeg.so.8{,.2.2} from
Ubuntu itself.
