From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC] netfilter: nf_tables: defer all object release via rcu
Date: Thu, 10 Apr 2014 13:51:36 +0200
Message-ID: <1397130696-3760-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41345 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935510AbaDJLwB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Apr 2014 07:52:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now that all objects are released in the reverse order via the
transaction infrastructure, we can enqueue the release via
call_rcu to save one synchronize_rcu. For small rule-sets loaded
via nft -f, it now takes between 50ms and 100ms less here.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

This is a follow up patch that applies on top of the new transaction
infrastructure.

It has downside effect which is that I had to remove anonymous set event
notification since we lack of the skb/nlh/nla context from there.

I think we can adapt the nf_tables_set_notify to skip report and
portid when we don't have any context, so we still send events for the
anonymous sets. I believe the remaining pointers in the context area
should be valid for several reasons:

1) The objects are released in reverse order according to the commands.

2) We hold a reference to the afi family module, so the module has to be
   there until we delete the table, which should be the last object
   in the queue to be released.

3) The table and chain pointers should correspond to objects that still exists
   (they cannot be deleted as use counter is > 1) or that are in the rcu queue
   to be released after us.

That patch would be slightly larger though and set_notify needs to be
adjusted.

 include/net/netfilter/nf_tables.h |    2 +
 net/netfilter/nf_tables_api.c     |  100 ++++++++++++++++++++++---------------
 2 files changed, 62 insertions(+), 40 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index b08f2a9..65656f7 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -391,12 +391,14 @@ struct nft_rule {
 /**
  *	struct nft_trans - nf_tables object update in transaction
  *
+ *	rcu_head: rcu head to defer release of transaction data
  *	@list: used internally
  *	@msg_type: message type
  *	@ctx: transaction context
  *	@data: internal information related to the transaction
  */
 struct nft_trans {
+	struct rcu_head			rcu_head;
 	struct list_head		list;
 	int				msg_type;
 	struct nft_ctx			ctx;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5606ae30..fd03212 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2612,7 +2612,8 @@ static void nft_set_destroy(struct nft_set *set)
 static void nf_tables_set_destroy(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	list_del(&set->list);
-	nf_tables_set_notify(ctx, set, NFT_MSG_DELSET);
+	if (!set->flags & NFT_SET_ANONYMOUS)
+		nf_tables_set_notify(ctx, set, NFT_MSG_DELSET);
 	nft_set_destroy(set);
 }
 
@@ -3306,6 +3307,30 @@ static void nft_chain_commit_update(struct nft_trans *trans)
 	}
 }
 
+/* Schedule objects for release via rcu to make sure no packets are accesing
+ * removed and aborted rules.
+ */
+static void nf_tables_commit_release_rcu(struct rcu_head *rt)
+{
+	struct nft_trans *trans = container_of(rt, struct nft_trans, rcu_head);
+
+	switch (trans->msg_type) {
+	case NFT_MSG_DELTABLE:
+		nf_tables_table_destroy(&trans->ctx);
+		break;
+	case NFT_MSG_DELCHAIN:
+		nf_tables_chain_destroy(trans->ctx.chain);
+		break;
+	case NFT_MSG_DELRULE:
+		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
+		break;
+	case NFT_MSG_DELSET:
+		nft_set_destroy(nft_trans_set(trans));
+		break;
+	}
+	kfree(trans);
+}
+
 static int nf_tables_commit(struct sk_buff *skb)
 {
 	struct net *net = sock_net(skb->sk);
@@ -3424,32 +3449,41 @@ static int nf_tables_commit(struct sk_buff *skb)
 		}
 	}
 
-	/* Make sure we don't see any packet traversing old rules */
-	synchronize_rcu();
-
-	/* Now we can safely release unused old rules */
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
-		switch (trans->msg_type) {
-		case NFT_MSG_DELTABLE:
-			nf_tables_table_destroy(&trans->ctx);
-			break;
-		case NFT_MSG_DELCHAIN:
-			nf_tables_chain_destroy(trans->ctx.chain);
-			break;
-		case NFT_MSG_DELRULE:
-			nf_tables_rule_destroy(&trans->ctx,
-					       nft_trans_rule(trans));
-			break;
-		case NFT_MSG_DELSET:
-			nft_set_destroy(nft_trans_set(trans));
-			break;
-		}
-		nft_trans_destroy(trans);
+		list_del(&trans->list);
+		trans->ctx.skb = NULL;
+		trans->ctx.nlh = NULL;
+		trans->ctx.nla = NULL;
+		call_rcu(&trans->rcu_head, nf_tables_commit_release_rcu);
 	}
 
 	return 0;
 }
 
+/* Schedule objects for release via rcu to make sure no packets are accesing
+ * removed and aborted rules.
+ */
+static void nf_tables_abort_release_rcu(struct rcu_head *rt)
+{
+	struct nft_trans *trans = container_of(rt, struct nft_trans, rcu_head);
+
+	switch (trans->msg_type) {
+	case NFT_MSG_NEWTABLE:
+		nf_tables_table_destroy(&trans->ctx);
+		break;
+	case NFT_MSG_NEWCHAIN:
+		nf_tables_chain_destroy(trans->ctx.chain);
+		break;
+	case NFT_MSG_NEWRULE:
+		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
+		break;
+	case NFT_MSG_NEWSET:
+		nft_set_destroy(nft_trans_set(trans));
+		break;
+	}
+	kfree(trans);
+}
+
 static int nf_tables_abort(struct sk_buff *skb)
 {
 	struct net *net = sock_net(skb->sk);
@@ -3522,26 +3556,12 @@ static int nf_tables_abort(struct sk_buff *skb)
 		}
 	}
 
-	/* Make sure we don't see any packet accessing aborted rules */
-	synchronize_rcu();
-
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
-		switch (trans->msg_type) {
-		case NFT_MSG_NEWTABLE:
-			nf_tables_table_destroy(&trans->ctx);
-			break;
-		case NFT_MSG_NEWCHAIN:
-			nf_tables_chain_destroy(trans->ctx.chain);
-			break;
-		case NFT_MSG_NEWRULE:
-			nf_tables_rule_destroy(&trans->ctx,
-					       nft_trans_rule(trans));
-			break;
-		case NFT_MSG_NEWSET:
-			nft_set_destroy(nft_trans_set(trans));
-			break;
-		}
-		nft_trans_destroy(trans);
+		list_del(&trans->list);
+		trans->ctx.skb = NULL;
+		trans->ctx.nlh = NULL;
+		trans->ctx.nla = NULL;
+		call_rcu(&trans->rcu_head, nf_tables_abort_release_rcu);
 	}
 
 	return 0;
-- 
1.7.10.4

