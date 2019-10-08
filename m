Return-Path: <SRS0=bnKo=YB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5A3AECE58E
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Oct 2019 00:50:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C621621479
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Oct 2019 00:50:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729733AbfJHAuC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Oct 2019 20:50:02 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:38566 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729708AbfJHAuC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Oct 2019 20:50:02 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id B9B623627D2
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Oct 2019 11:49:49 +1100 (AEDT)
Received: (qmail 25684 invoked by uid 501); 8 Oct 2019 00:49:48 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnetfilter_queue 3/5] doxygen: remove EXPORT_SYMBOL from the output
Date:   Tue,  8 Oct 2019 11:49:46 +1100
Message-Id: <20191008004948.25632-4-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20191008004948.25632-1-duncan_roe@optusnet.com.au>
References: <20191008004948.25632-1-duncan_roe@optusnet.com.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=XobE76Q3jBoA:10 a=3HDBlxybAAAA:8
        a=PO7r1zJSAAAA:8 a=bo1wLXsgliSv8NlJ1GUA:9 a=laEoCiVfU_Unz3mSdgXN:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

Add input filter to remove the internal EXPORT_SYMBOL macro that turns
on the compiler visibility attribute.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen.cfg.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doxygen.cfg.in b/doxygen.cfg.in
index a7378ca..660fe60 100644
--- a/doxygen.cfg.in
+++ b/doxygen.cfg.in
@@ -77,7 +77,7 @@ EXAMPLE_PATH           =
 EXAMPLE_PATTERNS       = 
 EXAMPLE_RECURSIVE      = NO
 IMAGE_PATH             = 
-INPUT_FILTER           = 
+INPUT_FILTER           = "sed 's/EXPORT_SYMBOL//g'"
 FILTER_PATTERNS        = 
 FILTER_SOURCE_FILES    = NO
 SOURCE_BROWSER         = YES
-- 
2.14.5

