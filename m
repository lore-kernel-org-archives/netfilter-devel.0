Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85186C41513
	for <netfilter-devel@archiver.kernel.org>; Sun, 13 Aug 2023 21:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbjHMVwy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 13 Aug 2023 17:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbjHMVu5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 13 Aug 2023 17:50:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1633AA1;
        Sun, 13 Aug 2023 14:48:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC56163F1C;
        Sun, 13 Aug 2023 21:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECFDC433C7;
        Sun, 13 Aug 2023 21:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1691963321;
        bh=On13n61MXvS0V1ZRhbnIt7pNX7A2dN1OCEVDqD8hBRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0WmWGEEMnJcUYBXRrMMHHDTgLNQhL5BvZAHhQ2z5F9x0AFkAPWOsRHwsjr0HVqTd8
         kN3B9nGRrii/j1UzZmI53MXQxQjnc5AsuEGfmZ7DQsEJHTdP9pWq/i/3DIyKw+8fLM
         SBG05Z+b3e8Mw1CN7NEBd7cRPsXHL28dh9ovpAVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 32/39] netfilter: nf_tables: report use refcount overflow
Date:   Sun, 13 Aug 2023 23:20:23 +0200
Message-ID: <20230813211705.902150875@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211704.796906808@linuxfoundation.org>
References: <20230813211704.796906808@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 1689f25924ada8fe14a4a82c38925d04994c7142 upstream.

Overflow use refcount checks are not complete.

Add helper function to deal with object reference counter tracking.
Report -EMFILE in case UINT_MAX is reached.

nft_use_dec() splats in case that reference counter underflows,
which should not ever happen.

Add nft_use_inc_restore() and nft_use_dec_restore() which are used
to restore reference counter from error and abort paths.

Use u32 in nft_flowtable and nft_object since helper functions cannot
work on bitfields.

Remove the few early incomplete checks now that the helper functions
are in place and used to check for refcount overflow.

