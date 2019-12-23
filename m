Return-Path: <SRS0=tBJ8=2N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UPPERCASE_75_100,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E93C2D0D4
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Dec 2019 01:36:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46190206B7
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Dec 2019 01:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfLWBgY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Dec 2019 20:36:24 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55930 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726564AbfLWBgX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Dec 2019 20:36:23 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 5CF4F7E9A31
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Dec 2019 12:36:08 +1100 (AEDT)
Received: (qmail 26318 invoked by uid 501); 23 Dec 2019 01:36:07 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 1/2] doc: whitespace: Remove trailing spaces from doxygen.cfg.in
Date:   Mon, 23 Dec 2019 12:36:06 +1100
Message-Id: <20191223013607.26276-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=pxVhFHJ0LMsA:10 a=RSmzAf-M6YYA:10 a=PO7r1zJSAAAA:8
        a=Y9dxhgrXtT2TbNKEtagA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen.cfg.in | 68 +++++++++++++++++++++++++++++-----------------------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/doxygen.cfg.in b/doxygen.cfg.in
index 660fe60..b2a8c5f 100644
--- a/doxygen.cfg.in
+++ b/doxygen.cfg.in
@@ -6,12 +6,12 @@ CREATE_SUBDIRS         = NO
 OUTPUT_LANGUAGE        = English
 BRIEF_MEMBER_DESC      = YES
 REPEAT_BRIEF           = YES
-ABBREVIATE_BRIEF       = 
+ABBREVIATE_BRIEF       =
 ALWAYS_DETAILED_SEC    = NO
 INLINE_INHERITED_MEMB  = NO
 FULL_PATH_NAMES        = NO
-STRIP_FROM_PATH        = 
-STRIP_FROM_INC_PATH    = 
+STRIP_FROM_PATH        =
+STRIP_FROM_INC_PATH    =
 SHORT_NAMES            = NO
 JAVADOC_AUTOBRIEF      = NO
 QT_AUTOBRIEF           = NO
@@ -19,7 +19,7 @@ MULTILINE_CPP_IS_BRIEF = NO
 INHERIT_DOCS           = YES
 SEPARATE_MEMBER_PAGES  = NO
 TAB_SIZE               = 8
-ALIASES                = 
+ALIASES                =
 OPTIMIZE_OUTPUT_FOR_C  = YES
 OPTIMIZE_OUTPUT_JAVA   = NO
 OPTIMIZE_FOR_FORTRAN   = NO
@@ -53,32 +53,32 @@ GENERATE_TODOLIST      = YES
 GENERATE_TESTLIST      = YES
 GENERATE_BUGLIST       = YES
 GENERATE_DEPRECATEDLIST= YES
-ENABLED_SECTIONS       = 
+ENABLED_SECTIONS       =
 MAX_INITIALIZER_LINES  = 30
 SHOW_USED_FILES        = YES
 SHOW_DIRECTORIES       = NO
-FILE_VERSION_FILTER    = 
+FILE_VERSION_FILTER    =
 QUIET                  = NO
 WARNINGS               = YES
 WARN_IF_UNDOCUMENTED   = YES
 WARN_IF_DOC_ERROR      = YES
 WARN_NO_PARAMDOC       = NO
 WARN_FORMAT            = "$file:$line: $text"
-WARN_LOGFILE           = 
+WARN_LOGFILE           =
 INPUT                  = .
 INPUT_ENCODING         = UTF-8
 FILE_PATTERNS          = *.c
 RECURSIVE              = YES
-EXCLUDE                = 
+EXCLUDE                =
 EXCLUDE_SYMLINKS       = NO
-EXCLUDE_PATTERNS       = 
+EXCLUDE_PATTERNS       =
 EXCLUDE_SYMBOLS        = EXPORT_SYMBOL
-EXAMPLE_PATH           = 
-EXAMPLE_PATTERNS       = 
+EXAMPLE_PATH           =
+EXAMPLE_PATTERNS       =
 EXAMPLE_RECURSIVE      = NO
-IMAGE_PATH             = 
+IMAGE_PATH             =
 INPUT_FILTER           = "sed 's/EXPORT_SYMBOL//g'"
-FILTER_PATTERNS        = 
+FILTER_PATTERNS        =
 FILTER_SOURCE_FILES    = NO
 SOURCE_BROWSER         = YES
 INLINE_SOURCES         = NO
