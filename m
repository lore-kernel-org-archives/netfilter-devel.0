From: pablo@netfilter.org
Subject: [nftables 3/9] netfilter: nf_tables: atomic rule updates and dumps
Date: Thu, 31 Jan 2013 01:03:59 +0100
Message-ID: <1359590645-4703-3-git-send-email-pablo@netfilter.org>
References: <1359590645-4703-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([209.236.71.68]:35778 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab3AaAEZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2013 19:04:25 -0500
In-Reply-To: <1359590645-4703-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch adds global atomic rule updates and dumps based on
bitmask generations. This allows to atomically commit a set of
rule-set updates incrementally without altering the internal
state of existing nf_tables expressions/matches/targets.

The idea consists of using a generation cursor of 1 bit and
a bitmask of 2 bits per rule. Assuming the gencursor is 0,
then the genmask (expressed as a bitmask) can be interpreted
as:

00 active in the present, will be active in the next generation.
01 inactive in the present, will be active in the next generation.
10 active in the present, will be deleted in the next generation.
 ^
 gencursor

Once you invoke the transition to the next generation, the global
gencursor is updated:

00 active in the present, will be active in the next generation.
01 active in the present, needs to zero its future, it becomes 00.
10 inactive in the present, delete now.
^
gencursor

If a dump is in progress and nf_tables enters a new generation,
the dump will stop and return -EBUSY to let userspace know that
it has to retry again. In order to invalidate dumps, a global
genctr counter is increased everytime nf_tables enters a new
generation.

This new operation can be used from the user-space utility
that controls the firewall, eg.

nft restore < file

The rule updates contained in `file' will be applied atomically.

cat file
-----
add filter INPUT ip saddr 1.1.1.1 counter accept #1
del filter INPUT ip daddr 2.2.2.2 counter drop   #2
commit                                           #3
-EOF-

Note that the rule 1 will be inactive until the transition to the
next generation, the rule 2 will be evicted in the next generation.

There is a penalty during the rule update due to the branch
misprediction in the packet matching framework. But that should be
quickly resolved once the iteration over the dirty list that
contain rules that require updates is finished.

Event notification happens once the rule-set update has been
committed. So we skip notifications is case the rule-set update
is aborted, which can happen in case that the rule-set is tested
to apply correctly.

This patch is based on ideas extracted from discussions with
Patrick McHardy.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_tables.h |    8 ++
 include/net/netfilter/nf_tables.h   |   10 +-
 include/net/netns/nftables.h        |    2 +
 net/netfilter/nf_tables_api.c       |  227 ++++++++++++++++++++++++++++++++---
 net/netfilter/nf_tables_core.c      |   10 ++
 5 files changed, 240 insertions(+), 17 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 7640290..3749069 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -37,6 +37,8 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWSETELEM,
 	NFT_MSG_GETSETELEM,
 	NFT_MSG_DELSETELEM,
+	NFT_MSG_COMMIT,
+	NFT_MSG_ABORT,
 	NFT_MSG_MAX,
 };
 
@@ -85,12 +87,18 @@ enum nft_chain_attributes {
 };
 #define NFTA_CHAIN_MAX		(__NFTA_CHAIN_MAX - 1)
 
+enum {
+	NFT_RULE_F_COMMIT	= (1 << 0),
+	NFT_RULE_F_MASK		= NFT_RULE_F_COMMIT,
+};
+
 enum nft_rule_attributes {
 	NFTA_RULE_UNSPEC,
 	NFTA_RULE_TABLE,
 	NFTA_RULE_CHAIN,
 	NFTA_RULE_HANDLE,
 	NFTA_RULE_EXPRESSIONS,
+	NFTA_RULE_FLAGS,
 	__NFTA_RULE_MAX
 };
 #define NFTA_RULE_MAX		(__NFTA_RULE_MAX - 1)
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3ba63b6..1131e49 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -319,15 +319,19 @@ static inline void *nft_expr_priv(const struct nft_expr *expr)
  *	struct nft_rule - nf_tables rule
  *
  *	@list: used internally
+ *	@dirty_list: this rule needs an update after new generation
  *	@rcu_head: used internally for rcu
  *	@handle: rule handle
+ *	@genmask: generation mask
  *	@dlen: length of expression data
  *	@data: expression data
  */
 struct nft_rule {
 	struct list_head		list;
+	struct list_head		dirty_list;
 	struct rcu_head			rcu_head;
-	u64				handle:48,
+	u64				handle:46,
+					genmask:2,
 					dlen:16;
 	unsigned char			data[]
 		__attribute__((aligned(__alignof__(struct nft_expr))));
@@ -366,8 +370,10 @@ enum nft_chain_flags {
  *	struct nft_chain - nf_tables chain
  *
  *	@rules: list of rules in the chain
+ *	@dirty_rules: rules that need an update after next generation
  *	@list: used internally
  *	@rcu_head: used internally
+ *	@net: net namespace that this chain belongs to
  *	@handle: chain handle
  *	@flags: bitmask of enum nft_chain_flags
  *	@use: number of jump references to this chain
@@ -376,8 +382,10 @@ enum nft_chain_flags {
  */
 struct nft_chain {
 	struct list_head		rules;
+	struct list_head		dirty_rules;
 	struct list_head		list;
 	struct rcu_head			rcu_head;
+	struct net			*net;
 	u64				handle;
 	u8				flags;
 	u16				use;
diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
index a98b1c5..fe919c7 100644
--- a/include/net/netns/nftables.h
+++ b/include/net/netns/nftables.h
@@ -10,6 +10,8 @@ struct netns_nftables {
 	struct nft_af_info	*ipv4;
 	struct nft_af_info	*ipv6;
 	struct nft_af_info	*bridge;
+	u8			gencursor:1,
+				genctr:7;
 };
 
 #endif
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index db6150b..7f08381 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -863,7 +863,9 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 	}
 
 	INIT_LIST_HEAD(&chain->rules);
+	INIT_LIST_HEAD(&chain->dirty_rules);
 	chain->handle = nf_tables_alloc_handle(table);
+	chain->net = net;
 	nla_strlcpy(chain->name, name, NFT_CHAIN_MAXNAMELEN);
 
 	list_add_tail(&chain->list, &table->chains);
@@ -1150,6 +1152,7 @@ static const struct nla_policy nft_rule_policy[NFTA_RULE_MAX + 1] = {
 				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
 	[NFTA_RULE_HANDLE]	= { .type = NLA_U64 },
 	[NFTA_RULE_EXPRESSIONS]	= { .type = NLA_NESTED },
+	[NFTA_RULE_FLAGS]	= { .type = NLA_U32 },
 };
 
 static int nf_tables_fill_rule_info(struct sk_buff *skb, u32 portid, u32 seq,
@@ -1239,6 +1242,41 @@ err:
 	return err;
 }
 
+static inline bool
+nft_rule_is_active(struct net *net, const struct nft_rule *rule)
+{
+	return (rule->genmask & (1 << net->nft.gencursor)) == 0;
+}
+
+static inline int gencursor_next(struct net *net)
+{
+	return net->nft.gencursor+1 == 1 ? 1 : 0;
+}
+
+static inline int
+nft_rule_is_active_next(struct net *net, const struct nft_rule *rule)
+{
+	return (rule->genmask & (1 << gencursor_next(net))) == 0;
+}
+
+static inline void
+nft_rule_activate_next(struct net *net, struct nft_rule *rule)
+{
+	/* Now inactive, will be active in the future */
+	rule->genmask = (1 << net->nft.gencursor);
+}
+
+static inline void
+nft_rule_disactivate_next(struct net *net, struct nft_rule *rule)
+{
+	rule->genmask = (1 << gencursor_next(net));
+}
+
+static inline void nft_rule_clear(struct net *net, struct nft_rule *rule)
+{
+	rule->genmask = 0;
+}
+
 static int nf_tables_dump_rules(struct sk_buff *skb,
 				struct netlink_callback *cb)
 {
@@ -1250,6 +1288,7 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 	unsigned int idx = 0, s_idx = cb->args[0];
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
+	unsigned int genctr = net->nft.genctr, gencursor = net->nft.gencursor;
 
 	list_for_each_entry(afi, &net->nft.af_info, list) {
 		if (family != NFPROTO_UNSPEC && family != afi->family)
@@ -1258,6 +1297,8 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 		list_for_each_entry(table, &afi->tables, list) {
 			list_for_each_entry(chain, &table->chains, list) {
 				list_for_each_entry(rule, &chain->rules, list) {
+					if (!nft_rule_is_active(net, rule))
+						goto cont;
 					if (idx < s_idx)
 						goto cont;
 					if (idx > s_idx)
@@ -1276,6 +1317,10 @@ cont:
 		}
 	}
 done:
+	/* Invalidate this dump, a transition to the new generation happened */
+	if (gencursor != net->nft.gencursor || genctr != net->nft.genctr)
+		return -EBUSY;
+
 	cb->args[0] = idx;
 	return skb->len;
 }
@@ -1376,6 +1421,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	unsigned int size, i, n;
 	int err, rem;
 	bool create;
+	u32 flags = 0;
 	u64 handle;
 
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
@@ -1434,6 +1480,15 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	if (rule == NULL)
 		goto err1;
 
+	if (nla[NFTA_RULE_FLAGS]) {
+		flags = ntohl(nla_get_be32(nla[NFTA_RULE_FLAGS]));
+		if (flags & ~NFT_RULE_F_MASK)
+			return -EINVAL;
+
+		if (flags & NFT_RULE_F_COMMIT)
+			nft_rule_activate_next(net, rule);
+	}
+
 	rule->handle = handle;
 	rule->dlen   = size;
 
@@ -1447,16 +1502,26 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	}
 
 	if (nlh->nlmsg_flags & NLM_F_REPLACE) {
-		list_replace_rcu(&old_rule->list, &rule->list);
-		nf_tables_rule_destroy(old_rule);
+		if (flags & NFT_RULE_F_COMMIT) {
+			nft_rule_disactivate_next(net, old_rule);
+			list_add_tail_rcu(&rule->list, &chain->rules);
+		} else {
+			list_replace_rcu(&old_rule->list, &rule->list);
+			nf_tables_rule_destroy(old_rule);
+		}
 	} else if (nlh->nlmsg_flags & NLM_F_APPEND)
 		list_add_tail_rcu(&rule->list, &chain->rules);
 	else
 		list_add_rcu(&rule->list, &chain->rules);
 
-	nf_tables_rule_notify(skb, nlh, table, chain, rule, NFT_MSG_NEWRULE,
-			      nlh->nlmsg_flags & (NLM_F_APPEND | NLM_F_REPLACE),
-			      nfmsg->nfgen_family);
+	if (flags & NFT_RULE_F_COMMIT)
+		list_add(&rule->dirty_list, &chain->dirty_rules);
+	else {
+		nf_tables_rule_notify(skb, nlh, table, chain, rule,
+				      NFT_MSG_NEWRULE,
+				      nlh->nlmsg_flags & (NLM_F_APPEND | NLM_F_REPLACE),
+				      nfmsg->nfgen_family);
+	}
 	return 0;
 
 err2:
@@ -1469,6 +1534,23 @@ err1:
 	return err;
 }
 
+static void
+nf_tables_delrule_one(struct nft_ctx *ctx, struct nft_rule *rule, u32 flags)
+{
+	if (flags & NFT_RULE_F_COMMIT) {
+		struct nft_chain *chain = (struct nft_chain *)ctx->chain;
+
+		nft_rule_disactivate_next(ctx->net, rule);
+		list_add(&rule->dirty_list, &chain->dirty_rules);
+	} else {
+		list_del_rcu(&rule->list);
+		nf_tables_rule_notify(ctx->skb, ctx->nlh, ctx->table,
+				      ctx->chain, rule, NFT_MSG_DELRULE,
+				      0, ctx->afi->family);
+		nf_tables_rule_destroy(rule);
+	}
+}
+
 static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 			     const struct nlmsghdr *nlh,
 			     const struct nlattr * const nla[])
@@ -1480,6 +1562,8 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 	struct nft_chain *chain;
 	struct nft_rule *rule, *tmp;
 	int family = nfmsg->nfgen_family;
+	struct nft_ctx ctx;
+	u32 flags = 0;
 
 	afi = nf_tables_afinfo_lookup(net, family, false);
 	if (IS_ERR(afi))
@@ -1493,31 +1577,132 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(chain))
 		return PTR_ERR(chain);
 
+	nft_ctx_init(&ctx, skb, nlh, afi, table, chain);
+
+	if (nla[NFTA_RULE_FLAGS]) {
+		flags = ntohl(nla_get_be32(nla[NFTA_RULE_FLAGS]));
+
+		if (flags & ~NFT_RULE_F_MASK)
+			return -EINVAL;
+	}
+
 	if (nla[NFTA_RULE_HANDLE]) {
 		rule = nf_tables_rule_lookup(chain, nla[NFTA_RULE_HANDLE]);
 		if (IS_ERR(rule))
 			return PTR_ERR(rule);
 
-		/* List removal must be visible before destroying expressions */
-		list_del_rcu(&rule->list);
-
-		nf_tables_rule_notify(skb, nlh, table, chain, rule,
-				      NFT_MSG_DELRULE, 0, family);
-		nf_tables_rule_destroy(rule);
+		nf_tables_delrule_one(&ctx, rule, flags);
 	} else {
 		/* Remove all rules in this chain */
-		list_for_each_entry_safe(rule, tmp, &chain->rules, list) {
-			list_del_rcu(&rule->list);
+		list_for_each_entry_safe(rule, tmp, &chain->rules, list)
+			nf_tables_delrule_one(&ctx, rule, flags);
+	}
 
-			nf_tables_rule_notify(skb, nlh, table, chain, rule,
-					      NFT_MSG_DELRULE, 0, family);
-			nf_tables_rule_destroy(rule);
+	return 0;
+}
+
+static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
+			    const struct nlmsghdr *nlh,
+			    const struct nlattr * const nla[])
+{
+	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
+	const struct nft_af_info *afi;
+	struct net *net = sock_net(skb->sk);
+	struct nft_table *table;
+	struct nft_chain *chain;
+	struct nft_rule *rule, *tmp;
+	int family = nfmsg->nfgen_family;
+	bool create;
+
+	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
+
+	afi = nf_tables_afinfo_lookup(net, nfmsg->nfgen_family, create);
+	if (IS_ERR(afi))
+		return PTR_ERR(afi);
+
+	/* Bump generation counter, invalidate any dump in progress */
+	net->nft.genctr++;
+
+	/* A new generation has just started */
+	net->nft.gencursor++;
+
+	/* Make sure all packets have left the previous generation before
+	 * purging old rules.
+	 */
+	synchronize_rcu();
+
+	list_for_each_entry(table, &afi->tables, list) {
+		list_for_each_entry(chain, &table->chains, list) {
+			list_for_each_entry_safe(rule, tmp, &chain->dirty_rules, dirty_list) {
+				/* Delete this rule from the dirty list */
+				list_del(&rule->dirty_list);
+
+				/* This rule was inactive in the past and just
+				 * became active. Clear the next bit of the
+				 * genmask since its meaning has changed, now
+				 * it is the future.
+				 */
+				if (nft_rule_is_active(net, rule)) {
+					nft_rule_clear(net, rule);
+					nf_tables_rule_notify(skb, nlh, table,
+							      chain, rule,
+							      NFT_MSG_NEWRULE,
+							      0,
+							      nfmsg->nfgen_family);
+					continue;
+				}
+
+				/* This rule is in the past, get rid of it */
+				list_del_rcu(&rule->list);
+				nf_tables_rule_notify(skb, nlh, table, chain,
+						      rule, NFT_MSG_DELRULE, 0,
+						      family);
+				nf_tables_rule_destroy(rule);
+			}
 		}
 	}
 
 	return 0;
 }
 
+static int nf_tables_abort(struct sock *nlsk, struct sk_buff *skb,
+			   const struct nlmsghdr *nlh,
+			   const struct nlattr * const nla[])
+{
+	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
+	const struct nft_af_info *afi;
+	struct net *net = sock_net(skb->sk);
+	struct nft_table *table;
+	struct nft_chain *chain;
+	struct nft_rule *rule, *tmp;
+	bool create;
+
+	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
+
+	afi = nf_tables_afinfo_lookup(net, nfmsg->nfgen_family, create);
+	if (IS_ERR(afi))
+		return PTR_ERR(afi);
+
+	list_for_each_entry(table, &afi->tables, list) {
+		list_for_each_entry(chain, &table->chains, list) {
+			list_for_each_entry_safe(rule, tmp, &chain->dirty_rules, dirty_list) {
+				/* Delete all rules from the dirty list */
+				list_del(&rule->dirty_list);
+
+				if (!nft_rule_is_active_next(net, rule)) {
+					nft_rule_clear(net, rule);
+					continue;
+				}
+
+				/* This rule is inactive, get rid of it */
+				list_del_rcu(&rule->list);
+				nf_tables_rule_destroy(rule);
+			}
+		}
+	}
+	return 0;
+}
+
 /*
  * Sets
  */
@@ -2477,6 +2662,16 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
 		.policy		= nft_set_elem_list_policy,
 	},
+	[NFT_MSG_COMMIT] = {
+		.call		= nf_tables_commit,
+		.attr_count	= NFTA_TABLE_MAX,
+		.policy		= nft_rule_policy,
+	},
+	[NFT_MSG_ABORT] = {
+		.call		= nf_tables_abort,
+		.attr_count	= NFTA_TABLE_MAX,
+		.policy		= nft_rule_policy,
+	},
 };
 
 static const struct nfnetlink_subsystem nf_tables_subsys = {
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index b9917b7..a3f848f 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -72,12 +72,22 @@ nft_do_chain_pktinfo(struct nft_pktinfo *pkt, const struct nf_hook_ops *ops)
 		const struct nft_chain	*chain;
 		const struct nft_rule	*rule;
 	} jumpstack[NFT_JUMP_STACK_SIZE];
+	/*
+	 * Cache cursor to avoid problems in case that the cursor is updated
+	 * while traversing the ruleset.
+	 */
+	unsigned int gencursor = chain->net->nft.gencursor;
 
 do_chain:
 	rule = list_entry(&chain->rules, struct nft_rule, list);
 next_rule:
 	data[NFT_REG_VERDICT].verdict = NFT_CONTINUE;
 	list_for_each_entry_continue_rcu(rule, &chain->rules, list) {
+
+		/* This rule is not active, skip. */
+		if (unlikely(rule->genmask & (1 << gencursor)))
+			continue;
+
 		nft_rule_for_each_expr(expr, last, rule) {
 			if (expr->ops == &nft_cmp_fast_ops)
 				nft_cmp_fast_eval(expr, data);
-- 
1.7.10.4

