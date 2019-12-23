Return-Path: <SRS0=tBJ8=2N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UPPERCASE_50_75,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94719C2D0C8
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Dec 2019 01:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FE4E206B7
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Dec 2019 01:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfLWBgX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Dec 2019 20:36:23 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:38205 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726604AbfLWBgW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Dec 2019 20:36:22 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 6C76C3A2443
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Dec 2019 12:36:08 +1100 (AEDT)
Received: (qmail 26322 invoked by uid 501); 23 Dec 2019 01:36:07 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 2/2] doc: doxygen.cfg.in: Eliminate 20 doxygen warnings
Date:   Mon, 23 Dec 2019 12:36:07 +1100
Message-Id: <20191223013607.26276-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20191223013607.26276-1-duncan_roe@optusnet.com.au>
References: <20191223013607.26276-1-duncan_roe@optusnet.com.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=pxVhFHJ0LMsA:10 a=RSmzAf-M6YYA:10
        a=PO7r1zJSAAAA:8 a=82UjKu56oGJD9LqawU0A:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

- Add 5 opaque or internal items to the EXCLUDE_SYMBOLS list
- Remove 4 obsolete configuration lines

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen.cfg.in | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/doxygen.cfg.in b/doxygen.cfg.in
index b2a8c5f..648c4e6 100644
--- a/doxygen.cfg.in
+++ b/doxygen.cfg.in
@@ -56,7 +56,6 @@ GENERATE_DEPRECATEDLIST= YES
 ENABLED_SECTIONS       =
 MAX_INITIALIZER_LINES  = 30
 SHOW_USED_FILES        = YES
-SHOW_DIRECTORIES       = NO
 FILE_VERSION_FILTER    =
 QUIET                  = NO
 WARNINGS               = YES
@@ -72,7 +71,12 @@ RECURSIVE              = YES
 EXCLUDE                =
 EXCLUDE_SYMLINKS       = NO
 EXCLUDE_PATTERNS       =
-EXCLUDE_SYMBOLS        = EXPORT_SYMBOL
+EXCLUDE_SYMBOLS        = EXPORT_SYMBOL \
+                         tcp_word_hdr \
+                         nfq_handle \
+                         nfq_data \
+                         nfq_q_handle\
+                         tcp_flag_word
 EXAMPLE_PATH           =
 EXAMPLE_PATTERNS       =
 EXAMPLE_RECURSIVE      = NO
@@ -96,7 +100,6 @@ HTML_OUTPUT            = html
 HTML_FILE_EXTENSION    = .html
 HTML_HEADER            =
 HTML_STYLESHEET        =
-HTML_ALIGN_MEMBERS     = YES
 GENERATE_HTMLHELP      = NO
 GENERATE_DOCSET        = NO
 DOCSET_FEEDNAME        = "Doxygen generated docs"
@@ -135,8 +138,6 @@ MAN_EXTENSION          = .3
 MAN_LINKS              = NO
 GENERATE_XML           = NO
 XML_OUTPUT             = xml
-XML_SCHEMA             =
-XML_DTD                =
 XML_PROGRAMLISTING     = YES
 GENERATE_AUTOGEN_DEF   = NO
 GENERATE_PERLMOD       = NO
-- 
2.14.5

