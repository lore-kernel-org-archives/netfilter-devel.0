Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DF52192F9
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 22:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776292399; cv=none; b=diBKsgpQI8WvrM8SSfI5g7BGOwzMglAkvh0zQemncxP4DPjlbMhcFiKaNUe0EgO2IXKnlBUvgYdT7Hyb6Ke+0dX19Ia6RwPaVhr7hubX6PoCAInVPtRT+qrIBET/VKoXy0D/pqZEcyRxiNZc9gVudZRjasQfWBKjje2nQFvH29E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776292399; c=relaxed/simple;
	bh=OIkN0otQjUhbXT3pNaQkwAjWRosSp4HdDj/j/U1QruU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJdE568AM/2vx5GacNk79EX2770St5ySbEbzFuiDdk+t5+O+Djw/lqDX33VNH7Obx0vgFgFIh3fBt3OHMGd7+OwHQ6bXL4iBDHh/7Z16a4jODGV4SZE12uCDdWb6OO7yrM/k2pvWH5UuaYGXZoHUsuGYR1aDrxo40LOsQy67KTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lUOxTIze; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lUOxTIze"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9BEAF6017D;
	Thu, 16 Apr 2026 00:33:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776292395;
	bh=QmtKylC+mxeYJuiPQRemHRhXScKrAiy74bCu9w4QzRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUOxTIzeoREbRhRX/vNHBzk3i+DNXL+etKzpVVFMVfoK23VEd/mHN8bz7l00px6Nh
	 Y8Pp12SkqdXcrtFr0WEfLXQpQwhTCzOyiD4SE+rqAKSUMzfTNvMsu8eczK0lFa0Y1f
	 uRtOuL6tU21jBjuytlhyzA5GAJ2JMiVzPKGVsFGuqD/Afs8B+oZ9GaLU+fh04VH+Y9
	 a/644z5Ej7ut6+AnjP/kfSp2Ornl5S6srZlIVfq6Yb/tBgIPR8hVqbx9dR7eddWsIY
	 YpEYeyIZcFG3QKpa3TbOty4bovSbS6nFnSLGqckHlsFgwluR2w1uGmLnWkzCJeG3ef
	 qmnYizIDx14GA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf,v3 3/3] netfilter: nf_tables: add hook transactions for device deletions
Date: Thu, 16 Apr 2026 00:33:09 +0200
Message-ID: <20260415223309.95527-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260415223309.95527-1-pablo@netfilter.org>
References: <20260415223309.95527-1-pablo@netfilter.org>
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

Fixes: 7d937b107108 ("netfilter: nf_tables: support for deleting devices in an existing netdev chain")
Fixes: b6d9014a3335 ("netfilter: nf_tables: delete flowtable hooks via transaction list")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: rebased on top of ("netfilter: nf_tables: use list_del_rcu for netlink hooks")
    add several helper functions to reduce copy-and-paste pattern

 include/net/netfilter/nf_tables.h |  13 ++++
 net/netfilter/nf_tables_api.c     | 118 +++++++++++++++++++++++++-----
 2 files changed, 114 insertions(+), 17 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index ec8a8ec9c0aa..3ec41574af77 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1216,12 +1216,15 @@ struct nft_stats {
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
@@ -1676,6 +1679,16 @@ struct nft_trans {
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
index 8c0706d6d887..5f6f91e5d6da 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -380,6 +380,29 @@ static void nft_netdev_hook_unlink_free_rcu(struct nft_hook *hook)
 	nft_netdev_hook_free_rcu(hook);
 }
 
+static void nft_trans_hook_unlink_free(struct nft_trans_hook *trans_hook)
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
+		nft_trans_hook_unlink_free(trans_hook);
+	}
+}
+
 static void nft_netdev_unregister_hooks(struct net *net,
 					struct list_head *hook_list,
 					bool release_netdev)
@@ -2397,8 +2420,12 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
 
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
@@ -3157,6 +3184,32 @@ static int nf_tables_newchain(struct sk_buff *skb, const struct nfnl_info *info,
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
+static void nft_trans_delhook_release(struct list_head *del_list)
+{
+	struct nft_trans_hook *trans_hook, *next;
+
+	list_for_each_entry_safe(trans_hook, next, del_list, list) {
+		trans_hook->hook->flags &= ~NFT_HOOK_REMOVE;
+		nft_trans_hook_unlink_free(trans_hook);
+	}
+}
+
 static int nft_delchain_hook(struct nft_ctx *ctx,
 			     struct nft_base_chain *basechain,
 			     struct netlink_ext_ack *extack)
@@ -3183,7 +3236,10 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
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
@@ -3203,7 +3259,7 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
 	return 0;
 
 err_chain_del_hook:
-	list_splice(&chain_del_list, &basechain->hook_list);
+	nft_trans_delhook_release(&chain_del_list);
 	nft_chain_release_hook(&chain_hook);
 
 	return err;
@@ -8984,6 +9040,16 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 	return err;
 }
 
