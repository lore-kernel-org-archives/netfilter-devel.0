From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/7] build: no need for error message in PKG_CHECK_MODULES
Date: Sun, 31 Oct 2010 00:08:20 +0200
Message-ID: <1288476502-18721-7-git-send-email-jengelh@medozas.de>
References: <1288476502-18721-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46358 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776Ab0J3WJI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:09:08 -0400
In-Reply-To: <1288476502-18721-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

PKG_CHECK_MODULES already produces its own (and more verbose) messsage
when a module cannot be found.

Mucking around with CFLAGS and LIBS is also not needed since pkgconfig
takes care of providing variables, so let's use them in Makefile.am.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac              |   13 -------------
 src/Makefile.am           |    6 +++---
 src/conntrack/Makefile.am |    3 +--
 src/expect/Makefile.am    |    3 +--
 4 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/configure.ac b/configure.ac
index d5b65af..429f0a7 100644
--- a/configure.ac
+++ b/configure.ac
@@ -19,14 +19,6 @@ case "$host" in
 esac
 
 dnl Dependencies
-AC_CHECK_PROG(HAVE_PKG_CONFIG, pkg-config, yes)
-if test "x$HAVE_PKG_CONFIG" = "x"
-then
-	echo "*** Error: No suitable pkg-config found. ***"
-	echo "    Please install the 'pkg-config' package."
-	exit 1
-fi
-
 PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 1.0.0])
 
 AC_CHECK_HEADERS(arpa/inet.h)
@@ -69,11 +61,6 @@ if test ! -z "$libdir"; then
 	CFLAGS="$CFLAGS -DLIBNETFILTER_CONNTRACK_DIR=$MODULE_DIR"
 fi
 
-CFLAGS="$CFLAGS $LIBNFNETLINK_CFLAGS"
-LIBNFCONNTRACK_LIBS="$LIBNFNETLINK_LIBS"
-
-AC_SUBST(LIBNFCONNTRACK_LIBS)
-
 dnl Output the makefile
 AC_OUTPUT(Makefile src/Makefile include/Makefile utils/Makefile qa/Makefile include/libnetfilter_conntrack/Makefile include/internal/Makefile src/conntrack/Makefile src/expect/Makefile libnetfilter_conntrack.pc doxygen.cfg)
 
diff --git a/src/Makefile.am b/src/Makefile.am
index 7816f07..2e9ccd0 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -6,13 +6,13 @@ include $(top_srcdir)/Make_global.am
 
 SUBDIRS=conntrack expect
 
-AM_CFLAGS = -Wall
-LIBS = @LIBNFCONNTRACK_LIBS@
+AM_CFLAGS = -Wall ${LIBNFNETLINK_CFLAGS}
 
 lib_LTLIBRARIES = libnetfilter_conntrack.la 
 
 libnetfilter_conntrack_la_LIBADD = conntrack/libnfconntrack.la \
-				   expect/libnfexpect.la
+				   expect/libnfexpect.la \
+				   ${LIBNFNETLINK_LIBS}
 libnetfilter_conntrack_la_LDFLAGS = -Wc,-nostartfiles -lnfnetlink -ldl 	\
 				    -version-info $(LIBVERSION)
 libnetfilter_conntrack_la_SOURCES = main.c
diff --git a/src/conntrack/Makefile.am b/src/conntrack/Makefile.am
index 51d03c0..68c2d72 100644
--- a/src/conntrack/Makefile.am
+++ b/src/conntrack/Makefile.am
@@ -1,7 +1,6 @@
 include $(top_srcdir)/Make_global.am
 
-AM_CFLAGS = -Wall
-LIBS = @LIBNFCONNTRACK_LIBS@
+AM_CFLAGS = -Wall ${LIBNFNETLINK_CFLAGS}
 
 noinst_LTLIBRARIES = libnfconntrack.la 
 
diff --git a/src/expect/Makefile.am b/src/expect/Makefile.am
index 719ed23..b0404ba 100644
--- a/src/expect/Makefile.am
+++ b/src/expect/Makefile.am
@@ -1,7 +1,6 @@
 include $(top_srcdir)/Make_global.am
 
-AM_CFLAGS = -Wall
-LIBS = @LIBNFCONNTRACK_LIBS@
+AM_CFLAGS = -Wall ${LIBNFNETLINK_CFLAGS}
 
 noinst_LTLIBRARIES = libnfexpect.la 
 
-- 
1.7.1

