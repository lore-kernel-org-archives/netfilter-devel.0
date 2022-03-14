Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D38CAC4167B
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Mar 2022 17:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243245AbiCNRYj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Mar 2022 13:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243313AbiCNRYf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Mar 2022 13:24:35 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 09B1D31DE3
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2022 10:23:25 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id C3A1C60868
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2022 18:21:08 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v3 11/14] netfilter: nft_xfrm: track register operations
Date:   Mon, 14 Mar 2022 18:23:10 +0100
Message-Id: <20220314172313.63348-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220314172313.63348-1-pablo@netfilter.org>
References: <20220314172313.63348-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Check if the destination register already contains the data that this
xfrm expression performs. This allows to skip this redundant operation.
If the destination contains a different selector, update the register
tracking information.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: no changes

 net/netfilter/nft_xfrm.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
index cbbbc4ecad3a..becb88fa4e9b 100644
--- a/net/netfilter/nft_xfrm.c
+++ b/net/netfilter/nft_xfrm.c
@@ -27,6 +27,7 @@ struct nft_xfrm {
 	u8			dreg;
 	u8			dir;
 	u8			spnum;
+	u8			len;
 };
 
 static int nft_xfrm_get_init(const struct nft_ctx *ctx,
@@ -86,6 +87,7 @@ static int nft_xfrm_get_init(const struct nft_ctx *ctx,
 
 	priv->spnum = spnum;
 
+	priv->len = len;
 	return nft_parse_register_store(ctx, tb[NFTA_XFRM_DREG], &priv->dreg,
 					NULL, NFT_DATA_VALUE, len);
 }
@@ -252,6 +254,31 @@ static int nft_xfrm_validate(const struct nft_ctx *ctx, const struct nft_expr *e
 	return nft_chain_validate_hooks(ctx->chain, hooks);
 }
 
+static bool nft_xfrm_reduce(struct nft_regs_track *track,
+			    const struct nft_expr *expr)
+{
+	const struct nft_xfrm *priv = nft_expr_priv(expr);
+	const struct nft_xfrm *xfrm;
+
+	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
+		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+		return false;
+	}
+
+	xfrm = nft_expr_priv(track->regs[priv->dreg].selector);
+	if (priv->key != xfrm->key ||
+	    priv->dreg != xfrm->dreg ||
+	    priv->dir != xfrm->dir ||
+	    priv->spnum != xfrm->spnum) {
+		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+		return false;
+	}
+
+	if (!track->regs[priv->dreg].bitwise)
+		return true;
+
+	return nft_expr_reduce_bitwise(track, expr);
+}
 
 static struct nft_expr_type nft_xfrm_type;
 static const struct nft_expr_ops nft_xfrm_get_ops = {
@@ -261,6 +288,7 @@ static const struct nft_expr_ops nft_xfrm_get_ops = {
 	.init		= nft_xfrm_get_init,
 	.dump		= nft_xfrm_get_dump,
 	.validate	= nft_xfrm_validate,
+	.reduce		= nft_xfrm_reduce,
 };
 
 static struct nft_expr_type nft_xfrm_type __read_mostly = {
-- 
2.30.2

