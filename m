Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EB6184521
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2024 20:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726863841; cv=none; b=KrKGgoRi0C+x0nT/aEXNjttPdC54nwHwwfH2JCSVG+3e5/Sop4nVeao/gckCYtI3+9R1QQWK7LmYjqWrJK9pXVab/Y08WXzuZq2UFnKcmfJv3BWejI1fNBYZ1CJqZtWkP2p63qTfwyvmsEOwGYSJa/zc7TYhemBkdYWl+oaVb/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726863841; c=relaxed/simple;
	bh=phwWkCO+jVaA0NrBpHF/jXnEH2NFvivYhKhsgIKNyp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAWODdQy3N/S987fa+1F/vUsgpxvX1+pVbjkb3YDlc5a9muJDBqv1iiWoiJWKGpRYDj/gHqNHEQwyCu1JUOCQkKAtVyRsvhBJMZhLW+n+OfZBcJ7i7rk3fwL64madneUu30kdp2W8tKFKoPRFEi+OLcUkgC2oLG7wwTV5UfYrik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=HUVsURDU; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="HUVsURDU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ijZLjVESof7dFoBf1x5pzLbdf9MiSmplBKhxMX/UKMI=; b=HUVsURDUN3LIAavaiyJNQ17NwN
	1GDFW5lirsT00NX0RHKSGt4PUaM2Tk9dvdRr9tcoPUFVj3QgqqO7PkGAqqcJvxJDf12GzaK+kynRy
	tZvzzIy2UfJGyiBVGyVfszj5TBuIjd0dzqltxYjEJ6TzsvFSBSejZyPOMOFX0vk+gHNjRDrlInP/T
	J2hK6q8CmHo+e+EJdxNy7k+pDrnvAwkOkCIX4afINhGJyf6CYbFMFYoadHFOvDhjWZgnAkUm/wFIY
	R7d47yabWsJYHx6jE37M6rPolRjK+aEQHV9USwz6eiRNzfZS2dA2+8kpyREWBic7KaEOIJI67x9x2
	7B9OEDPw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1srkAT-000000006IP-1cLQ;
	Fri, 20 Sep 2024 22:23:53 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v4 06/16] netfilter: nf_tables: Introduce functions freeing nft_hook objects
Date: Fri, 20 Sep 2024 22:23:37 +0200
Message-ID: <20240920202347.28616-7-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240920202347.28616-1-phil@nwl.cc>
References: <20240920202347.28616-1-phil@nwl.cc>
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
Changes since v3:
- Move function declarations up and use the wrapper in
  nft_netdev_unregister_hooks(), too.
---
 net/netfilter/nf_tables_api.c | 36 ++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f77ba323a906..a0482c7fc659 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -322,6 +322,16 @@ static int nft_netdev_register_hooks(struct net *net,
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
@@ -332,7 +342,7 @@ static void nft_netdev_unregister_hooks(struct net *net,
 		nf_unregister_net_hook(net, &hook->ops);
 		if (release_netdev) {
 			list_del(&hook->list);
-			kfree_rcu(hook, rcu);
+			nft_netdev_hook_free_rcu(hook);
 		}
 	}
 }
@@ -2152,7 +2162,7 @@ void nf_tables_chain_destroy(struct nft_chain *chain)
 			list_for_each_entry_safe(hook, next,
 						 &basechain->hook_list, list) {
 				list_del_rcu(&hook->list);
-				kfree_rcu(hook, rcu);
+				nft_netdev_hook_free_rcu(hook);
 			}
 		}
 		module_put(basechain->type->owner);
@@ -2244,7 +2254,7 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
 		}
 		if (nft_hook_list_find(hook_list, hook)) {
 			NL_SET_BAD_ATTR(extack, tmp);
-			kfree(hook);
+			nft_netdev_hook_free(hook);
 			err = -EEXIST;
 			goto err_hook;
 		}
@@ -2262,7 +2272,7 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
 err_hook:
 	list_for_each_entry_safe(hook, next, hook_list, list) {
 		list_del(&hook->list);
-		kfree(hook);
+		nft_netdev_hook_free(hook);
 	}
 	return err;
 }
@@ -2405,7 +2415,7 @@ static void nft_chain_release_hook(struct nft_chain_hook *hook)
 
 	list_for_each_entry_safe(h, next, &hook->list, list) {
 		list_del(&h->list);
-		kfree(h);
+		nft_netdev_hook_free(h);
 	}
 	module_put(hook->type->owner);
 }
@@ -2695,7 +2705,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 
 				if (nft_hook_list_find(&basechain->hook_list, h)) {
 					list_del(&h->list);
-					kfree(h);
+					nft_netdev_hook_free(h);
 				}
 			}
 		} else {
@@ -2816,7 +2826,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 			if (unregister)
 				nf_unregister_net_hook(ctx->net, &h->ops);
 			list_del(&h->list);
-			kfree_rcu(h, rcu);
+			nft_netdev_hook_free_rcu(h);
 		}
 		module_put(hook.type->owner);
 	}
@@ -8617,7 +8627,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 
 		nft_unregister_flowtable_hook(net, flowtable, hook);
 		list_del_rcu(&hook->list);
-		kfree_rcu(hook, rcu);
+		nft_netdev_hook_free_rcu(hook);
 	}
 
 	return err;
@@ -8629,7 +8639,7 @@ static void nft_hooks_destroy(struct list_head *hook_list)
 
 	list_for_each_entry_safe(hook, next, hook_list, list) {
 		list_del_rcu(&hook->list);
-		kfree_rcu(hook, rcu);
+		nft_netdev_hook_free_rcu(hook);
 	}
 }
 
@@ -8653,7 +8663,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 	list_for_each_entry_safe(hook, next, &flowtable_hook.list, list) {
 		if (nft_hook_list_find(&flowtable->hook_list, hook)) {
 			list_del(&hook->list);
-			kfree(hook);
+			nft_netdev_hook_free(hook);
 		}
 	}
 
@@ -8700,7 +8710,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 		if (unregister)
 			nft_unregister_flowtable_hook(ctx->net, flowtable, hook);
 		list_del_rcu(&hook->list);
-		kfree_rcu(hook, rcu);
+		nft_netdev_hook_free_rcu(hook);
 	}
 
 	return err;
@@ -8846,7 +8856,7 @@ static void nft_flowtable_hook_release(struct nft_flowtable_hook *flowtable_hook
 
 	list_for_each_entry_safe(this, next, &flowtable_hook->list, list) {
 		list_del(&this->list);
-		kfree(this);
+		nft_netdev_hook_free(this);
 	}
 }
 
@@ -9210,7 +9220,7 @@ static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
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

