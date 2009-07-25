From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/5] build: combine iptables-multi and iptables-static
Date: Sat, 25 Jul 2009 22:22:42 +0200
Message-ID: <1248553363-26903-5-git-send-email-jengelh@medozas.de>
References: <1248553363-26903-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55095 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbZGYUWu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 25 Jul 2009 16:22:50 -0400
In-Reply-To: <1248553363-26903-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changed the Makefile so that:

1. --enable-shared / --disable-shared control the linkage against
   libdl (and thus the potential to use 3rd party extensions)

2. --enable-static / --disable-static controls whether shipped
   extensions are built-in or provided as modules

iptables-static becomes redundant by this action; iptables-multi now
has the feature.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 INSTALL                   |   41 ++++++++++++++++++++++++++++++-----------
 Makefile.am               |   32 ++++++++++++--------------------
 extensions/GNUmakefile.in |    4 ++--
 include/xtables.h.in      |    2 +-
 ip6tables-restore.c       |    2 +-
 ip6tables-save.c          |    2 +-
 ip6tables-standalone.c    |    2 +-
 iptables-restore.c        |    2 +-
 iptables-save.c           |    2 +-
 iptables-standalone.c     |    2 +-
 10 files changed, 51 insertions(+), 40 deletions(-)

diff --git a/INSTALL b/INSTALL
index 4a44989..acb56cd 100644
--- a/INSTALL
+++ b/INSTALL
@@ -41,18 +41,22 @@ Configuring and compiling
 
 	It is enabled by default.
 
+--enable-static
+
+	Produce additional binaries, iptables-static/ip6tables-static,
+	which have all shipped extensions compiled in.
+
+--disable-shared
+
+	Produce binaries that have dynamic loading of extensions disabled.
+	This implies --enable-static.
+	(See some details below.)
+
 --enable-libipq
 
 	This option causes libipq to be installed into ${libdir} and
 	${includedir}.
 
---enable-static
-
-	Enable building single standalone multipurpose binaries,
-	(iptables-static and ip6tables-static), which contain every
-	extension compiled-in (and does not support additional
-	extensions).
-
 --with-ksource=
 
 	Xtables does not depend on kernel headers anymore, but you can
@@ -74,7 +78,22 @@ The make process will automatically build multipurpose binaries.
 These have the core (iptables), -save, -restore and -xml code
 compiled into one binary, but extensions remain as modules.
 
-If you want to build a statically linked version of the iptables binary,
-without the need for loading the plugins at runtime (e.g. for an
-embedded device or router-on-a-disk), you can use the --enable-static
-configure flag.
+
+Static and shared
+=================
+
+Basically there are three configuration modes defined:
+
+ --disable-static --enable-shared (this is the default)
+
+	Build a binary that relies upon dynamic loading of extensions.
+
+ --enable-static --enable-shared
+
+	Build a binary that has the shipped extensions built-in, but
+	is still capable of loading additional extensions.
+
+ --enable-static --disable-shared
+
+	Shipped extensions are built-in, and dynamic loading is
+	deactivated.
diff --git a/Makefile.am b/Makefile.am
index 23cdedd..fc779e9 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -26,7 +26,13 @@ libiptc_libip6tc_la_LDFLAGS = -version-info 0:0:0
 lib_LTLIBRARIES      += libxtables.la
 libxtables_la_SOURCES = xtables.c
 libxtables_la_LDFLAGS = -version-info ${libxtables_vcurrent}:0:${libxtables_vage}
+if ENABLE_SHARED
+libxtables_la_CFLAGS  = ${AM_CFLAGS}
 libxtables_la_LIBADD  = -ldl
+else
+libxtables_la_CFLAGS  = ${AM_CFLAGS} -DNO_SHARED_LIBS=1
+libxtables_la_LIBADD  =
+endif
 
 # iptables, dynamic
 iptables_SOURCES          = iptables-standalone.c iptables.c xshared.c
@@ -38,6 +44,9 @@ iptables_multi_SOURCES    = iptables-multi.c iptables-save.c \
                             iptables-restore.c iptables-xml.c \
                             iptables-standalone.c iptables.c xshared.c
 iptables_multi_CFLAGS     = ${AM_CFLAGS} -DIPTABLES_MULTI
+if ENABLE_STATIC
+iptables_multi_CFLAGS    += -DALL_INCLUSIVE
+endif
 iptables_multi_LDFLAGS    = ${iptables_LDFLAGS}
 iptables_multi_LDADD      = ${iptables_LDADD}
 
@@ -49,11 +58,6 @@ iptables_save_SOURCES     = iptables-save.c iptables.c xshared.c
 iptables_save_LDFLAGS     = ${iptables_LDFLAGS}
 iptables_save_LDADD       = ${iptables_LDADD}
 
-# iptables-multi, semi-static
-iptables_static_SOURCES   = ${iptables_multi_SOURCES} xtables.c
-iptables_static_CFLAGS    = ${iptables_multi_CFLAGS} -DNO_SHARED_LIBS=1
-iptables_static_LDADD     = libiptc/libip4tc.la extensions/libext4.a -lm
-
 iptables_xml_SOURCES      = iptables-xml.c
 
 # ip6tables, dynamic
@@ -65,6 +69,9 @@ ip6tables_multi_SOURCES   = ip6tables-multi.c ip6tables-save.c \
                             ip6tables-restore.c ip6tables-standalone.c \
                             ip6tables.c xshared.c
 ip6tables_multi_CFLAGS    = ${AM_CFLAGS} -DIPTABLES_MULTI
