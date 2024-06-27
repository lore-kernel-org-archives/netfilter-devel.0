Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCD01149C7E;
	Thu, 27 Jun 2024 11:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719487647; cv=none; b=PULGE8C/olETcX7FPc2T+yM+2S8Vj/1wOrO+nSnQGgkIkmc8UT7kKF6jl9irU7MiVxKyzhrLo2EIBciB2jnmU7kngXCGrnvvN0i6NTlZHaQgQaGl57LzFXlkrFfOzz9r+stXasw6b2+bOltboeHwBdBEzYygDrdywo9ux6KnCgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719487647; c=relaxed/simple;
	bh=CzLS/cGwq9HBvNT+bmRidncFuqu6YNM7U/jvLyrhfTc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ja60ytfQ/Z5nX3+7yzsWBDt5+zF5XBBBh722YFWbH2cQv/32RFvxq+uZrtu3ZzOYg5MNTJpD/EjNvECIVbhouo/RMMBBBRXpmSEKmVLi4JyYkbgppDy2ywZRWUH5SyvFAhkD/p6cA1bTbDF9a+3NrQ5xUWvOpZMDq1xzmNy2nWw=
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
Subject: [PATCH nf-next 08/19] netfilter: nf_tables: store chain pointer in rule transaction
Date: Thu, 27 Jun 2024 13:27:02 +0200
Message-Id: <20240627112713.4846-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240627112713.4846-1-pablo@netfilter.org>
References: <20240627112713.4846-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Currently the chain can be derived from trans->ctx.chain, but
the ctx will go away soon.

