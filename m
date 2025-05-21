Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD50529CB3A
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 20:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747860289; cv=none; b=cmEjSSaLDKbLZdlqu39XqGLDKe78Wm+bPHR++4vATWOc/SQr9uLoxtJPxgdH7RL+SpgPtoj+NH+mW+MBautak8juQzYR8YoTGfGwYYwT6TBxhpwnIXYshQ6SxK80dKtMTMLwbWfe94qd8e1bZyVoLIab1Xag42pHgjKbX92gQK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747860289; c=relaxed/simple;
	bh=iarmeuqcibx27iU3z+P1+jCzZNAKrYfJpEhocTZJvFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJLBYhyNcNdiAoS3OfNtjVdpCxDnTB36Hy6KoJyV2YchIlxiNJJY7Bqn64CJoWma1pM2xj5L64H341OAiCQ6JWngiYSwBp1evKEybse8XaF0s86cfOzDD+Y0uIn1WbX7E1qvjTzPyyioKoFHgNd0HeBxVsS94moJvK7bAzxLZLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=m2/WhhqD; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="m2/WhhqD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=DWstikqxtD0guttnYrmNmTZtk+vR6DbzZEgS3VviPgM=; b=m2/WhhqDAGDrWANa287EpNmpEj
	AsIVEOvLKQIW6khUsLBUpOqGBQbccXZhS4jFH5Bd/eOkbnQuA+aYaJK+NW4sOOlGY78DLbKOCFCnt
	Pa/C6gTm6i7KU03VamLDClJ7pHuYUWBiTPQ7J8SsCda4s9rzKI7EncHpyTIyfBzI/jMuAg7JsbsVk
	FkJfGHkJzagF9ogjwadHNvKpkXeqwjWc4pl62AYwhGJGnekhIU3md8mcS2QMMxBXDPKBFe6nnEN4Q
	ce1xVYofz+OujJpy5446wculeaJzB2Rw4dhXtX5EPxBSeDrsDLQHnCB1TJYpqbSKT+X+NOcFnpZ6K
	s6SA/XKw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uHqIw-000000007Ry-0ezr;
	Wed, 21 May 2025 22:44:46 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v7 04/13] netfilter: nf_tables: Pass nf_hook_ops to nft_unregister_flowtable_hook()
Date: Wed, 21 May 2025 22:44:25 +0200
Message-ID: <20250521204434.13210-5-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250521204434.13210-1-phil@nwl.cc>
References: <20250521204434.13210-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function accesses only the hook's ops field, pass it directly. This
prepares for nft_hooks holding a list of nf_hook_ops in future.

While at it, make use of the function in
__nft_unregister_flowtable_net_hooks() as well.

Signed-off-by: Phil Sutter <phil@nwl.cc>
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
2.49.0

