Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C344C433FE
	for <netfilter-devel@archiver.kernel.org>; Sun, 10 Oct 2021 02:37:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E04E60F57
	for <netfilter-devel@archiver.kernel.org>; Sun, 10 Oct 2021 02:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhJJCjk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Oct 2021 22:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhJJCjk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Oct 2021 22:39:40 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD0CC061570
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Oct 2021 19:37:42 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id a73so7325645pge.0
        for <netfilter-devel@vger.kernel.org>; Sat, 09 Oct 2021 19:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YCS1lBttf4rno5Mxe9SteAZeunF8T+fnkopRzho/VqQ=;
        b=fTnEb8mElaPdCN250698eVCzDGjgoHV+5Fiih1dUmdZCO9sCUBY1D1CrBLtjHGgjW8
         eUhnQFtMFvwA6MsDB8mHyfn7H2D5OlnPZ8HnOJfx6lqA3O1uMUogyDaoEuaISaYZxsHX
         2R5Cskr7Z9O/b/bk6hYozrrzqmGLzaN6jA0Zjmzci6ABgd7InVVjGr/RKEO+Sq7g8KGc
         iih9eRRbbrJl4KBSjMUDPZ/4I3m9zpS0OSfF5ILvz4JxGirTYaILFFqDVow1P8W8IM3b
         9bre66yxT7aT9BY5rz5lVyhNYvjI5BTe0Oe7KjOPCH+TphPL+JtrNnL+Ytzf3hVk31w+
         s9ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=YCS1lBttf4rno5Mxe9SteAZeunF8T+fnkopRzho/VqQ=;
        b=T+12Ilfy4Ek8fgeOBC42tLWbwUnDcHnHf4btahyg75tzSOsjG01xzRph7HzhGS2qq+
         VJaQ3sTbGDH+NTzcqXADCeB7eogAXRDJpeQNz00mJ4zFoQborxJSDPWvOrRQWwBGsKAg
         ltw+/e2jJgkQpUQRMnghaJJ4sDuN+YshO2BU99qm2q6qHg88n/3JLuIbBxHi4FIVNkWp
         xpktis0xgyQKTakn6etyr3UUn0r3stB6IGmOtU5Fqw2OcwxSijEh9FNpIXi/V8ihzKwU
         1kPKwELgdoksQRdK3q7KF54U4NVtsmWCauHt1gp81ZyHGc3MEcWWU3lZUAQcntK6eMOz
         jx+w==
X-Gm-Message-State: AOAM5301/SE8H8lPoW9DhOZ/oDMQjwb1eV6jcr552PQKA/MYJpdZCibU
        BShVIIdyxwLnBVBMLI8tq069M1AhLdI=
X-Google-Smtp-Source: ABdhPJwyae3a9c/0o0MFMKiNYIpOYM131PeG5q+hw7R9uUIzsFUPQsNZEDpsgPnTtKNhQs82tBcnWA==
X-Received: by 2002:a63:6a05:: with SMTP id f5mr12019285pgc.398.1633833461563;
        Sat, 09 Oct 2021 19:37:41 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id b23sm3889749pgn.83.2021.10.09.19.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 19:37:41 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_log v5 1/1] build: doc: `make` generates requested documentation
Date:   Sun, 10 Oct 2021 13:37:34 +1100
Message-Id: <20211010023734.26923-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010023734.26923-1-duncan_roe@optusnet.com.au>
References: <20211010023734.26923-1-duncan_roe@optusnet.com.au>
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
v3: - update .gitignore for clean `git status` after in-tree build
    - adjust configure.ac indentation for better readability
    - adjust configure.ac for all lines to fit in 80cc
v4: implement Jeremy's suggestions
v5: rebase on top of Jeremy's "Build fixes" patch series
 .gitignore                               |  7 ++--
 Makefile.am                              |  2 +-
 autogen.sh                               |  8 +++++
 configure.ac                             | 46 +++++++++++++++++++++++-
 doxygen/Makefile.am                      | 39 ++++++++++++++++++++
 doxygen.cfg.in => doxygen/doxygen.cfg.in |  9 ++---
 6 files changed, 103 insertions(+), 8 deletions(-)
 create mode 100644 doxygen/Makefile.am
 rename doxygen.cfg.in => doxygen/doxygen.cfg.in (76%)

