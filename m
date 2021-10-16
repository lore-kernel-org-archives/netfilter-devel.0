Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C18C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Oct 2021 04:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F294061222
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Oct 2021 04:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240668AbhJPEmC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 16 Oct 2021 00:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239415AbhJPEmC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 16 Oct 2021 00:42:02 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044E4C061570
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Oct 2021 21:39:55 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id c4so3369163pgv.11
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Oct 2021 21:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i9JpjL980ETRd4VL7Xi7Snxjf6CcVE6dT9gqdCL6Mbw=;
        b=F1x7nyBrOdP+SoZS6yNP91LbsiDfQgry8gUmATy/cUD2Ljk8Ys5ZAZ2FQW7s/Gl+XV
         IEhqk07sIXduhWTOszY/BIz5pg2pXZbYLrs11GeF80P6+ue/BmrL666IBXH6f8WPsuWd
         hqgP1OrJ8YsESz9HCUMUGt7fJlqhy+7tbXsNmSL0WyIoGPAUehb0nZdFTwl+82q+70sL
         kC1s96d5GJbVdOdmqbDM/PD8rU05MAxr1z57yMoQYdxfv4Ff3Ow7l+JRGkmUJpSBsv0h
         fu4c6eiLFYJdGeKkX8ds3szy4uBx/LpHhPilwO+uogcFxlJrIQvp9pMeucaxoCzscQjZ
         2Hxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=i9JpjL980ETRd4VL7Xi7Snxjf6CcVE6dT9gqdCL6Mbw=;
        b=XaBsDIXgBIWr5xzddOPZMejaVM2et7QtiNkflOolfrOVd6dWO19dak8y0jN+W4DFGt
         wiuWoiSVvinwNqaYt3Py0B8nve34L7qEYXQ1qqOZwx+UHhElxihlysHWQRYbl+77Balv
         nYGOhzqNE5+8AiPyxLdZjhgihmNvni+i/FFte570RSaf7bmiORIizscmMBt29IoMX2wA
         5H0JYZAscoc3cBa5qA8TGJ8p+l06yIdchIS2CLoJQgk5GgvjSqM3Zy/BKWh+gAUfxj1y
         0/+MORngE95w/lSZSuYemm50ZfhhB51Asq69omtUg/mI52GqVwi9gNgtf11wb2wDCOqY
         AOMg==
X-Gm-Message-State: AOAM530Lwpwe5gAtpGo1k7D4TxTXmMuwYvWoZSWdMlUREIqPapdJ+EOg
        ZPh0iLmAeIpKePdZ5Kt6iRhfLQ39qL0=
X-Google-Smtp-Source: ABdhPJzRg8qflDfWFrXhGFE56Oh30tHVtJmlFC65XVZOoKG/Cy5rl7LZddmDmjB4/vLYV/2tVfXkUA==
X-Received: by 2002:a63:84c3:: with SMTP id k186mr12367425pgd.462.1634359194146;
        Fri, 15 Oct 2021 21:39:54 -0700 (PDT)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id h1sm6518894pfh.183.2021.10.15.21.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 21:39:53 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_log v5] build: doc: Allow to specify whether to produce man pages, html, neither or both
Date:   Sat, 16 Oct 2021 15:39:48 +1100
Message-Id: <20211016043948.2422-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

- configure --help lists non-default documentation options.
  Looking around the web, this seemed to me to be what most projects do.
  Listed options are --enable-html-doc & --disable-man-pages.
- --with-doxygen is removed: --disable-man-pages also disables doxygen unless
  --enable-html-doc is asserted.
If html is requested, `make install` installs it in htmldir.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
v2: broken out from 0001-build-doc-Fix-man-pages.patch
v3: no change (still part of a series)
v4: remove --without-doxygen since -disable-man-pages does that
v5: - update .gitignore for clean `git status` after in-tree build
    - in configure.ac:
      - ensure all variables are always set (avoid leakage from environment)
      - provide helpful warning if HTML enabled but dot not found
 .gitignore             |  5 ++++-
 configure.ac           | 34 +++++++++++++++++++++++++++-------
 doxygen/Makefile.am    | 11 ++++++++++-
 doxygen/doxygen.cfg.in |  3 ++-
 4 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/.gitignore b/.gitignore
index 525628e..ae3e740 100644
--- a/.gitignore
+++ b/.gitignore
@@ -15,7 +15,10 @@ Makefile.in
 /libtool
 /stamp-h1
 
-/doxygen.cfg
+/doxygen/doxygen.cfg
 /libnetfilter_queue.pc
 
 /examples/nf-queue
+/doxygen/doxyfile.stamp
+/doxygen/html/
+/doxygen/man/
diff --git a/configure.ac b/configure.ac
index 4721eeb..83959b0 100644
--- a/configure.ac
+++ b/configure.ac
@@ -13,6 +13,22 @@ m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
 dnl kernel style compile messages
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
 
