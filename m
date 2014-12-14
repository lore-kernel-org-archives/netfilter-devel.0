From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] build: restore --disable-debug
Date: Sun, 14 Dec 2014 21:04:49 +0100
Message-ID: <1418587490-10633-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, cyrus@openwrt.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60189 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbaLNUCg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:02:36 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix fallout from the automake conversion. Display after configuration
if it is enabled or not.

Reported-by: Steven Barth <cyrus@openwrt.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac    |   10 ++++++----
 src/Makefile.am |    5 ++++-
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/configure.ac b/configure.ac
index 1525ac4..b55b2b1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -24,9 +24,10 @@ AC_DEFINE([_STDC_FORMAT_MACROS], [], [printf-style format macros])
 
 AC_ARG_ENABLE([debug],
 	      AS_HELP_STRING([--enable-debug], [Enable debugging]),
-	      [CONFIG_DEBUG="$(echo $enableval | cut -b1)"],
-	      [CONFIG_DEBUG="y"])
-AC_SUBST([CONFIG_DEBUG])
+	      [with_debug=no],
+	      [with_debug=yes])
+AC_SUBST(with_debug)
+AM_CONDITIONAL([BUILD_DEBUG], [test "x$with_debug" != xno])
 
 # Checks for programs.
 AC_PROG_CC
@@ -128,4 +129,5 @@ AC_OUTPUT
 
 echo "
 nft configuration:
-  cli support:			${with_cli}"
+  cli support:			${with_cli}
+  enable debugging:		${with_debug}"
diff --git a/src/Makefile.am b/src/Makefile.am
index d53c347..378424d 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -3,8 +3,11 @@ sbin_PROGRAMS = nft
 CLEANFILES = scanner.c parser_bison.c
 
 AM_CPPFLAGS = -I$(top_srcdir)/include
-AM_CPPFLAGS += -DDEFAULT_INCLUDE_PATH="\"${sysconfdir}\"" -DDEBUG \
+AM_CPPFLAGS += -DDEFAULT_INCLUDE_PATH="\"${sysconfdir}\"" \
 		${LIBMNL_CFLAGS} ${LIBNFTNL_CFLAGS}
+if BUILD_DEBUG
+AM_CPPFLAGS += -g -DDEBUG
+endif
 
 AM_CFLAGS = -Wall								\
 	    -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations	\
-- 
1.7.10.4

