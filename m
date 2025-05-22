Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A9D29AB1F;
	Thu, 22 May 2025 16:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747932802; cv=none; b=B1ey93dyNrGNDgVLheDQX+udziRa1V8kkxBa8E43Clmwh3LO/8ZGL6+E1w58Jl4W4znKZc/elovmQhAtGrjSTbLFGTheR0dal7SydX0udE6LJET+L7LhCfjsSJQXjQ3iKlj7vurlPVcdhkhdgs7v8+Fh0ZovPSe3asYJBSeoI1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747932802; c=relaxed/simple;
	bh=+t8LFOqD1QLwOd9cGovdb9rg5l8hbaP0DFiPMQRLg1g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PRBaXe1FLEvg2G8uy5De/vTtdCezM3vxpBWna9Ilfzczzjs87uu4VweyTaJA+14ioJDOHap/Nvh0PrE4mlMd6ji+taD4SRhkPaCWFxdB4iQi6NWHTnW/ATrJO0IXFxzgkn3HMfd2qBretm9bwRQnrFEJtzOELzih4SuPQueWHsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TgiVFFWh; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sbpuynVU; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TgiVFFWh";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sbpuynVU"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 68324606EC; Thu, 22 May 2025 18:53:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932799;
	bh=Ef6gq6DawuimOIDQi247P7RvHBIS9S5NQYQL6jELAW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TgiVFFWhtuw+ZkuIqmx1NXC6A+HrwjDzaYUbHdz0q22bmCS0BFlX5ep1igy67ikvi
	 DAuC+CRB7TsTk5rwlU7BQ50NK1o+HI3znaMDJQoMuxoWYKWZzZzb7bVat3KbbIMlnh
	 NMNYgf95s3IOjRN6mxl2UpqVj9UCQz9/gAtDBK7EL7WX8k5hbSwRSXFCFU/xH/fbJy
	 WbL5ONXD9x9xb6/uJcB8E2fvc2wAY+Dx+8kovQ7oZEA+/bFU3s41X+hAaS8hTP0t05
	 1KnNvXndgTGl9e8KINI3VHScf0SLzDdoCsV0MZ9lx8MswR1ZbNUzrOd7Bb/HwsWPcK
	 45QH88sGZ8oHQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F16A96073A;
	Thu, 22 May 2025 18:52:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932776;
	bh=Ef6gq6DawuimOIDQi247P7RvHBIS9S5NQYQL6jELAW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sbpuynVUWzlcmWvkzmwdT+Im8dIPsQjhaPbvGcmCjWm9gN0zQLFgyLhofinS5UOgl
	 pvvcoSu4F3UJFP7OEtOsSKN5hyX4STVTpMHqMhlrw9pSuUnPM6KRhbu6y0Bw2/19mA
	 6c6NQr+S7R/H/tlHtGL4ooklHOOH4uEXQ198nCp7UdBQcGtXMZbgjz7b8KdYywWcM5
	 UUmaavz+bRyFnMHH1ZFKniT48V6cGVyO4F5dCHfjIeX6rkkFmAZTn5HXYvyJe2egPv
	 z1+VSaLr50nl359PIZD6xydqJ2jJw+wLb2/XZFhROYjNKBuEroHxLRKcD+T+q8ZjVT
	 BwaFAtxM71xEg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 14/26] netfilter: nf_tables: Introduce functions freeing nft_hook objects
Date: Thu, 22 May 2025 18:52:26 +0200
Message-Id: <20250522165238.378456-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250522165238.378456-1-pablo@netfilter.org>
References: <20250522165238.378456-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

Pointless wrappers around kfree() for now, prep work for an embedded
list of nf_hook_ops.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 38 ++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b28f6730e26d..9998fcf44a38 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -323,6 +323,16 @@ static int nft_netdev_register_hooks(struct net *net,
 	return err;
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
 static void nft_netdev_unregister_hooks(struct net *net,
 					struct list_head *hook_list,
 					bool release_netdev)
@@ -333,7 +343,7 @@ static void nft_netdev_unregister_hooks(struct net *net,
 		nf_unregister_net_hook(net, &hook->ops);
 		if (release_netdev) {
 			list_del(&hook->list);
-			kfree_rcu(hook, rcu);
+			nft_netdev_hook_free_rcu(hook);
 		}
 	}
 }
