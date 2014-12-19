From: =?UTF-8?B?SsO2cmc=?= Thalheim <joerg@higgsboson.tk>
Subject: [PATCH] add systemd service file
Date: Fri, 19 Dec 2014 14:02:58 +0100
Message-ID: <20141219140258.787a4c4e@turingmachine>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/7MV_Xf6hToWC7IXic+1BlNu"; protocol="application/pgp-signature"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.higgsboson.tk ([148.251.132.243]:45866 "EHLO
	mail.higgsboson.tk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaLSNDI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Dec 2014 08:03:08 -0500
Received: from turingmachine (55d44dbc.access.ecotel.net [85.212.77.188])
	by mail.higgsboson.tk (Postfix) with ESMTPSA id F22C671C2
	for <netfilter-devel@vger.kernel.org>; Fri, 19 Dec 2014 14:03:03 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Sig_/7MV_Xf6hToWC7IXic+1BlNu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Signed-off-by: J=C3=B6rg Thalheim <joerg@higgsboson.tk>
---
 configure.ac                   | 34 ++++++++++++++++++++++++++++++++++
 files/Makefile.am              |  3 ++-
 files/nftables/nftables.conf   |  0
 files/systemd/Makefile.am      | 12 ++++++++++++
 files/systemd/nftables-reload  | 16 ++++++++++++++++
 files/systemd/nftables.service | 12 ++++++++++++
 6 files changed, 76 insertions(+), 1 deletion(-)
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
index 0000000..0fcc2ad
--- /dev/null
+++ b/files/systemd/nftables-reload
@@ -0,0 +1,16 @@
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
+tmp=3D${TMPDIR-/tmp}
+rules=3D`mktemp "$tmp/nftables.XXXXXXX"`
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
+
+[Install]
+WantedBy=3Dmulti-user.target
--=20
2.2.0


--Sig_/7MV_Xf6hToWC7IXic+1BlNu
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUlCIDAAoJEMpBBrjXzHn61l0H/0PpdDB7YR/4+Iihq88pGLLi
T6N5XlW57NmzrgiEseQUnJZIZZhtJ0udY7pKXFv+UAAqDsNbvIvV13oRYiizapNv
ddgfV6x52UDSrYnFUKA+wZoTEOEIkrNuiEQAoamhUahTAY+7JKXk/u54E6kHvHSM
ha2Ukk2L5N4M5KSc1DFAkWTWcdHSFFIf6NC4NSdNefpLa8e4fG9A6AU/MHwWNqoR
bDsNz5ezexlZ4MPc5SVz9iM0c1sLKaM8ikRwn8UiYt4Jt8U1/YtTTg3osJhBHoHX
B+P+ACEV8qM4/ob2Cu13UG91K+Oim/o+3MHarm8T9hepebG0eY4Soan3Vb4hQcI=
=oWE9
-----END PGP SIGNATURE-----

--Sig_/7MV_Xf6hToWC7IXic+1BlNu--
