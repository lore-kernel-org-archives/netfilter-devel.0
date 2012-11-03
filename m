From: Eric Leblond <eric@regit.org>
Subject: [PATCH 3/4] Add configure flag to disable NFLOG build
Date: Sat,  3 Nov 2012 12:33:00 +0100
Message-ID: <1351942382-24791-4-git-send-email-eric@regit.org>
References: <1351942382-24791-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:49001 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590Ab2KCMDT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Nov 2012 08:03:19 -0400
In-Reply-To: <1351942382-24791-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 configure.ac             |    8 +++++++-
 input/packet/Makefile.am |    4 ++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 5bb8644..930aef0 100644
--- a/configure.ac
+++ b/configure.ac
@@ -44,7 +44,13 @@ AC_SUBST([regular_CFLAGS])
 dnl Check for the right nfnetlink version
 PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 1.0.1])
 PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
-PKG_CHECK_MODULES([LIBNETFILTER_LOG], [libnetfilter_log >= 1.0.0])
+AC_ARG_ENABLE(nflog,
+       AS_HELP_STRING([--enable-nflog], [Enable nflog module [default=yes]]),,[enable_nflog=yes])
+AS_IF([test "x$enable_nflog" = "xyes"], [
+    PKG_CHECK_MODULES([LIBNETFILTER_LOG], [libnetfilter_log >= 1.0.0])
+    AC_DEFINE([BUILD_NFLOG], [1], [Building nflog module])
+])
+AM_CONDITIONAL([BUILD_NFLOG], [test "x$enable_nflog" = "xyes"])
 AC_ARG_ENABLE(nfct,
        AS_HELP_STRING([--enable-nfct], [Enable nfct module [default=yes]]),,[enable_nfct=yes])
 AS_IF([test "x$enable_nfct" = "xyes"], [
diff --git a/input/packet/Makefile.am b/input/packet/Makefile.am
index 250543b..7d278d1 100644
--- a/input/packet/Makefile.am
+++ b/input/packet/Makefile.am
@@ -2,12 +2,16 @@
 AM_CPPFLAGS = -I$(top_srcdir)/include
 AM_CFLAGS = ${regular_CFLAGS}
 
+if BUILD_NFLOG
 pkglib_LTLIBRARIES = ulogd_inppkt_NFLOG.la ulogd_inppkt_ULOG.la \
 			 ulogd_inppkt_UNIXSOCK.la
 
 ulogd_inppkt_NFLOG_la_SOURCES = ulogd_inppkt_NFLOG.c
 ulogd_inppkt_NFLOG_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_LOG_LIBS)
 ulogd_inppkt_NFLOG_la_CFLAGS = $(AM_CFLAGS) $(LIBNETFILTER_LOG_CFLAGS)
+else
+pkglib_LTLIBRARIES = ulogd_inppkt_ULOG.la ulogd_inppkt_UNIXSOCK.la
+endif
 
 ulogd_inppkt_ULOG_la_SOURCES = ulogd_inppkt_ULOG.c
 ulogd_inppkt_ULOG_la_LDFLAGS = -avoid-version -module
-- 
1.7.10.4

