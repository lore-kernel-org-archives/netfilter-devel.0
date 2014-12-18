From: =?UTF-8?B?SsO2cmc=?= Thalheim <joerg@higgsboson.tk>
Subject: [PATCH] add systemd service file
Date: Thu, 18 Dec 2014 13:47:03 +0100
Message-ID: <20141218134703.11fc792a@turingmachine>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/d4KQkvPkv0uwgr0.waZVuOf"; protocol="application/pgp-signature"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.higgsboson.tk ([148.251.132.243]:35494 "EHLO
	mail.higgsboson.tk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbaLRMrG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Dec 2014 07:47:06 -0500
Received: from turingmachine (unknown [141.56.66.51])
	by mail.higgsboson.tk (Postfix) with ESMTPSA id BF3D378E3
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Dec 2014 13:47:03 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Sig_/d4KQkvPkv0uwgr0.waZVuOf
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Signed-off-by: J=C3=B6rg Thalheim <joerg@higgsboson.tk>
---
 configure.ac                   | 34 ++++++++++++++++++++++++++++++++++
 files/Makefile.am              | 10 +++++++++-
 files/nftables.conf            |  7 +++++++
 files/nftables/nftables.conf   |  0
 files/systemd/Makefile.am      | 12 ++++++++++++
 files/systemd/nftables-reload  | 15 +++++++++++++++
 files/systemd/nftables.service | 12 ++++++++++++
 7 files changed, 89 insertions(+), 1 deletion(-)
 create mode 100644 files/nftables.conf
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
+AC_ARG_WITH(systemd, [  --with-systemd          set directory for
systemd service files],
+        [systemd_unitdir=3D"$withval"; with_systemd=3Dyes],
+        [systemd_unitdir=3D""; with_systemd=3Dno])
+AC_SUBST(systemd_unitdir)
+
+AC_ARG_WITH(systemdutildir, [  --with-systemdutildir   set directory
for systemd helper scripts],
+        [systemd_utildir=3D"$withval"], [systemd_utildir=3D""])
+AC_SUBST(systemd_utildir)
+
+AM_CONDITIONAL([INSTALL_SYSTEMD], [test "x$with_systemd" !=3D xno])
+AM_COND_IF([INSTALL_SYSTEMD],
+       [AS_IF([test "x$PKGCONFIG" =3D "x"],
+             [AC_MSG_ERROR(Need pkg-config to enable systemd
support.)], +
+             [AC_MSG_CHECKING(for systemd)
+              AS_IF([$PKGCONFIG --exists systemd],
+                    [AC_MSG_RESULT(yes)
+                     AS_IF([$PKGCONFIG --exists systemd],
+                           [AS_IF([test "x$systemd_unit_dir" =3D "x"],
+                                  [ systemd_unitdir=3D"`$PKGCONFIG
--variable=3Dsystemdsystemunitdir systemd`"])
+                            AS_IF([test "x$systemd_util_dir" =3D "x"],
+                                  [ systemd_utildir=3D"`$PKGCONFIG
--variable=3Dsystemdutildir systemd`"])
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
@@ -124,10 +156,12 @@
AC_CONFIG_FILES([					\
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
index a8394c0..8045495 100644
--- a/files/Makefile.am
+++ b/files/Makefile.am
@@ -1 +1,9 @@
-SUBDIRS =3D nftables
+SUBDIRS =3D	nftables	\
+					systemd
+
+nftables_confdir =3D ${sysconfdir}
+nftables_conf_DATA =3D nftables.conf
+
+install-data-hook:
+	${SED} -i
's|@sbindir[@]|${sbindir}/|g;s|@sysconfdir[@]|${sysconfdir}/|g' \
+		${DESTDIR}${sysconfdir}/nftables.conf
diff --git a/files/nftables.conf b/files/nftables.conf
new file mode 100644
index 0000000..f572db5
--- /dev/null
+++ b/files/nftables.conf
@@ -0,0 +1,7 @@
+#! @sbindir@nft -f
+
+table inet filter {
+	chain input		{ type filter hook input priority
0; }
+	chain forward		{ type filter hook forward
priority 0; }
+	chain output		{ type filter hook output priority
0; } +}
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
+	${SED} -i
's|@sbindir[@]|${sbindir}/|g;s|@sysconfdir[@]|${sysconfdir}/|g;s|@systemd_s=
criptsdir[@]|${systemd_scriptsdir}/|g'
\
+		${DESTDIR}${systemd_scriptsdir}/nftables-reload \
+		${DESTDIR}${systemd_unitdir}/nftables.service
+endif
diff --git a/files/systemd/nftables-reload
b/files/systemd/nftables-reload new file mode 100755
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
diff --git a/files/systemd/nftables.service
b/files/systemd/nftables.service new file mode 100644
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

--Sig_/d4KQkvPkv0uwgr0.waZVuOf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUkszHAAoJEMpBBrjXzHn6oN8H/AuHNkSTFRnUFCVtZcCyPqDn
kyV75DTM4vevGaGHSF/EogyFreSB+fWnxWPa+C7xRYj8PxNha9lUDsXKlIo3QzLD
UF8qcpglQRMlxdkJv0L+kzqtFTT36VKHbKD2ikaO/TvzYynu7mJqoUUTUFhXPI+b
qSQ3jjcxgq940QjvdJ4DuHmXoqk5vbYWWbMtOIgON/ZCDeULXr06WzWl8Or+LIWf
1HS9sSJ+BCIomvOmx5rVk7miIbQQBHdjuqeToxDzNGgBU+75XKJfTaTcJavOVsa3
9DIdq1rK8JIK2hm8I5LXSuZynkVc0eKB/nM/hCe7WAjFcMhSvgl/LQZ29dZEweE=
=abVF
-----END PGP SIGNATURE-----

--Sig_/d4KQkvPkv0uwgr0.waZVuOf--
