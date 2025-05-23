Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A04A2920BE;
	Fri, 23 May 2025 13:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748006884; cv=none; b=QTp+zdNFo+XVDTE4oEoEPCZmi/0M13yDZTXYddifNffeto+pfGdXEEy55TFIQ4uXhpmCpm/X8ZseKISr59svMRpiVAkgsYF9z5CpWqsh1FIjEdp5QLfT36MaaynXjIVTQoYNSUumDXpTAcaHyX+a4Zoz+SWRrOHx30FMLcEke2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748006884; c=relaxed/simple;
	bh=vNIzA7zz5cUG0dIVCafYhfFGEo+JNyMxc2qv5YpzS2U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Aq0S4U4bpainORH0P3AG4nNC/TtEQ579QMaVL2/eJlPvjcdDEdY7yE6q/ADf360Np8DbefrvDOBB+tbwv0Qv608jvUv+EFq/2a4BjKDSrmnTa7Seo0GUiGJns2X3iaxr3XTk6wv++/ohOmmFxmKNQxxQG2wuzJKoZSAZN6yyHpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hyf4I24F; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=B2w60LKU; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hyf4I24F";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="B2w60LKU"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id DB51B602B6; Fri, 23 May 2025 15:28:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006881;
	bh=7tCsy85K6KSWtiqB9l4Z3E6bSxiLQWl/KZ/VdM1Z28A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hyf4I24FWXv0NLCq76h2px+GQTlGHkZr7tXPkPoSuEyj5lznv6VsLR34X2/MXAESX
	 RZfw/oq5vZ01mqJrYujrqpb9QlOXOSuZTVnl/1/LWQ18pPhH6S1+9fIaBvB0SVI83I
	 tlM7VvIv8iYt4HQ21nMr/v4e6lsJ2hN0KQ9hZ5nZOxE3SVPMvI80KGnCsJdPexxbto
	 idAznAO47RJTfSrFv9o2iWB6LzZxniIg9M0emq6qBvlJw9zH69jlRgMUYHr0lWUVVu
	 Q5/YU9lU7A7KxWN/S3CJK5CM9hg22Axd8hnLdWRvMlJPUJC3rEy3t9+xLhzx0I82t2
	 xozx3vg75PCAA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4E5036076C;
	Fri, 23 May 2025 15:27:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006851;
	bh=7tCsy85K6KSWtiqB9l4Z3E6bSxiLQWl/KZ/VdM1Z28A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B2w60LKUtEdaFCZn01Klk3YwqMC2vmYDRVfCJsK4lZLxrLPZWcDrvRHJPdseKsLZz
	 yM7W38EWmKUy5fqj/M9posydc9A2QiIOqVo/YNqz1Cj332yoziwo6kgOXqnABMhbGG
	 HDs2bZ8sVGAPXyxTwbdPm1ZuG+0NyFR4p2iVdKoQoYNqIXdyxqs5atJemCZKIKHdJx
	 zzlFj6XJjaytd/68iYxrB4/6rDRRB3coEzJpFiykIL/aM9tGWblBKYE+v99chwVm8I
	 Z46z7GkqheU+/sTZwn2Te/BLuHJF7LtHj7t33T4jMLHNAhxIbDtC26noQgnenJFUFK
	 JcJ2wj5ffAw/Q==
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
Date: Fri, 23 May 2025 15:27:03 +0200
Message-Id: <20250523132712.458507-18-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250523132712.458507-1-pablo@netfilter.org>
References: <20250523132712.458507-1-pablo@netfilter.org>
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

