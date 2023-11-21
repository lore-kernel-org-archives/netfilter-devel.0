Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC6CC61D94
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Nov 2023 12:28:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234658AbjKUM2b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Nov 2023 07:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbjKUM2b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Nov 2023 07:28:31 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDC292;
        Tue, 21 Nov 2023 04:28:26 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1r5Prc-0005B9-VB; Tue, 21 Nov 2023 13:28:24 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     lorenzo@kernel.org, <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/8] netfilter: flowtable: move nf_flowtable out of container structures
Date:   Tue, 21 Nov 2023 13:27:44 +0100
Message-ID: <20231121122800.13521-2-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231121122800.13521-1-fw@strlen.de>
References: <20231121122800.13521-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

struct nf_flowtable is currently wholly embedded in either nft_flowtable
or tcf_ct_flow_table.

In order to allow flowtable acceleration via XDP, the XDP program will
need to map struct net_device to struct nf_flowtable.

To make this work reliably, make a clear separation of the frontend
(nft, tc) and backend (nf_flowtable) representation.

In this first patch, amke it so nft_flowtable and tcf_ct_flow_table
only store pointers to an nf_flowtable structure.

The main goal is to have follow patches that allow us to keep the
nf_flowtable structure around for a bit longer (e.g. until after
an rcu grace period has elapesed) when the frontend(s) are tearing the
structures down.

At this time, things are fine, but when xdp programs might be using
the nf_flowtable structure as well we will need a way to ensure that
no such users exist anymore.

Right now there is inufficient guarantee: nftables only ensures
that the netfilter hooks are unregistered, and tc only ensures the
tc actions have been removed.

Any future kfunc might still be called in parallel from an XDP
program.  The easies way to resolve this is to let the nf_flowtable
core handle release and module reference counting itself.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h | 15 +++++---
 net/netfilter/nf_tables_api.c     | 62 +++++++++++++++++--------------
 net/netfilter/nft_flow_offload.c  |  4 +-
 net/sched/act_ct.c                | 33 +++++++++-------
 4 files changed, 66 insertions(+), 48 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index b157c5cafd14..362eca5d0451 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1380,8 +1380,14 @@ void nft_unregister_obj(struct nft_object_type *obj_type);
  *	@use: number of references to this flow table
  * 	@handle: unique object handle
  *	@dev_name: array of device names
- *	@data: rhashtable and garbage collector
- * 	@ops: array of hooks
+ *	@hook_list: list of struct nft_hook
+ *	@ft: pointer to underlying nf_flowtable
+ *
+ *	This structure represents the low-level
+ *	nf_flowtable within the nf_tables framework.
+ *
+ *	nf_flowtable itself has no concept of 'tables', 'transactions',
+ *	etc. They do not even have names.
  */
 struct nft_flowtable {
 	struct list_head		list;
@@ -1392,9 +1398,8 @@ struct nft_flowtable {
 	u32				genmask:2;
 	u32				use;
 	u64				handle;
-	/* runtime data below here */
-	struct list_head		hook_list ____cacheline_aligned;
-	struct nf_flowtable		data;
+	struct list_head		hook_list;
+	struct nf_flowtable		*ft;
 };
 
 struct nft_flowtable *nft_flowtable_lookup(const struct nft_table *table,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c0a42989b982..ee0de8d9b49c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8100,11 +8100,11 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 
 		if (tb[NFTA_FLOWTABLE_HOOK_PRIORITY]) {
 			priority = ntohl(nla_get_be32(tb[NFTA_FLOWTABLE_HOOK_PRIORITY]));
-			if (priority != flowtable->data.priority)
+			if (priority != flowtable->ft->priority)
 				return -EOPNOTSUPP;
 		}
 
-		flowtable_hook->priority	= flowtable->data.priority;
+		flowtable_hook->priority	= flowtable->ft->priority;
 		flowtable_hook->num		= flowtable->hooknum;
 	}
 
@@ -8121,8 +8121,8 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 		hook->ops.pf		= NFPROTO_NETDEV;
 		hook->ops.hooknum	= flowtable_hook->num;
 		hook->ops.priority	= flowtable_hook->priority;
-		hook->ops.priv		= &flowtable->data;
-		hook->ops.hook		= flowtable->data.type->hook;
+		hook->ops.priv		= flowtable->ft;
+		hook->ops.hook		= flowtable->ft->type->hook;
 	}
 
 	return err;
