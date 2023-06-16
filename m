Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0DBCEB64D7
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Jun 2023 15:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345815AbjFPPMf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Jun 2023 11:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbjFPPMf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Jun 2023 11:12:35 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A494030FE
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Jun 2023 08:12:33 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v4 02/10] netfilter: nf_tables: add NFT_TRANS_PREPARE_ERROR to deal with bound set/chain
Date:   Fri, 16 Jun 2023 17:12:18 +0200
Message-Id: <20230616151226.66473-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230616151226.66473-1-pablo@netfilter.org>
References: <20230616151226.66473-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a new state to deal with rule expressions deactivation from the
newrule error path, otherwise the anonymous set remains in the list in
inactive state for the next generation. Mark the set/chain transaction
as unbound so the abort path releases this object, set it as inactive in
the next generation so it is not reachable anymore from this transaction
and reference counter is dropped.

Fixes: 1240eb93f061 ("netfilter: nf_tables: incorrect error path handling with NFT_MSG_NEWRULE")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: do not fall through _PREPARE state, next patch deactivates objects in
    the anonymous map and this is not required in _PREPARE_ERROR state,
    where the set is left unbound and the set transactions drop the
    refcount. This fixes a chain refcount underflow.

 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     | 43 ++++++++++++++++++++++++++-----
 net/netfilter/nft_immediate.c     |  3 +++
 3 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 8ba7f81e81a6..de2b0130c151 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -901,6 +901,7 @@ struct nft_expr_type {
 
 enum nft_trans_phase {
 	NFT_TRANS_PREPARE,
+	NFT_TRANS_PREPARE_ERROR,
 	NFT_TRANS_ABORT,
 	NFT_TRANS_COMMIT,
 	NFT_TRANS_RELEASE
@@ -1108,6 +1109,7 @@ int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
 			 struct nft_set_elem *elem);
 int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set);
 int nf_tables_bind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
+void nf_tables_unbind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
 
 enum nft_chain_types {
 	NFT_CHAIN_T_DEFAULT = 0,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7b3a0bf254e3..f8afefc8294f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -169,7 +169,8 @@ static void nft_trans_destroy(struct nft_trans *trans)
 	kfree(trans);
 }
 
-static void nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set)
+static void __nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set,
+				 bool bind)
 {
 	struct nftables_pernet *nft_net;
 	struct net *net = ctx->net;
@@ -183,17 +184,28 @@ static void nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set)
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWSET:
 			if (nft_trans_set(trans) == set)
-				nft_trans_set_bound(trans) = true;
+				nft_trans_set_bound(trans) = bind;
 			break;
 		case NFT_MSG_NEWSETELEM:
 			if (nft_trans_elem_set(trans) == set)
-				nft_trans_elem_set_bound(trans) = true;
+				nft_trans_elem_set_bound(trans) = bind;
 			break;
 		}
 	}
 }
 
-static void nft_chain_trans_bind(const struct nft_ctx *ctx, struct nft_chain *chain)
+static void nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set)
+{
+	return __nft_set_trans_bind(ctx, set, true);
+}
+
+static void nft_set_trans_unbind(const struct nft_ctx *ctx, struct nft_set *set)
+{
+	return __nft_set_trans_bind(ctx, set, false);
+}
+
+static void __nft_chain_trans_bind(const struct nft_ctx *ctx,
+				   struct nft_chain *chain, bool bind)
 {
 	struct nftables_pernet *nft_net;
 	struct net *net = ctx->net;
@@ -207,7 +219,7 @@ static void nft_chain_trans_bind(const struct nft_ctx *ctx, struct nft_chain *ch
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWCHAIN:
 			if (nft_trans_chain(trans) == chain)
-				nft_trans_chain_bound(trans) = true;
+				nft_trans_chain_bound(trans) = bind;
 			break;
 		case NFT_MSG_NEWRULE:
 			if (trans->ctx.chain == chain)
@@ -217,6 +229,12 @@ static void nft_chain_trans_bind(const struct nft_ctx *ctx, struct nft_chain *ch
 	}
 }
 
+static void nft_chain_trans_bind(const struct nft_ctx *ctx,
+				 struct nft_chain *chain)
+{
+	__nft_chain_trans_bind(ctx, chain, true);
+}
+
 int nf_tables_bind_chain(const struct nft_ctx *ctx, struct nft_chain *chain)
 {
 	if (!nft_chain_binding(chain))
@@ -235,6 +253,11 @@ int nf_tables_bind_chain(const struct nft_ctx *ctx, struct nft_chain *chain)
 	return 0;
 }
 
+void nf_tables_unbind_chain(const struct nft_ctx *ctx, struct nft_chain *chain)
+{
+	__nft_chain_trans_bind(ctx, chain, false);
+}
+
 static int nft_netdev_register_hooks(struct net *net,
 				     struct list_head *hook_list)
 {
@@ -3884,7 +3907,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 	if (flow)
 		nft_flow_rule_destroy(flow);
 err_release_rule:
-	nft_rule_expr_deactivate(&ctx, rule, NFT_TRANS_PREPARE);
+	nft_rule_expr_deactivate(&ctx, rule, NFT_TRANS_PREPARE_ERROR);
 	nf_tables_rule_destroy(&ctx, rule);
 err_release_expr:
 	for (i = 0; i < n; i++) {
@@ -5183,6 +5206,13 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
 			      enum nft_trans_phase phase)
 {
 	switch (phase) {
+	case NFT_TRANS_PREPARE_ERROR:
+		nft_set_trans_unbind(ctx, set);
+		if (nft_set_is_anonymous(set))
+			nft_deactivate_next(ctx->net, set);
+
+		set->use--;
+		break;
 	case NFT_TRANS_PREPARE:
 		if (nft_set_is_anonymous(set))
 			nft_deactivate_next(ctx->net, set);
@@ -7701,6 +7731,7 @@ void nf_tables_deactivate_flowtable(const struct nft_ctx *ctx,
 				    enum nft_trans_phase phase)
 {
 	switch (phase) {
+	case NFT_TRANS_PREPARE_ERROR:
 	case NFT_TRANS_PREPARE:
 	case NFT_TRANS_ABORT:
 	case NFT_TRANS_RELEASE:
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index de40090b39e1..38ddc4980007 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -150,6 +150,9 @@ static void nft_immediate_deactivate(const struct nft_ctx *ctx,
 				nft_rule_expr_deactivate(&chain_ctx, rule, phase);
 
 			switch (phase) {
+			case NFT_TRANS_PREPARE_ERROR:
+				nf_tables_unbind_chain(ctx, chain);
+				fallthrough;
 			case NFT_TRANS_PREPARE:
 				nft_deactivate_next(ctx->net, chain);
 				break;
-- 
2.30.2

