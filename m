From: Giorgio Dal Molin <giorgio.dal.molin@mobotix.com>
Subject: [PATCH 1/1] autotools conversion: added autotools support for the 'doc' subdir.
Date: Mon, 10 Nov 2014 15:57:05 +0100
Message-ID: <1415631425-10121-3-git-send-email-giorgio.dal.molin@mobotix.com>
References: <1415631425-10121-1-git-send-email-giorgio.dal.molin@mobotix.com>
Cc: Giorgio <giorgio.nicole@arcor.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:41935 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752229AbaKJO5Z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:57:25 -0500
Received: from mail-in-12-z2.arcor-online.net (mail-in-12-z2.arcor-online.net [151.189.8.29])
	by mx.arcor.de (Postfix) with ESMTP id 940D110BFBE
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2014 15:57:23 +0100 (CET)
In-Reply-To: <1415631425-10121-1-git-send-email-giorgio.dal.molin@mobotix.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Giorgio <giorgio.nicole@arcor.de>

---
 Makefile.am     |  5 ++---
 configure.ac    | 45 ++++++++++++++++++++++-----------------------
 doc/Makefile.am | 19 +++++++++++++++++++
 doc/Makefile.in | 20 --------------------
 4 files changed, 43 insertions(+), 46 deletions(-)
 create mode 100644 doc/Makefile.am
 delete mode 100644 doc/Makefile.in

diff --git a/Makefile.am b/Makefile.am
index f48b08c..5268c38 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,5 +1,4 @@
-include Make_global.am
-
 ACLOCAL_AMFLAGS	= -I m4
 
-SUBDIRS		= src
+SUBDIRS =	src	\
+		doc
diff --git a/configure.ac b/configure.ac
index 15bb3e9..ba3299c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -49,29 +49,24 @@ then
         exit 1
 fi
 
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
+AC_CHECK_PROG(DOCBOOK2X_MAN, [docbook2x-man], [docbook2x-man], [no])
+AC_CHECK_PROG(DOCBOOK2MAN, [docbook2man], [docbook2man], [no])
+AC_CHECK_PROG(DB2X_DOCBOOK2MAN, [db2x_docbook2man], [db2x_docbook2man], [no])
+AS_IF([test "$DOCBOOK2X_MAN" != "no"], [DB2MAN="$DOCBOOK2X_MAN"],
+	[AS_IF([test "$DOCBOOK2MAN" != "no"], [DB2MAN="$DOCBOOK2MAN"],
+		[AS_IF([test "$DB2X_DOCBOOK2MAN" != "no"], [DB2MAN="$DB2X_DOCBOOK2MAN"],
+			[AC_MSG_WARN([docbookx2-man/db2x_docbook2man not found, no manpages will be built])]
+		)]
+	)]
+)
 AC_SUBST(DB2MAN)
+AM_CONDITIONAL([BUILD_MAN], [test -n "$DB2MAN"])
 
-AC_CHECK_PROG(CONFIG_PDF, dblatex, y, n)
-if test "$CONFIG_PDF" != "y"
-then
-	AC_MSG_WARN([dblatex not found, no PDF manpages will be built])
-fi
+AC_CHECK_PROG(DBLATEX, [dblatex], [found], [no])
+AS_IF([test "$DBLATEX" == "no"],
+	[AC_MSG_WARN([dblatex not found, no PDF manpages will be built])]
+)
+AM_CONDITIONAL([BUILD_PDF], [test "$DBLATEX" == "found"])
 
 # Checks for libraries.
 PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
@@ -119,6 +114,10 @@ AC_TYPE_UINT64_T
 # Checks for library functions.
 AC_CHECK_FUNCS([memmove memset strchr strdup strerror strtoull])
 
-AC_CONFIG_FILES([Makefile])
-AC_CONFIG_FILES([src/Makefile])
+AC_CONFIG_FILES([					\
+		Makefile				\
+		src/Makefile				\
+		doc/Makefile				\
+		])
+
 AC_OUTPUT
diff --git a/doc/Makefile.am b/doc/Makefile.am
new file mode 100644
index 0000000..a92de7f
--- /dev/null
+++ b/doc/Makefile.am
@@ -0,0 +1,19 @@
+if BUILD_MAN
+man_MANS = nft.8
+endif
+
+if BUILD_PDF
+pdf_DATA = nft.pdf
+endif
+
+pdfdir=${docdir}/pdf
+
+.xml.pdf:
+	${AM_V_GEN}dblatex -q -t pdf -o $@ $<
+
+.xml.8:
+	${AM_V_GEN}${DB2MAN} --xinclude $<
+
+EXTRA_DIST = nft.xml
+
+CLEANFILES = nft.pdf nft.8 *~
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
2.1.3

