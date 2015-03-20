From: =?UTF-8?B?SsO2cmc=?= Thalheim <joerg@higgsboson.tk>
Subject: [PATCH v2] add systemd service file
Date: Fri, 20 Mar 2015 10:53:04 +0100
Message-ID: <20150320105304.043069e6@turingmachine>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/F3Gc4T+8Oe.4qW=._VBwIU5"; protocol="application/pgp-signature"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.higgsboson.tk ([148.251.132.243]:33851 "EHLO
	mail.higgsboson.tk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbbCTKIr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Mar 2015 06:08:47 -0400
Received: from turingmachine (we0678.dip.tu-dresden.de [141.76.178.166])
	by mail.higgsboson.tk (Postfix) with ESMTPSA id 72A7323AF0
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2015 09:53:13 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Sig_/F3Gc4T+8Oe.4qW=._VBwIU5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Signed-off-by: J=C3=B6rg Thalheim <joerg@higgsboson.tk>
---
 configure.ac                   | 30 +++++++++++++++++++++++++++++-
 files/Makefile.am              |  3 ++-
 files/nftables/nftables.conf   |  0
 files/systemd/Makefile.am      |  7 +++++++
 files/systemd/nftables.service | 17 +++++++++++++++++
 5 files changed, 55 insertions(+), 2 deletions(-)
 create mode 100644 files/nftables/nftables.conf
 create mode 100644 files/systemd/Makefile.am
 create mode 100644 files/systemd/nftables.service

diff --git a/configure.ac b/configure.ac
index d8f949a..f4352a6 100644
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
@@ -117,6 +119,30 @@ AC_TYPE_UINT16_T
 AC_TYPE_UINT32_T
 AC_TYPE_UINT64_T
=20
+AC_ARG_WITH(systemd, [  --with-systemd          set directory for systemd =
service files],
+        [systemd_unitdir=3D"$withval"; with_systemd=3Dyes],
+        [systemd_unitdir=3D""; with_systemd=3Dno])
+AC_SUBST(systemd_unitdir)
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
@@ -129,6 +155,7 @@ AC_CONFIG_FILES([					\
 		doc/Makefile				\
 		files/Makefile				\
 		files/nftables/Makefile			\
+		files/systemd/Makefile			\
 		])
 AC_OUTPUT
=20
@@ -136,4 +163,5 @@ echo "
 nft configuration:
   cli support:			${with_cli}
   enable debugging:		${with_debug}
-  use mini-gmp:			${with_mini_gmp}"
+  use mini-gmp:			${with_mini_gmp}
+  systemd support:		${with_systemd}"
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
index 0000000..2bf8580
--- /dev/null
+++ b/files/systemd/Makefile.am
@@ -0,0 +1,7 @@
+if INSTALL_SYSTEMD
+systemd_unit_DATA =3D nftables.service
+
+install-data-hook:
+	${SED} -i 's|@sbindir[@]|${sbindir}/|g;s|@sysconfdir[@]|${sysconfdir}/|g'=
 \
+		${DESTDIR}${systemd_unitdir}/nftables.service
+endif
diff --git a/files/systemd/nftables.service b/files/systemd/nftables.service
new file mode 100644
index 0000000..bdb12cf
--- /dev/null
+++ b/files/systemd/nftables.service
@@ -0,0 +1,17 @@
+[Unit]
+Description=3DNetfilter Tables
+Documentation=3Dman:nft(8)
+Wants=3Dnetwork-pre.target
+Before=3Dnetwork-pre.target
+
+[Service]
+Type=3Doneshot
+ProtectSystem=3Dfull
+ProtectHome=3Dtrue
+ExecStart=3D@sbindir@nft -f /etc/nftables.conf
+ExecReload=3D@sbindir@nft 'flush ruleset; include "/etc/nftables.conf";'
+ExecStop=3D@sbindir@nft flush ruleset
+RemainAfterExit=3Dyes
+
+[Install]
+WantedBy=3Dmulti-user.target

--Sig_/F3Gc4T+8Oe.4qW=._VBwIU5
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQF8BAEBCgBmBQJVC+4BXxSAAAAAAC4AKGlzc3Vlci1mcHJAbm90YXRpb25zLm9w
ZW5wZ3AuZmlmdGhob3JzZW1hbi5uZXQ0QUJBMDczODJBRDU3RTZCOUFBNEU4OERD
QTQxMDZCOEQ3Q0M3OUZBAAoJEMpBBrjXzHn6z2gH/ArH758TJM0AnhJLoAOdImmD
P2KEA9ZcdCKoe2WL/9iVsVXnvbveJSCtf4QiDBQdLdnp9PdlsBktkPMlhzdBrwnI
jfKXXxm1FVgpC77gZZdppR/u8K+c1znt5qYCGt3L4xqoQ6oSg+WFyEERzLe3vtQM
CE+oUlMVi2tl7shc9U5uiA76WY14puPHQuOuLBsDWSMgInnenhjGgh4SvHatdxXO
51f0DJs+kzy2Io4293pP7Xw0GQx1XN5yCTRCMegS+zEWtFr25439dK4tuNn351j4
VgYsfXhhtOQxv/Qx9p3HUj4/YCoYm+sAkU2Hz0u/m1Yzc1cH8Hn18Y6JBk6R9VQ=
=IJ9H
-----END PGP SIGNATURE-----

--Sig_/F3Gc4T+8Oe.4qW=._VBwIU5--
