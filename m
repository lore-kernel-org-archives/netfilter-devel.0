From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 1/4] netfilter: nf_tables: get rid of jump label to return
Date: Fri, 28 Apr 2017 15:46:53 +0200
Message-ID: <1493387215-8285-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56984 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755527AbdD1NrO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Apr 2017 09:47:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4C5DF209918
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 15:47:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3C9191850E
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 15:47:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0870C1850E
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 15:47:04 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Several spots in the code use goto statements to return the error,
remove them.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 89 +++++++++++++++++++------------------------
 1 file changed, 40 insertions(+), 49 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 434c739dfeca..deeddb3e9546 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -714,14 +714,13 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 			return -EINVAL;
 	}
 
-	err = -EAFNOSUPPORT;
 	if (!try_module_get(afi->owner))
-		goto err1;
+		return -EAFNOSUPPORT;
 
 	err = -ENOMEM;
 	table = kzalloc(sizeof(*table), GFP_KERNEL);
 	if (table == NULL)
-		goto err2;
+		goto err1;
 
 	nla_strlcpy(table->name, name, NFT_TABLE_MAXNAMELEN);
 	INIT_LIST_HEAD(&table->chains);
@@ -732,15 +731,14 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 	nft_ctx_init(&ctx, net, skb, nlh, afi, table, NULL, nla);
 	err = nft_trans_table_add(&ctx, NFT_MSG_NEWTABLE);
 	if (err < 0)
-		goto err3;
+		goto err2;
 
 	list_add_tail_rcu(&table->list, &afi->tables);
 	return 0;
-err3:
-	kfree(table);
 err2:
-	module_put(afi->owner);
+	kfree(table);
 err1:
+	module_put(afi->owner);
 	return err;
 }
 
@@ -1796,23 +1794,22 @@ struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
 
 	err = nf_tables_expr_parse(ctx, nla, &info);
 	if (err < 0)
-		goto err1;
+		return ERR_PTR(err);
 
 	err = -ENOMEM;
 	expr = kzalloc(info.ops->size, GFP_KERNEL);
 	if (expr == NULL)
-		goto err2;
+		goto err1;
 
 	err = nf_tables_newexpr(ctx, &info, expr);
 	if (err < 0)
-		goto err3;
+		goto err2;
 
 	return expr;
-err3:
-	kfree(expr);
 err2:
-	module_put(info.ops->type->owner);
+	kfree(expr);
 err1:
+	module_put(info.ops->type->owner);
 	return ERR_PTR(err);
 }
 
@@ -3652,10 +3649,10 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	err = nft_data_init(ctx, &elem.key.val, sizeof(elem.key), &d1,
 			    nla[NFTA_SET_ELEM_KEY]);
 	if (err < 0)
-		goto err1;
+		return err;
 	err = -EINVAL;
 	if (d1.type != NFT_DATA_VALUE || d1.len != set->klen)
-		goto err2;
+		goto err1;
 
 	nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, d1.len);
 	if (timeout > 0) {
@@ -3667,13 +3664,13 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (nla[NFTA_SET_ELEM_OBJREF] != NULL) {
 		if (!(set->flags & NFT_SET_OBJECT)) {
 			err = -EINVAL;
-			goto err2;
+			goto err1;
 		}
 		obj = nf_tables_obj_lookup(ctx->table, nla[NFTA_SET_ELEM_OBJREF],
 					   set->objtype, genmask);
 		if (IS_ERR(obj)) {
 			err = PTR_ERR(obj);
-			goto err2;
+			goto err1;
 		}
 		nft_set_ext_add(&tmpl, NFT_SET_EXT_OBJREF);
 	}
@@ -3682,11 +3679,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		err = nft_data_init(ctx, &data, sizeof(data), &d2,
 				    nla[NFTA_SET_ELEM_DATA]);
 		if (err < 0)
-			goto err2;
+			goto err1;
 
 		err = -EINVAL;
 		if (set->dtype != NFT_DATA_VERDICT && d2.len != set->dlen)
-			goto err3;
+			goto err2;
 
 		dreg = nft_type_to_reg(set->dtype);
 		list_for_each_entry(binding, &set->bindings, list) {
@@ -3704,7 +3701,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 							  &data,
 							  d2.type, d2.len);
 			if (err < 0)
-				goto err3;
+				goto err2;
 		}
 
 		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_DATA, d2.len);
@@ -3726,7 +3723,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	elem.priv = nft_set_elem_init(set, &tmpl, elem.key.val.data, data.data,
 				      timeout, GFP_KERNEL);
 	if (elem.priv == NULL)
