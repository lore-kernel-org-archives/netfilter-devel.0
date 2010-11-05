From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/5] build: remove redundant bison/lex tests
Date: Fri,  5 Nov 2010 18:56:53 +0100
Message-ID: <1288979814-18512-6-git-send-email-jengelh@medozas.de>
References: <1288979814-18512-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55387 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab0KER5J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:57:09 -0400
In-Reply-To: <1288979814-18512-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

AC_PROG_{LEX,YACC} already searches for the programs, so no need to do
it again with AC_CHECK_PROGS.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/configure.ac b/configure.ac
index 7f9110a..47a3660 100644
--- a/configure.ac
+++ b/configure.ac
@@ -19,18 +19,13 @@ case "$host" in
 esac
 
 dnl Dependencies
-PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 1.0.0])
-PKG_CHECK_MODULES([LIBNETFILTER_CONNTRACK], [libnetfilter_conntrack >= 0.0.102])
-
-AC_CHECK_PROGS(XYACC,$YACC bison yacc,none)
-if test "$XYACC" = "none"
+if test -z "$ac_cv_prog_YACC"
 then
 	echo "*** Error: No suitable bison/yacc found. ***"
 	echo "    Please install the 'bison' package."
 	exit 1
 fi
-AC_CHECK_PROGS(XLEX,$LEX flex lex,none)
-if test "$XLEX" = "none"
+if test -z "$ac_cv_prog_LEX"
 then
 	echo "*** Error: No suitable flex/lex found. ***"
 	echo "    Please install the 'flex' package."
@@ -38,7 +33,7 @@ then
 fi
 
 AC_MSG_CHECKING(flex version)
-flex_version=`$LEX --version | sed 's/version//g' | awk '/flex/ {print $2}'`
+flex_version=`$ac_cv_prog_LEX --version | sed 's/version//g' | awk '/flex/ {print $2}'`
 flex_major=`echo $flex_version| cut -d . -f 1`
 flex_minor=`echo $flex_version| cut -d . -f 2`
 flex_rev=`echo $flex_version| cut -d . -f 3`
@@ -52,6 +47,9 @@ else
 	flex.])
 fi
 
+PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 1.0.0])
+PKG_CHECK_MODULES([LIBNETFILTER_CONNTRACK], [libnetfilter_conntrack >= 0.0.102])
+
 AC_CHECK_HEADERS([linux/capability.h],, [AC_MSG_ERROR([Cannot find linux/capabibility.h])])
 
 # Checks for libraries.
-- 
1.7.1

