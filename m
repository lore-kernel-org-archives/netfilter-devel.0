Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4A54C4320A
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Sep 2021 08:59:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B19EF610A1
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Sep 2021 08:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244796AbhIBJAw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Sep 2021 05:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233507AbhIBJAw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Sep 2021 05:00:52 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7BAC061575
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Sep 2021 01:59:54 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id e7so745958plh.8
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Sep 2021 01:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hUUCm/+DSUBkmewmy5OZfV3s9tRKXeyAwdsPHRvuvgA=;
        b=nQR2j58bLLo/FqIIqzFY0iobAGTIqBZ4RKFcHiqgwqzocfuaejhQPWCo4hGM2+g+J/
         44KT9GSf9J7KpdDDRx5zF81NNqxN6TdCUX4PWFcRyWfIPVn0Fx+gti5+8EFWej0YYE6Z
         pfhdlplnKQiBF3uwviHrPWPrQgWyDnFjm9XD4Cx87TrZHQh87I6z41kvU3UgrH5m15QD
         8m93e/4davKMXysgvCUX/mg8DsyRJDMzm5fKSCvyWE0bnj72qruCWZEYSQoimUGEsRPT
         W5tGfpn2VPAoHf7WxVRWJ82M38MOQHc0uG5Zz1bj9szRseVEm+G5GoalGlZPra4eUYys
         Vk9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=hUUCm/+DSUBkmewmy5OZfV3s9tRKXeyAwdsPHRvuvgA=;
        b=nrL2956ys8oDgDpdtNrdh6U1gdjcEiMIfSm98skcsLGSUxQ9JDLeCz8JA67py0koG0
         hEc+SJZfNHUsyH65XbSv6sN8SpMWZRpzvTG7jA2Tk1D6aU6CZTgx4ugcEKZmBIDclFbT
         EYaRdFIv4jy5YAwKyCn5uw/Yo6q0759TS5GAqgiTRZMy1SQeSIi4oJ3DIRDZQKxoNL1y
         yb3Yzz92F3JZNtFz7wiBCOPDoP8R1+muQPXqc5clc2l+axGyYohDok14eH2nYePGbac+
         pBQtTlg+U0cHlJEvoy9hpKTGz9vyjN6niRh+JZHlqzBzhz1CUz75aTcYeFPJaYDLPFEB
         jNNQ==
X-Gm-Message-State: AOAM532nCNLDn3V0jD2in1GoDEaHc9l0mU3q33DfCPekPlTBIBR9aI6y
        ow+frmGP27ppDd86l0qlqWnRUraBgMs=
X-Google-Smtp-Source: ABdhPJy3M2O55XR2NUswsYaN+7ByLxDDDtm5qhh9ZEXG8JT9JoIBl1VCEDYXDy+jbGWh0qIM3GMvhQ==
X-Received: by 2002:a17:90a:de16:: with SMTP id m22mr2765349pjv.38.1630573194072;
        Thu, 02 Sep 2021 01:59:54 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id s14sm1884719pgf.4.2021.09.02.01.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 01:59:53 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_log 1/1] build: doc: `make` generates requested documentation
Date:   Thu,  2 Sep 2021 18:59:45 +1000
Message-Id: <20210902085945.22099-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210902085945.22099-1-duncan_roe@optusnet.com.au>
References: <20210902085945.22099-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Generate man pages, HTML, neither or both according to ./configure.
Based on the work done for libnetfilter_queue

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 .gitignore                               |  2 +-
 Makefile.am                              |  2 +-
 autogen.sh                               |  8 ++++
 configure.ac                             | 58 +++++++++++++++++++++++-
 doxygen/Makefile.am                      | 39 ++++++++++++++++
 doxygen.cfg.in => doxygen/doxygen.cfg.in |  9 ++--
 6 files changed, 111 insertions(+), 7 deletions(-)
 create mode 100644 doxygen/Makefile.am
 rename doxygen.cfg.in => doxygen/doxygen.cfg.in (76%)

diff --git a/.gitignore b/.gitignore
index 5eaabe3..41a3c1c 100644
--- a/.gitignore
+++ b/.gitignore
@@ -13,6 +13,6 @@ Makefile.in
 /configure
 /libtool
 
