Return-Path: <SRS0=EbRH=2B=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7301BC43603
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Dec 2019 22:37:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45F0C20836
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Dec 2019 22:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfLKWhh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Dec 2019 17:37:37 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:51816 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726494AbfLKWhg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Dec 2019 17:37:36 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id A550F7E9D4E
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Dec 2019 09:37:20 +1100 (AEDT)
Received: (qmail 30112 invoked by uid 501); 11 Dec 2019 22:37:19 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 1/2] src: doc: udp.c: rename 1 more formal pkt arg to pktb
Date:   Thu, 12 Dec 2019 09:37:18 +1100
Message-Id: <20191211223719.30070-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=pxVhFHJ0LMsA:10 a=RSmzAf-M6YYA:10 a=PO7r1zJSAAAA:8
        a=LGa6rJJ3HznHUMj1z0EA:9 a=QtVhIzdZYSVbvH6N6Mh2:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/extra/udp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/extra/udp.c b/src/extra/udp.c
index eb301f2..faef19b 100644
--- a/src/extra/udp.c
+++ b/src/extra/udp.c
@@ -130,19 +130,19 @@ void nfq_udp_compute_checksum_ipv6(struct udphdr *udph, struct ip6_hdr *ip6h)
  * checksums for you.
  */
 EXPORT_SYMBOL
-int nfq_udp_mangle_ipv4(struct pkt_buff *pkt,
+int nfq_udp_mangle_ipv4(struct pkt_buff *pktb,
 			unsigned int match_offset, unsigned int match_len,
 			const char *rep_buffer, unsigned int rep_len)
 {
 	struct iphdr *iph;
 	struct udphdr *udph;
 
-	iph = (struct iphdr *)pkt->network_header;
-	udph = (struct udphdr *)(pkt->network_header + iph->ihl*4);
+	iph = (struct iphdr *)pktb->network_header;
+	udph = (struct udphdr *)(pktb->network_header + iph->ihl*4);
 
 	udph->len = htons(ntohs(udph->len) + rep_len - match_len);
 
-	if (!nfq_ip_mangle(pkt, iph->ihl*4 + sizeof(struct udphdr),
+	if (!nfq_ip_mangle(pktb, iph->ihl*4 + sizeof(struct udphdr),
 				match_offset, match_len, rep_buffer, rep_len))
 		return 0;
 
-- 
2.14.5

