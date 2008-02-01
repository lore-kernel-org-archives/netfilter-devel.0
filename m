From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [07/10] [NETFILTER]: Combine IP[6]T_LIB_DIR into XTABLES_LIBDIR.
Date: Fri, 1 Feb 2008 01:29:32 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802010129140.4864@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801312315120.4864@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38774 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbYBAA3e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2008 19:29:34 -0500
In-Reply-To: <Pine.LNX.4.64.0801312315120.4864@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Combine IP[6]T_LIB_DIR into XTABLES_LIBDIR.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 configure.ac              |   12 ++++++------
 extensions/GNUmakefile.in |    6 +++---
 include/ip6tables.h       |    4 ----
 include/iptables.h        |    4 ----
 include/xtables.h         |    4 ----
 ip6tables-restore.c       |    8 +++++---
 ip6tables-save.c          |    8 +++++---
 ip6tables-standalone.c    |    8 +++++---
 iptables-restore.c        |    8 +++++---
 iptables-save.c           |    8 +++++---
 iptables-standalone.c     |    8 +++++---
 libiptc/libiptc.c         |    4 ----
 12 files changed, 39 insertions(+), 43 deletions(-)

Index: iptables/configure.ac
===================================================================
--- iptables.orig/configure.ac
+++ iptables/configure.ac
@@ -22,11 +22,11 @@ AC_ARG_WITH([ksource],
 	AS_HELP_STRING([--with-ksource=PATH],
 	[Path to kernel source directory [[/lib/modules/CURRENT/source]]]),
 	[ksourcedir="$withval"])
