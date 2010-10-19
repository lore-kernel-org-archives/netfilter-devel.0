From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/8] build: add separate option for kernel source directory
Date: Tue, 19 Oct 2010 18:12:16 +0200
Message-ID: <1287504742-12922-4-git-send-email-jengelh@medozas.de>
References: <1287504742-12922-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53569 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293Ab0JSQMa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:12:30 -0400
In-Reply-To: <1287504742-12922-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The build directory is not necessarily the same as the source directory.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/configure.ac b/configure.ac
index 34f0889..906ef84 100644
--- a/configure.ac
+++ b/configure.ac
@@ -13,10 +13,14 @@ esac
 
 dnl Additional arguments
 dnl Kernel build directory or source tree
-AC_ARG_WITH([kernel],
-	    AS_HELP_STRING([--with-kernel=PATH],
-	    		   [Path to kernel source/build directory]),
-	    [KBUILDDIR="$withval";])
+AC_ARG_WITH([kbuild],
+            AS_HELP_STRING([--with-kbuild=PATH],
+                           [Path to kernel build directory]),
+            [KBUILDDIR="$withval";])
+AC_ARG_WITH([ksource],
+            AS_HELP_STRING([--with-ksource=PATH],
+                           [Path to kernel source directory]),
+            [KSOURCEDIR="$withval";])
 AM_CONDITIONAL(WITH_KBUILDDIR, test "$KBUILDDIR" != "")
 AC_SUBST(KBUILDDIR)
 
@@ -28,9 +32,10 @@ else
 	kbuilddir="/lib/modules/`uname -r`/build"
 fi
 
-if test ! -e "$kbuilddir/include/linux/netfilter/nfnetlink.h"
-then
-	AC_MSG_ERROR([Invalid kernel build directory $kbuilddir])
+if test -n "$KSOURCEDIR"; then
+	ksourcedir="$KSOURCEDIR"
+else
+	ksourcedir="/lib/modules/$(uname -r)/source"
 fi
 
 if test ! -e "$kbuilddir/.config"
@@ -46,11 +51,11 @@ then
 fi
 
 dnl Check kernel dependencies: nfnetlink.h
-NFNL_CB_CONST="`./check_const $kbuilddir/include/linux/netfilter/nfnetlink.h`"
+NFNL_CB_CONST="`./check_const $ksourcedir/include/linux/netfilter/nfnetlink.h`"
 AC_SUBST(NFNL_CB_CONST)
 
 dnl Check kernel dependencies: netlink.h
-NETLINK_DUMP_CONST="`./check_const $kbuilddir/include/linux/netlink.h`"
+NETLINK_DUMP_CONST="`./check_const $ksourcedir/include/linux/netlink.h`"
 AC_SUBST(NETLINK_DUMP_CONST)
 
 dnl Maximal number of sets supported by the kernel, default 256
-- 
1.7.1

