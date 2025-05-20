Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7754D254855;
	Tue, 20 May 2025 00:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747700568; cv=none; b=DcdDimQZWCtID1HZ1p9MmXhnWUF6tgGZHjLeogbz+ZLJNu4uCj88Cxjb2CzTVGCw6rTKsBQLqp+IriHZoaBseDwg9wAeOy4ui+sVJnAkJN4R/EnBhYQR67ljTgfPmpdm9ihdbwhxv3lBiQy7SR/iY6sF98OjtZlDbqTXyUH+Egw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747700568; c=relaxed/simple;
	bh=2oP4BqRCkyqHjuKuOTtbwI83y0oB6bVhS0SbIcI8iY4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ei3LBynWG1eRSa+s87iixP1OOy0BGZ7QIvKiexZRBWQRy70G44b+pkP6tr14dkulaJXEphMaWUI38LTJ4FMTkfi2DAwsAyPakJ4o57K5xbxOaVpaP/5Sg0s5PhtvCr7ahGYcKblbIN4tNDhPjti4CsL/o5S3Q88aoAPEKPx+mj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AVTKpVH0; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AVTKpVH0; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AVTKpVH0";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AVTKpVH0"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E2C5F6027C; Tue, 20 May 2025 02:22:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747700563;
	bh=BwBKPicD6he26ddvMBjBV2qoecHdq5omx7fEeq/CmNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AVTKpVH0Zg0Xhs0kSm0nbDRHvnMFRbbt114Ie6nsr/jX6DaCxDGCdoFMzGtfnxVk+
	 K3HHUtRTjuy41+bGBVFANCnonbUbTuVIY/FzeeBTQQj+XUXgFM9NhegjlJVnL5Kd6x
	 csFNKuiRShU1CMEqJWOQ7DKbo5jY6riAbmFkDpAsLV4UTufelLopwvTVfER3r0yAiy
	 FKzItufz71WGON7KgqJWL/8pco6bwuUhx3FEv4rRV+OvdvtnDvJBBnKlD3yVYivkKk
	 4okRwwWeQQWd1aYHjMjwCQ82JzwlKe2/yTwNq/Fa1jKBzQGUzNgkzeVfNGizQndA+t
	 Zb3Qdnp8jknfg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F0E5460264;
	Tue, 20 May 2025 02:22:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747700563;
	bh=BwBKPicD6he26ddvMBjBV2qoecHdq5omx7fEeq/CmNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AVTKpVH0Zg0Xhs0kSm0nbDRHvnMFRbbt114Ie6nsr/jX6DaCxDGCdoFMzGtfnxVk+
	 K3HHUtRTjuy41+bGBVFANCnonbUbTuVIY/FzeeBTQQj+XUXgFM9NhegjlJVnL5Kd6x
	 csFNKuiRShU1CMEqJWOQ7DKbo5jY6riAbmFkDpAsLV4UTufelLopwvTVfER3r0yAiy
	 FKzItufz71WGON7KgqJWL/8pco6bwuUhx3FEv4rRV+OvdvtnDvJBBnKlD3yVYivkKk
	 4okRwwWeQQWd1aYHjMjwCQ82JzwlKe2/yTwNq/Fa1jKBzQGUzNgkzeVfNGizQndA+t
	 Zb3Qdnp8jknfg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,5.10 2/3] netfilter: nf_tables: wait for rcu grace period on net_device removal
Date: Tue, 20 May 2025 02:22:35 +0200
Message-Id: <20250520002236.185365-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250520002236.185365-1-pablo@netfilter.org>
References: <20250520002236.185365-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit c03d278fdf35e73dd0ec543b9b556876b9d9a8dc upstream.

8c873e219970 ("netfilter: core: free hooks with call_rcu") removed
synchronize_net() call when unregistering basechain hook, however,
net_device removal event handler for the NFPROTO_NETDEV was not updated
to wait for RCU grace period.

