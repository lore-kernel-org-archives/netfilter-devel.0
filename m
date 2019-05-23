Return-Path: <SRS0=SfI0=TX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF9DC282DD
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 21:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E563A21773
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 21:36:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388351AbfEWVgF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 May 2019 17:36:05 -0400
Received: from mail.us.es ([193.147.175.20]:46952 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388320AbfEWVgC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 May 2019 17:36:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 66895C1A72
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2019 23:36:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 58EADDA70C
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2019 23:36:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4E8D5DA70A; Thu, 23 May 2019 23:36:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4937CDA707;
        Thu, 23 May 2019 23:35:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 23 May 2019 23:35:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 184054265A32;
        Thu, 23 May 2019 23:35:58 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 10/11] netfilter: nft_flow_offload: IPCB is only valid for ipv4 family
Date:   Thu, 23 May 2019 23:35:46 +0200
Message-Id: <20190523213547.15523-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190523213547.15523-1-pablo@netfilter.org>
References: <20190523213547.15523-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Guard this with a check vs. ipv4, IPCB isn't valid in ipv6 case.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_flow_offload.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index c97c03c3939a..d70742e95e14 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -48,15 +48,20 @@ static int nft_flow_route(const struct nft_pktinfo *pkt,
 	return 0;
 }
 
-static bool nft_flow_offload_skip(struct sk_buff *skb)
+static bool nft_flow_offload_skip(struct sk_buff *skb, int family)
 {
-	struct ip_options *opt  = &(IPCB(skb)->opt);
-
-	if (unlikely(opt->optlen))
-		return true;
 	if (skb_sec_path(skb))
 		return true;
 
+	if (family == NFPROTO_IPV4) {
+		const struct ip_options *opt;
+
+		opt = &(IPCB(skb)->opt);
+
+		if (unlikely(opt->optlen))
+			return true;
+	}
+
 	return false;
 }
 
@@ -74,7 +79,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	struct nf_conn *ct;
 	int ret;
 
-	if (nft_flow_offload_skip(pkt->skb))
+	if (nft_flow_offload_skip(pkt->skb, nft_pf(pkt)))
 		goto out;
 
 	ct = nf_ct_get(pkt->skb, &ctinfo);
-- 
2.11.0

