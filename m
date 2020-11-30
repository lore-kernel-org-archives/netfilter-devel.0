Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE57C64E7B
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Nov 2020 13:06:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D1C721D7A
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Nov 2020 13:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgK3NGC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Nov 2020 08:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgK3NGC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Nov 2020 08:06:02 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDB1C0613D2
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Nov 2020 05:05:21 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 65534)
        id 83A9359BD6197; Mon, 30 Nov 2020 14:05:20 +0100 (CET)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id DED1F59BD6194;
        Mon, 30 Nov 2020 14:05:19 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 1/2] build: choose right automake variables
Date:   Mon, 30 Nov 2020 14:05:18 +0100
Message-Id: <20201130130519.20880-1-jengelh@inai.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

-l is a library selection, needs to go into _LDADD/_LIBADD.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 examples/Makefile.am | 4 ++--
 src/Makefile.am      | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git examples/Makefile.am examples/Makefile.am
index 1906697..97bb70c 100644
--- examples/Makefile.am
+++ examples/Makefile.am
@@ -3,5 +3,5 @@ include ${top_srcdir}/Make_global.am
 check_PROGRAMS = nf-queue
 
 nf_queue_SOURCES = nf-queue.c
-nf_queue_LDADD = ../src/libnetfilter_queue.la
-nf_queue_LDFLAGS = -dynamic -lmnl
+nf_queue_LDADD = ../src/libnetfilter_queue.la -lmnl
+nf_queue_LDFLAGS = -dynamic
diff --git src/Makefile.am src/Makefile.am
index ab2a151..8cede12 100644
--- src/Makefile.am
+++ src/Makefile.am
@@ -26,7 +26,7 @@ lib_LTLIBRARIES = libnetfilter_queue.la
 
 noinst_HEADERS = internal.h
 
-libnetfilter_queue_la_LDFLAGS = -Wc,-nostartfiles -lnfnetlink \
+libnetfilter_queue_la_LDFLAGS = -Wc,-nostartfiles \
 				-version-info $(LIBVERSION)
 libnetfilter_queue_la_SOURCES = libnetfilter_queue.c	\
 				nlmsg.c			\
-- 
2.29.2

