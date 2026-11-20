Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795136125;
	b=q4Qi5LBrH3iL4ShjL8A03/sTHfUXONoDPSCzbK5jrKyHEoG/EsM3iMOt4jq8PH8sAbaa
	 D2pIffXvYaEseWXWP4tSi1ZvHGBAEvJ7HYBTjT9S3ixBqb7r0tiG9iErmBEU59tG6pE6+
	 AT6AEqBndBCNJ42LDicZbH4Rzkax7zzsYVdi1lkAPtjZXovexzq2L8nYN5Ev9BeHjz7do
	 zjNfryoPqzv2BIFJpg+PQwZ3gEw8mdXPtaXZuC0b9vOT17npxVEoJ+hMLBzNg0eSCNeMH
	 FbDxYakq8Ej+CEln/RDrW4FxfDFHqQ/a91aHi+MGO9Q/LY4aUsThntSfPADSP82b8Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795136125;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=voneEJeoGuzJ06dQXSZc4U9r3Pgnrvc4A1cmak3XvBk=;
	b=e91wdWcXOfkhTBaYBsS6UW7XUWytwdAZ4w6KRfOindpsS4yNJgNPeyY7z0Ee2RWxCtVS
	 MvyqLvZtV5uYkOxVLJODzUqIDsPbl9claR9DqOSIT5+zgWrDEA4eYIVfbuanpbbhuzb/q
	 mLDz34OVUZ5x5gWq4aqauAnp/w2SIc/I7zGMAjYQTHXZaxuOjR9WLJP28SrSD5IV2zj5x
	 QoASz9hHHlnGvs4bPtcXIBjzgIedzK2KmMHnRQeJyo2EpqhYHcGwDjDMgB5MNBdSiPw5X
	 Boq0gOb4XiE4qUdAKv5EUwir9I2hEucSLmtq0OtWyNvPdRD8ctT8RVX0rlW0BVcDUoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=vyPgjQXR;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E24A606A320
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 00:55:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E24A606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=vyPgjQXR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795136122;
	bh=voneEJeoGuzJ06dQXSZc4U9r3Pgnrvc4A1cmak3XvBk=;
	h=From:To:Subject:Date:From;
	b=vyPgjQXR+FYSrusb1TOU0RLTBlEzNG0mGfxD79Raw1zvc2D0hk9gX0VvO1+ZbIGhg
	 rtuaxZ6L56QtUyZwc7WTyx84fvM1+SPJ2DSt1xVxQ4t8rKAjdZFr9ywxS40JC14PgU
	 gXczWbyK/lzLGHBtB7dxujQ3TvJ2Wo25o0EWRYQg+2lfJHtY2tViJMICmPfWO8zG14
	 VqB6WHDDjrVRilQjLtBMXVVEk30QuJGVixeUyPXTSeedRuKdnNgDIfGfwktegtx7A2
	 KrIEE2iirQiduQalSqaopolojT6Cr4TWNKdWa+QgdV8oqgyhQV/nU30j0reN7iVK8x
	 LEXRF5zUps0dQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E09AD60051
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 01:55:21 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v5 1/3] netfilter: nf_tables: add NFT_HOOK_UNREGISTERED and use it
Date: Fri, 20 Nov 2026 01:55:16 +0100
Message-ID: <20261120005518.3446074-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit f9a43007d3f7 ("netfilter: nf_tables: double hook unregistration
in netns path") fixes a race in the netns exit path with netdev device
event handler. The netns pre_exit handler unregisters the hooks, then
exit release them. In between this two calls, the netdev event might
show up and try to unregister the hooks again. This patch revisit this
fix by adding a new NFT_HOOK_UNREGISTERED flag which allows us to skip
the hook from the netdevice and flowtable event handlers.

This patch is a prerequisit for another follow up fix for the flowtable
hardware offload which allows to unregister the flow_block once the
entries in hardware have been removed.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v5: no changes

 include/net/netfilter/nf_tables.h |  3 +-
 net/netfilter/nf_tables_api.c     | 53 +++++++++++++++----------------
 net/netfilter/nft_chain_filter.c  |  6 ++--
 3 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9d597482363d..5edff5d7dacd 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1209,7 +1209,8 @@ struct nft_stats {
 	struct u64_stats_sync	syncp;
 };
 
-#define NFT_HOOK_REMOVE	(1 << 0)
+#define NFT_HOOK_REMOVE		(1 << 0)
+#define NFT_HOOK_UNREGISTERED	(1 << 1)
 
 struct nft_hook {
 	struct list_head	list;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8b94b5e7dbdb..d3c04a71c924 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -329,6 +329,7 @@ static int nft_netdev_register_hooks(struct net *net,
 
 			j++;
 		}
+		hook->flags &= ~NFT_HOOK_UNREGISTERED;
 	}
 	return 0;
 
@@ -340,6 +341,7 @@ static int nft_netdev_register_hooks(struct net *net,
 
 			nf_unregister_net_hook(net, ops);
 		}
+		hook->flags |= NFT_HOOK_UNREGISTERED;
 	}
 	return err;
 }
