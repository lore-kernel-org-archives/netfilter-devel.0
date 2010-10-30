From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 06/10] build: no need for error message in PKG_CHECK_MODULES
Date: Sun, 31 Oct 2010 00:11:11 +0200
Message-ID: <1288476676-32749-7-git-send-email-jengelh@medozas.de>
References: <1288476676-32749-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49975 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab0J3WLZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:11:25 -0400
In-Reply-To: <1288476676-32749-1-git-send-email-jengelh@medozas.de>
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
index 7c3468b..c4cc36e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -19,15 +19,7 @@ case "$host" in
 esac
 
 dnl Dependencies
-LIBNFNETLINK_REQUIRED=0.0.41
- 
-PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED,,
-	AC_MSG_ERROR(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED))
- 
-CFLAGS="$CFLAGS $LIBNFNETLINK_CFLAGS"
-LIBNFQUEUE_LIBS="$LIBNFNETLINK_LIBS"
- 
-AC_SUBST(LIBNFQUEUE_LIBS)
+PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 0.0.41])
 
 dnl Output the makefiles
 AC_OUTPUT(Makefile include/Makefile include/libnetfilter_queue/Makefile src/Makefile utils/Makefile libnetfilter_queue.pc doxygen.cfg)
diff --git a/src/Makefile.am b/src/Makefile.am
index c408961..aa1f5ba 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -21,11 +21,11 @@
 LIBVERSION=2:0:1
 
 AM_CPPFLAGS = -I$(top_srcdir)/include -I${KERNELDIR}
-AM_CFLAGS = -fPIC -Wall
-LIBS = @LIBNFQUEUE_LIBS@
+AM_CFLAGS = -fPIC -Wall ${LIBNFNETLINK_CFLAGS}
 
 lib_LTLIBRARIES = libnetfilter_queue.la
 
 libnetfilter_queue_la_LDFLAGS = -Wc,-nostartfiles -lnfnetlink \
 				-version-info $(LIBVERSION)
 libnetfilter_queue_la_SOURCES = libnetfilter_queue.c 
+libnetfilter_queue_la_LIBADD  = ${LIBNFNETLINK_LIBS}
-- 
1.7.1

