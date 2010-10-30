From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 08/11] build: no need for error message in PKG_CHECK_MODULES
Date: Sun, 31 Oct 2010 00:09:56 +0200
Message-ID: <1288476600-29859-9-git-send-email-jengelh@medozas.de>
References: <1288476600-29859-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49920 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab0J3WKL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:10:11 -0400
In-Reply-To: <1288476600-29859-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

PKG_CHECK_MODULES already produces its own (and more verbose) messsage
when a module cannot be found.

Mucking around with CFLAGS and LIBS is also not needed since pkgconfig
takes care of providing variables, so let's use them in Makefile.am.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac    |   10 +---------
 src/Makefile.am |    4 ++--
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/configure.ac b/configure.ac
index 7fa3566..4e1dd6b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -20,15 +20,7 @@ case "$host" in
 esac
 
 dnl Dependencies
-LIBNFNETLINK_REQUIRED=0.0.41
- 
-PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED,,
-	AC_MSG_ERROR(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED))
-
-CFLAGS="$CFLAGS $LIBNFNETLINK_CFLAGS"
-LIBNFLOG_LIBS="$LIBNFNETLINK_LIBS"
- 
-AC_SUBST(LIBNFLOG_LIBS)
+PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 0.0.41])
 
 dnl Output the makefile
 AC_OUTPUT(Makefile src/Makefile include/Makefile include/libnetfilter_log/Makefile utils/Makefile libnetfilter_log.pc doxygen.cfg)
diff --git a/src/Makefile.am b/src/Makefile.am
index 5668473..e78faa8 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -21,14 +21,14 @@
 LIBVERSION=2:0:1
 
 AM_CPPFLAGS = -I$(top_srcdir)/include
-AM_CFLAGS = -Wall
-LIBS = @LIBNFLOG_LIBS@
+AM_CFLAGS = -Wall ${LIBNFNETLINK_CFLAGS}
 
 lib_LTLIBRARIES = libnetfilter_log.la libnetfilter_log_libipulog.la
 
 libnetfilter_log_la_LDFLAGS = -Wc,-nostartfiles -lnfnetlink	\
 			      -version-info $(LIBVERSION)
 libnetfilter_log_la_SOURCES = libnetfilter_log.c 
+libnetfilter_log_la_LIBADD  = ${LIBNFNETLINK_LIBS}
 
 libnetfilter_log_libipulog_la_LDFLAGS = -Wc,-nostartfiles	\
 					-version-info 1:0:0
-- 
1.7.1

