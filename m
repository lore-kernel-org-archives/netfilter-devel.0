From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] Make libnftables a local static library
Date: Thu, 30 Nov 2017 18:11:24 +0100
Message-ID: <20171130171124.24408-1-phil@nwl.cc>
References: <20171124140246.GA6881@salvia>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:52128 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753586AbdK3RLg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Nov 2017 12:11:36 -0500
In-Reply-To: <20171124140246.GA6881@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This changes Makefiles so that libnftables is built into a static
library which is not installed. This allows for incompatible changes
while still providing a library to link to for testing purposes.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 Makefile.am     |  3 ---
 src/Makefile.am | 14 ++++++--------
 2 files changed, 6 insertions(+), 11 deletions(-)

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
diff --git a/src/Makefile.am b/src/Makefile.am
index 9f7a4bfbb90a4..07ddfd590dd8f 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -27,9 +27,9 @@ parser_bison.o scanner.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-decl
 
 BUILT_SOURCES = parser_bison.h
 
-lib_LTLIBRARIES = libnftables.la
+noinst_LIBRARIES = libnftables.a
 
-libnftables_la_SOURCES =			\
+libnftables_a_SOURCES =				\
 		rule.c				\
 		statement.c			\
 		datatype.c			\
@@ -64,14 +64,14 @@ libnftables_la_SOURCES =			\
 if BUILD_MINIGMP
 mini-gmp.o: AM_CFLAGS += -Wno-sign-compare
 
-libnftables_la_SOURCES += mini-gmp.c
+libnftables_a_SOURCES += mini-gmp.c
 endif
 
-libnftables_la_LIBADD = ${LIBMNL_LIBS} ${LIBNFTNL_LIBS}
+nft_LDADD = libnftables.a ${LIBMNL_LIBS} ${LIBNFTNL_LIBS}
 
 if BUILD_XTABLES
-libnftables_la_SOURCES += xt.c
-libnftables_la_LIBADD += ${XTABLES_LIBS}
+libnftables_a_SOURCES += xt.c
+nft_LDADD += ${XTABLES_LIBS}
 endif
 
 nft_SOURCES = main.c
@@ -79,5 +79,3 @@ nft_SOURCES = main.c
 if BUILD_CLI
 nft_SOURCES += cli.c
 endif
-
-nft_LDADD = libnftables.la
-- 
2.13.1