-		goto err3;
+		goto err2;
 
 	ext = nft_set_elem_ext(set, elem.priv);
 	if (flags)
@@ -3743,7 +3740,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
 	if (trans == NULL)
-		goto err4;
+		goto err3;
 
 	ext->genmask = nft_genmask_cur(ctx->net) | NFT_SET_ELEM_BUSY_MASK;
 	err = set->ops->insert(ctx->net, set, &elem, &ext2);
@@ -3760,31 +3757,30 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			else if (!(nlmsg_flags & NLM_F_EXCL))
 				err = 0;
 		}
-		goto err5;
+		goto err4;
 	}
 
 	if (set->size &&
 	    !atomic_add_unless(&set->nelems, 1, set->size + set->ndeact)) {
 		err = -ENFILE;
-		goto err6;
+		goto err5;
 	}
 
 	nft_trans_elem(trans) = elem;
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 	return 0;
 
-err6:
-	set->ops->remove(ctx->net, set, &elem);
 err5:
-	kfree(trans);
+	set->ops->remove(ctx->net, set, &elem);
 err4:
-	kfree(elem.priv);
+	kfree(trans);
 err3:
+	kfree(elem.priv);
+err2:
 	if (nla[NFTA_SET_ELEM_DATA] != NULL)
 		nft_data_uninit(&data, d2.type);
-err2:
-	nft_data_uninit(&elem.key.val, d1.type);
 err1:
+	nft_data_uninit(&elem.key.val, d1.type);
 	return err;
 }
 
@@ -3844,11 +3840,10 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	err = nla_parse_nested(nla, NFTA_SET_ELEM_MAX, attr,
 			       nft_set_elem_policy);
 	if (err < 0)
-		goto err1;
+		return err;
 
-	err = -EINVAL;
 	if (nla[NFTA_SET_ELEM_KEY] == NULL)
-		goto err1;
+		return -EINVAL;
 
 	nft_set_ext_prepare(&tmpl);
 
@@ -3861,11 +3856,11 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	err = nft_data_init(ctx, &elem.key.val, sizeof(elem.key), &desc,
 			    nla[NFTA_SET_ELEM_KEY]);
 	if (err < 0)
-		goto err1;
+		return err;
 
 	err = -EINVAL;
 	if (desc.type != NFT_DATA_VALUE || desc.len != set->klen)
-		goto err2;
+		goto err1;
 
 	nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, desc.len);
 
@@ -3873,7 +3868,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	elem.priv = nft_set_elem_init(set, &tmpl, elem.key.val.data, NULL, 0,
 				      GFP_KERNEL);
 	if (elem.priv == NULL)
-		goto err2;
+		goto err1;
 
 	ext = nft_set_elem_ext(set, elem.priv);
 	if (flags)
@@ -3882,13 +3877,13 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_DELSETELEM, set);
 	if (trans == NULL) {
 		err = -ENOMEM;
-		goto err3;
+		goto err2;
 	}
 
 	priv = set->ops->deactivate(ctx->net, set, &elem);
 	if (priv == NULL) {
 		err = -ENOENT;
-		goto err4;
+		goto err3;
 	}
 	kfree(elem.priv);
 	elem.priv = priv;
@@ -3897,13 +3892,12 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 	return 0;
 
-err4:
-	kfree(trans);
 err3:
-	kfree(elem.priv);
+	kfree(trans);
 err2:
-	nft_data_uninit(&elem.key.val, desc.type);
+	kfree(elem.priv);
 err1:
+	nft_data_uninit(&elem.key.val, desc.type);
 	return err;
 }
 
@@ -5563,10 +5557,8 @@ static int __init nf_tables_module_init(void)
 
 	info = kmalloc(sizeof(struct nft_expr_info) * NFT_RULE_MAXEXPRS,
 		       GFP_KERNEL);
-	if (info == NULL) {
-		err = -ENOMEM;
-		goto err1;
-	}
+	if (info == NULL)
+		return -ENOMEM;
 
 	err = nf_tables_core_module_init();
 	if (err < 0)
@@ -5578,11 +5570,10 @@ static int __init nf_tables_module_init(void)
 
 	pr_info("nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>\n");
 	return register_pernet_subsys(&nf_tables_net_ops);
-err3:
-	nf_tables_core_module_exit();
 err2:
-	kfree(info);
+	nf_tables_core_module_exit();
 err1:
+	kfree(info);
 	return err;
 }
 
-- 
2.1.4

