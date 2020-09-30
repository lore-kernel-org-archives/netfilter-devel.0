Return-Path: <SRS0=6DLs=DH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2109DC4727F
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Sep 2020 05:18:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5E462075F
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Sep 2020 05:18:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgI3FSE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Sep 2020 01:18:04 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:52394 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725306AbgI3FSE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Sep 2020 01:18:04 -0400
Received: from dimstar.local.net (n49-192-70-185.sun3.vic.optusnet.com.au [49.192.70.185])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id ECBC83ABE41
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Sep 2020 14:46:04 +1000 (AEST)
Received: (qmail 11151 invoked by uid 501); 30 Sep 2020 04:46:03 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, dunc@dimstar.local.net
Subject: [PATCH libnetfilter_queue] doc: build: Reduce size of doxygen.cfg and doxygen build o/p
Date:   Wed, 30 Sep 2020 14:46:03 +1000
Message-Id: <20200930044603.11109-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.17.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=zRnOCfNoldqEzXEIOSrMkw==:117 a=zRnOCfNoldqEzXEIOSrMkw==:17
        a=reM5J-MqmosA:10 a=RSmzAf-M6YYA:10 a=PO7r1zJSAAAA:8
        a=03uqnuHKltvE6X5U11kA:9
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

doxygen.cfg only needs to contain non-default options.
Removing other options shaves 4KB (off a 5KB file).
Also remove options that are obsolete at the latest doxygen release:
 PERL_PATH, MSCGEN_PATH and PAPER_TYPE=a4wide (defaults to a4).

While being about it, send doxygen stdout to /dev/null to make (future)
warnings easier to see.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen.cfg.in      | 162 +-------------------------------------------
 doxygen/Makefile.am |   2 +-
 2 files changed, 3 insertions(+), 161 deletions(-)

diff --git a/doxygen.cfg.in b/doxygen.cfg.in
index c54f534..4c16e3e 100644
--- a/doxygen.cfg.in
+++ b/doxygen.cfg.in
@@ -1,185 +1,27 @@
-DOXYFILE_ENCODING      = UTF-8
+# Difference with default Doxyfile 1.8.20
 PROJECT_NAME           = @PACKAGE@
 PROJECT_NUMBER         = @VERSION@
 OUTPUT_DIRECTORY       = doxygen
-CREATE_SUBDIRS         = NO
-OUTPUT_LANGUAGE        = English
-BRIEF_MEMBER_DESC      = YES
-REPEAT_BRIEF           = YES
 ABBREVIATE_BRIEF       =
-ALWAYS_DETAILED_SEC    = NO
-INLINE_INHERITED_MEMB  = NO
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
 FILE_PATTERNS          = *.c
 RECURSIVE              = YES
-EXCLUDE                =
-EXCLUDE_SYMLINKS       = NO
-EXCLUDE_PATTERNS       =
 EXCLUDE_SYMBOLS        = EXPORT_SYMBOL \
                          tcp_word_hdr \
                          nfq_handle \
                          nfq_data \
                          nfq_q_handle \
                          tcp_flag_word
-EXAMPLE_PATH           =
 EXAMPLE_PATTERNS       =
-EXAMPLE_RECURSIVE      = NO
-IMAGE_PATH             =
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
 HAVE_DOT               = @HAVE_DOT@
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
 DOT_TRANSPARENT        = YES
-DOT_MULTI_TARGETS      = NO
-GENERATE_LEGEND        = YES
-DOT_CLEANUP            = YES
-SEARCHENGINE           = NO
diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index ef468e0..58d153f 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -9,7 +9,7 @@ doc_srcs = $(top_srcdir)/src/libnetfilter_queue.c  \
            $(top_srcdir)/src/extra/pktbuff.c
 
 doxyfile.stamp: $(doc_srcs) $(top_srcdir)/fixmanpages.sh
-	rm -rf html man && cd .. && doxygen doxygen.cfg && ./fixmanpages.sh
+	rm -rf html man && cd .. && doxygen doxygen.cfg >/dev/null && ./fixmanpages.sh
 	touch doxyfile.stamp
 
 CLEANFILES = doxyfile.stamp
-- 
2.17.5

