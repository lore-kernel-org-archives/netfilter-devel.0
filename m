From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 14/24] configure: split --enable-libipq from --enable-devel
Date: Sun,  6 Apr 2008 17:27:11 +0200
Message-ID: <72b07adb3cb324eaa7bb6824095774867bcff211.1207495183.git.jengelh@computergmbh.de>
References: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56489 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbYDFP10 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Apr 2008 11:27:26 -0400
In-Reply-To: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <bd573e5e48763aa655cdb6e3f70a6f647c3868c7.1207495183.git.jengelh@computergmbh.de>
References: <bd573e5e48763aa655cdb6e3f70a6f647c3868c7.1207495183.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 Makefile.am  |    2 +-
 configure.ac |    6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 8babe96..8137c93 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -6,7 +6,7 @@ regular_CFLAGS  := @regular_CFLAGS@
 kinclude_CFLAGS := @kinclude_CFLAGS@
 AM_CFLAGS        = ${regular_CFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CFLAGS}
 SUBDIRS         := extensions
-if ENABLE_DEVEL
+if ENABLE_LIBIPQ
 SUBDIRS         += libipq
 endif
 
diff --git a/configure.ac b/configure.ac
index 4c18cb0..3a0bff3 100644
--- a/configure.ac
+++ b/configure.ac
@@ -27,12 +27,16 @@ AC_ARG_WITH([xtlibdir],
 	[xtlibdir="${libexecdir}/iptables"])
 AC_ARG_ENABLE([devel],
 	AS_HELP_STRING([--enable-devel],
-	[Build and install development files (libipq, libipq-devel, iptables-devel)]))
+	[Install Xtables development headers]),
+	[enable_devel="$enableval"], [enable_devel="yes"])
+AC_ARG_ENABLE([libipq],
+	AS_HELP_STRING([--enable-libipq], [Build and install libipq]))
 
 AC_CHECK_HEADER([netinet/ip6.h], [], [AC_MSG_ERROR(but we need that for IPv6)])
 AM_CONDITIONAL([ENABLE_STATIC], [test "$enable_static" == "yes"])
 AM_CONDITIONAL([ENABLE_SHARED], [test "$enable_shared" == "yes"])
 AM_CONDITIONAL([ENABLE_DEVEL], [test "$enable_devel" == "yes"])
+AM_CONDITIONAL([ENABLE_LIBIPQ], [test "$enable_libipq" == "yes"])
 
 regular_CFLAGS="-D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64 \
 	-D_REENTRANT -Wall -Waggregate-return -Wmissing-declarations \
-- 
1.5.5.rc3

