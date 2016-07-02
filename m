From: Nicholas Vinson <nvinson234@gmail.com>
Subject: [PATCH 1/1 rev. 1] nft: configure.ac: Replace magic dblatex dep.
Date: Sat,  2 Jul 2016 11:34:20 -0700
Message-ID: <20160702183420.18609-1-nvinson234@gmail.com>
Cc: Nicholas Vinson <nvinson234@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33512 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbcGBSev (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Jul 2016 14:34:51 -0400
Received: by mail-pf0-f195.google.com with SMTP id c74so12762051pfb.0
        for <netfilter-devel@vger.kernel.org>; Sat, 02 Jul 2016 11:34:51 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a configure switch to enable and disable PDF document generation.
This switch is to replace the current method of automatically detecting
dblatex and building the PDF documentation when present.

Signed-off-by: Nicholas Vinson <nvinson234@gmail.com>
---
 configure.ac | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/configure.ac b/configure.ac
index 0e7edcf..877f530 100644
--- a/configure.ac
+++ b/configure.ac
@@ -29,6 +29,12 @@ AC_ARG_ENABLE([debug],
 AC_SUBST(with_debug)
 AM_CONDITIONAL([BUILD_DEBUG], [test "x$with_debug" != xno])
 
+AC_ARG_ENABLE([pdf-doc],
+	      AS_HELP_STRING([--enable-pdf-doc], [Enable PDF documentation]),
+	      AS_IF([test "x$enable_pdf_doc" = "xno"], [enable_pdf_doc=no],
+	      [enable_pdf_doc=yes]), [enable_pdf_doc=no])
+AM_CONDITIONAL([BUILD_PDF], [test "x$enable_pdf_doc" == "xyes" ])
+
 # Checks for programs.
 AC_PROG_CC
 AC_PROG_MKDIR_P
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

