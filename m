Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2BCCC48BDF
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Jun 2021 04:19:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADCBE61107
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Jun 2021 04:19:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhFVEV6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Jun 2021 00:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhFVEV5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Jun 2021 00:21:57 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18EABC061574
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Jun 2021 21:19:42 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id t9so16010301pgn.4
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Jun 2021 21:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9Mjw+nwdwcjlA20T2kfVHUcqmnZtQ4bscPcujqy45m8=;
        b=Y9wtp5n+oz5NFOBeSIVoM1DnMu1YoNWb2acKkUyd0v8sQ+hakcJenH9XZTfACaPIxu
         XBYC0c56jbBn+gNBds6rOYoqnsRMSTSHS7MLYEA7y2XCgf5yhCGwREPrKmD28+VRNam/
         3BnCyUd3asmtAXOG1DiB839OC5Z9fq23Oyr0xWAEO8h55Kwa/Me80P/kH8flAjjBP6zo
         YAHskmVA3iHdbShh5Wz5AtIHDrMPDDeU5uvVb1gs8kn+xXPsbFepE+Lv3Y+ejibxkl/b
         bSTOuzF1H2V4nwLsw/5mk9eB6jpjhFkuYUmpD3qhoo5FVXysVoSi8H0jZTA0CK2XeNPF
         xiVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=9Mjw+nwdwcjlA20T2kfVHUcqmnZtQ4bscPcujqy45m8=;
        b=Zg0F9/ZmLBBcEASBtwut1nU9rRXF9p/QXv2WlDT7aJiUYRKhvPG+KWfsjprNX/RuuM
         2KMt5iCqQJgOUsBC0PeqwyuMM64YNhrok15+NNJwj2Rp+UR2M3AyF1lD7KRZqi8UWHOD
         7fwVKs7BzQOKrylsh86GPOliCDitoCYdY/XjCn+18qztikPzz2DKwnFjvaedIUF1st+r
         zKbF+S98kRtiBgJjffDT2pr9Zw3oBsGh3OFPmYEjc/c6YONuo0TVJ8IYBE5yhXde261C
         TJXn0ke1PjZ/kOkNg3/qxeSrXJj75/IRi3idtocLsrifsxxPk/r6GY8BJaC6s9OPXPYx
         kY1g==
X-Gm-Message-State: AOAM532Lnt4zPmSv3qyLpJLUuzB3k4a4JDk5nnFxycF51nEmldY0nHWk
        u4J/xu8Jc+Zq86o1zIt73qo=
X-Google-Smtp-Source: ABdhPJwIFUQOllHmKFvabD+gzcs1lSoy8aANOrm6/SdT2NBTnliyrKLpHNmVCviuh7qXXeDIK+GBRQ==
X-Received: by 2002:a63:65c5:: with SMTP id z188mr1861910pgb.174.1624335581539;
        Mon, 21 Jun 2021 21:19:41 -0700 (PDT)
Received: from slk1.local.net (n49-192-52-33.sun3.vic.optusnet.com.au. [49.192.52.33])
        by smtp.gmail.com with ESMTPSA id c6sm8734940pfb.39.2021.06.21.21.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 21:19:41 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, duncan_roe@optusnet.com.au
Subject: [PATCH libmnl 1/1] build: doc: "make" builds & installs a full set of man pages
Date:   Tue, 22 Jun 2021 14:19:33 +1000
Message-Id: <20210622041933.25654-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210622041933.25654-1-duncan_roe@optusnet.com.au>
References: <20210622041933.25654-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Repeat what we did for libnetfilter_queue:
 - New makefile in doxygen directory. Rebuilds documentation if any sources
   change that contain doxygen comments:
   - Renames each group man page to the first function listed therein
   - Creates symlinks for subsequently listed functions
   - Deletes _* temp files and moves sctruct-describing man pages to man7
 - Update top-level makefile to visit new subdir doxygen
 - Update top-level configure to only build documentation if doxygen installed
 - Add --with/without-doxygen switch
 - Check whether dot is available when configuring doxygen
 - Reduce size of doxygen.cfg and doxygen build o/p
 - `make distcheck` passes with doxygen enabled
