From: Florian Westphal <fw@strlen.de>
Subject: [PATCH next] netfilter: nf_tables: allow expressions to return STOLEN
Date: Tue, 18 Oct 2016 17:35:18 +0200
Message-ID: <1476804918-4191-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:53298 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S938606AbcJRPgr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Oct 2016 11:36:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently not supported, we'd oops as skb was (or is) free'd elsewhere.

Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.7.3

