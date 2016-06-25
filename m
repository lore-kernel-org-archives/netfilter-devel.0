From: Nicholas Vinson <nvinson234@gmail.com>
Subject: [PATCH 1/1] nft: configure.ac: Replace magic dblatex dep.
Date: Sat, 25 Jun 2016 09:28:09 -0700
Message-ID: <20160625162809.11877-1-nvinson234@gmail.com>
Cc: Nicholas Vinson <nvinson234@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:34211 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbcFYQ2q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 25 Jun 2016 12:28:46 -0400
Received: by mail-pa0-f68.google.com with SMTP id us13so11589387pab.1
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Jun 2016 09:28:46 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a configure switch to enable and disable PDF document generation.
This switch is to replace the current method of automatically detecting
dblatex and building the PDF documentation when present.

Bug: 1074
Signed-off-by: Nicholas Vinson <nvinson234@gmail.com>
---
 configure.ac | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/configure.ac b/configure.ac
index 0e7edcf..cbc7868 100644
--- a/configure.ac
+++ b/configure.ac
@@ -22,6 +22,12 @@ AC_CONFIG_HEADER([config.h])
 AC_DEFINE([_GNU_SOURCE], [], [Enable various GNU extensions])
 AC_DEFINE([_STDC_FORMAT_MACROS], [], [printf-style format macros])
 
+AC_ARG_ENABLE([pdf-doc],
+	      AS_HELP_STRING([--disable-pdf-doc], [Disable PDF documentation]),
+	      AS_IF([test "x$enable_pdf_doc" = "xno"], [enable_pdf_doc=no],
+	      [enable_pdf_doc=yes]), [enable_pdf_doc=yes])
+AM_CONDITIONAL([BUILD_PDF], [test "x$enable_pdf_doc" == "xyes" ])
+
 AC_ARG_ENABLE([debug],
 	      AS_HELP_STRING([--enable-debug], [Disable debugging]),
 	      AS_IF([test "x$enable_debug" = "xno"], [with_debug=no], [with_debug=yes]),
@@ -63,11 +69,11 @@ AS_IF([test "$DOCBOOK2X_MAN" != "no"], [DB2MAN="$DOCBOOK2X_MAN"],
 AC_SUBST(DB2MAN)
 AM_CONDITIONAL([BUILD_MAN], [test -n "$DB2MAN"])
 
-AC_CHECK_PROG(DBLATEX, [dblatex], [found], [no])
-AS_IF([test "$DBLATEX" == "no"],
-	[AC_MSG_WARN([dblatex not found, no PDF manpages will be built])]
-)
-AM_CONDITIONAL([BUILD_PDF], [test "$DBLATEX" == "found"])
+AM_COND_IF([BUILD_PDF], [
+	AC_CHECK_PROG(DBLATEX, [dblatex], [found], [no])
+	AS_IF([test "$DBLATEX" == "no"],
+	      [AC_MSG_ERROR([dblatex not found])])
+])
 
 # Checks for libraries.
 PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
@@ -136,4 +142,5 @@ echo "
 nft configuration:
   cli support:			${with_cli}
   enable debugging:		${with_debug}
-  use mini-gmp:			${with_mini_gmp}"
+  use mini-gmp:			${with_mini_gmp}
+  enable pdf documentation:	${enable_pdf_doc}"
-- 
2.9.0

