Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18E73B777B;
	Fri, 17 Apr 2026 09:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776418795; cv=none; b=SdLLQmAzwgieyS1gkrFVYYtwK/1ad7vgAJESxjh3DmL89pgFZHX1VOF3R6l+UcIAmRfF0pIqiGRFzUx6At24wRXRnCr6vKu5heQEREEZL6FlNE18MBadg9HSg28RUjMJN7nk/wWlZjcP0on424QhCQN8KFEimYdNvWg7RNu6mro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776418795; c=relaxed/simple;
	bh=yQq1s9JMLELSWMim2fbGzsDBDSQe+F13MEht4hnVLmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAfC73lhlEq4baCkq8M6tnS+a2psqFCLOe9Nddr7OSgJzymyMiYccc+CqEfAu3g0GRUHWS4nsgEyWOXsblkmuuo7CFe/yJK9nUscG0Ng/qp8teHeC/TJ0/SjgEuc9WLPz2nVEdh9jpikABTh5qTFiv+wjnNWqUwe4gECZTsKQ6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vsKXLI32; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vsKXLI32"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3DEC96017D;
	Fri, 17 Apr 2026 11:39:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776418791;
	bh=YgMALUF1To0Oe/rCAPb2Nuey5Ao9W/hbrXA5JSEWUV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vsKXLI32jQrZZ9Hyju51SzSgiI1NzN52ER7o5FwFEKtmMckjjvD3lYIUtHI4fxw43
	 g/HQRRpNwWvwmO9/aq7VxJx81u5gTW0tQi2bTTNqVvW16tgoQrmg7sUeuQH4O/Gbt8
	 x33bs9tH8DtTvYFS2QZNkX4fpHA+33F00I2bGDpPCYox7NSb1Tlia1elw/IalD7k1s
	 je9Hk2A7VQXxkzvdq28+4JiyIyiPvaJyOaarbmGjfi/sqyRLia5M9SHdMDx0QWC+s3
	 Q/qfc6FoIt5n3+Zlo1c9jOVmrNuYYXTCwCaph5t9352cO1exzHCgQcPzMYavFsRtKq
	 RzIuh//5hLGNA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: netdev@vger.kernel.org,
	fw@strlen.de
Subject: [PATCH nf,v6 4/4] netfilter: nf_tables: add hook transactions for device deletions
Date: Fri, 17 Apr 2026 11:39:42 +0200
Message-ID: <20260417093942.373885-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260417093942.373885-1-pablo@netfilter.org>
References: <20260417093942.373885-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Restore the flag that indicates that the hook is going away, ie.
NFT_HOOK_REMOVE, but add a new transaction object to track deletion
of hooks without altering the basechain/flowtable hook_list during
the preparation phase.

The existing approach that moves the hook from the basechain/flowtable
hook_list to transaction hook_list breaks netlink dump path readers
of this RCU-protected list.

It should be possible use an array for nft_trans_hook to store the
deleted hooks to compact the representation but I am not expecting
many hook object, specially now that wildcard support for devices
is in place.

Note that the nft_trans_chain_hooks() list contains a list of struct
nft_trans_hook objects for DELCHAIN and DELFLOWTABLE commands, while
this list stores struct nft_hook objects for NEWCHAIN and NEWFLOWTABLE.
Note that new commands can be updated to use nft_trans_hook for
consistency.

This patch also adapts the event notification path to deal with the list
of hook transactions.

Fixes: 7d937b107108 ("netfilter: nf_tables: support for deleting devices in an existing netdev chain")
Fixes: b6d9014a3335 ("netfilter: nf_tables: delete flowtable hooks via transaction list")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v6: just a rebase on top of net-next, net is still behind.

 include/net/netfilter/nf_tables.h |  13 ++
 net/netfilter/nf_tables_api.c     | 251 +++++++++++++++++++++++-------
 2 files changed, 212 insertions(+), 52 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 2c0173d9309c..cff7b773e972 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1204,12 +1204,15 @@ struct nft_stats {
 	struct u64_stats_sync	syncp;
 };
 