@@ -8164,8 +8164,8 @@ static void nft_unregister_flowtable_hook(struct net *net,
 					  struct nft_hook *hook)
 {
 	nf_unregister_net_hook(net, &hook->ops);
-	flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
-				    FLOW_BLOCK_UNBIND);
+	flowtable->ft->type->setup(flowtable->ft, hook->ops.dev,
+				   FLOW_BLOCK_UNBIND);
 }
 
 static void __nft_unregister_flowtable_net_hooks(struct net *net,
@@ -8212,17 +8212,15 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 			}
 		}
 
-		err = flowtable->data.type->setup(&flowtable->data,
-						  hook->ops.dev,
-						  FLOW_BLOCK_BIND);
+		err = flowtable->ft->type->setup(flowtable->ft, hook->ops.dev,
+						 FLOW_BLOCK_BIND);
 		if (err < 0)
 			goto err_unregister_net_hooks;
 
 		err = nf_register_net_hook(net, &hook->ops);
 		if (err < 0) {
-			flowtable->data.type->setup(&flowtable->data,
-						    hook->ops.dev,
-						    FLOW_BLOCK_UNBIND);
+			flowtable->ft->type->setup(flowtable->ft, hook->ops.dev,
+						   FLOW_BLOCK_UNBIND);
 			goto err_unregister_net_hooks;
 		}
 
@@ -8284,13 +8282,13 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 			err = -EOPNOTSUPP;
 			goto err_flowtable_update_hook;
 		}
-		if ((flowtable->data.flags & NFT_FLOWTABLE_HW_OFFLOAD) ^
+		if ((flowtable->ft->flags & NFT_FLOWTABLE_HW_OFFLOAD) ^
 		    (flags & NFT_FLOWTABLE_HW_OFFLOAD)) {
 			err = -EOPNOTSUPP;
 			goto err_flowtable_update_hook;
 		}
 	} else {
-		flags = flowtable->data.flags;
+		flags = flowtable->ft->flags;
 	}
 
 	err = nft_register_flowtable_net_hooks(ctx->net, ctx->table,
@@ -8402,18 +8400,24 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 		goto err2;
 	}
 