+static void nft_hooks_trans_destroy(struct list_head *hook_list)
+{
+	struct nft_trans_hook *trans_hook, *next;
+
+	list_for_each_entry_safe(trans_hook, next, hook_list, list) {
+		nft_netdev_hook_unlink_free_rcu(trans_hook->hook);
+		nft_trans_hook_unlink_free(trans_hook);
+	}
+}
+
 static void nft_hooks_destroy(struct list_head *hook_list)
 {
 	struct nft_hook *hook, *next;
@@ -8992,6 +9058,24 @@ static void nft_hooks_destroy(struct list_head *hook_list)
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
+		nft_trans_hook_unlink_free(trans_hook);
+	}
+}
+
 static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 				struct nft_flowtable *flowtable,
 				struct netlink_ext_ack *extack)
@@ -9250,7 +9334,10 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
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
@@ -9271,7 +9358,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 	return 0;
 
 err_flowtable_del_hook:
-	list_splice(&flowtable_del_list, &flowtable->hook_list);
+	nft_trans_delhook_release(&flowtable_del_list);
 	nft_flowtable_hook_release(&flowtable_hook);
 
 	return err;
@@ -10104,7 +10191,7 @@ static void nft_commit_release(struct nft_trans *trans)
 	case NFT_MSG_DELCHAIN:
 	case NFT_MSG_DESTROYCHAIN:
 		if (nft_trans_chain_update(trans))
-			nft_hooks_destroy(&nft_trans_chain_hooks(trans));
+			nft_hooks_trans_destroy(&nft_trans_chain_hooks(trans));
 		else
 			nf_tables_chain_destroy(nft_trans_chain(trans));
 		break;
@@ -10127,7 +10214,7 @@ static void nft_commit_release(struct nft_trans *trans)
 	case NFT_MSG_DELFLOWTABLE:
 	case NFT_MSG_DESTROYFLOWTABLE:
 		if (nft_trans_flowtable_update(trans))
-			nft_hooks_destroy(&nft_trans_flowtable_hooks(trans));
+			nft_hooks_trans_destroy(&nft_trans_flowtable_hooks(trans));
 		else
 			nf_tables_flowtable_destroy(nft_trans_flowtable(trans));
 		break;
@@ -10920,9 +11007,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				nf_tables_chain_notify(&ctx, NFT_MSG_DELCHAIN,
 						       &nft_trans_chain_hooks(trans));
 				if (!(table->flags & NFT_TABLE_F_DORMANT)) {
-					nft_netdev_unregister_hooks(net,
-								    &nft_trans_chain_hooks(trans),
-								    true);
+					nft_netdev_unregister_trans_hook(net,
+								    &nft_trans_chain_hooks(trans));
 				}
 			} else {
 				nft_chain_del(nft_trans_chain(trans));
@@ -11052,9 +11138,9 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 							   nft_trans_flowtable(trans),
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
@@ -11223,8 +11309,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		case NFT_MSG_DELCHAIN:
 		case NFT_MSG_DESTROYCHAIN:
 			if (nft_trans_chain_update(trans)) {
-				list_splice(&nft_trans_chain_hooks(trans),
-					    &nft_trans_basechain(trans)->hook_list);
+				nft_trans_delhook_release(&nft_trans_chain_hooks(trans));
 			} else {
 				nft_use_inc_restore(&table->use);
 				nft_clear(trans->net, nft_trans_chain(trans));
@@ -11338,8 +11423,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		case NFT_MSG_DELFLOWTABLE:
 		case NFT_MSG_DESTROYFLOWTABLE:
 			if (nft_trans_flowtable_update(trans)) {
-				list_splice(&nft_trans_flowtable_hooks(trans),
-					    &nft_trans_flowtable(trans)->hook_list);
+				nft_trans_delhook_release(&nft_trans_flowtable_hooks(trans));
 			} else {
 				nft_use_inc_restore(&table->use);
 				nft_clear(trans->net, nft_trans_flowtable(trans));
-- 
2.47.3

