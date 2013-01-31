From: pablo@netfilter.org
Subject: [v2-nftables 1/2] netfilter: nf_tables: add packet and byte counters per chain
Date: Fri,  1 Feb 2013 00:20:39 +0100
Message-ID: <1359674440-3239-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([209.236.71.68]:50725 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab3AaXUv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2013 18:20:51 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch adds per-cpu chain counters. Only base chains are allowed
to have them to emulate x_tables behaviour.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |    7 +++
 include/uapi/linux/netfilter/nf_tables.h |    1 +
 net/netfilter/nf_tables_api.c            |  100 ++++++++++++++++++++++++++++++
 net/netfilter/nf_tables_core.c           |   26 ++++++--
 4 files changed, 130 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 1131e49..a9df310 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -400,18 +400,25 @@ enum nft_chain_type {
 	NFT_CHAIN_T_MAX
 };
 
+struct nft_stats {
+	u64 bytes;
+	u64 pkts;
+};
+
 /**
  *	struct nft_base_chain - nf_tables base chain
  *
  *	@ops: netfilter hook ops
  *	@type: chain type
  *	@policy: default policy
+ *	@stats: per-cpu chain stats
  *	@chain: the chain
  */
 struct nft_base_chain {
 	struct nf_hook_ops		ops;
 	enum nft_chain_type		type;
 	u8				policy;
+	struct nft_stats __percpu	*stats;
 	struct nft_chain		chain;
 };
 
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 3749069..ccd2c30 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -83,6 +83,7 @@ enum nft_chain_attributes {
 	NFTA_CHAIN_POLICY,
 	NFTA_CHAIN_USE,
 	NFTA_CHAIN_TYPE,
+	NFTA_CHAIN_COUNTERS,
 	__NFTA_CHAIN_MAX
 };
 #define NFTA_CHAIN_MAX		(__NFTA_CHAIN_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 031aad9..141e33e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -529,6 +529,33 @@ static const struct nla_policy nft_hook_policy[NFTA_HOOK_MAX + 1] = {
 	[NFTA_HOOK_PRIORITY]	= { .type = NLA_U32 },
 };
 
+static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
+{
+	struct nft_stats *cpu_stats, total;
+	struct nlattr *nest;
+	int cpu;
+
+	memset(&total, 0, sizeof(total));
+	for_each_possible_cpu(cpu) {
+		cpu_stats = per_cpu_ptr(stats, cpu);
+		total.pkts += cpu_stats->pkts;
+		total.bytes += cpu_stats->bytes;
+	}
+	nest = nla_nest_start(skb, NFTA_CHAIN_COUNTERS);
+	if (nest == NULL)
+		goto nla_put_failure;
+
+	if (nla_put_be64(skb, NFTA_COUNTER_PACKETS, cpu_to_be64(total.pkts)) ||
+	    nla_put_be64(skb, NFTA_COUNTER_BYTES, cpu_to_be64(total.bytes)))
+		goto nla_put_failure;
+
+	nla_nest_end(skb, nest);
+	return 0;
+
+nla_put_failure:
+	return -ENOSPC;
+}
+
 static int nf_tables_fill_chain_info(struct sk_buff *skb, u32 portid, u32 seq,
 				     int event, u32 flags, int family,
 				     const struct nft_table *table,
@@ -575,6 +602,9 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, u32 portid, u32 seq,
 		if (nla_put_string(skb, NFTA_CHAIN_TYPE,
 			chain_type[ops->pf][nft_base_chain(chain)->type]->name))
 				goto nla_put_failure;
+
+		if (nft_dump_stats(skb, nft_base_chain(chain)->stats))
+			goto nla_put_failure;
 	}
 
 	if (nla_put_be32(skb, NFTA_CHAIN_USE, htonl(chain->use)))
@@ -728,6 +758,51 @@ nf_tables_chain_policy(struct nft_base_chain *chain, const struct nlattr *attr)
 	return 0;
 }
 
+static const struct nla_policy nft_counter_policy[NFTA_COUNTER_MAX + 1] = {
+	[NFTA_COUNTER_PACKETS]	= { .type = NLA_U64 },
+	[NFTA_COUNTER_BYTES]	= { .type = NLA_U64 },
+};
+
+static int
+nf_tables_counters(struct nft_base_chain *chain, const struct nlattr *attr)
+{
+	struct nlattr *tb[NFTA_COUNTER_MAX+1];
+	struct nft_stats __percpu *newstats;
+	struct nft_stats *stats;
+	int err;
+
+	err = nla_parse_nested(tb, NFTA_COUNTER_MAX, attr, nft_counter_policy);
+	if (err < 0)
+		return err;
+
+	if (!tb[NFTA_COUNTER_BYTES] || !tb[NFTA_COUNTER_PACKETS])
+		return -EINVAL;
+
+	newstats = alloc_percpu(struct nft_stats);
+	if (newstats == NULL)
+		return -ENOMEM;
+
+	/* Restore old counters on this cpu, no problem. Per-cpu statistics
+	 * are not exposed to userspace.
+	 */
+	stats = this_cpu_ptr(newstats);
+	stats->bytes = be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_BYTES]));
+	stats->pkts = be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_PACKETS]));
+
+	if (chain->stats) {
+		/* nfnl_lock is held, add some nfnl function for this, later */
+		struct nft_stats __percpu *oldstats =
+			rcu_dereference_protected(chain->stats, 1);
+
+		rcu_assign_pointer(chain->stats, newstats);
+		synchronize_rcu();
+		free_percpu(oldstats);
+	} else
+		rcu_assign_pointer(chain->stats, newstats);
+
+	return 0;
+}
+
 static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 			      const struct nlmsghdr *nlh,
 			      const struct nlattr * const nla[])
