From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] Eliminate forgotten traces of libnftables exporting
Date: Tue, 16 Jan 2018 17:19:57 +0100
Message-ID: <20180116161957.10634-1-phil@nwl.cc>
References: <20180116161857.GA25722@orbyte.nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:47222 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750941AbeAPQUI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 11:20:08 -0500
In-Reply-To: <20180116161857.GA25722@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This removes libnftables pkg-config file along with the few lines of
code to adjust and install it.

Fixes: d572d59788143 ("Make libnftables a local static library")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 Makefile.am       |  3 ---
 configure.ac      |  1 -
 libnftables.pc.in | 15 ---------------
 3 files changed, 19 deletions(-)
 delete mode 100644 libnftables.pc.in

diff --git a/Makefile.am b/Makefile.am
index 9af25ded836b8..10aa40f14127f 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -6,6 +6,3 @@ SUBDIRS = 	src	\
 		files
 
 EXTRA_DIST =	tests
-
-pkgconfigdir = $(libdir)/pkgconfig
-pkgconfig_DATA = libnftables.pc
diff --git a/configure.ac b/configure.ac
index 6ed3edca1fe5c..60c8c08bff2a1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -141,7 +141,6 @@ AC_CHECK_FUNCS([memmove memset strchr strdup strerror strtoull])
 
 AC_CONFIG_FILES([					\
 		Makefile				\
-		libnftables.pc				\
 		src/Makefile				\
 		include/Makefile			\
 		include/nftables/Makefile		\
diff --git a/libnftables.pc.in b/libnftables.pc.in
deleted file mode 100644
index 6431d48cf6f2c..0000000000000
--- a/libnftables.pc.in
+++ /dev/null
@@ -1,15 +0,0 @@
-# libnftables pkg-config file
-
-prefix=@prefix@
-exec_prefix=@exec_prefix@
-libdir=@libdir@
-includedir=@includedir@
-
-Name: libnftables
-Description: Netfilter nf_tables user library
-URL: http://netfilter.org/projects/nftables/
-Version: @VERSION@
-Requires:
-Conflicts:
-Libs: -L${libdir} -lnftables
-Cflags: -I${includedir}
-- 
2.15.1

