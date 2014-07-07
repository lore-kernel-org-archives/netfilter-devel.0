From: Giorgio Dal Molin <giorgio.nicole@arcor.de>
Subject: [PATCH 5/7] autotool conversion: Converted the support for the 'doc/' subdir.
Date: Mon,  7 Jul 2014 12:15:42 +0159
Message-ID: <1404728169-7899-6-git-send-email-giorgio.nicole@arcor.de>
References: <1404728169-7899-1-git-send-email-giorgio.nicole@arcor.de>
Cc: Giorgio <giorgio.nicole@arcor.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:38577 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752648AbaGGKQu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2014 06:16:50 -0400
Received: from mail-in-12-z2.arcor-online.net (mail-in-12-z2.arcor-online.net [151.189.8.29])
	by mx.arcor.de (Postfix) with ESMTP id C217F3AF172
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Jul 2014 12:16:48 +0200 (CEST)
In-Reply-To: <1404728169-7899-1-git-send-email-giorgio.nicole@arcor.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Giorgio <giorgio.nicole@arcor.de>

To generate the nft.8 man page the configure script searches for the
tools 'docbookx2-man' and 'db2x_docbook2man'; if at least one is found
then the man page is generated. To force the system not to generate the
man page use the option '--disable-man'.

To generate the pdf doc file the configure script searches for the tool
'dblatex'; if it is found then the pdf doc file is generated. To force
the system not to generate the pdf doc file use the option '--disable-pdf'.
---
 configure.ac    | 73 +++++++++++++++++++++++++++++++++++++++------------------
 doc/Makefile.am | 12 ++++++++++
 doc/Makefile.in | 20 ----------------
 3 files changed, 62 insertions(+), 43 deletions(-)
 create mode 100644 doc/Makefile.am
 delete mode 100644 doc/Makefile.in

diff --git a/configure.ac b/configure.ac
index 7070cb8..18f6f51 100644
--- a/configure.ac
+++ b/configure.ac
@@ -27,30 +27,57 @@ AC_PROG_SED
 AC_PROG_YACC
 AM_PROG_LEX
 
-AC_CHECK_PROG(CONFIG_MAN1, [docbook2x-man], [y], [n])
-if test "$CONFIG_MAN1" == "y"
-then
-	CONFIG_MAN=y
-	DB2MAN=docbook2x-man
-else
-	AC_CHECK_PROG(CONFIG_MAN2, [db2x_docbook2man], [y], [n])
-	if test "$CONFIG_MAN2" == "y"
-	then
-		CONFIG_MAN=y
-		DB2MAN=db2x_docbook2man
-	else
-		AC_MSG_WARN([docbookx2-man/db2x_docbook2man not found, no manpages will be built])
-	fi
-fi
-AC_SUBST(CONFIG_MAN)
-AC_SUBST(DB2MAN)
-
-AC_CHECK_PROG(CONFIG_PDF, dblatex, y, n)
-if test "$CONFIG_PDF" != "y"
-then
-	AC_MSG_WARN([dblatex not found, no PDF manpages will be built])
-fi
+AC_CHECK_PROG(DOCBOOK2X_MAN, [docbook2x-man], [found], [no])
+AC_CHECK_PROG(DB2X_DOCBOOK2MAN, [db2x_docbook2man], [found], [no])
+AS_CASE([$DOCBOOK2X_MAN],
+	[found],[
+		DB2MAN=docbook2x-man
+		NFT_8=nft.8
+		],
+	[AS_CASE([$DB2X_DOCBOOK2MAN],
+		[found],[
+			DB2MAN=db2x_docbook2man
+			NFT_8=nft.8
+			],
+		[AC_MSG_WARN([docbookx2-man/db2x_docbook2man not found, no manpages will be built])]
+	)]
+)
+
+AC_ARG_ENABLE([man], AS_HELP_STRING([--enable-man], [Enable generating the man page nft.8. Requires docbook2x-man or db2x_docbook2man.]))
+
+AC_MSG_CHECKING([whether to generate the man page])
+AS_CASE([${enable_man}],
+	[yes],[
+		AS_IF([test -z "$DB2MAN"],AC_MSG_ERROR([No tool found to generate the man page. Please install either docbook2x-man or db2x_docbook2man.]))
+		AC_MSG_RESULT(yes)
+	], [
+	NFT_8=""
+	AC_MSG_RESULT(no)
+	]
+)
 
+AC_SUBST(DB2MAN)
+AC_SUBST(NFT_8)
+
+AC_CHECK_PROG(DBLATEX, [dblatex], [found], [no])
+AS_CASE([$DBLATEX],
+	[found],[NFT_PDF=nft.pdf],
+	[AC_MSG_WARN([dblatex not found, no PDF manpages will be built])]
+)
+
+AC_MSG_CHECKING([whether to generate the pdf doc])
+AC_ARG_ENABLE([pdf], AS_HELP_STRING([--enable-pdf], [Enable generating the pdf doc file nft.pdf. Requires dblatex.]))
+AS_CASE([${enable_pdf}],
+	[yes],[
+		AS_IF([test -z "$DBLATEX"], AC_MSG_ERROR([No tool found to generate the pdf doc. Please install dblatex.]))
+		AC_MSG_RESULT(yes)
+	],[
+	NFT_PDF=""
+	AC_MSG_RESULT(no)
+	]
+)
+
+AC_SUBST(NFT_PDF)
 
 # Checks for libraries.
 
diff --git a/doc/Makefile.am b/doc/Makefile.am
new file mode 100644
index 0000000..6ea973a
--- /dev/null
+++ b/doc/Makefile.am
@@ -0,0 +1,12 @@
+man_MANS = @NFT_8@
+pdf_DATA = @NFT_PDF@
+
+pdfdir=${docdir}/pdf
+
+nft.pdf: nft.xml
+	@echo -e "  PDF\t\t$@"
+	@dblatex -q -t pdf -o $@ $<
+
+nft.8: nft.xml
+	@echo -e "  MAN\t\t$@"
+	@$(DB2MAN) --xinclude $<
diff --git a/doc/Makefile.in b/doc/Makefile.in
deleted file mode 100644
index 1ec856c..0000000
--- a/doc/Makefile.in
+++ /dev/null
@@ -1,20 +0,0 @@
-mandocs-@CONFIG_MAN@	+= doc/nft.8
-pdfdocs-@CONFIG_PDF@	+= doc/nft.pdf
-
-all:		$(mandocs-y) $(pdfdocs-y)
-clean:
-		@echo -e "  CLEAN\t\tdoc"
-		$(RM) $(mandocs-y) $(pdfdocs-y)
-
-install:	$(mandocs-y) $(pdfdocs-y)
-		@echo -e "  INSTALL\tdoc"
-		if test -n "$(mandocs-y)"; then \
-			$(MKDIR_P) $(DESTDIR)/${mandir}/man8 ;\
-			$(INSTALL) -m 755 -p $(mandocs-y) \
-					$(DESTDIR)/${mandir}/man8/ ;\
-		fi
-		if test -n "$(pdfdocs-y)"; then \
-			$(MKDIR_P) $(DESTDIR)/${pdfdir} ;\
-			$(INSTALL) -m 755 -p $(pdfdocs-y) \
-					$(DESTDIR)/${pdfdir}/ ;\
-		fi
-- 
2.0.1

