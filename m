From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 03/12] netfilter: nf_tables: allow expressions to return STOLEN
Date: Tue,  1 Nov 2016 22:26:24 +0100
Message-ID: <1478035593-1362-4-git-send-email-pablo@netfilter.org>
References: <1478035593-1362-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52508 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752446AbcKAV0t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Nov 2016 17:26:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 59A621683A8
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 22:26:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4771BBAC29
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 22:26:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 06A31DA845
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 22:26:41 +0100 (CET)
In-Reply-To: <1478035593-1362-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

Currently not supported, we'd oops as skb was (or is) free'd elsewhere.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 0dd5c695482f..70de32a6d5c0 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -178,6 +178,7 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 	case NF_ACCEPT:
 	case NF_DROP:
 	case NF_QUEUE:
+	case NF_STOLEN:
 		nft_trace_packet(&info, chain, rule,
 				 rulenum, NFT_TRACETYPE_RULE);
 		return regs.verdict.code;
-- 
2.1.4