@@ -406,19 +408,17 @@ static void nft_netdev_unregister_trans_hook(struct net *net,
 
 static void nft_netdev_unregister_hooks(struct net *net,
 					const struct nft_table *table,
-					struct list_head *hook_list,
-					bool release_netdev)
+					struct list_head *hook_list)
 {
-	struct nft_hook *hook, *next;
+	struct nft_hook *hook;
 	struct nf_hook_ops *ops;
 
-	list_for_each_entry_safe(hook, next, hook_list, list) {
+	list_for_each_entry(hook, hook_list, list) {
 		if (!(table->flags & NFT_TABLE_F_DORMANT)) {
 			list_for_each_entry(ops, &hook->ops_list, list)
 				nf_unregister_net_hook(net, ops);
 		}
-		if (release_netdev)
-			nft_netdev_hook_unlink_free_rcu(hook);
+		hook->flags |= NFT_HOOK_UNREGISTERED;
 	}
 }
 
@@ -447,8 +447,7 @@ static int nf_tables_register_hook(struct net *net,
 
 static void __nf_tables_unregister_hook(struct net *net,
 					const struct nft_table *table,
-					struct nft_chain *chain,
-					bool release_netdev)
+					struct nft_chain *chain)
 {
 	struct nft_base_chain *basechain;
 	const struct nf_hook_ops *ops;
@@ -460,8 +459,7 @@ static void __nf_tables_unregister_hook(struct net *net,
 
 	/* must also be called for dormant tables */
 	if (nft_base_chain_netdev(table->family, basechain->ops.hooknum)) {
-		nft_netdev_unregister_hooks(net, table, &basechain->hook_list,
-					    release_netdev);
+		nft_netdev_unregister_hooks(net, table, &basechain->hook_list);
 		return;
 	}
 
@@ -478,7 +476,7 @@ static void nf_tables_unregister_hook(struct net *net,
 				      const struct nft_table *table,
 				      struct nft_chain *chain)
 {
-	return __nf_tables_unregister_hook(net, table, chain, false);
+	return __nf_tables_unregister_hook(net, table, chain);
 }
 
 static bool nft_trans_collapse_set_elem_allowed(const struct nft_trans_elem *a, const struct nft_trans_elem *b)
@@ -9038,8 +9036,7 @@ static void nft_unregister_flowtable_ops(struct net *net,
 
 static void __nft_unregister_flowtable_net_hooks(struct net *net,
 						 struct nft_flowtable *flowtable,
-						 struct list_head *hook_list,
-					         bool release_netdev)
+						 struct list_head *hook_list)
 {
 	struct nft_hook *hook, *next;
 	struct nf_hook_ops *ops;
@@ -9047,8 +9044,8 @@ static void __nft_unregister_flowtable_net_hooks(struct net *net,
 	list_for_each_entry_safe(hook, next, hook_list, list) {
 		list_for_each_entry(ops, &hook->ops_list, list)
 			nft_unregister_flowtable_ops(net, flowtable, ops);
-		if (release_netdev)
-			nft_netdev_hook_unlink_free_rcu(hook);
+
+		hook->flags |= NFT_HOOK_UNREGISTERED;
 	}
 }
 
@@ -9056,7 +9053,7 @@ static void nft_unregister_flowtable_net_hooks(struct net *net,
 					       struct nft_flowtable *flowtable,
 					       struct list_head *hook_list)
 {
-	__nft_unregister_flowtable_net_hooks(net, flowtable, hook_list, false);
+	__nft_unregister_flowtable_net_hooks(net, flowtable, hook_list);
 }
 
 static int nft_register_flowtable_ops(struct net *net,
@@ -9833,8 +9830,10 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 				continue;
 
 			/* flow_offload_netdev_event() cleans up entries for us. */
-			nft_unregister_flowtable_ops(dev_net(dev),
-						     flowtable, ops);
+			if (!(hook->flags & NFT_HOOK_UNREGISTERED)) {
+				nft_unregister_flowtable_ops(dev_net(dev),
+							     flowtable, ops);
+			}
 			list_del_rcu(&ops->list);
 			kfree_rcu(ops, rcu);
 			break;
@@ -11291,10 +11290,13 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		nf_tables_table_destroy(trans->table);
 		break;
 	case NFT_MSG_NEWCHAIN:
-		if (nft_trans_chain_update(trans))
+		if (nft_trans_chain_update(trans)) {
 			nft_hooks_destroy(&nft_trans_chain_hooks(trans));
-		else
+			free_percpu(nft_trans_chain_stats(trans));
+			kfree(nft_trans_chain_name(trans));
+		} else {
 			nf_tables_chain_destroy(nft_trans_chain(trans));
+		}
 		break;
 	case NFT_MSG_NEWRULE:
 		nf_tables_rule_destroy(&ctx, nft_trans_rule(trans));
@@ -11383,11 +11385,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		case NFT_MSG_NEWCHAIN:
 			if (nft_trans_chain_update(trans)) {
 				nft_netdev_unregister_hooks(net, table,
-							    &nft_trans_chain_hooks(trans),
-							    true);
-				free_percpu(nft_trans_chain_stats(trans));
-				kfree(nft_trans_chain_name(trans));
-				nft_trans_destroy(trans);
+							    &nft_trans_chain_hooks(trans));
 			} else {
 				if (nft_trans_chain_bound(trans)) {
 					nft_trans_destroy(trans);
@@ -12048,11 +12046,10 @@ static void __nft_release_hook(struct net *net, struct nft_table *table)
 	struct nft_chain *chain;
 
 	list_for_each_entry(chain, &table->chains, list)
-		__nf_tables_unregister_hook(net, table, chain, true);
+		__nf_tables_unregister_hook(net, table, chain);
 	list_for_each_entry(flowtable, &table->flowtables, list)
 		__nft_unregister_flowtable_net_hooks(net, flowtable,
-						     &flowtable->hook_list,
-						     true);
+						     &flowtable->hook_list);
 }
 
 static void __nft_release_hooks(struct net *net)
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index e04e689f2228..ffbf5dad3139 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -337,7 +337,8 @@ static int nft_netdev_event(unsigned long event, struct net_device *dev,
 			if (!ops || (changename && match))
 				continue;
 
-			if (!(table->flags & NFT_TABLE_F_DORMANT))
+			if (!(table->flags & NFT_TABLE_F_DORMANT) &&
+			    !(hook->flags & NFT_HOOK_UNREGISTERED))
 				nf_unregister_net_hook(dev_net(dev), ops);
 
 			list_del_rcu(&ops->list);
@@ -356,7 +357,8 @@ static int nft_netdev_event(unsigned long event, struct net_device *dev,
 
 			ops->dev = dev;
 
-			if (!(table->flags & NFT_TABLE_F_DORMANT) &&
+			if ((!(table->flags & NFT_TABLE_F_DORMANT) &&
+			     !(hook->flags & NFT_HOOK_UNREGISTERED)) &&
 			    nf_register_net_hook(dev_net(dev), ops)) {
 				kfree(ops);
 				return 1;
-- 
2.47.3

