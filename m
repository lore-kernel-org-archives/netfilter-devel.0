Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 416C7EB64DA
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jul 2023 15:02:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbjGEPC3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jul 2023 11:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbjGEPCV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jul 2023 11:02:21 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6CE281FF3;
        Wed,  5 Jul 2023 08:01:55 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     sashal@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Subject: [PATCH -stable,5.10,v2 05/11] netfilter: nf_tables: add NFT_TRANS_PREPARE_ERROR to deal with bound set/chain
Date:   Wed,  5 Jul 2023 17:00:05 +0200
Message-Id: <20230705150011.59408-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230705150011.59408-1-pablo@netfilter.org>
References: <20230705150011.59408-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

[ 26b5a5712eb85e253724e56a54c17f8519bd8e4e ]

Add a new state to deal with rule expressions deactivation from the
newrule error path, otherwise the anonymous set remains in the list in
inactive state for the next generation. Mark the set/chain transaction
as unbound so the abort path releases this object, set it as inactive in
the next generation so it is not reachable anymore from this transaction
and reference counter is dropped.

Fixes: 1240eb93f061 ("netfilter: nf_tables: incorrect error path handling with NFT_MSG_NEWRULE")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     | 45 ++++++++++++++++++++++++++-----
 net/netfilter/nft_immediate.c     |  3 +++
 3 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 28b3d4fbebae..03886052491e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -777,6 +777,7 @@ struct nft_expr_type {
 
 enum nft_trans_phase {
 	NFT_TRANS_PREPARE,
+	NFT_TRANS_PREPARE_ERROR,
 	NFT_TRANS_ABORT,
 	NFT_TRANS_COMMIT,
 	NFT_TRANS_RELEASE
@@ -970,6 +971,7 @@ struct nft_chain {
 
 int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain);
 int nf_tables_bind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
+void nf_tables_unbind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
 
 enum nft_chain_types {
 	NFT_CHAIN_T_DEFAULT = 0,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 10ec55f3f80a..c646537efaf5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -173,7 +173,8 @@ static void nft_trans_destroy(struct nft_trans *trans)
 	kfree(trans);
 }
 
-static void nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set)
+static void __nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set,
+				 bool bind)
 {
 	struct nftables_pernet *nft_net;
 	struct net *net = ctx->net;
@@ -187,17 +188,28 @@ static void nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set)
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
@@ -211,16 +223,22 @@ static void nft_chain_trans_bind(const struct nft_ctx *ctx, struct nft_chain *ch
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWCHAIN:
 			if (nft_trans_chain(trans) == chain)
-				nft_trans_chain_bound(trans) = true;
+				nft_trans_chain_bound(trans) = bind;
 			break;
 		case NFT_MSG_NEWRULE:
 			if (trans->ctx.chain == chain)
-				nft_trans_rule_bound(trans) = true;
+				nft_trans_rule_bound(trans) = bind;
 			break;
 		}
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
@@ -239,6 +257,11 @@ int nf_tables_bind_chain(const struct nft_ctx *ctx, struct nft_chain *chain)
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
@@ -3449,7 +3472,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 
 	return 0;
 err2:
-	nft_rule_expr_deactivate(&ctx, rule, NFT_TRANS_PREPARE);
+	nft_rule_expr_deactivate(&ctx, rule, NFT_TRANS_PREPARE_ERROR);
 	nf_tables_rule_destroy(&ctx, rule);
 err1:
 	for (i = 0; i < n; i++) {
@@ -4585,6 +4608,13 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
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
@@ -6525,6 +6555,7 @@ void nf_tables_deactivate_flowtable(const struct nft_ctx *ctx,
 				    enum nft_trans_phase phase)
 {
 	switch (phase) {
+	case NFT_TRANS_PREPARE_ERROR:
 	case NFT_TRANS_PREPARE:
 	case NFT_TRANS_ABORT:
 	case NFT_TRANS_RELEASE:
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index 9d4248898ce4..6b0efab4fad0 100644
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

