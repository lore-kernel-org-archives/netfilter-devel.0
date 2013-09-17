From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -nftables v2 2/4] netfilter: nf_tables: use per netns commit list
Date: Tue, 17 Sep 2013 12:43:11 +0200
Message-ID: <1379414593-17956-3-git-send-email-pablo@netfilter.org>
References: <1379414593-17956-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52642 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab3IQKna (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Sep 2013 06:43:30 -0400
In-Reply-To: <1379414593-17956-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Instead of one list per chain.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |    6 +-
 include/net/netns/nftables.h      |    1 +
 net/netfilter/nf_tables_api.c     |  109 +++++++++++++------------------------
 3 files changed, 44 insertions(+), 72 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index fe08cf4..6b644c2 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -342,11 +342,15 @@ struct nft_rule {
  *
  *	@list: used internally
  *	@rule: rule that needs to be updated
+ *	@chain: chain that this rule belongs to
+ *	@table: table for which this chain applies
  *	@family: family expressesed as AF_*
  */
 struct nft_rule_trans {
 	struct list_head		list;
 	struct nft_rule			*rule;
+	const struct nft_chain		*chain;
+	const struct nft_table		*table;
 	u8				family;
 };
 
@@ -383,7 +387,6 @@ enum nft_chain_flags {
  *	struct nft_chain - nf_tables chain
  *
  *	@rules: list of rules in the chain
- *	@dirty_rules: rules that need an update after next generation
  *	@list: used internally
  *	@rcu_head: used internally
  *	@net: net namespace that this chain belongs to
@@ -396,7 +399,6 @@ enum nft_chain_flags {
  */
 struct nft_chain {
 	struct list_head		rules;
-	struct list_head		dirty_rules;
 	struct list_head		list;
 	struct rcu_head			rcu_head;
 	struct net			*net;
diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
index 9b35901..15d056d 100644
--- a/include/net/netns/nftables.h
+++ b/include/net/netns/nftables.h
@@ -7,6 +7,7 @@ struct nft_af_info;
 
 struct netns_nftables {
 	struct list_head	af_info;
+	struct list_head	commit_list;
 	struct nft_af_info	*ipv4;
 	struct nft_af_info	*ipv6;
 	struct nft_af_info	*arp;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f099d0d..8c78d36 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -976,7 +976,6 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 	}
 
 	INIT_LIST_HEAD(&chain->rules);
-	INIT_LIST_HEAD(&chain->dirty_rules);
 	chain->handle = nf_tables_alloc_handle(table);
 	chain->net = net;
 	chain->table = table;
@@ -1540,15 +1539,16 @@ static struct nft_expr_info *info;
 static int nf_tables_trans_add(struct nft_rule *rule, const struct nft_ctx *ctx)
 {
 	struct nft_rule_trans *rupd;
-	struct nft_chain *chain = (struct nft_chain *)ctx->chain;
 
 	rupd = kmalloc(sizeof(struct nft_rule_trans), GFP_KERNEL);
 	if (rupd == NULL)
 	       return -ENOMEM;
 
+	rupd->chain = ctx->chain;
+	rupd->table = ctx->table;
 	rupd->rule = rule;
 	rupd->family = ctx->afi->family;
-	list_add(&rupd->list, &chain->dirty_rules);
+	list_add(&rupd->list, &ctx->net->nft.commit_list);
 
 	return 0;
 }
@@ -1776,19 +1776,8 @@ static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
 			    const struct nlmsghdr *nlh,
 			    const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	const struct nft_af_info *afi;
 	struct net *net = sock_net(skb->sk);
-	struct nft_table *table;
-	struct nft_chain *chain;
 	struct nft_rule_trans *rupd, *tmp;
-	bool create;
-
-	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
-
-	afi = nf_tables_afinfo_lookup(net, nfmsg->nfgen_family, create);
-	if (IS_ERR(afi))
-		return PTR_ERR(afi);
 
 	/* Bump generation counter, invalidate any dump in progress */
 	net->nft.genctr++;
@@ -1801,37 +1790,31 @@ static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
 	 */
 	synchronize_rcu();
 
-	list_for_each_entry(table, &afi->tables, list) {
-		list_for_each_entry(chain, &table->chains, list) {
-			list_for_each_entry_safe(rupd, tmp, &chain->dirty_rules, list) {
-				/* Delete this rule from the dirty list */
-				list_del(&rupd->list);
-
-				/* This rule was inactive in the past and just
-				 * became active. Clear the next bit of the
-				 * genmask since its meaning has changed, now
-				 * it is the future.
-				 */
-				if (nft_rule_is_active(net, rupd->rule)) {
-					nft_rule_clear(net, rupd->rule);
-					nf_tables_rule_notify(skb, nlh, table,
-							      chain, rupd->rule,
-							      NFT_MSG_NEWRULE,
-							      0,
-							      rupd->family);
-					kfree(rupd);
-					continue;
-				}
+	list_for_each_entry_safe(rupd, tmp, &net->nft.commit_list, list) {
+		/* Delete this rule from the dirty list */
+		list_del(&rupd->list);
 
-				/* This rule is in the past, get rid of it */
-				list_del_rcu(&rupd->rule->list);
-				nf_tables_rule_notify(skb, nlh, table, chain,
-						      rupd->rule, NFT_MSG_DELRULE, 0,
-						      rupd->family);
-				nf_tables_rule_destroy(rupd->rule);
-				kfree(rupd);
-			}
+		/* This rule was inactive in the past and just became active.
+		 * Clear the next bit of the genmask since its meaning has
+		 * changed, now it is the future.
+		 */
+		if (nft_rule_is_active(net, rupd->rule)) {
+			nft_rule_clear(net, rupd->rule);
+			nf_tables_rule_notify(skb, nlh, rupd->table,
+					      rupd->chain, rupd->rule,
+					      NFT_MSG_NEWRULE, 0,
+					      rupd->family);
+			kfree(rupd);
+			continue;
 		}
+
+		/* This rule is in the past, get rid of it */
+		list_del_rcu(&rupd->rule->list);
+		nf_tables_rule_notify(skb, nlh, rupd->table, rupd->chain,
+				      rupd->rule, NFT_MSG_DELRULE, 0,
+				      rupd->family);
+		nf_tables_rule_destroy(rupd->rule);
+		kfree(rupd);
 	}
 
 	return 0;
@@ -1841,38 +1824,23 @@ static int nf_tables_abort(struct sock *nlsk, struct sk_buff *skb,
 			   const struct nlmsghdr *nlh,
 			   const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	const struct nft_af_info *afi;
 	struct net *net = sock_net(skb->sk);
-	struct nft_table *table;
-	struct nft_chain *chain;
 	struct nft_rule_trans *rupd, *tmp;
-	bool create;
-
-	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
-
-	afi = nf_tables_afinfo_lookup(net, nfmsg->nfgen_family, create);
-	if (IS_ERR(afi))
-		return PTR_ERR(afi);
 
-	list_for_each_entry(table, &afi->tables, list) {
-		list_for_each_entry(chain, &table->chains, list) {
-			list_for_each_entry_safe(rupd, tmp, &chain->dirty_rules, list) {
-				/* Delete all rules from the dirty list */
-				list_del(&rupd->list);
-
-				if (!nft_rule_is_active_next(net, rupd->rule)) {
-					nft_rule_clear(net, rupd->rule);
-					kfree(rupd);
-					continue;
-				}
+	list_for_each_entry_safe(rupd, tmp, &net->nft.commit_list, list) {
+		/* Delete all rules from the dirty list */
+		list_del(&rupd->list);
 
-				/* This rule is inactive, get rid of it */
-				list_del_rcu(&rupd->rule->list);
-				nf_tables_rule_destroy(rupd->rule);
-				kfree(rupd);
-			}
+		if (!nft_rule_is_active_next(net, rupd->rule)) {
+			nft_rule_clear(net, rupd->rule);
+			kfree(rupd);
+			continue;
 		}
+
+		/* This rule is inactive, get rid of it */
+		list_del_rcu(&rupd->rule->list);
+		nf_tables_rule_destroy(rupd->rule);
+		kfree(rupd);
 	}
 	return 0;
 }
@@ -3224,6 +3192,7 @@ EXPORT_SYMBOL_GPL(nft_data_dump);
 static int nf_tables_init_net(struct net *net)
 {
 	INIT_LIST_HEAD(&net->nft.af_info);
+	INIT_LIST_HEAD(&net->nft.commit_list);
 	return 0;
 }
 
-- 
1.7.10.4

