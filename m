From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/5] build: use AC_PROG_YACC and AM_PROG_LEX
Date: Thu,  6 Nov 2014 19:25:46 +0100
Message-ID: <1415298349-985-3-git-send-email-pablo@netfilter.org>
References: <1415298349-985-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38976 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbaKFSYJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:24:09 -0500
In-Reply-To: <1415298349-985-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

To check for bison and flex installed on the system.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/configure.ac b/configure.ac
index e68d59f..ee9cf6c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -24,6 +24,21 @@ AC_PROG_CC
 AC_PROG_MKDIR_P
 AC_PROG_INSTALL
 AC_PROG_SED
+AM_PROG_LEX
+AC_PROG_YACC
+
+if test -z "$ac_cv_prog_YACC"
+then
+        echo "*** Error: No suitable bison/yacc found. ***"
+        echo "    Please install the 'bison' package."
+        exit 1
+fi
+if test -z "$ac_cv_prog_LEX"
+then
+        echo "*** Error: No suitable flex/lex found. ***"
+        echo "    Please install the 'flex' package."
+        exit 1
+fi
 
 AC_CHECK_PROG(CONFIG_MAN1, [docbook2x-man], [y], [n])
 if test "$CONFIG_MAN1" == "y"
@@ -49,18 +64,6 @@ then
 	AC_MSG_WARN([dblatex not found, no PDF manpages will be built])
 fi
 
-AC_PATH_PROG(LEX, [flex])
-if test -z "$LEX"
-then
-	AC_MSG_ERROR([No suitable version of flex found])
-fi
-
-AC_PATH_PROG(YACC, [bison])
-if test -z "$YACC"
-then
-	AC_MSG_ERROR([No suitable version of bison found])
-fi
-
 # Checks for libraries.
 PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
 PKG_CHECK_MODULES([LIBNFTNL], [libnftnl >= 1.0.2])
-- 
1.7.10.4

