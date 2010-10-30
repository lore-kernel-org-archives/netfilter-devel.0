From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/9] build: use autoconf-suggested naming of files
Date: Sun, 31 Oct 2010 00:07:25 +0200
Message-ID: <1288476454-18451-2-git-send-email-jengelh@medozas.de>
References: <1288476454-18451-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46284 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab0J3WHi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:07:38 -0400
In-Reply-To: <1288476454-18451-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |   25 +++++++++++++++++++++++++
 configure.in |   25 -------------------------
 2 files changed, 25 insertions(+), 25 deletions(-)
 create mode 100644 configure.ac
 delete mode 100644 configure.in

diff --git a/configure.ac b/configure.ac
new file mode 100644
index 0000000..47f3551
--- /dev/null
+++ b/configure.ac
@@ -0,0 +1,25 @@
+dnl Process this file with autoconf to create configure.
+
+AC_INIT(libnfnetlink, 1.0.0)
+
+AC_CANONICAL_SYSTEM
+
+AM_INIT_AUTOMAKE
+
+AC_PROG_CC
+AC_EXEEXT
+AM_PROG_LIBTOOL
+AC_SUBST(LIBTOOL_DEPS)
+
+case $target in 
+*-*-linux*) ;;
+*) AC_MSG_ERROR([Linux only, dude!]);;
+esac
+
+
+dnl--------------------------------
+dnl--------------------------------
+
+
+dnl Output the makefile
+AC_OUTPUT(Makefile src/Makefile include/Makefile include/libnfnetlink/Makefile utils/Makefile libnfnetlink.pc)
diff --git a/configure.in b/configure.in
deleted file mode 100644
index 47f3551..0000000
--- a/configure.in
+++ /dev/null
@@ -1,25 +0,0 @@
-dnl Process this file with autoconf to create configure.
-
-AC_INIT(libnfnetlink, 1.0.0)
-
-AC_CANONICAL_SYSTEM
-
-AM_INIT_AUTOMAKE
-
-AC_PROG_CC
-AC_EXEEXT
-AM_PROG_LIBTOOL
-AC_SUBST(LIBTOOL_DEPS)
-
-case $target in 
-*-*-linux*) ;;
-*) AC_MSG_ERROR([Linux only, dude!]);;
-esac
-
-
-dnl--------------------------------
-dnl--------------------------------
-
-
-dnl Output the makefile
-AC_OUTPUT(Makefile src/Makefile include/Makefile include/libnfnetlink/Makefile utils/Makefile libnfnetlink.pc)
-- 
1.7.1

