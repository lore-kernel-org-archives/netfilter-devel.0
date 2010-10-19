From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 05/10] build: run autoupdate
Date: Tue, 19 Oct 2010 12:47:36 +0200
Message-ID: <1287485262-6562-6-git-send-email-jengelh@medozas.de>
References: <1287485262-6562-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44404 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758255Ab0JSKrt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:47:49 -0400
In-Reply-To: <1287485262-6562-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Macro usage has changed over the last few years. Update it to the
current specification using autoupdate(1).

Manually update INCLUDES -> CPPFLAGS, because autoupdate did not
catch that.

Remove $(all_includes) and $(LIBS) because it is not used anywhere.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Make_global.am  |    2 +-
 configure.ac    |    7 ++++---
 src/Makefile.am |    2 --
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 4d56685..78a0e35 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -20,5 +20,5 @@
 #
 LIBVERSION=0:0:0
 
-INCLUDES=$(all_includes) -I$(top_srcdir)/include
+CPPFLAGS = -I$(top_srcdir)/include
 AM_CFLAGS=-fPIC -Wall -Wextra -Wno-unused-parameter
diff --git a/configure.ac b/configure.ac
index 6a199c4..d9567ea 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,14 +1,14 @@
 dnl Process this file with autoconf to create configure.
 
 AC_INIT([libmnl], [1.0.0-beta0])
-AC_CANONICAL_SYSTEM
+AC_CANONICAL_TARGET
 AC_CONFIG_MACRO_DIR([m4])
 AM_INIT_AUTOMAKE([foreign dist-bzip2 1.6 subdir-objects])
 
 AC_PROG_CC
 AM_PROG_CC_C_O
 AC_EXEEXT
-AM_PROG_LIBTOOL
+LT_INIT
 AC_SUBST(LIBTOOL_DEPS)
 
 case $target in 
@@ -16,4 +16,5 @@ case $target in
 *) AC_MSG_ERROR([Linux only, dude!]);;
 esac
 
-AC_OUTPUT(Makefile src/Makefile include/Makefile include/libmnl/Makefile examples/Makefile examples/genl/Makefile examples/netfilter/Makefile examples/rtnl/Makefile libmnl.pc doxygen.cfg)
+AC_CONFIG_FILES([Makefile src/Makefile include/Makefile include/libmnl/Makefile examples/Makefile examples/genl/Makefile examples/netfilter/Makefile examples/rtnl/Makefile libmnl.pc doxygen.cfg])
+AC_OUTPUT
diff --git a/src/Makefile.am b/src/Makefile.am
index 72ccb0c..1e34c0f 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -1,7 +1,5 @@
 include $(top_srcdir)/Make_global.am
 
-LIBS=
-
 lib_LTLIBRARIES = libmnl.la
 
 libmnl_la_LDFLAGS = -Wc,-nostartfiles -version-info $(LIBVERSION)
-- 
1.7.1

