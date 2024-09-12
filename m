Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC481A4E86
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 12:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726145111; cv=none; b=fmWQxuZ0acwB+nWL9oSx74QUBuxWAKgpo96sTiiFw+stHGWjgaqWVCX0EMbPFCCmgNKAnDZBOC7JvyHfn/R9a+K7pEa1fUmV0F/HWbczhtyrKQHna2WbqBG11Ai6ateMS6eOM8jjicUJov2w5wLHodIcewAJqSZr7YeloVwu9Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726145111; c=relaxed/simple;
	bh=AOJzP7L9CVFLLH6enQeKfHGrjIcAwPvZfVhdtt++umE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FjVUdTQ/yOpCRPY5W7mAimDI48uurna9n0BpkA2QNIEgXbXN+2hWDBoc+1XhX8NVM8P9Gg9aQtmIjiWsCUSCziXjFmojG8IYQ3BnzkgE/V2DGYix5REv7/qt6ry+JRDtj8+7Rqkzuw7LqD45T+eLxqLIADXvj2eCo2Q+/28/ib4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=cOU+N0cS; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="cOU+N0cS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BXvDvxGBaGUh8J3gzHo7AhJpYAexo6b3uK4i8Ag1KoE=; b=cOU+N0cSYPUhOtxUNBwKvjUOoB
	VlWtr66OaBOTO3sjn8+mCbQrA+SZnW5mIAkM69TTrXi+v7NzfR+VrBdW4wQ62BXJrlj8DSuejHDMI
	Axr9cEdhSmxheO+EkBxFKiZWZBb5mqdywgV3BGFqFM/yaXznjTMXNdYuNkMoCRG1lfIjDXFrpCVRL
	8Cyq8sbtIM4eDMK6AJ/ExmENKNIoe94PWh4zSeZZoRg2QD3t7TT+ycMXjrc5zPPgj3En1VRcDNway
	QBXM8UVCwYevzzML5z0DZPfcCIg9kHyN7MMXCvJUUd0lpce2Z8GHfAsleAdkU1PyzR8dnfPSbf2JY
	amOd3mng==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1soipj-000000004ER-2Fu7;
	Thu, 12 Sep 2024 14:21:59 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v3 07/16] netfilter: nf_tables: Introduce functions freeing nft_hook objects
Date: Thu, 12 Sep 2024 14:21:39 +0200
Message-ID: <20240912122148.12159-8-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240912122148.12159-1-phil@nwl.cc>
References: <20240912122148.12159-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pointless wrappers around kfree() for now, prep work for an embedded
list of nf_hook_ops.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 46d4e9056bf1..dedf50ba266c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2134,6 +2134,16 @@ static void nf_tables_chain_free_chain_rules(struct nft_chain *chain)
 	kvfree(chain->blob_next);
 }
 
+static void nft_netdev_hook_free(struct nft_hook *hook)
+{
+	kfree(hook);
+}
+
+static void nft_netdev_hook_free_rcu(struct nft_hook *hook)
+{
+	kfree_rcu(hook, rcu);
+}
+
 void nf_tables_chain_destroy(struct nft_chain *chain)
 {
 	const struct nft_table *table = chain->table;
@@ -2152,7 +2162,7 @@ void nf_tables_chain_destroy(struct nft_chain *chain)
 			list_for_each_entry_safe(hook, next,
 						 &basechain->hook_list, list) {
 				list_del_rcu(&hook->list);
-				kfree_rcu(hook, rcu);
+				nft_netdev_hook_free_rcu(hook);
 			}
 		}
 		module_put(basechain->type->owner);
@@ -2240,7 +2250,7 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
 		}
 		if (nft_hook_list_find(hook_list, hook)) {
 			NL_SET_BAD_ATTR(extack, tmp);
-			kfree(hook);
+			nft_netdev_hook_free(hook);
 			err = -EEXIST;
 			goto err_hook;
 		}
@@ -2258,7 +2268,7 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
 err_hook:
 	list_for_each_entry_safe(hook, next, hook_list, list) {
 		list_del(&hook->list);
-		kfree(hook);
+		nft_netdev_hook_free(hook);
 	}
 	return err;
 }
@@ -2401,7 +2411,7 @@ static void nft_chain_release_hook(struct nft_chain_hook *hook)
 
 	list_for_each_entry_safe(h, next, &hook->list, list) {
 		list_del(&h->list);
-		kfree(h);
+		nft_netdev_hook_free(h);
 	}
 	module_put(hook->type->owner);
 }
@@ -2691,7 +2701,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 
 				if (nft_hook_list_find(&basechain->hook_list, h)) {
 					list_del(&h->list);
-					kfree(h);
+					nft_netdev_hook_free(h);
 				}
 			}
 		} else {
@@ -2812,7 +2822,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 			if (unregister)
 				nf_unregister_net_hook(ctx->net, &h->ops);
 			list_del(&h->list);
-			kfree_rcu(h, rcu);
+			nft_netdev_hook_free_rcu(h);
 		}
 		module_put(hook.type->owner);
 	}
@@ -8586,7 +8596,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 
 		nft_unregister_flowtable_hook(net, flowtable, hook);
 		list_del_rcu(&hook->list);
-		kfree_rcu(hook, rcu);
+		nft_netdev_hook_free_rcu(hook);
 	}
 
 	return err;
@@ -8598,7 +8608,7 @@ static void nft_hooks_destroy(struct list_head *hook_list)
 
 	list_for_each_entry_safe(hook, next, hook_list, list) {
 		list_del_rcu(&hook->list);
-		kfree_rcu(hook, rcu);
+		nft_netdev_hook_free_rcu(hook);
 	}
 }
 
@@ -8622,7 +8632,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 	list_for_each_entry_safe(hook, next, &flowtable_hook.list, list) {
 		if (nft_hook_list_find(&flowtable->hook_list, hook)) {
 			list_del(&hook->list);
-			kfree(hook);
+			nft_netdev_hook_free(hook);
 		}
 	}
 
@@ -8669,7 +8679,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 		if (unregister)
 			nft_unregister_flowtable_hook(ctx->net, flowtable, hook);
 		list_del_rcu(&hook->list);
-		kfree_rcu(hook, rcu);
+		nft_netdev_hook_free_rcu(hook);
 	}
 
 	return err;
@@ -8815,7 +8825,7 @@ static void nft_flowtable_hook_release(struct nft_flowtable_hook *flowtable_hook
 
 	list_for_each_entry_safe(this, next, &flowtable_hook->list, list) {
 		list_del(&this->list);
-		kfree(this);
+		nft_netdev_hook_free(this);
 	}
 }
 
@@ -9179,7 +9189,7 @@ static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
 					    FLOW_BLOCK_UNBIND);
 		list_del_rcu(&hook->list);
-		kfree_rcu(hook, rcu);
+		nft_netdev_hook_free_rcu(hook);
 	}
 	kfree(flowtable->name);
 	module_put(flowtable->data.type->owner);
-- 
2.43.0

