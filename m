Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F103DC4167D
	for <netfilter-devel@archiver.kernel.org>; Sat,  8 Jan 2022 22:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbiAHW0x (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 8 Jan 2022 17:26:53 -0500
Received: from mail.netfilter.org ([217.70.188.207]:40116 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233522AbiAHW0u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Jan 2022 17:26:50 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4DCFE6468F
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Jan 2022 23:24:00 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 12/14] netfilter: nft_bitwise: track register operations
Date:   Sat,  8 Jan 2022 23:26:36 +0100
Message-Id: <20220108222638.36037-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220108222638.36037-1-pablo@netfilter.org>
References: <20220108222638.36037-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Check if the destination register already contains the data that this
bitwise expression performs. This allows to skip this redundant
operation.

If the destination contains a different bitwise operation, cancel the
register tracking information. If the destination contains no bitwise
operation, update the register tracking information.

Update the payload and meta expression to check if this bitwise
operation has been already performed on the register. Hence, both the
payload/meta and the bitwise expressions are reduced.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  2 +
 net/netfilter/nft_bitwise.c       | 93 +++++++++++++++++++++++++++++++
 net/netfilter/nft_meta.c          |  2 +-
 net/netfilter/nft_payload.c       |  2 +-
 4 files changed, 97 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 1c37ce61daea..eaf55da9a205 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -358,6 +358,8 @@ int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src);
 void nft_expr_destroy(const struct nft_ctx *ctx, struct nft_expr *expr);
 int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
 		  const struct nft_expr *expr);
+bool nft_expr_reduce_bitwise(struct nft_regs_track *track,
+			     const struct nft_expr *expr);
 
 struct nft_set_ext;
 
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 47b0dba95054..95855fa41ad7 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -278,12 +278,51 @@ static int nft_bitwise_offload(struct nft_offload_ctx *ctx,
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
+		return false;
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
 
@@ -385,12 +424,48 @@ static int nft_bitwise_fast_offload(struct nft_offload_ctx *ctx,
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
+		return false;
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
 
@@ -427,3 +502,21 @@ struct nft_expr_type nft_bitwise_type __read_mostly = {
 	.maxattr	= NFTA_BITWISE_MAX,
 	.owner		= THIS_MODULE,
 };
+
+bool nft_expr_reduce_bitwise(struct nft_regs_track *track,
+			     const struct nft_expr *expr)
+{
+	const struct nft_expr *last = track->last;
+	const struct nft_expr *next;
+
+	if (expr == last)
+		return false;
+
+	next = nft_expr_next(expr);
+	if (next->ops == &nft_bitwise_ops)
+		return nft_bitwise_reduce(track, next);
+	else if (next->ops == &nft_bitwise_fast_ops)
+		return nft_bitwise_fast_reduce(track, next);
+
+	return false;
+}
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 430f40bc3cb4..40fe48fcf9d0 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -774,7 +774,7 @@ static bool nft_meta_get_reduce(struct nft_regs_track *track,
 	if (!track->regs[priv->dreg].bitwise)
 		return true;
 
-	return false;
+	return nft_expr_reduce_bitwise(track, expr);
 }
 
 static const struct nft_expr_ops nft_meta_get_ops = {
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index b228fea0f263..b5a3c45727b3 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -235,7 +235,7 @@ static bool nft_payload_reduce(struct nft_regs_track *track,
 	if (!track->regs[priv->dreg].bitwise)
 		return true;
 
-	return false;
+	return nft_expr_reduce_bitwise(track, expr);
 }
 
 static bool nft_payload_offload_mask(struct nft_offload_reg *reg,
-- 
2.30.2

