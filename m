From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 23/24] Clarify prerequisites of Xtables and update option
 notes
Date: Tue, 4 Mar 2008 17:21:32 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041721170.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35293 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765345AbYCDQVd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:21:33 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit a2f4f8e88552d9505fe22c7246e236d9635d4084
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Mon Mar 3 00:34:48 2008 +0100

    Clarify prerequisites of Xtables and update option notes
---
 INSTALL                             |   26 ++++++++++++++++----------
 Makefile.am                         |    2 +-
 configure.ac                        |    6 +++---
 include/{xtables.h => xtables.h.in} |    2 ++
 4 files changed, 22 insertions(+), 14 deletions(-)
 rename include/{xtables.h => xtables.h.in} (99%)

diff --git a/INSTALL b/INSTALL
index 7b4cb9b..dfac3af 100644
--- a/INSTALL
+++ b/INSTALL
@@ -11,8 +11,10 @@ Xtables uses the well-known configure(autotools) infrastructure.
 Prerequisites
 =============
 
-	* no other packages required
-	  (well, you obviously need the basics like a compiler)
+	* no kernel-source required
+
+	* but obviously a compiler, glibc-devel and linux-kernel-headers
+	  (/usr/include/linux)
 
 
 Configuring and compiling
@@ -26,20 +28,24 @@ Configuring and compiling
 	/usr/local, so the binaries will go into /usr/local/bin, sbin,
 	manpages into /usr/local/share/man, etc.
 
---xtlibdir=
+--with-xtlibdir=
 
 	The path to where Xtables extensions should be installed to. It
 	defaults to ${prefix}/libexec/xtables.
 
---enable-devel
-
-	This causes development files to be installed to
-	${prefix}/include. (By default, no headers and libraries are
-	installed.)
+--enable-devel (or --disable-devel)
 
-	This is needed for building additional packages,
+	This option causes development files to be installed to
+	${includedir}, which is needed for building additional packages,
 	such as Xtables-addons or other 3rd-party extensions.
 
+	It is enabled by default.
+
+--enable-libipq
+
+	This option causes libipq to be installed into ${libdir} and
+	${includedir}.
+
 --enable-static
 
 	Enable building single standalone multipurpose binaries,
@@ -51,7 +57,7 @@ Configuring and compiling
 
 	Xtables does not depend on kernel headers anymore, but you can
 	optionally specify a search path to include anyway. This is
-	probably only useful for development.
+	probably only useful for development and cross-compiling.
 
 If you want to enable debugging, use
 
diff --git a/Makefile.am b/Makefile.am
index 80ef3a0..e9448c8 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -4,7 +4,7 @@ AUTOMAKE_OPTIONS = foreign subdir-objects
 
 regular_CFLAGS  := @regular_CFLAGS@
 kinclude_CFLAGS := @kinclude_CFLAGS@
-AM_CFLAGS        = ${regular_CFLAGS} -I${top_srcdir}/include ${kinclude_CFLAGS}
+AM_CFLAGS        = ${regular_CFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CFLAGS}
 SUBDIRS         := extensions
 if ENABLE_LIBIPQ
 SUBDIRS         += libipq
diff --git a/configure.ac b/configure.ac
index b4bd5c0..829027e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -40,8 +40,7 @@ AM_CONDITIONAL([ENABLE_LIBIPQ], [test "$enable_libipq" == "yes"])
 regular_CFLAGS="-D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64 \
 	-D_REENTRANT -Wall -Waggregate-return -Wmissing-declarations \
 	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes \
-	-Winline -pipe -DXTABLES_VERSION=\\\"$PACKAGE_VERSION\\\" \
-	-DXTABLES_LIBDIR=\\\"\${xtlibdir}\\\"";
+	-Winline -pipe -DXTABLES_LIBDIR=\\\"\${xtlibdir}\\\"";
 kinclude_CFLAGS="";
 if [[ -n "$kbuilddir" ]]; then
 	kinclude_CFLAGS="$kinclude_CFLAGS -I $kbuilddir/include";
@@ -54,4 +53,5 @@ AC_SUBST([regular_CFLAGS kinclude_CFLAGS])
 AC_SUBST([kbuilddir])
 AC_SUBST([ksourcedir])
 AC_SUBST([xtlibdir])
-AC_OUTPUT([Makefile extensions/GNUmakefile libipq/Makefile])
+AC_OUTPUT([Makefile extensions/GNUmakefile libipq/Makefile
+	include/xtables.h])
diff --git a/include/xtables.h b/include/xtables.h.in
similarity index 99%
rename from include/xtables.h
rename to include/xtables.h.in
index 408d199..02fb7a0 100644
--- a/include/xtables.h
+++ b/include/xtables.h.in
@@ -7,6 +7,8 @@
 #include <libiptc/libxtc.h>
 #include <stdbool.h>
 
+#define XTABLES_VERSION "@PACKAGE_VERSION@"
+
 #ifndef IPPROTO_SCTP
 #define IPPROTO_SCTP 132
 #endif
