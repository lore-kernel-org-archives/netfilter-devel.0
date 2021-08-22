Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14200C432BE
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 04:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE4E261130
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 04:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhHVEPc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Aug 2021 00:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbhHVEPc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Aug 2021 00:15:32 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950DDC061575
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Aug 2021 21:14:51 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id c17so13369505pgc.0
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Aug 2021 21:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xFC0KDJXPd+lqKpf3D1n+XRWwbEcV4spDt/Mr8eCIOM=;
        b=PJNx2R47A555RioD7UBFvZ/WXzt/I6nTYV7swe02SqB5j6VYW/Imi8ipJQezVUeyO6
         UIlrY69mbj4hQV0cKK8X6dj1ATa+QKxqlD+7RzH3h3XXAW8PN9/bq0jW6Xxss5+6H9US
         Hn4ttC1zh28fu75a+b8WDli6/1WL5bG/224ZgRca92oE9LJAgxHfLNJztBsaume6OKAp
         57fktp7evzqzQ+gYUhPFn115sOXYPBl9hBJylSylrQtmzyk+TGY3o6auoKrsqV9qjVsD
         MY/mldghTpohlXjldzTjHAQ0Hdi5OTqw03U4jYqPIbIpr6EECIRjM/8TblqwAnSCHvDe
         25dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=xFC0KDJXPd+lqKpf3D1n+XRWwbEcV4spDt/Mr8eCIOM=;
        b=oYRWHqb636HoFkDrOrBDcjHiUx1i3hgXkEVGG9zYZKz1EC2gGyg0PHuPgogoqUKgtV
         6YGeOCkj50R+Y+c+9Be5AKBVc5xgaXISa+AGYUXvgGmcwxcK1oK/75FWfNa5ammMpSJu
         k0Bj9QFMgDmIgnAXOwssUnvHRcF3mV6lixltbOklhqIoQ5gPSc5dlxR6MHggHk75mb2x
         RQOj7MixGzrY7MqtB30QtoGCL6r1dUFHdxyl5Kj2p8EJ3HP6murV8qhgxtn2qB4R3pQH
         4+8AW1A3EkiWT9LdbWDA9A+YOGFH3hSxkgJ4aS/9+soXQ271RHf8mQM0QsfZP2eLTlnO
         MRyA==
X-Gm-Message-State: AOAM531HDdup38M6XOEeOwzVmZxvlSp2HeOBeSMB61xxxF4oj7Ie9srL
        3oQJWpFQiETJkVantCyPhYQvVZcJa45uVA==
X-Google-Smtp-Source: ABdhPJyZiAyNiaV6rk+xNsl23I/+DCRrz3t4QLIdAW9kdWzxerRieivQjyttDqY63FWFj6lrx4IpOg==
X-Received: by 2002:a05:6a00:1904:b029:3b9:e4ea:1f22 with SMTP id y4-20020a056a001904b02903b9e4ea1f22mr27572690pfi.79.1629605691149;
        Sat, 21 Aug 2021 21:14:51 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id lk17sm5777271pjb.44.2021.08.21.21.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Aug 2021 21:14:50 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v4 2/4] build: doc: can choose what to build and install
Date:   Sun, 22 Aug 2021 14:14:40 +1000
Message-Id: <20210822041442.8394-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210822041442.8394-1-duncan_roe@optusnet.com.au>
References: <20210822041442.8394-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update doxygen/Makefile.am to build and install man pages and html documentation
conditionally. Involves configure.ac and doxygen.cfg.in, see below.

CONFIGURE.AC

Update `configure --help` to list non-default documentation options, as do most
packages (i.e. list non-defaults). 3 listed options:
1. --enable-html-doc
2. --disable-man-pages
3. --without-doxygen
Option 3 overrides 1 & 2: e.g. if you have --without-doxygen but not
--disable-man-pages you get:
  WARNING: Doxygen disabled - man pages will not be built
doxygen is not run if no documentation is requested.

Configure command                  Installed package size (KB)
========= =======                  ========= ======= ==== ====
./configure --without-doxygen       176
./configure --disable-man-pages     176
./configure                         300
./configure --enable-html-doc      1460
./configure --enable-html-doc\
	    --disable-man-pages    1340

Do some extra re-ordering for clarity. Also for clarity, since this is
linux-only, re-work test commands to look mode modern.

DOXYGEN.CFG.IN

HTML and man page generation are both conditional.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 configure.ac        | 76 +++++++++++++++++++++++++++++++--------------
 doxygen.cfg.in      |  3 +-
 doxygen/Makefile.am | 11 ++++++-
 3 files changed, 64 insertions(+), 26 deletions(-)

diff --git a/configure.ac b/configure.ac
index 0fe754c..376d4ff 100644
--- a/configure.ac
+++ b/configure.ac
@@ -10,9 +10,42 @@ AM_INIT_AUTOMAKE([-Wall foreign subdir-objects
 	tar-pax no-dist-gzip dist-bzip2 1.6])
 m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
 
