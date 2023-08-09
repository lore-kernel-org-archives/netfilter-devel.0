Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B4E8C41513
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Aug 2023 11:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbjHILFh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Aug 2023 07:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbjHILFg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Aug 2023 07:05:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4711702;
        Wed,  9 Aug 2023 04:05:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E1CD6309F;
        Wed,  9 Aug 2023 11:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE790C433C8;
        Wed,  9 Aug 2023 11:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1691579135;
        bh=fcibgim+ERhMZSah6mrjCAVT5weOmibbe8XwNkL2MLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EmIqXTyPWQoSVTOq3+WyERDkjsr5/LbXAxZIqnsQuyNxNJN8s4cNHqCSicKWuoGiw
         SSSsjNsvqg1hrhGUMUtlu371MJ7/4ar13k2UISiscsJbFJbkEE/zVy4pAFe7sMm+5W
         BIP1CASgEV7hIi1W7Ax/cBZMf1cjOU/DSa4jBuIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.14 088/204] netfilter: nf_tables: add NFT_TRANS_PREPARE_ERROR to deal with bound set/chain
Date:   Wed,  9 Aug 2023 12:40:26 +0200
Message-ID: <20230809103645.594505855@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ 26b5a5712eb85e253724e56a54c17f8519bd8e4e ]

Add a new state to deal with rule expressions deactivation from the
newrule error path, otherwise the anonymous set remains in the list in
inactive state for the next generation. Mark the set/chain transaction
as unbound so the abort path releases this object, set it as inactive in
the next generation so it is not reachable anymore from this transaction
and reference counter is dropped.

Fixes: 1240eb93f061 ("netfilter: nf_tables: incorrect error path handling with NFT_MSG_NEWRULE")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |    1 +
 net/netfilter/nf_tables_api.c     |   26 ++++++++++++++++++++++----
 2 files changed, 23 insertions(+), 4 deletions(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -725,6 +725,7 @@ struct nft_expr_type {
 
 enum nft_trans_phase {
 	NFT_TRANS_PREPARE,
+	NFT_TRANS_PREPARE_ERROR,
 	NFT_TRANS_ABORT,
 	NFT_TRANS_COMMIT,
 	NFT_TRANS_RELEASE
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -140,7 +140,8 @@ static void nft_trans_destroy(struct nft
 	kfree(trans);
 }
 
-static void nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set)
+static void __nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set,
+				 bool bind)
 {
 	struct net *net = ctx->net;
 	struct nft_trans *trans;
@@ -152,16 +153,26 @@ static void nft_set_trans_bind(const str
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
 static int nf_tables_register_hooks(struct net *net,
 				    const struct nft_table *table,
 				    struct nft_chain *chain,
@@ -2465,7 +2476,7 @@ static int nf_tables_newrule(struct net
 	return 0;
 
 err2:
-	nft_rule_expr_deactivate(&ctx, rule, NFT_TRANS_PREPARE);
+	nft_rule_expr_deactivate(&ctx, rule, NFT_TRANS_PREPARE_ERROR);
 	nf_tables_rule_destroy(&ctx, rule);
 err1:
 	for (i = 0; i < n; i++) {
@@ -3446,6 +3457,13 @@ void nf_tables_deactivate_set(const stru
 			      enum nft_trans_phase phase)
 {
 	switch (phase) {
+	case NFT_TRANS_PREPARE_ERROR:
+		nft_set_trans_unbind(ctx, set);
+		if (set->flags & NFT_SET_ANONYMOUS)
+			nft_deactivate_next(ctx->net, set);
+
+		set->use--;
+		break;
 	case NFT_TRANS_PREPARE:
 		if (set->flags & NFT_SET_ANONYMOUS)
 			nft_deactivate_next(ctx->net, set);