+#define NFT_HOOK_REMOVE	(1 << 0)
+
 struct nft_hook {
 	struct list_head	list;
 	struct list_head	ops_list;
 	struct rcu_head		rcu;
 	char			ifname[IFNAMSIZ];
 	u8			ifnamelen;
+	u8			flags;
 };
 
 struct nf_hook_ops *nft_hook_find_ops(const struct nft_hook *hook,
@@ -1664,6 +1667,16 @@ struct nft_trans {
 	u8				put_net:1;
 };
 
+/**
+ * struct nft_trans_hook - nf_tables hook update in transaction
+ * @list: used internally
+ * @hook: struct nft_hook with the device hook
+ */
+struct nft_trans_hook {
+	struct list_head		list;
+	struct nft_hook			*hook;
+};
+
 /**
  * struct nft_trans_binding - nf_tables object with binding support in transaction
  * @nft_trans:    base structure, MUST be first member
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ae10116af923..d04768641ffb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -380,6 +380,29 @@ static void nft_netdev_hook_unlink_free_rcu(struct nft_hook *hook)
 	nft_netdev_hook_free_rcu(hook);
 }
 
+static void nft_trans_hook_destroy(struct nft_trans_hook *trans_hook)
+{
+	list_del(&trans_hook->list);
+	kfree(trans_hook);
+}
+
+static void nft_netdev_unregister_trans_hook(struct net *net,
+					     struct list_head *hook_list)
+{
+	struct nft_trans_hook *trans_hook, *next;
+	struct nf_hook_ops *ops;
+	struct nft_hook *hook;
+
+	list_for_each_entry_safe(trans_hook, next, hook_list, list) {
+		hook = trans_hook->hook;
+		list_for_each_entry(ops, &hook->ops_list, list)
+			nf_unregister_net_hook(net, ops);
+
+		nft_netdev_hook_unlink_free_rcu(hook);
+		nft_trans_hook_destroy(trans_hook);
+	}
+}
+
 static void nft_netdev_unregister_hooks(struct net *net,
 					struct list_head *hook_list,
 					bool release_netdev)
@@ -1946,13 +1969,59 @@ static int nft_nla_put_hook_dev(struct sk_buff *skb, struct nft_hook *hook)
 	return nla_put_string(skb, attr, hook->ifname);
 }
 
+struct nft_hook_dump_ctx {
+	struct nft_hook *first;
+	int n;
+};
+
+static int nft_dump_basechain_hook_one(struct sk_buff *skb,
+				       struct nft_hook *hook,
+				       struct nft_hook_dump_ctx *dump_ctx)
+{
+	if (!dump_ctx->first)
+		dump_ctx->first = hook;
+
+	if (nft_nla_put_hook_dev(skb, hook))
+		return -1;
+
+	dump_ctx->n++;
+
+	return 0;
+}
+
+static int nft_dump_basechain_hook_list(struct sk_buff *skb,
+					const struct list_head *hook_list,
+					struct nft_hook_dump_ctx *dump_ctx)
+{
+	struct nft_hook *hook;
+
+	list_for_each_entry_rcu(hook, hook_list, list,
+				lockdep_commit_lock_is_held(net))
+		nft_dump_basechain_hook_one(skb, hook, dump_ctx);
+
+	return 0;
+}
+
+static int nft_dump_basechain_trans_hook_list(struct sk_buff *skb,
+					      const struct list_head *trans_hook_list,
+					      struct nft_hook_dump_ctx *dump_ctx)
+{
+	struct nft_trans_hook *trans_hook;
+
+	list_for_each_entry(trans_hook, trans_hook_list, list)
+		nft_dump_basechain_hook_one(skb, trans_hook->hook, dump_ctx);
+
+	return 0;
+}
+
 static int nft_dump_basechain_hook(struct sk_buff *skb,
 				   const struct net *net, int family,
 				   const struct nft_base_chain *basechain,
-				   const struct list_head *hook_list)
+				   const struct list_head *hook_list,
+				   const struct list_head *trans_hook_list)
 {
 	const struct nf_hook_ops *ops = &basechain->ops;
-	struct nft_hook *hook, *first = NULL;
+	struct nft_hook_dump_ctx dump_hook_ctx = {};
 	struct nlattr *nest, *nest_devs;
 	int n = 0;
 
@@ -1969,23 +2038,23 @@ static int nft_dump_basechain_hook(struct sk_buff *skb,
 		if (!nest_devs)
 			goto nla_put_failure;
 
-		if (!hook_list)
+		if (!hook_list && !trans_hook_list)
 			hook_list = &basechain->hook_list;
 
-		list_for_each_entry_rcu(hook, hook_list, list,
-					lockdep_commit_lock_is_held(net)) {
-			if (!first)
-				first = hook;
-
-			if (nft_nla_put_hook_dev(skb, hook))
-				goto nla_put_failure;
-			n++;
+		if (hook_list &&
+		    nft_dump_basechain_hook_list(skb, hook_list, &dump_hook_ctx)) {
+			goto nla_put_failure;
+		} else if (trans_hook_list &&
+			   nft_dump_basechain_trans_hook_list(skb, trans_hook_list,
+							      &dump_hook_ctx)) {
+			goto nla_put_failure;
 		}
+
 		nla_nest_end(skb, nest_devs);
 
 		if (n == 1 &&
-		    !hook_is_prefix(first) &&
-		    nla_put_string(skb, NFTA_HOOK_DEV, first->ifname))
+		    !hook_is_prefix(dump_hook_ctx.first) &&
+		    nla_put_string(skb, NFTA_HOOK_DEV, dump_hook_ctx.first->ifname))
 			goto nla_put_failure;
 	}
 	nla_nest_end(skb, nest);
@@ -1999,7 +2068,8 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 				     u32 portid, u32 seq, int event, u32 flags,
 				     int family, const struct nft_table *table,
 				     const struct nft_chain *chain,
-				     const struct list_head *hook_list)
+				     const struct list_head *hook_list,
+				     const struct list_head *trans_hook_list)
 {
 	struct nlmsghdr *nlh;
 
@@ -2015,7 +2085,7 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 			 NFTA_CHAIN_PAD))
 		goto nla_put_failure;
 
-	if (!hook_list &&
+	if (!hook_list && !trans_hook_list &&
 	    (event == NFT_MSG_DELCHAIN ||
 	     event == NFT_MSG_DESTROYCHAIN)) {
 		nlmsg_end(skb, nlh);
@@ -2026,7 +2096,8 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 		const struct nft_base_chain *basechain = nft_base_chain(chain);
 		struct nft_stats __percpu *stats;
 
-		if (nft_dump_basechain_hook(skb, net, family, basechain, hook_list))
+		if (nft_dump_basechain_hook(skb, net, family, basechain,
+					    hook_list, trans_hook_list))
 			goto nla_put_failure;
 
 		if (nla_put_be32(skb, NFTA_CHAIN_POLICY,
@@ -2062,7 +2133,8 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 }
 
 static void nf_tables_chain_notify(const struct nft_ctx *ctx, int event,
-				   const struct list_head *hook_list)
+				   const struct list_head *hook_list,
+				   const struct list_head *trans_hook_list)
 {
 	struct nftables_pernet *nft_net;
 	struct sk_buff *skb;
@@ -2082,7 +2154,7 @@ static void nf_tables_chain_notify(const struct nft_ctx *ctx, int event,
 
 	err = nf_tables_fill_chain_info(skb, ctx->net, ctx->portid, ctx->seq,
 					event, flags, ctx->family, ctx->table,
-					ctx->chain, hook_list);
+					ctx->chain, hook_list, trans_hook_list);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -2128,7 +2200,7 @@ static int nf_tables_dump_chains(struct sk_buff *skb,
 						      NFT_MSG_NEWCHAIN,
 						      NLM_F_MULTI,
 						      table->family, table,
-						      chain, NULL) < 0)
+						      chain, NULL, NULL) < 0)
 				goto done;
 
 			nl_dump_check_consistent(cb, nlmsg_hdr(skb));
@@ -2182,7 +2254,7 @@ static int nf_tables_getchain(struct sk_buff *skb, const struct nfnl_info *info,
 
 	err = nf_tables_fill_chain_info(skb2, net, NETLINK_CB(skb).portid,
 					info->nlh->nlmsg_seq, NFT_MSG_NEWCHAIN,
-					0, family, table, chain, NULL);
+					0, family, table, chain, NULL, NULL);
 	if (err < 0)
 		goto err_fill_chain_info;
 
@@ -2345,8 +2417,12 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
 
 	list_for_each_entry(hook, hook_list, list) {
 		if (!strncmp(hook->ifname, this->ifname,
-			     min(hook->ifnamelen, this->ifnamelen)))
+			     min(hook->ifnamelen, this->ifnamelen))) {
+			if (hook->flags & NFT_HOOK_REMOVE)
+				continue;
+
 			return hook;
+		}
 	}
 
 	return NULL;
@@ -3105,6 +3181,32 @@ static int nf_tables_newchain(struct sk_buff *skb, const struct nfnl_info *info,
 	return nf_tables_addchain(&ctx, family, policy, flags, extack);
 }
 
+static int nft_trans_delhook(struct nft_hook *hook,
+			     struct list_head *del_list)
+{
+	struct nft_trans_hook *trans_hook;
+
+	trans_hook = kmalloc_obj(*trans_hook, GFP_KERNEL);
+	if (!trans_hook)
+		return -ENOMEM;
+
+	trans_hook->hook = hook;
+	list_add_tail(&trans_hook->list, del_list);
+	hook->flags |= NFT_HOOK_REMOVE;
+
+	return 0;
+}
+
+static void nft_trans_delhook_abort(struct list_head *del_list)
+{
+	struct nft_trans_hook *trans_hook, *next;
+
+	list_for_each_entry_safe(trans_hook, next, del_list, list) {
+		trans_hook->hook->flags &= ~NFT_HOOK_REMOVE;
+		nft_trans_hook_destroy(trans_hook);
+	}
+}
+
 static int nft_delchain_hook(struct nft_ctx *ctx,
 			     struct nft_base_chain *basechain,
 			     struct netlink_ext_ack *extack)
@@ -3131,7 +3233,10 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
 			err = -ENOENT;
 			goto err_chain_del_hook;
 		}
-		list_move(&hook->list, &chain_del_list);
+		if (nft_trans_delhook(hook, &chain_del_list) < 0) {
+			err = -ENOMEM;
+			goto err_chain_del_hook;
+		}
 	}
 
 	trans = nft_trans_alloc_chain(ctx, NFT_MSG_DELCHAIN);
@@ -3151,7 +3256,7 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
 	return 0;
 
 err_chain_del_hook:
-	list_splice(&chain_del_list, &basechain->hook_list);
+	nft_trans_delhook_abort(&chain_del_list);
 	nft_chain_release_hook(&chain_hook);
 
 	return err;
@@ -8933,6 +9038,14 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 	return err;
 }
 
+static void nft_trans_delhook_commit(struct list_head *hook_list)
+{
+	struct nft_trans_hook *trans_hook, *next;
+
+	list_for_each_entry_safe(trans_hook, next, hook_list, list)
+		nft_trans_hook_destroy(trans_hook);
+}
+
 static void nft_hooks_destroy(struct list_head *hook_list)
 {
 	struct nft_hook *hook, *next;
@@ -8941,6 +9054,24 @@ static void nft_hooks_destroy(struct list_head *hook_list)
 		nft_netdev_hook_unlink_free_rcu(hook);
 }
 
+static void nft_flowtable_unregister_trans_hook(struct net *net,
+						struct nft_flowtable *flowtable,
+						struct list_head *hook_list)
+{
+	struct nft_trans_hook *trans_hook, *next;
+	struct nf_hook_ops *ops;
+	struct nft_hook *hook;
+
+	list_for_each_entry_safe(trans_hook, next, hook_list, list) {
+		hook = trans_hook->hook;
+		list_for_each_entry(ops, &hook->ops_list, list)
+			nft_unregister_flowtable_ops(net, flowtable, ops);
+
+		nft_netdev_hook_unlink_free_rcu(hook);
+		nft_trans_hook_destroy(trans_hook);
+	}
+}
+
 static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 				struct nft_flowtable *flowtable,
 				struct netlink_ext_ack *extack)
@@ -9199,7 +9330,10 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 			err = -ENOENT;
 			goto err_flowtable_del_hook;
 		}
-		list_move(&hook->list, &flowtable_del_list);
+		if (nft_trans_delhook(hook, &flowtable_del_list) < 0) {
+			err = -ENOMEM;
+			goto err_flowtable_del_hook;
+		}
 	}
 
 	trans = nft_trans_alloc(ctx, NFT_MSG_DELFLOWTABLE,
@@ -9220,7 +9354,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 	return 0;
 
 err_flowtable_del_hook:
-	list_splice(&flowtable_del_list, &flowtable->hook_list);
+	nft_trans_delhook_abort(&flowtable_del_list);
 	nft_flowtable_hook_release(&flowtable_hook);
 
 	return err;
@@ -9285,8 +9419,10 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 					 u32 portid, u32 seq, int event,
 					 u32 flags, int family,
 					 struct nft_flowtable *flowtable,
-					 struct list_head *hook_list)
+					 struct list_head *hook_list,
+					 struct list_head *trans_hook_list)
 {
+	struct nft_trans_hook *trans_hook;
 	struct nlattr *nest, *nest_devs;
 	struct nft_hook *hook;
 	struct nlmsghdr *nlh;
@@ -9303,7 +9439,7 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 			 NFTA_FLOWTABLE_PAD))
 		goto nla_put_failure;
 
-	if (!hook_list &&
+	if (!hook_list && !trans_hook_list &&
 	    (event == NFT_MSG_DELFLOWTABLE ||
 	     event == NFT_MSG_DESTROYFLOWTABLE)) {
 		nlmsg_end(skb, nlh);
@@ -9325,13 +9461,20 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 	if (!nest_devs)
 		goto nla_put_failure;
 
-	if (!hook_list)
+	if (!hook_list && !trans_hook_list)
 		hook_list = &flowtable->hook_list;
 
-	list_for_each_entry_rcu(hook, hook_list, list,
-				lockdep_commit_lock_is_held(net)) {
-		if (nft_nla_put_hook_dev(skb, hook))
-			goto nla_put_failure;
+	if (hook_list) {
+		list_for_each_entry_rcu(hook, hook_list, list,
+					lockdep_commit_lock_is_held(net)) {
+			if (nft_nla_put_hook_dev(skb, hook))
+				goto nla_put_failure;
+		}
+	} else if (trans_hook_list) {
+		list_for_each_entry(trans_hook, trans_hook_list, list) {
+			if (nft_nla_put_hook_dev(skb, trans_hook->hook))
+				goto nla_put_failure;
+		}
 	}
 	nla_nest_end(skb, nest_devs);
 	nla_nest_end(skb, nest);
@@ -9385,7 +9528,7 @@ static int nf_tables_dump_flowtable(struct sk_buff *skb,
 							  NFT_MSG_NEWFLOWTABLE,
 							  NLM_F_MULTI | NLM_F_APPEND,
 							  table->family,
-							  flowtable, NULL) < 0)
+							  flowtable, NULL, NULL) < 0)
 				goto done;
 
 			nl_dump_check_consistent(cb, nlmsg_hdr(skb));
@@ -9485,7 +9628,7 @@ static int nf_tables_getflowtable(struct sk_buff *skb,
 	err = nf_tables_fill_flowtable_info(skb2, net, NETLINK_CB(skb).portid,
 					    info->nlh->nlmsg_seq,
 					    NFT_MSG_NEWFLOWTABLE, 0, family,
-					    flowtable, NULL);
+					    flowtable, NULL, NULL);
 	if (err < 0)
 		goto err_fill_flowtable_info;
 
@@ -9498,7 +9641,9 @@ static int nf_tables_getflowtable(struct sk_buff *skb,
 
 static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 				       struct nft_flowtable *flowtable,
-				       struct list_head *hook_list, int event)
+				       struct list_head *hook_list,
+				       struct list_head *trans_hook_list,
+				       int event)
 {
 	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
 	struct sk_buff *skb;
@@ -9518,7 +9663,8 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 
 	err = nf_tables_fill_flowtable_info(skb, ctx->net, ctx->portid,
 					    ctx->seq, event, flags,
-					    ctx->family, flowtable, hook_list);
+					    ctx->family, flowtable,
+					    hook_list, trans_hook_list);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -10053,7 +10199,7 @@ static void nft_commit_release(struct nft_trans *trans)
 	case NFT_MSG_DELCHAIN:
 	case NFT_MSG_DESTROYCHAIN:
 		if (nft_trans_chain_update(trans))
-			nft_hooks_destroy(&nft_trans_chain_hooks(trans));
+			nft_trans_delhook_commit(&nft_trans_chain_hooks(trans));
 		else
 			nf_tables_chain_destroy(nft_trans_chain(trans));
 		break;
@@ -10076,7 +10222,7 @@ static void nft_commit_release(struct nft_trans *trans)
 	case NFT_MSG_DELFLOWTABLE:
 	case NFT_MSG_DESTROYFLOWTABLE:
 		if (nft_trans_flowtable_update(trans))
-			nft_hooks_destroy(&nft_trans_flowtable_hooks(trans));
+			nft_trans_delhook_commit(&nft_trans_flowtable_hooks(trans));
 		else
 			nf_tables_flowtable_destroy(nft_trans_flowtable(trans));
 		break;
@@ -10837,31 +10983,30 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			if (nft_trans_chain_update(trans)) {
 				nft_chain_commit_update(nft_trans_container_chain(trans));
 				nf_tables_chain_notify(&ctx, NFT_MSG_NEWCHAIN,
-						       &nft_trans_chain_hooks(trans));
+						       &nft_trans_chain_hooks(trans), NULL);
 				list_splice_rcu(&nft_trans_chain_hooks(trans),
 						&nft_trans_basechain(trans)->hook_list);
 				/* trans destroyed after rcu grace period */
 			} else {
 				nft_chain_commit_drop_policy(nft_trans_container_chain(trans));
 				nft_clear(net, nft_trans_chain(trans));
-				nf_tables_chain_notify(&ctx, NFT_MSG_NEWCHAIN, NULL);
+				nf_tables_chain_notify(&ctx, NFT_MSG_NEWCHAIN, NULL, NULL);
 				nft_trans_destroy(trans);
 			}
 			break;
 		case NFT_MSG_DELCHAIN:
 		case NFT_MSG_DESTROYCHAIN:
 			if (nft_trans_chain_update(trans)) {
-				nf_tables_chain_notify(&ctx, NFT_MSG_DELCHAIN,
+				nf_tables_chain_notify(&ctx, NFT_MSG_DELCHAIN, NULL,
 						       &nft_trans_chain_hooks(trans));
 				if (!(table->flags & NFT_TABLE_F_DORMANT)) {
-					nft_netdev_unregister_hooks(net,
-								    &nft_trans_chain_hooks(trans),
-								    true);
+					nft_netdev_unregister_trans_hook(net,
+									 &nft_trans_chain_hooks(trans));
 				}
 			} else {
 				nft_chain_del(nft_trans_chain(trans));
 				nf_tables_chain_notify(&ctx, NFT_MSG_DELCHAIN,
-						       NULL);
+						       NULL, NULL);
 				nf_tables_unregister_hook(ctx.net, ctx.table,
 							  nft_trans_chain(trans));
 			}
