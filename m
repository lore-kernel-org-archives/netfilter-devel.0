From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/3] netfilter: nf_tables: minor tracing cleanups
Date: Tue,  3 Mar 2015 20:10:04 +0000
Message-ID: <1425413406-6804-2-git-send-email-kaber@trash.net>
References: <1425413406-6804-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44981 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbbCCUKL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Mar 2015 15:10:11 -0500
In-Reply-To: <1425413406-6804-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The tracing code is squeezed between multiple related parts of the
evaluation code, move it out. Also add an inline wrapper for the
reoccuring test for skb->nf_trace.

Small code savings in nft_do_chain():

  nft_trace_packet          | -137
  nft_do_chain              |   -8
 2 functions changed, 145 bytes removed, diff: -145

net/netfilter/nf_tables_core.c:
  __nft_trace_packet | +137
 1 function changed, 137 bytes added, diff: +137

net/netfilter/nf_tables_core.o:
 3 functions changed, 137 bytes added, 145 bytes removed, diff: -8

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_core.c | 98 +++++++++++++++++++++---------------------
 1 file changed, 49 insertions(+), 49 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 3b90eb2..074067d 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -21,6 +21,48 @@
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_log.h>
 
+enum nft_trace {
+	NFT_TRACE_RULE,
+	NFT_TRACE_RETURN,
+	NFT_TRACE_POLICY,
+};
+
+static const char *const comments[] = {
+	[NFT_TRACE_RULE]	= "rule",
+	[NFT_TRACE_RETURN]	= "return",
+	[NFT_TRACE_POLICY]	= "policy",
+};
+
+static struct nf_loginfo trace_loginfo = {
+	.type = NF_LOG_TYPE_LOG,
+	.u = {
+		.log = {
+			.level = 4,
+			.logflags = NF_LOG_MASK,
+	        },
+	},
+};
+
+static void __nft_trace_packet(const struct nft_pktinfo *pkt,
+			       const struct nft_chain *chain,
+			       int rulenum, enum nft_trace type)
+{
+	struct net *net = dev_net(pkt->in ? pkt->in : pkt->out);
+
+	nf_log_packet(net, pkt->xt.family, pkt->ops->hooknum, pkt->skb, pkt->in,
+		      pkt->out, &trace_loginfo, "TRACE: %s:%s:%s:%u ",
+		      chain->table->name, chain->name, comments[type],
+		      rulenum);
+}
+
+static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
+				    const struct nft_chain *chain,
+				    int rulenum, enum nft_trace type)
+{
+	if (unlikely(pkt->skb->nf_trace))
+		__nft_trace_packet(pkt, chain, rulenum, type);
+}
+
 static void nft_cmp_fast_eval(const struct nft_expr *expr,
 			      struct nft_data data[NFT_REG_MAX + 1])
 {
@@ -66,40 +108,6 @@ struct nft_jumpstack {
 	int			rulenum;
 };
 
-enum nft_trace {
-	NFT_TRACE_RULE,
-	NFT_TRACE_RETURN,
-	NFT_TRACE_POLICY,
-};
-
-static const char *const comments[] = {
-	[NFT_TRACE_RULE]	= "rule",
-	[NFT_TRACE_RETURN]	= "return",
-	[NFT_TRACE_POLICY]	= "policy",
-};
-
-static struct nf_loginfo trace_loginfo = {
-	.type = NF_LOG_TYPE_LOG,
-	.u = {
-		.log = {
-			.level = 4,
-			.logflags = NF_LOG_MASK,
-	        },
-	},
-};
-
-static void nft_trace_packet(const struct nft_pktinfo *pkt,
-			     const struct nft_chain *chain,
-			     int rulenum, enum nft_trace type)
-{
-	struct net *net = dev_net(pkt->in ? pkt->in : pkt->out);
-
-	nf_log_packet(net, pkt->xt.family, pkt->ops->hooknum, pkt->skb, pkt->in,
-		      pkt->out, &trace_loginfo, "TRACE: %s:%s:%s:%u ",
-		      chain->table->name, chain->name, comments[type],
-		      rulenum);
-}
-
 unsigned int
 nft_do_chain(struct nft_pktinfo *pkt, const struct nf_hook_ops *ops)
 {
@@ -146,8 +154,7 @@ next_rule:
 			data[NFT_REG_VERDICT].verdict = NFT_CONTINUE;
 			continue;
 		case NFT_CONTINUE:
-			if (unlikely(pkt->skb->nf_trace))
-				nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
+			nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
 			continue;
 		}
 		break;
@@ -157,16 +164,13 @@ next_rule:
 	case NF_ACCEPT:
 	case NF_DROP:
 	case NF_QUEUE:
-		if (unlikely(pkt->skb->nf_trace))
-			nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
-
+		nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
 		return data[NFT_REG_VERDICT].verdict;
 	}
 
 	switch (data[NFT_REG_VERDICT].verdict) {
 	case NFT_JUMP:
-		if (unlikely(pkt->skb->nf_trace))
-			nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
+		nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
 
 		BUG_ON(stackptr >= NFT_JUMP_STACK_SIZE);
 		jumpstack[stackptr].chain = chain;
@@ -176,18 +180,15 @@ next_rule:
 		chain = data[NFT_REG_VERDICT].chain;
 		goto do_chain;
 	case NFT_GOTO:
-		if (unlikely(pkt->skb->nf_trace))
-			nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
+		nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
 
 		chain = data[NFT_REG_VERDICT].chain;
 		goto do_chain;
 	case NFT_RETURN:
-		if (unlikely(pkt->skb->nf_trace))
-			nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RETURN);
+		nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RETURN);
 		break;
 	case NFT_CONTINUE:
-		if (unlikely(pkt->skb->nf_trace && !(chain->flags & NFT_BASE_CHAIN)))
-			nft_trace_packet(pkt, chain, ++rulenum, NFT_TRACE_RETURN);
+		nft_trace_packet(pkt, chain, ++rulenum, NFT_TRACE_RETURN);
 		break;
 	default:
 		WARN_ON(1);
@@ -201,8 +202,7 @@ next_rule:
 		goto next_rule;
 	}
 
-	if (unlikely(pkt->skb->nf_trace))
-		nft_trace_packet(pkt, basechain, -1, NFT_TRACE_POLICY);
+	nft_trace_packet(pkt, basechain, -1, NFT_TRACE_POLICY);
 
 	rcu_read_lock_bh();
 	stats = this_cpu_ptr(rcu_dereference(nft_base_chain(basechain)->stats));
-- 
2.1.0

