Received: from mail.netfilter.org (unknown [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 608B9234CE4;
	Thu, 16 Jan 2025 17:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737047971; cv=none; b=mGkGp3PP/MLRgmDM936KmwDBzF6o3mNQg8tKhoU3ZjfodJF6lPven168yxiImh8TP64Dgbeo+xwwt/UT11xnFezK+ecEjrevx0cKxXxc971B6FVyb+pNuKycAIxLc7wvn6ci6tVwvCFWHu/b2kJvFHG5XPdct/qD2Aw/8IsxT10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737047971; c=relaxed/simple;
	bh=6/7yjt2BepUE4q73oLbuslXB3cVo7z5uZYuf6bXngTI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P20jKA3ocz7x8DFRdoeJEeQlGz6lbMqKUzJyQ7qJs8WfarkdmPgn6Ch6rq811jUeCvqlORMspoJUo/5BdCwJKkVODZHKol1W9OFyqf8OC9g20m/KeG2ZAHCADSklg3Zv6i18m9otjF8ayFEub7lyQ8mijw3yzZe6lqzmZQYq6UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 07/14] netfilter: nf_tables: Tolerate chains with no remaining hooks
Date: Thu, 16 Jan 2025 18:18:55 +0100
Message-Id: <20250116171902.1783620-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250116171902.1783620-1-pablo@netfilter.org>
References: <20250116171902.1783620-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  2 --
 net/netfilter/nf_tables_api.c     | 41 -------------------------------
 net/netfilter/nft_chain_filter.c  | 29 ++++++----------------
 3 files changed, 7 insertions(+), 65 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index d1f274af5b70..26a65d5a3123 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1235,8 +1235,6 @@ static inline bool nft_is_base_chain(const struct nft_chain *chain)
 	return chain->flags & NFT_CHAIN_BASE;
 }
 
-int __nft_release_basechain(struct nft_ctx *ctx);
-
 unsigned int nft_do_chain(struct nft_pktinfo *pkt, void *priv);
 
 static inline bool nft_use_inc(u32 *use)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ed15c52e3c65..667459256e4c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11741,47 +11741,6 @@ int nft_data_dump(struct sk_buff *skb, int attr, const struct nft_data *data,
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
2.30.2

