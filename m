From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 13/13] configure: split --enable-libipq from --enable-devel
Date: Thu, 10 Apr 2008 09:38:18 +0200
Message-ID: <f8ec9281798789546f0171bc3521c4426442b56d.1207813085.git.jengelh@computergmbh.de>
References: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50191 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbYDJHiW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Apr 2008 03:38:22 -0400
In-Reply-To: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
In-Reply-To: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
References: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
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
index 3081cc0..10d4380 100644
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