Aditionally, exclude opaque structs mnl_nlmsg_batch & mnl_socket

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 Makefile.am         |   4 +-
 configure.ac        |  24 +++++-
 doxygen.cfg.in      | 176 ++------------------------------------------
 doxygen/Makefile.am |  75 +++++++++++++++++++
 4 files changed, 107 insertions(+), 172 deletions(-)
 create mode 100644 doxygen/Makefile.am

diff --git a/Makefile.am b/Makefile.am
index dec85d0..94e6935 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -2,8 +2,8 @@ include $(top_srcdir)/Make_global.am
 
 ACLOCAL_AMFLAGS = -I m4
 
-SUBDIRS = src include examples
-DIST_SUBDIRS = src include examples
+SUBDIRS = src include examples doxygen
+DIST_SUBDIRS = src include examples doxygen
 
 pkgconfigdir = $(libdir)/pkgconfig
 pkgconfig_DATA = libmnl.pc
diff --git a/configure.ac b/configure.ac
index 35b2531..a06ae6a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -27,5 +27,27 @@ regular_CFLAGS="-Wall -Waggregate-return -Wmissing-declarations \
 	-Wformat=2 -pipe"
 AC_SUBST([regular_CPPFLAGS])
 AC_SUBST([regular_CFLAGS])
-AC_CONFIG_FILES([Makefile src/Makefile include/Makefile include/libmnl/Makefile include/linux/Makefile include/linux/netfilter/Makefile examples/Makefile examples/genl/Makefile examples/kobject/Makefile examples/netfilter/Makefile examples/rtnl/Makefile libmnl.pc doxygen.cfg])
+AC_CONFIG_FILES([Makefile src/Makefile include/Makefile include/libmnl/Makefile include/linux/Makefile include/linux/netfilter/Makefile examples/Makefile examples/genl/Makefile examples/kobject/Makefile examples/netfilter/Makefile examples/rtnl/Makefile libmnl.pc doxygen.cfg doxygen/Makefile])
+
+AC_ARG_WITH([doxygen], [AS_HELP_STRING([--with-doxygen],
+	    [create doxygen documentation])],
+	    [with_doxygen="$withval"], [with_doxygen=yes])
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
+	dnl Only run doxygen Makefile if doxygen installed
+	AC_MSG_WARN([Doxygen not found - continuing without Doxygen support])
+])
 AC_OUTPUT
+
+echo "
+libmnl configuration:
+  doxygen:          ${with_doxygen}"
diff --git a/doxygen.cfg.in b/doxygen.cfg.in
index 31f0102..1e42e44 100644
--- a/doxygen.cfg.in
+++ b/doxygen.cfg.in
@@ -1,184 +1,22 @@
-DOXYFILE_ENCODING      = UTF-8
+# Difference with default Doxyfile 1.8.20
 PROJECT_NAME           = @PACKAGE@
 PROJECT_NUMBER         = @VERSION@
 OUTPUT_DIRECTORY       = doxygen
-CREATE_SUBDIRS         = NO
-OUTPUT_LANGUAGE        = English
-BRIEF_MEMBER_DESC      = YES
-REPEAT_BRIEF           = YES
-ABBREVIATE_BRIEF       = 
-ALWAYS_DETAILED_SEC    = NO
-INLINE_INHERITED_MEMB  = NO
+ABBREVIATE_BRIEF       =
 FULL_PATH_NAMES        = NO
-STRIP_FROM_PATH        = 
-STRIP_FROM_INC_PATH    = 
-SHORT_NAMES            = NO
-JAVADOC_AUTOBRIEF      = NO
-QT_AUTOBRIEF           = NO
-MULTILINE_CPP_IS_BRIEF = NO
-INHERIT_DOCS           = YES
-SEPARATE_MEMBER_PAGES  = NO
 TAB_SIZE               = 8
-ALIASES                = 
 OPTIMIZE_OUTPUT_FOR_C  = YES
