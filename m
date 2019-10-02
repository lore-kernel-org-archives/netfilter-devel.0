Return-Path: <SRS0=1WdE=X3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA42DC35280
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Oct 2019 06:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80702215EA
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Oct 2019 06:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfJBGtI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Oct 2019 02:49:08 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38943 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725860AbfJBGtI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Oct 2019 02:49:08 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 9897B43EB03
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Oct 2019 16:48:49 +1000 (AEST)
Received: (qmail 30751 invoked by uid 501); 2 Oct 2019 06:48:48 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] Fix a missing doxygen section trailer in nlmsg.c
Date:   Wed,  2 Oct 2019 16:48:48 +1000
Message-Id: <20191002064848.30620-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=XobE76Q3jBoA:10 a=aBizlib_ZF6BrrbkkwIA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This corrects an oddity in the web doco (and presumably in the man pages as
well) whereby "Netlink message batch helpers" was showing up as a sub-topic of
"Netlink message helpers".

This was included in my original (rejected) patch "Enable doxygen to generate
Function Documentation" with a comment "(didn't think it warrantied an extra
patch)" - clearly wrong
---
 src/nlmsg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/nlmsg.c b/src/nlmsg.c
index fb99135..d398e63 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -370,6 +370,10 @@ EXPORT_SYMBOL void mnl_nlmsg_fprintf(FILE *fd, const void *data, size_t datalen,
 	}
 }
 
+/**
+ * @}
+ */
+
 /**
  * \defgroup batch Netlink message batch helpers
  *
-- 
2.14.5

