From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH] Add flags to disable NFLOG or NFCT at configure time.
Date: Sat, 13 Sep 2008 13:13:13 +0200
Message-ID: <1221304393-30931-1-git-send-email-eric@inl.fr>
References: <48CA4C37.5000306@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:37081 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753137AbYIMLNT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Sep 2008 07:13:19 -0400
In-Reply-To: <48CA4C37.5000306@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds some --without options to configure script that
can be used to disable compilation of some nfnetlink related modules.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 configure.in             |   19 ++++++++++++++++---
 input/flow/Makefile.am   |    2 ++
 input/packet/Makefile.am |    5 +++++
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/configure.in b/configure.in
index 0e173a3..129b95a 100644
--- a/configure.in
+++ b/configure.in
@@ -37,12 +37,25 @@ LIBNFNETLINK_REQUIRED=0.0.39
 LIBNETFILTER_CONNTRACK_REQUIRED=0.0.95
 LIBNETFILTER_LOG_REQUIRED=0.0.15
 
-PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED,, AC_MSG_ERROR(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED))
 
-PKG_CHECK_MODULES(LIBNETFILTER_CONNTRACK, libnetfilter_conntrack >= $LIBNETFILTER_CONNTRACK_REQUIRED,, AC_MSG_ERROR(Cannot find libnetfilter_conntrack >= $LIBNETFILTER_CONNTRACK_REQUIRED))
+AC_ARG_WITH(nfnetlink, [AC_HELP_STRING(--without-nfnetlink,  Disable NFLOG and NFCT)], enable_nfnetlink=$withval, enable_nfnetlink="yes")
+AC_ARG_WITH(nfconntrack, [AC_HELP_STRING(--without-nfconntrack,  Disable NFCT input plugin)], enable_nfconntrack=$withval, enable_nfconntrack="yes")
+AC_ARG_WITH(nflog, [AC_HELP_STRING(--without-nflog,  Disable NFLOG input plugin)], enable_nflog=$withval, enable_nflog="yes")
 
-PKG_CHECK_MODULES(LIBNETFILTER_LOG, libnetfilter_log >= $LIBNETFILTER_LOG_REQUIRED,, AC_MSG_ERROR(Cannot find libnetfilter_log >= $LIBNETFILTER_LOG_REQUIRED))
+if test "$enable_nfnetlink" = "yes"; then
+	PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED, nfnetlink="yes", AC_MSG_ERROR(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED to build NFLOG and NFCT plugin))
 
+	if test "$enable_nfconntrack" = "yes"; then
+		PKG_CHECK_MODULES(LIBNETFILTER_CONNTRACK, libnetfilter_conntrack >= $LIBNETFILTER_CONNTRACK_REQUIRED, nfconntrack="yes", AC_MSG_ERROR(Cannot find libnetfilter_conntrack >= $LIBNETFILTER_CONNTRACK_REQUIRED to build NFCT plugin))
+	fi
+
+	if test "$enable_nflog" = "yes"; then
+		PKG_CHECK_MODULES(LIBNETFILTER_LOG, libnetfilter_log >= $LIBNETFILTER_LOG_REQUIRED, nflog="yes", AC_MSG_ERROR(Cannot find libnetfilter_log >= $LIBNETFILTER_LOG_REQUIRED to build NFLOG plugin))
+	fi
+fi
+
+AM_CONDITIONAL(HAVE_LIBNFCONNTRACK, test "x$nfnetlink" != "x" -a "x$nfconntrack" != "x")
+AM_CONDITIONAL(HAVE_LIBNFLOG, test "x$nfnetlink" != "x" -a "x$nflog" != "x")
 
 CT_CHECK_POSTGRES_DB()
 AM_CONDITIONAL(HAVE_PGSQL, test "x$PQLIBPATH" != "x")
diff --git a/input/flow/Makefile.am b/input/flow/Makefile.am
index 288d335..0751807 100644
--- a/input/flow/Makefile.am
+++ b/input/flow/Makefile.am
@@ -2,11 +2,13 @@
 INCLUDES = $(all_includes) -I$(top_srcdir)/include
 AM_CFLAGS=-fPIC -Wall
 
+if HAVE_LIBNFCONNTRACK
 pkglib_LTLIBRARIES = ulogd_inpflow_NFCT.la # ulogd_inpflow_IPFIX.la
 
 ulogd_inpflow_NFCT_la_SOURCES = ulogd_inpflow_NFCT.c
 ulogd_inpflow_NFCT_la_LDFLAGS = -module $(LIBNETFILTER_CONNTRACK_LIBS)
 ulogd_inpflow_NFCT_la_CFLAGS = $(AM_CFLAGS) $(LIBNETFILTER_CONNTRACK_CFLAGS)
+endif
 
 #ulogd_inpflow_IPFIX_la_SOURCES = ulogd_inpflow_IPFIX.c
 #ulogd_inpflow_IPFIX_la_LDFLAGS = -module
diff --git a/input/packet/Makefile.am b/input/packet/Makefile.am
index a07f724..9f9a89c 100644
--- a/input/packet/Makefile.am
+++ b/input/packet/Makefile.am
@@ -3,11 +3,16 @@ INCLUDES = $(all_includes) -I$(top_srcdir)/include
 AM_CFLAGS=-fPIC -Wall
 LIBS=
 
+if HAVE_LIBNFLOG
 pkglib_LTLIBRARIES = ulogd_inppkt_NFLOG.la ulogd_inppkt_ULOG.la
 
 ulogd_inppkt_NFLOG_la_SOURCES = ulogd_inppkt_NFLOG.c
 ulogd_inppkt_NFLOG_la_LDFLAGS = -module $(LIBNETFILTER_LOG_LIBS)
 ulogd_inppkt_NFLOG_la_CFLAGS = $(AM_CFLAGS) $(LIBNETFILTER_LOG_CFLAGS)
+else
+pkglib_LTLIBRARIES = ulogd_inppkt_ULOG.la
+endif
+
 
 ulogd_inppkt_ULOG_la_SOURCES = ulogd_inppkt_ULOG.c
 ulogd_inppkt_ULOG_la_LDFLAGS = -module
-- 
1.5.4.3

