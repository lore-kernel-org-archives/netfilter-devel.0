From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -nftables v2 1/4] netfilter: nf_tables: get rid of per rule list_head for commits
Date: Tue, 17 Sep 2013 12:43:10 +0200
Message-ID: <1379414593-17956-2-git-send-email-pablo@netfilter.org>
References: <1379414593-17956-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52633 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab3IQKn3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Sep 2013 06:43:29 -0400
In-Reply-To: <1379414593-17956-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Get rid of the extra struct list_head per rule. With this patch, a
temporary object is allocated to store the rule update information.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |   15 ++++++-
 net/netfilter/nf_tables_api.c     |   83 ++++++++++++++++++++++++-------------
 2 files changed, 67 insertions(+), 31 deletions(-)

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
index c5d0129..f099d0d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1537,6 +1537,22 @@ static void nf_tables_rule_destroy(struct nft_rule *rule)
 
 static struct nft_expr_info *info;
 
+static int nf_tables_trans_add(struct nft_rule *rule, const struct nft_ctx *ctx)
+{
+	struct nft_rule_trans *rupd;
+	struct nft_chain *chain = (struct nft_chain *)ctx->chain;
+
+	rupd = kmalloc(sizeof(struct nft_rule_trans), GFP_KERNEL);
+	if (rupd == NULL)
+	       return -ENOMEM;
+
+	rupd->rule = rule;
+	rupd->family = ctx->afi->family;
+	list_add(&rupd->list, &chain->dirty_rules);
+
+	return 0;
+}
+
 static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 			     const struct nlmsghdr *nlh,
 			     const struct nlattr * const nla[])
@@ -1664,7 +1680,9 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	}
 
 	if (flags & NFT_RULE_F_COMMIT)
-		list_add(&rule->dirty_list, &chain->dirty_rules);
+		err = nf_tables_trans_add(rule, &ctx);
+		if (err < 0)
+			goto err2;
 	else {
 		nf_tables_rule_notify(skb, nlh, table, chain, rule,
 				      NFT_MSG_NEWRULE,
@@ -1683,14 +1701,14 @@ err1:
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
+		err = nf_tables_trans_add(rule, ctx);
 	} else {
 		list_del_rcu(&rule->list);
 		nf_tables_rule_notify(ctx->skb, ctx->nlh, ctx->table,
@@ -1698,6 +1716,7 @@ nf_tables_delrule_one(struct nft_ctx *ctx, struct nft_rule *rule, u32 flags)
 				      0, ctx->afi->family);
 		nf_tables_rule_destroy(rule);
 	}
+	return err;
 }
 
 static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
@@ -1710,7 +1729,7 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 	const struct nft_table *table;
 	struct nft_chain *chain;
 	struct nft_rule *rule, *tmp;
-	int family = nfmsg->nfgen_family;
+	int family = nfmsg->nfgen_family, err = 0;
 	struct nft_ctx ctx;
 	u32 flags = 0;
 
@@ -1740,14 +1759,17 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
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
@@ -1759,8 +1781,7 @@ static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
 	struct net *net = sock_net(skb->sk);
 	struct nft_table *table;
 	struct nft_chain *chain;
-	struct nft_rule *rule, *tmp;
-	int family = nfmsg->nfgen_family;
+	struct nft_rule_trans *rupd, *tmp;
 	bool create;
 
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
@@ -1782,31 +1803,33 @@ static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
 
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
@@ -1823,7 +1846,7 @@ static int nf_tables_abort(struct sock *nlsk, struct sk_buff *skb,
 	struct net *net = sock_net(skb->sk);
 	struct nft_table *table;
 	struct nft_chain *chain;
-	struct nft_rule *rule, *tmp;
+	struct nft_rule_trans *rupd, *tmp;
 	bool create;
 
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
@@ -1834,18 +1857,20 @@ static int nf_tables_abort(struct sock *nlsk, struct sk_buff *skb,
 
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

