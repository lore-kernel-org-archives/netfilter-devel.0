From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 2/4] netfilter: nf_tables: remove nft_data_uninit() on NFT_DATA_VALUE
Date: Fri, 28 Apr 2017 15:46:54 +0200
Message-ID: <1493387215-8285-2-git-send-email-pablo@netfilter.org>
References: <1493387215-8285-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56994 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1036048AbdD1Nr3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Apr 2017 09:47:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9E3C2209917
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 15:47:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C274185C75
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 15:47:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4E3A818FDB8
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 15:47:06 +0200 (CEST)
In-Reply-To: <1493387215-8285-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft_data_uninit on NFT_DATA_VALUE turns into no-op, and this happens
over and over again on set element keys, so let's remove this
unnecessary call. This sorts out an existing inconsistency in the tree
since expression like nft_bitwise that assume NFT_DATA_VALUE never call
nft_data_uninit() in their error path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 54 ++++++++++++++++++-------------------------
 net/netfilter/nft_range.c     | 20 +++++-----------
 2 files changed, 29 insertions(+), 45 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index deeddb3e9546..11b2cf664cd4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3561,7 +3561,6 @@ void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 {
 	struct nft_set_ext *ext = nft_set_elem_ext(set, elem);
 
-	nft_data_uninit(nft_set_ext_key(ext), NFT_DATA_VALUE);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
 		nft_data_uninit(nft_set_ext_data(ext), set->dtype);
 	if (destroy_expr && nft_set_ext_exists(ext, NFT_SET_EXT_EXPR))
@@ -3650,9 +3649,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    nla[NFTA_SET_ELEM_KEY]);
 	if (err < 0)
 		return err;
-	err = -EINVAL;
 	if (d1.type != NFT_DATA_VALUE || d1.len != set->klen)
-		goto err1;
+		return -EINVAL;
 
 	nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, d1.len);
 	if (timeout > 0) {
@@ -3662,16 +3660,14 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	}
 
 	if (nla[NFTA_SET_ELEM_OBJREF] != NULL) {
-		if (!(set->flags & NFT_SET_OBJECT)) {
-			err = -EINVAL;
-			goto err1;
-		}
+		if (!(set->flags & NFT_SET_OBJECT))
+			return -EINVAL;
+
 		obj = nf_tables_obj_lookup(ctx->table, nla[NFTA_SET_ELEM_OBJREF],
 					   set->objtype, genmask);
-		if (IS_ERR(obj)) {
-			err = PTR_ERR(obj);
-			goto err1;
-		}
+		if (IS_ERR(obj))
+			return PTR_ERR(obj);
+
 		nft_set_ext_add(&tmpl, NFT_SET_EXT_OBJREF);
 	}
 
@@ -3679,11 +3675,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		err = nft_data_init(ctx, &data, sizeof(data), &d2,
 				    nla[NFTA_SET_ELEM_DATA]);
 		if (err < 0)
-			goto err1;
+			return err;
 
 		err = -EINVAL;
 		if (set->dtype != NFT_DATA_VERDICT && d2.len != set->dlen)
-			goto err2;
+			goto err1;
 
 		dreg = nft_type_to_reg(set->dtype);
 		list_for_each_entry(binding, &set->bindings, list) {
@@ -3701,7 +3697,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 							  &data,
 							  d2.type, d2.len);
 			if (err < 0)
-				goto err2;
+				goto err1;
 		}
 
 		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_DATA, d2.len);
@@ -3723,7 +3719,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	elem.priv = nft_set_elem_init(set, &tmpl, elem.key.val.data, data.data,
 				      timeout, GFP_KERNEL);
 	if (elem.priv == NULL)
-		goto err2;
+		goto err1;
 
 	ext = nft_set_elem_ext(set, elem.priv);
 	if (flags)
@@ -3740,7 +3736,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
 	if (trans == NULL)
