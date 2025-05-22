Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F01729CB36;
	Thu, 22 May 2025 16:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747932805; cv=none; b=MBqS6q0YzgwJjMuCCan9e3fNJ+DD70lwJRvqI5QaZECmxWNhH+H2paK3heeCbuo8pissiXaxREiDsrjdluJQRoGi+757oakgXKW1NNJgbDuMSSnHG1MSmjofreyX2iflN4wZWxj/ECltGSpftJUeqRUSaj5zchAYinV3PMygk08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747932805; c=relaxed/simple;
	bh=vNIzA7zz5cUG0dIVCafYhfFGEo+JNyMxc2qv5YpzS2U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IYPcPeV1EbveyhOracfEXWCls7HoPswJohyEpAboluN7SCy/WVVg0KvE0M5LKEdpNxzcg3cB35mTYxKnuSIuuo1wYMs6f2ypeQlzKlo9iLLZLWDBivwVmBccPI3d9KoQLGXrtfWA0rZVMXRjcFqvC/r5HvpvzCBdBWqdKuUJMdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KcrvBukC; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VMZuSW3X; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KcrvBukC";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VMZuSW3X"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 4CB9D606E2; Thu, 22 May 2025 18:53:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932802;
	bh=7tCsy85K6KSWtiqB9l4Z3E6bSxiLQWl/KZ/VdM1Z28A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KcrvBukC7r7gAXMCwf0Q4iYoaQuJJTFtEIcQQjBM7QIMYQYOnld0Kl5eTz/vjl8yy
	 rRuzrLr96ajKH5eKpOwk+NCYLMYosfJJICoD4FLYobYg3lF50Am1Hv70MtPg6AKWa2
	 bbGNUkIRKf6dtRL8eLQ89okVXhJRIId+R8BrdbS/MmxGK0eS4dDsjDD9hAUPLMchZ7
	 EEXTkPviWtETXSF9OI8zFb7r8j0r/DrU4spxVxUMOLAjVO1zPaZ+z41oCn/7KuIorw
	 0vfRW0JMiB1gxtEk9wKpplIJQHUbI+BdS4hyMcdkloK4HWUI3GBgzzTW+YopKvHDVU
	 d2PpxXf71R2Ug==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1C01260747;
	Thu, 22 May 2025 18:52:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932778;
	bh=7tCsy85K6KSWtiqB9l4Z3E6bSxiLQWl/KZ/VdM1Z28A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMZuSW3X2T41nY30LKAaQcSPlQwzjfyIyctI9EmHAwdK7aM1Z1lIcuDI9jhvI3W7h
	 uI9szICsDLa7aUgSzD6QI0va84fUGmU5QH42xx3zGht4U7VND/6WDnUcGdMsVDWxgq
	 2WfAVM9iVitCqD1sp+1y0hhYB3cNUFIEh6PPBjStCpYE5gzl5c6d2yYnNCllAISJmK
	 zhlPr74l1r6IUwFAGRsPQDpotYcWPpacFqVhAwJaUZNFfpNalrFKOywCQHO0a4S8qW
	 pEpM8Mkp3n+nxnnSKS4149yuNGCys2l6MvWEOqAof1eFSQ5gpxoImTbwSN4/2IPg7I
	 jShb3dW2ye3Ow==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 17/26] netfilter: nf_tables: Pass nf_hook_ops to nft_unregister_flowtable_hook()
Date: Thu, 22 May 2025 18:52:29 +0200
Message-Id: <20250522165238.378456-18-pablo@netfilter.org>
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

The function accesses only the hook's ops field, pass it directly. This
prepares for nft_hooks holding a list of nf_hook_ops in future.

While at it, make use of the function in
__nft_unregister_flowtable_net_hooks() as well.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a1d705796282..8fb8bcdfdcb2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8895,12 +8895,12 @@ nft_flowtable_type_get(struct net *net, u8 family)
 }
 
 /* Only called from error and netdev event paths. */
-static void nft_unregister_flowtable_hook(struct net *net,
-					  struct nft_flowtable *flowtable,
-					  struct nft_hook *hook)
+static void nft_unregister_flowtable_ops(struct net *net,
+					 struct nft_flowtable *flowtable,
+					 struct nf_hook_ops *ops)
 {
-	nf_unregister_net_hook(net, &hook->ops);
-	flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
+	nf_unregister_net_hook(net, ops);
+	flowtable->data.type->setup(&flowtable->data, ops->dev,
 				    FLOW_BLOCK_UNBIND);
 }
 
@@ -8912,9 +8912,7 @@ static void __nft_unregister_flowtable_net_hooks(struct net *net,
 	struct nft_hook *hook, *next;
 
 	list_for_each_entry_safe(hook, next, hook_list, list) {
-		nf_unregister_net_hook(net, &hook->ops);
-		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
-					    FLOW_BLOCK_UNBIND);
+		nft_unregister_flowtable_ops(net, flowtable, &hook->ops);
 		if (release_netdev) {
 			list_del(&hook->list);
 			nft_netdev_hook_free_rcu(hook);
@@ -8983,7 +8981,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 		if (i-- <= 0)
 			break;
 
-		nft_unregister_flowtable_hook(net, flowtable, hook);
+		nft_unregister_flowtable_ops(net, flowtable, &hook->ops);
 		list_del_rcu(&hook->list);
 		nft_netdev_hook_free_rcu(hook);
 	}
@@ -9066,7 +9064,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 err_flowtable_update_hook:
 	list_for_each_entry_safe(hook, next, &flowtable_hook.list, list) {
 		if (unregister)
-			nft_unregister_flowtable_hook(ctx->net, flowtable, hook);
+			nft_unregister_flowtable_ops(ctx->net, flowtable, &hook->ops);
 		list_del_rcu(&hook->list);
 		nft_netdev_hook_free_rcu(hook);
 	}
@@ -9639,7 +9637,7 @@ static void nft_flowtable_event(unsigned long event, struct net_device *dev,
 			continue;
 
 		/* flow_offload_netdev_event() cleans up entries for us. */
-		nft_unregister_flowtable_hook(dev_net(dev), flowtable, hook);
+		nft_unregister_flowtable_ops(dev_net(dev), flowtable, ops);
 		list_del_rcu(&hook->list);
 		kfree_rcu(hook, rcu);
 		break;
-- 
2.30.2

