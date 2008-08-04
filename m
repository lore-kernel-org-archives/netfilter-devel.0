From: Jan Engelhardt <jengelh@medozas.de>
Subject: Put xtables.c into its own library, libxtables.so
Date: Mon, 4 Aug 2008 09:53:34 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808040952170.28732@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, hadi@cyberus.ca,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	denys@visp.net.lb
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54859 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012AbYHDNxf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:53:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit e8bfb37302c1868c99b96ae37af2fdba67a4ed2c
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Jul 2 22:29:56 2008 +0200

Put xtables.c into its own library, libxtables.so

iproute2's tc's m_ipt.c poses as a pseudo-iptables program to make
use of the info structure composition of iptables extensions.
Since tc would have to clone a lot of code, xtables.c is put into
its own shared library and should not be relied upon by any other
programs.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 .gitignore    |    4 ++++
 Makefile.am   |   30 ++++++++++++++++++------------
 configure.ac  |    7 ++++++-
 xtables.pc.in |   11 +++++++++++
 4 files changed, 39 insertions(+), 13 deletions(-)
 create mode 100644 xtables.pc.in

diff --git a/.gitignore b/.gitignore
index 9ebe15c..741f972 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,11 +1,14 @@
 .*.d
 .*.dd
 *.a
+*.la
+*.lo
 *.oo
 *.so
 *.o
 .deps
 .dirstamp
+.libs
 Makefile
 Makefile.in
 
@@ -31,6 +34,7 @@ Makefile.in
 /ltmain.sh
 /missing
 /stamp-h1
+/xtables.pc
 
 /ip6tables
 /ip6tables.8
diff --git a/Makefile.am b/Makefile.am
index b714b97..48e012e 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -11,55 +11,59 @@ endif
 # libiptc
 libiptc_libiptc_a_SOURCES = libiptc/libip4tc.c libiptc/libip6tc.c
 
+lib_LTLIBRARIES       = libxtables.la
+libxtables_la_SOURCES = xtables.c
+libxtables_la_LDFLAGS = -version 0:0:0
+
 # iptables, dynamic
-iptables_SOURCES          = iptables-standalone.c iptables.c xtables.c
+iptables_SOURCES          = iptables-standalone.c iptables.c
 iptables_LDFLAGS          = -rdynamic
-iptables_LDADD            = -ldl -lm libiptc/libiptc.a extensions/libext4.a
+iptables_LDADD            = -ldl -lm libiptc/libiptc.a extensions/libext4.a libxtables.la
 
 iptables_multi_SOURCES    = iptables-multi.c iptables-save.c \
                             iptables-restore.c iptables-xml.c \
-                            iptables-standalone.c iptables.c xtables.c
+                            iptables-standalone.c iptables.c
 iptables_multi_CFLAGS     = ${AM_CFLAGS} -DIPTABLES_MULTI
 iptables_multi_LDFLAGS    = ${iptables_LDFLAGS}
 iptables_multi_LDADD      = ${iptables_LDADD}
 
-iptables_restore_SOURCES  = iptables-restore.c iptables.c xtables.c
+iptables_restore_SOURCES  = iptables-restore.c iptables.c
 iptables_restore_LDFLAGS  = ${iptables_LDFLAGS}
 iptables_restore_LDADD    = ${iptables_LDADD}
 
-iptables_save_SOURCES     = iptables-save.c iptables.c xtables.c
+iptables_save_SOURCES     = iptables-save.c iptables.c
 iptables_save_LDFLAGS     = ${iptables_LDFLAGS}
 iptables_save_LDADD       = ${iptables_LDADD}
 
 # iptables-multi, semi-static
-iptables_static_SOURCES   = ${iptables_multi_SOURCES}
+iptables_static_SOURCES   = ${iptables_multi_SOURCES} iptables.c xtables.c
 iptables_static_CFLAGS    = ${iptables_multi_CFLAGS} -DNO_SHARED_LIBS=1
 iptables_static_LDADD     = -lm libiptc/libiptc.a extensions/libext4.a
 
 iptables_xml_SOURCES      = iptables-xml.c
 
 # ip6tables, dynamic
-ip6tables_SOURCES         = ip6tables-standalone.c ip6tables.c xtables.c
+ip6tables_SOURCES         = ip6tables-standalone.c ip6tables.c
 ip6tables_LDFLAGS         = -rdynamic
