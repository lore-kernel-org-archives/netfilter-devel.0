From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 02/10] build: do not abuse AM_INIT_AUTOMAKE for autoconf options
Date: Tue, 19 Oct 2010 12:47:33 +0200
Message-ID: <1287485262-6562-3-git-send-email-jengelh@medozas.de>
References: <1287485262-6562-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44392 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758241Ab0JSKrq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:47:46 -0400
In-Reply-To: <1287485262-6562-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Also rename the file to its standard designated name.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |   18 ++++++++++++++++++
 configure.in |   18 ------------------
 2 files changed, 18 insertions(+), 18 deletions(-)
 create mode 100644 configure.ac
 delete mode 100644 configure.in

diff --git a/configure.ac b/configure.ac
new file mode 100644
index 0000000..5cbbdfd
--- /dev/null
+++ b/configure.ac
@@ -0,0 +1,18 @@
+dnl Process this file with autoconf to create configure.
+
+AC_INIT([libmnl], [1.0.0-beta0])
+AC_CANONICAL_SYSTEM
+AC_CONFIG_MACRO_DIR([m4])
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
+AC_OUTPUT(Makefile src/Makefile include/Makefile include/libmnl/Makefile examples/Makefile examples/genl/Makefile examples/netfilter/Makefile examples/rtnl/Makefile libmnl.pc doxygen.cfg)
diff --git a/configure.in b/configure.in
deleted file mode 100644
index 8f2287e..0000000
--- a/configure.in
+++ /dev/null
@@ -1,18 +0,0 @@
-dnl Process this file with autoconf to create configure.
-
-AC_INIT
-AC_CANONICAL_SYSTEM
-AC_CONFIG_MACRO_DIR([m4])
-AM_INIT_AUTOMAKE(libmnl, 1.0.0-beta0)
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
-AC_OUTPUT(Makefile src/Makefile include/Makefile include/libmnl/Makefile examples/Makefile examples/genl/Makefile examples/netfilter/Makefile examples/rtnl/Makefile libmnl.pc doxygen.cfg)
-- 
1.7.1

