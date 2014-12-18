From: =?UTF-8?B?SsO2cmc=?= Thalheim <joerg@higgsboson.tk>
Subject: [PATCH] add systemd service file
Date: Thu, 18 Dec 2014 21:10:30 +0100
Message-ID: <20141218211030.22a83448@turingmachine>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/hKhEsIcBMwiK1nKNItRWiv7"; protocol="application/pgp-signature"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.higgsboson.tk ([148.251.132.243]:48260 "EHLO
	mail.higgsboson.tk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaLRUKk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Dec 2014 15:10:40 -0500
Received: from turingmachine (ip-109-47-192-77.web.vodafone.de [109.47.192.77])
	by mail.higgsboson.tk (Postfix) with ESMTPSA id 240467CFB
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Dec 2014 21:10:36 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Sig_/hKhEsIcBMwiK1nKNItRWiv7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Signed-off-by: J=C3=B6rg Thalheim <joerg@higgsboson.tk>
---
 configure.ac                   | 34 ++++++++++++++++++++++++++++++++++
 files/Makefile.am              |  3 ++-
 files/nftables/nftables.conf   |  0
 files/systemd/Makefile.am      | 12 ++++++++++++
 files/systemd/nftables-reload  | 15 +++++++++++++++
 files/systemd/nftables.service | 12 ++++++++++++
 6 files changed, 75 insertions(+), 1 deletion(-)
 create mode 100644 files/nftables/nftables.conf
 create mode 100644 files/systemd/Makefile.am
 create mode 100755 files/systemd/nftables-reload
 create mode 100644 files/systemd/nftables.service

diff --git a/configure.ac b/configure.ac
index 57ea99d..5adb223 100644
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
@@ -124,10 +156,12 @@ AC_CONFIG_FILES([					\
 		doc/Makefile				\
 		files/Makefile				\
 		files/nftables/Makefile			\
+		files/systemd/Makefile			\
 		])
 AC_OUTPUT
=20
 echo "
 nft configuration:
   cli support:			${with_cli}
+  systemd support:		${with_systemd}
   enable debugging:		${with_debug}"
diff --git a/files/Makefile.am b/files/Makefile.am
index a8394c0..4dc0027 100644
--- a/files/Makefile.am
+++ b/files/Makefile.am
@@ -1 +1,2 @@
-SUBDIRS =3D nftables
+SUBDIRS =3D	nftables	\
+					systemd
diff --git a/files/nftables/nftables.conf b/files/nftables/nftables.conf
new file mode 100644
index 0000000..e69de29
diff --git a/files/systemd/Makefile.am b/files/systemd/Makefile.am
new file mode 100644
index 0000000..c0a56c8
--- /dev/null
+++ b/files/systemd/Makefile.am
@@ -0,0 +1,12 @@
+
+if INSTALL_SYSTEMD
+systemd_unit_DATA =3D nftables.service
+
+systemd_scriptsdir =3D ${systemd_utildir}/scripts
+systemd_scripts_SCRIPTS =3D nftables-reload
+
+install-data-hook:
+	${SED} -i 's|@sbindir[@]|${sbindir}/|g;s|@sysconfdir[@]|${sysconfdir}/|g;=
s|@systemd_scriptsdir[@]|${systemd_scriptsdir}/|g' \
+		${DESTDIR}${systemd_scriptsdir}/nftables-reload \
+		${DESTDIR}${systemd_unitdir}/nftables.service
+endif
diff --git a/files/systemd/nftables-reload b/files/systemd/nftables-reload
new file mode 100755
index 0000000..d688cb6
--- /dev/null
+++ b/files/systemd/nftables-reload
@@ -0,0 +1,15 @@
+#!/bin/sh
+
+set -e
+
+if [ ! -f @sysconfdir@nftables.conf ]
+then
+  echo "/etc/nftables.conf does not exist" >&2
+  exit 1
+fi
+
+rules=3D"$(mktemp nftables.XXXXXXXX)"
+trap "rm -f $tmpfile" 0 1 2 3 15
+echo "flush ruleset" > "$rules"
+cat @sysconfdir@nftables.conf >> "$rules"
+@sbindir@nft -f "$rules"
diff --git a/files/systemd/nftables.service b/files/systemd/nftables.service
new file mode 100644
index 0000000..f958bfc
--- /dev/null
+++ b/files/systemd/nftables.service
@@ -0,0 +1,12 @@
+[Unit]
+Description=3Dnftables
+Documentation=3Dman:nft(8)
+
+[Service]
+RemainAfterExit=3Dyes
+ExecStart=3D@sbindir@nft -I /etc/nftables -f /etc/nftables.conf
+ExecStop=3D@sbindir@nft flush ruleset
+ExecReload=3D@systemd_scriptsdir@nftables-reload

--Sig_/hKhEsIcBMwiK1nKNItRWiv7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUkzS2AAoJEMpBBrjXzHn6DO0H/jQmm7Los+tevVh+lb0hqD2m
WxOICBpQHogv778QiANArW3xuzm/NyvT/3SmaYVoShox4XFBXc04xGKnLwBh3o1O
ySK+JQKmsdowz/0yEkqzoQCOVA2Br+oGw3me3CtE6VJkc0dIv9+CZlZX196lERNl
EtpoThL/K+2kQnv01TzLL6Vie2Afpc4sNm6+3PXu2aWASD6Le1/C6vw4ajxyPqR5
xtOw/5P5jDDtwwrZSXM1iBP0sRCP95AwAe7qec0ZCoRVTrdlEVsSw8r18puej837
+78Yo2JS+tDmseO+KfG8Jsg8Xzgi99g3mPx2HgW3HAuNr3EY8a2tzzpiVervSz8=
=aJf0
-----END PGP SIGNATURE-----

--Sig_/hKhEsIcBMwiK1nKNItRWiv7--
