Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609741662E7
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2025 17:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736443907; cv=none; b=cl2rOrACXvzY2yOz8d+KJFMQ+meC474JxSbTs95hopPAJ7uXYdNG5yrN04r30YolJZxVs8R2p4qhl+Zrw9qNmaKqAI5+kWk7sS6IcmQa5dCDHPQp5vTg7Upl1v+J1GllGQ4lMbGy0vUYz98CujYnshDKNRlXR1aX1BzcTBIczVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736443907; c=relaxed/simple;
	bh=YxEJc6xB3Y7GaGgN7BnPSiCoskMtr4I4O2+dK4L+rmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ya6vIHvJle5Xfp27AG5P610HFJXw266LSn/zLHluGH9vpinMZ0rpLYNIL7eUe4WEROC65M16yWYWnwqseEKk0H5RT/aFPGwZgYd7uwdYOA7QkXkMM5J+s9PwbjIE77SAzx39mLObdoAJq6DUcL1N9V16xqVyNFSN1lS7MfFF178=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=o4A8mzvK; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="o4A8mzvK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CqUFUjD9UdRv5VQMTeyRpzeuNrZk6U/z+RfgjlxNiBg=; b=o4A8mzvKDTVkIrgpeDFhQsiQH6
	6BJPLD167lukQLXxPOnrqfBQxwtlagkBKxa54IPVy/1x3QkvjXaHhjHLvg/Mijx8zKqtIK84AYopz
	HjeFbory07qAqfxlgebCIbIvYMYpEE1t9SU+ftpVg982+/pJ8FgOvnPGMcylMzSLiq4Y9c9XvKyCk
	ivU96RSTH/LepI3CpszXQToiFw611KbApyDn+gZUpkPXSv716uZEok4TtNl1ECzejKKTi4T0S8Nhj
	XbTi0FfhRkKTVxKp2oCc+NNt0zErxr3Kf7mI2eMXXCMbozmfvc/5kZga9O6NLczWOc0QgBriA1NcS
	6/jii1Zw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tVwNg-000000006MI-2vFM;
	Thu, 09 Jan 2025 18:31:40 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v7 5/6] netfilter: nf_tables: Tolerate chains with no remaining hooks
Date: Thu,  9 Jan 2025 18:31:36 +0100
Message-ID: <20250109173137.17954-6-phil@nwl.cc>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250109173137.17954-1-phil@nwl.cc>
References: <20250109173137.17954-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do not drop a netdev-family chain if the last interface it is registered
for vanishes. Users dumping and storing the ruleset upon shutdown to
restore it upon next boot may otherwise lose the chain and all contained
rules. They will still lose the list of devices, a later patch will fix
that. For now, this aligns the event handler's behaviour with that for
flowtables.
The controversal situation at netns exit should be no problem here:
event handler will unregister the hooks, core nftables cleanup code will
drop the chain itself.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netfilter/nf_tables.h |  2 --
 net/netfilter/nf_tables_api.c     | 41 -------------------------------
 net/netfilter/nft_chain_filter.c  | 29 ++++++----------------
 3 files changed, 7 insertions(+), 65 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index d8fb1d0d6c8a..ffa5068e1a3d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1229,8 +1229,6 @@ static inline bool nft_is_base_chain(const struct nft_chain *chain)
 	return chain->flags & NFT_CHAIN_BASE;
 }
 
-int __nft_release_basechain(struct nft_ctx *ctx);
-
 unsigned int nft_do_chain(struct nft_pktinfo *pkt, void *priv);
 
 static inline bool nft_use_inc(u32 *use)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9a14f0e542f3..30efde5417b7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11697,47 +11697,6 @@ int nft_data_dump(struct sk_buff *skb, int attr, const struct nft_data *data,
 }
 EXPORT_SYMBOL_GPL(nft_data_dump);
 
-static void __nft_release_basechain_now(struct nft_ctx *ctx)
-{
-	struct nft_rule *rule, *nr;
-
-	list_for_each_entry_safe(rule, nr, &ctx->chain->rules, list) {
-		list_del(&rule->list);
-		nf_tables_rule_release(ctx, rule);
-	}
-	nf_tables_chain_destroy(ctx->chain);
-}
-
-int __nft_release_basechain(struct nft_ctx *ctx)
-{
-	struct nft_rule *rule;
-
-	if (WARN_ON_ONCE(!nft_is_base_chain(ctx->chain)))
-		return 0;
-
-	nf_tables_unregister_hook(ctx->net, ctx->chain->table, ctx->chain);
-	list_for_each_entry(rule, &ctx->chain->rules, list)
-		nft_use_dec(&ctx->chain->use);
-
-	nft_chain_del(ctx->chain);
-	nft_use_dec(&ctx->table->use);
-
-	if (!maybe_get_net(ctx->net)) {
-		__nft_release_basechain_now(ctx);
-		return 0;
-	}
-
-	/* wait for ruleset dumps to complete.  Owning chain is no longer in
-	 * lists, so new dumps can't find any of these rules anymore.
-	 */
-	synchronize_rcu();
-
-	__nft_release_basechain_now(ctx);
-	put_net(ctx->net);
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
2.47.1