-/doxygen/
+/build_man.sh
 /doxygen.cfg
 /*.pc
diff --git a/Makefile.am b/Makefile.am
index 2a9cdd8..6662d7b 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,4 +1,4 @@
-SUBDIRS	= include src utils
+SUBDIRS	= include src utils doxygen
 
 ACLOCAL_AMFLAGS = -I m4
 
diff --git a/autogen.sh b/autogen.sh
index 5e1344a..b47c529 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -1,4 +1,12 @@
 #!/bin/sh -e
 
+# Allow to override build_man.sh url for local testing
+# E.g. export NFQ_URL=file:///usr/src/libnetfilter_queue
+NFQ_URL=${NFQ_URL:-https://git.netfilter.org/libnetfilter_queue/plain}
+
+curl $NFQ_URL/doxygen/build_man.sh -O
+chmod a+x build_man.sh
+mv build_man.sh doxygen/
+
 autoreconf -fi
 rm -Rf autom4te.cache
diff --git a/configure.ac b/configure.ac
index c914e00..c37b934 100644
--- a/configure.ac
+++ b/configure.ac
@@ -12,6 +12,35 @@ m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
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
@@ -35,8 +64,35 @@ PKG_CHECK_MODULES([LIBNETFILTER_CONNTRACK], [libnetfilter_conntrack >= 1.0.2],
 		  [HAVE_LNFCT=1], [HAVE_LNFCT=0])
 AM_CONDITIONAL([BUILD_NFCT], [test "$HAVE_LNFCT" -eq 1])
 
+AS_IF([test "$enable_man_pages" = no -a "$enable_html_doc" = no], [with_doxygen=no])
+
+AS_IF([test "x$with_doxygen" != xno], [
+	AC_CHECK_PROGS([DOXYGEN], [doxygen])
+	AC_CHECK_PROGS([DOT], [dot], [""])
+	AS_IF([test "x$DOT" != "x"],
+	      [AC_SUBST(HAVE_DOT, YES)],
+	      [AC_SUBST(HAVE_DOT, NO)])
+])
+
+AM_CONDITIONAL([HAVE_DOXYGEN], [test -n "$DOXYGEN"])
+AS_IF([test "x$DOXYGEN" = x], [
+	AS_IF([test "x$with_doxygen" != xno], [
+		dnl Only run doxygen Makefile if doxygen installed
+		AC_MSG_WARN([Doxygen not found - no documentation will be built])
+		with_doxygen=no
+		enable_html_doc=no
+		enable_man_pages=no
+	])
+])
+
 dnl Output the makefile
 AC_CONFIG_FILES([Makefile src/Makefile include/Makefile
 	include/libnetfilter_log/Makefile utils/Makefile libnetfilter_log.pc
-	doxygen.cfg])
+	doxygen/Makefile doxygen/doxygen.cfg])
 AC_OUTPUT
+
+echo "
+libnetfilter_log configuration:
+  doxygen:                    ${with_doxygen}
+man pages:                    ${enable_man_pages}
+html docs:                    ${enable_html_doc}"
diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
new file mode 100644
index 0000000..582db4e
--- /dev/null
+++ b/doxygen/Makefile.am
@@ -0,0 +1,39 @@
+if HAVE_DOXYGEN
+
+doc_srcs = $(top_srcdir)/src/libnetfilter_log.c\
+	   $(top_srcdir)/src/nlmsg.c\
+	   $(top_srcdir)/src/libipulog_compat.c
+
+doxyfile.stamp: $(doc_srcs) Makefile
+	rm -rf html man
+	doxygen doxygen.cfg >/dev/null
+
+if BUILD_MAN
+	$(abs_top_srcdir)/doxygen/build_man.sh
+endif
+
+	touch doxyfile.stamp
+
+CLEANFILES = doxyfile.stamp
+
+all-local: doxyfile.stamp
+clean-local:
+	rm -rf man html
+install-data-local:
+if BUILD_MAN
+	mkdir -p $(DESTDIR)$(mandir)/man3
+	cp --no-dereference --preserve=links,mode,timestamps man/man3/*.3\
+	  $(DESTDIR)$(mandir)/man3/
+endif
+if BUILD_HTML
+	mkdir  -p $(DESTDIR)$(htmldir)
+	cp  --no-dereference --preserve=links,mode,timestamps html/*\
+		$(DESTDIR)$(htmldir)
+endif
+
+# make distcheck needs uninstall-local
+uninstall-local:
+	rm -rf $(DESTDIR)$(mandir) man html doxyfile.stamp $(DESTDIR)$(htmldir)
+endif
+
+EXTRA_DIST = build_man.sh
diff --git a/doxygen.cfg.in b/doxygen/doxygen.cfg.in
similarity index 76%
rename from doxygen.cfg.in
rename to doxygen/doxygen.cfg.in
index dc2fddb..b6c27dc 100644
--- a/doxygen.cfg.in
+++ b/doxygen/doxygen.cfg.in
@@ -1,12 +1,11 @@
 # Difference with default Doxyfile 1.8.20
 PROJECT_NAME           = @PACKAGE@
 PROJECT_NUMBER         = @VERSION@
-OUTPUT_DIRECTORY       = doxygen
 ABBREVIATE_BRIEF       =
 FULL_PATH_NAMES        = NO
 TAB_SIZE               = 8
 OPTIMIZE_OUTPUT_FOR_C  = YES
-INPUT                  = .
+INPUT                  = @abs_top_srcdir@/src
 FILE_PATTERNS          = *.c
 RECURSIVE              = YES
 EXCLUDE_SYMBOLS        = nflog_g_handle \
@@ -18,7 +17,9 @@ SOURCE_BROWSER         = YES
 ALPHABETICAL_INDEX     = NO
 GENERATE_LATEX         = NO
 LATEX_CMD_NAME         = latex
-GENERATE_MAN           = YES
-HAVE_DOT               = YES
+GENERATE_MAN           = @GEN_MAN@
+GENERATE_HTML          = @GEN_HTML@
+MAN_LINKS              = YES
+HAVE_DOT               = @HAVE_DOT@
 DOT_TRANSPARENT        = YES
 SEARCHENGINE           = NO
-- 
2.17.5

