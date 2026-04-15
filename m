Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2683A75B7
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 17:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776273049; cv=none; b=W9dnjyE7Bu9FIy/tp0wykDlsJRh17ILnICZCvP1t66hcb/UroXhGgJFWwBptquJDTAWvcwCW0wbpyztbk8JseczXL84qvoVmRNR/o8Su2s41OgP5hfeOFia40TO7ZvZFt9xm2L35NpoAwxrpH7ABZu2AA+fIbzbwblCstWp+YBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776273049; c=relaxed/simple;
	bh=/cl8xPrwU4M6zAoVvUk8j/1b83xhRq7TXgynUxBrqxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LhNZtlo4+XCn3EGhkyCR6t67KhV+Gv6DSOFLwFjPBYqpvpGQKDk2nKxe42AEJyf5ejvx0TdmCSDxbXBti3C46UIC1LKjh6FiY0Yl6+oidAYo6H44y3P1E7bJlCxO7JAuJX2D6rDRUl+RYYoSmb2KQ/LVj2OdR4+o7RPdq3j7Tdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tcPPYU5D; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tcPPYU5D"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7E7D7600B5;
	Wed, 15 Apr 2026 19:10:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776273045;
	bh=kTV8XdpTgY+ZAAdccwvCMOgpH0YbW9qXzlgZliYEi04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tcPPYU5D1ZPzMrzz8UbJJW9FtBsRe31mL5SWQ9xqmN6yKKOjCkG9DxwFXtAyreHkr
	 fPLpiCtkir33c6z6IhtTrszTBIjgLX3lD3Wo9QZr6l3DlwTzMPe72pqQTywSIj7EII
	 RdXGHmwgK37US+hgTtWAy2Jj6IoXVphYYy8Dz+owD+orUeWjn6MlvlhUovxhucPfvX
	 FLhB7k6++/8YPsuU/drN9D1DFUEZ2Vogro8icvbIgVRpgsNd0OAFvzBmt7RTdtuX05
	 ySfmI4JXMIog/FNUlLIA8fOSeSsIRN+hUmW64ax4n1ZevzTYwjr91Xw4rFhOKYdyff
	 8J9PvLSkUUbjg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf,v2 3/3] netfilter: nf_tables: add hook transactions for device deletions
Date: Wed, 15 Apr 2026 19:10:38 +0200
Message-ID: <20260415171038.41442-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260415171038.41442-1-pablo@netfilter.org>
References: <20260415171038.41442-1-pablo@netfilter.org>
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
v2: no changes.

 include/net/netfilter/nf_tables.h |  13 ++++
 net/netfilter/nf_tables_api.c     | 124 ++++++++++++++++++++++++++----
 2 files changed, 120 insertions(+), 17 deletions(-)

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
index 4d7c2794c87d..2ea94a534280 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -374,6 +374,25 @@ static void nft_netdev_hook_free_rcu(struct nft_hook *hook)
 	call_rcu(&hook->rcu, __nft_netdev_hook_free_rcu);
 }
 
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
+		list_del(&hook->list);
+		nft_netdev_hook_free_rcu(hook);
+		list_del(&trans_hook->list);
+		kfree(trans_hook);
+	}
+}
+
 static void nft_netdev_unregister_hooks(struct net *net,
 					struct list_head *hook_list,
 					bool release_netdev)
@@ -2395,8 +2414,12 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
 
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
@@ -3160,6 +3183,7 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
 {
 	const struct nft_chain *chain = &basechain->chain;
 	const struct nlattr * const *nla = ctx->nla;
+	struct nft_trans_hook *trans_hook, *next;
 	struct nft_chain_hook chain_hook = {};
 	struct nft_hook *this, *hook;
 	LIST_HEAD(chain_del_list);
@@ -3180,7 +3204,14 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
 			err = -ENOENT;
 			goto err_chain_del_hook;
 		}
-		list_move(&hook->list, &chain_del_list);
+		trans_hook = kmalloc(sizeof(*trans_hook), GFP_KERNEL);
+		if (!trans_hook) {
+			err = -ENOMEM;
+			goto err_chain_del_hook;
+		}
+		trans_hook->hook = hook;
+		list_add_tail(&trans_hook->list, &chain_del_list);
+		hook->flags |= NFT_HOOK_REMOVE;
 	}
 
 	trans = nft_trans_alloc_chain(ctx, NFT_MSG_DELCHAIN);
@@ -3200,7 +3231,11 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
 	return 0;
 
 err_chain_del_hook:
-	list_splice(&chain_del_list, &basechain->hook_list);
+	list_for_each_entry_safe(trans_hook, next, &chain_del_list, list) {
+		list_del(&trans_hook->list);
+		trans_hook->hook->flags &= ~NFT_HOOK_REMOVE;
+		kfree(trans_hook);
+	}
 	nft_chain_release_hook(&chain_hook);
 
 	return err;
@@ -8984,6 +9019,20 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 	return err;
 }
 
+static void nft_hooks_trans_destroy(struct list_head *hook_list)
+{
+	struct nft_trans_hook *trans_hook, *next;
+	struct nft_hook *hook;
+
+	list_for_each_entry_safe(trans_hook, next, hook_list, list) {
+		hook = trans_hook->hook;
+		list_del_rcu(&hook->list);
+		nft_netdev_hook_free_rcu(hook);
+		list_del(&trans_hook->list);
+		kfree(trans_hook);
+	}
+}
+
 static void nft_hooks_destroy(struct list_head *hook_list)
 {
 	struct nft_hook *hook, *next;
@@ -8994,6 +9043,27 @@ static void nft_hooks_destroy(struct list_head *hook_list)
 	}
 }
 
