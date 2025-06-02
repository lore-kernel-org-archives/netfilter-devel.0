Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3147319EEBD;
	Mon,  2 Jun 2025 14:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875371; cv=none; b=dYJm3EmJDo8QHZ5JoRicdwruV6MpvG0mEDK/2PeM/0vxJ/x74/+Qyz5Ac16KouVTJZvT7ve4SdkmNknO2dL2q5p5WSy/hA9sDcX+d/MD+0xWJjZeHMLSJvIzvoVGIjHPGvTDH1JCB3eVVbuhS+Ef40NXLtoN1yMnOQPjSh1OX9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875371; c=relaxed/simple;
	bh=YjTim2P8gRiBjDatoN4AlA5FEduAWCZ9Wubp7sVqDSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uaq/6RC3FKpO7Du1SqeDq8rb0CvGwJ7ELBDzX2sE2jEmhmYgIxy0sEXYy55hdLAKd+jWRSSZRWRjLJCv6XhbmD2+QQ9mbfo6x3PK9ApuIgmKx9HXulJqUeHIGi1FXcgpAsZvTaSX5yBCqkwma7IFY8SIKx8j4dCuTt3Rdgj6bZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2aFrfE3I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2aFrfE3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967CEC4CEEB;
	Mon,  2 Jun 2025 14:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875371;
	bh=YjTim2P8gRiBjDatoN4AlA5FEduAWCZ9Wubp7sVqDSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2aFrfE3INVoRmsFFSriXcTJnnnhyw2h7uoovm024P+lQL0W9EWEvEEmRlrotmbEJF
	 stej9GKXAa3OPnHdblXequScZorerGBtkI+x5mFom910HbcAeWe5/Hv8hM9EsAU3JS
	 wWt+RANaOQapKQJ0utIIpQRyqSs9jQcfc8HQMVr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 113/270] netfilter: nf_tables: wait for rcu grace period on net_device removal
Date: Mon,  2 Jun 2025 15:46:38 +0200
Message-ID: <20250602134311.848453019@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |    3 ++
 net/netfilter/nf_tables_api.c     |   41 +++++++++++++++++++++++++++++++-------
 2 files changed, 37 insertions(+), 7 deletions(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -962,6 +962,7 @@ struct nft_chain {
 	char				*name;
 	u16				udlen;
 	u8				*udata;
+	struct rcu_head			rcu_head;
 
 	/* Only used during control plane commit phase: */
 	struct nft_rule			**rules_next;
@@ -1100,6 +1101,7 @@ static inline void nft_use_inc_restore(u
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
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1299,6 +1299,7 @@ static int nf_tables_newtable(struct net
 	INIT_LIST_HEAD(&table->sets);
 	INIT_LIST_HEAD(&table->objects);
 	INIT_LIST_HEAD(&table->flowtables);
+	write_pnet(&table->net, net);
 	table->family = family;
 	table->flags = flags;
 	table->handle = ++table_handle;
@@ -9559,22 +9560,48 @@ int nft_data_dump(struct sk_buff *skb, i
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