Fixes: 96518518cc41 ("netfilter: add nftables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |   31 ++++++-
 net/netfilter/nf_tables_api.c     |  166 +++++++++++++++++++++++---------------
 net/netfilter/nft_flow_offload.c  |    6 -
 net/netfilter/nft_objref.c        |    8 +
 4 files changed, 140 insertions(+), 71 deletions(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1013,6 +1013,29 @@ int __nft_release_basechain(struct nft_c
 
 unsigned int nft_do_chain(struct nft_pktinfo *pkt, void *priv);
 
+static inline bool nft_use_inc(u32 *use)
+{
+	if (*use == UINT_MAX)
+		return false;
+
+	(*use)++;
+
+	return true;
+}
+
+static inline void nft_use_dec(u32 *use)
+{
+	WARN_ON_ONCE((*use)-- == 0);
+}
+
+/* For error and abort path: restore use counter to previous state. */
+static inline void nft_use_inc_restore(u32 *use)
+{
+	WARN_ON_ONCE(!nft_use_inc(use));
+}
+
+#define nft_use_dec_restore	nft_use_dec
+
 /**
  *	struct nft_table - nf_tables table
  *
@@ -1082,8 +1105,8 @@ struct nft_object {
 	struct list_head		list;
 	struct rhlist_head		rhlhead;
 	struct nft_object_hash_key	key;
-	u32				genmask:2,
-					use:30;
+	u32				genmask:2;
+	u32				use;
 	u64				handle;
 	/* runtime data below here */
 	const struct nft_object_ops	*ops ____cacheline_aligned;
@@ -1185,8 +1208,8 @@ struct nft_flowtable {
 	int				hooknum;
 	int				priority;
 	int				ops_len;
-	u32				genmask:2,
-					use:30;
+	u32				genmask:2;
+	u32				use;
 	u64				handle;
 	/* runtime data below here */
 	struct nf_hook_ops		*ops ____cacheline_aligned;
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -282,7 +282,7 @@ static int nft_delchain(struct nft_ctx *
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-	ctx->table->use--;
+	nft_use_dec(&ctx->table->use);
 	nft_deactivate_next(ctx->net, ctx->chain);
 
 	return 0;
@@ -323,7 +323,7 @@ nf_tables_delrule_deactivate(struct nft_
 	/* You cannot delete the same rule twice */
 	if (nft_is_active_next(ctx->net, rule)) {
 		nft_deactivate_next(ctx->net, rule);
-		ctx->chain->use--;
+		nft_use_dec(&ctx->chain->use);
 		return 0;
 	}
 	return -ENOENT;
@@ -412,7 +412,7 @@ static int nft_delset(const struct nft_c
 		return err;
 
 	nft_deactivate_next(ctx->net, set);
-	ctx->table->use--;
+	nft_use_dec(&ctx->table->use);
 
 	return err;
 }
@@ -444,7 +444,7 @@ static int nft_delobj(struct nft_ctx *ct
 		return err;
 
 	nft_deactivate_next(ctx->net, obj);
-	ctx->table->use--;
+	nft_use_dec(&ctx->table->use);
 
 	return err;
 }
@@ -478,7 +478,7 @@ static int nft_delflowtable(struct nft_c
 		return err;
 
 	nft_deactivate_next(ctx->net, flowtable);
-	ctx->table->use--;
+	nft_use_dec(&ctx->table->use);
 
 	return err;
 }
@@ -1715,9 +1715,6 @@ static int nf_tables_addchain(struct nft
 	struct nft_rule **rules;
 	int err;
 
-	if (table->use == UINT_MAX)
-		return -EOVERFLOW;
-
 	if (nla[NFTA_CHAIN_HOOK]) {
 		struct nft_chain_hook hook;
 		struct nf_hook_ops *ops;
@@ -1794,6 +1791,11 @@ static int nf_tables_addchain(struct nft
 	if (err < 0)
 		goto err1;
 
+	if (!nft_use_inc(&table->use)) {
+		err = -EMFILE;
+		goto err_use;
+	}
+
 	err = rhltable_insert_key(&table->chains_ht, chain->name,
 				  &chain->rhlhead, nft_chain_ht_params);
 	if (err)
@@ -1811,11 +1813,12 @@ static int nf_tables_addchain(struct nft
 	if (nft_is_base_chain(chain))
 		nft_trans_chain_policy(trans) = policy;
 
-	table->use++;
 	list_add_tail_rcu(&chain->list, &table->chains);
 
 	return 0;
 err2:
+	nft_use_dec_restore(&table->use);
+err_use:
 	nf_tables_unregister_hook(net, table, chain);
 err1:
 	nf_tables_chain_destroy(ctx);
@@ -2831,9 +2834,6 @@ static int nf_tables_newrule(struct net
 			return -EINVAL;
 		handle = nf_tables_alloc_handle(table);
 
-		if (chain->use == UINT_MAX)
-			return -EOVERFLOW;
-
 		if (nla[NFTA_RULE_POSITION]) {
 			pos_handle = be64_to_cpu(nla_get_be64(nla[NFTA_RULE_POSITION]));
 			old_rule = __nft_rule_lookup(chain, pos_handle);
@@ -2915,16 +2915,21 @@ static int nf_tables_newrule(struct net
 		expr = nft_expr_next(expr);
 	}
 
+	if (!nft_use_inc(&chain->use)) {
+		err = -EMFILE;
+		goto err2;
+	}
+
 	if (nlh->nlmsg_flags & NLM_F_REPLACE) {
 		trans = nft_trans_rule_add(&ctx, NFT_MSG_NEWRULE, rule);
 		if (trans == NULL) {
 			err = -ENOMEM;
-			goto err2;
+			goto err_destroy_flow_rule;
 		}
 		err = nft_delrule(&ctx, old_rule);
 		if (err < 0) {
 			nft_trans_destroy(trans);
-			goto err2;
+			goto err_destroy_flow_rule;
 		}
 
 		list_add_tail_rcu(&rule->list, &old_rule->list);
@@ -2932,7 +2937,7 @@ static int nf_tables_newrule(struct net
 		trans = nft_trans_rule_add(&ctx, NFT_MSG_NEWRULE, rule);
 		if (!trans) {
 			err = -ENOMEM;
-			goto err2;
+			goto err_destroy_flow_rule;
 		}
 
 		if (nlh->nlmsg_flags & NLM_F_APPEND) {
@@ -2948,7 +2953,6 @@ static int nf_tables_newrule(struct net
 		}
 	}
 	kvfree(info);
-	chain->use++;
 
 	if (nft_net->validate_state == NFT_VALIDATE_DO)
 		return nft_table_validate(net, table);
@@ -2962,6 +2966,9 @@ static int nf_tables_newrule(struct net
 	}
 
 	return 0;
+
+err_destroy_flow_rule:
+	nft_use_dec_restore(&chain->use);
 err2:
 	nft_rule_expr_deactivate(&ctx, rule, NFT_TRANS_PREPARE_ERROR);
 	nf_tables_rule_destroy(&ctx, rule);
@@ -3775,10 +3782,15 @@ static int nf_tables_newset(struct net *
 	if (ops->privsize != NULL)
 		size = ops->privsize(nla, &desc);
 
+	if (!nft_use_inc(&table->use)) {
+		err = -EMFILE;
+		goto err1;
+	}
+
 	set = kvzalloc(sizeof(*set) + size + udlen, GFP_KERNEL);
 	if (!set) {
 		err = -ENOMEM;
-		goto err1;
+		goto err_alloc;
 	}
 
 	name = nla_strdup(nla[NFTA_SET_NAME], GFP_KERNEL);
@@ -3825,7 +3837,7 @@ static int nf_tables_newset(struct net *
 		goto err4;
 
 	list_add_tail_rcu(&set->list, &table->sets);
-	table->use++;
+
 	return 0;
 
 err4:
@@ -3834,6 +3846,8 @@ err3:
 	kfree(set->name);
 err2:
 	kvfree(set);
+err_alloc:
+	nft_use_dec_restore(&table->use);
 err1:
 	module_put(to_set_type(ops)->owner);
 	return err;
@@ -3920,9 +3934,6 @@ int nf_tables_bind_set(const struct nft_
 	struct nft_set_binding *i;
 	struct nft_set_iter iter;
 
-	if (set->use == UINT_MAX)
-		return -EOVERFLOW;
-
 	if (!list_empty(&set->bindings) && nft_set_is_anonymous(set))
 		return -EBUSY;
 
@@ -3947,10 +3958,12 @@ int nf_tables_bind_set(const struct nft_
 			return iter.err;
 	}
 bind:
+	if (!nft_use_inc(&set->use))
+		return -EMFILE;
+
 	binding->chain = ctx->chain;
 	list_add_tail_rcu(&binding->list, &set->bindings);
 	nft_set_trans_bind(ctx, set);
-	set->use++;
 
 	return 0;
 }
@@ -3974,7 +3987,7 @@ void nf_tables_activate_set(const struct
 	if (nft_set_is_anonymous(set))
 		nft_clear(ctx->net, set);
 
-	set->use++;
+	nft_use_inc_restore(&set->use);
 }
 EXPORT_SYMBOL_GPL(nf_tables_activate_set);
 
@@ -3990,17 +4003,17 @@ void nf_tables_deactivate_set(const stru
 		else
 			list_del_rcu(&binding->list);
 
-		set->use--;
+		nft_use_dec(&set->use);
 		break;
 	case NFT_TRANS_PREPARE:
 		if (nft_set_is_anonymous(set))
 			nft_deactivate_next(ctx->net, set);
 
-		set->use--;
+		nft_use_dec(&set->use);
 		return;
 	case NFT_TRANS_ABORT:
 	case NFT_TRANS_RELEASE:
-		set->use--;
+		nft_use_dec(&set->use);
 		/* fall through */
 	default:
 		nf_tables_unbind_set(ctx, set, binding,
@@ -4585,7 +4598,7 @@ void nft_set_elem_destroy(const struct n
 		}
 	}
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF))
-		(*nft_set_ext_obj(ext))->use--;
+		nft_use_dec(&(*nft_set_ext_obj(ext))->use);
 	kfree(elem);
 }
 EXPORT_SYMBOL_GPL(nft_set_elem_destroy);
@@ -4706,8 +4719,16 @@ static int nft_add_set_elem(struct nft_c
 				     set->objtype, genmask);
 		if (IS_ERR(obj)) {
 			err = PTR_ERR(obj);
+			obj = NULL;
+			goto err2;
+		}
+
+		if (!nft_use_inc(&obj->use)) {
+			err = -EMFILE;
+			obj = NULL;
 			goto err2;
 		}
+
 		nft_set_ext_add(&tmpl, NFT_SET_EXT_OBJREF);
 	}
 
@@ -4772,10 +4793,8 @@ static int nft_add_set_elem(struct nft_c
 		udata->len = ulen - 1;
 		nla_memcpy(&udata->data, nla[NFTA_SET_ELEM_USERDATA], ulen);
 	}
-	if (obj) {
+	if (obj)
 		*nft_set_ext_obj(ext) = obj;
-		obj->use++;
-	}
 
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
 	if (trans == NULL)
@@ -4821,13 +4840,14 @@ err6:
 err5:
 	kfree(trans);
 err4:
-	if (obj)
-		obj->use--;
 	kfree(elem.priv);
 err3:
 	if (nla[NFTA_SET_ELEM_DATA] != NULL)
 		nft_data_release(&elem.data.val, desc.type);
 err2:
+	if (obj)
+		nft_use_dec_restore(&obj->use);
+
 	nft_data_release(&elem.key.val, NFT_DATA_VALUE);
 err1:
 	return err;
@@ -4887,11 +4907,14 @@ static int nf_tables_newsetelem(struct n
  */
 void nft_data_hold(const struct nft_data *data, enum nft_data_types type)
 {
+	struct nft_chain *chain;
+
 	if (type == NFT_DATA_VERDICT) {
 		switch (data->verdict.code) {
 		case NFT_JUMP:
 		case NFT_GOTO:
-			data->verdict.chain->use++;
+			chain = data->verdict.chain;
+			nft_use_inc_restore(&chain->use);
 			break;
 		}
 	}
@@ -4906,7 +4929,7 @@ static void nft_set_elem_activate(const
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
 		nft_data_hold(nft_set_ext_data(ext), set->dtype);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF))
-		(*nft_set_ext_obj(ext))->use++;
+		nft_use_inc_restore(&(*nft_set_ext_obj(ext))->use);
 }
 
 static void nft_set_elem_deactivate(const struct net *net,
@@ -4918,7 +4941,7 @@ static void nft_set_elem_deactivate(cons
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
 		nft_data_release(nft_set_ext_data(ext), set->dtype);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF))
-		(*nft_set_ext_obj(ext))->use--;
+		nft_use_dec(&(*nft_set_ext_obj(ext))->use);
 }
 
 static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
@@ -5375,9 +5398,14 @@ static int nf_tables_newobj(struct net *
 
 	nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
 
+	if (!nft_use_inc(&table->use))
+		return -EMFILE;
+
 	type = nft_obj_type_get(net, objtype);
-	if (IS_ERR(type))
-		return PTR_ERR(type);
+	if (IS_ERR(type)) {
+		err = PTR_ERR(type);
+		goto err_type;
+	}
 
 	obj = nft_obj_init(&ctx, type, nla[NFTA_OBJ_DATA]);
 	if (IS_ERR(obj)) {
@@ -5403,7 +5431,7 @@ static int nf_tables_newobj(struct net *
 		goto err4;
 
 	list_add_tail_rcu(&obj->list, &table->objects);
-	table->use++;
+
 	return 0;
 err4:
 	/* queued in transaction log */
@@ -5417,6 +5445,9 @@ err2:
 	kfree(obj);
 err1:
 	module_put(type->owner);
+err_type:
+	nft_use_dec_restore(&table->use);
+
 	return err;
 }
 
@@ -5761,7 +5792,7 @@ void nf_tables_deactivate_flowtable(cons
 	case NFT_TRANS_PREPARE:
 	case NFT_TRANS_ABORT:
 	case NFT_TRANS_RELEASE:
-		flowtable->use--;
+		nft_use_dec(&flowtable->use);
 		/* fall through */
 	default:
 		return;
@@ -5967,9 +5998,14 @@ static int nf_tables_newflowtable(struct
 
 	nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
 
+	if (!nft_use_inc(&table->use))
+		return -EMFILE;
+
 	flowtable = kzalloc(sizeof(*flowtable), GFP_KERNEL);
-	if (!flowtable)
-		return -ENOMEM;
+	if (!flowtable) {
+		err = -ENOMEM;
+		goto flowtable_alloc;
+	}
 
 	flowtable->table = table;
 	flowtable->handle = nf_tables_alloc_handle(table);
@@ -6023,7 +6059,6 @@ static int nf_tables_newflowtable(struct
 		goto err6;
 
 	list_add_tail_rcu(&flowtable->list, &table->flowtables);
-	table->use++;
 
 	return 0;
 err6:
@@ -6041,6 +6076,9 @@ err2:
 	kfree(flowtable->name);
 err1:
 	kfree(flowtable);
+flowtable_alloc:
+	nft_use_dec_restore(&table->use);
+
 	return err;
 }
 
@@ -7035,7 +7073,7 @@ static int nf_tables_commit(struct net *
 			 */
 			if (nft_set_is_anonymous(nft_trans_set(trans)) &&
 			    !list_empty(&nft_trans_set(trans)->bindings))
-				trans->ctx.table->use--;
+				nft_use_dec(&trans->ctx.table->use);
 
 			nf_tables_set_notify(&trans->ctx, nft_trans_set(trans),
 					     NFT_MSG_NEWSET, GFP_KERNEL);
@@ -7188,7 +7226,7 @@ static int __nf_tables_abort(struct net
 				kfree(nft_trans_chain_name(trans));
 				nft_trans_destroy(trans);
 			} else {
-				trans->ctx.table->use--;
+				nft_use_dec_restore(&trans->ctx.table->use);
 				nft_chain_del(trans->ctx.chain);
 				nf_tables_unregister_hook(trans->ctx.net,
 							  trans->ctx.table,
@@ -7196,25 +7234,25 @@ static int __nf_tables_abort(struct net
 			}
 			break;
 		case NFT_MSG_DELCHAIN:
-			trans->ctx.table->use++;
+			nft_use_inc_restore(&trans->ctx.table->use);
 			nft_clear(trans->ctx.net, trans->ctx.chain);
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWRULE:
-			trans->ctx.chain->use--;
+			nft_use_dec_restore(&trans->ctx.chain->use);
 			list_del_rcu(&nft_trans_rule(trans)->list);
 			nft_rule_expr_deactivate(&trans->ctx,
 						 nft_trans_rule(trans),
 						 NFT_TRANS_ABORT);
 			break;
 		case NFT_MSG_DELRULE:
-			trans->ctx.chain->use++;
+			nft_use_inc_restore(&trans->ctx.chain->use);
 			nft_clear(trans->ctx.net, nft_trans_rule(trans));
 			nft_rule_expr_activate(&trans->ctx, nft_trans_rule(trans));
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWSET:
-			trans->ctx.table->use--;
+			nft_use_dec_restore(&trans->ctx.table->use);
 			if (nft_trans_set_bound(trans)) {
 				nft_trans_destroy(trans);
 				break;
@@ -7222,7 +7260,7 @@ static int __nf_tables_abort(struct net
 			list_del_rcu(&nft_trans_set(trans)->list);
 			break;
 		case NFT_MSG_DELSET:
-			trans->ctx.table->use++;
+			nft_use_inc_restore(&trans->ctx.table->use);
 			nft_clear(trans->ctx.net, nft_trans_set(trans));
 			nft_trans_destroy(trans);
 			break;
@@ -7249,23 +7287,23 @@ static int __nf_tables_abort(struct net
 				nft_obj_destroy(&trans->ctx, nft_trans_obj_newobj(trans));
 				nft_trans_destroy(trans);
 			} else {
-				trans->ctx.table->use--;
+				nft_use_dec_restore(&trans->ctx.table->use);
 				nft_obj_del(nft_trans_obj(trans));
 			}
 			break;
 		case NFT_MSG_DELOBJ:
-			trans->ctx.table->use++;
+			nft_use_inc_restore(&trans->ctx.table->use);
 			nft_clear(trans->ctx.net, nft_trans_obj(trans));
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWFLOWTABLE:
-			trans->ctx.table->use--;
+			nft_use_dec_restore(&trans->ctx.table->use);
 			list_del_rcu(&nft_trans_flowtable(trans)->list);
 			nft_unregister_flowtable_net_hooks(net,
 					nft_trans_flowtable(trans));
 			break;
 		case NFT_MSG_DELFLOWTABLE:
-			trans->ctx.table->use++;
+			nft_use_inc_restore(&trans->ctx.table->use);
 			nft_clear(trans->ctx.net, nft_trans_flowtable(trans));
 			nft_trans_destroy(trans);
 			break;
@@ -7685,8 +7723,9 @@ static int nft_verdict_init(const struct
 			return PTR_ERR(chain);
 		if (nft_is_base_chain(chain))
 			return -EOPNOTSUPP;
+		if (!nft_use_inc(&chain->use))
+			return -EMFILE;
 
-		chain->use++;
 		data->verdict.chain = chain;
 		break;
 	}
@@ -7698,10 +7737,13 @@ static int nft_verdict_init(const struct
 
 static void nft_verdict_uninit(const struct nft_data *data)
 {
+	struct nft_chain *chain;
+
 	switch (data->verdict.code) {
 	case NFT_JUMP:
 	case NFT_GOTO:
-		data->verdict.chain->use--;
+		chain = data->verdict.chain;
+		nft_use_dec(&chain->use);
 		break;
 	}
 }
@@ -7855,11 +7897,11 @@ int __nft_release_basechain(struct nft_c
 	nf_tables_unregister_hook(ctx->net, ctx->chain->table, ctx->chain);
 	list_for_each_entry_safe(rule, nr, &ctx->chain->rules, list) {
 		list_del(&rule->list);
-		ctx->chain->use--;
+		nft_use_dec(&ctx->chain->use);
 		nf_tables_rule_release(ctx, rule);
 	}
 	nft_chain_del(ctx->chain);
-	ctx->table->use--;
+	nft_use_dec(&ctx->table->use);
 	nf_tables_chain_destroy(ctx);
 
 	return 0;
@@ -7896,29 +7938,29 @@ static void __nft_release_table(struct n
 		ctx.chain = chain;
 		list_for_each_entry_safe(rule, nr, &chain->rules, list) {
 			list_del(&rule->list);
-			chain->use--;
+			nft_use_dec(&chain->use);
 			nf_tables_rule_release(&ctx, rule);
 		}
 	}
 	list_for_each_entry_safe(flowtable, nf, &table->flowtables, list) {
 		list_del(&flowtable->list);
-		table->use--;
+		nft_use_dec(&table->use);
 		nf_tables_flowtable_destroy(flowtable);
 	}
 	list_for_each_entry_safe(set, ns, &table->sets, list) {
 		list_del(&set->list);
-		table->use--;
+		nft_use_dec(&table->use);
 		nft_set_destroy(set);
 	}
 	list_for_each_entry_safe(obj, ne, &table->objects, list) {
 		nft_obj_del(obj);
-		table->use--;
+		nft_use_dec(&table->use);
 		nft_obj_destroy(&ctx, obj);
 	}
 	list_for_each_entry_safe(chain, nc, &table->chains, list) {
 		ctx.chain = chain;
 		nft_chain_del(chain);
-		table->use--;
+		nft_use_dec(&table->use);
 		nf_tables_chain_destroy(&ctx);
 	}
 	list_del(&table->list);
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -171,8 +171,10 @@ static int nft_flow_offload_init(const s
 	if (IS_ERR(flowtable))
 		return PTR_ERR(flowtable);
 
+	if (!nft_use_inc(&flowtable->use))
+		return -EMFILE;
+
 	priv->flowtable = flowtable;
-	flowtable->use++;
 
 	return nf_ct_netns_get(ctx->net, ctx->family);
 }
@@ -191,7 +193,7 @@ static void nft_flow_offload_activate(co
 {
 	struct nft_flow_offload *priv = nft_expr_priv(expr);
 
-	priv->flowtable->use++;
+	nft_use_inc_restore(&priv->flowtable->use);
 }
 
 static void nft_flow_offload_destroy(const struct nft_ctx *ctx,
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -41,8 +41,10 @@ static int nft_objref_init(const struct
 	if (IS_ERR(obj))
 		return -ENOENT;
 
+	if (!nft_use_inc(&obj->use))
+		return -EMFILE;
+
 	nft_objref_priv(expr) = obj;
-	obj->use++;
 
 	return 0;
 }
@@ -71,7 +73,7 @@ static void nft_objref_deactivate(const
 	if (phase == NFT_TRANS_COMMIT)
 		return;
 
-	obj->use--;
+	nft_use_dec(&obj->use);
 }
 
 static void nft_objref_activate(const struct nft_ctx *ctx,
@@ -79,7 +81,7 @@ static void nft_objref_activate(const st
 {
 	struct nft_object *obj = nft_objref_priv(expr);
 
-	obj->use++;
+	nft_use_inc_restore(&obj->use);
 }
 
 static struct nft_expr_type nft_objref_type;


