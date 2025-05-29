Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18AB219A7D;
	Thu, 29 May 2025 09:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748510325; cv=none; b=n5pdyOiig1OBHy9DhmrG5OTF1hi7kULLkreDht3wjkYH9cVmGz6TOXV/Pjl24BJKa/hrOfFnW+fax/rQWkCr/yMZi697DMmYHplHkjQHR49N37uJ+tvqvikJE8Fi5ug4caeZs8YIdHFws9Qay07ytrFLyjKnZd6uH2teUBtGElw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748510325; c=relaxed/simple;
	bh=DfSbHPCa6MxWvF44YVVS/IEpR9XOyDybF+XGjvCxaIM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L84KohuvEgeSTe16xdSKK/+tsC+EQTvDoCoyrc1IlBT/L2vFatSX8RbgvlgRJKwSZEhSWGrgYkeOnh8o4vKZmyJDTdGPvTqRkmCKbzECHwYypcbW0g9j7Et95i7Ld7DieU3+HCppSEkP/y52HtNA8A3xT8P0QMmMJV1uLkqusNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QL7eV3TH; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ignFCIOH; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QL7eV3TH";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ignFCIOH"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 20D6860753; Thu, 29 May 2025 11:11:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748509913;
	bh=1u9kumkznwUAxM5bTg9/ePa4WAoFSmRHyu7Y+ifICh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QL7eV3THbVcXwti7cOdVqBmIv4dItxh5VwT6YCdCCd8thNcl5ebQEBKYaUEnRvnIr
	 ltbR/+vy+P73/LYmVJ08PUgXgTdcD3wmq8W2hjHjD4RerglECnicYujFNKE+CZSiHt
	 j9O42WLz7S3FAeAObzqXzQoPD+zQm5A6XDMzlLDky4aPvZRflUmS9UlhUkXAjAcwwW
	 iKkxiPx4XlV0cDLXxpumxT6WBnauDwlMuij0O99jNAujzclKBraIOjiwCauWsx4qb9
	 Wnek5eDlZs9wL3IlMYcew+nwFLzuWLGkz1+0KFc8QvH+H4R/PE1k+3Jg8DRHwG4p82
	 dB4kz2ipebHvg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B8AA160750;
	Thu, 29 May 2025 11:11:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748509910;
	bh=1u9kumkznwUAxM5bTg9/ePa4WAoFSmRHyu7Y+ifICh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ignFCIOHyzqf6GvJmnCSjH/7GVyjg/F3yhMzZtP8C4R1nEi2iZwPESU5mTHZbJ4Wv
	 GA+uiOYZVAJQxO1zmgZpPsEaIJJryvw3q+A9XOHp7eDSKeMD8iaxhHKQyOvkqAYya+
	 /MP0EyachY5wDD+9dqu/23/Lf1vETA/OI2Sc1xOcCZyBVyy8GPZXOiXNw2iG2i7zcb
	 IInKc3kvwgFnZcAzDS2g/TGou6IOruBrS88EDdEl8EN+0D+oCJQoDV8PGGActUVmlv
	 dRhnc0fZsoKZFh3Dzlcw1hBWI5RtJoVsV6fLvDYjV9VePgEBeMCo8mxWerTMOwLbCi
	 rjbFHRldYA2VA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,5.4 3/3] netfilter: nf_tables: do not defer rule destruction via call_rcu
Date: Thu, 29 May 2025 11:11:44 +0200
Message-Id: <20250529091144.118355-4-pablo@netfilter.org>
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
 net/netfilter/nf_tables_api.c     | 31 ++++++++++++++-----------------
 2 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 566370938939..92551a765a44 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -899,7 +899,6 @@ struct nft_chain {
 	u8				flags:6,
 					genmask:2;
 	char				*name;
-	struct rcu_head			rcu_head;
 
 	/* Only used during control plane commit phase: */
 	struct nft_rule			**rules_next;
@@ -1016,7 +1015,6 @@ static inline void nft_use_inc_restore(u32 *use)
  *	@sets: sets in the table
  *	@objects: stateful objects in the table
  *	@flowtables: flow tables in the table
- *	@net: netnamespace this table belongs to
  *	@hgenerator: handle generator state
  *	@handle: table handle
  *	@use: number of chain references to this table
@@ -1032,7 +1030,6 @@ struct nft_table {
 	struct list_head		sets;
 	struct list_head		objects;
 	struct list_head		flowtables;
-	possible_net_t			net;
 	u64				hgenerator;
 	u64				handle;
 	u32				use;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2d015fcf8d8d..9e20fb759cb8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1109,7 +1109,6 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 	INIT_LIST_HEAD(&table->sets);
 	INIT_LIST_HEAD(&table->objects);
 	INIT_LIST_HEAD(&table->flowtables);
-	write_pnet(&table->net, net);
 	table->family = family;
 	table->flags = flags;
 	table->handle = ++table_handle;
@@ -2824,6 +2823,8 @@ static void nf_tables_rule_destroy(const struct nft_ctx *ctx,
 static void nf_tables_rule_release(const struct nft_ctx *ctx,
 				   struct nft_rule *rule)
 {
+	lockdep_commit_lock_is_held(ctx->net);
+
 	nft_rule_expr_deactivate(ctx, rule, NFT_TRANS_RELEASE);
 	nf_tables_rule_destroy(ctx, rule);
 }
@@ -4172,6 +4173,8 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
 			      struct nft_set_binding *binding,
 			      enum nft_trans_phase phase)
 {
+	lockdep_commit_lock_is_held(ctx->net);
+
 	switch (phase) {
 	case NFT_TRANS_PREPARE_ERROR:
 		nft_set_trans_unbind(ctx, set);
@@ -8228,19 +8231,6 @@ static void __nft_release_basechain_now(struct nft_ctx *ctx)
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
@@ -8255,11 +8245,18 @@ int __nft_release_basechain(struct nft_ctx *ctx)
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

