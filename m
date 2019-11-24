Return-Path: <SRS0=BgG3=ZQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 445CEC432C0
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Nov 2019 02:33:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 196D420706
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Nov 2019 02:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfKXCdY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 Nov 2019 21:33:24 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46924 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726676AbfKXCdY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Nov 2019 21:33:24 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id BCA0C7E9126
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Nov 2019 13:33:11 +1100 (AEDT)
Received: (qmail 18242 invoked by uid 501); 24 Nov 2019 02:33:10 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] src: Fix test for IPv6 header
Date:   Sun, 24 Nov 2019 13:33:10 +1100
Message-Id: <20191124023310.18200-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=G6BsK5s5 c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=MeAgGD-zjQ4A:10 a=RSmzAf-M6YYA:10 a=PO7r1zJSAAAA:8
        a=-9mr4hxqB4bSUj-R2EYA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Updated:

 src/extra/ipv6.c: Only test the first 4 bits of the putative IPv6 header to be
                   6, since all the other bits are up for grabs.
                   (I have seen nonzero Flow Control on the local interface and
                   RFC2474 & RFC3168 document Traffic Class use).

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/extra/ipv6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/extra/ipv6.c b/src/extra/ipv6.c
index af307d6..f685b3b 100644
--- a/src/extra/ipv6.c
+++ b/src/extra/ipv6.c
@@ -45,7 +45,7 @@ struct ip6_hdr *nfq_ip6_get_hdr(struct pkt_buff *pktb)
 	ip6h = (struct ip6_hdr *)pktb->network_header;
 
 	/* Not IPv6 packet. */
-	if (ip6h->ip6_flow != 0x60)
+	if ((*(uint8_t *)ip6h & 0xf0) != 0x60)
 		return NULL;
 
 	return ip6h;
-- 
2.14.5

