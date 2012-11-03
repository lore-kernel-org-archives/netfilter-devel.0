From: Eric Leblond <eric@regit.org>
Subject: [PATCH 2/4] Add configure flag to disable NFCT build
Date: Sat,  3 Nov 2012 12:32:59 +0100
Message-ID: <1351942382-24791-3-git-send-email-eric@regit.org>
References: <1351942382-24791-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:49005 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab2KCMDX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Nov 2012 08:03:23 -0400
In-Reply-To: <1351942382-24791-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 configure.ac           |    8 +++++++-
 input/flow/Makefile.am |    2 ++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 159cb0b..5bb8644 100644
--- a/configure.ac
+++ b/configure.ac
@@ -44,8 +44,14 @@ AC_SUBST([regular_CFLAGS])
 dnl Check for the right nfnetlink version
 PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 1.0.1])
 PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
-PKG_CHECK_MODULES([LIBNETFILTER_CONNTRACK], [libnetfilter_conntrack >= 1.0.2])
 PKG_CHECK_MODULES([LIBNETFILTER_LOG], [libnetfilter_log >= 1.0.0])
+AC_ARG_ENABLE(nfct,
+       AS_HELP_STRING([--enable-nfct], [Enable nfct module [default=yes]]),,[enable_nfct=yes])
+AS_IF([test "x$enable_nfct" = "xyes"], [
+    PKG_CHECK_MODULES([LIBNETFILTER_CONNTRACK], [libnetfilter_conntrack >= 1.0.2])
+    AC_DEFINE([BUILD_NFCT], [1], [Building nfct module])
+])
+AM_CONDITIONAL([BUILD_NFCT], [test "x$enable_nfct" = "xyes"])
 AC_ARG_ENABLE(nfacct,
        AS_HELP_STRING([--enable-nfacct], [Enable nfacct module [default=yes]]),,[enable_nfacct=yes])
 AS_IF([test "x$enable_nfacct" = "xyes"], [
diff --git a/input/flow/Makefile.am b/input/flow/Makefile.am
index 127caf6..36c34ca 100644
--- a/input/flow/Makefile.am
+++ b/input/flow/Makefile.am
@@ -2,11 +2,13 @@
 AM_CPPFLAGS = -I$(top_srcdir)/include
 AM_CFLAGS = ${regular_CFLAGS}
 
+if BUILD_NFCT
 pkglib_LTLIBRARIES = ulogd_inpflow_NFCT.la # ulogd_inpflow_IPFIX.la
 
 ulogd_inpflow_NFCT_la_SOURCES = ulogd_inpflow_NFCT.c
 ulogd_inpflow_NFCT_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_CONNTRACK_LIBS)
 ulogd_inpflow_NFCT_la_CFLAGS = $(AM_CFLAGS) $(LIBNETFILTER_CONNTRACK_CFLAGS)
+endif
 
 #ulogd_inpflow_IPFIX_la_SOURCES = ulogd_inpflow_IPFIX.c
 #ulogd_inpflow_IPFIX_la_LDFLAGS = -avoid-version -module
-- 
1.7.10.4

