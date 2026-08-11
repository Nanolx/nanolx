$chroot_mode = 'unshare';
$external_commands = { "build-failed-commands" => [ [ '%SBUILD_SHELL' ] ] };
$distribution = 'unstable';
$extra_repositories = [
    'deb [trusted=yes] https://apt.nanolx.org/ photonic main',
    'deb [trusted=yes] https://www.deb-multimedia.org/ unstable main'
];
$build_arch_all = 0;
$build_source = 0;
$source_only_changes = 0;
$run_lintian = 0;
$run_autopkgtest = 0;
$run_piuparts = 1;
$piuparts_opts = [
    '--no-eatmydata', '--distribution=%r', '--fake-essential-packages=systemd-sysv',
    '--distribution=%r', '--bootstrapcmd=mmdebstrap --skip=check/empty --variant=minbase,
     --aptopt="Acquire::http { Proxy \"http://127.0.0.1:3142\"; }"'
];
$build_environment = { "CCACHE_DIR" => "/build/ccache" };
$path = "/usr/lib/ccache:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games";
$build_path = "/build/package/";
$dsc_dir = "package";
$unshare_bind_mounts = [ { directory => "$HOME/.cache/ccache", mountpoint => "/build/ccache" } ];