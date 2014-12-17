From: =?UTF-8?B?SsO2cmc=?= Thalheim <joerg@higgsboson.tk>
Subject: [PATCH] add systemd service file
Date: Wed, 17 Dec 2014 20:54:07 +0100
Message-ID: <20141217205407.06558f65@turingmachine>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/xASvj1ZY7McgWO1H_4q_0EK"; protocol="application/pgp-signature"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.higgsboson.tk ([148.251.132.243]:59472 "EHLO
	mail.higgsboson.tk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaLQT7f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Dec 2014 14:59:35 -0500
Received: from turingmachine (unknown [IPv6:2001:4dd0:fb82:c3d2:5e51:4fff:fe58:e70b])
	by mail.higgsboson.tk (Postfix) with ESMTPSA id 290BF714F
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Dec 2014 20:54:08 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Sig_/xASvj1ZY7McgWO1H_4q_0EK
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Signed-off-by: J=C3=B6rg Thalheim <joerg@higgsboson.tk>
---
 .gitignore                |   2 +
 configure.ac              |  35 +++++++++++++
 files/Makefile.am         |   7 +++
 files/nftables.service.in |  12 +++++
 files/nftablesctl.in      | 129 ++++++++++++++++++++++++++++++++++++++++++=
++++
 5 files changed, 185 insertions(+)
 create mode 100644 files/nftables.service.in
 create mode 100755 files/nftablesctl.in

diff --git a/.gitignore b/.gitignore
index 63ef1a2..e6f8065 100644
--- a/.gitignore
+++ b/.gitignore
@@ -23,6 +23,8 @@ depcomp
 ylwrap
 src/parser_bison.c
 src/parser_bison.h
+files/nftables.service
+files/nftablesctl
=20
 # Debian package build temporary files
 build-stamp
diff --git a/configure.ac b/configure.ac
index 57ea99d..19980d1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -13,6 +13,8 @@ AC_CONFIG_MACRO_DIR([m4])
 AM_INIT_AUTOMAKE([-Wall foreign subdir-objects
         tar-pax no-dist-gzip dist-bzip2 1.6])
=20
+AC_PATH_TOOL(PKGCONFIG, pkg-config)
+
 dnl kernel style compile messages
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
=20
@@ -112,6 +114,36 @@ AC_TYPE_UINT16_T
 AC_TYPE_UINT32_T
 AC_TYPE_UINT64_T
