Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C3EBC43219
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Mar 2022 00:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235719AbiCNAzi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 13 Mar 2022 20:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235022AbiCNAzf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 13 Mar 2022 20:55:35 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B6DC034B9C
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Mar 2022 17:54:26 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 278DD6300E
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2022 01:52:11 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 05/12,v2] netfilter: nft_meta: extend reduce support to bridge family
Date:   Mon, 14 Mar 2022 01:54:10 +0100
Message-Id: <20220314005417.315832-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220314005417.315832-1-pablo@netfilter.org>
References: <20220314005417.315832-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

its enough to export the meta get reduce helper and then call it
from nft_meta_bridge too.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes

 include/net/netfilter/nft_meta.h       | 2 ++
 net/bridge/netfilter/nft_meta_bridge.c | 1 +
 net/netfilter/nft_meta.c               | 5 +++--
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nft_meta.h b/include/net/netfilter/nft_meta.h
index 246fd023dcf4..9b51cc67de54 100644
--- a/include/net/netfilter/nft_meta.h
+++ b/include/net/netfilter/nft_meta.h
@@ -44,4 +44,6 @@ int nft_meta_set_validate(const struct nft_ctx *ctx,
 			  const struct nft_expr *expr,
 			  const struct nft_data **data);
 
+bool nft_meta_get_reduce(struct nft_regs_track *track,
+			 const struct nft_expr *expr);
 #endif
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 380a31ebf840..8c3eaba87ad2 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -99,6 +99,7 @@ static const struct nft_expr_ops nft_meta_bridge_get_ops = {
 	.eval		= nft_meta_bridge_get_eval,
 	.init		= nft_meta_bridge_get_init,
 	.dump		= nft_meta_get_dump,
+	.reduce		= nft_meta_get_reduce,
 };
 
 static bool nft_meta_bridge_set_reduce(struct nft_regs_track *track,
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 482eed7c7bbf..ac4859241e17 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -752,8 +752,8 @@ static int nft_meta_get_offload(struct nft_offload_ctx *ctx,
 	return 0;
 }
 
-static bool nft_meta_get_reduce(struct nft_regs_track *track,
-				const struct nft_expr *expr)
+bool nft_meta_get_reduce(struct nft_regs_track *track,
+			 const struct nft_expr *expr)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 	const struct nft_meta *meta;
@@ -775,6 +775,7 @@ static bool nft_meta_get_reduce(struct nft_regs_track *track,
 
 	return nft_expr_reduce_bitwise(track, expr);
 }
+EXPORT_SYMBOL_GPL(nft_meta_get_reduce);
 
 static const struct nft_expr_ops nft_meta_get_ops = {
 	.type		= &nft_meta_type,
-- 
2.30.2

