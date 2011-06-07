From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/5] src: move all libiptc pieces into its directory
Date: Tue,  7 Jun 2011 22:36:00 +0200
Message-ID: <1307478964-2034-3-git-send-email-jengelh@medozas.de>
References: <1307478964-2034-1-git-send-email-jengelh@medozas.de>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:39437 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab1FGUgK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 16:36:10 -0400
In-Reply-To: <1307478964-2034-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 .gitignore            |    1 -
 Makefile.am           |   17 +++--------------
 configure.ac          |    4 ++--
 libiptc.pc.in         |   12 ------------
 libiptc/.gitignore    |    1 +
 libiptc/Makefile.am   |   12 ++++++++++++
 libiptc/libiptc.pc.in |   12 ++++++++++++
 7 files changed, 30 insertions(+), 29 deletions(-)
 delete mode 100644 libiptc.pc.in
 create mode 100644 libiptc/.gitignore
 create mode 100644 libiptc/Makefile.am
 create mode 100644 libiptc/libiptc.pc.in

diff --git a/.gitignore b/.gitignore
index 9d24ce0..fc68536 100644
--- a/.gitignore
+++ b/.gitignore
@@ -36,7 +36,6 @@ Makefile.in
 /ltmain.sh
 /missing
 /stamp-h1
-/libiptc.pc
 /xtables.pc
 
 /ip6tables
diff --git a/Makefile.am b/Makefile.am
index 48f01d8..02b5c09 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -5,7 +5,7 @@ AUTOMAKE_OPTIONS = foreign subdir-objects
 
 AM_CFLAGS        = ${regular_CFLAGS}
 AM_CPPFLAGS      = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CPPFLAGS}
-SUBDIRS          = extensions
+SUBDIRS          = extensions libiptc
 if ENABLE_DEVEL
 SUBDIRS         += include
 endif
@@ -15,19 +15,8 @@ endif
 if HAVE_LIBNFNETLINK
 SUBDIRS         += utils
 endif
-lib_LTLIBRARIES =
 
-# libiptc
-lib_LTLIBRARIES            += libiptc/libip4tc.la libiptc/libip6tc.la libiptc/libiptc.la
-libiptc_libiptc_la_SOURCES  =
-libiptc_libiptc_la_LIBADD   = libiptc/libip4tc.la libiptc/libip6tc.la
-libiptc_libiptc_la_LDFLAGS  = -version-info 0:0:0 ${libiptc_LDFLAGS2}
-libiptc_libip4tc_la_SOURCES = libiptc/libip4tc.c
-libiptc_libip4tc_la_LDFLAGS = -version-info 0:0:0
-libiptc_libip6tc_la_SOURCES = libiptc/libip6tc.c
-libiptc_libip6tc_la_LDFLAGS = -version-info 0:0:0 ${libiptc_LDFLAGS2}
-
-lib_LTLIBRARIES      += libxtables.la
+lib_LTLIBRARIES       = libxtables.la
 libxtables_la_SOURCES = xtables.c xtoptions.c
 libxtables_la_LDFLAGS = -version-info ${libxtables_vcurrent}:0:${libxtables_vage}
 if ENABLE_SHARED
@@ -80,7 +69,7 @@ iptables.8: ${srcdir}/iptables.8.in extensions/matches4.man extensions/targets4.
 ip6tables.8: ${srcdir}/ip6tables.8.in extensions/matches6.man extensions/targets6.man
 	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' -e '/@MATCH@/ r extensions/matches6.man' -e '/@TARGET@/ r extensions/targets6.man' $< >$@;
 
-pkgconfig_DATA = libiptc.pc xtables.pc
+pkgconfig_DATA = xtables.pc
 
 .PHONY: tarball
 tarball:
diff --git a/configure.ac b/configure.ac
index daed602..f3de3d3 100644
--- a/configure.ac
+++ b/configure.ac
@@ -111,6 +111,6 @@ libxtables_vmajor=$(($libxtables_vcurrent - $libxtables_vage));
 AC_SUBST([libxtables_vmajor])
 
 AC_CONFIG_FILES([Makefile extensions/GNUmakefile include/Makefile
-	libipq/Makefile utils/Makefile
-	include/xtables.h include/iptables/internal.h libiptc.pc xtables.pc])
+	libipq/Makefile libiptc/Makefile libiptc/libiptc.pc utils/Makefile
+	include/xtables.h include/iptables/internal.h xtables.pc])
 AC_OUTPUT
diff --git a/libiptc.pc.in b/libiptc.pc.in
deleted file mode 100644
index 99a3544..0000000
--- a/libiptc.pc.in
+++ /dev/null
@@ -1,12 +0,0 @@
-
-prefix=@prefix@
-exec_prefix=@exec_prefix@
-libdir=@libdir@
-includedir=@includedir@
-
-Name:		libiptc
-Description:	iptables ruleset ADT and kernel interface
-Version:	@PACKAGE_VERSION@
-Libs:		-L${libdir} -liptc
-Libs.private:	-lip4tc -lip6tc
-Cflags:		-I${includedir}
diff --git a/libiptc/.gitignore b/libiptc/.gitignore
new file mode 100644
index 0000000..8767550
--- /dev/null
+++ b/libiptc/.gitignore
@@ -0,0 +1 @@
+/libiptc.pc
diff --git a/libiptc/Makefile.am b/libiptc/Makefile.am
new file mode 100644
index 0000000..a7d0ea2
--- /dev/null
+++ b/libiptc/Makefile.am
@@ -0,0 +1,12 @@
+# -*- Makefile -*-
+
+pkgconfig_DATA      = libiptc.pc
+
+lib_LTLIBRARIES     = libip4tc.la libip6tc.la libiptc.la
+libiptc_la_SOURCES  =
+libiptc_la_LIBADD   = libip4tc.la libip6tc.la
+libiptc_la_LDFLAGS  = -version-info 0:0:0 ${libiptc_LDFLAGS2}
+libip4tc_la_SOURCES = libip4tc.c
+libip4tc_la_LDFLAGS = -version-info 0:0:0
+libip6tc_la_SOURCES = libip6tc.c
+libip6tc_la_LDFLAGS = -version-info 0:0:0 ${libiptc_LDFLAGS2}
diff --git a/libiptc/libiptc.pc.in b/libiptc/libiptc.pc.in
new file mode 100644
index 0000000..99a3544
--- /dev/null
+++ b/libiptc/libiptc.pc.in
@@ -0,0 +1,12 @@
+
+prefix=@prefix@
+exec_prefix=@exec_prefix@
+libdir=@libdir@
+includedir=@includedir@
+
+Name:		libiptc
+Description:	iptables ruleset ADT and kernel interface
+Version:	@PACKAGE_VERSION@
+Libs:		-L${libdir} -liptc
+Libs.private:	-lip4tc -lip6tc
+Cflags:		-I${includedir}
-- 
1.7.3.4