Thus add the chain pointer to nft_trans_rule structure itself.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  3 +++
 net/netfilter/nf_tables_api.c     | 21 +++++++++++----------
 net/netfilter/nf_tables_offload.c | 16 ++++++++--------
 3 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 328fdc140551..86e6bd63a205 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1640,6 +1640,7 @@ struct nft_trans_binding {
 struct nft_trans_rule {
 	struct nft_trans		nft_trans;
 	struct nft_rule			*rule;
+	struct nft_chain		*chain;
 	struct nft_flow_rule		*flow;
 	u32				rule_id;
 	bool				bound;
@@ -1655,6 +1656,8 @@ struct nft_trans_rule {
 	nft_trans_container_rule(trans)->rule_id
 #define nft_trans_rule_bound(trans)			\
 	nft_trans_container_rule(trans)->bound
+#define nft_trans_rule_chain(trans)	\
+	nft_trans_container_rule(trans)->chain
 
 struct nft_trans_set {
 	struct nft_trans_binding	nft_trans_binding;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f4e39816104f..3e5980f0bf71 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -251,7 +251,7 @@ static void __nft_chain_trans_bind(const struct nft_ctx *ctx,
 				nft_trans_chain_bound(trans) = bind;
 			break;
 		case NFT_MSG_NEWRULE:
-			if (trans->ctx.chain == chain)
+			if (nft_trans_rule_chain(trans) == chain)
 				nft_trans_rule_bound(trans) = bind;
 			break;
 		}
@@ -541,6 +541,7 @@ static struct nft_trans *nft_trans_rule_add(struct nft_ctx *ctx, int msg_type,
 			ntohl(nla_get_be32(ctx->nla[NFTA_RULE_ID]));
 	}
 	nft_trans_rule(trans) = rule;
+	nft_trans_rule_chain(trans) = ctx->chain;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 
 	return trans;
@@ -4227,7 +4228,7 @@ static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
 
 	list_for_each_entry(trans, &nft_net->commit_list, list) {
 		if (trans->msg_type == NFT_MSG_NEWRULE &&
-		    trans->ctx.chain == chain &&
+		    nft_trans_rule_chain(trans) == chain &&
 		    id == nft_trans_rule_id(trans))
 			return nft_trans_rule(trans);
 	}
@@ -9684,7 +9685,7 @@ static void nf_tables_commit_chain_prepare_cancel(struct net *net)
 	list_for_each_entry_safe(trans, next, &nft_net->commit_list, list) {
 		if (trans->msg_type == NFT_MSG_NEWRULE ||
 		    trans->msg_type == NFT_MSG_DELRULE) {
-			struct nft_chain *chain = trans->ctx.chain;
+			struct nft_chain *chain = nft_trans_rule_chain(trans);
 
 			kvfree(chain->blob_next);
 			chain->blob_next = NULL;
@@ -10250,7 +10251,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		}
 		if (trans->msg_type == NFT_MSG_NEWRULE ||
 		    trans->msg_type == NFT_MSG_DELRULE) {
-			chain = trans->ctx.chain;
+			chain = nft_trans_rule_chain(trans);
 
 			ret = nf_tables_commit_chain_prepare(net, chain);
 			if (ret < 0) {
@@ -10346,7 +10347,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nf_tables_rule_notify(&trans->ctx,
 					      nft_trans_rule(trans),
 					      NFT_MSG_NEWRULE);
-			if (trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD)
+			if (nft_trans_rule_chain(trans)->flags & NFT_CHAIN_HW_OFFLOAD)
 				nft_flow_rule_destroy(nft_trans_flow_rule(trans));
 
 			nft_trans_destroy(trans);
@@ -10361,7 +10362,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 						 nft_trans_rule(trans),
 						 NFT_TRANS_COMMIT);
 
-			if (trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD)
+			if (nft_trans_rule_chain(trans)->flags & NFT_CHAIN_HW_OFFLOAD)
 				nft_flow_rule_destroy(nft_trans_flow_rule(trans));
 			break;
 		case NFT_MSG_NEWSET:
@@ -10645,20 +10646,20 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				nft_trans_destroy(trans);
 				break;
 			}
-			nft_use_dec_restore(&trans->ctx.chain->use);
+			nft_use_dec_restore(&nft_trans_rule_chain(trans)->use);
 			list_del_rcu(&nft_trans_rule(trans)->list);
 			nft_rule_expr_deactivate(&trans->ctx,
 						 nft_trans_rule(trans),
 						 NFT_TRANS_ABORT);
-			if (trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD)
+			if (nft_trans_rule_chain(trans)->flags & NFT_CHAIN_HW_OFFLOAD)
 				nft_flow_rule_destroy(nft_trans_flow_rule(trans));
 			break;
 		case NFT_MSG_DELRULE:
 		case NFT_MSG_DESTROYRULE:
-			nft_use_inc_restore(&trans->ctx.chain->use);
+			nft_use_inc_restore(&nft_trans_rule_chain(trans)->use);
 			nft_clear(trans->ctx.net, nft_trans_rule(trans));
 			nft_rule_expr_activate(&trans->ctx, nft_trans_rule(trans));
-			if (trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD)
+			if (nft_trans_rule_chain(trans)->flags & NFT_CHAIN_HW_OFFLOAD)
 				nft_flow_rule_destroy(nft_trans_flow_rule(trans));
 
 			nft_trans_destroy(trans);
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 8d892a0d2438..0619feb10abb 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -533,18 +533,18 @@ static void nft_flow_rule_offload_abort(struct net *net,
 						     FLOW_BLOCK_BIND);
 			break;
 		case NFT_MSG_NEWRULE:
-			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
+			if (!(nft_trans_rule_chain(trans)->flags & NFT_CHAIN_HW_OFFLOAD))
 				continue;
 
-			err = nft_flow_offload_rule(trans->ctx.chain,
+			err = nft_flow_offload_rule(nft_trans_rule_chain(trans),
 						    nft_trans_rule(trans),
 						    NULL, FLOW_CLS_DESTROY);
 			break;
 		case NFT_MSG_DELRULE:
-			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
+			if (!(nft_trans_rule_chain(trans)->flags & NFT_CHAIN_HW_OFFLOAD))
 				continue;
 
-			err = nft_flow_offload_rule(trans->ctx.chain,
+			err = nft_flow_offload_rule(nft_trans_rule_chain(trans),
 						    nft_trans_rule(trans),
 						    nft_trans_flow_rule(trans),
 						    FLOW_CLS_REPLACE);
@@ -586,7 +586,7 @@ int nft_flow_rule_offload_commit(struct net *net)
 						     FLOW_BLOCK_UNBIND);
 			break;
 		case NFT_MSG_NEWRULE:
-			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
+			if (!(nft_trans_rule_chain(trans)->flags & NFT_CHAIN_HW_OFFLOAD))
 				continue;
 
 			if (trans->ctx.flags & NLM_F_REPLACE ||
@@ -594,16 +594,16 @@ int nft_flow_rule_offload_commit(struct net *net)
 				err = -EOPNOTSUPP;
 				break;
 			}
-			err = nft_flow_offload_rule(trans->ctx.chain,
+			err = nft_flow_offload_rule(nft_trans_rule_chain(trans),
 						    nft_trans_rule(trans),
 						    nft_trans_flow_rule(trans),
 						    FLOW_CLS_REPLACE);
 			break;
 		case NFT_MSG_DELRULE:
-			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
+			if (!(nft_trans_rule_chain(trans)->flags & NFT_CHAIN_HW_OFFLOAD))
 				continue;
 
-			err = nft_flow_offload_rule(trans->ctx.chain,
+			err = nft_flow_offload_rule(nft_trans_rule_chain(trans),
 						    nft_trans_rule(trans),
 						    NULL, FLOW_CLS_DESTROY);
 			break;
-- 
2.30.2

