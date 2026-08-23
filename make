#!/bin/bash

CWD=$(dirname "$(readlink -m "${BASH_SOURCE[0]}")")
PREFIX=${PREFIX:-/usr}

dirs=(/boot/efi/EFI/refind/themes/
 /etc/dracut.conf.d/
 /opt/Citrix/ICAClient/
 ${PREFIX}/bin/
 ${PREFIX}/lib/x86_64-linux-gnu/
 ${PREFIX}/lib/systemd/system/
 ${PREFIX}/sbin/
 ${PREFIX}/share/applications/
 ${PREFIX}/share/aurorae/themes/
 ${PREFIX}/share/bash-completion/completions/
 ${PREFIX}/share/color-schemes/
 ${PREFIX}/share/icons/
 ${PREFIX}/share/konsole/
 ${PREFIX}/share/Kvantum/
 ${PREFIX}/share/kwin/effects/
 ${PREFIX}/share/kwin/scripts/
 ${PREFIX}/share/nanolx/skel/bin
 ${PREFIX}/share/nanolx/sources.d/
 ${PREFIX}/share/nanolx/apt.d/
 ${PREFIX}/share/man/man1/
 ${PREFIX}/share/org.kde.syntax-highlighting/themes
 ${PREFIX}/share/plasma/plasmoids
 ${PREFIX}/share/plymouth/themes/
 ${PREFIX}/share/sddm/themes/
 ${PREFIX}/share/wallpapers)

BIN_SCRIPTS=(hugo-push
 nanolx-gtksettings-kde
 repokit)
SBIN_SCRIPTS=(nanolx-apt
 nanolx-backup
 nanolx-backup-helper-usb
 nanolx-ctx
 nanolx-orbit
 nanolx-pam-yubikey
 nanolx-refind
 nanolx-skel)
SCRIPTS_CONF=(citrix_hdx_config.json
 config.pl
 hugo-push.conf
 Nanolx.knsv
 nanolx-apt.conf
 nanolx-backup-usb.rules
 nanolx-backup-usb.service
 nanolx-backup.service
 nanolx-backup.timer
 nanolx-orbit.conf
 pulseaudio-dummy
 repokit.conf
 yubikey-lock.rules
 99-keep-refind)
SKEL_CONF=(bash_logout
 bashrc
 bashstyle-ng.ini
 conkyrc
 profile)
SKEL_BIN=(conky-on-second-screen)
APT_SOURCES=(debian
 deb-multimedia
 i2p
 liquorix
 mozilla
 nanolx
 winehq)
APT_CONF=(99nanolx
 pinning)

create_dirs () {
    for dir in "${dirs[@]}"; do
        mkdir -p "${DESTDIR}${dir}"
    done
}

