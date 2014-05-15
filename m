From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: nf_tables: fix trace when matching rule
Date: Thu, 15 May 2014 18:28:44 +0200
Message-ID: <1400171324-3923-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44968 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbaEOQ2v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2014 12:28:51 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add the corresponding trace if we have a full match in a rule.
Note that the traces will look slightly different than in x_tables
since the log message after all expressions have been evaluated
(contrary to x_tables, that emits it before the target action).
This manifests in two differences in nf_tables wrt. x_tables:

1) The rule that enables the tracing is included in the trace.

2) If the rule emits some log message, that is shown before the
   trace log message.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 421c36a..7dbf803 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -144,8 +144,10 @@ next_rule:
 		switch (data[NFT_REG_VERDICT].verdict) {
 		case NFT_BREAK:
 			data[NFT_REG_VERDICT].verdict = NFT_CONTINUE;
-			/* fall through */
+			continue;
 		case NFT_CONTINUE:
+			if (unlikely(pkt->skb->nf_trace && expr == last))
+				nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
 			continue;
 		}
 		break;
-- 
1.7.10.4

