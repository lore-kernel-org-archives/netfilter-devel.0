From: Giorgio Dal Molin <giorgio.nicole@arcor.de>
Subject: [PATCH 6/8] autotool conversion: Converted the support for the 'doc/' subdir.
Date: Fri, 25 Jul 2014 23:52:57 +0159
Message-ID: <1406325204-23648-7-git-send-email-giorgio.nicole@arcor.de>
References: <20140725171646.GA5718@salvia>
 <1406325204-23648-1-git-send-email-giorgio.nicole@arcor.de>
Cc: Giorgio Dal Molin <giorgio.nicole@arcor.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:33519 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933208AbaGYVy7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jul 2014 17:54:59 -0400
Received: from mail-in-01-z2.arcor-online.net (mail-in-01-z2.arcor-online.net [151.189.8.13])
	by mx.arcor.de (Postfix) with ESMTP id 95CC2197569
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Jul 2014 23:54:57 +0200 (CEST)
In-Reply-To: <1406325204-23648-1-git-send-email-giorgio.nicole@arcor.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

To generate the nft.8 man page the configure script searches for the
tools 'docbookx2-man' and 'db2x_docbook2man'; if at least one is found
then the man page is generated. To force the system not to generate the
man page use the option '--disable-man'.

To generate the pdf doc file the configure script searches for the tool
'dblatex'; if it is found then the pdf doc file is generated. To force
the system not to generate the pdf doc file use the option '--disable-pdf'.
---
 configure.ac    | 73 +++++++++++++++++++++++++++++++++++++++------------------
 doc/Makefile.am | 10 ++++++++
 doc/Makefile.in | 20 ----------------
 3 files changed, 60 insertions(+), 43 deletions(-)
 create mode 100644 doc/Makefile.am
 delete mode 100644 doc/Makefile.in

diff --git a/configure.ac b/configure.ac
index 900b26a..18ca0a2 100644
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
index 0000000..58c79df
--- /dev/null
+++ b/doc/Makefile.am
@@ -0,0 +1,10 @@
+man_MANS = @NFT_8@
+pdf_DATA = @NFT_PDF@
+
+pdfdir=${docdir}/pdf
+
+.xml.pdf:
+	${AM_V_GEN}dblatex -q -t pdf -o $@ $<
+
+.8.xml:
+	${AM_V_GEN}$(DB2MAN) --xinclude $<
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
2.0.3