-		goto err3;
+		goto err2;
 
 	ext->genmask = nft_genmask_cur(ctx->net) | NFT_SET_ELEM_BUSY_MASK;
 	err = set->ops->insert(ctx->net, set, &elem, &ext2);
@@ -3757,30 +3753,28 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			else if (!(nlmsg_flags & NLM_F_EXCL))
 				err = 0;
 		}
-		goto err4;
+		goto err3;
 	}
 
 	if (set->size &&
 	    !atomic_add_unless(&set->nelems, 1, set->size + set->ndeact)) {
 		err = -ENFILE;
-		goto err5;
+		goto err4;
 	}
 
 	nft_trans_elem(trans) = elem;
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 	return 0;
 
-err5:
-	set->ops->remove(ctx->net, set, &elem);
 err4:
-	kfree(trans);
+	set->ops->remove(ctx->net, set, &elem);
 err3:
-	kfree(elem.priv);
+	kfree(trans);
 err2:
+	kfree(elem.priv);
+err1:
 	if (nla[NFTA_SET_ELEM_DATA] != NULL)
 		nft_data_uninit(&data, d2.type);
-err1:
-	nft_data_uninit(&elem.key.val, d1.type);
 	return err;
 }
 
@@ -3883,7 +3877,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	priv = set->ops->deactivate(ctx->net, set, &elem);
 	if (priv == NULL) {
 		err = -ENOENT;
-		goto err3;
+		goto err2;
 	}
 	kfree(elem.priv);
 	elem.priv = priv;
@@ -3892,12 +3886,10 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 	return 0;
 
-err3:
-	kfree(trans);
 err2:
-	kfree(elem.priv);
+	kfree(trans);
 err1:
-	nft_data_uninit(&elem.key.val, desc.type);
+	kfree(elem.priv);
 	return err;
 }
 
@@ -5562,11 +5554,11 @@ static int __init nf_tables_module_init(void)
 
 	err = nf_tables_core_module_init();
 	if (err < 0)
-		goto err2;
+		goto err1;
 
 	err = nfnetlink_subsys_register(&nf_tables_subsys);
 	if (err < 0)
-		goto err3;
+		goto err2;
 
 	pr_info("nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>\n");
 	return register_pernet_subsys(&nf_tables_net_ops);
diff --git a/net/netfilter/nft_range.c b/net/netfilter/nft_range.c
index 9edc74eedc10..114bb77b156a 100644
--- a/net/netfilter/nft_range.c
+++ b/net/netfilter/nft_range.c
@@ -73,39 +73,31 @@ static int nft_range_init(const struct nft_ctx *ctx, const struct nft_expr *expr
 	err = nft_data_init(NULL, &priv->data_to, sizeof(priv->data_to),
 			    &desc_to, tb[NFTA_RANGE_TO_DATA]);
 	if (err < 0)
-		goto err1;
+		return err;
 
-	if (desc_from.len != desc_to.len) {
-		err = -EINVAL;
-		goto err2;
-	}
+	if (desc_from.len != desc_to.len)
+		return -EINVAL;
 
 	priv->sreg = nft_parse_register(tb[NFTA_RANGE_SREG]);
 	err = nft_validate_register_load(priv->sreg, desc_from.len);
 	if (err < 0)
-		goto err2;
+		return err;
 
 	err = nft_parse_u32_check(tb[NFTA_RANGE_OP], U8_MAX, &op);
 	if (err < 0)
-		goto err2;
+		return err;
 
 	switch (op) {
 	case NFT_RANGE_EQ:
 	case NFT_RANGE_NEQ:
 		break;
 	default:
-		err = -EINVAL;
-		goto err2;
+		return -EINVAL;
 	}
 
 	priv->op  = op;
 	priv->len = desc_from.len;
 	return 0;
-err2:
-	nft_data_uninit(&priv->data_to, desc_to.type);
-err1:
-	nft_data_uninit(&priv->data_from, desc_from.type);
-	return err;
 }
 
 static int nft_range_dump(struct sk_buff *skb, const struct nft_expr *expr)
-- 
2.1.4

