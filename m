Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5B2150998
	for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2024 13:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715605801; cv=none; b=Z/E7qhbnu6ogc5WZeNFLw3QdLVkowjggx3t3zNOKqhZ3jMsqQLTZnNXg6ExKS4Pt+/rBfiX+h14/JGgLEN4et/SB6yBFiY02jrDXWTi702xM44UDCXplrlfFAqtU811eiZwjzZSFSTgfyrgIV5ltu4otcAaLMSa74eYIVBOcveI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715605801; c=relaxed/simple;
	bh=gsaycAl9BWrapyqYEmKTDHC+BamB3TX2VYyy55Jf0cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7PkYC7dMRHVTf0eWaBa/7ABP5gbLxkZ45RkOL4LGohnvI3MhlV+R8+eO6uDCXh9H2lK8Wkm/GgycLPEk0dd2OTQ/sSrbh68nEkQUZ3Lr5XEwfvJSkRia1QVMRNL5z9Re4eApn6LJrr24KsqltsIfB4bpj6B/ee/mdifPSb8hgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1s6VRG-0001Q2-47; Mon, 13 May 2024 15:09:58 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 08/11] netfilter: nf_tables: store chain pointer in rule transaction
Date: Mon, 13 May 2024 15:00:48 +0200
Message-ID: <20240513130057.11014-9-fw@strlen.de>
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

Currently the chain can be derived from trans->ctx.chain, but
the ctx will go away soon.

Thus add the chain pointer to nft_trans_rule structure itself.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h |  3 +++
 net/netfilter/nf_tables_api.c     | 21 +++++++++++----------
 net/netfilter/nf_tables_offload.c | 16 ++++++++--------
 3 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3ae09dca65ad..11a38fcf4dec 100644
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
@@ -1653,6 +1654,8 @@ struct nft_trans_rule {
 	container_of(trans, struct nft_trans_rule, nft_trans)->rule_id
 #define nft_trans_rule_bound(trans)	\
 	container_of(trans, struct nft_trans_rule, nft_trans)->bound
+#define nft_trans_rule_chain(trans)	\
+	container_of(trans, struct nft_trans_rule, nft_trans)->chain
 
 struct nft_trans_set {
 	struct nft_trans_binding	nft_trans_binding;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 044007893e79..9d8fc31bbfc6 100644
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
@@ -540,6 +540,7 @@ static struct nft_trans *nft_trans_rule_add(struct nft_ctx *ctx, int msg_type,
 			ntohl(nla_get_be32(ctx->nla[NFTA_RULE_ID]));
 	}
 	nft_trans_rule(trans) = rule;
+	nft_trans_rule_chain(trans) = ctx->chain;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 
 	return trans;
@@ -4226,7 +4227,7 @@ static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
 
 	list_for_each_entry(trans, &nft_net->commit_list, list) {
 		if (trans->msg_type == NFT_MSG_NEWRULE &&
-		    trans->ctx.chain == chain &&
+		    nft_trans_rule_chain(trans) == chain &&
 		    id == nft_trans_rule_id(trans))
 			return nft_trans_rule(trans);
 	}
@@ -9683,7 +9684,7 @@ static void nf_tables_commit_chain_prepare_cancel(struct net *net)
 	list_for_each_entry_safe(trans, next, &nft_net->commit_list, list) {
 		if (trans->msg_type == NFT_MSG_NEWRULE ||
 		    trans->msg_type == NFT_MSG_DELRULE) {
-			struct nft_chain *chain = trans->ctx.chain;
+			struct nft_chain *chain = nft_trans_rule_chain(trans);
 
 			kvfree(chain->blob_next);
 			chain->blob_next = NULL;
@@ -10249,7 +10250,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		}
 		if (trans->msg_type == NFT_MSG_NEWRULE ||
 		    trans->msg_type == NFT_MSG_DELRULE) {
-			chain = trans->ctx.chain;
+			chain = nft_trans_rule_chain(trans);
 
 			ret = nf_tables_commit_chain_prepare(net, chain);
 			if (ret < 0) {
@@ -10345,7 +10346,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nf_tables_rule_notify(&trans->ctx,
 					      nft_trans_rule(trans),
 					      NFT_MSG_NEWRULE);
-			if (trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD)
+			if (nft_trans_rule_chain(trans)->flags & NFT_CHAIN_HW_OFFLOAD)
 				nft_flow_rule_destroy(nft_trans_flow_rule(trans));
 
 			nft_trans_destroy(trans);
@@ -10360,7 +10361,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 						 nft_trans_rule(trans),
 						 NFT_TRANS_COMMIT);
 
-			if (trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD)
+			if (nft_trans_rule_chain(trans)->flags & NFT_CHAIN_HW_OFFLOAD)
 				nft_flow_rule_destroy(nft_trans_flow_rule(trans));
 			break;
 		case NFT_MSG_NEWSET:
@@ -10644,20 +10645,20 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
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
2.43.2