@@ -792,6 +867,16 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 				return err;
 		}
 
+		if (nla[NFTA_CHAIN_COUNTERS]) {
+			if (!(chain->flags & NFT_BASE_CHAIN))
+				return -EOPNOTSUPP;
+
+			err = nf_tables_counters(nft_base_chain(chain),
+						 nla[NFTA_CHAIN_COUNTERS]);
+			if (err < 0)
+				return err;
+		}
+
 		if (nla[NFTA_CHAIN_HANDLE] && name)
 			nla_strlcpy(chain->name, name, NFT_CHAIN_MAXNAMELEN);
 
@@ -851,11 +936,22 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 			err = nf_tables_chain_policy(basechain,
 						     nla[NFTA_CHAIN_POLICY]);
 			if (err < 0) {
+				free_percpu(basechain->stats);
 				kfree(basechain);
 				return err;
 			}
 		} else
 			basechain->policy = NF_ACCEPT;
+
+		if (nla[NFTA_CHAIN_COUNTERS]) {
+			err = nf_tables_counters(basechain,
+						 nla[NFTA_CHAIN_COUNTERS]);
+			if (err < 0) {
+				free_percpu(basechain->stats);
+				kfree(basechain);
+				return err;
+			}
+		}
 	} else {
 		chain = kzalloc(sizeof(*chain), GFP_KERNEL);
 		if (chain == NULL)
@@ -872,6 +968,7 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 	    chain->flags & NFT_BASE_CHAIN) {
 		err = nf_register_hook(&nft_base_chain(chain)->ops);
 		if (err < 0) {
+			free_percpu(basechain->stats);
 			kfree(basechain);
 			return err;
 		}
@@ -889,6 +986,9 @@ static void nf_tables_rcu_chain_destroy(struct rcu_head *head)
 
 	BUG_ON(chain->use > 0);
 
+	if (chain->flags & NFT_BASE_CHAIN)
+		free_percpu(nft_base_chain(chain)->stats);
+
 	kfree(chain);
 }
 
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index a3f848f..1454805 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -60,6 +60,25 @@ static bool nft_payload_fast_eval(const struct nft_expr *expr,
 	return true;
 }
 
+struct nft_jumpstack {
+	const struct nft_chain	*chain;
+	const struct nft_rule	*rule;
+};
+
+static inline void
+nft_chain_stats(const struct nft_chain *this, const struct nft_pktinfo *pkt,
+		struct nft_jumpstack *jumpstack, unsigned int stackptr)
+{
+	struct nft_stats __percpu *stats;
+	const struct nft_chain *chain = stackptr ? jumpstack[0].chain : this;
+
+	rcu_read_lock_bh();
+	stats = rcu_dereference(nft_base_chain(chain)->stats);
+	__this_cpu_inc(stats->pkts);
+	__this_cpu_add(stats->bytes, pkt->skb->len);
+	rcu_read_unlock_bh();
+}
+
 unsigned int
 nft_do_chain_pktinfo(struct nft_pktinfo *pkt, const struct nf_hook_ops *ops)
 {
@@ -68,10 +87,7 @@ nft_do_chain_pktinfo(struct nft_pktinfo *pkt, const struct nf_hook_ops *ops)
 	const struct nft_expr *expr, *last;
 	struct nft_data data[NFT_REG_MAX + 1];
 	unsigned int stackptr = 0;
-	struct {
-		const struct nft_chain	*chain;
-		const struct nft_rule	*rule;
-	} jumpstack[NFT_JUMP_STACK_SIZE];
+	struct nft_jumpstack jumpstack[NFT_JUMP_STACK_SIZE];
 	/*
 	 * Cache cursor to avoid problems in case that the cursor is updated
 	 * while traversing the ruleset.
@@ -113,6 +129,7 @@ next_rule:
 	case NF_ACCEPT:
 	case NF_DROP:
 	case NF_QUEUE:
+		nft_chain_stats(chain, pkt, jumpstack, stackptr);
 		return data[NFT_REG_VERDICT].verdict;
 	case NFT_JUMP:
 		BUG_ON(stackptr >= NFT_JUMP_STACK_SIZE);
@@ -136,6 +153,7 @@ next_rule:
 		rule  = jumpstack[stackptr].rule;
 		goto next_rule;
 	}
+	nft_chain_stats(chain, pkt, jumpstack, stackptr);
 
 	return nft_base_chain(chain)->policy;
 }
-- 
1.7.10.4

