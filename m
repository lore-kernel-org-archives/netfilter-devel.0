Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 997F0C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Sep 2021 02:28:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 776F561247
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Sep 2021 02:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238693AbhI1C37 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Sep 2021 22:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238684AbhI1C35 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Sep 2021 22:29:57 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A57C061604
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Sep 2021 19:28:18 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id y8so17621822pfa.7
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Sep 2021 19:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7iJHS+lbbLBhK3v4sGpL4OT93pHuWrj1No7xTcfadRY=;
        b=jqOfxuHnWTq3Zt5cNTIu3a6pBbHlDv9dr9yPRvXM3zXKcOORmer2YUwwWchtUG/1oE
         eC0Al9F+HwIQ7ZGn/WGIbCj/Q/6TQ6tx++q00L+PK8ThswsRNzLmxO3KvNducpGl2v5v
         30TadygnesvLb+FD3hKygI1zB3MZWRreruE2SC+0Bv1J4qDb7nf3NJDHNJjSdZgECwRD
         XJNu+tQyQ2h4xA/e6pZpX8vUo9W8As1jHWE5lnKJ0WoQvzZFp6RcRRVV2kOzeFPAgzXQ
         fKYXnqdcUlcaF6Im35q4mXgQCHwXmN5Al2cVVDAngZFpTYOuDyfOvLhh4+975J+pZZkb
         3OnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=7iJHS+lbbLBhK3v4sGpL4OT93pHuWrj1No7xTcfadRY=;
        b=V/U70Io1xoU2sLx/VPsrAyD85bEujKjkCf+dFH8lwf8zXgbH+mImNxuS7T3Kxuzqm0
         rCORgvr70enFuufsYcaKvlVIV7XJOlLGLy1+rJmG/C4NQaZxFLL0TZt4UOmDap0Dkryu
         hm13vnam/rRnNuvAdQ0ovwKeBzWA5nKZfRIK+DHbtRg0Abd+vqswUxYBRP1EBhwSpkcp
         3bIKfchfxW8PukhmIqaGo3x9XHX29wM48PjCIP4dcmbBFEDNncpQsNHdezaY8mjHvtE9
         Ie6+EcYyU44oKpcrAYjd49RjdrMLGwNxaJiQrfCYjGNi+1U7RdeNTI8I8ZK5MfEhn2GZ
         huzA==
X-Gm-Message-State: AOAM530pexB1ZXROd81rAzlEPkjGAiE6FnmyDq3K+cHwE82U2yruOLgF
        G4LTMU30+vFb/XG77MSWWnelU1eJHUU=
X-Google-Smtp-Source: ABdhPJxYYgcLT/v0YM1wWZHy8CXDNOhiFfrJtC3GZ0XXYHZ+d4HhrlhicDQvW6Tx9cFn+ecodOm16w==
X-Received: by 2002:a63:3483:: with SMTP id b125mr2454085pga.35.1632796097733;
        Mon, 27 Sep 2021 19:28:17 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id 65sm18657727pfu.187.2021.09.27.19.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 19:28:17 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_log v2] build: doc: `make` generates requested documentation
Date:   Tue, 28 Sep 2021 12:28:13 +1000
Message-Id: <20210928022813.12582-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Generate man pages, HTML, neither or both according to ./configure.
Based on the work done for libnetfilter_queue

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
v2: remove --without-doxygen since -disable-man-pages does that
 .gitignore                               |  2 +-
 Makefile.am                              |  2 +-
 autogen.sh                               |  8 +++++
 configure.ac                             | 43 +++++++++++++++++++++++-
 doxygen/Makefile.am                      | 39 +++++++++++++++++++++
 doxygen.cfg.in => doxygen/doxygen.cfg.in |  9 ++---
 6 files changed, 96 insertions(+), 7 deletions(-)
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
index c914e00..f51a867 100644
--- a/configure.ac
+++ b/configure.ac
@@ -12,6 +12,22 @@ m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
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
@@ -35,8 +51,33 @@ PKG_CHECK_MODULES([LIBNETFILTER_CONNTRACK], [libnetfilter_conntrack >= 1.0.2],
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

