Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6FFFC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Mar 2022 15:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbiCLPt0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Mar 2022 10:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbiCLPtY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Mar 2022 10:49:24 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A2F18AE7D
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2022 07:48:19 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id A7CEB60866
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2022 16:46:10 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 3/9] netfilter: nft_ct: track register operations
Date:   Sat, 12 Mar 2022 16:48:05 +0100
Message-Id: <20220312154811.68611-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220312154811.68611-1-pablo@netfilter.org>
References: <20220312154811.68611-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Check if the destination register already contains the data that this
ct store expression performs. This allows to skip this redundant
operation. If the destination contains a different selector, update
the register tracking information.

Export nft_expr_reduce_bitwise as a symbol since nft_ct might be
compiled as a module.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_bitwise.c |  1 +
 net/netfilter/nft_ct.c      | 48 +++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index a588576fe547..f9b47b9f9637 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -521,3 +521,4 @@ bool nft_expr_reduce_bitwise(struct nft_regs_track *track,
 
 	return false;
 }
+EXPORT_SYMBOL_GPL(nft_expr_reduce_bitwise);
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 98e361185503..346f204e2f87 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -26,6 +26,7 @@
 struct nft_ct {
 	enum nft_ct_keys	key:8;
 	enum ip_conntrack_dir	dir:8;
+	u8			len;
 	union {
 		u8		dreg;
 		u8		sreg;
@@ -500,6 +501,7 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 		}
 	}
 
+	priv->len = len;
 	err = nft_parse_register_store(ctx, tb[NFTA_CT_DREG], &priv->dreg, NULL,
 				       NFT_DATA_VALUE, len);
 	if (err < 0)
@@ -608,6 +610,7 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 		}
 	}
 
+	priv->len = len;
 	err = nft_parse_register_load(tb[NFTA_CT_SREG], &priv->sreg, len);
 	if (err < 0)
 		goto err1;
@@ -677,6 +680,30 @@ static int nft_ct_get_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static bool nft_ct_get_reduce(struct nft_regs_track *track,
+			      const struct nft_expr *expr)
+{
+	const struct nft_ct *priv = nft_expr_priv(expr);
+	const struct nft_ct *ct;
+
+	if (!track->regs[priv->dreg].selector ||
+	    track->regs[priv->dreg].selector->ops != expr->ops) {
+		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+		return false;
+	}
+
+	ct = nft_expr_priv(track->regs[priv->dreg].selector);
+	if (priv->key != ct->key) {
+		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+		return false;
+	}
+
+	if (!track->regs[priv->dreg].bitwise)
+		return true;
+
+	return nft_expr_reduce_bitwise(track, expr);
+}
+
 static int nft_ct_set_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_ct *priv = nft_expr_priv(expr);
@@ -710,8 +737,27 @@ static const struct nft_expr_ops nft_ct_get_ops = {
 	.init		= nft_ct_get_init,
 	.destroy	= nft_ct_get_destroy,
 	.dump		= nft_ct_get_dump,
+	.reduce		= nft_ct_get_reduce,
 };
 
+static bool nft_ct_set_reduce(struct nft_regs_track *track,
+			      const struct nft_expr *expr)
+{
+	int i;
+
+	for (i = 0; i < NFT_REG32_NUM; i++) {
+		if (!track->regs[i].selector)
+			continue;
+
+		if (track->regs[i].selector->ops != &nft_ct_get_ops)
+			continue;
+
+		__nft_reg_track_cancel(track, i);
+	}
+
+	return false;
+}
+
 static const struct nft_expr_ops nft_ct_set_ops = {
 	.type		= &nft_ct_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ct)),
@@ -719,6 +765,7 @@ static const struct nft_expr_ops nft_ct_set_ops = {
 	.init		= nft_ct_set_init,
 	.destroy	= nft_ct_set_destroy,
 	.dump		= nft_ct_set_dump,
+	.reduce		= nft_ct_set_reduce,
 };
 
 #ifdef CONFIG_NF_CONNTRACK_ZONES
@@ -729,6 +776,7 @@ static const struct nft_expr_ops nft_ct_set_zone_ops = {
 	.init		= nft_ct_set_init,
 	.destroy	= nft_ct_set_destroy,
 	.dump		= nft_ct_set_dump,
+	.reduce		= nft_ct_set_reduce,
 };
 #endif
 
-- 
2.30.2

