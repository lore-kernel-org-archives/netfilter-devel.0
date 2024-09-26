Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182ED1AD3EB
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 09:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727344621; cv=none; b=ViZRg1HVSGWa/WNablOJCiVrh/VqzA6vo0/rbpzPE+8iZLYoZjWMpmiPtLoSjvZWGT2446iE1aWf6f4APN2rz9se/WsL55qDjsGgjHhaoe42B59ueCBLQewUYNSnHwg3/a1b/Q0tdENsaJONf5v6dn+841rKXfTaPAz6jjbKIUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727344621; c=relaxed/simple;
	bh=QEp3pXN4DRwsHdzG6UPu0nFtdyM1C+Rq7eZQIvThT80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHlDr9+npZqxTh3/3bUnn8UD5zxNgSxUFkBn8HJBXAM8+UgqIWwRvvj6/pKlAsOo1dSYYnt5oeO6PRaTdeYErR0eJyQ50SimROnBGmeuMGTZsrRqDzS2+0Oj8fgWLg/2UT4ZLG6A4vEc5qsDoswSIC3phkLyABpVdAHYE4i5gIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=EL34VaxR; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="EL34VaxR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9SQxgzp/l1/Uw68dUj6lZmKIgEYQVBL7aSD6bN9hi3w=; b=EL34VaxRmkueQnhu4v5LcZrNxd
	ijQkRakSHlKyE3/uh0SKkKm4apjCJzZMydIaoYObjn535PoIVLNI0oThFQDGFphX4NMuRTQG/CGS2
	8gcIMk/V4pPVLrhrX/kyckFGfsXB84sAGlWIB07m4FY+GW+ecu/c2y+L02q1XUfKzYcpLYB4KWC3R
	jkzemk2LZMI7h1Bq1nQoLHy0svwYxrfeHT+KejG88uxyBwIzZDOH2uPQ3fWp+FR2B0pXQ8jny9LRz
	1KEoW8B9saGWpOawzjQMibTNybMP2hN1KdutTQwBAnB8sU6GfDlQool2Q04ZWiHEQVeWmsTpYcu9k
	Ezpx7AHg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1stlF4-000000006HF-3JfT;
	Thu, 26 Sep 2024 11:56:58 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v5 05/18] netfilter: nf_tables: Tolerate chains with no remaining hooks
Date: Thu, 26 Sep 2024 11:56:30 +0200
Message-ID: <20240926095643.8801-6-phil@nwl.cc>
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
index 73714e9d9392..6aa39c4a8c3c 100644
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
index f6e28a6ac9b0..f77ba323a906 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11433,27 +11433,6 @@ int nft_data_dump(struct sk_buff *skb, int attr, const struct nft_data *data,
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

