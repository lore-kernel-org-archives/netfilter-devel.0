Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA18321E0A2;
	Tue, 20 May 2025 00:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747700568; cv=none; b=aCl2F2NXySd0uAVQucp/3/UW1DS1guni7EA9LlGIyUp9hFDXPFBJruhldPzNdqPIkhBKQVlBWLs2anbWm/N/xCG4JQK0nN94FHfecWBlk8Y8+p8s40Ujh7escPEU5+EJPnbK/Poc6xNmvvUCA5mpmRw/D1J5TFbNPgdfVOeOXWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747700568; c=relaxed/simple;
	bh=2sCflagYN1p0EebWs7zkkYMbJ9WhV8z0MOEquY11XpE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fJtK834sMizXTolcIdv8Qcm41c7HzGteaZU8QRhrCn0cX860UoyKienks820jb5bL89tuxvCpF+XsgrDLbJ5vJQWccDA/8roL8+WjTdotu5zyFVY5uqIJ5F5XmJBK53j6oYpH6/Pmug+1ewr7ZFp3wyEga9yh10s6jBA2wVcIUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cG344SDC; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NarhBe0J; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cG344SDC";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NarhBe0J"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 7886160264; Tue, 20 May 2025 02:22:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747700565;
	bh=oGvscRL3p69LkmN1hCOi58RKacP8aVkx5RQ5/VPTiGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cG344SDCqxU/oNSxDYUZ8ddVUX17PG+wklz1bIiengmvNBFsBB1TGdOLn+qWmZ3ff
	 63Z0yC2l/Iym1baRPnBrhUJw+qSc921UIWURsuFsp4G5PU0MHRTsp7JtuyBVKGUdhN
	 ou+IkPpSKSgyWItWFv8avfV4D5WO79RRvoUPvBkkgRB1lMmtSwQGaZACTsGN39N7KU
	 clmsIaiDVrDak7voQpxiFEZur+DiYOsY9Saig42LYmWMVDRC872Hpr6e4U9HURDhlE
	 q4HSUot3C0jufZJoeHoPg9o/lIxHy6duc0d8UfD2tkLcMe9U0w2Sa1WVKvcG3gFVto
	 bKOQTRXlbNJ0A==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A05A360272;
	Tue, 20 May 2025 02:22:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747700563;
	bh=oGvscRL3p69LkmN1hCOi58RKacP8aVkx5RQ5/VPTiGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NarhBe0J+iFvpN6uy4ASs1nek0f2yR1qbRxU1yZBhmorgQInEvdFHPqzpKx8TBbeD
	 viOS6MS1l/9V1356M8bb7Af2DzTbAY23nqCdlBrZcHZOLsl/g9djEjttAUjNyJtGjV
	 3YGTxgAZtJchozVPI4m0wI8NKcGw5yKSG4e0WavcOp+trvxluhHacL0n6vhOvkS1RN
	 i4LwRYp2MV6+rFDpefV2ePTVV0p6FX63DcMaeBQNqN9hJQ4EQogO3azWrtmSHRwcXG
	 vuweaN5F5hblo13ngtlkYkV3KKTR7zxdnW0Ib+h6SZiwMMKlAQXjo6MdpI0emLAoBs
	 Q0/tqwAuPqziQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,5.10 3/3] netfilter: nf_tables: do not defer rule destruction via call_rcu
Date: Tue, 20 May 2025 02:22:36 +0200
Message-Id: <20250520002236.185365-4-pablo@netfilter.org>
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

From: Florian Westphal <fw@strlen.de>

commit b04df3da1b5c6f6dc7cdccc37941740c078c4043 upstream.

nf_tables_chain_destroy can sleep, it can't be used from call_rcu
callbacks.

Moreover, nf_tables_rule_release() is only safe for error unwinding,
while transaction mutex is held and the to-be-desroyed rule was not
exposed to either dataplane or dumps, as it deactives+frees without
the required synchronize_rcu() in-between.

nft_rule_expr_deactivate() callbacks will change ->use counters
of other chains/sets, see e.g. nft_lookup .deactivate callback, these
must be serialized via transaction mutex.

Also add a few lockdep asserts to make this more explicit.

Calling synchronize_rcu() isn't ideal, but fixing this without is hard
and way more intrusive.  As-is, we can get:

WARNING: .. net/netfilter/nf_tables_api.c:5515 nft_set_destroy+0x..
Workqueue: events nf_tables_trans_destroy_work
RIP: 0010:nft_set_destroy+0x3fe/0x5c0
Call Trace:
 <TASK>
 nf_tables_trans_destroy_work+0x6b7/0xad0
 process_one_work+0x64a/0xce0
 worker_thread+0x613/0x10d0

