From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 15/24] configure: split --enable-libipq from --enable-devel
Date: Tue, 4 Mar 2008 17:04:55 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041704330.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44005 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218AbYCDQE5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:04:57 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 5fbe0ae09d30f8e32f3631b8c615200bbec89174
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Mon Feb 11 15:01:03 2008 +0100

    configure: split --enable-libipq from --enable-devel
---
 Makefile.am  |    2 +-
 configure.ac |    7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 5240635..811eb62 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -6,7 +6,7 @@ regular_CFLAGS  := @regular_CFLAGS@
 kinclude_CFLAGS := @kinclude_CFLAGS@
 AM_CFLAGS        = ${regular_CFLAGS} -I${top_srcdir}/include ${kinclude_CFLAGS}
 SUBDIRS         := extensions
-if ENABLE_DEVEL
+if ENABLE_LIBIPQ
 SUBDIRS         += libipq
 endif
 
diff --git a/configure.ac b/configure.ac
index 261356f..4025e0e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -26,13 +26,16 @@ AC_ARG_WITH([xtlibdir],
 	[xtlibdir="$withval"],
 	[xtlibdir="${libexecdir}/xtables"])
 AC_ARG_ENABLE([devel],
-	AS_HELP_STRING([--enable-devel],
-	[Build and install development files (libipq, libipq-devel, xtables-devel)]))
+	AS_HELP_STRING([--enable-devel], [Install Xtables headers]),
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
