Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF75C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Sep 2021 05:32:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78FA56124B
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Sep 2021 05:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244166AbhIXFe2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Sep 2021 01:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243369AbhIXFeX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Sep 2021 01:34:23 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D75C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Sep 2021 22:32:50 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id bb10so5726100plb.2
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Sep 2021 22:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=piMifv+q21c5onewIRLIWqmQekgHh1xA0bAUiv0GVUo=;
        b=THRDIU0NANTxDTy3jWLlY/dAPDoVEFmNU+Qq8BDMcTJ9gG7EDb5pkNgzYtaI55NJsy
         X66pEJocZX2/SpeFSXjiSSkIairBH1ea+kPJQuVoWvwqcwkWy3ozm0cN2v2Aobe3wkJz
         I8B/fpYjGqTrV/q54PGd/hvyFq/l5ENCCtJNOvfvARfRbjdnWohI8Vw07K0ixkO/CrlA
         dC8P7SxO4AvksybW2uoc+EN+aK/zzSJcoexR2To6euDOJf4r0BFOBS9pYtMTYvcyE2/v
         /ltTuSr8dgoTLlKoFeTWnzgt3Y/rzcEZuYhw/NMVWqcRi70SdVw1ehDrahmq2ZFrOzdx
         ZtLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=piMifv+q21c5onewIRLIWqmQekgHh1xA0bAUiv0GVUo=;
        b=wUQ4SiWZKm8ojm9/UnG2nliEw3DES9s2FLh7CTIfvD2vhWvGE2FGnGlfPd/US3nGph
         28/H3ExvY0NEIkAveUWpsh9tOba0exuNG9z5TdNqqMnOVfGPP7/s3O+O/vxVS5ySE4Rf
         wD3xvZ/3c1dds2PbXyugqB6S+rC/Jxv4XDtFN3lbaDPOat7y5anglMJ/nku73eoWw54o
         0rrrwwwLEdkTNMI+5gtQN0JlFzzYWNZuotMm7m/Rl4MPmskiJcy0qtXNuFIFMnWiRAr3
         ryICP+fozenMi42C/q7kOYT4X+dIL58Vhgcur+9SfhauDBFbhtXbTZS19HorkpFqwAqt
         yqWQ==
X-Gm-Message-State: AOAM533s53IIPIUgC4OF3DTYdU9g58ppIAI9SwZNyHzj7hASa9B4uRcz
        KxRQjcwGnwlNfdxtAWidLJ8EfzJFOn8=
X-Google-Smtp-Source: ABdhPJxghERRpuJK0YLCHY1owQT9+holWKQZjkBpl8wSCeSvr+y+Ztrc87GwXmUCwvRASVU7+7eITA==
X-Received: by 2002:a17:90a:b009:: with SMTP id x9mr65356pjq.118.1632461570041;
        Thu, 23 Sep 2021 22:32:50 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id e18sm7484433pfj.159.2021.09.23.22.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 22:32:49 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v4 1/1] build: doc: Allow to specify whether to produce man pages, html, neither or both
Date:   Fri, 24 Sep 2021 15:32:42 +1000
Message-Id: <20210924053242.7846-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210924053242.7846-1-duncan_roe@optusnet.com.au>
References: <20210924053242.7846-1-duncan_roe@optusnet.com.au>
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
 configure.ac           | 28 ++++++++++++++++++++++------
 doxygen/Makefile.am    | 11 ++++++++++-
 doxygen/doxygen.cfg.in |  3 ++-
 3 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/configure.ac b/configure.ac
index 4721eeb..77737b2 100644
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
@@ -36,9 +52,7 @@ AC_CONFIG_FILES([Makefile src/Makefile utils/Makefile examples/Makefile
 	doxygen/Makefile doxygen/doxygen.cfg
 	include/linux/Makefile include/linux/netfilter/Makefile])
 
-AC_ARG_WITH([doxygen], [AS_HELP_STRING([--with-doxygen],
-	    [create doxygen documentation])],
-	    [with_doxygen="$withval"], [with_doxygen=yes])
+AS_IF([test "$enable_man_pages" = no -a "$enable_html_doc" = no], [with_doxygen=no])
 
 AS_IF([test "x$with_doxygen" != xno], [
 	AC_CHECK_PROGS([DOXYGEN], [doxygen])
@@ -52,12 +66,14 @@ AM_CONDITIONAL([HAVE_DOXYGEN], [test -n "$DOXYGEN"])
 AS_IF([test "x$DOXYGEN" = x], [
 	AS_IF([test "x$with_doxygen" != xno], [
 		dnl Only run doxygen Makefile if doxygen installed
-		AC_MSG_WARN([Doxygen not found - continuing without Doxygen support])
-		with_doxygen=no
+		AC_MSG_WARN([Doxygen not found - no documentation will be built])
+		enable_html_doc=no
+		enable_man_pages=no
 	])
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