+static void nft_flowtable_unregister_hooks_trans(struct net *net,
+						 struct nft_flowtable *flowtable,
+						 struct list_head *hook_list)
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
+		list_del(&hook->list);
+		nft_netdev_hook_free_rcu(hook);
+		list_del(&trans_hook->list);
+		kfree(trans_hook);
+
+	}
+}
+
 static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 				struct nft_flowtable *flowtable,
 				struct netlink_ext_ack *extack)
@@ -9237,6 +9307,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_flowtable_hook flowtable_hook;
+	struct nft_trans_hook *trans_hook, *next;
 	LIST_HEAD(flowtable_del_list);
 	struct nft_hook *this, *hook;
 	struct nft_trans *trans;
@@ -9253,7 +9324,14 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 			err = -ENOENT;
 			goto err_flowtable_del_hook;
 		}
-		list_move(&hook->list, &flowtable_del_list);
+		trans_hook = kmalloc(sizeof(*trans_hook), GFP_KERNEL);
+		if (!trans_hook) {
+			err = -ENOMEM;
+			goto err_flowtable_del_hook;
+		}
+		trans_hook->hook = hook;
+		list_add_tail(&trans_hook->list, &flowtable_del_list);
+		hook->flags |= NFT_HOOK_REMOVE;
 	}
 
 	trans = nft_trans_alloc(ctx, NFT_MSG_DELFLOWTABLE,
@@ -9274,7 +9352,11 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 	return 0;
 
 err_flowtable_del_hook:
-	list_splice(&flowtable_del_list, &flowtable->hook_list);
+	list_for_each_entry_safe(trans_hook, next, &flowtable_del_list, list) {
+		list_del(&trans_hook->list);
+		trans_hook->hook->flags &= ~NFT_HOOK_REMOVE;
+		kfree(trans_hook);
+	}
 	nft_flowtable_hook_release(&flowtable_hook);
 
 	return err;
@@ -10112,7 +10194,7 @@ static void nft_commit_release(struct nft_trans *trans)
 	case NFT_MSG_DELCHAIN:
 	case NFT_MSG_DESTROYCHAIN:
 		if (nft_trans_chain_update(trans))
-			nft_hooks_destroy(&nft_trans_chain_hooks(trans));
+			nft_hooks_trans_destroy(&nft_trans_chain_hooks(trans));
 		else
 			nf_tables_chain_destroy(nft_trans_chain(trans));
 		break;
@@ -10135,7 +10217,7 @@ static void nft_commit_release(struct nft_trans *trans)
 	case NFT_MSG_DELFLOWTABLE:
 	case NFT_MSG_DESTROYFLOWTABLE:
 		if (nft_trans_flowtable_update(trans))
-			nft_hooks_destroy(&nft_trans_flowtable_hooks(trans));
+			nft_hooks_trans_destroy(&nft_trans_flowtable_hooks(trans));
 		else
 			nf_tables_flowtable_destroy(nft_trans_flowtable(trans));
 		break;
@@ -10928,9 +11010,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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
@@ -11060,9 +11141,9 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 							   nft_trans_flowtable(trans),
 							   &nft_trans_flowtable_hooks(trans),
 							   trans->msg_type);
-				nft_unregister_flowtable_net_hooks(net,
-								   nft_trans_flowtable(trans),
-								   &nft_trans_flowtable_hooks(trans));
+				nft_flowtable_unregister_hooks_trans(net,
+								     nft_trans_flowtable(trans),
+								     &nft_trans_flowtable_hooks(trans));
 			} else {
 				list_del_rcu(&nft_trans_flowtable(trans)->list);
 				nf_tables_flowtable_notify(&ctx,
@@ -11158,6 +11239,17 @@ static void nft_set_abort_update(struct list_head *set_update_list)
 	}
 }
 
+static void nft_hooks_trans_abort(struct list_head *trans_hook_list)
+{
+	struct nft_trans_hook *trans_hook, *next;
+
+	list_for_each_entry_safe(trans_hook, next, trans_hook_list, list) {
+		trans_hook->hook->flags &= ~NFT_HOOK_REMOVE;
+		list_del(&trans_hook->list);
+		kfree(trans_hook);
+	}
+}
+
 static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
@@ -11231,8 +11323,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		case NFT_MSG_DELCHAIN:
 		case NFT_MSG_DESTROYCHAIN:
 			if (nft_trans_chain_update(trans)) {
-				list_splice(&nft_trans_chain_hooks(trans),
-					    &nft_trans_basechain(trans)->hook_list);
+				nft_hooks_trans_abort(&nft_trans_chain_hooks(trans));
 			} else {
 				nft_use_inc_restore(&table->use);
 				nft_clear(trans->net, nft_trans_chain(trans));
@@ -11346,8 +11437,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		case NFT_MSG_DELFLOWTABLE:
 		case NFT_MSG_DESTROYFLOWTABLE:
 			if (nft_trans_flowtable_update(trans)) {
-				list_splice(&nft_trans_flowtable_hooks(trans),
-					    &nft_trans_flowtable(trans)->hook_list);
+				nft_hooks_trans_abort(&nft_trans_flowtable_hooks(trans));
 			} else {
 				nft_use_inc_restore(&table->use);
 				nft_clear(trans->net, nft_trans_flowtable(trans));
-- 
2.47.3