+	flowtable->ft = kzalloc(sizeof(*flowtable->ft), GFP_KERNEL_ACCOUNT);
+	if (!flowtable->ft) {
+		err = -ENOMEM;
+		goto err3;
+	}
+
 	if (nla[NFTA_FLOWTABLE_FLAGS]) {
-		flowtable->data.flags =
+		flowtable->ft->flags =
 			ntohl(nla_get_be32(nla[NFTA_FLOWTABLE_FLAGS]));
-		if (flowtable->data.flags & ~NFT_FLOWTABLE_MASK) {
+		if (flowtable->ft->flags & ~NFT_FLOWTABLE_MASK) {
 			err = -EOPNOTSUPP;
 			goto err3;
 		}
 	}
 
-	write_pnet(&flowtable->data.net, net);
-	flowtable->data.type = type;
-	err = type->init(&flowtable->data);
+	write_pnet(&flowtable->ft->net, net);
+	flowtable->ft->type = type;
+	err = type->init(flowtable->ft);
 	if (err < 0)
 		goto err3;
 
@@ -8423,7 +8427,7 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 		goto err4;
 
 	list_splice(&flowtable_hook.list, &flowtable->hook_list);
-	flowtable->data.priority = flowtable_hook.priority;
+	flowtable->ft->priority = flowtable_hook.priority;
 	flowtable->hooknum = flowtable_hook.num;
 
 	err = nft_register_flowtable_net_hooks(ctx.net, table,
@@ -8448,8 +8452,9 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 		kfree_rcu(hook, rcu);
 	}
 err4:
-	flowtable->data.type->free(&flowtable->data);
+	flowtable->ft->type->free(flowtable->ft);
 err3:
+	kfree(flowtable->ft);
 	module_put(type->owner);
 err2:
 	kfree(flowtable->name);
@@ -8603,14 +8608,14 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 	}
 
 	if (nla_put_be32(skb, NFTA_FLOWTABLE_USE, htonl(flowtable->use)) ||
-	    nla_put_be32(skb, NFTA_FLOWTABLE_FLAGS, htonl(flowtable->data.flags)))
+	    nla_put_be32(skb, NFTA_FLOWTABLE_FLAGS, htonl(flowtable->ft->flags)))
 		goto nla_put_failure;
 
 	nest = nla_nest_start_noflag(skb, NFTA_FLOWTABLE_HOOK);
 	if (!nest)
 		goto nla_put_failure;
 	if (nla_put_be32(skb, NFTA_FLOWTABLE_HOOK_NUM, htonl(flowtable->hooknum)) ||
-	    nla_put_be32(skb, NFTA_FLOWTABLE_HOOK_PRIORITY, htonl(flowtable->data.priority)))
+	    nla_put_be32(skb, NFTA_FLOWTABLE_HOOK_PRIORITY, htonl(flowtable->ft->priority)))
 		goto nla_put_failure;
 
 	nest_devs = nla_nest_start_noflag(skb, NFTA_FLOWTABLE_HOOK_DEVS);
@@ -8825,15 +8830,16 @@ static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 {
 	struct nft_hook *hook, *next;
 
-	flowtable->data.type->free(&flowtable->data);
+	flowtable->ft->type->free(flowtable->ft);
 	list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
-		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
-					    FLOW_BLOCK_UNBIND);
+		flowtable->ft->type->setup(flowtable->ft, hook->ops.dev,
+					   FLOW_BLOCK_UNBIND);
 		list_del_rcu(&hook->list);
 		kfree(hook);
 	}
 	kfree(flowtable->name);
-	module_put(flowtable->data.type->owner);
+	module_put(flowtable->ft->type->owner);
+	kfree(flowtable->ft);
 	kfree(flowtable);
 }
 
