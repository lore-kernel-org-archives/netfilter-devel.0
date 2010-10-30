From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 01/11] build: use autoconf-suggested naming of files
Date: Sun, 31 Oct 2010 00:09:49 +0200
Message-ID: <1288476600-29859-2-git-send-email-jengelh@medozas.de>
References: <1288476600-29859-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49897 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787Ab0J3WKD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:10:03 -0400
In-Reply-To: <1288476600-29859-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |   35 +++++++++++++++++++++++++++++++++++
 configure.in |   35 -----------------------------------
 2 files changed, 35 insertions(+), 35 deletions(-)
 create mode 100644 configure.ac
 delete mode 100644 configure.in

diff --git a/configure.ac b/configure.ac
new file mode 100644
index 0000000..e0e1a41
--- /dev/null
+++ b/configure.ac
@@ -0,0 +1,35 @@
+dnl Process this file with autoconf to create configure.
+
+AC_INIT
+
+AC_CANONICAL_SYSTEM
+AC_CONFIG_MACRO_DIR([m4])
+
+AM_INIT_AUTOMAKE(libnetfilter_log, 1.0.0)
+
+AC_PROG_CC
+AM_PROG_LIBTOOL
+AC_PROG_INSTALL
+AC_PROG_LN_S
+
+AC_SUBST(LIBTOOL_DEPS)
+
+case $target in 
+*-*-linux*) ;;
+*) AC_MSG_ERROR([Linux only, dude!]);;
+esac
+
+dnl Dependencies
+LIBNFNETLINK_REQUIRED=0.0.41
+ 
+PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED,,
+	AC_MSG_ERROR(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED))
+
+CFLAGS="$CFLAGS $LIBNFNETLINK_CFLAGS"
+LIBNFLOG_LIBS="$LIBNFNETLINK_LIBS"
+ 
+AC_SUBST(LIBNFLOG_LIBS)
+
+dnl Output the makefile
+AC_OUTPUT(Makefile src/Makefile include/Makefile include/libnetfilter_log/Makefile utils/Makefile libnetfilter_log.pc doxygen.cfg)
+
diff --git a/configure.in b/configure.in
deleted file mode 100644
index e0e1a41..0000000
--- a/configure.in
+++ /dev/null
@@ -1,35 +0,0 @@
-dnl Process this file with autoconf to create configure.
-
-AC_INIT
-
-AC_CANONICAL_SYSTEM
-AC_CONFIG_MACRO_DIR([m4])
-
-AM_INIT_AUTOMAKE(libnetfilter_log, 1.0.0)
-
-AC_PROG_CC
-AM_PROG_LIBTOOL
-AC_PROG_INSTALL
-AC_PROG_LN_S
-
-AC_SUBST(LIBTOOL_DEPS)
-
-case $target in 
-*-*-linux*) ;;
-*) AC_MSG_ERROR([Linux only, dude!]);;
-esac
-
-dnl Dependencies
-LIBNFNETLINK_REQUIRED=0.0.41
- 
-PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED,,
-	AC_MSG_ERROR(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED))
-
-CFLAGS="$CFLAGS $LIBNFNETLINK_CFLAGS"
-LIBNFLOG_LIBS="$LIBNFNETLINK_LIBS"
- 
-AC_SUBST(LIBNFLOG_LIBS)
-
-dnl Output the makefile
-AC_OUTPUT(Makefile src/Makefile include/Makefile include/libnetfilter_log/Makefile utils/Makefile libnetfilter_log.pc doxygen.cfg)
-
-- 
1.7.1

