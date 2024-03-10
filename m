Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89A2F39846
	for <netfilter-devel@vger.kernel.org>; Sun, 10 Mar 2024 20:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710103824; cv=none; b=azrOf3LIUV/1WyLuBdB6c5C3JR0Rs30km0qf3iSoj1JeycPfG+pPIrAyDPCfNoqoC3eBei4ZfHYy6Y/7RRG4vcUkxnDQXq4vqe8BkRG3yeryEwu29oJVfy4vTa7Hpy+bWCoMx04LpVLNebwM5loa/MHlnfzSPtS6H1wf+1dzCUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710103824; c=relaxed/simple;
	bh=UKNTm/pcsq9LA6U7hUtYk4kI9t4nhFANWkQrgTvEiF4=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=B+yjiZh0+Jh3FUDFwfcKUYQmC5tKhZByhTGBzGyBPjD7RtYNr84j9TQD9YkSdu1NCd9VjttKdk9pl8e96pf/2/vBZC4X89B5QGsBam3DQUv8WWd7Z0KCXzzJw7VkFrX4qV8PO6O/Cwz1ssoKqGqMms6GDLbXgs0mSut8w5tvQWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_tables: fix updating/deleting devices in an existing netdev chain
Date: Sun, 10 Mar 2024 21:50:08 +0100
Message-Id: <20240310205008.117707-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Updating netdev basechain is broken in many ways.

Keeping a list of pending hooks to be added/deleted in the transaction
object does not mix well with table flag updates (ie. setting dormant
flag in table) which operate on the existing basechain hook list.
Instead, add/delete hook to/from the basechain hook list and allocate
one transaction object per new device to refers to the hook to
add/delete.

Add an 'inactive' flag that is set on to identify devices that has been
already deleted, so double deletion in one batch is not possible.

For chain updates, several transaction objects are allocated: one or
more for the new devices, and another one for policy/stats/name updates.

Moreover, skip hook unregistration if table is in dormant state.
Otherwise, commit/abort path try to unregister hooks which are enabled,
triggering a WARN_ON splat from the netfilter hook core. Delete hook
object from basechain hook list through rcu variant, then release it
after rcu grace period.

And dumping the list of hook basechain requires RCU list iteration.

This also fixes a memleak of chain stats in case the error path is
exercised and remove useless basechain hook ops pointer fetch when
updating devices in chain.

