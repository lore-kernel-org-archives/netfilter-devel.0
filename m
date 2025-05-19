Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2723D200110;
	Mon, 19 May 2025 23:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747697692; cv=none; b=iccdTHjhHNUwHUpDzYxca2jn2eTw+J/FutPyCmM1Dpj4kq1lu+cv2pW8L7WmNoHk0+bKEQwgkDiswp3H7R6IRAvolR7tW++f8DUwCSsf0eItLeFwqFTBZ7sz3UT+FFeZWeLoqbivLA7C+XeetME2CxDMcwowjtOSwq41NiK27PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747697692; c=relaxed/simple;
	bh=8suw9bLoB4MJajb/RLDi5yZiLWevKBF1DeImE3f34bc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LMTcFOJLxMipKefc6Tp0n0dP0GbD2pDzbcO/v0Hqdua0HF7h6Xgdn2zu7t6fGYHy8pp3Afoy9h+sTDRDfhbSd4FCMaoNKuNfGIo4qUzcr8UqYXO137MM2wReWr2Fw0yPGWv4VSUJ2bW3Uk1SErkvP0aEyopQWorOMqidzKdQgvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oQ8NaJuY; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=iP0Jso1S; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oQ8NaJuY";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="iP0Jso1S"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 20851602A0; Tue, 20 May 2025 01:34:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747697689;
	bh=bDeb6N8LX2eaMs2u24pHtWrLJaZAHEXvNuyJJjBo/Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oQ8NaJuYDsAw0AN7ImUKKsGDvfIHbi4UvDL4+WngfpUNaRNdrE48QVFBhWiRtgYLi
	 /eFafMqQwv8Qm8N0nSehEHvsqKGZhRWudK9hZDw1sTPIuzK6LZBcZtQDQz79k4POdI
	 P+otEp9Fo4j0tmi2HoPJCLjrDpq7moxIO3EPqtqMbv8o80UDuCv4F9EldPO6z89Uov
	 e0MmuPsaelr7FIx+OjE8UXQe+5mhI0ztyufbDWN07HIa6BJ6FYSeL+VQfaFKajdGJP
	 4jXKnVv/zJR6U4hRR72P/DKl+spCu1J/6VjflYep2rWyyFoRxqvYJ2jG/Tpex59jcx
	 EzkgRLcAY6Tqw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AAB2760296;
	Tue, 20 May 2025 01:34:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747697687;
	bh=bDeb6N8LX2eaMs2u24pHtWrLJaZAHEXvNuyJJjBo/Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iP0Jso1SMO/t4BVD8Z4Y8DP/robOO+NG2cuM9DnIKtkkXE3b7PaXWNm6w4IEiejna
	 0aPnGscZnFphHj4UZOOZl7J7mIBTj8665mk5Qep7fshGnEJGTJNgYVh8AlwbgJSEmC
	 BKNEGHlGogOOfuXNhvxRbqq83PNHJUY6mY0J+hIWBzcNutzr0fIz7uFqWCitVkxchH
	 nq+nj/6ELIT59BdGlYrjsrA15H/Ilxc6RRmUqJ0HNblXxUggu3qouWBwLoptASSyzL
	 KO/eSfXM2+6Hn7+dZjW0O85hqaVGDdTX7EkniAnhneoqUH72u0L5V4rG0GyBHGSluU
	 O90xON5/y/Obg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,6.1 2/3] netfilter: nf_tables: wait for rcu grace period on net_device removal
Date: Tue, 20 May 2025 01:34:37 +0200
Message-Id: <20250519233438.22640-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250519233438.22640-1-pablo@netfilter.org>
References: <20250519233438.22640-1-pablo@netfilter.org>
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
 include/net/netfilter/nf_tables.h |  4 +++
 net/netfilter/nf_tables_api.c     | 41 +++++++++++++++++++++++++------
 2 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 41abb5982348..76a51ed432ca 100644
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
@@ -1203,6 +1205,7 @@ static inline void nft_use_inc_restore(u32 *use)
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
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dc1e11c0b168..aa1a85eff61b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1413,6 +1413,7 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	INIT_LIST_HEAD(&table->sets);
 	INIT_LIST_HEAD(&table->objects);
 	INIT_LIST_HEAD(&table->flowtables);
+	write_pnet(&table->net, net);
 	table->family = family;
 	table->flags = flags;
 	table->handle = ++nft_net->table_handle;
@@ -10662,22 +10663,48 @@ int nft_data_dump(struct sk_buff *skb, int attr, const struct nft_data *data,
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

