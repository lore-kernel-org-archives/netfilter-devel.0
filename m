From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 01/10] build: build: use autoconf-suggested naming of files
Date: Sun, 31 Oct 2010 00:11:06 +0200
Message-ID: <1288476676-32749-2-git-send-email-jengelh@medozas.de>
References: <1288476676-32749-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49956 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904Ab0J3WLT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:11:19 -0400
In-Reply-To: <1288476676-32749-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |   33 +++++++++++++++++++++++++++++++++
 configure.in |   33 ---------------------------------
 2 files changed, 33 insertions(+), 33 deletions(-)
 create mode 100644 configure.ac
 delete mode 100644 configure.in

diff --git a/configure.ac b/configure.ac
new file mode 100644
index 0000000..a82c9f1
--- /dev/null
+++ b/configure.ac
@@ -0,0 +1,33 @@
+dnl Process this file with autoconf to create configure.
+
+AC_INIT
+AC_CANONICAL_SYSTEM
+AC_CONFIG_MACRO_DIR([m4])
+
+AM_INIT_AUTOMAKE(libnetfilter_queue, 1.0.0)
+
+AC_PROG_CC
+AC_EXEEXT
+AM_PROG_LIBTOOL
+AC_PROG_INSTALL
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
+LIBNFQUEUE_LIBS="$LIBNFNETLINK_LIBS"
+ 
+AC_SUBST(LIBNFQUEUE_LIBS)
+
+dnl Output the makefiles
+AC_OUTPUT(Makefile include/Makefile include/libnetfilter_queue/Makefile src/Makefile utils/Makefile libnetfilter_queue.pc doxygen.cfg)
diff --git a/configure.in b/configure.in
deleted file mode 100644
index a82c9f1..0000000
--- a/configure.in
+++ /dev/null
@@ -1,33 +0,0 @@
-dnl Process this file with autoconf to create configure.
-
-AC_INIT
-AC_CANONICAL_SYSTEM
-AC_CONFIG_MACRO_DIR([m4])
-
-AM_INIT_AUTOMAKE(libnetfilter_queue, 1.0.0)
-
-AC_PROG_CC
-AC_EXEEXT
-AM_PROG_LIBTOOL
-AC_PROG_INSTALL
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
-LIBNFQUEUE_LIBS="$LIBNFNETLINK_LIBS"
- 
-AC_SUBST(LIBNFQUEUE_LIBS)
-
-dnl Output the makefiles
-AC_OUTPUT(Makefile include/Makefile include/libnetfilter_queue/Makefile src/Makefile utils/Makefile libnetfilter_queue.pc doxygen.cfg)
-- 
1.7.1

