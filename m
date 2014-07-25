From: Giorgio Dal Molin <giorgio.nicole@arcor.de>
Subject: [PATCH 7/8] autotools conversion: commit the rest of the configure.ac changes.
Date: Fri, 25 Jul 2014 23:52:58 +0159
Message-ID: <1406325204-23648-8-git-send-email-giorgio.nicole@arcor.de>
References: <20140725171646.GA5718@salvia>
 <1406325204-23648-1-git-send-email-giorgio.nicole@arcor.de>
Cc: Giorgio Dal Molin <giorgio.nicole@arcor.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:47684 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933208AbaGYVzD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jul 2014 17:55:03 -0400
Received: from mail-in-15-z2.arcor-online.net (mail-in-15-z2.arcor-online.net [151.189.8.32])
	by mx.arcor.de (Postfix) with ESMTP id CD4592D6E07
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Jul 2014 23:55:01 +0200 (CEST)
In-Reply-To: <1406325204-23648-1-git-send-email-giorgio.nicole@arcor.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Mainly the handling of the option '--enable-debug' and the definition of
the cpp variable DEFAULT_INCLUDE_PATH; the definition is written to
the generated header 'config.h', included by all the 'src/*.c'.

Also updated the script 'autogen.sh' to support calling it from a
build directory different from the package root.
---
 autogen.sh      | 10 ++++++++--
 configure.ac    | 32 ++++++++++++++++++++++++++------
 src/Makefile.am |  4 ++--
 3 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/autogen.sh b/autogen.sh
index a62e737..ce6243c 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -1,4 +1,10 @@
-#!/bin/bash
+#! /bin/sh
 
-autoreconf -fi;
+srcdir=`dirname $0`
+test -z "$srcdir" && srcdir=.
+
+ORIGDIR=`pwd`
+cd $srcdir
+
+autoreconf -fvi || exit 1
 rm -Rf autom4te*.cache config.h.in~
diff --git a/configure.ac b/configure.ac
index 18ca0a2..f4a6051 100644
--- a/configure.ac
+++ b/configure.ac
@@ -5,7 +5,13 @@ AC_PREREQ(2.61)
 
 AC_COPYRIGHT([Copyright (c) 2008 Patrick McHardy <kaber@trash.net>])
 AC_INIT([nftables], [0.3], [netfilter-devel@vger.kernel.org])
+AM_INIT_AUTOMAKE([dist-bzip2 dist-xz])
+AM_MAINTAINER_MODE([disable])
+AM_SILENT_RULES([yes])
+AC_CONFIG_MACRO_DIR([m4])
+
 AC_DEFINE([RELEASE_NAME], ["Support Edward Snowden"], [Release name])
+AC_DEFINE_UNQUOTED([DEFAULT_INCLUDE_PATH],["$confdir"],[define DEFAULT_INCLUDE_PATH])
 
 AC_CONFIG_SRCDIR([src/rule.c])
 AC_CONFIG_HEADER([config.h])
@@ -14,10 +20,17 @@ AC_DEFINE([_GNU_SOURCE], [], [Enable various GNU extensions])
 AC_DEFINE([_STDC_FORMAT_MACROS], [], [printf-style format macros])
 
 AC_ARG_ENABLE([debug],
-	      AS_HELP_STRING([--enable-debug], [Enable debugging]),
-	      [CONFIG_DEBUG="$(echo $enableval | cut -b1)"],
-	      [CONFIG_DEBUG="y"])
-AC_SUBST([CONFIG_DEBUG])
+	      AS_HELP_STRING([--enable-debug], [Enable debugging]))
+
+AS_CASE([$enable_debug],
+	[yes],[
+	AC_DEFINE([DEBUG],1,[Debug enabled])
+	DEBUG_CPPFLAGS="-DDEBUG"
+	DEBUG_CFLAGS="-g"
+	])
+
+AC_SUBST(DEBUG_CPPFLAGS)
+AC_SUBST(DEBUG_CFLAGS)
 
 # Checks for programs.
 AC_PROG_CC
@@ -119,6 +132,13 @@ AC_TYPE_UINT64_T
 # Checks for library functions.
 AC_CHECK_FUNCS([memmove memset strchr strdup strerror strtoull])
 
-AC_CONFIG_FILES([Makefile Makefile.defs Makefile.rules])
-AC_CONFIG_FILES([src/Makefile doc/Makefile files/Makefile])
+AC_CONFIG_FILES([	Makefile				\
+			src/Makefile				\
+			doc/Makefile				\
+			files/Makefile				\
+			files/nftables/Makefile			\
+			include/Makefile			\
+			include/linux/Makefile			\
+			include/linux/netfilter/Makefile	\
+		])
 AC_OUTPUT
diff --git a/src/Makefile.am b/src/Makefile.am
index 5f19732..2b2c535 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -6,9 +6,9 @@ nft_CFLAGS =	-fno-strict-aliasing							\
 		-Wdeclaration-after-statement -Wsign-compare -Winit-self		\
 		-Wformat-nonliteral -Wformat-security -Wmissing-format-attribute	\
 		-Wcast-align -Wundef -Wbad-function-cast				\
-		-Waggregate-return -Wunused -Wwrite-strings
+		-Waggregate-return -Wunused -Wwrite-strings ${DEBUG_CFLAGS}
 
-nft_CPPFLAGS = -I${srcdir}/../include ${LIBMNL_CFLAGS} ${LIBNFTNL_CFLAGS}
+nft_CPPFLAGS = -I${srcdir}/../include ${LIBMNL_CFLAGS} ${LIBNFTNL_CFLAGS} ${DEBUG_CPPFLAGS}
 
 nft_LDADD = ${LIBMNL_LIBS} ${LIBNFTNL_LIBS}
 
-- 
2.0.3