=20
+AC_ARG_WITH(systemd, [  --with-systemd          set directory for systemd =
service files],
+        [systemd_unitdir=3D"$withval"; with_systemd=3Dyes],
+        [systemd_unitdir=3D""; with_systemd=3Dno])
+AC_SUBST(systemd_unitdir)
+
+AC_ARG_WITH(systemdutildir, [  --with-systemdutildir   set directory for s=
ystemd helper scripts],
+        [systemd_utildir=3D"$withval"], [systemd_utildir=3D""])
+AC_SUBST(systemd_utildir)
+
+AM_CONDITIONAL([INSTALL_SYSTEMD], [test "x$with_systemd" !=3D xno])
+AM_COND_IF([INSTALL_SYSTEMD],
+       [AS_IF([test "x$PKGCONFIG" =3D "x"],
+             [AC_MSG_ERROR(Need pkg-config to enable systemd support.)],
+
+             [AC_MSG_CHECKING(for systemd)
+              AS_IF([$PKGCONFIG --exists systemd],
+                    [AC_MSG_RESULT(yes)
+                     AS_IF([$PKGCONFIG --exists systemd],
+                           [AS_IF([test "x$systemd_unit_dir" =3D "x"],
+                                  [ systemd_unitdir=3D"`$PKGCONFIG --varia=
ble=3Dsystemdsystemunitdir systemd`"])
+                            AS_IF([test "x$systemd_util_dir" =3D "x"],
+                                  [ systemd_utildir=3D"`$PKGCONFIG --varia=
ble=3Dsystemdutildir systemd`"])
+                           ])
+                    ]
+                    [AC_MSG_RESULT(no)])
+             ]
+
+       )]
+)
+
 # Checks for library functions.
 AC_CHECK_FUNCS([memmove memset strchr strdup strerror strtoull])
=20
@@ -124,10 +156,13 @@ AC_CONFIG_FILES([					\
 		doc/Makefile				\
 		files/Makefile				\
 		files/nftables/Makefile			\
+		files/nftables.service			\
+		files/nftablesctl			\
 		])
 AC_OUTPUT
=20
 echo "
 nft configuration:
   cli support:			${with_cli}
+  systemd support:		${with_systemd}
   enable debugging:		${with_debug}"
diff --git a/files/Makefile.am b/files/Makefile.am
index a8394c0..4da6432 100644
--- a/files/Makefile.am
+++ b/files/Makefile.am
@@ -1 +1,8 @@
 SUBDIRS =3D nftables
+
+if INSTALL_SYSTEMD
+systemd_unit_DATA =3D nftables.service
+
+systemd_scriptsdir =3D ${systemd_utildir}/scripts
+systemd_scripts_SCRIPTS =3D nftablesctl
+endif
diff --git a/files/nftables.service.in b/files/nftables.service.in
new file mode 100644
index 0000000..3c8c921
--- /dev/null
+++ b/files/nftables.service.in
@@ -0,0 +1,12 @@
+[Unit]
+Description=3Dnftables
+Documentation=3Dman:nftables(8)
+
+[Service]
+Type=3Doneshot
+RemainAfterExit=3Dyes
+ExecStart=3D@systemd_utildir@/scripts/nftablesctl start
+ExecStop=3D@systemd_utildir@/scripts/nftablesctl stop
+
+[Install]
+WantedBy=3Dmulti-user.target
diff --git a/files/nftablesctl.in b/files/nftablesctl.in
new file mode 100755
index 0000000..080f980
--- /dev/null
+++ b/files/nftablesctl.in
@@ -0,0 +1,129 @@
+#!/bin/sh
+
+set -e
+
+usage() {
+	name=3D$(basename "$0")
+	echo "Usage: $name start|stop|restart|list"
+	echo
+	echo "       $name start     load the rules"
+	echo "       $name stop      flush the rules"
+	echo "       $name restart   reload the rules"
+	echo "       $name list      list the loaded rules"
+	echo
+	echo "Using --confirm in the following manner will prompt you to check if"
+	echo "your network connection is working fine:"
+	echo
+	echo "       $name start --confirm"
+	echo "       $name restart --confirm"
+}
+
+if [ "$(id -u)" -ne 0 ]
+then
+	echo "Warning: Only root can run this script" >&2
+	echo
+	usage
+	exit 1
+fi
+
+if [ ! -d /etc/nftables ]
+then
+	echo "Rules directory /etc/nftables does not exist" >&2
+	exit 1
+fi
+
+ctrl_c() {
+	echo
+	echo "nftables rules successfully applied"
+	exit 0
+}
+
+nft_clear_table() {
+	@sbindir@nft flush table "$1" "$2"
+	@sbindir@nft list table "$1" "$2" \
+		| awk '/^[ \t]+chain/{ print $2 }' \
+		| xargs -r -L 1 @sbindir@nft delete chain "$1" "$2"
+	@sbindir@nft list sets "$1" "$2" \
+		| awk '/^[ \t]+set/{ print $2 }' \
+		| xargs -r -L 1 @sbindir@nft delete set "$1" "$2"
+}
+
+nft_delete_table() {
+	nft_clear_table "$1" "$2"
+	if @sbindir@nft list table "$1" "$2" > /dev/null
+	then
+		@sbindir@nft delete table "$1" "$2"
+	fi
+}
+
+nft_clear_protocol() {
+	for T in $(@sbindir@nft list tables "$1" | cut -d ' ' -f 2)
+	do
+		nft_delete_table "$1" "$T"
+	done
+}
+
+nft_list_protocol() {
+	for T in $(@sbindir@nft list tables "$1" | cut -d ' ' -f 2)
+	do
+		@sbindir@nft list table "$1" "$T"
+	done
+}
+
+nftables_start() {
+	find /etc/nftables -maxdepth 1 -type f -name '*.rules' -print0 | \
+		sort -z | xargs --null --no-run-if-empty --max-args=3D1 @sbindir@nft -f
+
+	if [ -t 0 ] && [ "$1" =3D "--confirm" ]
+	then
+		echo "Please confirm that your network connection is working and press C=
trl+C on success"
+		trap ctrl_c INT
+
+		sleep 20
+
+		echo "No response, flushing rules"
+		nftables_stop
+	fi
+}
+
+nftables_list() {
+	for P in ip inet ip6 arp bridge
+	do
+		nft_list_protocol "$P"
+	done
+}
+
+nftables_stop() {
+	for P in ip inet ip6 arp bridge
+	do
+		nft_clear_protocol "$P"
+	done
+}
+
+nftables_restart() {
+	nftables_stop
+	nftables_start "$1"
+}
+
+case "$1" in
+	start)
+		nftables_start "$2"
+		;;
+
+	stop)
+		nftables_stop
+		;;
+
+	restart)
+		nftables_restart "$2"
+		;;
+
+	list)
+		nftables_list
+		;;
+
+	*)
+		usage

--Sig_/xASvj1ZY7McgWO1H_4q_0EK
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUkd9fAAoJEMpBBrjXzHn6H+gH/35pq4GHBbU10IGEZ3BUBEQc
uxVRkgoFqOxoDH3qLtup0PI96Nopj3E/VZJ68xd1jCdpOvoJ9MJgT8PTt+u2RoRj
BkejGBhT3er21f3nFFkcEn659gSx/mcBp5YLitm/t5tkpnnR3bLBexKK7ER4x+q0
CxgSwWjuuHN0uDSTAR+mjIlKf6HqJsbgoM+XvBq7lE3S1Q/ae3mEpjg/EtGBN9cR
3FehTwG9GbjoT14MheM2mCvd5IzZ3CnWVVafiMidZfi9wmdLVf0iMa5XgqTAdwQl
aM9A6u66h2dlO79d9Ubc+kF2DUyIA+FsCBQjpe1gDeLWk0RzRlQbS9obJ+KNMMs=
=wylJ
-----END PGP SIGNATURE-----

--Sig_/xASvj1ZY7McgWO1H_4q_0EK--