+case "$host" in
+*-*-linux* | *-*-uclinux*) ;;
+*) AC_MSG_ERROR([Linux only, dude!]);;
+esac
+
 dnl kernel style compile messages
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
 
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
@@ -20,44 +53,39 @@ AM_PROG_LIBTOOL
 AC_PROG_INSTALL
 CHECK_GCC_FVISIBILITY
 
-case "$host" in
-*-*-linux* | *-*-uclinux*) ;;
-*) AC_MSG_ERROR([Linux only, dude!]);;
-esac
-
 dnl Dependencies
 PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 0.0.41])
 PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
 
-dnl Output the makefiles
-AC_CONFIG_FILES([Makefile src/Makefile utils/Makefile examples/Makefile
-        libnetfilter_queue.pc doxygen.cfg
-	include/Makefile include/libnetfilter_queue/Makefile
-	doxygen/Makefile
-	include/linux/Makefile include/linux/netfilter/Makefile])
-
-AC_ARG_WITH([doxygen], [AS_HELP_STRING([--with-doxygen],
-	    [create doxygen documentation])],
-	    [with_doxygen="$withval"], [with_doxygen=yes])
+AS_IF([test "$enable_man_pages" = no -a "$enable_html_doc" = no], [with_doxygen=no])
 
-AS_IF([test "x$with_doxygen" != xno], [
+AS_IF([test "$with_doxygen" = yes], [
 	AC_CHECK_PROGS([DOXYGEN], [doxygen])
 	AC_CHECK_PROGS([DOT], [dot], [""])
-	AS_IF([test "x$DOT" != "x"],
+	AS_IF([test -n "$DOT"],
 	      [AC_SUBST(HAVE_DOT, YES)],
 	      [AC_SUBST(HAVE_DOT, NO)])
 ])
 
 AM_CONDITIONAL([HAVE_DOXYGEN], [test -n "$DOXYGEN"])
-AS_IF([test "x$DOXYGEN" = x], [
-	AS_IF([test "x$with_doxygen" != xno], [
-		dnl Only run doxygen Makefile if doxygen installed
-		AC_MSG_WARN([Doxygen not found - continuing without Doxygen support])
-		with_doxygen=no
-	])
+AS_IF([test -z "$DOXYGEN" -a "$with_doxygen" = yes], [
+	dnl Only run doxygen Makefile if doxygen installed
+	AC_MSG_WARN([Doxygen not found - no documentation will be built])
+	with_doxygen=no
+	enable_html_doc=no
+	enable_man_pages=no
 ])
+
+dnl Output the makefiles
+AC_CONFIG_FILES([Makefile src/Makefile utils/Makefile examples/Makefile
+	libnetfilter_queue.pc doxygen.cfg
+	include/Makefile include/libnetfilter_queue/Makefile
+	doxygen/Makefile
+	include/linux/Makefile include/linux/netfilter/Makefile])
 AC_OUTPUT
 
 echo "
 libnetfilter_queue configuration:
-  doxygen:                      ${with_doxygen}"
+  doxygen:                      ${with_doxygen}
+man pages:                      ${enable_man_pages}
+html docs:                      ${enable_html_doc}"
diff --git a/doxygen.cfg.in b/doxygen.cfg.in
index 266782e..757d72e 100644
--- a/doxygen.cfg.in
+++ b/doxygen.cfg.in
@@ -22,7 +22,8 @@ ALPHABETICAL_INDEX     = NO
 SEARCHENGINE           = NO
 GENERATE_LATEX         = NO
 LATEX_CMD_NAME         = latex
-GENERATE_MAN           = YES
+GENERATE_MAN           = @GEN_MAN@
+GENERATE_HTML          = @GEN_HTML@
 MAN_LINKS              = YES
 HAVE_DOT               = @HAVE_DOT@
 DOT_TRANSPARENT        = YES
diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index 5bcef61..37ed7aa 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -24,6 +24,7 @@ doxyfile.stamp: $(doc_srcs) Makefile.am
 # automake (run by autogen.sh) allows comments starting ## after continuations
 # but not blank lines
 
+if BUILD_MAN
 	/bin/bash -p -c 'declare -A renamed_page;\
 ##
 main(){ set -e; cd man/man3; rm -f _*;\
@@ -219,6 +220,7 @@ remove_temp_files(){ for i in $$temps;\
 };\
 ##
 main'
+endif
 
 	touch doxyfile.stamp
 
@@ -228,11 +230,18 @@ all-local: doxyfile.stamp
 clean-local:
 	rm -rf $(top_srcdir)/doxygen/man $(top_srcdir)/doxygen/html
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
+	rm -rf $(DESTDIR)$(htmldir) $(DESTDIR)$(mandir) man html doxyfile.stamp
 endif
-- 
2.17.5