In case the synchronize_rcu becomes an issue, we can explore alternatives.

One way would be to allocate nft_trans_rule objects + one nft_trans_chain
object, deactivate the rules + the chain and then defer the freeing to the
nft destroy workqueue.  We'd still need to keep the synchronize_rcu path as
a fallback to handle -ENOMEM corner cases though.

Reported-by: syzbot+b26935466701e56cfdc2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67478d92.050a0220.253251.0062.GAE@google.com/T/
Fixes: c03d278fdf35 ("netfilter: nf_tables: wait for rcu grace period on net_device removal")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  3 ---
 net/netfilter/nf_tables_api.c     | 32 +++++++++++++++----------------
 2 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index c055847066c9..25dd157728a3 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -962,7 +962,6 @@ struct nft_chain {
 	char				*name;
 	u16				udlen;
 	u8				*udata;
-	struct rcu_head			rcu_head;
 
 	/* Only used during control plane commit phase: */
 	struct nft_rule			**rules_next;
@@ -1101,7 +1100,6 @@ static inline void nft_use_inc_restore(u32 *use)
  *	@sets: sets in the table
  *	@objects: stateful objects in the table
  *	@flowtables: flow tables in the table
- *	@net: netnamespace this table belongs to
  *	@hgenerator: handle generator state
  *	@handle: table handle
  *	@use: number of chain references to this table
@@ -1117,7 +1115,6 @@ struct nft_table {
 	struct list_head		sets;
 	struct list_head		objects;
 	struct list_head		flowtables;
-	possible_net_t			net;
 	u64				hgenerator;
 	u64				handle;
 	u32				use;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f3d20023b353..ff419ecb268a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1299,7 +1299,6 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 	INIT_LIST_HEAD(&table->sets);
 	INIT_LIST_HEAD(&table->objects);
 	INIT_LIST_HEAD(&table->flowtables);
-	write_pnet(&table->net, net);
 	table->family = family;
 	table->flags = flags;
 	table->handle = ++table_handle;
@@ -3345,8 +3344,11 @@ void nf_tables_rule_destroy(const struct nft_ctx *ctx, struct nft_rule *rule)
 	kfree(rule);
 }
 
+/* can only be used if rule is no longer visible to dumps */
 static void nf_tables_rule_release(const struct nft_ctx *ctx, struct nft_rule *rule)
 {
+	lockdep_commit_lock_is_held(ctx->net);
+
 	nft_rule_expr_deactivate(ctx, rule, NFT_TRANS_RELEASE);
 	nf_tables_rule_destroy(ctx, rule);
 }
@@ -4858,6 +4860,8 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
 			      struct nft_set_binding *binding,
 			      enum nft_trans_phase phase)
 {
+	lockdep_commit_lock_is_held(ctx->net);
+
 	switch (phase) {
 	case NFT_TRANS_PREPARE_ERROR:
 		nft_set_trans_unbind(ctx, set);
@@ -9571,19 +9575,6 @@ static void __nft_release_basechain_now(struct nft_ctx *ctx)
 	nf_tables_chain_destroy(ctx->chain);
 }
 
-static void nft_release_basechain_rcu(struct rcu_head *head)
-{
-	struct nft_chain *chain = container_of(head, struct nft_chain, rcu_head);
-	struct nft_ctx ctx = {
-		.family	= chain->table->family,
-		.chain	= chain,
-		.net	= read_pnet(&chain->table->net),
-	};
-
-	__nft_release_basechain_now(&ctx);
-	put_net(ctx.net);
-}
-
 int __nft_release_basechain(struct nft_ctx *ctx)
 {
 	struct nft_rule *rule;
@@ -9598,11 +9589,18 @@ int __nft_release_basechain(struct nft_ctx *ctx)
 	nft_chain_del(ctx->chain);
 	nft_use_dec(&ctx->table->use);
 
-	if (maybe_get_net(ctx->net))
-		call_rcu(&ctx->chain->rcu_head, nft_release_basechain_rcu);
-	else
+	if (!maybe_get_net(ctx->net)) {
 		__nft_release_basechain_now(ctx);
+		return 0;
+	}
+
+	/* wait for ruleset dumps to complete.  Owning chain is no longer in
+	 * lists, so new dumps can't find any of these rules anymore.
+	 */
+	synchronize_rcu();
 
+	__nft_release_basechain_now(ctx);
+	put_net(ctx->net);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(__nft_release_basechain);
-- 
2.30.2

