Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAFA150998
	for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2024 13:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715605793; cv=none; b=PyWTls1hNzg4lYEav97N9VJUwSdAonVCoiqGSos9ElQwYn2RWF7b88pSYFmv2e9Hz7nZ6VkLq+PszsrtrqCOgBfgD34OZUvMIjFWW1opgyt/+gGUfcsragNntBuDTF38N/Y8BYeCeAvodqwFML2RLsS9EFpqPrePhZpMci+50LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715605793; c=relaxed/simple;
	bh=JzHwGgSO89F5mDwmsYVn+3txqaRJzlXodr0lsQ0L4o8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kN+xsb2Lk9fnc3ZQezrm8neo2jUWPhWtLHRnBLjWiltq25OZ8uy/odRj4rCViYwMg+b3Q4SFl28w9nCOMmy2gwHhnQr0ZqK1xj4CaLpTnyy/z1y5Y2Bz/6byXljBn4PGZxRBxbbEf3tipRDN5lPxow7lZtfqgkHLOUcFWWvfsUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1s6VR8-0001Pk-08; Mon, 13 May 2024 15:09:50 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 06/11] netfilter: nf_tables: pass more specific nft_trans_chain where possible
Date: Mon, 13 May 2024 15:00:46 +0200
Message-ID: <20240513130057.11014-7-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240513130057.11014-1-fw@strlen.de>
References: <20240513130057.11014-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These functions pass a pointer to the base object type, use the
more specific one.  No functional change intended.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 51 ++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 00e5fdf8977b..5a40a8040539 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -446,6 +446,7 @@ nft_trans_alloc_chain(const struct nft_ctx *ctx, int msg_type)
 		struct nft_trans_chain *chain = nft_trans_container_chain(trans);
 
 		INIT_LIST_HEAD(&chain->nft_trans_binding.binding_list);
+		chain->chain = ctx->chain;
 	}
 
 	return trans;
@@ -467,7 +468,6 @@ static struct nft_trans *nft_trans_chain_add(struct nft_ctx *ctx, int msg_type)
 				ntohl(nla_get_be32(ctx->nla[NFTA_CHAIN_ID]));
 		}
 	}
-	nft_trans_chain(trans) = ctx->chain;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 
 	return trans;
@@ -2088,18 +2088,19 @@ static struct nft_stats __percpu *nft_stats_alloc(const struct nlattr *attr)
 	return newstats;
 }
 
-static void nft_chain_stats_replace(struct nft_trans *trans)
+static void nft_chain_stats_replace(struct nft_trans_chain *trans)
 {
-	struct nft_base_chain *chain = nft_base_chain(trans->ctx.chain);
+	const struct nft_trans *t = &trans->nft_trans_binding.nft_trans;
+	struct nft_base_chain *chain = nft_base_chain(trans->chain);
 
-	if (!nft_trans_chain_stats(trans))
+	if (!trans->stats)
 		return;
 
-	nft_trans_chain_stats(trans) =
-		rcu_replace_pointer(chain->stats, nft_trans_chain_stats(trans),
-				    lockdep_commit_lock_is_held(trans->ctx.net));
+	trans->stats =
+		rcu_replace_pointer(chain->stats, trans->stats,
+				    lockdep_commit_lock_is_held(t->ctx.net));
 
-	if (!nft_trans_chain_stats(trans))
+	if (!trans->stats)
 		static_branch_inc(&nft_counters_enabled);
 }
 
@@ -9455,47 +9456,47 @@ static int nf_tables_validate(struct net *net)
  *
  * We defer the drop policy until the transaction has been finalized.
  */
-static void nft_chain_commit_drop_policy(struct nft_trans *trans)
+static void nft_chain_commit_drop_policy(struct nft_trans_chain *trans)
 {
 	struct nft_base_chain *basechain;
 
-	if (nft_trans_chain_policy(trans) != NF_DROP)
+	if (trans->policy != NF_DROP)
 		return;
 
-	if (!nft_is_base_chain(trans->ctx.chain))
+	if (!nft_is_base_chain(trans->chain))
 		return;
 
-	basechain = nft_base_chain(trans->ctx.chain);
+	basechain = nft_base_chain(trans->chain);
 	basechain->policy = NF_DROP;
 }
 
-static void nft_chain_commit_update(struct nft_trans *trans)
+static void nft_chain_commit_update(struct nft_trans_chain *trans)
 {
-	struct nft_table *table = trans->ctx.table;
+	struct nft_table *table = trans->nft_trans_binding.nft_trans.ctx.table;
 	struct nft_base_chain *basechain;
 
-	if (nft_trans_chain_name(trans)) {
+	if (trans->name) {
 		rhltable_remove(&table->chains_ht,
-				&trans->ctx.chain->rhlhead,
+				&trans->chain->rhlhead,
 				nft_chain_ht_params);
-		swap(trans->ctx.chain->name, nft_trans_chain_name(trans));
+		swap(trans->chain->name, trans->name);
 		rhltable_insert_key(&table->chains_ht,
-				    trans->ctx.chain->name,
-				    &trans->ctx.chain->rhlhead,
+				    trans->chain->name,
+				    &trans->chain->rhlhead,
 				    nft_chain_ht_params);
 	}
 
-	if (!nft_is_base_chain(trans->ctx.chain))
+	if (!nft_is_base_chain(trans->chain))
 		return;
 
 	nft_chain_stats_replace(trans);
 
-	basechain = nft_base_chain(trans->ctx.chain);
+	basechain = nft_base_chain(trans->chain);
 
-	switch (nft_trans_chain_policy(trans)) {
+	switch (trans->policy) {
 	case NF_DROP:
 	case NF_ACCEPT:
-		basechain->policy = nft_trans_chain_policy(trans);
+		basechain->policy = trans->policy;
 		break;
 	}
 }
@@ -10308,14 +10309,14 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			break;
 		case NFT_MSG_NEWCHAIN:
 			if (nft_trans_chain_update(trans)) {
-				nft_chain_commit_update(trans);
+				nft_chain_commit_update(nft_trans_container_chain(trans));
 				nf_tables_chain_notify(&trans->ctx, NFT_MSG_NEWCHAIN,
 						       &nft_trans_chain_hooks(trans));
 				list_splice(&nft_trans_chain_hooks(trans),
 					    &nft_trans_basechain(trans)->hook_list);
 				/* trans destroyed after rcu grace period */
 			} else {
-				nft_chain_commit_drop_policy(trans);
+				nft_chain_commit_drop_policy(nft_trans_container_chain(trans));
 				nft_clear(net, trans->ctx.chain);
 				nf_tables_chain_notify(&trans->ctx, NFT_MSG_NEWCHAIN, NULL);
 				nft_trans_destroy(trans);
-- 
2.43.2

