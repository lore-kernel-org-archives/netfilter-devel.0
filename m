Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94B4F1DE2B5
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Oct 2024 15:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730128446; cv=none; b=I46/xHl80CZnUxt2+MQ2nSNr76KxkLciWPSG4/G5WEx0V1p2MOHONn/fJQX2LrLi5jWkNnVvsya9zrc5R5WVX3gKtJ/7hcqY3QrN8ihrVC353vvjRkTwm2HZPNWuZVLpV5mCmviEH4JYYr1+t2QzaXfwtLyeJy2dtyNqLtyUt/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730128446; c=relaxed/simple;
	bh=MnQRBR+cnqtn4nYCEvElAxqCWumhhm4dflLlPlWUlcQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cn5ib17SS1LY9u0Sgru5rJS6UdqQuDJcXeDu+OSKK6JUpKbCF5gvof23CJGJxOGsFihHn44dz35S/82vWatshrGQWlUPm1cMYRLdEJFvuUqigW2qJfFxl7vq/IGlKRDgZwnOsgo7NXp7u2ZRAnNihg/ANwc7u3d/P9INa170DR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: matttbe@kernel.org,
	fw@strlen.de,
	phil@nwl.cc
Subject: [PATCH nf] netfilter: nf_tables: wait for rcu grace period on net_device removal
Date: Mon, 28 Oct 2024 16:13:51 +0100
Message-Id: <20241028151351.19562-1-pablo@netfilter.org>
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

Fixes: 835b803377f5 ("netfilter: nf_tables_netdev: unregister hooks on net_device removal")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     | 30 ++++++++++++++++++++++++------
 2 files changed, 26 insertions(+), 6 deletions(-)

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
index a24fe62650a7..762879187edb 100644
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
@@ -11430,22 +11431,39 @@ int nft_data_dump(struct sk_buff *skb, int attr, const struct nft_data *data,
 }
 EXPORT_SYMBOL_GPL(nft_data_dump);
 
-int __nft_release_basechain(struct nft_ctx *ctx)
+static void __nft_release_basechain_rcu(struct rcu_head *head)
 {
+	struct nft_chain *chain = container_of(head, struct nft_chain, rcu_head);
 	struct nft_rule *rule, *nr;
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
 
 	if (WARN_ON(!nft_is_base_chain(ctx->chain)))
 		return 0;
 
 	nf_tables_unregister_hook(ctx->net, ctx->chain->table, ctx->chain);
-	list_for_each_entry_safe(rule, nr, &ctx->chain->rules, list) {
-		list_del(&rule->list);
+	list_for_each_entry(rule, &ctx->chain->rules, list)
 		nft_use_dec(&ctx->chain->use);
-		nf_tables_rule_release(ctx, rule);
-	}
+
 	nft_chain_del(ctx->chain);
 	nft_use_dec(&ctx->table->use);
-	nf_tables_chain_destroy(ctx->chain);
+	get_net(ctx->net);
+
+	call_rcu(&ctx->chain->rcu_head, __nft_release_basechain_rcu);
 
 	return 0;
 }
-- 
2.30.2

