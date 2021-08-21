Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06DCEC4338F
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Aug 2021 05:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3F0B611C9
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Aug 2021 05:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhHUFiy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Aug 2021 01:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhHUFiy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Aug 2021 01:38:54 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5735AC061575
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Aug 2021 22:38:15 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id t13so10471482pfl.6
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Aug 2021 22:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xFC0KDJXPd+lqKpf3D1n+XRWwbEcV4spDt/Mr8eCIOM=;
        b=SiL1+Wi+32oCxQ6TDiIUjNBJD06X4/4QfzaPXchtTNp5RTxZQFCCUBNypzXIe59tVe
         wRNYHY26jW2sVez0mllJR473THNSXY8QfcOzkDTpdMoQzQNEoZPxqtfF1KJakBFgE0Ea
         WiKPunEhFhGAnBP7Csr8tROXsErvTIYF3pS9O8Co1KoU7JIOddVViTpI0oq4IjO86/u6
         5GhaTlvv2jhNcJMWjpV16A5gdr5UyGVwpFbN3EK2Rn9GkPi0fydfA39CsF3AHPig3vAK
         7SzrZEd1FZKJxmjtb5NYhKRdDj/JIrnZaioGH4GJ6ETnOGVPllZa4iGgd8qyRDP1M7fK
         hLjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=xFC0KDJXPd+lqKpf3D1n+XRWwbEcV4spDt/Mr8eCIOM=;
        b=Hx3HyK2RSrp927dUTy+M9gvOa0YIcGf7zbYRpGLfqofcAF4sVfY71WyAiRiJxzNDDF
         edDJtTy3wLFVaTwWp1Ci3dp3QN7PI6dtlmsVIA9M5oQN/hR1cQyih0lrykife14NlwFe
         XykAhSSVVtLqgaPhkTpqa5yBbUVRdpiCZjuytVkQyprsBFINuCq2wX9ld90sN3B/qb4w
         /ToTdKvv4ahQsHiApKeKlm6hAmV7CwUmmOtvrpnxDY0IPbQU5LGLZzWg8Dh2qpbikoM+
         TKnF5QuJv7oONqjLmwF5svKLhHBSVDxOTbaNTc9ZDpxAf2Wkbzmc5zkKXG1uELNHxUUz
         O/ag==
X-Gm-Message-State: AOAM532590a0f0T6+kYbFK0pMU6YqOzoJNO2NXTj/iVrivzZUOID3YDy
        oagZJzklnv/BZ8vTZdbKpB7cZTK/3LV7eg==
X-Google-Smtp-Source: ABdhPJzLtc6fibhMynSLSLfIel6q+cZGcW/uyjlEEm+tmXvKTSN+mvjUyW0UYhOMoPBVfoJv6t9ROw==
X-Received: by 2002:a65:450c:: with SMTP id n12mr21506672pgq.316.1629524294934;
        Fri, 20 Aug 2021 22:38:14 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id n30sm8905913pfv.87.2021.08.20.22.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 22:38:14 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 2/3] build: doc: can choose what to build and install
Date:   Sat, 21 Aug 2021 15:38:04 +1000
Message-Id: <20210821053805.6371-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210821053805.6371-1-duncan_roe@optusnet.com.au>
References: <20210821053805.6371-1-duncan_roe@optusnet.com.au>
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

