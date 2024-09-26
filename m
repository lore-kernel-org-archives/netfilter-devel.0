Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F32F1AAE15
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 09:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727344611; cv=none; b=AZ/YQ6ykDohV4whOafc5ILaJ57SJGjqadFXWo7q685fIqE/V5hv3qAjbO526/AOArYnu9EI6IS4ie/Oleu2nZw5abVBgCmZlcm4GLSGD29qIF/bee4I99qfowvNtUYLUkxE0yyhKB2KueZ5Rpo8hpNfjypkGY24thYuF5FZ1Dzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727344611; c=relaxed/simple;
	bh=3npXLVHBWxSx+tbcgDep4fLJH+iuhRSiEFVadXhnBCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGahbMbjidIaeJ5g/RqicwUab2kj/0pk5k+yPkhgqb8jsWm7aKnJfAaxCF6rc/SvOo3K/6TcU6BEyR9oW61MvfiDzKeRojUk4693fQ+cQ8iS6NTQVNCcGIFsN9X3TNSlNPEqbW2YMH7W8PFlSg49rRvoWWDagUchV3Cm9Zb2zI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ksUqoboc; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ksUqoboc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=er4yfd8DnqiNSGOQEUQVMLhDAqGZWUdGwVqgizU4ud0=; b=ksUqobocI2cv9jZnDVlhdbyoj8
	28UHZeMQylT3qXeIfX8owo+R33zrc8erAx2AGBvLPlErHZgDNCc1PbqHUPoJaiePjZm67lG+FuHen
	glPOdwUea/hAtkSBSmSzhHWk98uyU9zkXhxbzMnRwmAe0rdSWIWITTDKOkKCwJ0BfHYlPemNAC+Rp
	xYczcz7KFu13r/PBxUpddZtbOSlSyfwuqfifiMBaJT1J0tlqSeAWGqUjS32ksMeEQN6P3ELg8VhjX
	sngl8TtGIByW83ViLjcoqbxC4hdFBQA6XgZduJ9yHXHJdlknOCz8xTmKrmxQjvF/cA2dP9BCnSrRe
	OAdY5wQw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1stlEs-000000006Ez-2Vg5;
	Thu, 26 Sep 2024 11:56:46 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v5 07/18] netfilter: nf_tables: Introduce functions freeing nft_hook objects
Date: Thu, 26 Sep 2024 11:56:32 +0200
Message-ID: <20240926095643.8801-8-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240926095643.8801-1-phil@nwl.cc>
References: <20240926095643.8801-1-phil@nwl.cc>
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

