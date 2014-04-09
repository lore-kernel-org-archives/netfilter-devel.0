From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 11/11] netfilter: nf_tables: use new transaction infrastructure to handle elements
Date: Wed,  9 Apr 2014 20:36:12 +0200
Message-ID: <1397068572-3916-12-git-send-email-pablo@netfilter.org>
References: <1397068572-3916-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59231 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933885AbaDISg2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2014 14:36:28 -0400
In-Reply-To: <1397068572-3916-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Leave the set content in consistent state if we fail to load the
batch. Use the new generic transaction infrastructure to achieve
this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |   10 +++++
 net/netfilter/nf_tables_api.c     |   82 ++++++++++++++++++++++++++++++-------
 2 files changed, 78 insertions(+), 14 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 15bf745..b08f2a9 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -446,6 +446,16 @@ struct nft_trans_table {
 #define nft_trans_table_enable(trans)	\
 	(((struct nft_trans_table *)trans->data)->enable)
 
+struct nft_trans_elem {
+	struct nft_set		*set;
+	struct nft_set_elem	elem;
+};
+
+#define nft_trans_elem_set(trans)	\
+	(((struct nft_trans_elem *)trans->data)->set)
+#define nft_trans_elem(trans)	\
+	(((struct nft_trans_elem *)trans->data)->elem)
+
 static inline struct nft_expr *nft_expr_first(const struct nft_rule *rule)
 {
 	return (struct nft_expr *)&rule->data[0];
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0e1ac3a..5606ae30 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2985,7 +2985,21 @@ err:
 	return err;
 }
 
-static int nft_add_set_elem(const struct nft_ctx *ctx, struct nft_set *set,
+static struct nft_trans *nft_trans_elem_alloc(struct nft_ctx *ctx,
+					      int msg_type,
+					      struct nft_set *set)
+{
+	struct nft_trans *trans;
+
+	trans = nft_trans_alloc(ctx, msg_type, sizeof(struct nft_trans_elem));
+	if (trans == NULL)
+		return NULL;
+
+	nft_trans_elem_set(trans) = set;
+	return trans;
+}
+
+static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    const struct nlattr *attr)
 {
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
@@ -2993,6 +3007,7 @@ static int nft_add_set_elem(const struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_set_elem elem;
 	struct nft_set_binding *binding;
 	enum nft_registers dreg;
+	struct nft_trans *trans;
 	int err;
 
 	if (set->size && set->nelems == set->size)
@@ -3060,14 +3075,20 @@ static int nft_add_set_elem(const struct nft_ctx *ctx, struct nft_set *set,
 		}
 	}
 
+	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
+	if (trans == NULL)
+		goto err3;
+
 	err = set->ops->insert(set, &elem);
 	if (err < 0)
-		goto err3;
-	set->nelems++;
+		goto err4;
 
-	nf_tables_setelem_notify(ctx, set, &elem, NFT_MSG_NEWSETELEM, 0);
+	nft_trans_elem(trans) = elem;
+	list_add(&trans->list, &ctx->net->nft.commit_list);
 	return 0;
 
+err4:
+	kfree(trans);
 err3:
 	if (nla[NFTA_SET_ELEM_DATA] != NULL)
 		nft_data_uninit(&elem.data, d2.type);
@@ -3085,7 +3106,7 @@ static int nf_tables_newsetelem(struct sock *nlsk, struct sk_buff *skb,
 	const struct nlattr *attr;
 	struct nft_set *set;
 	struct nft_ctx ctx;
-	int rem, err;
+	int rem, err = 0;
 
 	err = nft_ctx_init_from_elemattr(&ctx, skb, nlh, nla, true);
 	if (err < 0)
@@ -3107,17 +3128,18 @@ static int nf_tables_newsetelem(struct sock *nlsk, struct sk_buff *skb,
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_add_set_elem(&ctx, set, attr);
 		if (err < 0)
-			return err;
+			break;
 	}
-	return 0;
+	return err;
 }
 
-static int nft_del_setelem(const struct nft_ctx *ctx, struct nft_set *set,
+static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 			   const struct nlattr *attr)
 {
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
 	struct nft_data_desc desc;
 	struct nft_set_elem elem;
+	struct nft_trans *trans;
 	int err;
 
 	err = nla_parse_nested(nla, NFTA_SET_ELEM_MAX, attr,
@@ -3141,10 +3163,12 @@ static int nft_del_setelem(const struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		goto err2;
 
-	set->ops->remove(set, &elem);
-	set->nelems--;
+	trans = nft_trans_elem_alloc(ctx, NFT_MSG_DELSETELEM, set);
+	if (trans == NULL)
+		goto err2;
 
-	nf_tables_setelem_notify(ctx, set, &elem, NFT_MSG_DELSETELEM, 0);
+	nft_trans_elem(trans) = elem;
+	list_add(&trans->list, &ctx->net->nft.commit_list);
 
 	nft_data_uninit(&elem.key, NFT_DATA_VALUE);
 	if (set->flags & NFT_SET_MAP)
@@ -3163,7 +3187,7 @@ static int nf_tables_delsetelem(struct sock *nlsk, struct sk_buff *skb,
 	const struct nlattr *attr;
 	struct nft_set *set;
 	struct nft_ctx ctx;
-	int rem, err;
+	int rem, err = 0;
 
 	err = nft_ctx_init_from_elemattr(&ctx, skb, nlh, nla, false);
 	if (err < 0)
@@ -3178,9 +3202,9 @@ static int nf_tables_delsetelem(struct sock *nlsk, struct sk_buff *skb,
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_del_setelem(&ctx, set, attr);
 		if (err < 0)
-			return err;
+			break;
 	}
-	return 0;
+	return err;
 }
 
 static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
@@ -3286,6 +3310,7 @@ static int nf_tables_commit(struct sk_buff *skb)
 {
 	struct net *net = sock_net(skb->sk);
 	struct nft_trans *trans, *next;
+	struct nft_set *set;
 
 	/* Bump generation counter, invalidate any dump in progress */
 	net->nft.genctr++;
@@ -3377,6 +3402,25 @@ static int nf_tables_commit(struct sk_buff *skb)
 			nf_tables_set_notify(&trans->ctx, nft_trans_set(trans),
 					     NFT_MSG_DELSET);
 			break;
+		case NFT_MSG_NEWSETELEM:
+			nft_trans_elem_set(trans)->nelems++;
+			nf_tables_setelem_notify(&trans->ctx,
+						 nft_trans_elem_set(trans),
+						 &nft_trans_elem(trans),
+						 NFT_MSG_NEWSETELEM, 0);
+			nft_trans_destroy(trans);
+			break;
+		case NFT_MSG_DELSETELEM:
+			nft_trans_elem_set(trans)->nelems--;
+			nf_tables_setelem_notify(&trans->ctx,
+						 nft_trans_elem_set(trans),
+						 &nft_trans_elem(trans),
+						 NFT_MSG_DELSETELEM, 0);
+			set = nft_trans_elem_set(trans);
+			set->ops->get(set, &nft_trans_elem(trans));
+			set->ops->remove(set, &nft_trans_elem(trans));
+			nft_trans_destroy(trans);
+			break;
 		}
 	}
 
@@ -3410,6 +3454,7 @@ static int nf_tables_abort(struct sk_buff *skb)
 {
 	struct net *net = sock_net(skb->sk);
 	struct nft_trans *trans, *next;
+	struct nft_set *set;
 
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
 		switch (trans->msg_type) {
@@ -3465,6 +3510,15 @@ static int nf_tables_abort(struct sk_buff *skb)
 				      &trans->ctx.table->sets);
 			nft_trans_destroy(trans);
 			break;
+		case NFT_MSG_NEWSETELEM:
+			set = nft_trans_elem_set(trans);
+			set->ops->get(set, &nft_trans_elem(trans));
+			set->ops->remove(set, &nft_trans_elem(trans));
+			nft_trans_destroy(trans);
+			break;
+		case NFT_MSG_DELSETELEM:
+			nft_trans_destroy(trans);
+			break;
 		}
 	}
 
-- 
1.7.10.4

