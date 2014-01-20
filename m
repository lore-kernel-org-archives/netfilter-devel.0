From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables (nft branch) PATCH] nft: Use new libnftnl library name against former libnftables
Date: Mon, 20 Jan 2014 17:56:41 +0200
Message-ID: <1390233401-2409-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4393 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbaATP4r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jan 2014 10:56:47 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adapt the current code to use the new library name libnftnl.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 configure.ac                     | 4 ++--
 iptables/Makefile.am             | 6 +++---
 iptables/nft-shared.c            | 4 ++--
 iptables/nft-shared.h            | 4 ++--
 iptables/nft.c                   | 8 ++++----
 iptables/xtables-config-parser.y | 4 ++--
 iptables/xtables-events.c        | 6 +++---
 iptables/xtables-restore.c       | 2 +-
 iptables/xtables-save.c          | 2 +-
 9 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/configure.ac b/configure.ac
index cbbf66d..ac7c9c0 100644
--- a/configure.ac
+++ b/configure.ac
@@ -123,9 +123,9 @@ PKG_CHECK_MODULES([libmnl], [libmnl >= 1.0],
 	[mnl=1], [mnl=0])
 AM_CONDITIONAL([HAVE_LIBMNL], [test "$mnl" = 1])
 
-PKG_CHECK_MODULES([libnftables], [libnftables >= 1.0],
+PKG_CHECK_MODULES([libnftnl], [libnftnl >= 1.0],
 	[nftables=1], [nftables=0])
-AM_CONDITIONAL([HAVE_LIBNFTABLES], [test "$nftables" = 1])
+AM_CONDITIONAL([HAVE_LIBNFTNL], [test "$nftables" = 1])
 
 AM_PROG_LEX
 AC_PROG_YACC
diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index b9a9743..2c6a163 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -1,7 +1,7 @@
 # -*- Makefile -*-
 
 AM_CFLAGS        = ${regular_CFLAGS}
-AM_CPPFLAGS      = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CPPFLAGS} ${libmnl_CFLAGS} ${libnftables_CFLAGS}
+AM_CPPFLAGS      = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CPPFLAGS} ${libmnl_CFLAGS} ${libnftnl_CFLAGS}
 AM_YFLAGS = -d
 
 xtables_multi_SOURCES  = xtables-multi.c iptables-xml.c
@@ -27,14 +27,14 @@ xtables_multi_LDADD   += ../libxtables/libxtables.la -lm
 
 if ENABLE_NFTABLES
 if HAVE_LIBMNL
-if HAVE_LIBNFTABLES
+if HAVE_LIBNFTNL
 xtables_multi_SOURCES += xtables-config-parser.y xtables-config-syntax.l
 xtables_multi_SOURCES += xtables-save.c xtables-restore.c \
 			 xtables-standalone.c xtables.c nft.c \
 			 nft-shared.c nft-ipv4.c nft-ipv6.c nft-arp.c \
 			 xtables-config.c xtables-events.c \
 			 xtables-arp-standalone.c xtables-arp.c
-xtables_multi_LDADD   += -lmnl -lnftables ${libmnl_LIBS} ${libnftables_LIBS}
+xtables_multi_LDADD   += ${libmnl_LIBS} ${libnftnl_LIBS}
 xtables_multi_CFLAGS  += -DENABLE_NFTABLES
 # yacc and lex generate dirty code
 xtables_multi-xtables-config-parser.o xtables_multi-xtables-config-syntax.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-declarations -Wno-implicit-function-declaration -Wno-nested-externs -Wno-undef -Wno-redundant-decls
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 43f03b2..d0e28ba 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -22,8 +22,8 @@
 #include <linux/netfilter/nf_tables.h>
 
 #include <libmnl/libmnl.h>
-#include <libnftables/rule.h>
-#include <libnftables/expr.h>
+#include <libnftnl/rule.h>
+#include <libnftnl/expr.h>
 
 #include "nft-shared.h"
 #include "xshared.h"
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 9df17bc..1d01eba 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -3,8 +3,8 @@
 
 #include <stdbool.h>
 
-#include <libnftables/rule.h>
-#include <libnftables/expr.h>
+#include <libnftnl/rule.h>
+#include <libnftnl/expr.h>
 
 #include "xshared.h"
 
diff --git a/iptables/nft.c b/iptables/nft.c
index 6f3fdb0..fc9db99 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -38,10 +38,10 @@
 #include <linux/netfilter/nf_tables_compat.h>
 
 #include <libmnl/libmnl.h>
-#include <libnftables/table.h>
-#include <libnftables/chain.h>
-#include <libnftables/rule.h>
-#include <libnftables/expr.h>
+#include <libnftnl/table.h>
+#include <libnftnl/chain.h>
+#include <libnftnl/rule.h>
+#include <libnftnl/expr.h>
 
 #include <netinet/in.h>	/* inet_ntoa */
 #include <arpa/inet.h>
diff --git a/iptables/xtables-config-parser.y b/iptables/xtables-config-parser.y
index 36dae38..2770a1b 100644
--- a/iptables/xtables-config-parser.y
+++ b/iptables/xtables-config-parser.y
@@ -17,8 +17,8 @@
 #include <errno.h>
 #include <stdarg.h>
 #include <libiptc/linux_list.h>
-#include <libnftables/table.h>
-#include <libnftables/chain.h>
+#include <libnftnl/table.h>
+#include <libnftnl/chain.h>
 
 #include <netinet/in.h>
 #include <linux/netfilter.h>
diff --git a/iptables/xtables-events.c b/iptables/xtables-events.c
index 408e091..4be8ab8 100644
--- a/iptables/xtables-events.c
+++ b/iptables/xtables-events.c
@@ -19,9 +19,9 @@
 #include <linux/netfilter/nf_tables.h>
 
 #include <libmnl/libmnl.h>
-#include <libnftables/table.h>
-#include <libnftables/chain.h>
-#include <libnftables/rule.h>
+#include <libnftnl/table.h>
+#include <libnftnl/chain.h>
+#include <libnftnl/rule.h>
 
 #include <include/xtables.h>
 #include "iptables.h" /* for xtables_globals */
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 06053f6..9a80f1e 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -16,7 +16,7 @@
 #include "libiptc/libiptc.h"
 #include "xtables-multi.h"
 #include "nft.h"
-#include <libnftables/chain.h>
+#include <libnftnl/chain.h>
 
 #ifdef DEBUG
 #define DEBUGP(x, args...) fprintf(stderr, x, ## args)
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 990c0fe..77eab14 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -19,7 +19,7 @@
 #include "xtables-multi.h"
 #include "nft.h"
 
-#include <libnftables/chain.h>
+#include <libnftnl/chain.h>
 
 #ifndef NO_SHARED_LIBS
 #include <dlfcn.h>
-- 
1.8.3.2

