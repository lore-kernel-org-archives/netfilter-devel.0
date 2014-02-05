From: Matthieu Crapet <Matthieu.Crapet@ingenico.com>
Subject: [RFC libnetfilter_log][PATCH] configure: add --without-ipulog option to disable libipulog build
Date: Wed, 5 Feb 2014 14:18:57 +0100
Message-ID: <1391606337-8706-1-git-send-email-Matthieu.Crapet@ingenico.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Matthieu Crapet <Matthieu.Crapet@ingenico.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.ingenico.com ([217.108.148.240]:6052 "EHLO
	smtp1.ingenico.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaBENeS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 08:34:18 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a compat library used for netfilter ULOG target.
ULOG only works with IPv4. NFLOG has replaced ULOG.

Signed-off-by: Matthieu Crapet <Matthieu.Crapet@ingenico.com>
---
 configure.ac                         |    5 +++++
 include/libnetfilter_log/Makefile.am |    4 ++++
 src/Makefile.am                      |    6 +++++-
 utils/Makefile.am                    |    7 +++++--
 4 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/configure.ac b/configure.ac
index fe6e75f..01f6890 100644
--- a/configure.ac
+++ b/configure.ac
@@ -23,6 +23,11 @@ case "$host" in
 *) AC_MSG_ERROR([Linux only, dude!]);;
 esac
 
+AC_ARG_WITH([ipulog],
+  AC_HELP_STRING([--without-ipulog], [don't build libipulog compat library]),
+  [ipulog_skip=1], [ipulog_skip=0])
+AM_CONDITIONAL([BUILD_IPULOG], [test $ipulog_skip = 0])
+
 dnl Dependencies
 PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 0.0.41])
 
diff --git a/include/libnetfilter_log/Makefile.am b/include/libnetfilter_log/Makefile.am
index fe934f1..0305357 100644
--- a/include/libnetfilter_log/Makefile.am
+++ b/include/libnetfilter_log/Makefile.am
@@ -1,3 +1,7 @@
 
+if BUILD_IPULOG
 pkginclude_HEADERS = libnetfilter_log.h libipulog.h linux_nfnetlink_log.h
+else
+pkginclude_HEADERS = libnetfilter_log.h linux_nfnetlink_log.h
+endif
 
diff --git a/src/Makefile.am b/src/Makefile.am
index 10a66e2..33933a4 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -22,14 +22,18 @@ LIBVERSION=2:0:1
 
 include ${top_srcdir}/Make_global.am
 
-lib_LTLIBRARIES = libnetfilter_log.la libnetfilter_log_libipulog.la
+lib_LTLIBRARIES = libnetfilter_log.la
 
 libnetfilter_log_la_LDFLAGS = -Wc,-nostartfiles -lnfnetlink	\
 			      -version-info $(LIBVERSION)
 libnetfilter_log_la_SOURCES = libnetfilter_log.c 
 libnetfilter_log_la_LIBADD  = ${LIBNFNETLINK_LIBS}
 
+if BUILD_IPULOG
+lib_LTLIBRARIES += libnetfilter_log_libipulog.la
+
 libnetfilter_log_libipulog_la_LDFLAGS = -Wc,-nostartfiles	\
 					-version-info 1:0:0
 libnetfilter_log_libipulog_la_LIBADD = libnetfilter_log.la
 libnetfilter_log_libipulog_la_SOURCES = libipulog_compat.c
+endif
diff --git a/utils/Makefile.am b/utils/Makefile.am
index ae64c90..f961b6c 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -1,12 +1,15 @@
 include ${top_srcdir}/Make_global.am
 
-check_PROGRAMS = nfulnl_test ulog_test
+check_PROGRAMS = nfulnl_test
 
 nfulnl_test_SOURCES = nfulnl_test.c
 nfulnl_test_LDADD = ../src/libnetfilter_log.la
 nfulnl_test_LDFLAGS = -dynamic
 
+if BUILD_IPULOG
+check_PROGRAMS += ulog_test
+
 ulog_test_SOURCES = ulog_test.c
 ulog_test_LDADD = ../src/libnetfilter_log_libipulog.la ../src/libnetfilter_log.la
 ulog_test_LDFLAGS = -dynamic
-
+endif
-- 
1.7.10.4

