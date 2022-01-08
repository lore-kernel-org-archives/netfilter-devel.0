Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2473C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  8 Jan 2022 07:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233740AbiAHHcs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 8 Jan 2022 02:32:48 -0500
Received: from a27-189.smtp-out.us-west-2.amazonses.com ([54.240.27.189]:40399
        "EHLO a27-189.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233661AbiAHHcs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Jan 2022 02:32:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hnpv7wyf3seapxrj4k4fhpgkc6n7n3bh; d=aaront.org; t=1641627167;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Transfer-Encoding;
        bh=VbRgAUYbM1wnPkTPNvFyZ08lSRGtZLnPrdXGyjqu9ug=;
        b=GX2nnJNRJSYj2bPAH55aktGPKFhfSwYsv1zLCsJjhghixr74PlcmC8+IN9cKxXoO
        sQw756DCwuEOcWize86Qyi2a7Y7JLFuhfb3/3ROpSOz7RA/uFU13nPtYvNlmRJQxlz+
        Gf4KUJa0gNuX3IhaVwvOKUa5u+0sYfYKYW8zfLnU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=7v7vs6w47njt4pimodk5mmttbegzsi6n; d=amazonses.com; t=1641627167;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Transfer-Encoding:Feedback-ID;
        bh=VbRgAUYbM1wnPkTPNvFyZ08lSRGtZLnPrdXGyjqu9ug=;
        b=DZkQ4eMthPfb5fn/L/l9+H44B+A+wIgQm7dC3RvHeU6f4nZDz53WVwps6aEjgm+U
        UrViKwEl2Dr81cS2bR19p+C0a8AqGT0eguQWtEl034M0Sxd43+yqSAhGI6U2hDLflqQ
        4zLqd1snWVJFTtEioGXPNZA0nSCS+O+SlIPiqRRU=
From:   Aaron Thompson <dev@aaront.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Aaron Thompson <dev@aaront.org>
Subject: [conntrack-tools PATCH] conntrackd: cthelper: ssdp: Fix parsing of IPv6 M-SEARCH requests.
Date:   Sat, 8 Jan 2022 07:32:47 +0000
Message-ID: <0101017e389aaaf3-3e2018c8-b439-403f-ba4c-0900581f733c-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Feedback-ID: 1.us-west-2.OwdjDcIoZWY+bZWuVZYzryiuW455iyNkDEZFeL97Dng=:AmazonSES
X-SES-Outgoing: 2022.01.08-54.240.27.189
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use the already correctly determined transport header offset instead of
assuming that the packet is IPv4.

Signed-off-by: Aaron Thompson <dev@aaront.org>
---
 src/helpers/ssdp.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/src/helpers/ssdp.c b/src/helpers/ssdp.c
index 56526f4..0c6f563 100644
--- a/src/helpers/ssdp.c
+++ b/src/helpers/ssdp.c
@@ -48,7 +48,6 @@
 #include <errno.h>
 #include <stdlib.h>
 #include <arpa/inet.h>
-#include <netinet/ip.h>
 #define _GNU_SOURCE
 #include <netinet/tcp.h>
 #include <netinet/udp.h>
@@ -159,11 +158,9 @@ static int handle_ssdp_new(struct pkt_buff *pkt, uint32_t protoff,
 {
 	int ret = NF_ACCEPT;
 	union nfct_attr_grp_addr daddr, saddr, taddr;
-	struct iphdr *net_hdr = (struct iphdr *)pktb_network_header(pkt);
 	int good_packet = 0;
 	struct nf_expect *exp;
 	uint16_t port;
-	unsigned int dataoff;
 	void *sb_ptr;
 
 	cthelper_get_addr_dst(myct->ct, MYCT_DIR_ORIG, &daddr);
@@ -201,13 +198,12 @@ static int handle_ssdp_new(struct pkt_buff *pkt, uint32_t protoff,
 	}
 
 	/* No data? Ignore */
-	dataoff = net_hdr->ihl*4 + sizeof(struct udphdr);
-	if (dataoff >= pktb_len(pkt)) {
+	if (protoff + sizeof(struct udphdr) >= pktb_len(pkt)) {
 		pr_debug("ssdp_help: UDP payload too small for M-SEARCH; ignoring\n");
 		return NF_ACCEPT;
 	}
 
-	sb_ptr = pktb_network_header(pkt) + dataoff;
+	sb_ptr = pktb_network_header(pkt) + protoff + sizeof(struct udphdr);
 
 	if (memcmp(sb_ptr, SSDP_M_SEARCH, SSDP_M_SEARCH_SIZE) != 0) {
 		pr_debug("ssdp_help: UDP payload does not begin with 'M-SEARCH'; ignoring\n");
-- 
2.30.2

