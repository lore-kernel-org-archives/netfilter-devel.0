From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/8] netfilter: nf_tables: add message type to transactions
Date: Sun, 30 Mar 2014 14:04:49 +0200
Message-ID: <1396181094-8140-4-git-send-email-pablo@netfilter.org>
References: <1396181094-8140-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45390 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbaC3MFH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Mar 2014 08:05:07 -0400
In-Reply-To: <1396181094-8140-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The patch adds message type to the transaction to simplify the
commit the and abort routines.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |    2 ++
 net/netfilter/nf_tables_api.c     |   71 +++++++++++++++++++++----------------
 2 files changed, 42 insertions(+), 31 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 4b28242..04d24e6 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -344,10 +344,12 @@ struct nft_rule {
  *	struct nft_trans - nf_tables object update in transaction
  *
  *	@list: used internally
+ *	@msg_type: message type
  *	@ctx: rule context
  */
 struct nft_trans {
 	struct list_head		list;
+	int				msg_type;
 	struct nft_ctx			ctx;
 	union {
 		struct nft_rule		*rule;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c67d504..4fce8d9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -105,7 +105,7 @@ static void nft_ctx_init(struct nft_ctx *ctx,
 	ctx->nla   = nla;
 }
 
-static struct nft_trans *nft_trans_alloc(struct nft_ctx *ctx)
+static struct nft_trans *nft_trans_alloc(struct nft_ctx *ctx, int msg_type)
 {
 	struct nft_trans *trans;
 
@@ -114,6 +114,7 @@ static struct nft_trans *nft_trans_alloc(struct nft_ctx *ctx)
 		return NULL;
 
 	trans->ctx	= *ctx;
+	trans->msg_type = msg_type;
 
 	return trans;
 }
@@ -1578,11 +1579,11 @@ static void nf_tables_rule_destroy(const struct nft_ctx *ctx,
 static struct nft_expr_info *info;
 
 static struct nft_trans *
-nft_rule_trans_add(struct nft_ctx *ctx, struct nft_rule *rule)
+nft_rule_trans_add(struct nft_ctx *ctx, int msg_type, struct nft_rule *rule)
 {
 	struct nft_trans *trans;
 
-	trans = nft_trans_alloc(ctx);
+	trans = nft_trans_alloc(ctx, msg_type);
 	if (trans == NULL)
 		return NULL;
 
@@ -1700,7 +1701,8 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 
 	if (nlh->nlmsg_flags & NLM_F_REPLACE) {
 		if (nft_rule_is_active_next(net, old_rule)) {
-			trans = nft_rule_trans_add(&ctx, old_rule);
+			trans = nft_rule_trans_add(&ctx, NFT_MSG_NEWRULE,
+						   old_rule);
 			if (trans == NULL) {
 				err = -ENOMEM;
 				goto err2;
@@ -1723,7 +1725,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 			list_add_rcu(&rule->list, &chain->rules);
 	}
 
-	if (nft_rule_trans_add(&ctx, rule) == NULL) {
+	if (nft_rule_trans_add(&ctx, NFT_MSG_NEWRULE, rule) == NULL) {
 		err = -ENOMEM;
 		goto err3;
 	}
@@ -1751,7 +1753,7 @@ nf_tables_delrule_one(struct nft_ctx *ctx, struct nft_rule *rule)
 {
 	/* You cannot delete the same rule twice */
 	if (nft_rule_is_active_next(ctx->net, rule)) {
-		if (nft_rule_trans_add(ctx, rule) == NULL)
+		if (nft_rule_trans_add(ctx, NFT_MSG_DELRULE, rule) == NULL)
 			return -ENOMEM;
 		nft_rule_disactivate_next(ctx->net, rule);
 		return 0;
@@ -2935,26 +2937,24 @@ static int nf_tables_commit(struct sk_buff *skb)
 	synchronize_rcu();
 
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
-		/* This rule was inactive in the past and just became active.
-		 * Clear the next bit of the genmask since its meaning has
-		 * changed, now it is the future.
-		 */
-		if (nft_rule_is_active(net, trans->rule)) {
-			nft_rule_clear(net, trans->rule);
-			nf_tables_rule_notify(skb, trans->ctx.nlh,
-					      trans->ctx.table, trans->ctx.chain,
+		switch (trans->msg_type) {
+		case NFT_MSG_NEWRULE:
+			nft_rule_clear(trans->ctx.net, trans->rule);
+			nf_tables_rule_notify(trans->ctx.skb, trans->ctx.nlh,
+					      trans->ctx.table,
+					      trans->ctx.chain,
 					      trans->rule, NFT_MSG_NEWRULE, 0,
 					      trans->ctx.afi->family);
-			nft_trans_destroy(trans);
-			continue;
+			break;
+		case NFT_MSG_DELRULE:
+			list_del_rcu(&trans->rule->list);
+			nf_tables_rule_notify(trans->ctx.skb, trans->ctx.nlh,
+					      trans->ctx.table,
+					      trans->ctx.chain,
+					      trans->rule, NFT_MSG_DELRULE, 0,
+					      trans->ctx.afi->family);
+			break;
 		}
-
-		/* This rule is in the past, get rid of it */
-		list_del_rcu(&trans->rule->list);
-		nf_tables_rule_notify(skb, trans->ctx.nlh,
-				      trans->ctx.table, trans->ctx.chain,
-				      trans->rule, NFT_MSG_DELRULE, 0,
-				      trans->ctx.afi->family);
 	}
 
 	/* Make sure we don't see any packet traversing old rules */
@@ -2962,7 +2962,11 @@ static int nf_tables_commit(struct sk_buff *skb)
 
 	/* Now we can safely release unused old rules */
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
-		nf_tables_rule_destroy(&trans->ctx, trans->rule);
+		switch (trans->msg_type) {
+		case NFT_MSG_DELRULE:
+			nf_tables_rule_destroy(&trans->ctx, trans->rule);
+			break;
+		}
 		nft_trans_destroy(trans);
 	}
 
@@ -2975,21 +2979,26 @@ static int nf_tables_abort(struct sk_buff *skb)
 	struct nft_trans *trans, *next;
 
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
-		if (!nft_rule_is_active_next(net, trans->rule)) {
-			nft_rule_clear(net, trans->rule);
+		switch (trans->msg_type) {
+		case NFT_MSG_NEWRULE:
+			list_del_rcu(&trans->rule->list);
+			break;
+		case NFT_MSG_DELRULE:
+			nft_rule_clear(trans->ctx.net, trans->rule);
 			nft_trans_destroy(trans);
-			continue;
+			break;
 		}
-
-		/* This rule is inactive, get rid of it */
-		list_del_rcu(&trans->rule->list);
 	}
 
 	/* Make sure we don't see any packet accessing aborted rules */
 	synchronize_rcu();
 
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
-		nf_tables_rule_destroy(&trans->ctx, trans->rule);
+		switch (trans->msg_type) {
+		case NFT_MSG_NEWRULE:
+			nf_tables_rule_destroy(&trans->ctx, trans->rule);
+			break;
+		}
 		nft_trans_destroy(trans);
 	}
 
-- 
1.7.10.4

