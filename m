Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D369913B7A3
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Apr 2025 09:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744796991; cv=none; b=jmqprIIO5jX4HBnUwIGqYUcYVe4kZBf4ke7Y0pFVoOuyitHKC90gv+OTsVftXEIb7scnemE0SbFFfC+CgWAWriWJLQwKeJTyeq4Hla9vnS5J4ZwK+BZ1mnpI4ebclPNijK1//R9t2omfi6Ngoa6vRrC9NRttUnqjmteeugQULV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744796991; c=relaxed/simple;
	bh=mw75aX+SKiImMjG/06a22vfZZVWJW8WRnigZKx8VBnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tff2OXmR055/rOloFOCyYLHsUWWlX28BKqukEVZSgCNcnh2uDMaEsXAKq+TlLChOJDxYMK8HJs6DAiNMb4vkM6v+cyRISnR2N3kANwYYh4vUchaCROrm6DeSRv4Yn6U2VGNeWjNJqbxieOPoM9lOmu6TiCpKVyUJF81dA5Z2FLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=aZh9OSuW; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="aZh9OSuW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cJ25ihWEzS2roxhZoLuSx2HgHB4hxY7MziqVk/Qk0sA=; b=aZh9OSuWwXXBiyhlegoNo6SoJJ
	1FOdpBs5DISv+4ysdpcc+UaPIu9p3tNVabfe9UnY3onvLKb6BHgIVO/hhSg96v33h4fOcPsi6NERn
	7Cwak9muFxaIbRL+9fN4vkGDl/SW1t574sBjYNUubFhGTG7q3XPp/DYCWhyKq4jXoIvbAkbCRrm0M
	g1IVPJDr1XGf2gBtrSbA8E7Met+WaftONw2p8TTsm7t6UTCq36IxwdRaZiRe2c5Q1DocEDmFckvxo
	lFhdhSP8tlepsmM3tLVkT5l+es0RU0FmjMn+Dmasu1XtRt2FHV//SnsGTawPZcjNWzpvHWuZagXA/
	5Zc7YLQQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1u4zOs-000000006T0-0Rl7;
	Wed, 16 Apr 2025 11:49:46 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v6 04/12] netfilter: nf_tables: Pass nf_hook_ops to nft_unregister_flowtable_hook()
Date: Tue, 15 Apr 2025 17:44:32 +0200
Message-ID: <20250415154440.22371-5-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250415154440.22371-1-phil@nwl.cc>
References: <20250415154440.22371-1-phil@nwl.cc>
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
Changes since v5:
- New patch.
---
 net/netfilter/nf_tables_api.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bc205114527a..f185432b7e90 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8869,12 +8869,12 @@ nft_flowtable_type_get(struct net *net, u8 family)
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
 
@@ -8886,9 +8886,7 @@ static void __nft_unregister_flowtable_net_hooks(struct net *net,
 	struct nft_hook *hook, *next;
 
 	list_for_each_entry_safe(hook, next, hook_list, list) {
-		nf_unregister_net_hook(net, &hook->ops);
-		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
-					    FLOW_BLOCK_UNBIND);
+		nft_unregister_flowtable_ops(net, flowtable, &hook->ops);
 		if (release_netdev) {
 			list_del(&hook->list);
 			nft_netdev_hook_free_rcu(hook);
@@ -8957,7 +8955,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 		if (i-- <= 0)
 			break;
 
-		nft_unregister_flowtable_hook(net, flowtable, hook);
+		nft_unregister_flowtable_ops(net, flowtable, &hook->ops);
 		list_del_rcu(&hook->list);
 		nft_netdev_hook_free_rcu(hook);
 	}
@@ -9040,7 +9038,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 err_flowtable_update_hook:
 	list_for_each_entry_safe(hook, next, &flowtable_hook.list, list) {
 		if (unregister)
-			nft_unregister_flowtable_hook(ctx->net, flowtable, hook);
+			nft_unregister_flowtable_ops(ctx->net, flowtable, &hook->ops);
 		list_del_rcu(&hook->list);
 		nft_netdev_hook_free_rcu(hook);
 	}
@@ -9613,7 +9611,7 @@ static void nft_flowtable_event(unsigned long event, struct net_device *dev,
 			continue;
 
 		/* flow_offload_netdev_event() cleans up entries for us. */
-		nft_unregister_flowtable_hook(dev_net(dev), flowtable, hook);
+		nft_unregister_flowtable_ops(dev_net(dev), flowtable, ops);
 		list_del_rcu(&hook->list);
 		kfree_rcu(hook, rcu);
 		break;
-- 
2.49.0

