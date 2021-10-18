Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA28C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Oct 2021 04:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6926610A3
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Oct 2021 04:17:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhJRET4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Oct 2021 00:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbhJRETz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Oct 2021 00:19:55 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA206C06161C
        for <netfilter-devel@vger.kernel.org>; Sun, 17 Oct 2021 21:17:44 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id ls14-20020a17090b350e00b001a00e2251c8so11561827pjb.4
        for <netfilter-devel@vger.kernel.org>; Sun, 17 Oct 2021 21:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QJz9MCa6ZVHGGEkLVIeaQfEE4WDiNDtR/2qEcFoWWP0=;
        b=opiRpy1aAz/lDQMQ+M1f+2Ag5OcG57Oidhx8bquCaFX8dqTI7MxAyT21xVroZzEx0J
         Mh/w6Ht8eUKp6WF+fmGDn4T1vh42+wRBXTYSrHb2NVNvlDZH6F3S1ezuQVU4rURfgGhz
         p9WjVHlEbOlroZF0oDwQ4tAfR6NEW4YVRWUMuS8gkDkEfcjDS15/Jw69s1EFv6E1ACRH
         zqyUaINPQYbjUgTjRW7+JBfX23UTWIKiHI+Nk3Vil4fE728dLdz0fqqhmZkaob2auylD
         NmpoZJYVxOcdRIfN5Zm2rOfaswUgvHGAEao+1/SWTnoEb0MKUs1cSWc/PsH0tsjd43FN
         WP0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=QJz9MCa6ZVHGGEkLVIeaQfEE4WDiNDtR/2qEcFoWWP0=;
        b=ZoROuyaCMDC5/xltWd3etFqohnYlmL/4KH1sTg8P2Na4Ix8CE7mpWVTAfDMf5iQfw7
         GlNylQsguqFG6qzr1L6xtNQhEsqM8/khG/jBvse3Tw5tEzQrrUT62au2LtSJJ7bUBQY0
         xQNsLWX73+uqiM6yIaews+VMQIPI3QnDypWmOI/NFsVFu56VeiWK5yC2qzvRrWBvsebc
         KOUHNHQf85jEr1oqKS8AG+QnZN+iR7JGG9/TCeBW6AMaYMeWP39TmLnoJAxLn6kEheX5
         wYyy/Qf/E/VtvswQSMB2dQfzIzYACAiaqoQ5z4niyud9D/Zwc5KOJjhowLSXARzXlnhu
         l8IQ==
X-Gm-Message-State: AOAM532R/fOkEpSNY/DDJfYm1nF4WUQm7hWiyoKHyHf9W1xYl5S27GCi
        bxkbeT7xaPdJmuTvpEqavZrfgLao4JI=
X-Google-Smtp-Source: ABdhPJykGnfpk3kPvN+TqtcQxAv5hY/YiitMdJyAmDZLz1J3MZj61DrjYTVv0JZomqMqZBWSypuiyw==
X-Received: by 2002:a17:90a:4483:: with SMTP id t3mr44509230pjg.44.1634530664210;
        Sun, 17 Oct 2021 21:17:44 -0700 (PDT)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id i13sm10995987pgf.77.2021.10.17.21.17.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 21:17:43 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v6] build: doc: Allow to specify whether to produce man pages, html, neither or both
Date:   Mon, 18 Oct 2021 15:17:39 +1100
Message-Id: <20211018041739.13989-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

New default action is: run doxygen (if installed) to produce man pages only.
This adds 124 KB to the build tree (and to the install tree, after
`make install`).
For finer control of built documentation, the old --with-doxygen configure
option is removed. Instead there are 2 new options:
  --enable-html-doc      # +1160 KB
  --disable-man-pages    #  -124 KB
If doxygen is not installed, configure outputs a warning that man pages will not
be built. configure --disable-man-pages avoids this warning.
After --enable-html-doc
 - `make install` installs built pages in htmldir instead of just leaving them
   in the build tree.
 - If the 'dot' program is not installed, configure outputs a warning that
   interactive diagrams will be missing and to install graphviz to get them.
   (There is an interactive diagram at the head of some modules, e.g.
    User-space network packet buffer).

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
v2: broken out from 0001-build-doc-Fix-man-pages.patch
v3: no change (still part of a series)
v4: remove --without-doxygen since -disable-man-pages does that
v5: - update .gitignore for clean `git status` after in-tree build
    - in configure.ac:
      - ensure all variables are always set (avoid leakage from environment)
      - provide helpful warning if HTML enabled but dot not found
v6: - move .gitignore changes to separate patch
    - re-work commit message
(no code changes from v5)
 configure.ac           | 34 +++++++++++++++++++++++++++-------
 doxygen/Makefile.am    | 11 ++++++++++-
 doxygen/doxygen.cfg.in |  3 ++-
 3 files changed, 39 insertions(+), 9 deletions(-)

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

