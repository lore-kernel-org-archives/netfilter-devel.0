From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 1/6] netfilter: nf_tables: add generic macros to check for generation mask
Date: Wed, 22 Jun 2016 13:14:27 +0200
Message-ID: <1466594072-24043-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44230 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbcFVLOl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 07:14:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 75DBB49224A
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 13:14:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 608479EBC3
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 13:14:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 043E59EBBA
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 13:14:37 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thus, we can reuse these to check the genmask of any object type, not
only rules. This is required now that tables, chain and sets will get a
generation mask field too in follow up patches.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 24 ++++++++++++++++++++
 net/netfilter/nf_tables_api.c     | 46 +++++++--------------------------------
 2 files changed, 32 insertions(+), 38 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index f7c291f..6b7ce3a 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -971,6 +971,30 @@ static inline u8 nft_genmask_cur(const struct net *net)
 #define NFT_GENMASK_ANY		((1 << 0) | (1 << 1))
 
 /*
+ * Generic transaction helpers
+ */
+
+/* Check if this object is currently active. */
+#define nft_is_active(__net, __obj)				\
+	(((__obj)->genmask & nft_genmask_cur(__net)) == 0)
+
+/* Check if this object is active in the next generation. */
+#define nft_is_active_next(__net, __obj)			\
+	(((__obj)->genmask & nft_genmask_next(__net)) == 0)
+
+/* This object becomes active in the next generation. */
+#define nft_activate_next(__net, __obj)				\
+	(__obj)->genmask = nft_genmask_cur(__net)
+
+/* This object becomes inactive in the next generation. */
+#define nft_deactivate_next(__net, __obj)			\
+        (__obj)->genmask = nft_genmask_next(__net)
+
+/* After committing the ruleset, clear the stale generation bit. */
+#define nft_clear(__net, __obj)					\
+	(__obj)->genmask &= ~nft_genmask_next(__net)
+
+/*
  * Set element transaction helpers
  */
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2c88187..bae7d67 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -234,42 +234,12 @@ static int nft_delchain(struct nft_ctx *ctx)
 	return err;
 }
 
-static inline bool
-nft_rule_is_active(struct net *net, const struct nft_rule *rule)
-{
-	return (rule->genmask & nft_genmask_cur(net)) == 0;
-}
-
-static inline int
-nft_rule_is_active_next(struct net *net, const struct nft_rule *rule)
-{
-	return (rule->genmask & nft_genmask_next(net)) == 0;
-}
-
-static inline void
-nft_rule_activate_next(struct net *net, struct nft_rule *rule)
-{
-	/* Now inactive, will be active in the future */
-	rule->genmask = nft_genmask_cur(net);
-}
-
-static inline void
-nft_rule_deactivate_next(struct net *net, struct nft_rule *rule)
-{
-	rule->genmask = nft_genmask_next(net);
-}
-
-static inline void nft_rule_clear(struct net *net, struct nft_rule *rule)
-{
-	rule->genmask &= ~nft_genmask_next(net);
-}
-
 static int
 nf_tables_delrule_deactivate(struct nft_ctx *ctx, struct nft_rule *rule)
 {
 	/* You cannot delete the same rule twice */
-	if (nft_rule_is_active_next(ctx->net, rule)) {
-		nft_rule_deactivate_next(ctx->net, rule);
+	if (nft_is_active_next(ctx->net, rule)) {
+		nft_deactivate_next(ctx->net, rule);
 		ctx->chain->use--;
 		return 0;
 	}
@@ -1898,7 +1868,7 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 		list_for_each_entry_rcu(table, &afi->tables, list) {
 			list_for_each_entry_rcu(chain, &table->chains, list) {
 				list_for_each_entry_rcu(rule, &chain->rules, list) {
-					if (!nft_rule_is_active(net, rule))
+					if (!nft_is_active(net, rule))
 						goto cont;
 					if (idx < s_idx)
 						goto cont;
@@ -2102,7 +2072,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 	if (rule == NULL)
 		goto err1;
 
-	nft_rule_activate_next(net, rule);
+	nft_activate_next(net, rule);
 
 	rule->handle = handle;
 	rule->dlen   = size;
@@ -2124,14 +2094,14 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 	}
 
 	if (nlh->nlmsg_flags & NLM_F_REPLACE) {
-		if (nft_rule_is_active_next(net, old_rule)) {
+		if (nft_is_active_next(net, old_rule)) {
 			trans = nft_trans_rule_add(&ctx, NFT_MSG_DELRULE,
 						   old_rule);
 			if (trans == NULL) {
 				err = -ENOMEM;
 				goto err2;
 			}
-			nft_rule_deactivate_next(net, old_rule);
+			nft_deactivate_next(net, old_rule);
 			chain->use--;
 			list_add_tail_rcu(&rule->list, &old_rule->list);
 		} else {
@@ -3979,7 +3949,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 						   trans->ctx.afi->nops);
 			break;
 		case NFT_MSG_NEWRULE:
-			nft_rule_clear(trans->ctx.net, nft_trans_rule(trans));
+			nft_clear(trans->ctx.net, nft_trans_rule(trans));
 			nf_tables_rule_notify(&trans->ctx,
 					      nft_trans_rule(trans),
 					      NFT_MSG_NEWRULE);
@@ -4115,7 +4085,7 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb)
 			break;
 		case NFT_MSG_DELRULE:
 			trans->ctx.chain->use++;
-			nft_rule_clear(trans->ctx.net, nft_trans_rule(trans));
+			nft_clear(trans->ctx.net, nft_trans_rule(trans));
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWSET:
-- 
2.1.4

