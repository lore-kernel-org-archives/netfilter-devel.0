From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf 5/5] netfilter: nf_tables: fix missing return trace at the end of non-base chain
Date: Mon, 12 May 2014 16:40:05 +0200
Message-ID: <1399905605-6394-5-git-send-email-pablo@netfilter.org>
References: <1399905605-6394-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36568 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758718AbaELOlP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 10:41:15 -0400
In-Reply-To: <1399905605-6394-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Display "return" for implicit rule at the end of a non-base chain,
instead of when popping chain from the stack.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_core.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index be08a96..421c36a 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -182,18 +182,16 @@ next_rule:
 	case NFT_RETURN:
 		if (unlikely(pkt->skb->nf_trace))
 			nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RETURN);
-
-		/* fall through */
+		break;
 	case NFT_CONTINUE:
+		if (unlikely(pkt->skb->nf_trace && !(chain->flags & NFT_BASE_CHAIN)))
+			nft_trace_packet(pkt, chain, ++rulenum, NFT_TRACE_RETURN);
 		break;
 	default:
 		WARN_ON(1);
 	}
 
 	if (stackptr > 0) {
-		if (unlikely(pkt->skb->nf_trace))
-			nft_trace_packet(pkt, chain, ++rulenum, NFT_TRACE_RETURN);
-
 		stackptr--;
 		chain = jumpstack[stackptr].chain;
 		rule  = jumpstack[stackptr].rule;
-- 
1.7.10.4

