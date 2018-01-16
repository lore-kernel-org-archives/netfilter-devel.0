From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 2/2] configure: Allow to disable man page building
Date: Tue, 16 Jan 2018 17:38:07 +0100
Message-ID: <20180116163807.13276-3-phil@nwl.cc>
References: <20180116163807.13276-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:47268 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751118AbeAPQiX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 11:38:23 -0500
In-Reply-To: <20180116163807.13276-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Aparently there are distributions which come with incompatible docbook
implementations. On those, forced man page creating if required binaries
are found leads to build failure.

Allow them to conveniently disable man page output instead of having to
pass undocumented variables to configure.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 configure.ac | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/configure.ac b/configure.ac
index 22fb293c47035..1d588d5d37773 100644
--- a/configure.ac
+++ b/configure.ac
@@ -29,6 +29,12 @@ AC_ARG_ENABLE([debug],
 AC_SUBST(with_debug)
 AM_CONDITIONAL([BUILD_DEBUG], [test "x$with_debug" != xno])
 
+AC_ARG_ENABLE([man-doc],
+	      AS_HELP_STRING([--disable-man-doc], [Disable man page documentation]),
+	      AS_IF([test "x$enable_man_doc" = "xno"], [enable_man_doc=no],
+	      [enable_man_doc=yes]), [enable_man_doc=yes])
+AM_CONDITIONAL([BUILD_MAN], [test "x$enable_man_doc" == "xyes" ])
+
 AC_ARG_ENABLE([pdf-doc],
 	      AS_HELP_STRING([--enable-pdf-doc], [Enable PDF documentation]),
 	      AS_IF([test "x$enable_pdf_doc" = "xno"], [enable_pdf_doc=no],
@@ -59,18 +65,20 @@ fi
 AM_PROG_AR
 AM_PROG_LIBTOOL
 
-AC_CHECK_PROG(DOCBOOK2X_MAN, [docbook2x-man], [docbook2x-man], [no])
-AC_CHECK_PROG(DOCBOOK2MAN, [docbook2man], [docbook2man], [no])
-AC_CHECK_PROG(DB2X_DOCBOOK2MAN, [db2x_docbook2man], [db2x_docbook2man], [no])
-AS_IF([test "$DOCBOOK2X_MAN" != "no"], [DB2MAN="$DOCBOOK2X_MAN"],
-	[AS_IF([test "$DOCBOOK2MAN" != "no"], [DB2MAN="$DOCBOOK2MAN"],
-		[AS_IF([test "$DB2X_DOCBOOK2MAN" != "no"], [DB2MAN="$DB2X_DOCBOOK2MAN"],
-			[AC_MSG_WARN([docbookx2-man/db2x_docbook2man not found, no manpages will be built])]
-		)]
-	)]
-)
-AC_SUBST(DB2MAN)
-AM_CONDITIONAL([BUILD_MAN], [test -n "$DB2MAN"])
+AM_COND_IF([BUILD_MAN], [
+	AC_CHECK_PROG(DOCBOOK2X_MAN, [docbook2x-man], [docbook2x-man], [no])
+	AC_CHECK_PROG(DOCBOOK2MAN, [docbook2man], [docbook2man], [no])
+	AC_CHECK_PROG(DB2X_DOCBOOK2MAN, [db2x_docbook2man], [db2x_docbook2man], [no])
+	AS_IF([test "$DOCBOOK2X_MAN" != "no"], [DB2MAN="$DOCBOOK2X_MAN"],
+	      [AS_IF([test "$DOCBOOK2MAN" != "no"], [DB2MAN="$DOCBOOK2MAN"],
+		     [AS_IF([test "$DB2X_DOCBOOK2MAN" != "no"],
+			    [DB2MAN="$DB2X_DOCBOOK2MAN"],
+			    [AC_MSG_WARN([docbookx2-man/db2x_docbook2man not found, no manpages will be built])]
+		     )]
+	     )]
+	)
+	AC_SUBST(DB2MAN)
+])
 
 AM_COND_IF([BUILD_PDF], [
 	AC_CHECK_PROG(DBLATEX, [dblatex], [found], [no])
@@ -161,5 +169,6 @@ nft configuration:
   cli support:			${with_cli}
   enable debugging symbols:	${with_debug}
   use mini-gmp:			${with_mini_gmp}
+  enable man page:              ${enable_man_doc}
   enable pdf documentation:	${enable_pdf_doc}
   libxtables support:		${with_libxtables}"
-- 
2.15.1

