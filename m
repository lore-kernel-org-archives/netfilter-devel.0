From: pablo@netfilter.org
Subject: [nftables 7/9] netfilter: nf_tables: add trace support
Date: Thu, 31 Jan 2013 01:04:03 +0100
Message-ID: <1359590645-4703-7-git-send-email-pablo@netfilter.org>
References: <1359590645-4703-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([209.236.71.68]:58972 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab3AaAEc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2013 19:04:32 -0500
In-Reply-To: <1359590645-4703-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |    2 ++
 net/netfilter/nf_tables_api.c     |    1 +
 net/netfilter/nf_tables_core.c    |   55 +++++++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index d172b66..3782777 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -376,6 +376,7 @@ enum nft_chain_flags {
  *	@list: used internally
  *	@rcu_head: used internally
  *	@net: net namespace that this chain belongs to
+ *	@table: table that this chain belongs to
  *	@handle: chain handle
  *	@flags: bitmask of enum nft_chain_flags
  *	@use: number of jump references to this chain
@@ -388,6 +389,7 @@ struct nft_chain {
 	struct list_head		list;
 	struct rcu_head			rcu_head;
 	struct net			*net;
+	struct nft_table		*table;
 	u64				handle;
 	u8				flags;
 	u16				use;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6eda6cc..7fc8d51 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -962,6 +962,7 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 	INIT_LIST_HEAD(&chain->dirty_rules);
 	chain->handle = nf_tables_alloc_handle(table);
 	chain->net = net;
+	chain->table = table;
 	nla_strlcpy(chain->name, name, NFT_CHAIN_MAXNAMELEN);
 
 	if (!(table->flags & NFT_TABLE_F_DORMANT) &&
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 5bb11f5..1b81546 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -19,6 +19,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_log.h>
 
 static void nft_cmp_fast_eval(const struct nft_expr *expr,
 			      struct nft_data data[NFT_REG_MAX + 1])
@@ -60,6 +61,39 @@ static bool nft_payload_fast_eval(const struct nft_expr *expr,
 	return true;
 }
 
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
+static void nft_trace_packet(const struct nft_pktinfo *pkt,
+			     const struct nft_chain *chain,
+			     int rulenum, enum nft_trace type)
+{
+	const char *comment = comments[type];
+
+	nf_log_packet(pkt->xt.family, pkt->hooknum, pkt->skb, pkt->in, pkt->out,
+		      &trace_loginfo, "TRACE: %s:%s:%s:%u ",
+		      chain->table->name, chain->name, comment, rulenum);
+}
+
 unsigned int
 nft_do_chain_pktinfo(struct nft_pktinfo *pkt, const struct nf_hook_ops *ops)
 {
@@ -71,7 +105,10 @@ nft_do_chain_pktinfo(struct nft_pktinfo *pkt, const struct nf_hook_ops *ops)
 	struct {
 		const struct nft_chain	*chain;
 		const struct nft_rule	*rule;
+		int			rulenum;
 	} jumpstack[NFT_JUMP_STACK_SIZE];
+	int rulenum = 0;
+
 	/*
 	 * Cache cursor to avoid problems in case that the cursor is updated
 	 * while traversing the ruleset.
@@ -83,6 +120,7 @@ do_chain:
 next_rule:
 	data[NFT_REG_VERDICT].verdict = NFT_CONTINUE;
 	list_for_each_entry_continue_rcu(rule, &chain->rules, list) {
+		rulenum++;
 
 		/* This rule is not active, skip. */
 		if (unlikely(rule->genmask & (1 << gencursor)))
@@ -113,17 +151,28 @@ next_rule:
 	case NF_ACCEPT:
 	case NF_DROP:
 	case NF_QUEUE:
+		if (unlikely(pkt->skb->nf_trace))
+			nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
+
 		return data[NFT_REG_VERDICT].verdict;
 	case NFT_JUMP:
+		if (unlikely(pkt->skb->nf_trace))
+			nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
+
 		BUG_ON(stackptr >= NFT_JUMP_STACK_SIZE);
 		jumpstack[stackptr].chain = chain;
 		jumpstack[stackptr].rule  = rule;
+		jumpstack[stackptr].rulenum = rulenum;
 		stackptr++;
 		/* fall through */
 	case NFT_GOTO:
 		chain = data[NFT_REG_VERDICT].chain;
 		goto do_chain;
 	case NFT_RETURN:
+		if (unlikely(pkt->skb->nf_trace))
+			nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RETURN);
+
+		/* fall through */
 	case NFT_CONTINUE:
 		break;
 	default:
@@ -134,6 +183,7 @@ next_rule:
 		stackptr--;
 		chain = jumpstack[stackptr].chain;
 		rule  = jumpstack[stackptr].rule;
+		rulenum = jumpstack[stackptr].rulenum;
 		goto next_rule;
 	}
 
@@ -146,6 +196,11 @@ next_rule:
 		__this_cpu_add(stats->bytes, pkt->skb->len);
 		rcu_read_unlock_bh();
 	}
+	if (unlikely(pkt->skb->nf_trace)) {
+		rulenum++;	/* Skip last rule */
+		nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_POLICY);
+	}
+
 	return nft_base_chain(chain)->policy;
 }
 EXPORT_SYMBOL_GPL(nft_do_chain_pktinfo);
-- 
1.7.10.4

