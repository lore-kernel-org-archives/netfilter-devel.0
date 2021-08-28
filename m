Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFFC7C432BE
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 03:35:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D115960FBF
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 03:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233213AbhH1DgS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Aug 2021 23:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbhH1DgP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Aug 2021 23:36:15 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72EBC0613D9
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Aug 2021 20:35:24 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id e15so5219587plh.8
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Aug 2021 20:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U0sGQZisqo/d8DbrnRxT6BJu0mjRO69QFmL09EvxPKw=;
        b=pDIQIVuQS/Hb6ZiWl1eC80qwZoT/N8zLQ/8YT4yk311yQGAQJDFF8XvBfFQWn1fIVN
         ZUtFUOgn6gDEaHyWNJOGZ9r/adj83Mhf787xzii1mPk/Z53mQHrGOGBLij/hvU8mI/cR
         QQ036zuCchH8cQl/MkcQqKZWhG3d7TTzrA6v1zG5yR+4wO31TMnbL5HK3VNplADpZKGs
         7nMqu4DSaKCjaYdKwm2PZ+QAYIYNVxQDSU6K89TT5R1PEbEBkzS510ltYU81ojwWZt4Y
         1M46Ak9c8w0TbKlnU+3mbj5vOZf0Td1YGjGTViTioeN9ROk0pipPS8HkcfnpQG4Gdxq4
         icUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=U0sGQZisqo/d8DbrnRxT6BJu0mjRO69QFmL09EvxPKw=;
        b=KrO2X5uaJDtOjvJVnvy4x+WTnClswgI2q6CKh7y8xpwDs5xGUOfYeoqijbaDAriUyy
         TY+B3jrbxp8vJ87Dbjnko1ILVxcOndDX9C21e3ybROUm/BF3e1viJ/moAsi0QIUzhmT3
         5hZVssTjNEWgw0vE8waS48OEQTwSfxLrQfU1/j6+NdCPQ/1ZoAmKJE6iiIgLwrVTEQph
         5YZ9VmmT4XlUQoB8cpm06ksz9pTTY1GtvejQ+XGo+bj7BtXlOySUJDxjGo4xdjmyvn1O
         DASPtKPD6Fhayv9HX298ehkwWwPWpZ1mrOTRvRjIm+uIWJ4TXjvAaT5VlfTd+4T/IKAQ
         HcuQ==
X-Gm-Message-State: AOAM532VbvvJnFxOswljP8Wb16/1Nh8SmejxIgrey4awXlq6Sh6LPiED
        +b/rjfz0s69hugeMc8YORshe88kdCrs=
X-Google-Smtp-Source: ABdhPJy//k3DqImJxyv8HoTho94+PW5G8cxpSbDDLt1cvpajt0CgLSEx14FC6Yq9IN2MUsAQPbchOA==
X-Received: by 2002:a17:902:b10b:b0:134:de66:4f8c with SMTP id q11-20020a170902b10b00b00134de664f8cmr11697752plr.66.1630121724429;
        Fri, 27 Aug 2021 20:35:24 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id q21sm8513021pgk.71.2021.08.27.20.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 20:35:23 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 5/6] build: doc: Allow to specify whether to produce man pages, html, neither or both
Date:   Sat, 28 Aug 2021 13:35:07 +1000
Message-Id: <20210828033508.15618-5-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210828033508.15618-1-duncan_roe@optusnet.com.au>
References: <20210828033508.15618-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

- configure --help lists non-default documentation options.
  Looking around the web, this seemed to me to be what most projects do.
  Listed options are --without-doxygen, --enable-html-doc &
  --disable-man-pages.
- configure warns on inconsistent options e.g. --without-doxygen by itself
  warns man pages will not be built.
- configure.ac re-ordered so --without-doxygen overrides --enable-any-doc.
If html is requested, `make install` installs it in htmldir.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 configure.ac           | 41 ++++++++++++++++++++++++++++++++++++-----
 doxygen/Makefile.am    | 11 ++++++++++-
 doxygen/doxygen.cfg.in |  3 ++-
 3 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/configure.ac b/configure.ac