@@ -10967,6 +11112,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				nf_tables_flowtable_notify(&ctx,
 							   nft_trans_flowtable(trans),
 							   &nft_trans_flowtable_hooks(trans),
+							   NULL,
 							   NFT_MSG_NEWFLOWTABLE);
 				list_splice_rcu(&nft_trans_flowtable_hooks(trans),
 						&nft_trans_flowtable(trans)->hook_list);
@@ -10975,6 +11121,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				nf_tables_flowtable_notify(&ctx,
 							   nft_trans_flowtable(trans),
 							   NULL,
+							   NULL,
 							   NFT_MSG_NEWFLOWTABLE);
 			}
 			nft_trans_destroy(trans);
@@ -10984,16 +11131,18 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			if (nft_trans_flowtable_update(trans)) {
 				nf_tables_flowtable_notify(&ctx,
 							   nft_trans_flowtable(trans),
+							   NULL,
 							   &nft_trans_flowtable_hooks(trans),
 							   trans->msg_type);
-				nft_unregister_flowtable_net_hooks(net,
-								   nft_trans_flowtable(trans),
-								   &nft_trans_flowtable_hooks(trans));
+				nft_flowtable_unregister_trans_hook(net,
+								    nft_trans_flowtable(trans),
+								    &nft_trans_flowtable_hooks(trans));
 			} else {
 				list_del_rcu(&nft_trans_flowtable(trans)->list);
 				nf_tables_flowtable_notify(&ctx,
 							   nft_trans_flowtable(trans),
 							   NULL,
+							   NULL,
 							   trans->msg_type);
 				nft_unregister_flowtable_net_hooks(net,
 						nft_trans_flowtable(trans),
@@ -11157,8 +11306,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		case NFT_MSG_DELCHAIN:
 		case NFT_MSG_DESTROYCHAIN:
 			if (nft_trans_chain_update(trans)) {
-				list_splice(&nft_trans_chain_hooks(trans),
-					    &nft_trans_basechain(trans)->hook_list);
+				nft_trans_delhook_abort(&nft_trans_chain_hooks(trans));
 			} else {
 				nft_use_inc_restore(&table->use);
 				nft_clear(trans->net, nft_trans_chain(trans));
@@ -11272,8 +11420,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		case NFT_MSG_DELFLOWTABLE:
 		case NFT_MSG_DESTROYFLOWTABLE:
 			if (nft_trans_flowtable_update(trans)) {
-				list_splice(&nft_trans_flowtable_hooks(trans),
-					    &nft_trans_flowtable(trans)->hook_list);
+				nft_trans_delhook_abort(&nft_trans_flowtable_hooks(trans));
 			} else {
 				nft_use_inc_restore(&table->use);
 				nft_clear(trans->net, nft_trans_flowtable(trans));
-- 
2.47.3

