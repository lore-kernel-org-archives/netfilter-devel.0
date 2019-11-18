Return-Path: <SRS0=asLr=ZK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF27C432C3
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Nov 2019 03:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D37AD206B6
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Nov 2019 03:36:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfKRDg4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 17 Nov 2019 22:36:56 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:57585 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726345AbfKRDg4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 17 Nov 2019 22:36:56 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id CC8887E954A
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Nov 2019 14:36:39 +1100 (AEDT)
Received: (qmail 26518 invoked by uid 501); 18 Nov 2019 03:36:38 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 2/2] Minor tweak to pktb_len function description
Date:   Mon, 18 Nov 2019 14:36:38 +1100
Message-Id: <20191118033638.26472-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20191118033638.26472-1-duncan_roe@optusnet.com.au>
References: <20191118033638.26472-1-duncan_roe@optusnet.com.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=G6BsK5s5 c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=MeAgGD-zjQ4A:10 a=RSmzAf-M6YYA:10
        a=PO7r1zJSAAAA:8 a=WZLFqVhQHYXB1mON-jIA:9 a=mK7HoAy08T6YxbGK:21
        a=HKiU--5TG3Z0cFr8:21
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/extra/pktbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
index 26d7ca8..c4f3da3 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -111,7 +111,7 @@ uint8_t *pktb_data(struct pkt_buff *pktb)
 }
 
 /**
- * pktb_len - return length of the packet buffer
+ * pktb_len - get length of packet buffer
  * \param pktb Pointer to userspace packet buffer
  * \return Length of packet contained within __pktb__
  * \par
-- 
2.14.5