@@ -90,20 +90,20 @@ USE_HTAGS              = NO
 VERBATIM_HEADERS       = YES
 ALPHABETICAL_INDEX     = NO
 COLS_IN_ALPHA_INDEX    = 5
-IGNORE_PREFIX          = 
+IGNORE_PREFIX          =
 GENERATE_HTML          = YES
 HTML_OUTPUT            = html
 HTML_FILE_EXTENSION    = .html
-HTML_HEADER            = 
-HTML_STYLESHEET        = 
+HTML_HEADER            =
+HTML_STYLESHEET        =
 HTML_ALIGN_MEMBERS     = YES
 GENERATE_HTMLHELP      = NO
 GENERATE_DOCSET        = NO
 DOCSET_FEEDNAME        = "Doxygen generated docs"
 DOCSET_BUNDLE_ID       = org.doxygen.Project
 HTML_DYNAMIC_SECTIONS  = NO
-CHM_FILE               = 
-HHC_LOCATION           = 
+CHM_FILE               =
+HHC_LOCATION           =
 GENERATE_CHI           = NO
 BINARY_TOC             = NO
 TOC_EXPAND             = NO
@@ -117,8 +117,8 @@ LATEX_CMD_NAME         = latex
 MAKEINDEX_CMD_NAME     = makeindex
 COMPACT_LATEX          = NO
 PAPER_TYPE             = a4wide
-EXTRA_PACKAGES         = 
-LATEX_HEADER           = 
+EXTRA_PACKAGES         =
+LATEX_HEADER           =
 PDF_HYPERLINKS         = YES
 USE_PDFLATEX           = YES
 LATEX_BATCHMODE        = NO
@@ -127,38 +127,38 @@ GENERATE_RTF           = NO
 RTF_OUTPUT             = rtf
 COMPACT_RTF            = NO
 RTF_HYPERLINKS         = NO
-RTF_STYLESHEET_FILE    = 
-RTF_EXTENSIONS_FILE    = 
+RTF_STYLESHEET_FILE    =
+RTF_EXTENSIONS_FILE    =
 GENERATE_MAN           = YES
 MAN_OUTPUT             = man
 MAN_EXTENSION          = .3
 MAN_LINKS              = NO
 GENERATE_XML           = NO
 XML_OUTPUT             = xml
-XML_SCHEMA             = 
-XML_DTD                = 
+XML_SCHEMA             =
+XML_DTD                =
 XML_PROGRAMLISTING     = YES
 GENERATE_AUTOGEN_DEF   = NO
 GENERATE_PERLMOD       = NO
 PERLMOD_LATEX          = NO
 PERLMOD_PRETTY         = YES
-PERLMOD_MAKEVAR_PREFIX = 
+PERLMOD_MAKEVAR_PREFIX =
 ENABLE_PREPROCESSING   = YES
 MACRO_EXPANSION        = NO
 EXPAND_ONLY_PREDEF     = NO
 SEARCH_INCLUDES        = YES
-INCLUDE_PATH           = 
-INCLUDE_FILE_PATTERNS  = 
-PREDEFINED             = 
-EXPAND_AS_DEFINED      = 
+INCLUDE_PATH           =
+INCLUDE_FILE_PATTERNS  =
+PREDEFINED             =
+EXPAND_AS_DEFINED      =
 SKIP_FUNCTION_MACROS   = YES
-TAGFILES               = 
-GENERATE_TAGFILE       = 
+TAGFILES               =
+GENERATE_TAGFILE       =
 ALLEXTERNALS           = NO
 EXTERNAL_GROUPS        = YES
 PERL_PATH              = /usr/bin/perl
 CLASS_DIAGRAMS         = YES
-MSCGEN_PATH            = 
+MSCGEN_PATH            =
 HIDE_UNDOC_RELATIONS   = YES
 HAVE_DOT               = YES
 CLASS_GRAPH            = YES
@@ -173,8 +173,8 @@ CALLER_GRAPH           = NO
 GRAPHICAL_HIERARCHY    = YES
 DIRECTORY_GRAPH        = YES
 DOT_IMAGE_FORMAT       = png
-DOT_PATH               = 
-DOTFILE_DIRS           = 
+DOT_PATH               =
+DOTFILE_DIRS           =
 DOT_GRAPH_MAX_NODES    = 50
 MAX_DOT_GRAPH_DEPTH    = 0
 DOT_TRANSPARENT        = YES
-- 
2.14.5

