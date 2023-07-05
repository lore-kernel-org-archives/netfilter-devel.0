Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09BBCC001DF
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jul 2023 16:54:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbjGEQyz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jul 2023 12:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231972AbjGEQyp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jul 2023 12:54:45 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B6EB619B0;
        Wed,  5 Jul 2023 09:54:38 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     sashal@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Subject: [PATCH -stable,5.4 07/10] netfilter: nf_tables: add NFT_TRANS_PREPARE_ERROR to deal with bound set/chain
Date:   Wed,  5 Jul 2023 18:54:20 +0200
Message-Id: <20230705165423.50054-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230705165423.50054-1-pablo@netfilter.org>
References: <20230705165423.50054-1-pablo@netfilter.org>
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
 include/net/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c     | 27 +++++++++++++++++++++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 66c6fa5ede79..745af181ccea 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -756,6 +756,7 @@ struct nft_expr_type {
 
 enum nft_trans_phase {
 	NFT_TRANS_PREPARE,
+	NFT_TRANS_PREPARE_ERROR,
 	NFT_TRANS_ABORT,
 	NFT_TRANS_COMMIT,
 	NFT_TRANS_RELEASE
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 49450af83353..1551363d6c8f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -137,7 +137,8 @@ static void nft_trans_destroy(struct nft_trans *trans)
 	kfree(trans);
 }
 
-static void nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set)
+static void __nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set,
+				 bool bind)
 {
 	struct nftables_pernet *nft_net;
 	struct net *net = ctx->net;
@@ -151,16 +152,26 @@ static void nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set)
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
 static void nft_trans_commit_list_add_tail(struct net *net, struct nft_trans *trans)
 {
 	struct nftables_pernet *nft_net;
@@ -2939,7 +2950,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 
 	return 0;
 err2:
-	nft_rule_expr_deactivate(&ctx, rule, NFT_TRANS_PREPARE);
+	nft_rule_expr_deactivate(&ctx, rule, NFT_TRANS_PREPARE_ERROR);
 	nf_tables_rule_destroy(&ctx, rule);
 err1:
 	for (i = 0; i < n; i++) {
@@ -3959,6 +3970,13 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
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
@@ -5724,6 +5742,7 @@ void nf_tables_deactivate_flowtable(const struct nft_ctx *ctx,
 				    enum nft_trans_phase phase)
 {
 	switch (phase) {
+	case NFT_TRANS_PREPARE_ERROR:
 	case NFT_TRANS_PREPARE:
 	case NFT_TRANS_ABORT:
 	case NFT_TRANS_RELEASE:
-- 
2.30.2

