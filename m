From: Eric Leblond <eric@regit.org>
Subject: [PATCH 1/4] Add configure flag to disable NFACCT build
Date: Sat,  3 Nov 2012 12:32:58 +0100
Message-ID: <1351942382-24791-2-git-send-email-eric@regit.org>
References: <1351942382-24791-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:49003 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab2KCMDV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Nov 2012 08:03:21 -0400
In-Reply-To: <1351942382-24791-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It is now possible to pass the --disable-nfacct flag to disable
compilation of NFACCT input plugin. Doing this the build of ulogd
is possible on system where nfacct is not available.
---
 configure.ac              |    8 +++++++-
 input/sum/Makefile.am     |    4 ++--
 output/ulogd_output_XML.c |    7 ++++++-
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index 0f21cf1..159cb0b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -44,9 +44,15 @@ AC_SUBST([regular_CFLAGS])
 dnl Check for the right nfnetlink version
 PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 1.0.1])
 PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
-PKG_CHECK_MODULES([LIBNETFILTER_ACCT], [libnetfilter_acct >= 1.0.1])
 PKG_CHECK_MODULES([LIBNETFILTER_CONNTRACK], [libnetfilter_conntrack >= 1.0.2])
 PKG_CHECK_MODULES([LIBNETFILTER_LOG], [libnetfilter_log >= 1.0.0])
+AC_ARG_ENABLE(nfacct,
+       AS_HELP_STRING([--enable-nfacct], [Enable nfacct module [default=yes]]),,[enable_nfacct=yes])
+AS_IF([test "x$enable_nfacct" = "xyes"], [
+    PKG_CHECK_MODULES([LIBNETFILTER_ACCT], [libnetfilter_acct >= 1.0.1])
+    AC_DEFINE([BUILD_NFACCT], [1], [Building nfacct module])
+])
+AM_CONDITIONAL([BUILD_NFACCT], [test "x$enable_nfacct" = "xyes"])
 
 CT_CHECK_POSTGRES_DB()
 AM_CONDITIONAL(HAVE_PGSQL, test "x$PQLIBPATH" != "x")
diff --git a/input/sum/Makefile.am b/input/sum/Makefile.am
index 33fa849..b6ddb4d 100644
--- a/input/sum/Makefile.am
+++ b/input/sum/Makefile.am
@@ -1,8 +1,8 @@
 AM_CPPFLAGS = -I$(top_srcdir)/include $(LIBNETFILTER_ACCT_CFLAGS) $(LIBMNL_CFLAGS)
 AM_CFLAGS = ${regular_CFLAGS}
-
+if BUILD_NFACCT
 pkglib_LTLIBRARIES = ulogd_inpflow_NFACCT.la
-
 ulogd_inpflow_NFACCT_la_SOURCES = ulogd_inpflow_NFACCT.c
 ulogd_inpflow_NFACCT_la_LDFLAGS = -avoid-version -module
 ulogd_inpflow_NFACCT_la_LIBADD  = $(LIBMNL_LIBS) $(LIBNETFILTER_ACCT_LIBS)
+endif
diff --git a/output/ulogd_output_XML.c b/output/ulogd_output_XML.c
index e9c3974..616e6c0 100644
--- a/output/ulogd_output_XML.c
+++ b/output/ulogd_output_XML.c
@@ -20,7 +20,10 @@
 
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 #include <libnetfilter_log/libnetfilter_log.h>
+#include "../config.h"
+#ifdef BUILD_NFACCT
 #include <libnetfilter_acct/libnetfilter_acct.h>
+#endif
 #include <ulogd/ulogd.h>
 #include <sys/param.h>
 #include <time.h>
@@ -118,6 +121,7 @@ xml_output_packet(struct ulogd_key *inp, char *buf, ssize_t size)
 static int
 xml_output_sum(struct ulogd_key *inp, char *buf, ssize_t size)
 {
+#ifdef BUILD_NFACCT
 	struct nfacct *nfacct = ikey_get_ptr(&inp[KEY_SUM]);
 	int tmp;
 
@@ -125,10 +129,11 @@ xml_output_sum(struct ulogd_key *inp, char *buf, ssize_t size)
 						 NFACCT_SNPRINTF_F_TIME);
 	if (tmp < 0 || tmp >= size)
 		return -1;
-
+#endif
 	return 0;
 }
 
+
 static int xml_output(struct ulogd_pluginstance *upi)
 {
 	struct ulogd_key *inp = upi->input.keys;
-- 
1.7.10.4

