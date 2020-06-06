Return-Path: <SRS0=pZFI=7T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A439C433E0
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Jun 2020 05:25:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 633D02064C
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Jun 2020 05:25:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgFFFZR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Jun 2020 01:25:17 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:43348 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726157AbgFFFZQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Jun 2020 01:25:16 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail108.syd.optusnet.com.au (Postfix) with SMTP id 51B5A1A7F01
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Jun 2020 15:25:14 +1000 (AEST)
Received: (qmail 27469 invoked by uid 501); 6 Jun 2020 05:25:10 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     fw@strlen.de, pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 1/1] build: dist: Add fixmanpages.sh to distribution tree
Date:   Sat,  6 Jun 2020 15:25:10 +1000
Message-Id: <20200606052510.27423-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200606052510.27423-1-duncan_roe@optusnet.com.au>
References: <20200606052510.27423-1-duncan_roe@optusnet.com.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=nTHF0DUjJn0A:10 a=RSmzAf-M6YYA:10 a=PO7r1zJSAAAA:8
        a=YQ7Q6Yom_H_-2F9t53gA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Tested by running Slackware package builder on libnetfilter_queue-1.0.4.tar.bz2
created by 'make dist' after applying the patch. Works now, failed before.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 Makefile.am | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile.am b/Makefile.am
index a5b347b..796f0d0 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -10,3 +10,4 @@ pkgconfigdir = $(libdir)/pkgconfig
 pkgconfig_DATA = libnetfilter_queue.pc
 
 EXTRA_DIST += Make_global.am
+EXTRA_DIST += fixmanpages.sh
-- 
2.14.5

