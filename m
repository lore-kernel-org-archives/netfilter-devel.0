Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848871ACDE8
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 12:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726145121; cv=none; b=uYzV4o2xvxwgvljrCwCOSKxuSU1Ly2R3Zk4JuYPNqw492/Me+79r7uQ5MgLAGGHnER7D07M+EhLFI56ZcXSHmu6OLjeXxKchd0f/AagIRyg/d924H1lvjBTsVsEUO68XSfTIy0zIdWDmOF9oIeV2XGOLCYYE87V2XVjHzWHYhB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726145121; c=relaxed/simple;
	bh=G8DD1RodIas8kAhrEk2I3/bPPE5R0aDSPqpXNOtM6VI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nHvAdX6KnJrc4b7T1RtlUE4Mm7+TaWNEvZmF3Wegv3biEepRYNBVe5bZzQIHlr9knTp84S5ZzjwfRutZMtMixR1F0s8lRt/FhSjOannJe8AQZgaXfLhZNvSnws6cyl0fEQOdznzUwqczhZ2W3mJoi4dGwzhtEH2Odg5GMI0Kflw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=F1aZm3q8; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="F1aZm3q8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Yx18rzpzGl7+KBfQrqtuBo19WGDZGJBYYUBVzIw0dFQ=; b=F1aZm3q8L6zbeBS0HD+YrVw+Ph
	hKwgKybKwysmghbIKI1qD0RisAhfzAgOOZOqJAHvoI3eNxB9ZRjwi+l5ZmZiT3z8zbbTqKYIEtRZQ
	kqZRRbzTFNaZSbP3hATw6VnpQ4FfAwD3w5ecQc/3mFHMvOCVwfXSfvgeM9g2m8zyHgOKLxMTXuRtd
	9vvQTZSPiwq4Zs5AQcbNmxUu94gd+d8DnM+yoHwMdBZ8BYE9Yj8RYokIbrhmwg3AwJSXAI+0mX/AV
	J9uKNsck7nJ89nmoAdr6oHbRJZhtyas6heckLTGY3Qj9HHs/Alk9YcxfCoMMAaIvJGpUt3FFyEV4j
	DqeUxe1w==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1soipg-000000004Dw-2pr3;
	Thu, 12 Sep 2024 14:21:56 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v3 06/16] netfilter: nf_tables: Tolerate chains with no remaining hooks
Date: Thu, 12 Sep 2024 14:21:38 +0200
Message-ID: <20240912122148.12159-7-phil@nwl.cc>
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

Do not drop a netdev-family chain if the last interface it is registered
for vanishes. Users dumping and storing the ruleset upon shutdown for
restore upon next boot may otherwise lose the chain and all contained
rules. They will still lose the list of devices, a later patch will fix
that. For now, this aligns the event handler's behaviour with that for
flowtables.
The controversal situation at netns exit should be no problem here:
event handler will unregister the hooks, core nftables cleanup code will
drop the chain itself.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netfilter/nf_tables.h |  2 --
 net/netfilter/nf_tables_api.c     | 21 ---------------------
 net/netfilter/nft_chain_filter.c  | 29 +++++++----------------------
 3 files changed, 7 insertions(+), 45 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index efd6b55b4914..16daffcee0e1 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1228,8 +1228,6 @@ static inline bool nft_is_base_chain(const struct nft_chain *chain)
 	return chain->flags & NFT_CHAIN_BASE;
 }
 
-int __nft_release_basechain(struct nft_ctx *ctx);
-
 unsigned int nft_do_chain(struct nft_pktinfo *pkt, void *priv);
 
 static inline bool nft_use_inc(u32 *use)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 457696f55003..46d4e9056bf1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11386,27 +11386,6 @@ int nft_data_dump(struct sk_buff *skb, int attr, const struct nft_data *data,
 }
 EXPORT_SYMBOL_GPL(nft_data_dump);
 
-int __nft_release_basechain(struct nft_ctx *ctx)
-{
-	struct nft_rule *rule, *nr;
-
-	if (WARN_ON(!nft_is_base_chain(ctx->chain)))
-		return 0;
-
-	nf_tables_unregister_hook(ctx->net, ctx->chain->table, ctx->chain);
-	list_for_each_entry_safe(rule, nr, &ctx->chain->rules, list) {
-		list_del(&rule->list);
-		nft_use_dec(&ctx->chain->use);
-		nf_tables_rule_release(ctx, rule);
-	}
-	nft_chain_del(ctx->chain);
-	nft_use_dec(&ctx->table->use);
-	nf_tables_chain_destroy(ctx->chain);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(__nft_release_basechain);
-
 static void __nft_release_hook(struct net *net, struct nft_table *table)
 {
 	struct nft_flowtable *flowtable;
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 7010541fcca6..543f258b7c6b 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -322,34 +322,19 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 			     struct nft_ctx *ctx)
 {
 	struct nft_base_chain *basechain = nft_base_chain(ctx->chain);
-	struct nft_hook *hook, *found = NULL;
-	int n = 0;
+	struct nft_hook *hook;
 
 	list_for_each_entry(hook, &basechain->hook_list, list) {
-		if (hook->ops.dev == dev)
-			found = hook;
-
-		n++;
-	}
-	if (!found)
-		return;
+		if (hook->ops.dev != dev)
+			continue;
 
-	if (n > 1) {
 		if (!(ctx->chain->table->flags & NFT_TABLE_F_DORMANT))
-			nf_unregister_net_hook(ctx->net, &found->ops);
+			nf_unregister_net_hook(ctx->net, &hook->ops);
 
-		list_del_rcu(&found->list);
-		kfree_rcu(found, rcu);
-		return;
+		list_del_rcu(&hook->list);
+		kfree_rcu(hook, rcu);
+		break;
 	}
-
-	/* UNREGISTER events are also happening on netns exit.
-	 *
-	 * Although nf_tables core releases all tables/chains, only this event
-	 * handler provides guarantee that hook->ops.dev is still accessible,
-	 * so we cannot skip exiting net namespaces.
-	 */
-	__nft_release_basechain(ctx);
 }
 
 static int nf_tables_netdev_event(struct notifier_block *this,
-- 
2.43.0