+if ENABLE_STATIC
+ip6tables_multi_CFLAGS   += -DALL_INCLUSIVE
+endif
 ip6tables_multi_LDFLAGS   = ${ip6tables_LDFLAGS}
 ip6tables_multi_LDADD     = ${ip6tables_LDADD}
 
@@ -76,11 +83,6 @@ ip6tables_save_SOURCES    = ip6tables-save.c ip6tables.c xshared.c
 ip6tables_save_LDFLAGS    = ${ip6tables_LDFLAGS}
 ip6tables_save_LDADD      = ${ip6tables_LDADD}
 
-# iptables-multi, semi-static
-ip6tables_static_SOURCES    = ${ip6tables_multi_SOURCES} xtables.c
-ip6tables_static_CFLAGS     = ${ip6tables_multi_CFLAGS} -DNO_SHARED_LIBS=1
-ip6tables_static_LDADD      = libiptc/libip6tc.la extensions/libext6.a -lm
-
 bin_PROGRAMS     = iptables-xml
 sbin_PROGRAMS    =
 noinst_PROGRAMS  =
@@ -89,22 +91,12 @@ man_MANS         = iptables.8 iptables-restore.8 iptables-save.8 \
                    ip6tables-save.8
 CLEANFILES       = iptables.8 ip6tables.8
 
-if ENABLE_STATIC
-if ENABLE_IPV4
-sbin_PROGRAMS += iptables-static
-endif
-if ENABLE_IPV6
-sbin_PROGRAMS += ip6tables-static
-endif
-endif
-if ENABLE_SHARED
 if ENABLE_IPV4
 sbin_PROGRAMS += iptables iptables-multi iptables-restore iptables-save
 endif
 if ENABLE_IPV6
 sbin_PROGRAMS += ip6tables ip6tables-multi ip6tables-restore ip6tables-save
 endif
-endif
 
 iptables.8: ${srcdir}/iptables.8.in extensions/matches4.man extensions/targets4.man
 	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' -e '/@MATCH@/ r extensions/matches4.man' -e '/@TARGET@/ r extensions/targets4.man' $< >$@;
diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index e1f1f49..709366a 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -56,8 +56,8 @@ targets := libext4.a libext6.a matches4.man matches6.man \
 targets_install :=
 @ENABLE_STATIC_TRUE@ libext4_objs := ${pfx_objs} ${pf4_objs}
 @ENABLE_STATIC_TRUE@ libext6_objs := ${pfx_objs} ${pf6_objs}
-@ENABLE_SHARED_TRUE@ targets += ${pfx_solibs} ${pf4_solibs} ${pf6_solibs}
-@ENABLE_SHARED_TRUE@ targets_install += ${pfx_solibs} ${pf4_solibs} ${pf6_solibs}
+@ENABLE_STATIC_FALSE@ targets += ${pfx_solibs} ${pf4_solibs} ${pf6_solibs}
+@ENABLE_STATIC_FALSE@ targets_install += ${pfx_solibs} ${pf4_solibs} ${pf6_solibs}
 
 .SECONDARY:
 
diff --git a/include/xtables.h.in b/include/xtables.h.in
index 7468302..3955716 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -277,7 +277,7 @@ extern void xtables_ip6parse_multiple(const char *, struct in6_addr **,
  */
 extern void xtables_save_string(const char *value);
 
-#ifdef NO_SHARED_LIBS
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 #	ifdef _INIT
 #		undef _init
 #		define _init _INIT
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index 06a82ae..d0efbee 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -137,7 +137,7 @@ int main(int argc, char *argv[])
 				ip6tables_globals.program_version);
 		exit(1);
 	}
-#ifdef NO_SHARED_LIBS
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 #endif
 
diff --git a/ip6tables-save.c b/ip6tables-save.c
index c59608f..dc189e9 100644
--- a/ip6tables-save.c
+++ b/ip6tables-save.c
@@ -148,7 +148,7 @@ int main(int argc, char *argv[])
 				ip6tables_globals.program_version);
 		exit(1);
 	}
-#ifdef NO_SHARED_LIBS
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 #endif
 
diff --git a/ip6tables-standalone.c b/ip6tables-standalone.c
index 649ac3d..8661bd9 100644
--- a/ip6tables-standalone.c
+++ b/ip6tables-standalone.c
@@ -58,7 +58,7 @@ main(int argc, char *argv[])
 		exit(1);
 	}
 
-#ifdef NO_SHARED_LIBS
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 #endif
 
diff --git a/iptables-restore.c b/iptables-restore.c
index 5108fda..86d63e2 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -140,7 +140,7 @@ main(int argc, char *argv[])
 				iptables_globals.program_version);
 		exit(1);
 	}
-#ifdef NO_SHARED_LIBS
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 #endif
 
diff --git a/iptables-save.c b/iptables-save.c
index f63ee6b..3bcf422 100644
--- a/iptables-save.c
+++ b/iptables-save.c
@@ -148,7 +148,7 @@ main(int argc, char *argv[])
 				iptables_globals.program_version);
 		exit(1);
 	}
-#ifdef NO_SHARED_LIBS
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 #endif
 
diff --git a/iptables-standalone.c b/iptables-standalone.c
index 9185388..1f60e31 100644
--- a/iptables-standalone.c
+++ b/iptables-standalone.c
@@ -58,7 +58,7 @@ main(int argc, char *argv[])
 				iptables_globals.program_version);
 				exit(1);
 	}
-#ifdef NO_SHARED_LIBS
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 #endif
 
-- 
1.6.3.3

