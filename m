Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A39C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Oct 2021 04:15:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E78B60F9C
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Oct 2021 04:15:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhJIERJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Oct 2021 00:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhJIERI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Oct 2021 00:17:08 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6987CC061570
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Oct 2021 21:15:12 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id c29so9791229pfp.2
        for <netfilter-devel@vger.kernel.org>; Fri, 08 Oct 2021 21:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B/CNXStxqoi0UFJHKD7KgAVNn+zRHTzFIiKwZkMYQFk=;
        b=oWYhYwyNrJPEfxUgByx4oAX7uoXmO8Qs7ugoISosVQcEHqCETvd/VaIfvCyAVqeNVQ
         5LgFLIMfQgYVzD1HLdrxnxyxAc6zRIEJY1v8wZkuQZHqjHLiACuVfujDNV5dFgJ1Kuku
         mUu/HzV8IGtASxQTsKq84q2SW7aD1U/Bzz2u0PQ+vaffFfCpDkEp0K1OPh6LcUqDBuo8
         d1eJmva1MdRzVxZQO9zeSR+qsP2rrIGNOrApqRBjdJUGItdMo3OTXPieCJ9AaFQaAQG4
         W1HS3jFwbxo84VtLr08Zsmy62K/M+NQZD7spbBqueTs2rWZfRlih3aLMJdLVMPwaZ4fr
         rEyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=B/CNXStxqoi0UFJHKD7KgAVNn+zRHTzFIiKwZkMYQFk=;
        b=72Yh56kBNbzZ8PkdR1eWoW3yWFPUB4SlXQRyo7ldH4qZKbv5YSpVJU8RibapMMmLAG
         gQ7M3zmtJ45Z7x0ePjNWCMKZ/RqBKC6Uxuryw+zo/ptcke1u43lbSAsQDpZWbU13mlun
         ng5vmsdcDZtWS7/i4IH6cxR6tIX1kCSJrS9JW8c0pQvAYTsd+THZWeThAxY9adJ0Ck8X
         yOMIS1CFENPaPPkCpfXGSVuuIfoq93YiY6VSEUuf9KOuUxAF/Vbcgj7zPVejc/He4kaD
         nXJFx54Al7BSEJ8zVEH+j1E1Uc8pFdaUZ4DkPBAxLd9OjdsY8AMCMh9g9yx1CW8QFSwx
         ChGw==
X-Gm-Message-State: AOAM532o7kekwq/gYyQh1zsltf9ljnMpfvt6n9kkU+nZq+P/QJQjMwlu
        6uzSIIsqNm9KaA1riVrdoF4WUAb4ChI=
X-Google-Smtp-Source: ABdhPJydZaxdHNDPAu7njAQc3VJxd4MDzU32cG38GQWq0Q1LeN7/Dj/vmraoB+CsFbJxuFFKmdV0Cg==
X-Received: by 2002:a62:8c92:0:b0:44c:acfe:73a2 with SMTP id m140-20020a628c92000000b0044cacfe73a2mr13815713pfd.9.1633752909596;
        Fri, 08 Oct 2021 21:15:09 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id m186sm708185pfb.165.2021.10.08.21.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 21:15:09 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_log v4] build: doc: `make` generates requested documentation
Date:   Sat,  9 Oct 2021 15:15:04 +1100
Message-Id: <20211009041504.25756-1-duncan_roe@optusnet.com.au>
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
v3: - update .gitignore for clean `git status` after in-tree build
    - adjust configure.ac indentation for better readability
    - adjust configure.ac for all lines to fit in 80cc
v4: implement Jeremy's suggestions
 .gitignore                               |  7 ++--
 Makefile.am                              |  2 +-
 autogen.sh                               |  8 +++++
 configure.ac                             | 45 +++++++++++++++++++++++-
 doxygen/Makefile.am                      | 39 ++++++++++++++++++++
 doxygen.cfg.in => doxygen/doxygen.cfg.in |  9 ++---
 6 files changed, 102 insertions(+), 8 deletions(-)
 create mode 100644 doxygen/Makefile.am
 rename doxygen.cfg.in => doxygen/doxygen.cfg.in (76%)

diff --git a/.gitignore b/.gitignore
index 5eaabe3..9b3ff62 100644
--- a/.gitignore
+++ b/.gitignore
@@ -13,6 +13,9 @@ Makefile.in
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
index 2a9cdd8..6662d7b 100644
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
index c914e00..134178d 100644
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
 AC_DISABLE_STATIC
@@ -35,8 +52,34 @@ PKG_CHECK_MODULES([LIBNETFILTER_CONNTRACK], [libnetfilter_conntrack >= 1.0.2],
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

