Return-Path: <SRS0=+R7G=3E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2583C33CB1
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jan 2020 07:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9378214AF
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jan 2020 07:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbgAOHw0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Jan 2020 02:52:26 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:37166 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726088AbgAOHw0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Jan 2020 02:52:26 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id F3E917EB266
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jan 2020 18:52:04 +1100 (AEDT)
Received: (qmail 18585 invoked by uid 501); 15 Jan 2020 07:52:03 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] src: Fix indenting weirdness is pktbuff.c w/out changing indent
Date:   Wed, 15 Jan 2020 18:52:03 +1100
Message-Id: <20200115075203.18538-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=Jdjhy38mL1oA:10 a=RSmzAf-M6YYA:10 a=PO7r1zJSAAAA:8
        a=Z29m_iOhgQRVFZOTsBsA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In  pktb_alloc, declare struct ethhdr *ethhdr at function start,
thus avoiding cute braces on case AF_BRIDGE.
This costs nothing and generates less code.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/extra/pktbuff.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
index 37f6bc0..b7d379e 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -53,6 +53,7 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
 {
 	struct pkt_buff *pktb;
 	void *pkt_data;
+	struct ethhdr *ethhdr;
 
 	pktb = calloc(1, sizeof(struct pkt_buff) + len + extra);
 	if (pktb == NULL)
@@ -74,9 +75,8 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
 	case AF_INET6:
 		pktb->network_header = pktb->data;
 		break;
-	case AF_BRIDGE: {
-		struct ethhdr *ethhdr = (struct ethhdr *)pktb->data;
-
+	case AF_BRIDGE:
+		ethhdr = (struct ethhdr *)pktb->data;
 		pktb->mac_header = pktb->data;
 
 		switch(ethhdr->h_proto) {
@@ -92,7 +92,6 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
 		}
 		break;
 	}
-	}
 	return pktb;
 }
 
-- 
2.14.5

