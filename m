From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf 3/5] netfilter: nf_tables: fix tracing of the goto action
Date: Mon, 12 May 2014 16:40:03 +0200
Message-ID: <1399905605-6394-3-git-send-email-pablo@netfilter.org>
References: <1399905605-6394-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36554 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758569AbaELOlM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 10:41:12 -0400
In-Reply-To: <1399905605-6394-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add missing code to trace goto actions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 7d83a49..f55fb28 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -171,8 +171,12 @@ next_rule:
 		jumpstack[stackptr].rule  = rule;
 		jumpstack[stackptr].rulenum = rulenum;
 		stackptr++;
-		/* fall through */
+		chain = data[NFT_REG_VERDICT].chain;
+		goto do_chain;
 	case NFT_GOTO:
+		if (unlikely(pkt->skb->nf_trace))
+			nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
+
 		chain = data[NFT_REG_VERDICT].chain;
 		goto do_chain;
 	case NFT_RETURN:
-- 
1.7.10.4

