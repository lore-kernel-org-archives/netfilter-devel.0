From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 2/3] Make NFLOG and NFCT build conditionnal
Date: Thu, 11 Sep 2008 22:48:04 +0200
Message-ID: <1221166085-23435-3-git-send-email-eric@inl.fr>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:47377 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752015AbYIKUsK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2008 16:48:10 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies the build system behaviour to be able to compile
ulogd on system without recent release of libnetfilter library. If
a library is absent or too old, it will simply not compile the concerned
input module.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 configure.in             |    9 ++++++---
 input/flow/Makefile.am   |    2 ++
 input/packet/Makefile.am |    5 +++++
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/configure.in b/configure.in
index 0e173a3..3ddcae5 100644
--- a/configure.in
+++ b/configure.in
@@ -37,12 +37,15 @@ LIBNFNETLINK_REQUIRED=0.0.39
 LIBNETFILTER_CONNTRACK_REQUIRED=0.0.95
 LIBNETFILTER_LOG_REQUIRED=0.0.15
 
-PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED,, AC_MSG_ERROR(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED))
+PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED, nfnetlink="yes", AC_MSG_WARN(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED to build NFLOG and NFCT plugin))
 
-PKG_CHECK_MODULES(LIBNETFILTER_CONNTRACK, libnetfilter_conntrack >= $LIBNETFILTER_CONNTRACK_REQUIRED,, AC_MSG_ERROR(Cannot find libnetfilter_conntrack >= $LIBNETFILTER_CONNTRACK_REQUIRED))
+PKG_CHECK_MODULES(LIBNETFILTER_CONNTRACK, libnetfilter_conntrack >= $LIBNETFILTER_CONNTRACK_REQUIRED, nfconntrack="yes", AC_MSG_WARN(Cannot find libnetfilter_conntrack >= $LIBNETFILTER_CONNTRACK_REQUIRED to build NFCT plugin))
 
-PKG_CHECK_MODULES(LIBNETFILTER_LOG, libnetfilter_log >= $LIBNETFILTER_LOG_REQUIRED,, AC_MSG_ERROR(Cannot find libnetfilter_log >= $LIBNETFILTER_LOG_REQUIRED))
+AM_CONDITIONAL(HAVE_LIBNFCONNTRACK, test "x$nfnetlink" != "x" -a "x$nfconntrack" != "x")
 
+PKG_CHECK_MODULES(LIBNETFILTER_LOG, libnetfilter_log >= $LIBNETFILTER_LOG_REQUIRED, nflog="yes", AC_MSG_WARN(Cannot find libnetfilter_log >= $LIBNETFILTER_LOG_REQUIRED to build NFLOG plugin))
+
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