@@ -10164,7 +10170,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			break;
 		case NFT_MSG_NEWFLOWTABLE:
 			if (nft_trans_flowtable_update(trans)) {
-				nft_trans_flowtable(trans)->data.flags =
+				nft_trans_flowtable(trans)->ft->flags =
 					nft_trans_flowtable_flags(trans);
 				nf_tables_flowtable_notify(&trans->ctx,
 							   nft_trans_flowtable(trans),
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index ab3362c483b4..83b631470bab 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -196,7 +196,7 @@ static void nft_dev_forward_path(struct nf_flow_route *route,
 	int i;
 
 	if (nft_dev_fill_forward_path(route, dst, ct, dir, ha, &stack) >= 0)
-		nft_dev_path_info(&stack, &info, ha, &ft->data);
+		nft_dev_path_info(&stack, &info, ha, ft->ft);
 
 	if (!info.indev || !nft_flowtable_find_dev(info.indev, ft))
 		return;
@@ -293,7 +293,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 				  const struct nft_pktinfo *pkt)
 {
 	struct nft_flow_offload *priv = nft_expr_priv(expr);
-	struct nf_flowtable *flowtable = &priv->flowtable->data;
+	struct nf_flowtable *flowtable = priv->flowtable->ft;
 	struct tcphdr _tcph, *tcph = NULL;
 	struct nf_flow_route route = {};
 	enum ip_conntrack_info ctinfo;
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index b3f4a503ee2b..2a6362becd71 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -45,7 +45,7 @@ struct tcf_ct_flow_table {
 	struct rhash_head node; /* In zones tables */
 
 	struct rcu_work rwork;
-	struct nf_flowtable nf_ft;
+	struct nf_flowtable *nf_ft;
 	refcount_t ref;
 	u16 zone;
 
@@ -305,6 +305,7 @@ static int tcf_ct_flow_table_get(struct net *net, struct tcf_ct_params *params)
 	ct_ft = kzalloc(sizeof(*ct_ft), GFP_KERNEL);
 	if (!ct_ft)
 		goto err_alloc;
+
 	refcount_set(&ct_ft->ref, 1);
 
 	ct_ft->zone = params->zone;
@@ -312,24 +313,29 @@ static int tcf_ct_flow_table_get(struct net *net, struct tcf_ct_params *params)
 	if (err)
 		goto err_insert;
 
-	ct_ft->nf_ft.type = &flowtable_ct;
-	ct_ft->nf_ft.flags |= NF_FLOWTABLE_HW_OFFLOAD |
-			      NF_FLOWTABLE_COUNTER;
-	err = nf_flow_table_init(&ct_ft->nf_ft);
+	ct_ft->nf_ft = kzalloc(sizeof(*ct_ft->nf_ft), GFP_KERNEL);
+	if (!ct_ft->nf_ft)
+		goto err_alloc;
+
+	ct_ft->nf_ft->type = &flowtable_ct;
+	ct_ft->nf_ft->flags |= NF_FLOWTABLE_HW_OFFLOAD |
+			       NF_FLOWTABLE_COUNTER;
+	err = nf_flow_table_init(ct_ft->nf_ft);
 	if (err)
 		goto err_init;
-	write_pnet(&ct_ft->nf_ft.net, net);
+	write_pnet(&ct_ft->nf_ft->net, net);
 
 	__module_get(THIS_MODULE);
 out_unlock:
 	params->ct_ft = ct_ft;
-	params->nf_ft = &ct_ft->nf_ft;
+	params->nf_ft = ct_ft->nf_ft;
 	mutex_unlock(&zones_mutex);
 
 	return 0;
 
 err_init:
 	rhashtable_remove_fast(&zones_ht, &ct_ft->node, zones_params);
+	kfree(ct_ft->nf_ft);
 err_insert:
 	kfree(ct_ft);
 err_alloc:
@@ -345,16 +351,17 @@ static void tcf_ct_flow_table_cleanup_work(struct work_struct *work)
 
 	ct_ft = container_of(to_rcu_work(work), struct tcf_ct_flow_table,
 			     rwork);
-	nf_flow_table_free(&ct_ft->nf_ft);
+	nf_flow_table_free(ct_ft->nf_ft);
 
 	/* Remove any remaining callbacks before cleanup */
-	block = &ct_ft->nf_ft.flow_block;
-	down_write(&ct_ft->nf_ft.flow_block_lock);
+	block = &ct_ft->nf_ft->flow_block;
+	down_write(&ct_ft->nf_ft->flow_block_lock);
 	list_for_each_entry_safe(block_cb, tmp_cb, &block->cb_list, list) {
 		list_del(&block_cb->list);
 		flow_block_cb_free(block_cb);
 	}
-	up_write(&ct_ft->nf_ft.flow_block_lock);
+	up_write(&ct_ft->nf_ft->flow_block_lock);
+	kfree(ct_ft->nf_ft);
 	kfree(ct_ft);
 
 	module_put(THIS_MODULE);
@@ -417,7 +424,7 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
 		tcf_ct_flow_tc_ifidx(entry, act_ct_ext, FLOW_OFFLOAD_DIR_REPLY);
 	}
 
-	err = flow_offload_add(&ct_ft->nf_ft, entry);
+	err = flow_offload_add(ct_ft->nf_ft, entry);
 	if (err)
 		goto err_add;
 
@@ -625,7 +632,7 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 				     struct sk_buff *skb,
 				     u8 family)
 {
-	struct nf_flowtable *nf_ft = &p->ct_ft->nf_ft;
+	struct nf_flowtable *nf_ft = p->ct_ft->nf_ft;
 	struct flow_offload_tuple_rhash *tuplehash;
 	struct flow_offload_tuple tuple = {};
 	enum ip_conntrack_info ctinfo;
-- 
2.41.0