diff --git a/.gitignore b/.gitignore
index ef6bb0f..4990a51 100644
--- a/.gitignore
+++ b/.gitignore
@@ -16,6 +16,9 @@ Makefile.in
 /configure
 /libtool
 
-/doxygen/
-/doxygen.cfg
+/doxygen/doxygen.cfg
+/doxygen/build_man.sh
+/doxygen/doxyfile.stamp
+/doxygen/man/
+/doxygen/html/
 /*.pc
diff --git a/Makefile.am b/Makefile.am
index c7b86f7..46b14f9 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,4 +1,4 @@
-SUBDIRS	= include src utils
+SUBDIRS	= include src utils doxygen
 
 ACLOCAL_AMFLAGS = -I m4
 
diff --git a/autogen.sh b/autogen.sh
index 5e1344a..93e2a23 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -1,4 +1,12 @@
 #!/bin/sh -e
 
+BUILD_MAN=doxygen/build_man.sh
+
+# Allow to override build_man.sh url for local testing
+# E.g. export NFQ_URL=file:///usr/src/libnetfilter_queue
+curl ${NFQ_URL:-https://git.netfilter.org/libnetfilter_queue/plain}/$BUILD_MAN\
+  -o$BUILD_MAN
+chmod a+x $BUILD_MAN
+
 autoreconf -fi
 rm -Rf autom4te.cache
diff --git a/configure.ac b/configure.ac
index 85e49ed..589eb59 100644
--- a/configure.ac
+++ b/configure.ac
@@ -12,6 +12,23 @@ m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
 dnl kernel style compile messages
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
 
+AC_ARG_ENABLE([html-doc],
+	      AS_HELP_STRING([--enable-html-doc], [Enable html documentation]),
+	      [], [enable_html_doc=no])
+AM_CONDITIONAL([BUILD_HTML], [test "$enable_html_doc" = yes])
+AS_IF([test "$enable_html_doc" = yes],
+      [AC_SUBST(GEN_HTML, YES)],
+      [AC_SUBST(GEN_HTML, NO)])
+
+AC_ARG_ENABLE([man-pages],
+	      AS_HELP_STRING([--disable-man-pages],
+			     [Disable man page documentation]),
+	      [], [enable_man_pages=yes])
+AM_CONDITIONAL([BUILD_MAN], [test "$enable_man_pages" = yes])
+AS_IF([test "$enable_man_pages" = yes],
+      [AC_SUBST(GEN_MAN, YES)],
+      [AC_SUBST(GEN_MAN, NO)])
+
 AC_PROG_CC
 AM_PROG_CC_C_O
 LT_INIT([disable_static])
@@ -37,6 +54,27 @@ PKG_CHECK_MODULES([LIBNETFILTER_CONNTRACK], [libnetfilter_conntrack >= 1.0.2],
 		  [HAVE_LNFCT=1], [HAVE_LNFCT=0])
 AM_CONDITIONAL([BUILD_NFCT], [test "$HAVE_LNFCT" -eq 1])
 
+AS_IF([test "$enable_man_pages" = no -a "$enable_html_doc" = no],
+      [with_doxygen=no], [with_doxygen=yes])
+
+AS_IF([test "x$with_doxygen" != xno], [
+	AC_CHECK_PROGS([DOXYGEN], [doxygen], [""])
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
+		AC_MSG_WARN([Doxygen not found - not building documentation])
+		enable_html_doc=no
+		enable_man_pages=no
+	])
+])
+
 dnl Output the makefile
 AC_CONFIG_FILES([Makefile
 		src/Makefile
@@ -45,5 +83,11 @@ AC_CONFIG_FILES([Makefile
 		utils/Makefile
 		libnetfilter_log.pc
 		libnetfilter_log_libipulog.pc
-		doxygen.cfg])
+		doxygen/Makefile
+		doxygen/doxygen.cfg])
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

