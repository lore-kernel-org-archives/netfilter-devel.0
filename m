Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UPPERCASE_75_100,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65286C43214
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Aug 2021 08:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4782360F3A
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Aug 2021 08:02:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240149AbhHaIDJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Aug 2021 04:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240126AbhHaIDF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Aug 2021 04:03:05 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF9AC06175F
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Aug 2021 01:02:10 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id z24-20020a17090acb1800b0018e87a24300so1818622pjt.0
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Aug 2021 01:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xblNGkWUs6hmDtB2PTBXARK8muRA2HKuoF2e+2UcP9g=;
        b=pqzxw8fIVQ8NmLeJ5LaGkCRPF6FiqDOgQQLjZ3nW9b1dRlCgv/0BSQieSr/HyKGm0B
         Qyv326V5SqhnDvXknJgH9F05+26VluS7sgASqYrH4qSR31nfojqsI4VAPSzZaqS9Z+9Q
         BTm+jsxwPSiXsdYIqB3L58V0mFLbaAMfzlYwcdMsuj62Q5CCHRDIIQGZasuTZ9eylvQ3
         Hlyzgqp1qB1L2zMKpl6kDyFveHU7VO+jQn8WZ01M2SgJ92kimLJBSlaMFq3G5LDU/FZh
         giisk4yPKu1dBjzyAZoXkyjjPxY3WWYkgzOQLzBQTRayU7sTMSRczsjmehPLPSEWVhV2
         LN2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=xblNGkWUs6hmDtB2PTBXARK8muRA2HKuoF2e+2UcP9g=;
        b=qw/fyHgsgXR40PejGWHkg9KbNhx2hzt+RNfFq/g5XByOJGtMH7E6B+cAqfxT8diF08
         XndNKa/U3a9Wi68nqiwlfNJ0MdgAbBZw/2edU/nP4U5hwvUS/8m+PCQmCtxACgAeVD9x
         uOiiN9cCgHwypp20jjfadyJ99gejoehSJlNlhTVELNHwdjZoIy0NQC2pX9eocwXYMeyD
         WKu17ihZn8361nPM2yV26Ushaiz+md04UE1steCnALiNu9Sjvzgw/h2epCaHTCFARhrq
         aeNRM+Hj7pVtuTl6/Nh1sx+0BXNB6k4LXwtHqvN4FlAX28DVIX5j+vrltACufiPascBG
         +org==
X-Gm-Message-State: AOAM530qbDECe0jYpG7QKCuAuE4Kf4Wn038VihbGO8AZRJcVu49Lt34d
        hkGIkgHJnqnJ6di3boTuXOUvOxqUh6A=
X-Google-Smtp-Source: ABdhPJw5BB6X0eREp1Z8BK9qB3vkCCd4G1oeFxq1JnnKKjm+J/C6hPxFIDTteNm9xuFeLuq3oD9Zmw==
X-Received: by 2002:a17:903:3014:b0:130:f1c8:bb02 with SMTP id o20-20020a170903301400b00130f1c8bb02mr3549138pla.53.1630396930478;
        Tue, 31 Aug 2021 01:02:10 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id r2sm1459047pgn.8.2021.08.31.01.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 01:02:09 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_log 2/3] build: doc: reduce doxygen.cfg.in to non-default entries only
Date:   Tue, 31 Aug 2021 18:01:59 +1000
Message-Id: <20210831080200.19566-3-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210831080200.19566-1-duncan_roe@optusnet.com.au>
References: <20210831080200.19566-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Also add EXCLUDE_SYMBOLS for structs that are undocumented (otherwise
doxygen makes html pages for them but warns they and their members are not
documented).

This formerly 5KB file is reduced almost down to 1/8th original size.

In the interests of a clean diff, the new file still has lines with trailing
spaces.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen.cfg.in | 170 ++-----------------------------------------------
 1 file changed, 5 insertions(+), 165 deletions(-)

diff --git a/doxygen.cfg.in b/doxygen.cfg.in
index 37bfa7c..b4bd3a7 100644
--- a/doxygen.cfg.in
+++ b/doxygen.cfg.in
@@ -1,184 +1,24 @@
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
 FILE_PATTERNS          = *.c
 RECURSIVE              = YES
-EXCLUDE                = 
-EXCLUDE_SYMLINKS       = NO
-EXCLUDE_PATTERNS       = 
-EXCLUDE_SYMBOLS        = 
-EXAMPLE_PATH           = 
+EXCLUDE_SYMBOLS        = nflog_g_handle \
+			 nflog_handle \
+			 ipulog_errmap_t \
+			 ipulog_handle
 EXAMPLE_PATTERNS       = 
-EXAMPLE_RECURSIVE      = NO
-IMAGE_PATH             = 
-INPUT_FILTER           = 
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
 HAVE_DOT               = YES
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
 SEARCHENGINE           = NO
-- 
2.17.5