-ip6tables_LDADD           = -ldl -lm libiptc/libiptc.a extensions/libext6.a
+ip6tables_LDADD           = -ldl -lm libiptc/libiptc.a extensions/libext6.a libxtables.la
 
 ip6tables_multi_SOURCES   = ip6tables-multi.c ip6tables-save.c \
                             ip6tables-restore.c ip6tables-standalone.c \
-                            ip6tables.c xtables.c
+                            ip6tables.c
 ip6tables_multi_CFLAGS    = ${AM_CFLAGS} -DIPTABLES_MULTI
 ip6tables_multi_LDFLAGS   = ${ip6tables_LDFLAGS}
 ip6tables_multi_LDADD     = ${ip6tables_LDADD}
 
-ip6tables_restore_SOURCES = ip6tables-restore.c ip6tables.c xtables.c
+ip6tables_restore_SOURCES = ip6tables-restore.c ip6tables.c
 ip6tables_restore_LDFLAGS = ${ip6tables_LDFLAGS}
 ip6tables_restore_LDADD   = ${ip6tables_LDADD}
 
-ip6tables_save_SOURCES    = ip6tables-save.c ip6tables.c xtables.c
+ip6tables_save_SOURCES    = ip6tables-save.c ip6tables.c
 ip6tables_save_LDFLAGS    = ${ip6tables_LDFLAGS}
 ip6tables_save_LDADD      = ${ip6tables_LDADD}
 
 # iptables-multi, semi-static
-ip6tables_static_SOURCES    = ${ip6tables_multi_SOURCES}
+ip6tables_static_SOURCES    = ${ip6tables_multi_SOURCES} ip6tables.c xtables.c
 ip6tables_static_CFLAGS     = ${ip6tables_multi_CFLAGS} -DNO_SHARED_LIBS=1
 ip6tables_static_LDADD      = -lm libiptc/libiptc.a extensions/libext6.a
 
@@ -92,6 +96,8 @@ ip6tables.8: ${srcdir}/ip6tables.8.in extensions/matches6.man extensions/targets
 extensions/%:
 	${MAKE} ${AM_MAKEFLAGS} -C $(@D) $(@F)
 
+pkgconfig_DATA = xtables.pc
+
 .PHONY: tarball
 tarball:
 	rm -Rf /tmp/${PACKAGE_TARNAME}-${PACKAGE_VERSION};
diff --git a/configure.ac b/configure.ac
index 2ffe6c0..d86e29f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -37,6 +37,9 @@ AC_ARG_ENABLE([devel],
 	[enable_devel="$enableval"], [enable_devel="yes"])
 AC_ARG_ENABLE([libipq],
 	AS_HELP_STRING([--enable-libipq], [Build and install libipq]))
+AC_ARG_WITH([pkgconfigdir], AS_HELP_STRING([--with-pkgconfigdir=PATH],
+	[Path to the pkgconfig directory [[LIBDIR/pkgconfig]]]),
+	[pkgconfigdir="$withval"], [pkgconfigdir='${libdir}/pkgconfig'])
 
 AC_CHECK_HEADER([linux/dccp.h])
 
@@ -69,6 +72,7 @@ AC_SUBST([kinclude_CFLAGS])
 AC_SUBST([kbuilddir])
 AC_SUBST([ksourcedir])
 AC_SUBST([xtlibdir])
+AC_SUBST([pkgconfigdir])
 
 XTABLES_VERSION_MAJOR=_XTABLES_VERSION_MAJOR
 XTABLES_VERSION_MINOR=_XTABLES_VERSION_MINOR
@@ -79,4 +83,5 @@ AC_SUBST([XTABLES_VERSION_MINOR])
 AC_SUBST([XTABLES_VERSION_PATCH])
 AC_SUBST([XTABLES_VERSION_EXTRA])
 
-AC_OUTPUT([Makefile extensions/GNUmakefile libipq/Makefile include/xtables.h])
+AC_OUTPUT([Makefile extensions/GNUmakefile libipq/Makefile include/xtables.h
+	xtables.pc])
diff --git a/xtables.pc.in b/xtables.pc.in
new file mode 100644
index 0000000..7246d7b
--- /dev/null
+++ b/xtables.pc.in
@@ -0,0 +1,11 @@
+
+prefix=@prefix@
+exec_prefix=@exec_prefix@
+libdir=@libdir@
+xtlibdir=@xtlibdir@
+includedir=@includedir@
+
+Name:		xtables
+Description:	Shared Xtables code for extensions and iproute2
+Version:	@PACKAGE_VERSION@
+Libs:		-lxtables

