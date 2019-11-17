Return-Path: <SRS0=RLGq=ZJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15570C432C0
	for <netfilter-devel@archiver.kernel.org>; Sun, 17 Nov 2019 02:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7E1C20730
	for <netfilter-devel@archiver.kernel.org>; Sun, 17 Nov 2019 02:35:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfKQCf7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 16 Nov 2019 21:35:59 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:32877 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725974AbfKQCf7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 16 Nov 2019 21:35:59 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id E70E93A0D1B
        for <netfilter-devel@vger.kernel.org>; Sun, 17 Nov 2019 13:35:42 +1100 (AEDT)
Received: (qmail 23374 invoked by uid 501); 17 Nov 2019 02:35:40 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v2] src: Fix IPv4 checksum calculation in AF_BRIDGE packet buffer
Date:   Sun, 17 Nov 2019 13:35:40 +1100
Message-Id: <20191117023540.23332-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20191116031834.13445-1-duncan_roe@optusnet.com.au>
References: <20191116031834.13445-1-duncan_roe@optusnet.com.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=MeAgGD-zjQ4A:10 a=RSmzAf-M6YYA:10
        a=PO7r1zJSAAAA:8 a=5MUvSgtflXIMSxYH55oA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Updated:

 src/extra/pktbuff.c: If pktb was created in family AF_BRIDGE, then pktb->len
                      will include the bytes in the network header.
                      So set the IPv4 length to "tail - network_header"
                      rather than len

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
v2: fix whitespace
 src/extra/ipv4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/extra/ipv4.c b/src/extra/ipv4.c
index 0227b62..c03f23f 100644
--- a/src/extra/ipv4.c
+++ b/src/extra/ipv4.c
@@ -117,7 +117,7 @@ int nfq_ip_mangle(struct pkt_buff *pktb, unsigned int dataoff,
 		return 0;
 
 	/* fix IP hdr checksum information */
-	iph->tot_len = htons(pktb->len);
+	iph->tot_len = htons(pktb->tail - pktb->network_header);
 	nfq_ip_set_checksum(iph);
 
 	return 1;
-- 
2.14.5

