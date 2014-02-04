From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/4] configure: conditional dependencies for nftables-compat
Date: Tue,  4 Feb 2014 16:32:24 +0100
Message-ID: <1391527946-19077-3-git-send-email-pablo@netfilter.org>
References: <1391527946-19077-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38388 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502AbaBDPci (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:32:38 -0500
In-Reply-To: <1391527946-19077-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Depend on libmnl, libnftnl, flex and bison if only if the nftables
compatibility is enabled.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac |   73 +++++++++++++++++++++++++++++-----------------------------
 1 file changed, 37 insertions(+), 36 deletions(-)

diff --git a/configure.ac b/configure.ac
index 54f1fd5..2521ccc 100644
--- a/configure.ac
+++ b/configure.ac
@@ -119,44 +119,45 @@ PKG_CHECK_MODULES([libnfnetlink], [libnfnetlink >= 1.0],
 	[nfnetlink=1], [nfnetlink=0])
 AM_CONDITIONAL([HAVE_LIBNFNETLINK], [test "$nfnetlink" = 1])
 
-PKG_CHECK_MODULES([libmnl], [libmnl >= 1.0],
-	[mnl=1], [mnl=0])
-AM_CONDITIONAL([HAVE_LIBMNL], [test "$mnl" = 1])
-
-PKG_CHECK_MODULES([libnftnl], [libnftnl >= 1.0],
-	[nftables=1], [nftables=0])
-AM_CONDITIONAL([HAVE_LIBNFTNL], [test "$nftables" = 1])
-
-AM_PROG_LEX
-AC_PROG_YACC
-
-if test -z "$ac_cv_prog_YACC"
-then
-	echo "*** Error: No suitable bison/yacc found. ***"
-	echo "    Please install the 'bison' package."
-	exit 1
-fi
-if test -z "$ac_cv_prog_LEX"
-then
-        echo "*** Error: No suitable flex/lex found. ***"
-        echo "    Please install the 'flex' package."
-        exit 1
+if test "x$enable_nftables" = "xyes"; then
+	PKG_CHECK_MODULES([libmnl], [libmnl >= 1.0], [mnl=1], [mnl=0])
+
+	PKG_CHECK_MODULES([libnftnl], [libnftnl >= 1.0], [nftables=1], [nftables=0])
+
+	AM_PROG_LEX
+	AC_PROG_YACC
+
+	if test -z "$ac_cv_prog_YACC"
+	then
+		echo "*** Error: No suitable bison/yacc found. ***"
+		echo "    Please install the 'bison' package."
+		exit 1
+	fi
+	if test -z "$ac_cv_prog_LEX"
+	then
+	        echo "*** Error: No suitable flex/lex found. ***"
+	        echo "    Please install the 'flex' package."
+	        exit 1
+	fi
+
+	AC_MSG_CHECKING(flex version)
+	flex_version=`$ac_cv_prog_LEX --version | sed 's/version//g' | awk '/flex/ {print $2}'`
+	flex_major=`echo $flex_version| cut -d . -f 1`
+	flex_minor=`echo $flex_version| cut -d . -f 2`
+	flex_rev=`echo $flex_version| cut -d . -f 3`
+
+	if test "$flex_major" -eq "2" && test "$flex_minor" -eq "5" && test "$flex_rev" -ge "33"; then
+		AC_MSG_RESULT([$flex_version. OK])
+	else
+		AC_MSG_WARN([flex version $flex_version found.
+		Version 2.5.33 or greater is required. You may experience problems
+		while compilating the nftables compatibility layer for iptables.
+		Please, consider to upgrade flex.])
+	fi
 fi
 
-AC_MSG_CHECKING(flex version)
-flex_version=`$ac_cv_prog_LEX --version | sed 's/version//g' | awk '/flex/ {print $2}'`
-flex_major=`echo $flex_version| cut -d . -f 1`
-flex_minor=`echo $flex_version| cut -d . -f 2`
-flex_rev=`echo $flex_version| cut -d . -f 3`
-
-if test "$flex_major" -eq "2" && test "$flex_minor" -eq "5" && test "$flex_rev" -ge "33"; then
-	AC_MSG_RESULT([$flex_version. OK])
-else
-	AC_MSG_WARN([flex version $flex_version found.
-	Version 2.5.33 or greater is required. You may experience problems
-	while compilating the nftables compatibility layer for iptables.
-	Please, consider to upgrade flex.])
-fi
+AM_CONDITIONAL([HAVE_LIBMNL], [test "$mnl" = 1])
+AM_CONDITIONAL([HAVE_LIBNFTNL], [test "$nftables" = 1])
 
 regular_CFLAGS="-Wall -Waggregate-return -Wmissing-declarations \
 	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes \
-- 
1.7.10.4

