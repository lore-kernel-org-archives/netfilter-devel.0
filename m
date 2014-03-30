From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/8] netfilter: nf_tables: relocate commit and abort routines in the source file
Date: Sun, 30 Mar 2014 14:04:48 +0200
Message-ID: <1396181094-8140-3-git-send-email-pablo@netfilter.org>
References: <1396181094-8140-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45388 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225AbaC3MFF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Mar 2014 08:05:05 -0400
In-Reply-To: <1396181094-8140-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Move the commit and abort routines to the bottom of the source code
file. This change is required by the follow up patches that add the
set, chain and table transaction support.

This patch is just a cleanup to access several functions without
having to declare their prototypes.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |  156 ++++++++++++++++++++---------------------
 1 file changed, 78 insertions(+), 78 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8b67d39..c67d504 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1824,84 +1824,6 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 	return err;
 }
 
-static int nf_tables_commit(struct sk_buff *skb)
-{
-	struct net *net = sock_net(skb->sk);
-	struct nft_trans *trans, *next;
-
-	/* Bump generation counter, invalidate any dump in progress */
-	net->nft.genctr++;
-
-	/* A new generation has just started */
-	net->nft.gencursor = gencursor_next(net);
-
-	/* Make sure all packets have left the previous generation before
-	 * purging old rules.
-	 */
-	synchronize_rcu();
-
-	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
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
-			nft_trans_destroy(trans);
-			continue;
-		}
-
-		/* This rule is in the past, get rid of it */
-		list_del_rcu(&trans->rule->list);
-		nf_tables_rule_notify(skb, trans->ctx.nlh,
-				      trans->ctx.table, trans->ctx.chain,
-				      trans->rule, NFT_MSG_DELRULE, 0,
-				      trans->ctx.afi->family);
-	}
-
-	/* Make sure we don't see any packet traversing old rules */
-	synchronize_rcu();
-
-	/* Now we can safely release unused old rules */
-	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
-		nf_tables_rule_destroy(&trans->ctx, trans->rule);
-		nft_trans_destroy(trans);
-	}
-
-	return 0;
-}
-
-static int nf_tables_abort(struct sk_buff *skb)
-{
-	struct net *net = sock_net(skb->sk);
-	struct nft_trans *trans, *next;
-
-	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
-		if (!nft_rule_is_active_next(net, trans->rule)) {
-			nft_rule_clear(net, trans->rule);
-			nft_trans_destroy(trans);
-			continue;
-		}
-
-		/* This rule is inactive, get rid of it */
-		list_del_rcu(&trans->rule->list);
-	}
-
-	/* Make sure we don't see any packet accessing aborted rules */
-	synchronize_rcu();
-
-	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
-		nf_tables_rule_destroy(&trans->ctx, trans->rule);
-		nft_trans_destroy(trans);
-	}
-
-	return 0;
-}
-
 /*
  * Sets
  */
@@ -2996,6 +2918,84 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 	},
 };
 
+static int nf_tables_commit(struct sk_buff *skb)
+{
+	struct net *net = sock_net(skb->sk);
+	struct nft_trans *trans, *next;
+
+	/* Bump generation counter, invalidate any dump in progress */
+	net->nft.genctr++;
+
+	/* A new generation has just started */
+	net->nft.gencursor = gencursor_next(net);
+
+	/* Make sure all packets have left the previous generation before
+	 * purging old rules.
+	 */
+	synchronize_rcu();
+
+	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
+		/* This rule was inactive in the past and just became active.
+		 * Clear the next bit of the genmask since its meaning has
+		 * changed, now it is the future.
+		 */
+		if (nft_rule_is_active(net, trans->rule)) {
+			nft_rule_clear(net, trans->rule);
+			nf_tables_rule_notify(skb, trans->ctx.nlh,
+					      trans->ctx.table, trans->ctx.chain,
+					      trans->rule, NFT_MSG_NEWRULE, 0,
+					      trans->ctx.afi->family);
+			nft_trans_destroy(trans);
+			continue;
+		}
+
+		/* This rule is in the past, get rid of it */
+		list_del_rcu(&trans->rule->list);
+		nf_tables_rule_notify(skb, trans->ctx.nlh,
+				      trans->ctx.table, trans->ctx.chain,
+				      trans->rule, NFT_MSG_DELRULE, 0,
+				      trans->ctx.afi->family);
+	}
+
+	/* Make sure we don't see any packet traversing old rules */
+	synchronize_rcu();
+
+	/* Now we can safely release unused old rules */
+	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
+		nf_tables_rule_destroy(&trans->ctx, trans->rule);
+		nft_trans_destroy(trans);
+	}
+
+	return 0;
+}
+
+static int nf_tables_abort(struct sk_buff *skb)
+{
+	struct net *net = sock_net(skb->sk);
+	struct nft_trans *trans, *next;
+
+	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
+		if (!nft_rule_is_active_next(net, trans->rule)) {
+			nft_rule_clear(net, trans->rule);
+			nft_trans_destroy(trans);
+			continue;
+		}
+
+		/* This rule is inactive, get rid of it */
+		list_del_rcu(&trans->rule->list);
+	}
+
+	/* Make sure we don't see any packet accessing aborted rules */
+	synchronize_rcu();
+
+	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
+		nf_tables_rule_destroy(&trans->ctx, trans->rule);
+		nft_trans_destroy(trans);
+	}
+
+	return 0;
+}
+
 static const struct nfnetlink_subsystem nf_tables_subsys = {
 	.name		= "nf_tables",
 	.subsys_id	= NFNL_SUBSYS_NFTABLES,
-- 
1.7.10.4

