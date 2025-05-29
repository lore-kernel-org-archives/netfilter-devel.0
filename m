Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B5621ABAD;
	Thu, 29 May 2025 09:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748510325; cv=none; b=u03nmmeLD6jvxKR/c8A/5nX6H5pk1g0Fy6+pUJYW0mnZOzfEGIqR8wrMGfzqqqctod4XRJzhDAht3+RlcS54BAYa3nDEvCweDPlXVZc+69yx1amNKcK4v0l7yn6h5vXwucrn1f4JKhzPbDVRXvReAf3IK9D4eSFYdQzAEEeE3yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748510325; c=relaxed/simple;
	bh=H2Nf3RjYSw10LvLOGmxbBeMICdhuMz47D/9J7IDj/ic=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N+sq+6rCZtObrlqQk7c4zdqytFeUvVZ6CEj+Q2fPJ/D6YlEbJtOvJw3785PIn8ULL4TRG/JTu18a3zRyW162+lvekFg6jL8k7jN0kL6eUDAITWdq1YjzwlWCIr+rXBQAQpEPcfS2P9aTJId3tailNqgxrjyJg3HDs4N1pEKwMU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=usCvteCs; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mDPGh2U4; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="usCvteCs";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mDPGh2U4"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 374646075C; Thu, 29 May 2025 11:11:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748509911;
	bh=VZ8SA+QCysf7PC7IDgeTfivmC44iJxSYKRuoFet+iRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=usCvteCsSlBSzNDXcDzGuNItQdldrvrB0n+YXKj5VLrmSv2a2sYfI/iTWatD+mAXD
	 /7brTL/lGnHRG6BcE7tj48+u2De5uvL9LK9WLi2cM+O2DPtOQxQ6zJrHJJSQOgPTl1
	 jRCxlEOKedNZV9UdX5q5xdBluY1duu8dmAr5iKREwdVEWitnMdIUu7hDeGUFBhaZTL
	 fNmLfMgc1hAqGbwRFg4AadttUb/5sJjjhTpyZyGsVTzwtWSvyucpzJIR8SZXL7EaXe
	 saqPg/9/SRWE1KBWx3X/x1+k9YKCknFeqHbZMiTIJyUizxEYVZEMkoHdDt8qK5UsQZ
	 Z7slhIXtaXHjw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 046266074B;
	Thu, 29 May 2025 11:11:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748509910;
	bh=VZ8SA+QCysf7PC7IDgeTfivmC44iJxSYKRuoFet+iRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mDPGh2U4hdkliE/0s4pt3joW8bo7EO9hTFbThsGwYTjIkgC4ibWvakbaIGVziYVeo
	 VUsfbF7NWs+9RNuqP8QvCh5fvwevorzacOvFMUjNxnhEgFsj1QnyapR+uxufth96lH
	 xaNUM7rhvLp9fSDkmxVTZRnFFJGp6rzKCgPfaeQx5EjRZFLTagLt3maoQRaycGEGnc
	 d1K7kop73UVuQgo6iEkHm7sVC/OerXGVpGo4n2fZdLyvmVYQJni5UzT5Uwak6ZUwjS
	 h5jp3dCqp4FIsJT4X5owNkYLRft82Axvm3v3c7zgTRS+CUmCzklsOaq2SiZimtvGqc
	 tUWa3zIiL9XrA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,5.4 2/3] netfilter: nf_tables: wait for rcu grace period on net_device removal
Date: Thu, 29 May 2025 11:11:43 +0200
Message-Id: <20250529091144.118355-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250529091144.118355-1-pablo@netfilter.org>
References: <20250529091144.118355-1-pablo@netfilter.org>
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
index 92551a765a44..566370938939 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -899,6 +899,7 @@ struct nft_chain {
 	u8				flags:6,
 					genmask:2;
 	char				*name;
+	struct rcu_head			rcu_head;
 
 	/* Only used during control plane commit phase: */
 	struct nft_rule			**rules_next;
@@ -1015,6 +1016,7 @@ static inline void nft_use_inc_restore(u32 *use)
  *	@sets: sets in the table
  *	@objects: stateful objects in the table
  *	@flowtables: flow tables in the table
+ *	@net: netnamespace this table belongs to
  *	@hgenerator: handle generator state
  *	@handle: table handle
  *	@use: number of chain references to this table
@@ -1030,6 +1032,7 @@ struct nft_table {
 	struct list_head		sets;
 	struct list_head		objects;
 	struct list_head		flowtables;
+	possible_net_t			net;
 	u64				hgenerator;
 	u64				handle;
 	u32				use;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c6f142b5e64f..2d015fcf8d8d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1109,6 +1109,7 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 	INIT_LIST_HEAD(&table->sets);
 	INIT_LIST_HEAD(&table->objects);
 	INIT_LIST_HEAD(&table->flowtables);
+	write_pnet(&table->net, net);
 	table->family = family;
 	table->flags = flags;
 	table->handle = ++table_handle;
@@ -8216,22 +8217,48 @@ int nft_data_dump(struct sk_buff *skb, int attr, const struct nft_data *data,
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

