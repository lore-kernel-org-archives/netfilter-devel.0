From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/7] netfilter: nf_tables: better encapsulation for the rule transaction code
Date: Thu, 27 Mar 2014 22:53:14 +0100
Message-ID: <1395957197-4899-5-git-send-email-pablo@netfilter.org>
References: <1395957197-4899-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49513 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441AbaC0Vxh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Mar 2014 17:53:37 -0400
In-Reply-To: <1395957197-4899-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Another cleanup to accomodate set, chain and table transaction support.
Move the rule transaction code to several functions to avoid too large
commit and abort routines.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |  102 ++++++++++++++++++++++++++++-------------
 1 file changed, 69 insertions(+), 33 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9a0aad5..4d4d5fc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2915,6 +2915,32 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 	},
 };
 
+static void nft_rule_commit_update(struct net *net, struct sk_buff *skb,
+				   struct nft_trans *trans)
+{
+	/* This rule was inactive in the past and just became active.
+	 * Clear the next bit of the genmask since its meaning has
+	 * changed, now it is the future.
+	 */
+	if (nft_rule_is_active(net, trans->rule)) {
+		nft_rule_clear(net, trans->rule);
+		nf_tables_rule_notify(skb, trans->ctx.nlh,
+				      trans->ctx.table, trans->ctx.chain,
+				      trans->rule, NFT_MSG_NEWRULE, 0,
+				      trans->ctx.afi->family);
+		list_del(&trans->list);
+		kfree(trans);
+		return;
+	}
+
+	/* This rule is in the past, get rid of it */
+	list_del_rcu(&trans->rule->list);
+	nf_tables_rule_notify(skb, trans->ctx.nlh,
+			      trans->ctx.table, trans->ctx.chain,
+			      trans->rule, NFT_MSG_DELRULE, 0,
+			      trans->ctx.afi->family);
+}
+
 static int nf_tables_commit(struct sk_buff *skb)
 {
 	struct net *net = sock_net(skb->sk);
@@ -2927,70 +2953,80 @@ static int nf_tables_commit(struct sk_buff *skb)
 	net->nft.gencursor = gencursor_next(net);
 
 	/* Make sure all packets have left the previous generation before
-	 * purging old rules.
+	 * purging old objects.
 	 */
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
-					      trans->rule, NFT_MSG_NEWRULE, 0,
-					      trans->ctx.afi->family);
-			list_del(&trans->list);
-			kfree(trans);
-			continue;
+		switch (trans->type) {
+		case NFT_TRANS_RULE:
+			nft_rule_commit_update(net, skb, trans);
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
 
-	/* Make sure we don't see any packet traversing old rules */
+	/* Make sure we don't see any packet traversing old objects */
 	synchronize_rcu();
 
-	/* Now we can safely release unused old rules */
+	/* Now we can safely release unused old objects */
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
-		nf_tables_rule_destroy(&trans->ctx, trans->rule);
 		list_del(&trans->list);
+		switch (trans->type) {
+		case NFT_TRANS_RULE:
+			nf_tables_rule_destroy(&trans->ctx, trans->rule);
+			break;
+		}
 		kfree(trans);
 	}
 
 	return 0;
 }
 
+static void nft_rule_abort_undo(struct net *net, struct sk_buff *skb,
+				struct nft_trans *trans)
+{
+	/* This rule was scheduled for removal but this transaction has been
+	 * aborted, clear the rule generation bitmask and leave it in place.
+	 */
+	if (!nft_rule_is_active_next(net, trans->rule)) {
+		nft_rule_clear(net, trans->rule);
+		list_del(&trans->list);
+		kfree(trans);
+		return;
+	}
+
+	/* This rule was scheduled to be active in the next generation, but
+	 * this transaction was aborted, remove it from the list.
+	 */
+	list_del_rcu(&trans->rule->list);
+}
+
 static int nf_tables_abort(struct sk_buff *skb)
 {
 	struct net *net = sock_net(skb->sk);
 	struct nft_trans *trans, *next;
 
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
-		if (!nft_rule_is_active_next(net, trans->rule)) {
-			nft_rule_clear(net, trans->rule);
-			list_del(&trans->list);
-			kfree(trans);
-			continue;
+		switch (trans->type) {
+		case NFT_TRANS_RULE:
+			nft_rule_abort_undo(net, skb, trans);
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
 		list_del(&trans->list);
+		switch (trans->type) {
+		case NFT_TRANS_RULE:
+			/* Release new rules, already removed from the list,
+			 * that we couldn't activate.
+			 */
+			nf_tables_rule_destroy(&trans->ctx, trans->rule);
+			break;
+		}
 		kfree(trans);
 	}
 
-- 
1.7.10.4