+AC_ARG_ENABLE([html-doc],
+	      AS_HELP_STRING([--enable-html-doc], [Enable html documentation]),
+	      [], [enable_html_doc=no])
+AM_CONDITIONAL([BUILD_HTML], [test "$enable_html_doc" = yes])
+AS_IF([test "$enable_html_doc" = yes],
+	[AC_SUBST(GEN_HTML, YES)],
+	[AC_SUBST(GEN_HTML, NO)])
+
+AC_ARG_ENABLE([man-pages],
+	      AS_HELP_STRING([--disable-man-pages], [Disable man page documentation]),
+	      [], [enable_man_pages=yes])
+AM_CONDITIONAL([BUILD_MAN], [test "$enable_man_pages" = yes])
+AS_IF([test "$enable_man_pages" = yes],
+	[AC_SUBST(GEN_MAN, YES)],
+	[AC_SUBST(GEN_MAN, NO)])
+
 AC_PROG_CC
 AM_PROG_CC_C_O
 AC_DISABLE_STATIC
@@ -36,12 +52,10 @@ AC_CONFIG_FILES([Makefile src/Makefile utils/Makefile examples/Makefile
 	doxygen/Makefile doxygen/doxygen.cfg
 	include/linux/Makefile include/linux/netfilter/Makefile])
 
-AC_ARG_WITH([doxygen], [AS_HELP_STRING([--with-doxygen],
-	    [create doxygen documentation])],
-	    [with_doxygen="$withval"], [with_doxygen=yes])
+AS_IF([test "$enable_man_pages" = no -a "$enable_html_doc" = no], [with_doxygen=no], [with_doxygen=yes])
 
 AS_IF([test "x$with_doxygen" != xno], [
-	AC_CHECK_PROGS([DOXYGEN], [doxygen])
+	AC_CHECK_PROGS([DOXYGEN], [doxygen], [""])
 	AC_CHECK_PROGS([DOT], [dot], [""])
 	AS_IF([test "x$DOT" != "x"],
 	      [AC_SUBST(HAVE_DOT, YES)],
@@ -52,12 +66,18 @@ AM_CONDITIONAL([HAVE_DOXYGEN], [test -n "$DOXYGEN"])
 AS_IF([test "x$DOXYGEN" = x], [
 	AS_IF([test "x$with_doxygen" != xno], [
 		dnl Only run doxygen Makefile if doxygen installed
-		AC_MSG_WARN([Doxygen not found - continuing without Doxygen support])
-		with_doxygen=no
+		AC_MSG_WARN([Doxygen not found - no documentation will be built])
+		enable_html_doc=no
+		enable_man_pages=no
 	])
+], [
+	dnl Warn user if html docs will be missing diagrams
+	AS_IF([test "$enable_html_doc" = yes -a -z "$DOT"],
+		AC_MSG_WARN([Dot not found - install graphviz to get interactive diagrams in HTML]))
 ])
 AC_OUTPUT
 
 echo "
 libnetfilter_queue configuration:
-  doxygen:                      ${with_doxygen}"
+man pages:                      ${enable_man_pages}
+html docs:                      ${enable_html_doc}"
diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index 5a7fdd5..c6eeed7 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -14,7 +14,9 @@ doxyfile.stamp: $(doc_srcs) Makefile
 	rm -rf html man
 	doxygen doxygen.cfg >/dev/null
 
+if BUILD_MAN
 	$(abs_top_srcdir)/doxygen/build_man.sh
+endif
 
 	touch doxyfile.stamp
 
@@ -24,13 +26,20 @@ all-local: doxyfile.stamp
 clean-local:
 	rm -rf man html
 install-data-local:
+if BUILD_MAN
 	mkdir -p $(DESTDIR)$(mandir)/man3
 	cp --no-dereference --preserve=links,mode,timestamps man/man3/*.3\
 	  $(DESTDIR)$(mandir)/man3/
+endif
+if BUILD_HTML
+	mkdir  -p $(DESTDIR)$(htmldir)
+	cp  --no-dereference --preserve=links,mode,timestamps html/*\
+		$(DESTDIR)$(htmldir)
+endif
 
 # make distcheck needs uninstall-local
 uninstall-local:
-	rm -r $(DESTDIR)$(mandir) man html doxyfile.stamp
+	rm -rf $(DESTDIR)$(mandir) man html doxyfile.stamp $(DESTDIR)$(htmldir)
 endif
 
 EXTRA_DIST = build_man.sh
diff --git a/doxygen/doxygen.cfg.in b/doxygen/doxygen.cfg.in
index 99b5c90..14bd0cf 100644
--- a/doxygen/doxygen.cfg.in
+++ b/doxygen/doxygen.cfg.in
@@ -21,7 +21,8 @@ ALPHABETICAL_INDEX     = NO
 SEARCHENGINE           = NO
 GENERATE_LATEX         = NO
 LATEX_CMD_NAME         = latex
-GENERATE_MAN           = YES
+GENERATE_MAN           = @GEN_MAN@
+GENERATE_HTML          = @GEN_HTML@
 MAN_LINKS              = YES
 HAVE_DOT               = @HAVE_DOT@
 DOT_TRANSPARENT        = YES
-- 
2.17.5

