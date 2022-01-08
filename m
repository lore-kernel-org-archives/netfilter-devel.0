Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 296E5C4167E
	for <netfilter-devel@archiver.kernel.org>; Sat,  8 Jan 2022 22:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbiAHW0w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 8 Jan 2022 17:26:52 -0500
Received: from mail.netfilter.org ([217.70.188.207]:40124 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233517AbiAHW0t (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Jan 2022 17:26:49 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0116764287
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Jan 2022 23:23:59 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 11/14] netfilter: nft_meta: track register operations
Date:   Sat,  8 Jan 2022 23:26:35 +0100
Message-Id: <20220108222638.36037-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220108222638.36037-1-pablo@netfilter.org>
References: <20220108222638.36037-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Check if the destination register already contains the data that this
meta store expression performs. This allows to skip this redundant
operation. If the destination contains a different selector, update
the register tracking information.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_meta.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index fe91ff5f8fbe..430f40bc3cb4 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -750,12 +750,40 @@ static int nft_meta_get_offload(struct nft_offload_ctx *ctx,
 	return 0;
 }
 
+static bool nft_meta_get_reduce(struct nft_regs_track *track,
+				const struct nft_expr *expr)
+{
+	const struct nft_meta *priv = nft_expr_priv(expr);
+	const struct nft_meta *meta;
+
+	if (!track->regs[priv->dreg].selector ||
+	    track->regs[priv->dreg].selector->ops != expr->ops) {
+		track->regs[priv->dreg].selector = expr;
+		track->regs[priv->dreg].bitwise = NULL;
+		return false;
+	}
+
+	meta = nft_expr_priv(track->regs[priv->dreg].selector);
+	if (priv->key != meta->key ||
+	    priv->dreg != meta->dreg) {
+		track->regs[priv->dreg].selector = expr;
+		track->regs[priv->dreg].bitwise = NULL;
+		return false;
+	}
+
+	if (!track->regs[priv->dreg].bitwise)
+		return true;
+
+	return false;
+}
+
 static const struct nft_expr_ops nft_meta_get_ops = {
 	.type		= &nft_meta_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
 	.eval		= nft_meta_get_eval,
 	.init		= nft_meta_get_init,
 	.dump		= nft_meta_get_dump,
+	.reduce		= nft_meta_get_reduce,
 	.validate	= nft_meta_get_validate,
 	.offload	= nft_meta_get_offload,
 };
-- 
2.30.2

