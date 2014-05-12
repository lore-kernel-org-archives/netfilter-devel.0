From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf 4/5] netfilter: nf_tables: fix bogus rulenum after goto action
Date: Mon, 12 May 2014 16:40:04 +0200
Message-ID: <1399905605-6394-4-git-send-email-pablo@netfilter.org>
References: <1399905605-6394-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36555 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758571AbaELOlM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 10:41:12 -0400
In-Reply-To: <1399905605-6394-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

After returning from the chain that we just went to with no matchings,
we get a bogus rule number in the trace. To fix this, we would need
to iterate over the list of remaining rules in the chain to update the
rule number counter.

Patrick suggested to set this to the maximum value since the default
base chain policy is the very last action when the processing the base
chain is over.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index f55fb28..be08a96 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -202,7 +202,7 @@ next_rule:
 	}
 
 	if (unlikely(pkt->skb->nf_trace))
-		nft_trace_packet(pkt, basechain, ++rulenum, NFT_TRACE_POLICY);
+		nft_trace_packet(pkt, basechain, -1, NFT_TRACE_POLICY);
 
 	rcu_read_lock_bh();
 	stats = rcu_dereference(nft_base_chain(basechain)->stats);
-- 
1.7.10.4

