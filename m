Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75084C4320A
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Aug 2021 03:44:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 574E56108E
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Aug 2021 03:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238062AbhHZDou (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Aug 2021 23:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235803AbhHZDot (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 23:44:49 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB16C061757
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Aug 2021 20:44:03 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id w19-20020a17090aaf9300b00191e6d10a19so1413057pjq.1
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Aug 2021 20:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U0sGQZisqo/d8DbrnRxT6BJu0mjRO69QFmL09EvxPKw=;
        b=O9KjDEhWpr+kRmDgisIprnhquj+zsUKDni6LTuJCDeg1oTdPrrkeonhioFiisI15jV
         6s6Szmg2fuKJx8quLcs1mFGhEt0eFO+bylwdXryfW+VoRPgj8mvXxl+5bmTpy54ohTDO
         DowXCt0zh93tSBRtLnHoEii0ykDw1w5FMuZGpzA6ju5+rZef51IhPDI5wI30ushxCHw4
         819unVLRB75UgN2Aego1pzuq49gbFNPzl6dVARnMGYxlTCrmdMrecC36IJ2N/Yj9XxKK
         CNaw28p9guEu6mP6B/rejUIc7W5eh83LQCOFsCz4FG7G9gdzWw76GbSVKX6btqHPW8uB
         tYsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=U0sGQZisqo/d8DbrnRxT6BJu0mjRO69QFmL09EvxPKw=;
        b=SzRmhPZQR4EcQDRLyKjpsypieiqpBWpe78bX1EU5diaJtaxu7lEypz8AyAyE/jR6K0
         M2fHgQOT7wDRMLXDJPXDvm5n7gnVyfyfl/SFw0fXHGRVApn4G9wPv4nsyVOLcTk9vXjS
         iKHpmUz7pZuhYkkbX6iUH61HqYr4RFqDqSZIdYgUueq6N+bbeHTu/RNDj4eWqtc4Vnai
         +jdu78G5kb3guGUOTNlT8xi4Ay/ShVgd8uvvmpFSNmygL3DR1HFOjtxa0mvOltFIweu0
         8GfOLotbYctn268bQu5Fi5I//B2HYTU7OdTE4DDj5yJ+tSmEseQ8DjqgYBlH+PI7vkmp
         WNCQ==
X-Gm-Message-State: AOAM531qwEpLCQfH0Xr7n8C9x/H32Mi1qRNp6N+jGcxavtMADgg/YuJb
        7NCjuvIAQmtit37O+20a2Ob7UujxlFxqRw==
X-Google-Smtp-Source: ABdhPJwlF1XXRvF6/dF7oJXwtXv0dDhcysPJKfYFd7b6hkBcEP777h2zshCwHba13vJIoghrdHnpgA==
X-Received: by 2002:a17:90a:5b0f:: with SMTP id o15mr13953770pji.97.1629949442531;
        Wed, 25 Aug 2021 20:44:02 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id s11sm1109193pfh.18.2021.08.25.20.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 20:44:02 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v2 5/5] build: doc: Allow to specify whether to produce man pages, html, neither or both
Date:   Thu, 26 Aug 2021 13:43:46 +1000
Message-Id: <20210826034346.13224-5-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210826034346.13224-1-duncan_roe@optusnet.com.au>
References: <20210826034346.13224-1-duncan_roe@optusnet.com.au>
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

