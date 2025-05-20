Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B74013635C;
	Tue, 20 May 2025 13:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749582; cv=none; b=Y18oMdM+CwD7Bw63FxMx2o1xPYwdW810ozQfzhfxc7kryflf5tXydgW4OMz8OKflWOoxors+xxHIkMXy8tlLiuw5iO2vtAwCagHvLY9w8aQ5eIvFZoxA0f8Ax+pUjeqjAaAKwhvibT9yjA97o2bwtnw9rxmkNKTXI/Cvnms5tzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749582; c=relaxed/simple;
	bh=7usBujxZoH6SzU+ZwHu8VV+tJN7GaNkYPtMauf+v1II=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQ37gbsLaU17j0IjUfFMVk7kvFwBKfD8hO0FiCAQmx9n4oorweHkUZFWWo49vog9UH/bwVLVha1QEmOd01DQRkHBa3d5h4e1FIFSpLKwRwVjSSGWhO5S9rzVXhhTQ621lgZvVVnbA+BT1oCs6fnwtgzpqd9/rKkUbGlmfC90LuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2vZJNEUP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2vZJNEUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71C0C4CEE9;
	Tue, 20 May 2025 13:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749582;
	bh=7usBujxZoH6SzU+ZwHu8VV+tJN7GaNkYPtMauf+v1II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2vZJNEUPjEmhezQCE0YDTxcsSDcwszpmEny1kwKQGdqbu6GFqXUQmlMVgzldSIafB
	 ulApmTk/mytyZiwSmEevBZnlZFBt47WlTOwuhcVz0giQgFWPayiDcpFsnL9H1juu5M
	 JQtUjf2Po39SZqG1OLvIpq6sRgUBO3iNVe2doLQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.1 89/97] netfilter: nf_tables: wait for rcu grace period on net_device removal
Date: Tue, 20 May 2025 15:50:54 +0200
Message-ID: <20250520125804.153728936@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 include/net/netfilter/nf_tables.h |    4 +++
 net/netfilter/nf_tables_api.c     |   41 +++++++++++++++++++++++++++++++-------
 2 files changed, 38 insertions(+), 7 deletions(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1045,6 +1045,7 @@ struct nft_rule_blob {
  *	@use: number of jump references to this chain
  *	@flags: bitmask of enum nft_chain_flags
  *	@name: name of the chain
+ *	@rcu_head: rcu head for deferred release
  */
 struct nft_chain {
 	struct nft_rule_blob		__rcu *blob_gen_0;
@@ -1061,6 +1062,7 @@ struct nft_chain {
 	char				*name;
 	u16				udlen;
 	u8				*udata;
+	struct rcu_head			rcu_head;
 
 	/* Only used during control plane commit phase: */
 	struct nft_rule_blob		*blob_next;
@@ -1203,6 +1205,7 @@ static inline void nft_use_inc_restore(u
  *	@sets: sets in the table
  *	@objects: stateful objects in the table
  *	@flowtables: flow tables in the table
+ *	@net: netnamespace this table belongs to
  *	@hgenerator: handle generator state
  *	@handle: table handle
  *	@use: number of chain references to this table
@@ -1218,6 +1221,7 @@ struct nft_table {
 	struct list_head		sets;
 	struct list_head		objects;
 	struct list_head		flowtables;
+	possible_net_t			net;
 	u64				hgenerator;
 	u64				handle;
 	u32				use;
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1413,6 +1413,7 @@ static int nf_tables_newtable(struct sk_
 	INIT_LIST_HEAD(&table->sets);
 	INIT_LIST_HEAD(&table->objects);
 	INIT_LIST_HEAD(&table->flowtables);
+	write_pnet(&table->net, net);
 	table->family = family;
 	table->flags = flags;
 	table->handle = ++nft_net->table_handle;
@@ -10662,22 +10663,48 @@ int nft_data_dump(struct sk_buff *skb, i
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


