Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69971891A9
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 06:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776665974; cv=none; b=rYWQk8BZzpsd58M+7BzIEThFMxTIJKSlTNK/iKCVZZb/+7PLZGVGd2nsiLHoHH6SHAI9Q2laDUGCUdElEJrfBpub2xvzxJwk7+mKSahbrKvkfBrHwmgsN0zPkbge9a4S9hASY8+kz0GRzmggLnUVUx7CIe1qNY7fnvGgGIAMKAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776665974; c=relaxed/simple;
	bh=iMcD6b6Me6O6lojDg+I3aPhZLrZGIucvZy9bFgfcTzs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ZixQY7e3b2NbpDUlahHSZwLi1oSUrXxMJc+lRaAd6eTwMgkHBoiWNIrL9u2KdLQ/moZxi8yIiUmli5VimO1Isl3yH+l2tyTSVLu0KK6yL+KZmstxLeOJpZVK8DFfCOd7ytt+TnAI/Qzeiuwq8L0x9cRYHMifTxXucj/Q5cgxqew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CGb849z4; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CGb849z4"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DB59360177
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 08:19:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776665969;
	bh=ZrzHuiicz9yWjCZVh3K5jv2UywpHODoIAzsY1iJMJTs=;
	h=From:To:Subject:Date:From;
	b=CGb849z445YNewgxBoeparQD/lxKG8ebz+1TFpcK3mWGaq93EWmfnNhgvv/rypim7
	 39+/NnSubK61RjTbI+3Cfs8DcrTK52vk1tybehuF3U4tDDb3zkGkDJ8AxBKDeiWz63
	 yor87OyS5DJE70f9QdmAlH27NKtSEwjpXjC7EvdJeVIjT1Vq77IrjX0ajZSC6b5hmN
	 JArxXvgcRXkt0fSyygYi4/zL2TfNbXuoRGYRJn9OSatnN1aV2hMAjFEm5/Im6QmXhm
	 q6FuOBE0NTkMdNTdB+47UmVWtVlAcwx/2SlX3cBCiTZdBza89d6xSROd38l/g8x3EJ
	 q5vZjCS0o7BBQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v7 1/4] netfilter: nf_tables: use list_del_rcu for netlink hooks
Date: Mon, 20 Apr 2026 08:19:21 +0200
Message-ID: <20260420061924.69302-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

nft_netdev_unregister_hooks and __nft_unregister_flowtable_net_hooks need
to use list_del_rcu(), this list can be walked by concurrent dumpers.

Add a new helper and use it consistently.

Fixes: f9a43007d3f7 ("netfilter: nf_tables: double hook unregistration in netns path")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 44 ++++++++++++++---------------------
 1 file changed, 18 insertions(+), 26 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8537b94653d3..07e151245765 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -374,6 +374,12 @@ static void nft_netdev_hook_free_rcu(struct nft_hook *hook)
 	call_rcu(&hook->rcu, __nft_netdev_hook_free_rcu);
 }
 
+static void nft_netdev_hook_unlink_free_rcu(struct nft_hook *hook)
+{
+	list_del_rcu(&hook->list);
+	nft_netdev_hook_free_rcu(hook);
+}
+
 static void nft_netdev_unregister_hooks(struct net *net,
 					struct list_head *hook_list,
 					bool release_netdev)
@@ -384,10 +390,8 @@ static void nft_netdev_unregister_hooks(struct net *net,
 	list_for_each_entry_safe(hook, next, hook_list, list) {
 		list_for_each_entry(ops, &hook->ops_list, list)
 			nf_unregister_net_hook(net, ops);
-		if (release_netdev) {
-			list_del(&hook->list);
-			nft_netdev_hook_free_rcu(hook);
-		}
+		if (release_netdev)
+			nft_netdev_hook_unlink_free_rcu(hook);
 	}
 }
 
@@ -2271,10 +2275,8 @@ void nf_tables_chain_destroy(struct nft_chain *chain)
 
 		if (nft_base_chain_netdev(table->family, basechain->ops.hooknum)) {
 			list_for_each_entry_safe(hook, next,
-						 &basechain->hook_list, list) {
-				list_del_rcu(&hook->list);
-				nft_netdev_hook_free_rcu(hook);
-			}
+						 &basechain->hook_list, list)
+				nft_netdev_hook_unlink_free_rcu(hook);
 		}
 		module_put(basechain->type->owner);
 		if (rcu_access_pointer(basechain->stats)) {
@@ -2974,6 +2976,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 				list_for_each_entry(ops, &h->ops_list, list)
 					nf_unregister_net_hook(ctx->net, ops);
 			}
+			/* hook.list is on stack, no need for list_del_rcu() */
 			list_del(&h->list);
 			nft_netdev_hook_free_rcu(h);
 		}
@@ -8852,10 +8855,8 @@ static void __nft_unregister_flowtable_net_hooks(struct net *net,
 	list_for_each_entry_safe(hook, next, hook_list, list) {
 		list_for_each_entry(ops, &hook->ops_list, list)
 			nft_unregister_flowtable_ops(net, flowtable, ops);
-		if (release_netdev) {
-			list_del(&hook->list);
-			nft_netdev_hook_free_rcu(hook);
-		}
+		if (release_netdev)
+			nft_netdev_hook_unlink_free_rcu(hook);
 	}
 }
 
@@ -8926,8 +8927,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 
 			nft_unregister_flowtable_ops(net, flowtable, ops);
 		}
-		list_del_rcu(&hook->list);
-		nft_netdev_hook_free_rcu(hook);
+		nft_netdev_hook_unlink_free_rcu(hook);
 	}
 
 	return err;
@@ -8937,10 +8937,8 @@ static void nft_hooks_destroy(struct list_head *hook_list)
 {
 	struct nft_hook *hook, *next;
 
-	list_for_each_entry_safe(hook, next, hook_list, list) {
-		list_del_rcu(&hook->list);
-		nft_netdev_hook_free_rcu(hook);
-	}
+	list_for_each_entry_safe(hook, next, hook_list, list)
+		nft_netdev_hook_unlink_free_rcu(hook);
 }
 
 static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
@@ -9028,8 +9026,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 				nft_unregister_flowtable_ops(ctx->net,
 							     flowtable, ops);
 		}
-		list_del_rcu(&hook->list);
-		nft_netdev_hook_free_rcu(hook);
+		nft_netdev_hook_unlink_free_rcu(hook);
 	}
 
 	return err;
@@ -9535,13 +9532,8 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 
 static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 {
-	struct nft_hook *hook, *next;
-
 	flowtable->data.type->free(&flowtable->data);
-	list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
-		list_del_rcu(&hook->list);
-		nft_netdev_hook_free_rcu(hook);
-	}
+	nft_hooks_destroy(&flowtable->hook_list);
 	kfree(flowtable->name);
 	module_put(flowtable->data.type->owner);
 	kfree(flowtable);
-- 
2.47.3