-OPTIMIZE_OUTPUT_JAVA   = NO
-OPTIMIZE_FOR_FORTRAN   = NO
-OPTIMIZE_OUTPUT_VHDL   = NO
-BUILTIN_STL_SUPPORT    = NO
-CPP_CLI_SUPPORT        = NO
-SIP_SUPPORT            = NO
-DISTRIBUTE_GROUP_DOC   = NO
-SUBGROUPING            = YES
-TYPEDEF_HIDES_STRUCT   = NO
-EXTRACT_ALL            = NO
-EXTRACT_PRIVATE        = NO
-EXTRACT_STATIC         = NO
-EXTRACT_LOCAL_CLASSES  = YES
-EXTRACT_LOCAL_METHODS  = NO
-EXTRACT_ANON_NSPACES   = NO
-HIDE_UNDOC_MEMBERS     = NO
-HIDE_UNDOC_CLASSES     = NO
-HIDE_FRIEND_COMPOUNDS  = NO
-HIDE_IN_BODY_DOCS      = NO
-INTERNAL_DOCS          = NO
-CASE_SENSE_NAMES       = YES
-HIDE_SCOPE_NAMES       = NO
-SHOW_INCLUDE_FILES     = YES
-INLINE_INFO            = YES
-SORT_MEMBER_DOCS       = YES
-SORT_BRIEF_DOCS        = NO
-SORT_GROUP_NAMES       = NO
-SORT_BY_SCOPE_NAME     = NO
-GENERATE_TODOLIST      = YES
-GENERATE_TESTLIST      = YES
-GENERATE_BUGLIST       = YES
-GENERATE_DEPRECATEDLIST= YES
-ENABLED_SECTIONS       = 
-MAX_INITIALIZER_LINES  = 30
-SHOW_USED_FILES        = YES
-SHOW_DIRECTORIES       = NO
-FILE_VERSION_FILTER    = 
-QUIET                  = NO
-WARNINGS               = YES
-WARN_IF_UNDOCUMENTED   = YES
-WARN_IF_DOC_ERROR      = YES
-WARN_NO_PARAMDOC       = NO
-WARN_FORMAT            = "$file:$line: $text"
-WARN_LOGFILE           = 
 INPUT                  = .
