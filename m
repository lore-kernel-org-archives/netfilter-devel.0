Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF2251C9ED2;
	Fri, 28 Jun 2024 16:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719590727; cv=none; b=q+nu1yO49BaK5oyqg7GfJeaMvy84GHI1TUAeRtPcVdgmlr3QdgOeGOBDVAfi9cMVJL/MRkXzjhe65O8I53gbOTSwyincQkfTOBAeFV2OI+AC/Q+inGdbUXzlDxdHEco39DABmJr8J9oojD3mw0c9/Y6Z3RVcZVYh59XKTOSuqJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719590727; c=relaxed/simple;
	bh=EhJLAkSJNEcAQj8EAFjRLxHVJUr7XgCQpnkdsZnakac=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sOUuYoe2m6G60Ik4ivxVf2fq80IbtNAtvE/L2KHCm8pnILP/bh86kHhH4jdTsQQEzpY5gtil+sL6PAg+6cXnW9hEFPYODgJLzS+k83iEsUrPsAbsbXVWEbPkf0TTYGxEPodEC+poQcQ0jIdRHWv3gt3kaSI6/2LjlpOmVi08WEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 06/17] netfilter: nf_tables: pass more specific nft_trans_chain where possible
Date: Fri, 28 Jun 2024 18:04:54 +0200
Message-Id: <20240628160505.161283-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240628160505.161283-1-pablo@netfilter.org>
References: <20240628160505.161283-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

These functions pass a pointer to the base object type, use the
more specific one.  No functional change intended.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 51 ++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bdc2d7f781ca..62a4da955574 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -448,6 +448,7 @@ nft_trans_alloc_chain(const struct nft_ctx *ctx, int msg_type)
 
 	trans_chain = nft_trans_container_chain(trans);
 	INIT_LIST_HEAD(&trans_chain->nft_trans_binding.binding_list);
+	trans_chain->chain = ctx->chain;
 
 	return trans;
 }
@@ -468,7 +469,6 @@ static struct nft_trans *nft_trans_chain_add(struct nft_ctx *ctx, int msg_type)
 				ntohl(nla_get_be32(ctx->nla[NFTA_CHAIN_ID]));
 		}
 	}
-	nft_trans_chain(trans) = ctx->chain;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 
 	return trans;
@@ -2089,18 +2089,19 @@ static struct nft_stats __percpu *nft_stats_alloc(const struct nlattr *attr)
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
 
@@ -9456,47 +9457,47 @@ static int nf_tables_validate(struct net *net)
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
@@ -10309,14 +10310,14 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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
2.30.2

