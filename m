Return-Path: <SRS0=tkBW=2K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76CB3C2D0D2
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Dec 2019 05:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CA4E2467F
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Dec 2019 05:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbfLTFyF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Dec 2019 00:54:05 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:49258 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725825AbfLTFyF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Dec 2019 00:54:05 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id C3FBA3A0EAB
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Dec 2019 16:53:48 +1100 (AEDT)
Received: (qmail 24159 invoked by uid 501); 20 Dec 2019 05:53:48 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 1/2] src: more IPv6 checksum fixes
Date:   Fri, 20 Dec 2019 16:53:47 +1100
Message-Id: <20191220055348.24113-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20191220055348.24113-1-duncan_roe@optusnet.com.au>
References: <20191220055348.24113-1-duncan_roe@optusnet.com.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=pxVhFHJ0LMsA:10 a=RSmzAf-M6YYA:10
        a=PO7r1zJSAAAA:8 a=lGczooPpUTXbnT1JoLQA:9 a=3vHKc1QorotQFowq:21
        a=VnMiHPgbUbupJygL:21
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Updated:

 src/extra/checksum.c: - Fix calculation of header length
                       - Upgrade calculation of payload length: Allow for extra
                         headers before the UDP header
                       - Delete "sum += ... s6_addr16[i] >> 16" lines,
                         since uint16_t >> 16 == 0
                       - Use upgraded payload length in pseudo-header

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/extra/checksum.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/extra/checksum.c b/src/extra/checksum.c
index 42389aa..8b23997 100644
--- a/src/extra/checksum.c
+++ b/src/extra/checksum.c
@@ -62,21 +62,21 @@ uint16_t nfq_checksum_tcpudp_ipv6(struct ip6_hdr *ip6h, void *transport_hdr,
 				  uint16_t protonum)
 {
 	uint32_t sum = 0;
-	uint32_t hdr_len = (uint32_t *)transport_hdr - (uint32_t *)ip6h;
-	uint32_t len = ip6h->ip6_plen - hdr_len;
+	uint32_t hdr_len = (uint8_t *)transport_hdr - (uint8_t *)ip6h;
+	/* Allow for extra headers before the UDP header */
+	/* TODO: Deal with routing headers */
+	uint32_t len = ntohs(ip6h->ip6_plen) - (hdr_len - sizeof *ip6h);
 	uint8_t *payload = (uint8_t *)ip6h + hdr_len;
 	int i;
 
 	for (i=0; i<8; i++) {
-		sum += (ip6h->ip6_src.s6_addr16[i] >> 16) & 0xFFFF;
 		sum += (ip6h->ip6_src.s6_addr16[i]) & 0xFFFF;
 	}
 	for (i=0; i<8; i++) {
-		sum += (ip6h->ip6_dst.s6_addr16[i] >> 16) & 0xFFFF;
 		sum += (ip6h->ip6_dst.s6_addr16[i]) & 0xFFFF;
 	}
 	sum += htons(protonum);
-	sum += htons(ip6h->ip6_plen);
+	sum += htons(len);
 
 	return nfq_checksum(sum, (uint16_t *)payload, len);
 }
-- 
2.14.5

