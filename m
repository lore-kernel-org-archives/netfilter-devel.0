Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F28B2076B2
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2024 21:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730237434; cv=none; b=uudX/cd0E2Hktl+2W91J3HqlEZfCJ2xQXW9oEpYaUDICIM7eOFIu20slCp/IF5/O4HqSujW6wuR3W+fUkOIr/gJg8MpU0pyPzjVBnfyn3tL3ZEYJhO9pjdcAe2ekZEUvYa+aGbtQ/UYQVO45Gu1nOwuAB8kOnbiTLY9T0c0896Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730237434; c=relaxed/simple;
	bh=rhpDF7jHp44L8bPypKLSqvr8mSNCGfTL5XovRqpbdDw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=k4nXaHI1wnI5pQLtIa/sqP0iSrdssP2lJZL6W1Jw0gy4p+q96VEKZpDs3mBlHG75Ll0AzyCs8UL08ICi2IZq+TH4BbhKovhUg+PbCNHS/RYJX4QIZaIytduIi9O1a1S0yzMZ87s8GiceRdV4b4NsmlH9t99dAlotL8XnoX5xRPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	matttbe@kernel.org,
	phil@nwl.cc
Subject: [PATCH nf,v3] netfilter: nf_tables: wait for rcu grace period on net_device removal
Date: Tue, 29 Oct 2024 22:30:20 +0100
Message-Id: <20241029213020.2281177-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

8c873e219970 ("netfilter: core: free hooks with call_rcu") removed
synchronize_net() call when unregistering basechain hook, however,
net_device removal event handler for the NFPROTO_NETDEV was not updated
to wait for RCU grace period.

Note that 835b803377f5 ("netfilter: nf_tables_netdev: unregister hooks
on net_device removal") does not remove basechain rules on device
removal, it was just a bit later that I was hinted to remove rules on
net_device removal, see 5ebe0b0eec9d ("netfilter: nf_tables: destroy
basechain and rules on netdevice removal").

Use rcu callback to release basechain but add a slow path by calling
synchronize_rcu() if reference on netns cannot be taken, because
basechain can be seen from this path:

 cleanup_net()
  default_device_exit_batch()
   unregister_netdevice_many_notify()
    notifier_call_chain()
     nf_tables_netdev_event()
      __nft_release_basechain()

nftables/tests/shell can trigger this path occasionally.

While at it, turn WARN_ON() into WARN_ON_ONCE().

Fixes: 835b803377f5 ("netfilter: nf_tables_netdev: unregister hooks on net_device removal")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: slow synchronize_rcu() path for what it looks like a corner case.
    I'm not particularly happy with this special case.

 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     | 48 ++++++++++++++++++++++++++++---
 2 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 91ae20cb7648..8dd8e278843d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1120,6 +1120,7 @@ struct nft_chain {
 	char				*name;
 	u16				udlen;
 	u8				*udata;
+	struct rcu_head			rcu_head;
 
 	/* Only used during control plane commit phase: */
 	struct nft_rule_blob		*blob_next;
@@ -1282,6 +1283,7 @@ struct nft_table {
 	struct list_head		sets;
 	struct list_head		objects;
 	struct list_head		flowtables;
+	possible_net_t			net;
 	u64				hgenerator;
 	u64				handle;
 	u32				use;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a24fe62650a7..f79d2c74c389 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1495,6 +1495,7 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	INIT_LIST_HEAD(&table->sets);
 	INIT_LIST_HEAD(&table->objects);
 	INIT_LIST_HEAD(&table->flowtables);
+	write_pnet(&table->net, net);
 	table->family = family;
 	table->flags = flags;
 	table->handle = ++nft_net->table_handle;
@@ -11430,14 +11431,14 @@ int nft_data_dump(struct sk_buff *skb, int attr, const struct nft_data *data,
 }
 EXPORT_SYMBOL_GPL(nft_data_dump);
 
-int __nft_release_basechain(struct nft_ctx *ctx)
+static int __nft_release_basechain_slow(struct nft_ctx *ctx)
 {
 	struct nft_rule *rule, *nr;
 
-	if (WARN_ON(!nft_is_base_chain(ctx->chain)))
-		return 0;
-
 	nf_tables_unregister_hook(ctx->net, ctx->chain->table, ctx->chain);
+
+	synchronize_rcu();
+
 	list_for_each_entry_safe(rule, nr, &ctx->chain->rules, list) {
 		list_del(&rule->list);
 		nft_use_dec(&ctx->chain->use);
@@ -11449,6 +11450,45 @@ int __nft_release_basechain(struct nft_ctx *ctx)
 
 	return 0;
 }
+
+static void __nft_release_basechain_rcu(struct rcu_head *head)
+{
+	struct nft_chain *chain = container_of(head, struct nft_chain, rcu_head);
+	struct nft_rule *rule, *nr;
+	struct nft_ctx ctx = {
+		.family	= chain->table->family,
+		.net	= read_pnet(&chain->table->net),
+	};
+
+	list_for_each_entry_safe(rule, nr, &chain->rules, list) {
+		list_del(&rule->list);
+		nf_tables_rule_release(&ctx, rule);
+	}
+	nf_tables_chain_destroy(chain);
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
+	if (unlikely(!maybe_get_net(ctx->net)))
+		return __nft_release_basechain_slow(ctx);
+
+	nf_tables_unregister_hook(ctx->net, ctx->chain->table, ctx->chain);
+	list_for_each_entry(rule, &ctx->chain->rules, list)
+		nft_use_dec(&ctx->chain->use);
+
+	nft_chain_del(ctx->chain);
+	nft_use_dec(&ctx->table->use);
+
+	call_rcu(&ctx->chain->rcu_head, __nft_release_basechain_rcu);
+
+	return 0;
+}
 EXPORT_SYMBOL_GPL(__nft_release_basechain);
 
 static void __nft_release_hook(struct net *net, struct nft_table *table)
-- 
2.30.2

