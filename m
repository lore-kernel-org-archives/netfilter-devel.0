Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D70B2C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Dec 2021 00:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234897AbhLJAcm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 19:32:42 -0500
Received: from mail.netfilter.org ([217.70.188.207]:44420 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234904AbhLJAck (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 19:32:40 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8D5AF60085
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Dec 2021 01:26:41 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 11/11] netfilter: nft_bitwise: track register operations
Date:   Fri, 10 Dec 2021 01:28:54 +0100
Message-Id: <20211210002854.144328-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211210002854.144328-1-pablo@netfilter.org>
References: <20211210002854.144328-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Check if the destination register already contains the data that this
bitwise store expression performs. This allows to skip this redundant
operation. If the destination contains a different bitwise operation,
cancel the register tracking information.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_bitwise.c | 79 +++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 47b0dba95054..ad577b79bc31 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -278,12 +278,53 @@ static int nft_bitwise_offload(struct nft_offload_ctx *ctx,
 	return 0;
 }
 
+static bool nft_bitwise_reduce(struct nft_regs_track *track,
+			       const struct nft_expr *expr)
+{
+	const struct nft_bitwise *priv = nft_expr_priv(expr);
+	const struct nft_bitwise *bitwise;
+
+	if (!track->regs[priv->dreg].selector)
+		return false;
+
+	if (!track->regs[priv->dreg].bitwise) {
+		track->regs[priv->dreg].bitwise = expr;
+		track->cur = expr;
+		return true;
+	}
+
+	if (track->regs[priv->dreg].bitwise->ops != expr->ops) {
+		track->regs[priv->dreg].selector = NULL;
+		track->regs[priv->dreg].bitwise = NULL;
+		return false;
+	}
+
+	bitwise = nft_expr_priv(track->regs[priv->dreg].bitwise);
+	if (memcmp(&priv->mask, &bitwise->mask, sizeof(priv->mask)) ||
+	    memcmp(&priv->xor, &bitwise->xor, sizeof(priv->xor)) ||
+	    memcmp(&priv->data, &bitwise->data, sizeof(priv->data)) ||
+	    priv->len != bitwise->len ||
+	    priv->op != bitwise->op ||
+	    priv->sreg != bitwise->sreg ||
+	    priv->dreg != bitwise->dreg) {
+		track->regs[priv->dreg].selector = NULL;
+		track->regs[priv->dreg].bitwise = NULL;
+		return false;
+	}
+
+	track->cur = expr;
+	pr_info("expr `%s' already in register, skip\n", expr->ops->type->name);
+
+	return true;
+}
+
 static const struct nft_expr_ops nft_bitwise_ops = {
 	.type		= &nft_bitwise_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_bitwise)),
 	.eval		= nft_bitwise_eval,
 	.init		= nft_bitwise_init,
 	.dump		= nft_bitwise_dump,
+	.reduce		= nft_bitwise_reduce,
 	.offload	= nft_bitwise_offload,
 };
 
@@ -385,12 +426,50 @@ static int nft_bitwise_fast_offload(struct nft_offload_ctx *ctx,
 	return 0;
 }
 
+static bool nft_bitwise_fast_reduce(struct nft_regs_track *track,
+				    const struct nft_expr *expr)
+{
+	const struct nft_bitwise_fast_expr *priv = nft_expr_priv(expr);
+	const struct nft_bitwise_fast_expr *bitwise;
+
+	if (!track->regs[priv->dreg].selector)
+		return false;
+
+	if (!track->regs[priv->dreg].bitwise) {
+		track->regs[priv->dreg].bitwise = expr;
+		track->cur = expr;
+		return true;
+	}
+
+	if (track->regs[priv->dreg].bitwise->ops != expr->ops) {
+		track->regs[priv->dreg].selector = NULL;
+		track->regs[priv->dreg].bitwise = NULL;
+		return false;
+	}
+
+	bitwise = nft_expr_priv(track->regs[priv->dreg].bitwise);
+	if (priv->mask != bitwise->mask ||
+	    priv->xor != bitwise->xor ||
+	    priv->sreg != bitwise->sreg ||
+	    priv->dreg != bitwise->dreg) {
+		track->regs[priv->dreg].selector = NULL;
+		track->regs[priv->dreg].bitwise = NULL;
+		return false;
+	}
+
+	pr_info("expr `%s' already in register, skip\n", expr->ops->type->name);
+	track->cur = expr;
+
+	return true;
+}
+
 const struct nft_expr_ops nft_bitwise_fast_ops = {
 	.type		= &nft_bitwise_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_bitwise_fast_expr)),
 	.eval		= NULL, /* inlined */
 	.init		= nft_bitwise_fast_init,
 	.dump		= nft_bitwise_fast_dump,
+	.reduce		= nft_bitwise_fast_reduce,
 	.offload	= nft_bitwise_fast_offload,
 };
 
-- 
2.30.2

