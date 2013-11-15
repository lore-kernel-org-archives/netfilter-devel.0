From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] build: fix make distcheck
Date: Fri, 15 Nov 2013 15:23:41 +0100
Message-ID: <1384525421-7063-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55012 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595Ab3KOOYH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Nov 2013 09:24:07 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix missing files that were not included in the tarball
that distcheck generates.

This also includes AC_EXEEXT, otherwise configure complains about
undefined CHECK_GCC_FVISIBILITY.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Makefile.am                         |    2 +-
 configure.ac                        |    1 +
 include/linux/netfilter/Makefile.am |    2 +-
 src/Makefile.am                     |    2 ++
 4 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index d5f6e40..83f176d 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -3,7 +3,7 @@ include $(top_srcdir)/Make_global.am
 ACLOCAL_AMFLAGS = -I m4
 
 SUBDIRS = src include examples tests
-DIST_SUBDIRS = src include examples
+DIST_SUBDIRS = src include examples tests
 
 pkgconfigdir = $(libdir)/pkgconfig
 pkgconfig_DATA = libnftables.pc
diff --git a/configure.ac b/configure.ac
index 4758a49..b023755 100644
--- a/configure.ac
+++ b/configure.ac
@@ -30,6 +30,7 @@ AS_IF([test "x$with_json_parsing" = "xyes"], [
 ])
 AC_PROG_CC
 AM_PROG_CC_C_O
+AC_EXEEXT
 AC_DISABLE_STATIC
 LT_INIT
 CHECK_GCC_FVISIBILITY
diff --git a/include/linux/netfilter/Makefile.am b/include/linux/netfilter/Makefile.am
index 51fb1ae..442463c 100644
--- a/include/linux/netfilter/Makefile.am
+++ b/include/linux/netfilter/Makefile.am
@@ -1 +1 @@
-noinst_HEADERS = nfnetlink.h nf_tables.h
+noinst_HEADERS = nfnetlink.h nf_tables.h nf_tables_compat.h
diff --git a/src/Makefile.am b/src/Makefile.am
index 5f64db2..48d5d2d 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -32,5 +32,7 @@ libnftables_la_SOURCES = utils.c		\
 			 expr/payload.c		\
 			 expr/reject.c		\
 			 expr/target.c		\
+			 expr/data_reg.h	\
 			 libnftables.map	\
+			 expr_ops.h		\
 			 internal.h
-- 
1.7.10.4