index 4721eeb..a4fb629 100644
--- a/configure.ac
+++ b/configure.ac
@@ -13,6 +13,35 @@ m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
 dnl kernel style compile messages
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
 
+dnl Must check for --without-doxygen before  checking --enable-*
+AC_ARG_WITH([doxygen], [AS_HELP_STRING([--without-doxygen],
+	    [Don't run doxygen (to create documentation)])],
+	    [with_doxygen="$withval"], [with_doxygen=yes])
+
+AC_ARG_ENABLE([html-doc],
+	      AS_HELP_STRING([--enable-html-doc], [Enable html documentation]),
+	      [], [enable_html_doc=no])
+AS_IF([test "$with_doxygen" = no -a "$enable_html_doc" = yes], [
+	AC_MSG_WARN([Doxygen disabled - html documentation will not be built])
+	enable_html_doc=no
+])
+AM_CONDITIONAL([BUILD_HTML], [test "$enable_html_doc" = yes])
+AS_IF([test "$enable_html_doc" = yes],
+	[AC_SUBST(GEN_HTML, YES)],
+	[AC_SUBST(GEN_HTML, NO)])
+
+AC_ARG_ENABLE([man-pages],
+	      AS_HELP_STRING([--disable-man-pages], [Disable man page documentation]),
+	      [], [enable_man_pages=yes])
+AS_IF([test "$with_doxygen" = no -a "$enable_man_pages" = yes], [
+	AC_MSG_WARN([Doxygen disabled - man pages will not be built])
+	enable_man_pages=no
+])
+AM_CONDITIONAL([BUILD_MAN], [test "$enable_man_pages" = yes])
+AS_IF([test "$enable_man_pages" = yes],
+	[AC_SUBST(GEN_MAN, YES)],
+	[AC_SUBST(GEN_MAN, NO)])
+
 AC_PROG_CC
 AM_PROG_CC_C_O
 AC_DISABLE_STATIC
@@ -36,9 +65,7 @@ AC_CONFIG_FILES([Makefile src/Makefile utils/Makefile examples/Makefile
 	doxygen/Makefile doxygen/doxygen.cfg
 	include/linux/Makefile include/linux/netfilter/Makefile])
 
-AC_ARG_WITH([doxygen], [AS_HELP_STRING([--with-doxygen],
-	    [create doxygen documentation])],
-	    [with_doxygen="$withval"], [with_doxygen=yes])
+AS_IF([test "$enable_man_pages" = no -a "$enable_html_doc" = no], [with_doxygen=no])
 
 AS_IF([test "x$with_doxygen" != xno], [
 	AC_CHECK_PROGS([DOXYGEN], [doxygen])
@@ -52,12 +79,16 @@ AM_CONDITIONAL([HAVE_DOXYGEN], [test -n "$DOXYGEN"])
 AS_IF([test "x$DOXYGEN" = x], [
 	AS_IF([test "x$with_doxygen" != xno], [
 		dnl Only run doxygen Makefile if doxygen installed
-		AC_MSG_WARN([Doxygen not found - continuing without Doxygen support])
+		AC_MSG_WARN([Doxygen not found - no documentation will be built])
 		with_doxygen=no
+		enable_html_doc=no
+		enable_man_pages=no
 	])
 ])
 AC_OUTPUT
 
 echo "
 libnetfilter_queue configuration:
-  doxygen:                      ${with_doxygen}"
+  doxygen:                      ${with_doxygen}
+man pages:                      ${enable_man_pages}
+html docs:                      ${enable_html_doc}"
diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index bab34bf..5235f78 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -6,7 +6,9 @@ doxyfile.stamp: $(doc_srcs) Makefile.am
 	rm -rf html man
 	doxygen doxygen.cfg >/dev/null
 
+if BUILD_MAN
 	$(abs_top_srcdir)/doxygen/build_man.sh
+endif
 
 	touch doxyfile.stamp
 
@@ -16,13 +18,20 @@ all-local: doxyfile.stamp
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

