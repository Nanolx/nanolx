#!/bin/bash

CWD=$(dirname "$(readlink -m "${BASH_SOURCE[0]}")")
PREFIX=${INSTALL_PREFIX:-/usr}

dirs=(${DESTDIR}/boot/efi/EFI/refind/themes/
 ${DESTDIR}/etc/dracut.conf.d/
 ${DESTDIR}/opt/Citrix/ICAClient/
 ${DESTDIR}${PREFIX}/bin/
 ${DESTDIR}${PREFIX}/lib/x86_64-linux-gnu/
 ${DESTDIR}${PREFIX}/lib/systemd/system/
 ${DESTDIR}${PREFIX}/sbin/
 ${DESTDIR}${PREFIX}/share/applications/
 ${DESTDIR}${PREFIX}/share/aurorae/themes/
 ${DESTDIR}${PREFIX}/share/bash-completion/completions/
 ${DESTDIR}${PREFIX}/share/Kvantum/
 ${DESTDIR}${PREFIX}/share/kwin/effects/
 ${DESTDIR}${PREFIX}/share/kwin/scripts/
 ${DESTDIR}${PREFIX}/share/nanolx/skel/bin
 ${DESTDIR}${PREFIX}/share/nanolx/sources.d/
 ${DESTDIR}${PREFIX}/share/nanolx/apt.d/
 ${DESTDIR}${PREFIX}/share/man/man1/
 ${DESTDIR}${PREFIX}/share/plymouth/themes/
 ${DESTDIR}${PREFIX}/share/sddm/themes/)

BIN_SCRIPTS=(repokit
 hugo-push)
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
 nanolx-apt.conf
 nanolx-backup-usb.rules
 nanolx-backup-usb.service
 nanolx-backup.service
 nanolx-backup.timer
 nanolx-orbit.conf
 pulseaudio-dummy
 repokit.conf
 yubikey-lock.rules)
SKEL_CONF=(bash_logout
 bashrc
 bashstyle-ng.ini
 conkyrc
 profile)
SKEL_BIN=(conky-on-second-screen)
APT_SOURCES=(debian
 i2p
 liquorix
 mozilla
 nanolx
 winehq)
APT_CONF=(99nanolx
 pinning)

create_dirs () {
    for dir in "${dirs[@]}"; do
        mkdir -p "${dir}"
    done
}

install_data () {
    cp "${CWD}/${1}" "${DESTDIR}${PREFIX}/${2}/$(basename "${1}")"
}

install_bin () {
    cp "${CWD}/${1}" "${DESTDIR}${PREFIX}/${2}/$(basename "${1}")"
    chmod +x "${DESTDIR}${PREFIX}/${2}/$(basename "${1}")"
}

install_dir () {
    cp -r "${CWD}/${1}" "${DESTDIR}${PREFIX}/${2}/"
}

install_scripts () {
    for script in "${BIN_SCRIPTS[@]}"; do
        install_bin "scripts/${script}" "bin"
        if [ -f "${CWD}/man/${script}.1" ]; then
            gzip "${CWD}/man/${script}.1" -c > "${CWD}/man/${script}.1.gz"
            install_data "man/${script}.1.gz" "share/man/man1"
        fi
        if [ -f "${CWD}/completion/${script}" ]; then
            install_data "completion/${script}" "share/bash-completion/completions"
        fi
    done
    for script in "${SBIN_SCRIPTS[@]}"; do
        install_bin "scripts/${script}" "sbin"
        if [ -f "${CWD}/man/${script}.1" ]; then
            gzip "${CWD}/man/${script}.1" -c > "${CWD}/man/${script}.1.gz"
            install_data "man/${script}.1.gz" "share/man/man1"
        fi
        if [ -f "${CWD}/completion/${script}" ]; then
            install_data "completion/${script}" "share/bash-completion/completions"
        fi
    done
}

install_scripts_conf () {
    for conf in "${SCRIPTS_CONF[@]}"; do
        install_data "scripts/${conf}" "share/nanolx"
    done
}

install_skel () {
    for conf in "${SKEL_CONF[@]}"; do
        install_data "skel/.${conf}" "share/nanolx/skel"
    done
    for bin in "${SKEL_BIN[@]}"; do
        install_bin "skel/bin/${bin}" "share/nanolx/skel/bin"
    done
}

install_apt () {
    for source in "${APT_SOURCES[@]}"; do
        install_data "apt/${source}.sources" "share/nanolx/sources.d"
    done
    for conf in "${APT_CONF[@]}"; do
        install_data "apt/${conf}" "share/nanolx/apt.d"
    done
}

case "${1}" in
    install)
        create_dirs
        install_scripts
        install_scripts_conf
        install_skel
        install_apt
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
        echo "nanolx install script, work in progress, use make install for now."
    ;;
esac