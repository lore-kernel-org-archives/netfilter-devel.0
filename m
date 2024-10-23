Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29001CC177
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2024 14:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695464; cv=none; b=Kd0o56UdixD8TbPediaH+N7WVAjDNUz6O9zL65cd3SHn1bzWPUWlbXr9HmQLJtjFt0/b1WANtzTuxX6lqd0epXQlK3GvXd9yfyxiLQUJu7f3cztP/t2YR8wo/rHCO8JLCcMjNPfacwu1NSgAERnvke51snrBSKE1Ki/TfH7C4ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695464; c=relaxed/simple;
	bh=e8g0CUiEBN5LPKjY0+BAAQQf/XZU3L7TrDN53QKVumI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1rfNHjrafpQPJlNiRPLj2nqjHIvwmMp9I+ZT4nLhbavD080HM7/KENHvetxbkumYrtG7d+RexIf9cqEo/dwenzvm0acTuXZGz/nznsRP1tQMnf1I3l+vlbywuJzheqnrtARq380XN8edoIwSME4y8pKQfXrUTgOsTZLh7zScNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=lwpdZCga; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="lwpdZCga"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NVZtZHQkwC3jLBLXFOzXGpoZGENaP36CO7AAkVAeI1A=; b=lwpdZCgaHEYEXQfuAhRzIifEe1
	tfSwvHqfg6t3lgmrdsV8x2yGATC+ZAerlUD5Gcyq9hXZrbVulTmr1fLawC4AlTYayJGfZd0uGj/zQ
	zfZ8l8j44VWp+ANP0vS08+Xzqbcykoi7a/TRyr0wk1EZO2Nf3NZIYSSagOJap/1jvaRmrV4Hsanbo
	eqVOQDAxJWvHNmf3d7VM4b7eVM0EyrE9kE+hIKm2pNBilWn58FqyFw2ovPNnPqi0f/8hXhoOh2MdP
	1uxM+tzzVrbq7EqeFkR6dFPlnqAfV3jikzFn0AD11PkTWnk9OkkLE3H5JiSteMgIsK/DHuVrqZ+GH
	9UQF7WaA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t3cnm-000000003st-2uAH;
	Wed, 23 Oct 2024 16:57:34 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v6 7/7] netfilter: nf_tables: Drop __nft_unregister_flowtable_net_hooks()
Date: Wed, 23 Oct 2024 16:57:30 +0200
Message-ID: <20241023145730.16896-8-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241023145730.16896-1-phil@nwl.cc>
References: <20241023145730.16896-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function is a 1:1 copy of nft_netdev_unregister_hooks(), use the
latter in its place.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4c2a0caa145d..e6c8314817e0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8548,25 +8548,10 @@ static void nft_unregister_flowtable_hook(struct net *net,
 				    FLOW_BLOCK_UNBIND);
 }
 
-static void __nft_unregister_flowtable_net_hooks(struct net *net,
-						 struct list_head *hook_list,
-					         bool release_netdev)
-{
-	struct nft_hook *hook, *next;
-
-	list_for_each_entry_safe(hook, next, hook_list, list) {
-		nf_unregister_net_hook(net, &hook->ops);
-		if (release_netdev) {
-			list_del(&hook->list);
-			kfree_rcu(hook, rcu);
-		}
-	}
-}
-
 static void nft_unregister_flowtable_net_hooks(struct net *net,
 					       struct list_head *hook_list)
 {
-	__nft_unregister_flowtable_net_hooks(net, hook_list, false);
+	nft_netdev_unregister_hooks(net, hook_list, false);
 }
 
 static int nft_register_flowtable_net_hooks(struct net *net,
@@ -11439,8 +11424,7 @@ static void __nft_release_hook(struct net *net, struct nft_table *table)
 	list_for_each_entry(chain, &table->chains, list)
 		__nf_tables_unregister_hook(net, table, chain, true);
 	list_for_each_entry(flowtable, &table->flowtables, list)
-		__nft_unregister_flowtable_net_hooks(net, &flowtable->hook_list,
-						     true);
+		nft_netdev_unregister_hooks(net, &flowtable->hook_list, true);
 }
 
 static void __nft_release_hooks(struct net *net)
-- 
2.47.0