install () {
    case "${3}" in
        /* )    local dest="${DESTDIR}${3}" ;;
        *  )    local dest="${DESTDIR}${PREFIX}/${3}" ;;
    esac

    case "${2}" in
        /* )    local in="${2}" ;;
        *  )    local in="${CWD}/${2}" ;;
    esac

    case "${1}" in
        data )  cp "${in}" "${dest}/$(basename "${2}")" ;;
        bin  )  cp "${in}" "${dest}/$(basename "${2}")"
                chmod +x "${dest}/$(basename "${2}")" ;;
        dir  )  cp -r "${in}" "${dest}/" ;;
    esac
}

install_scripts () {
    for script in "${BIN_SCRIPTS[@]}"; do
        install bin "scripts/${script}" bin
        if [ -f "${CWD}/man/${script}.1" ]; then
            gzip "${CWD}/man/${script}.1" -c > "${CWD}/man/${script}.1.gz"
            install data "man/${script}.1.gz" share/man/man1
        fi
        if [ -f "${CWD}/completion/${script}" ]; then
            install data "completion/${script}" share/bash-completion/completions
        fi
    done
    for script in "${SBIN_SCRIPTS[@]}"; do
        install bin "scripts/${script}" sbin
        if [ -f "${CWD}/man/${script}.1" ]; then
            gzip "${CWD}/man/${script}.1" -c > "${CWD}/man/${script}.1.gz"
            install data "man/${script}.1.gz" share/man/man1
        fi
        if [ -f "${CWD}/completion/${script}" ]; then
            install data "completion/${script}" share/bash-completion/completions
        fi
    done
}

install_scripts_conf () {
    for conf in "${SCRIPTS_CONF[@]}"; do
        install data "scripts/${conf}" share/nanolx
    done
}

install_skel () {
    for conf in "${SKEL_CONF[@]}"; do
        install data "skel/.${conf}" share/nanolx/skel
    done
    for bin in "${SKEL_BIN[@]}"; do
        install bin "skel/bin/${bin}" share/nanolx/skel/bin
    done
}

install_apt () {
    for source in "${APT_SOURCES[@]}"; do
        install data "apt/${source}.sources" share/nanolx/sources.d
    done
    for conf in "${APT_CONF[@]}"; do
        install data "apt/${conf}" "share/nanolx/apt.d"
    done
}

install_misc () {
    # rEFInd
    for dir in "${CWD}"/refind/*; do
        install dir "${dir}" /boot/efi/EFI/refind/themes/
    done

    # plymouth
    install data plymouth/fonts.conf /etc/dracut.conf.d/
    install dir  plymouth/debian-mac-style/ share/plymouth/themes/

    # icons and cursors
    for dir in "${CWD}"/icons/*; do
        install dir "${dir}" share/icons/
    done

    # Kvantum
    for dir in "${CWD}"/themes/Kvantum/*; do
        install dir "${dir}" share/Kvantum/
    done

    # KWin
    for dir in "${CWD}"/themes/aurorae/*; do
        install dir "${dir}" share/aurorae/themes/
    done
    for dir in "${CWD}"/themes/effects/*; do
        install dir "${dir}" share/kwin/effects/
    done
    for dir in "${CWD}"/kwin/*; do
        install dir "${dir}" share/kwin/scripts/
    done

    # Plasma
    for dir in "${CWD}"/themes/plasma/*; do
        install dir "${dir}" share/plasma/
    done
    for dir in "${CWD}"/themes/color-schemes/*; do
        install dir "${dir}" share/color-schemes/
    done
    for dir in "${CWD}"/plasmoids/*; do
        install dir "${dir}" share/plasma/plasmoids/
    done

    # Konsole
    for dir in "${CWD}"/themes/konsole/*; do
        install dir "${dir}" share/konsole/
    done

    # Kate / KDevelop color schemes
    for scheme in "${CWD}"/themes/kate/*; do
        install bin "${scheme}" share/org.kde.syntax-highlighting/themes/
    done

    # wallpapers
    for dir in "${CWD}"/wallpapers/*; do
        install dir "${dir}" share/wallpapers/
    done

    # SDDM
     for dir in "${CWD}"/sddm/*; do
        install dir "${dir}" share/sddm/themes/
    done

    # Citrix
    for desktop in "${CWD}/citrix"/*.desktop; do
        install data "${desktop}" share/applications/
    done
    for service in "${CWD}/citrix"/*.service; do
        install bin "${service}" lib/systemd/system/
    done
    for script in "${CWD}/citrix"/*.sh; do
        install bin "${script}" /opt/Citrix/ICAClient/
    done
    install bin lib/libjpeg.so.8.2.2 lib/x86_64-linux-gnu/

    # extra step for old Citrix
    ln -sf ${DESTDIR}${PREFIX}/lib/x86_64-linux-gnu/libjpeg.so.8.2.2 \
        ${DESTDIR}${PREFIX}/lib/x86_64-linux-gnu/libjpeg.so.8

}

case "${1}" in
    install)
        create_dirs
        install_scripts
        install_scripts_conf
        install_skel
        install_apt
        install_misc
    ;;
    uninstall)
        echo "nothing yet"
    ;;
    updateconf)
        install_scripts_conf
    ;;
    scripts)
        install_scripts
        install_scripts_conf
    ;;
    clean )
        rm -f "${CWD}/man"/*.1.gz
    ;;
    * )
        echo "
nanolx install script

usage:

[./]make clean      - clean up
[./]make install    - install everything
[./]make scripts    - only install scripts + config
[./]make updateconf - only install config
"
    ;;
esac
