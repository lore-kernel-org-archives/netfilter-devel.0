From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/10] netfilter: nf_tables: use new transaction infrastructure to handle elements
Date: Fri,  4 Apr 2014 15:48:14 +0200
Message-ID: <1396619294-26212-11-git-send-email-pablo@netfilter.org>
References: <1396619294-26212-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48531 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbaDDNsg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Apr 2014 09:48:36 -0400
In-Reply-To: <1396619294-26212-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Leave the set content in consistent state if we fail to load the
batch. Use the new generic transaction infrastructure to achieve
this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |   10 ++++
 net/netfilter/nf_tables_api.c     |  106 ++++++++++++++++++++++++++++++++-----
 2 files changed, 102 insertions(+), 14 deletions(-)

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
index 8305bda..5235d2c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2983,8 +2983,26 @@ err:
 	return err;
 }
 
-static int nft_add_set_elem(const struct nft_ctx *ctx, struct nft_set *set,
-			    const struct nlattr *attr)
+static int nft_trans_elem_add(struct nft_ctx *ctx, int msg_type,
+			      struct nft_set *set, struct nft_set_elem *elem,
+			      struct list_head *trans_list)
+{
+	struct nft_trans *trans;
+
+	trans = nft_trans_alloc(ctx, msg_type, sizeof(struct nft_trans_elem));
+	if (trans == NULL)
+		return -ENOMEM;
+
+	nft_trans_elem_set(trans) = set;
+	nft_trans_elem(trans) = *elem;
+	list_add_tail(&trans->list, trans_list);
+
+	return 0;
+}
+
+static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
+			    const struct nlattr *attr,
+			    struct list_head *trans_list)
 {
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
 	struct nft_data_desc d1, d2;
@@ -3061,11 +3079,17 @@ static int nft_add_set_elem(const struct nft_ctx *ctx, struct nft_set *set,
 	err = set->ops->insert(set, &elem);
 	if (err < 0)
 		goto err3;
-	set->nelems++;
 
-	nf_tables_setelem_notify(ctx, set, &elem, NFT_MSG_NEWSETELEM, 0);
+	err = nft_trans_elem_add(ctx, NFT_MSG_NEWSETELEM, set, &elem,
+				 trans_list);
+	if (err < 0)
+		goto err4;
+
 	return 0;
 
+err4:
+	set->ops->get(set, &elem);
+	set->ops->remove(set, &elem);
 err3:
 	if (nla[NFTA_SET_ELEM_DATA] != NULL)
 		nft_data_uninit(&elem.data, d2.type);
@@ -3084,6 +3108,8 @@ static int nf_tables_newsetelem(struct sock *nlsk, struct sk_buff *skb,
 	struct nft_set *set;
 	struct nft_ctx ctx;
 	int rem, err;
+	LIST_HEAD(trans_list);
+	struct nft_trans *trans, *next;
 
 	err = nft_ctx_init_from_elemattr(&ctx, skb, nlh, nla, true);
 	if (err < 0)
@@ -3103,15 +3129,27 @@ static int nf_tables_newsetelem(struct sock *nlsk, struct sk_buff *skb,
 		return -EBUSY;
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-		err = nft_add_set_elem(&ctx, set, attr);
+		err = nft_add_set_elem(&ctx, set, attr, &trans_list);
 		if (err < 0)
-			return err;
+			goto err1;
 	}
+	list_splice(&trans_list, &ctx.net->nft.commit_list);
+
 	return 0;
+
+err1:
+	list_for_each_entry_safe(trans, next, &trans_list, list) {
+		set = nft_trans_elem_set(trans);
+		set->ops->get(set, &nft_trans_elem(trans));
+		set->ops->remove(set, &nft_trans_elem(trans));
+		nft_trans_destroy(trans);
+	}
+	return err;
 }
 
-static int nft_del_setelem(const struct nft_ctx *ctx, struct nft_set *set,
-			   const struct nlattr *attr)
+static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
+			   const struct nlattr *attr,
+			   struct list_head *trans_list)
 {
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
 	struct nft_data_desc desc;
@@ -3139,10 +3177,10 @@ static int nft_del_setelem(const struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		goto err2;
 
-	set->ops->remove(set, &elem);
-	set->nelems--;
-
-	nf_tables_setelem_notify(ctx, set, &elem, NFT_MSG_DELSETELEM, 0);
+	err = nft_trans_elem_add(ctx, NFT_MSG_DELSETELEM, set, &elem,
+				 trans_list);
+	if (err < 0)
+		goto err2;
 
 	nft_data_uninit(&elem.key, NFT_DATA_VALUE);
 	if (set->flags & NFT_SET_MAP)
@@ -3162,6 +3200,8 @@ static int nf_tables_delsetelem(struct sock *nlsk, struct sk_buff *skb,
 	struct nft_set *set;
 	struct nft_ctx ctx;
 	int rem, err;
+	LIST_HEAD(trans_list);
+	struct nft_trans *trans, *next;
 
 	err = nft_ctx_init_from_elemattr(&ctx, skb, nlh, nla, false);
 	if (err < 0)
@@ -3174,11 +3214,19 @@ static int nf_tables_delsetelem(struct sock *nlsk, struct sk_buff *skb,
 		return -EBUSY;
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-		err = nft_del_setelem(&ctx, set, attr);
+		err = nft_del_setelem(&ctx, set, attr, &trans_list);
 		if (err < 0)
-			return err;
+			goto err1;
 	}
+	list_splice(&trans_list, &ctx.net->nft.commit_list);
+
 	return 0;
+
+err1:
+	list_for_each_entry_safe(trans, next, &trans_list, list)
+		nft_trans_destroy(trans);
+
+	return err;
 }
 
 static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
@@ -3293,6 +3341,7 @@ static int nf_tables_commit(struct sk_buff *skb)
 {
 	struct net *net = sock_net(skb->sk);
 	struct nft_trans *trans, *next;
+	struct nft_set *set;
 
 	/* Bump generation counter, invalidate any dump in progress */
 	net->nft.genctr++;
@@ -3379,6 +3428,25 @@ static int nf_tables_commit(struct sk_buff *skb)
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
 
@@ -3412,6 +3480,7 @@ static int nf_tables_abort(struct sk_buff *skb)
 {
 	struct net *net = sock_net(skb->sk);
 	struct nft_trans *trans, *next;
+	struct nft_set *set;
 
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
 		switch (trans->msg_type) {
@@ -3461,6 +3530,15 @@ static int nf_tables_abort(struct sk_buff *skb)
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

