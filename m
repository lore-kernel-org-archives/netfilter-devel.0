From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -nftables v3 1/4] netfilter: nf_tables: get rid of per rule list_head for commits
Date: Wed, 18 Sep 2013 00:14:09 +0200
Message-ID: <1379456050-4016-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35371 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab3IQWOT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Sep 2013 18:14:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Get rid of the extra struct list_head per rule. With this patch, a
temporary object is allocated to store the rule update information.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: fix rule replacement case

 include/net/netfilter/nf_tables.h |   15 +++++-
 net/netfilter/nf_tables_api.c     |  100 +++++++++++++++++++++++++------------
 2 files changed, 82 insertions(+), 33 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 215edf5..fe08cf4 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -321,7 +321,6 @@ static inline void *nft_expr_priv(const struct nft_expr *expr)
  *	struct nft_rule - nf_tables rule
  *
  *	@list: used internally
- *	@dirty_list: this rule needs an update after new generation
  *	@rcu_head: used internally for rcu
  *	@handle: rule handle
  *	@genmask: generation mask
@@ -330,7 +329,6 @@ static inline void *nft_expr_priv(const struct nft_expr *expr)
  */
 struct nft_rule {
 	struct list_head		list;
-	struct list_head		dirty_list;
 	struct rcu_head			rcu_head;
 	u64				handle:46,
 					genmask:2,
@@ -339,6 +337,19 @@ struct nft_rule {
 		__attribute__((aligned(__alignof__(struct nft_expr))));
 };
 
+/**
+ *	struct nft_rule_trans - nf_tables rule update in transaction
+ *
+ *	@list: used internally
+ *	@rule: rule that needs to be updated
+ *	@family: family expressesed as AF_*
+ */
+struct nft_rule_trans {
+	struct list_head		list;
+	struct nft_rule			*rule;
+	u8				family;
+};
+
 static inline struct nft_expr *nft_expr_first(const struct nft_rule *rule)
 {
 	return (struct nft_expr *)&rule->data[0];
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c5d0129..59079e0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1537,6 +1537,23 @@ static void nf_tables_rule_destroy(struct nft_rule *rule)
 
 static struct nft_expr_info *info;
 
+static struct nft_rule_trans *
+nf_tables_trans_add(struct nft_rule *rule, const struct nft_ctx *ctx)
+{
+	struct nft_rule_trans *rupd;
+	struct nft_chain *chain = (struct nft_chain *)ctx->chain;
+
+	rupd = kmalloc(sizeof(struct nft_rule_trans), GFP_KERNEL);
+	if (rupd == NULL)
+	       return NULL;
+
+	rupd->rule = rule;
+	rupd->family = ctx->afi->family;
+	list_add(&rupd->list, &chain->dirty_rules);
+
+	return rupd;
+}
+
 static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 			     const struct nlmsghdr *nlh,
 			     const struct nlattr * const nla[])
@@ -1547,6 +1564,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	struct nft_table *table;
 	struct nft_chain *chain;
 	struct nft_rule *rule, *old_rule = NULL;
+	struct nft_rule_trans *rupd = NULL;
 	struct nft_expr *expr;
 	struct nft_ctx ctx;
 	struct nlattr *tmp;
@@ -1646,6 +1664,9 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	if (nlh->nlmsg_flags & NLM_F_REPLACE) {
 		if (flags & NFT_RULE_F_COMMIT) {
 			nft_rule_disactivate_next(net, old_rule);
+			rupd = nf_tables_trans_add(old_rule, &ctx);
+			if (rupd == NULL)
+				goto err2;
 			list_add_tail_rcu(&rule->list, &chain->rules);
 		} else {
 			list_replace_rcu(&old_rule->list, &rule->list);
@@ -1663,9 +1684,12 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 			list_add_rcu(&rule->list, &chain->rules);
 	}
 
-	if (flags & NFT_RULE_F_COMMIT)
-		list_add(&rule->dirty_list, &chain->dirty_rules);
-	else {
+	if (flags & NFT_RULE_F_COMMIT) {
+		if (nf_tables_trans_add(rule, &ctx) == NULL) {
+			err = -ENOMEM;
+			goto err3;
+		}
+	} else {
 		nf_tables_rule_notify(skb, nlh, table, chain, rule,
 				      NFT_MSG_NEWRULE,
 				      nlh->nlmsg_flags & (NLM_F_APPEND | NLM_F_REPLACE),
@@ -1673,6 +1697,12 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	}
 	return 0;
 
+err3:
+	if (rupd) {
+		nft_rule_clear(net, rupd->rule);
+		list_del_rcu(&rupd->rule->list);
+		kfree(rupd);
+	}
 err2:
 	nf_tables_rule_destroy(rule);
 err1:
@@ -1683,14 +1713,15 @@ err1:
 	return err;
 }
 
-static void
+static int
 nf_tables_delrule_one(struct nft_ctx *ctx, struct nft_rule *rule, u32 flags)
 {
-	if (flags & NFT_RULE_F_COMMIT) {
-		struct nft_chain *chain = (struct nft_chain *)ctx->chain;
+	int err = 0;
 
+	if (flags & NFT_RULE_F_COMMIT) {
 		nft_rule_disactivate_next(ctx->net, rule);
-		list_add(&rule->dirty_list, &chain->dirty_rules);
+		if (nf_tables_trans_add(rule, ctx) == NULL)
+			err = -ENOMEM;
 	} else {
 		list_del_rcu(&rule->list);
 		nf_tables_rule_notify(ctx->skb, ctx->nlh, ctx->table,
@@ -1698,6 +1729,7 @@ nf_tables_delrule_one(struct nft_ctx *ctx, struct nft_rule *rule, u32 flags)
 				      0, ctx->afi->family);
 		nf_tables_rule_destroy(rule);
 	}
+	return err;
 }
 
 static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
@@ -1710,7 +1742,7 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 	const struct nft_table *table;
 	struct nft_chain *chain;
 	struct nft_rule *rule, *tmp;
-	int family = nfmsg->nfgen_family;
+	int family = nfmsg->nfgen_family, err = 0;
 	struct nft_ctx ctx;
 	u32 flags = 0;
 
@@ -1740,14 +1772,17 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 		if (IS_ERR(rule))
 			return PTR_ERR(rule);
 
-		nf_tables_delrule_one(&ctx, rule, flags);
+		err = nf_tables_delrule_one(&ctx, rule, flags);
 	} else {
 		/* Remove all rules in this chain */
-		list_for_each_entry_safe(rule, tmp, &chain->rules, list)
-			nf_tables_delrule_one(&ctx, rule, flags);
+		list_for_each_entry_safe(rule, tmp, &chain->rules, list) {
+			err = nf_tables_delrule_one(&ctx, rule, flags);
+			if (err < 0)
+				break;
+		}
 	}
 
-	return 0;
+	return err;
 }
 
 static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
@@ -1759,8 +1794,7 @@ static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
 	struct net *net = sock_net(skb->sk);
 	struct nft_table *table;
 	struct nft_chain *chain;
-	struct nft_rule *rule, *tmp;
-	int family = nfmsg->nfgen_family;
+	struct nft_rule_trans *rupd, *tmp;
 	bool create;
 
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
@@ -1782,31 +1816,33 @@ static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
 
 	list_for_each_entry(table, &afi->tables, list) {
 		list_for_each_entry(chain, &table->chains, list) {
-			list_for_each_entry_safe(rule, tmp, &chain->dirty_rules, dirty_list) {
+			list_for_each_entry_safe(rupd, tmp, &chain->dirty_rules, list) {
 				/* Delete this rule from the dirty list */
-				list_del(&rule->dirty_list);
+				list_del(&rupd->list);
 
 				/* This rule was inactive in the past and just
 				 * became active. Clear the next bit of the
 				 * genmask since its meaning has changed, now
 				 * it is the future.
 				 */
-				if (nft_rule_is_active(net, rule)) {
-					nft_rule_clear(net, rule);
+				if (nft_rule_is_active(net, rupd->rule)) {
+					nft_rule_clear(net, rupd->rule);
 					nf_tables_rule_notify(skb, nlh, table,
-							      chain, rule,
+							      chain, rupd->rule,
 							      NFT_MSG_NEWRULE,
 							      0,
-							      nfmsg->nfgen_family);
+							      rupd->family);
+					kfree(rupd);
 					continue;
 				}
 
 				/* This rule is in the past, get rid of it */
-				list_del_rcu(&rule->list);
+				list_del_rcu(&rupd->rule->list);
 				nf_tables_rule_notify(skb, nlh, table, chain,
-						      rule, NFT_MSG_DELRULE, 0,
-						      family);
-				nf_tables_rule_destroy(rule);
+						      rupd->rule, NFT_MSG_DELRULE, 0,
+						      rupd->family);
+				nf_tables_rule_destroy(rupd->rule);
+				kfree(rupd);
 			}
 		}
 	}
@@ -1823,7 +1859,7 @@ static int nf_tables_abort(struct sock *nlsk, struct sk_buff *skb,
 	struct net *net = sock_net(skb->sk);
 	struct nft_table *table;
 	struct nft_chain *chain;
-	struct nft_rule *rule, *tmp;
+	struct nft_rule_trans *rupd, *tmp;
 	bool create;
 
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
@@ -1834,18 +1870,20 @@ static int nf_tables_abort(struct sock *nlsk, struct sk_buff *skb,
 
 	list_for_each_entry(table, &afi->tables, list) {
 		list_for_each_entry(chain, &table->chains, list) {
-			list_for_each_entry_safe(rule, tmp, &chain->dirty_rules, dirty_list) {
+			list_for_each_entry_safe(rupd, tmp, &chain->dirty_rules, list) {
 				/* Delete all rules from the dirty list */
-				list_del(&rule->dirty_list);
+				list_del(&rupd->list);
 
-				if (!nft_rule_is_active_next(net, rule)) {
-					nft_rule_clear(net, rule);
+				if (!nft_rule_is_active_next(net, rupd->rule)) {
+					nft_rule_clear(net, rupd->rule);
+					kfree(rupd);
 					continue;
 				}
 
 				/* This rule is inactive, get rid of it */
-				list_del_rcu(&rule->list);
-				nf_tables_rule_destroy(rule);
+				list_del_rcu(&rupd->rule->list);
+				nf_tables_rule_destroy(rupd->rule);
+				kfree(rupd);
 			}
 		}
 	}
-- 
1.7.10.4

