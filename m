From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH iptables-nftables] iptables: fix compil when lib[mnl|nftables] are not in standard path
Date: Wed,  6 Mar 2013 16:00:31 +0100
Message-ID: <1362582031-17576-1-git-send-email-nicolas.dichtel@6wind.com>
Cc: netfilter-devel@vger.kernel.org,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 33.106-14-84.ripe.coltfrance.com ([84.14.106.33]:52427 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757481Ab3CFPAk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Mar 2013 10:00:40 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There was several problems:
 a typo in the configure option
 a typo in CFLAGS addon for libmnl and libnftables
 paths to lib were missing on link

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 configure.ac         | 2 +-
 iptables/Makefile.am | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/configure.ac b/configure.ac
index cbd129c..48a0d54 100644
--- a/configure.ac
+++ b/configure.ac
@@ -100,7 +100,7 @@ PKG_CHECK_MODULES([libmnl], [libmnl >= 1.0],
 	[mnl=1], [mnl=0])
 AM_CONDITIONAL([HAVE_LIBMNL], [test "$mnl" = 1])
 
-PKG_CHECK_MODULES([libnfables], [libnftables >= 1.0],
+PKG_CHECK_MODULES([libnftables], [libnftables >= 1.0],
 	[nftables=1], [nftables=0])
 AM_CONDITIONAL([HAVE_LIBNFTABLES], [test "$nftables" = 1])
 
diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 6738cd0..3995dd4 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -1,7 +1,7 @@
 # -*- Makefile -*-
 
 AM_CFLAGS        = ${regular_CFLAGS}
-AM_CPPFLAGS      = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CPPFLAGS} ${libmnl_CPPFLAGS} ${libnftables_CPPFLAGS}
+AM_CPPFLAGS      = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CPPFLAGS} ${libmnl_CFLAGS} ${libnftables_CFLAGS}
 AM_YFLAGS = -d
 
 xtables_multi_SOURCES  = xtables-multi.c iptables-xml.c
@@ -32,7 +32,7 @@ xtables_multi_SOURCES += xtables-save.c xtables-restore.c \
 			 nft-shared.c nft-ipv4.c nft-ipv6.c \
 			 xtables-config-parser.y xtables-config-syntax.l \
 			 xtables-config.c xtables-events.c
-xtables_multi_LDADD   += -lmnl -lnftables
+xtables_multi_LDADD   += -lmnl -lnftables ${libmnl_LIBS} ${libnftables_LIBS}
 xtables_multi_CFLAGS  += -DENABLE_NFTABLES
 # yacc and lex generate dirty code
 xtables_multi-xtables-config-parser.o xtables_multi-xtables-config-syntax.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-declarations -Wno-implicit-function-declaration -Wno-nested-externs -Wno-undef -Wno-redundant-decls
-- 
1.8.0.1

