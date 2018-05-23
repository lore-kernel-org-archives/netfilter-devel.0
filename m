From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 02/18] netfilter: nf_tables: remove old nf_log based tracing
Date: Wed, 23 May 2018 20:42:38 +0200
Message-ID: <20180523184254.22599-3-pablo@netfilter.org>
References: <20180523184254.22599-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180523184254.22599-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

nfnetlink tracing is available since nft 0.6 (June 2016).
Remove old nf_log based tracing to avoid rule counter in main loop.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_core.c | 29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 9cf47c4cb9d5..d457d854fcae 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -41,7 +41,7 @@ static const struct nf_loginfo trace_loginfo = {
 
 static noinline void __nft_trace_packet(struct nft_traceinfo *info,
 					const struct nft_chain *chain,
-					int rulenum, enum nft_trace_types type)
+					enum nft_trace_types type)
 {
 	const struct nft_pktinfo *pkt = info->pkt;
 
@@ -52,22 +52,16 @@ static noinline void __nft_trace_packet(struct nft_traceinfo *info,
 	info->type = type;
 
 	nft_trace_notify(info);
-
-	nf_log_trace(nft_net(pkt), nft_pf(pkt), nft_hook(pkt), pkt->skb,
-		     nft_in(pkt), nft_out(pkt), &trace_loginfo,
-		     "TRACE: %s:%s:%s:%u ",
-		     chain->table->name, chain->name, comments[type], rulenum);
 }
 
 static inline void nft_trace_packet(struct nft_traceinfo *info,
 				    const struct nft_chain *chain,
 				    const struct nft_rule *rule,
-				    int rulenum,
 				    enum nft_trace_types type)
 {
 	if (static_branch_unlikely(&nft_trace_enabled)) {
 		info->rule = rule;
-		__nft_trace_packet(info, chain, rulenum, type);
+		__nft_trace_packet(info, chain, type);
 	}
 }
 
@@ -133,7 +127,6 @@ static noinline void nft_update_chain_stats(const struct nft_chain *chain,
 struct nft_jumpstack {
 	const struct nft_chain	*chain;
 	const struct nft_rule	*rule;
-	int			rulenum;
 };
 
 unsigned int
@@ -146,7 +139,6 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 	struct nft_regs regs;
 	unsigned int stackptr = 0;
 	struct nft_jumpstack jumpstack[NFT_JUMP_STACK_SIZE];
-	int rulenum;
 	unsigned int gencursor = nft_genmask_cur(net);
 	struct nft_traceinfo info;
 
@@ -154,7 +146,6 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 	if (static_branch_unlikely(&nft_trace_enabled))
 		nft_trace_init(&info, pkt, &regs.verdict, basechain);
 do_chain:
-	rulenum = 0;
 	rule = list_entry(&chain->rules, struct nft_rule, list);
 next_rule:
 	regs.verdict.code = NFT_CONTINUE;
@@ -164,8 +155,6 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		if (unlikely(rule->genmask & gencursor))
 			continue;
 
-		rulenum++;
-
 		nft_rule_for_each_expr(expr, last, rule) {
 			if (expr->ops == &nft_cmp_fast_ops)
 				nft_cmp_fast_eval(expr, &regs);
@@ -183,7 +172,7 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 			continue;
 		case NFT_CONTINUE:
 			nft_trace_packet(&info, chain, rule,
-					 rulenum, NFT_TRACETYPE_RULE);
+					 NFT_TRACETYPE_RULE);
 			continue;
 		}
 		break;
@@ -195,7 +184,7 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 	case NF_QUEUE:
 	case NF_STOLEN:
 		nft_trace_packet(&info, chain, rule,
-				 rulenum, NFT_TRACETYPE_RULE);
+				 NFT_TRACETYPE_RULE);
 		return regs.verdict.code;
 	}
 
@@ -204,21 +193,19 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		BUG_ON(stackptr >= NFT_JUMP_STACK_SIZE);
 		jumpstack[stackptr].chain = chain;
 		jumpstack[stackptr].rule  = rule;
-		jumpstack[stackptr].rulenum = rulenum;
 		stackptr++;
 		/* fall through */
 	case NFT_GOTO:
 		nft_trace_packet(&info, chain, rule,
-				 rulenum, NFT_TRACETYPE_RULE);
+				 NFT_TRACETYPE_RULE);
 
 		chain = regs.verdict.chain;
 		goto do_chain;
 	case NFT_CONTINUE:
-		rulenum++;
 		/* fall through */
 	case NFT_RETURN:
 		nft_trace_packet(&info, chain, rule,
-				 rulenum, NFT_TRACETYPE_RETURN);
+				 NFT_TRACETYPE_RETURN);
 		break;
 	default:
 		WARN_ON(1);
@@ -228,12 +215,10 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		stackptr--;
 		chain = jumpstack[stackptr].chain;
 		rule  = jumpstack[stackptr].rule;
-		rulenum = jumpstack[stackptr].rulenum;
 		goto next_rule;
 	}
 
-	nft_trace_packet(&info, basechain, NULL, -1,
-			 NFT_TRACETYPE_POLICY);
+	nft_trace_packet(&info, basechain, NULL, NFT_TRACETYPE_POLICY);
 
 	if (static_branch_unlikely(&nft_counters_enabled))
 		nft_update_chain_stats(basechain, pkt);
-- 
2.11.0