@@ -2253,7 +2263,7 @@ void nf_tables_chain_destroy(struct nft_chain *chain)
 			list_for_each_entry_safe(hook, next,
 						 &basechain->hook_list, list) {
 				list_del_rcu(&hook->list);
-				kfree_rcu(hook, rcu);
+				nft_netdev_hook_free_rcu(hook);
 			}
 		}
 		module_put(basechain->type->owner);
@@ -2345,7 +2355,7 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
 		}
 		if (nft_hook_list_find(hook_list, hook)) {
 			NL_SET_BAD_ATTR(extack, tmp);
-			kfree(hook);
+			nft_netdev_hook_free(hook);
 			err = -EEXIST;
 			goto err_hook;
 		}
@@ -2363,7 +2373,7 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
 err_hook:
 	list_for_each_entry_safe(hook, next, hook_list, list) {
 		list_del(&hook->list);
-		kfree(hook);
+		nft_netdev_hook_free(hook);
 	}
 	return err;
 }
@@ -2506,7 +2516,7 @@ static void nft_chain_release_hook(struct nft_chain_hook *hook)
 
 	list_for_each_entry_safe(h, next, &hook->list, list) {
 		list_del(&h->list);
-		kfree(h);
+		nft_netdev_hook_free(h);
 	}
 	module_put(hook->type->owner);
 }
@@ -2795,7 +2805,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 
 				if (nft_hook_list_find(&basechain->hook_list, h)) {
 					list_del(&h->list);
-					kfree(h);
+					nft_netdev_hook_free(h);
 				}
 			}
 		} else {
@@ -2916,7 +2926,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 			if (unregister)
 				nf_unregister_net_hook(ctx->net, &h->ops);
 			list_del(&h->list);
-			kfree_rcu(h, rcu);
+			nft_netdev_hook_free_rcu(h);
 		}
 		module_put(hook.type->owner);
 	}
@@ -8907,7 +8917,7 @@ static void __nft_unregister_flowtable_net_hooks(struct net *net,
 					    FLOW_BLOCK_UNBIND);
 		if (release_netdev) {
 			list_del(&hook->list);
-			kfree_rcu(hook, rcu);
+			nft_netdev_hook_free_rcu(hook);
 		}
 	}
 }
@@ -8965,7 +8975,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 
 		nft_unregister_flowtable_hook(net, flowtable, hook);
 		list_del_rcu(&hook->list);
-		kfree_rcu(hook, rcu);
+		nft_netdev_hook_free_rcu(hook);
 	}
 
 	return err;
@@ -8977,7 +8987,7 @@ static void nft_hooks_destroy(struct list_head *hook_list)
 
 	list_for_each_entry_safe(hook, next, hook_list, list) {
 		list_del_rcu(&hook->list);
-		kfree_rcu(hook, rcu);
+		nft_netdev_hook_free_rcu(hook);
 	}
 }
 
@@ -9001,7 +9011,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 	list_for_each_entry_safe(hook, next, &flowtable_hook.list, list) {
 		if (nft_hook_list_find(&flowtable->hook_list, hook)) {
 			list_del(&hook->list);
-			kfree(hook);
+			nft_netdev_hook_free(hook);
 		}
 	}
 
@@ -9048,7 +9058,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 		if (unregister)
 			nft_unregister_flowtable_hook(ctx->net, flowtable, hook);
 		list_del_rcu(&hook->list);
-		kfree_rcu(hook, rcu);
+		nft_netdev_hook_free_rcu(hook);
 	}
 
 	return err;
@@ -9194,7 +9204,7 @@ static void nft_flowtable_hook_release(struct nft_flowtable_hook *flowtable_hook
 
 	list_for_each_entry_safe(this, next, &flowtable_hook->list, list) {
 		list_del(&this->list);
-		kfree(this);
+		nft_netdev_hook_free(this);
 	}
 }
 
@@ -9557,7 +9567,7 @@ static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 	flowtable->data.type->free(&flowtable->data);
 	list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
 		list_del_rcu(&hook->list);
-		kfree_rcu(hook, rcu);
+		nft_netdev_hook_free_rcu(hook);
 	}
 	kfree(flowtable->name);
 	module_put(flowtable->data.type->owner);
-- 
2.30.2

