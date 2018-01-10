From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] src/Makefile: Restore per object CFLAGS
Date: Wed, 10 Jan 2018 13:43:21 +0100
Message-ID: <20180110124321.19312-1-phil@nwl.cc>
References: <20180109132632.xfkio5fsama4so5j@salvia>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:58636 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933593AbeAJMnd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Jan 2018 07:43:33 -0500
In-Reply-To: <20180109132632.xfkio5fsama4so5j@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As per the automake manual, create internal libraries for parser and
mini-gmp sources so per-object flags can be set.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/Makefile.am | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 7581ec2090092..7fa72a8ea5bc2 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -22,9 +22,6 @@ AM_CFLAGS = -Wall								\
 
 AM_YFLAGS = -d
 
-# yacc and lex generate dirty code
-parser_bison.o scanner.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-declarations -Wno-implicit-function-declaration -Wno-nested-externs -Wno-undef -Wno-redundant-decls
-
 BUILT_SOURCES = parser_bison.h
 
 noinst_LTLIBRARIES = libnftables.la
@@ -56,19 +53,29 @@ libnftables_la_SOURCES =			\
 		iface.c				\
 		services.c			\
 		mergesort.c			\
-		scanner.l			\
 		tcpopt.c			\
-		parser_bison.y			\
 		libnftables.c
 
-if BUILD_MINIGMP
-mini-gmp.o: AM_CFLAGS += -Wno-sign-compare
+# yacc and lex generate dirty code
+noinst_LTLIBRARIES += libparser.la
+libparser_la_SOURCES = parser_bison.y scanner.l
+libparser_la_CFLAGS = ${AM_CFLAGS} \
+		      -Wno-missing-prototypes \
+		      -Wno-missing-declarations \
+		      -Wno-implicit-function-declaration \
+		      -Wno-nested-externs \
+		      -Wno-undef \
+		      -Wno-redundant-decls
+
+libnftables_la_LIBADD = ${LIBMNL_LIBS} ${LIBNFTNL_LIBS} libparser.la
 
-libnftables_la_SOURCES += mini-gmp.c
+if BUILD_MINIGMP
+noinst_LTLIBRARIES += libminigmp.la
+libminigmp_la_SOURCES = mini-gmp.c
+libminigmp_la_CFLAGS = ${AM_CFLAGS} -Wno-sign-compare
+libnftables_la_LIBADD += libminigmp.la
 endif
 
-libnftables_la_LIBADD = ${LIBMNL_LIBS} ${LIBNFTNL_LIBS}
-
 if BUILD_XTABLES
 libnftables_la_SOURCES += xt.c
 libnftables_la_LIBADD += ${XTABLES_LIBS}
-- 
2.13.1