-INPUT_ENCODING         = UTF-8
-FILE_PATTERNS          = *.c libmnl.h
+FILE_PATTERNS          = */src/*.c
 RECURSIVE              = YES
-EXCLUDE                = 
-EXCLUDE_SYMLINKS       = NO
-EXCLUDE_PATTERNS       = */.git/* .*.d
-EXCLUDE_SYMBOLS        = EXPORT_SYMBOL
-EXAMPLE_PATH           = 
-EXAMPLE_PATTERNS       = 
-EXAMPLE_RECURSIVE      = NO
-IMAGE_PATH             = 
+EXCLUDE_SYMBOLS        = EXPORT_SYMBOL mnl_nlmsg_batch mnl_socket
+EXAMPLE_PATTERNS       =
 INPUT_FILTER           = "sed 's/EXPORT_SYMBOL//g'"
-FILTER_PATTERNS        = 
-FILTER_SOURCE_FILES    = NO
 SOURCE_BROWSER         = YES
-INLINE_SOURCES         = NO
-STRIP_CODE_COMMENTS    = YES
-REFERENCED_BY_RELATION = NO
-REFERENCES_RELATION    = NO
-REFERENCES_LINK_SOURCE = YES
-USE_HTAGS              = NO
-VERBATIM_HEADERS       = YES
 ALPHABETICAL_INDEX     = NO
-COLS_IN_ALPHA_INDEX    = 5
-IGNORE_PREFIX          = 
-GENERATE_HTML          = YES
-HTML_OUTPUT            = html
-HTML_FILE_EXTENSION    = .html
-HTML_HEADER            = 
-HTML_STYLESHEET        = 
-HTML_ALIGN_MEMBERS     = YES
-GENERATE_HTMLHELP      = NO
-GENERATE_DOCSET        = NO
-DOCSET_FEEDNAME        = "Doxygen generated docs"
-DOCSET_BUNDLE_ID       = org.doxygen.Project
-HTML_DYNAMIC_SECTIONS  = NO
-CHM_FILE               = 
-HHC_LOCATION           = 
-GENERATE_CHI           = NO
-BINARY_TOC             = NO
-TOC_EXPAND             = NO
-DISABLE_INDEX          = NO
-ENUM_VALUES_PER_LINE   = 4
-GENERATE_TREEVIEW      = NO
-TREEVIEW_WIDTH         = 250
+SEARCHENGINE           = NO
 GENERATE_LATEX         = NO
-LATEX_OUTPUT           = latex
 LATEX_CMD_NAME         = latex
-MAKEINDEX_CMD_NAME     = makeindex
-COMPACT_LATEX          = NO
-PAPER_TYPE             = a4wide
-EXTRA_PACKAGES         = 
-LATEX_HEADER           = 
-PDF_HYPERLINKS         = YES
-USE_PDFLATEX           = YES
-LATEX_BATCHMODE        = NO
-LATEX_HIDE_INDICES     = NO
-GENERATE_RTF           = NO
-RTF_OUTPUT             = rtf
-COMPACT_RTF            = NO
-RTF_HYPERLINKS         = NO
-RTF_STYLESHEET_FILE    = 
-RTF_EXTENSIONS_FILE    = 
 GENERATE_MAN           = YES
-MAN_OUTPUT             = man
-MAN_EXTENSION          = .3
-MAN_LINKS              = NO
-GENERATE_XML           = NO
-XML_OUTPUT             = xml
-XML_SCHEMA             = 
-XML_DTD                = 
-XML_PROGRAMLISTING     = YES
-GENERATE_AUTOGEN_DEF   = NO
-GENERATE_PERLMOD       = NO
-PERLMOD_LATEX          = NO
-PERLMOD_PRETTY         = YES
-PERLMOD_MAKEVAR_PREFIX = 
-ENABLE_PREPROCESSING   = YES
-MACRO_EXPANSION        = NO
-EXPAND_ONLY_PREDEF     = NO
-SEARCH_INCLUDES        = YES
-INCLUDE_PATH           = 
-INCLUDE_FILE_PATTERNS  = 
-PREDEFINED             = 
-EXPAND_AS_DEFINED      = 
-SKIP_FUNCTION_MACROS   = YES
-TAGFILES               = 
-GENERATE_TAGFILE       = 
-ALLEXTERNALS           = NO
-EXTERNAL_GROUPS        = YES
-PERL_PATH              = /usr/bin/perl
-CLASS_DIAGRAMS         = YES
-MSCGEN_PATH            = 
-HIDE_UNDOC_RELATIONS   = YES
-HAVE_DOT               = YES
-CLASS_GRAPH            = YES
-COLLABORATION_GRAPH    = YES
-GROUP_GRAPHS           = YES
-UML_LOOK               = NO
-TEMPLATE_RELATIONS     = NO
-INCLUDE_GRAPH          = YES
-INCLUDED_BY_GRAPH      = YES
-CALL_GRAPH             = NO
-CALLER_GRAPH           = NO
-GRAPHICAL_HIERARCHY    = YES
-DIRECTORY_GRAPH        = YES
-DOT_IMAGE_FORMAT       = png
-DOT_PATH               = 
-DOTFILE_DIRS           = 
-DOT_GRAPH_MAX_NODES    = 50
-MAX_DOT_GRAPH_DEPTH    = 0
+HAVE_DOT               = @HAVE_DOT@
 DOT_TRANSPARENT        = YES
-DOT_MULTI_TARGETS      = NO
-GENERATE_LEGEND        = YES
-DOT_CLEANUP            = YES
-SEARCHENGINE           = NO
diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
new file mode 100644
index 0000000..e0598ab
--- /dev/null
+++ b/doxygen/Makefile.am
@@ -0,0 +1,75 @@
+if HAVE_DOXYGEN
+
+# Be sure to add new source files to this table
+doc_srcs = $(top_srcdir)/src/attr.c     \
+           $(top_srcdir)/src/callback.c \
+           $(top_srcdir)/src/nlmsg.c    \
+           $(top_srcdir)/src/socket.c
+
+doxyfile.stamp: $(doc_srcs) Makefile.am
+	rm -rf html man
+
+# Test for running under make distcheck.
+# If so, sibling src directory will be empty:
+# move it out of the way and symlink the real one while we run doxygen.
+	[ -f ../src/Makefile.in ] || \
+{ set -x; cd ..; mv src src.distcheck; ln -s $(top_srcdir)/src; }
+
+	cd ..; doxygen doxygen.cfg >/dev/null
+
+	[ ! -d ../src.distcheck ] || \
+{ set -x; cd ..; rm src; mv src.distcheck src; }
+
+# Keep this command up to date after adding new functions and source files.
+# The command has to be a single line so the functions work
+# (hence ";\" at the end of every line but the last).
+	main() { set -e; cd man/man3; rm -f _*;\
+setgroup attr mnl_attr_get_type;\
+  add2group mnl_attr_get_len mnl_attr_get_payload_len mnl_attr_get_payload;\
+  add2group mnl_attr_ok mnl_attr_next mnl_attr_type_valid mnl_attr_validate;\
+  add2group mnl_attr_validate2 mnl_attr_parse mnl_attr_parse_nested;\
+  add2group mnl_attr_parse_payload mnl_attr_get_u8 mnl_attr_get_u16;\
+  add2group mnl_attr_get_u32 mnl_attr_get_u64 mnl_attr_get_str mnl_attr_put;\
+  add2group mnl_attr_put_u8 mnl_attr_put_u16 mnl_attr_put_u32 mnl_attr_put_u64;\
+  add2group mnl_attr_put_str mnl_attr_put_strz mnl_attr_nest_start;\
+  add2group mnl_attr_put_check mnl_attr_put_u8_check mnl_attr_put_u16_check;\
+  add2group mnl_attr_put_u32_check mnl_attr_put_u64_check;\
+  add2group mnl_attr_put_str_check mnl_attr_put_strz_check;\
+  add2group mnl_attr_nest_start_check mnl_attr_nest_end mnl_attr_nest_cancel;\
+setgroup batch mnl_nlmsg_batch_start;\
+  add2group mnl_nlmsg_batch_stop mnl_nlmsg_batch_next mnl_nlmsg_batch_reset;\
+  add2group mnl_nlmsg_batch_size mnl_nlmsg_batch_head mnl_nlmsg_batch_current;\
+  add2group mnl_nlmsg_batch_is_empty;\
+setgroup callback mnl_cb_run;\
+  add2group mnl_cb_run2;\
+setgroup nlmsg mnl_nlmsg_size;\
+  add2group mnl_nlmsg_get_payload_len mnl_nlmsg_put_header;\
+  add2group mnl_nlmsg_put_extra_header mnl_nlmsg_get_payload;\
+  add2group mnl_nlmsg_get_payload_offset mnl_nlmsg_ok mnl_nlmsg_next;\
+  add2group mnl_nlmsg_get_payload_tail mnl_nlmsg_seq_ok mnl_nlmsg_portid_ok;\
+  add2group mnl_nlmsg_fprintf;\
+setgroup socket mnl_socket_get_fd;\
+  add2group mnl_socket_get_portid mnl_socket_open mnl_socket_open2;\
+  add2group mnl_socket_fdopen mnl_socket_bind mnl_socket_sendto;\
+  add2group mnl_socket_recvfrom mnl_socket_close mnl_socket_setsockopt;\
+  add2group mnl_socket_getsockopt;\
+};\
+setgroup() { mv $$1.3 $$2.3; BASE=$$2; };\
+add2group() { for i in $$@; do ln -sf $$BASE.3 $$i.3; done; };\
+main
+
+	touch doxyfile.stamp
+
+CLEANFILES = doxyfile.stamp
+
+all-local: doxyfile.stamp
+clean-local:
+	rm -rf $(top_srcdir)/doxygen/man $(top_srcdir)/doxygen/html
+install-data-local:
+	mkdir -p $(DESTDIR)$(mandir)/man3
+	cp --no-dereference --preserve=links,mode,timestamps man/man3/*.3 $(DESTDIR)$(mandir)/man3/
+
+# make distcheck needs uninstall-local
+uninstall-local:
+	rm -r $(DESTDIR)$(mandir) man html doxyfile.stamp
+endif
-- 
2.17.5