-AC_ARG_WITH([iptdir],
-	AS_HELP_STRING([--with-iptdir=PATH],
+AC_ARG_WITH([xtlibdir],
+	AS_HELP_STRING([--with-xtlibdir=PATH],
 	[Path to iptables modules [[LIBEXECDIR/iptables]]]),
-	[iptdir="$withval"],
-	[iptdir="${libexecdir}/iptables"])
+	[xtlibdir="$withval"],
+	[xtlibdir="${libexecdir}/iptables"])
 AC_ARG_ENABLE([devel],
 	AS_HELP_STRING([--enable-devel],
 	[Build and install development files (libipq, libipq-devel, iptables-devel)]))
@@ -40,11 +40,11 @@ regular_CFLAGS="-D_LARGEFILE_SOURCE=1 -D
 	-D_REENTRANT -Wall -Waggregate-return -Wmissing-declarations \
 	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes \
 	-Winline -pipe -DIPTABLES_VERSION=\\\"$PACKAGE_VERSION\\\" \
-	-DIPT_LIB_DIR=\\\"\${iptdir}\\\" -DIP6T_LIB_DIR=\\\"\${iptdir}\\\"";
+	-DXTABLES_LIBDIR=\\\"\${xtlibdir}\\\"";
 kinclude_CFLAGS="-I\"$kbuilddir/include\" -I\"$ksourcedir/include\"";
 
 AC_SUBST([regular_CFLAGS kinclude_CFLAGS])
 AC_SUBST([kbuilddir])
 AC_SUBST([ksourcedir])
-AC_SUBST([iptdir])
+AC_SUBST([xtlibdir])
 AC_OUTPUT([Makefile extensions/GNUmakefile libipq/Makefile])
Index: iptables/extensions/GNUmakefile.in
===================================================================
--- iptables.orig/extensions/GNUmakefile.in
+++ iptables/extensions/GNUmakefile.in
@@ -7,7 +7,7 @@ prefix      := @prefix@
 exec_prefix := @exec_prefix@
 libdir      := @libdir@
 libexecdir  := @libexecdir@
-iptdir      := @iptdir@
+xtlibdir    := @xtlibdir@
 
 CC             := @CC@
 CCLD           := ${CC}
@@ -82,8 +82,8 @@ targets_install :=
 all: ${targets}
 
 install: ${targets_install}
-	@mkdir -p "${DESTDIR}${iptdir}";
-	install -pm0755 $^ "${DESTDIR}${iptdir}/";
+	@mkdir -p "${DESTDIR}${xtlibdir}";
+	install -pm0755 $^ "${DESTDIR}${xtlibdir}/";
 
 clean:
 	rm -f *.o *.oo *.so *.a {matches,targets}[46].man initext4.c initext6.c;
Index: iptables/include/ip6tables.h
===================================================================
--- iptables.orig/include/ip6tables.h
+++ iptables/include/ip6tables.h
@@ -5,10 +5,6 @@
 
 #include "libiptc/libip6tc.h"
 
-#ifndef IP6T_LIB_DIR
-#define IP6T_LIB_DIR XT_LIB_DIR
-#endif
-
 #ifndef IP6T_SO_GET_REVISION_MATCH /* Old kernel source. */
 #define IP6T_SO_GET_REVISION_MATCH	68
 #define IP6T_SO_GET_REVISION_TARGET	69
Index: iptables/include/iptables.h
===================================================================
--- iptables.orig/include/iptables.h
+++ iptables/include/iptables.h
@@ -4,10 +4,6 @@
 #include "xtables.h"
 #include "libiptc/libiptc.h"
 
-#ifndef IPT_LIB_DIR
-#define IPT_LIB_DIR XT_LIB_DIR
-#endif
-
 #ifndef IPT_SO_GET_REVISION_MATCH /* Old kernel source. */
 #define IPT_SO_GET_REVISION_MATCH	(IPT_BASE_CTL + 2)
 #define IPT_SO_GET_REVISION_TARGET	(IPT_BASE_CTL + 3)
Index: iptables/include/xtables.h
===================================================================
--- iptables.orig/include/xtables.h
+++ iptables/include/xtables.h
@@ -7,10 +7,6 @@
 #include <libiptc/libxtc.h>
 #include <stdbool.h>
 
-#ifndef XT_LIB_DIR
-#define XT_LIB_DIR "/usr/local/lib/iptables"
-#endif
-
 #ifndef IPPROTO_SCTP
 #define IPPROTO_SCTP 132
 #endif
Index: iptables/ip6tables-restore.c
===================================================================
--- iptables.orig/ip6tables-restore.c
+++ iptables/ip6tables-restore.c
@@ -131,9 +131,11 @@ int main(int argc, char *argv[])
 	program_version = IPTABLES_VERSION;
 	line = 0;
 
-	lib_dir = getenv("IP6TABLES_LIB_DIR");
-	if (!lib_dir)
-		lib_dir = IP6T_LIB_DIR;
+	lib_dir = getenv("XTABLES_LIBDIR");
+	if (lib_dir == NULL)
+		lib_dir = getenv("IP6TABLES_LIB_DIR");
+	if (lib_dir == NULL)
+		lib_dir = XTABLES_LIBDIR;
 
 #ifdef NO_SHARED_LIBS
 	init_extensions();
Index: iptables/ip6tables-save.c
===================================================================
--- iptables.orig/ip6tables-save.c
+++ iptables/ip6tables-save.c
@@ -332,9 +332,11 @@ int main(int argc, char *argv[])
 	program_name = "ip6tables-save";
 	program_version = IPTABLES_VERSION;
 
-	lib_dir = getenv("IP6TABLES_LIB_DIR");
-	if (!lib_dir)
-		lib_dir = IP6T_LIB_DIR;
+	lib_dir = getenv("XTABLES_LIBDIR");
+	if (lib_dir == NULL)
+		lib_dir = getenv("IP6TABLES_LIB_DIR");
+	if (lib_dir == NULL)
+		lib_dir = XTABLES_LIBDIR;
 
 #ifdef NO_SHARED_LIBS
 	init_extensions();
Index: iptables/ip6tables-standalone.c
===================================================================
--- iptables.orig/ip6tables-standalone.c
+++ iptables/ip6tables-standalone.c
@@ -52,9 +52,11 @@ main(int argc, char *argv[])
 	program_name = "ip6tables";
 	program_version = IPTABLES_VERSION;
 
-	lib_dir = getenv("IP6TABLES_LIB_DIR");
-	if (!lib_dir)
-		lib_dir = IP6T_LIB_DIR;
+	lib_dir = getenv("XTABLES_LIBDIR");
+	if (lib_dir == NULL)
+		lib_dir = getenv("IP6TABLES_LIB_DIR");
+	if (lib_dir == NULL)
+		lib_dir = XTABLES_LIBDIR;
 
 #ifdef NO_SHARED_LIBS
 	init_extensions();
Index: iptables/iptables-restore.c
===================================================================
--- iptables.orig/iptables-restore.c
+++ iptables/iptables-restore.c
@@ -132,9 +132,11 @@ main(int argc, char *argv[])
 	program_version = IPTABLES_VERSION;
 	line = 0;
 
-	lib_dir = getenv("IPTABLES_LIB_DIR");
-	if (!lib_dir)
-		lib_dir = IPT_LIB_DIR;
+	lib_dir = getenv("XTABLES_LIBDIR");
+	if (lib_dir == NULL)
+		lib_dir = getenv("IPTABLES_LIB_DIR");
+	if (lib_dir == NULL)
+		lib_dir = XTABLES_LIBDIR;
 
 #ifdef NO_SHARED_LIBS
 	init_extensions();
Index: iptables/iptables-save.c
===================================================================
--- iptables.orig/iptables-save.c
+++ iptables/iptables-save.c
@@ -357,9 +357,11 @@ main(int argc, char *argv[])
 	program_name = "iptables-save";
 	program_version = IPTABLES_VERSION;
 
-	lib_dir = getenv("IPTABLES_LIB_DIR");
-	if (!lib_dir)
-		lib_dir = IPT_LIB_DIR;
+	lib_dir = getenv("XTABLES_LIBDIR");
+	if (lib_dir == NULL)
+		lib_dir = getenv("IPTABLES_LIB_DIR");
+	if (lib_dir == NULL)
+		lib_dir = XTABLES_LIBDIR;
 
 #ifdef NO_SHARED_LIBS
 	init_extensions();
Index: iptables/iptables-standalone.c
===================================================================
--- iptables.orig/iptables-standalone.c
+++ iptables/iptables-standalone.c
@@ -53,9 +53,11 @@ main(int argc, char *argv[])
 	program_name = "iptables";
 	program_version = IPTABLES_VERSION;
 
-	lib_dir = getenv("IPTABLES_LIB_DIR");
-	if (!lib_dir)
-		lib_dir = IPT_LIB_DIR;
+	lib_dir = getenv("XTABLES_LIBDIR");
+	if (lib_dir == NULL)
+		lib_dir = getenv("IPTABLES_LIB_DIR");
+	if (lib_dir == NULL)
+		lib_dir = XTABLES_LIBDIR;
 
 #ifdef NO_SHARED_LIBS
 	init_extensions();
Index: iptables/libiptc/libiptc.c
===================================================================
--- iptables.orig/libiptc/libiptc.c
+++ iptables/libiptc/libiptc.c
@@ -46,10 +46,6 @@
 #define debug(x, args...)
 #endif
 
-#ifndef IPT_LIB_DIR
-#define IPT_LIB_DIR "/usr/local/lib/iptables"
-#endif
-
 static int sockfd = -1;
 static int sockfd_use = 0;
 static void *iptc_fn = NULL;