Fixes: 7d937b107108 ("netfilter: nf_tables: support for deleting devices in an existing netdev chain")
Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |   7 +-
 net/netfilter/nf_tables_api.c     | 164 +++++++++++++++++++-----------
 2 files changed, 106 insertions(+), 65 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 510244cc0f8f..dd3c5e8af2c5 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1169,6 +1169,7 @@ struct nft_hook {
 	struct list_head	list;
 	struct nf_hook_ops	ops;
 	struct rcu_head		rcu;
+	bool			inactive;
 };
 
 /**
@@ -1656,7 +1657,7 @@ struct nft_trans_chain {
 	bool				bound;
 	u32				chain_id;
 	struct nft_base_chain		*basechain;
-	struct list_head		hook_list;
+	struct nft_hook			*hook;
 };
 
 #define nft_trans_chain(trans)	\
@@ -1675,8 +1676,8 @@ struct nft_trans_chain {
 	(((struct nft_trans_chain *)trans->data)->chain_id)
 #define nft_trans_basechain(trans)	\
 	(((struct nft_trans_chain *)trans->data)->basechain)
-#define nft_trans_chain_hooks(trans)	\
-	(((struct nft_trans_chain *)trans->data)->hook_list)
+#define nft_trans_chain_hook(trans)	\
+	(((struct nft_trans_chain *)trans->data)->hook)
 
 struct nft_trans_table {
 	bool				update;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1683dc196b59..fb319a3cd923 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1732,10 +1732,10 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
 
 static int nft_dump_basechain_hook(struct sk_buff *skb, int family,
 				   const struct nft_base_chain *basechain,
-				   const struct list_head *hook_list)
+				   const struct nft_hook *h)
 {
 	const struct nf_hook_ops *ops = &basechain->ops;
-	struct nft_hook *hook, *first = NULL;
+	struct nft_hook *first = NULL, *hook;
 	struct nlattr *nest, *nest_devs;
 	int n = 0;
 
@@ -1752,17 +1752,19 @@ static int nft_dump_basechain_hook(struct sk_buff *skb, int family,
 		if (!nest_devs)
 			goto nla_put_failure;
 
-		if (!hook_list)
-			hook_list = &basechain->hook_list;
-
-		list_for_each_entry(hook, hook_list, list) {
-			if (!first)
-				first = hook;
+		if (!h) {
+			list_for_each_entry_rcu(hook, &basechain->hook_list, list) {
+				if (!first)
+					first = hook;
 
+				if (nla_put_string(skb, NFTA_DEVICE_NAME,
+						   hook->ops.dev->name))
+					goto nla_put_failure;
+				n++;
+			}
+		} else {
 			if (nla_put_string(skb, NFTA_DEVICE_NAME,
-					   hook->ops.dev->name))
-				goto nla_put_failure;
-			n++;
+					   h->ops.dev->name));
 		}
 		nla_nest_end(skb, nest_devs);
 
@@ -1781,7 +1783,7 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 				     u32 portid, u32 seq, int event, u32 flags,
 				     int family, const struct nft_table *table,
 				     const struct nft_chain *chain,
-				     const struct list_head *hook_list)
+				     const struct nft_hook *hook)
 {
 	struct nlmsghdr *nlh;
 
@@ -1797,7 +1799,7 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 			 NFTA_CHAIN_PAD))
 		goto nla_put_failure;
 
-	if (event == NFT_MSG_DELCHAIN && !hook_list) {
+	if (event == NFT_MSG_DELCHAIN && !hook) {
 		nlmsg_end(skb, nlh);
 		return 0;
 	}
@@ -1806,7 +1808,7 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 		const struct nft_base_chain *basechain = nft_base_chain(chain);
 		struct nft_stats __percpu *stats;
 
-		if (nft_dump_basechain_hook(skb, family, basechain, hook_list))
+		if (nft_dump_basechain_hook(skb, family, basechain, hook))
 			goto nla_put_failure;
 
 		if (nla_put_be32(skb, NFTA_CHAIN_POLICY,
@@ -1842,7 +1844,7 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 }
 
 static void nf_tables_chain_notify(const struct nft_ctx *ctx, int event,
-				   const struct list_head *hook_list)
+				   const struct nft_hook *hook)
 {
 	struct nftables_pernet *nft_net;
 	struct sk_buff *skb;
@@ -1862,7 +1864,7 @@ static void nf_tables_chain_notify(const struct nft_ctx *ctx, int event,
 
 	err = nf_tables_fill_chain_info(skb, ctx->net, ctx->portid, ctx->seq,
 					event, flags, ctx->family, ctx->table,
-					ctx->chain, hook_list);
+					ctx->chain, hook);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -2543,6 +2545,27 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	return err;
 }
 
+static int nft_trans_updchain_hook(struct nft_ctx *ctx,
+				   struct nft_base_chain *basechain,
+				   struct nft_hook *hook)
+{
+	struct nft_trans *trans;
+
+	trans = nft_trans_alloc(ctx, NFT_MSG_NEWCHAIN,
+				sizeof(struct nft_trans_chain));
+	if (!trans)
+		return -ENOMEM;
+
+	nft_trans_basechain(trans) = basechain;
+	nft_trans_chain_update(trans) = true;
+	nft_trans_chain_hook(trans) = hook;
+	nft_trans_chain_policy(trans) = -1;
+
+	nft_trans_commit_list_add_tail(ctx->net, trans);
+
+	return 0;
+}
+
 static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 			      u32 flags, const struct nlattr *attr,
 			      struct netlink_ext_ack *extack)
@@ -2636,21 +2659,35 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 	    nft_is_base_chain(chain) &&
 	    !list_empty(&hook.list)) {
 		basechain = nft_base_chain(chain);
-		ops = &basechain->ops;
 
 		if (nft_base_chain_netdev(table->family, basechain->ops.hooknum)) {
 			err = nft_netdev_register_hooks(ctx->net, &hook.list);
 			if (err < 0)
-				goto err_hooks;
+				goto err_stats;
 		}
 	}
 
 	unregister = true;
+
+	list_for_each_entry_safe(h, next, &hook.list, list) {
+		err = nft_trans_updchain_hook(ctx, basechain, h);
+		if (err < 0)
+			goto err_stats;
+
+		list_move(&h->list, &basechain->hook_list);
+	}
+
+	if (!nla[NFTA_CHAIN_COUNTERS] &&
+	    !nla[NFTA_CHAIN_POLICY] &&
+	    !(nla[NFTA_CHAIN_HANDLE] &&
+	      nla[NFTA_CHAIN_NAME]))
+		goto out;
+
 	err = -ENOMEM;
 	trans = nft_trans_alloc(ctx, NFT_MSG_NEWCHAIN,
 				sizeof(struct nft_trans_chain));
 	if (trans == NULL)
-		goto err_trans;
+		goto err_stats;
 
 	nft_trans_chain_stats(trans) = stats;
 	nft_trans_chain_update(trans) = true;
@@ -2688,18 +2725,17 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 	}
 
 	nft_trans_basechain(trans) = basechain;
-	INIT_LIST_HEAD(&nft_trans_chain_hooks(trans));
-	list_splice(&hook.list, &nft_trans_chain_hooks(trans));
+	nft_trans_commit_list_add_tail(ctx->net, trans);
+out:
 	if (nla[NFTA_CHAIN_HOOK])
 		module_put(hook.type->owner);
 
-	nft_trans_commit_list_add_tail(ctx->net, trans);
-
 	return 0;
 
 err_trans:
-	free_percpu(stats);
 	kfree(trans);
+err_stats:
+	free_percpu(stats);
 err_hooks:
 	if (nla[NFTA_CHAIN_HOOK]) {
 		list_for_each_entry_safe(h, next, &hook.list, list) {
@@ -2835,6 +2871,28 @@ static int nf_tables_newchain(struct sk_buff *skb, const struct nfnl_info *info,
 	return nf_tables_addchain(&ctx, family, genmask, policy, flags, extack);
 }
 
+static int nft_trans_delchain_hook(struct nft_ctx *ctx,
+				   struct nft_base_chain *basechain,
+				   struct nft_hook *hook)
+{
+	struct nft_trans *trans;
+
+	trans = nft_trans_alloc(ctx, NFT_MSG_DELCHAIN,
+				sizeof(struct nft_trans_chain));
+	if (!trans)
+		return -ENOMEM;
+
+	hook->inactive = true;
+
+	nft_trans_basechain(trans) = basechain;
+	nft_trans_chain_update(trans) = true;
+	nft_trans_chain_hook(trans) = hook;
+
+	nft_trans_commit_list_add_tail(ctx->net, trans);
+
+	return 0;
+}
+
 static int nft_delchain_hook(struct nft_ctx *ctx,
 			     struct nft_base_chain *basechain,
 			     struct netlink_ext_ack *extack)
@@ -2843,8 +2901,6 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_chain_hook chain_hook = {};
 	struct nft_hook *this, *hook;
-	LIST_HEAD(chain_del_list);
-	struct nft_trans *trans;
 	int err;
 
 	err = nft_chain_parse_hook(ctx->net, basechain, nla, &chain_hook,
@@ -2854,32 +2910,16 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
 
 	list_for_each_entry(this, &chain_hook.list, list) {
 		hook = nft_hook_list_find(&basechain->hook_list, this);
-		if (!hook) {
+		if (!hook || hook->inactive) {
 			err = -ENOENT;
-			goto err_chain_del_hook;
+			break;
 		}
-		list_move(&hook->list, &chain_del_list);
-	}
 
-	trans = nft_trans_alloc(ctx, NFT_MSG_DELCHAIN,
-				sizeof(struct nft_trans_chain));
-	if (!trans) {
-		err = -ENOMEM;
-		goto err_chain_del_hook;
+		err = nft_trans_delchain_hook(ctx, basechain, hook);
+		if (err < 0)
+			break;
 	}
 
-	nft_trans_basechain(trans) = basechain;
-	nft_trans_chain_update(trans) = true;
-	INIT_LIST_HEAD(&nft_trans_chain_hooks(trans));
-	list_splice(&chain_del_list, &nft_trans_chain_hooks(trans));
-	nft_chain_release_hook(&chain_hook);
-
-	nft_trans_commit_list_add_tail(ctx->net, trans);
-
-	return 0;
-
-err_chain_del_hook:
-	list_splice(&chain_del_list, &basechain->hook_list);
 	nft_chain_release_hook(&chain_hook);
 
 	return err;
@@ -9384,7 +9424,7 @@ static void nft_commit_release(struct nft_trans *trans)
 	case NFT_MSG_DELCHAIN:
 	case NFT_MSG_DESTROYCHAIN:
 		if (nft_trans_chain_update(trans))
-			nft_hooks_destroy(&nft_trans_chain_hooks(trans));
+			kfree(nft_trans_chain_hook(trans));
 		else
 			nf_tables_chain_destroy(&trans->ctx);
 		break;
@@ -10158,9 +10198,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			if (nft_trans_chain_update(trans)) {
 				nft_chain_commit_update(trans);
 				nf_tables_chain_notify(&trans->ctx, NFT_MSG_NEWCHAIN,
-						       &nft_trans_chain_hooks(trans));
-				list_splice(&nft_trans_chain_hooks(trans),
-					    &nft_trans_basechain(trans)->hook_list);
+						       nft_trans_chain_hook(trans));
 				/* trans destroyed after rcu grace period */
 			} else {
 				nft_chain_commit_drop_policy(trans);
@@ -10173,10 +10211,12 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		case NFT_MSG_DESTROYCHAIN:
 			if (nft_trans_chain_update(trans)) {
 				nf_tables_chain_notify(&trans->ctx, NFT_MSG_DELCHAIN,
-						       &nft_trans_chain_hooks(trans));
-				nft_netdev_unregister_hooks(net,
-							    &nft_trans_chain_hooks(trans),
-							    true);
+						       nft_trans_chain_hook(trans));
+				if (nft_trans_chain_hook(trans)) {
+					list_del_rcu(&nft_trans_chain_hook(trans)->list);
+					if (!(trans->ctx.table->flags & NFT_TABLE_F_DORMANT))
+						nf_unregister_net_hook(net, &nft_trans_chain_hook(trans)->ops);
+				}
 			} else {
 				nft_chain_del(trans->ctx.chain);
 				nf_tables_chain_notify(&trans->ctx, NFT_MSG_DELCHAIN,
@@ -10368,7 +10408,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		break;
 	case NFT_MSG_NEWCHAIN:
 		if (nft_trans_chain_update(trans))
-			nft_hooks_destroy(&nft_trans_chain_hooks(trans));
+			kfree(nft_trans_chain_hook(trans));
 		else
 			nf_tables_chain_destroy(&trans->ctx);
 		break;
@@ -10448,12 +10488,13 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			break;
 		case NFT_MSG_NEWCHAIN:
 			if (nft_trans_chain_update(trans)) {
-				nft_netdev_unregister_hooks(net,
-							    &nft_trans_chain_hooks(trans),
-							    true);
+				if (nft_trans_chain_hook(trans)) {
+					list_del_rcu(&nft_trans_chain_hook(trans)->list);
+					if (!(trans->ctx.table->flags & NFT_TABLE_F_DORMANT))
+						nf_unregister_net_hook(net, &nft_trans_chain_hook(trans)->ops);
+				}
 				free_percpu(nft_trans_chain_stats(trans));
 				kfree(nft_trans_chain_name(trans));
-				nft_trans_destroy(trans);
 			} else {
 				if (nft_trans_chain_bound(trans)) {
 					nft_trans_destroy(trans);
@@ -10469,8 +10510,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		case NFT_MSG_DELCHAIN:
 		case NFT_MSG_DESTROYCHAIN:
 			if (nft_trans_chain_update(trans)) {
-				list_splice(&nft_trans_chain_hooks(trans),
-					    &nft_trans_basechain(trans)->hook_list);
+				nft_trans_chain_hook(trans)->inactive = false;
 			} else {
 				nft_use_inc_restore(&trans->ctx.table->use);
 				nft_clear(trans->ctx.net, trans->ctx.chain);
-- 
2.30.2