Note that 835b803377f5 ("netfilter: nf_tables_netdev: unregister hooks
on net_device removal") does not remove basechain rules on device
removal, I was hinted to remove rules on net_device removal later, see
5ebe0b0eec9d ("netfilter: nf_tables: destroy basechain and rules on
netdevice removal").

Although NETDEV_UNREGISTER event is guaranteed to be handled after
synchronize_net() call, this path needs to wait for rcu grace period via
rcu callback to release basechain hooks if netns is alive because an
ongoing netlink dump could be in progress (sockets hold a reference on
the netns).

Note that nf_tables_pre_exit_net() unregisters and releases basechain
hooks but it is possible to see NETDEV_UNREGISTER at a later stage in
the netns exit path, eg. veth peer device in another netns:

 cleanup_net()
  default_device_exit_batch()
   unregister_netdevice_many_notify()
    notifier_call_chain()
     nf_tables_netdev_event()
      __nft_release_basechain()

In this particular case, same rule of thumb applies: if netns is alive,
then wait for rcu grace period because netlink dump in the other netns
could be in progress. Otherwise, if the other netns is going away then
no netlink dump can be in progress and basechain hooks can be released
inmediately.

While at it, turn WARN_ON() into WARN_ON_ONCE() for the basechain
validation, which should not ever happen.

Fixes: 835b803377f5 ("netfilter: nf_tables_netdev: unregister hooks on net_device removal")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  3 +++
 net/netfilter/nf_tables_api.c     | 41 +++++++++++++++++++++++++------
 2 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 25dd157728a3..c055847066c9 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -962,6 +962,7 @@ struct nft_chain {
 	char				*name;
 	u16				udlen;
 	u8				*udata;
+	struct rcu_head			rcu_head;
 
 	/* Only used during control plane commit phase: */
 	struct nft_rule			**rules_next;
@@ -1100,6 +1101,7 @@ static inline void nft_use_inc_restore(u32 *use)
  *	@sets: sets in the table
  *	@objects: stateful objects in the table
  *	@flowtables: flow tables in the table
+ *	@net: netnamespace this table belongs to
  *	@hgenerator: handle generator state
  *	@handle: table handle
  *	@use: number of chain references to this table
@@ -1115,6 +1117,7 @@ struct nft_table {
 	struct list_head		sets;
 	struct list_head		objects;
 	struct list_head		flowtables;
+	possible_net_t			net;
 	u64				hgenerator;
 	u64				handle;
 	u32				use;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1e84c8564450..f3d20023b353 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1299,6 +1299,7 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 	INIT_LIST_HEAD(&table->sets);
 	INIT_LIST_HEAD(&table->objects);
 	INIT_LIST_HEAD(&table->flowtables);
+	write_pnet(&table->net, net);
 	table->family = family;
 	table->flags = flags;
 	table->handle = ++table_handle;
@@ -9559,22 +9560,48 @@ int nft_data_dump(struct sk_buff *skb, int attr, const struct nft_data *data,
 }
 EXPORT_SYMBOL_GPL(nft_data_dump);
 
-int __nft_release_basechain(struct nft_ctx *ctx)
+static void __nft_release_basechain_now(struct nft_ctx *ctx)
 {
 	struct nft_rule *rule, *nr;
 
-	if (WARN_ON(!nft_is_base_chain(ctx->chain)))
-		return 0;
-
-	nf_tables_unregister_hook(ctx->net, ctx->chain->table, ctx->chain);
 	list_for_each_entry_safe(rule, nr, &ctx->chain->rules, list) {
 		list_del(&rule->list);
-		nft_use_dec(&ctx->chain->use);
 		nf_tables_rule_release(ctx, rule);
 	}
+	nf_tables_chain_destroy(ctx->chain);
+}
+
+static void nft_release_basechain_rcu(struct rcu_head *head)
+{
+	struct nft_chain *chain = container_of(head, struct nft_chain, rcu_head);
+	struct nft_ctx ctx = {
+		.family	= chain->table->family,
+		.chain	= chain,
+		.net	= read_pnet(&chain->table->net),
+	};
+
+	__nft_release_basechain_now(&ctx);
+	put_net(ctx.net);
+}
+
+int __nft_release_basechain(struct nft_ctx *ctx)
+{
+	struct nft_rule *rule;
+
+	if (WARN_ON_ONCE(!nft_is_base_chain(ctx->chain)))
+		return 0;
+
+	nf_tables_unregister_hook(ctx->net, ctx->chain->table, ctx->chain);
+	list_for_each_entry(rule, &ctx->chain->rules, list)
+		nft_use_dec(&ctx->chain->use);
+
 	nft_chain_del(ctx->chain);
 	nft_use_dec(&ctx->table->use);
-	nf_tables_chain_destroy(ctx->chain);
+
+	if (maybe_get_net(ctx->net))
+		call_rcu(&ctx->chain->rcu_head, nft_release_basechain_rcu);
+	else
+		__nft_release_basechain_now(ctx);
 
 	return 0;
 }
-- 
2.30.2

