Return-Path: <SRS0=ntVu=Z7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A773C43603
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 23:53:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5720A20721
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 23:53:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfLIXxJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Dec 2019 18:53:09 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:60151 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727437AbfLIXxJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Dec 2019 18:53:09 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 164D17EB58F
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Dec 2019 10:52:56 +1100 (AEDT)
Received: (qmail 5732 invoked by uid 501); 9 Dec 2019 23:52:55 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] src: Fix value returned by nfq_udp_get_payload_len()
Date:   Tue, 10 Dec 2019 10:52:55 +1100
Message-Id: <20191209235255.5688-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20191209211204.gejs3uz2lc7nbjra@salvia>
References: <20191209211204.gejs3uz2lc7nbjra@salvia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=pxVhFHJ0LMsA:10 a=RSmzAf-M6YYA:10
        a=PO7r1zJSAAAA:8 a=r1guFdXvGmP_6AwhMRoA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Updated:

 src/extra/udp.c: Remember to subtract the UDP header length

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/extra/udp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/extra/udp.c b/src/extra/udp.c
index fed23e2..eb301f2 100644
--- a/src/extra/udp.c
+++ b/src/extra/udp.c
@@ -78,7 +78,7 @@ void *nfq_udp_get_payload(struct udphdr *udph, struct pkt_buff *pktb)
 EXPORT_SYMBOL
 unsigned int nfq_udp_get_payload_len(struct udphdr *udph, struct pkt_buff *pktb)
 {
-	return pktb->tail - pktb->transport_header;
+	return pktb->tail - pktb->transport_header - sizeof(struct udphdr);
 }
 
 /**
-- 
2.14.5

