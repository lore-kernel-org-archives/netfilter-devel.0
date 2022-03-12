Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4253AC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Mar 2022 15:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbiCLPtZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Mar 2022 10:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbiCLPtY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Mar 2022 10:49:24 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 072C08AE77
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2022 07:48:19 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3E0BC608F7
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2022 16:46:10 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 2/9] netfilter: nf_tables: cancel tracking for clobbered destination registers
Date:   Sat, 12 Mar 2022 16:48:04 +0100
Message-Id: <20220312154811.68611-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220312154811.68611-1-pablo@netfilter.org>
References: <20220312154811.68611-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Output of expressions might be larger than one single register, this might
clobber existing data. Reset tracking for all destination registers that
required to store the expression output.

This patch adds three new helper functions::

- nft_reg_track_update: cancel previous register tracking and update it.
- nft_reg_track_cancel: cancel any previous register tracking info.
- __nft_reg_track_cancel: cancel only one single register tracking info.

This patch updates the following expressions:

- meta_bridge
- bitwise
- byteorder
- nft_meta
- nft_payload

to use these helper functions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h      |  5 +++++
 include/net/netfilter/nft_meta.h       |  1 +
 net/bridge/netfilter/nft_meta_bridge.c |  4 ++--
 net/netfilter/nf_tables_api.c          | 31 ++++++++++++++++++++++++++
 net/netfilter/nft_bitwise.c            |  7 +++---
 net/netfilter/nft_byteorder.c          |  3 +--
 net/netfilter/nft_meta.c               | 11 +++++----
 net/netfilter/nft_payload.c            |  9 +++-----
 8 files changed, 51 insertions(+), 20 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index bb6529779a38..131cdbe3ddf0 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1643,4 +1643,9 @@ static inline bool nft_reduce_is_readonly(const struct nft_expr *expr)
 	return (unsigned long)expr->ops->reduce & NFT_REDUCE_INFOMASK;
 }
 
+void nft_reg_track_update(struct nft_regs_track *track,
+			  const struct nft_expr *expr, u8 dreg, int len);
+void nft_reg_track_cancel(struct nft_regs_track *track, u8 dreg, int len);
+void __nft_reg_track_cancel(struct nft_regs_track *track, u8 dreg);
+
 #endif /* _NET_NF_TABLES_H */
diff --git a/include/net/netfilter/nft_meta.h b/include/net/netfilter/nft_meta.h
index 2dce55c736f4..246fd023dcf4 100644
--- a/include/net/netfilter/nft_meta.h
+++ b/include/net/netfilter/nft_meta.h
@@ -6,6 +6,7 @@
 
 struct nft_meta {
 	enum nft_meta_keys	key:8;
+	u8			len;
 	union {
 		u8		dreg;
 		u8		sreg;
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index c1ef9cc89b78..380a31ebf840 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -87,6 +87,7 @@ static int nft_meta_bridge_get_init(const struct nft_ctx *ctx,
 		return nft_meta_get_init(ctx, expr, tb);
 	}
 
+	priv->len = len;
 	return nft_parse_register_store(ctx, tb[NFTA_META_DREG], &priv->dreg,
 					NULL, NFT_DATA_VALUE, len);
 }
@@ -112,8 +113,7 @@ static bool nft_meta_bridge_set_reduce(struct nft_regs_track *track,
 		if (track->regs[i].selector->ops != &nft_meta_bridge_get_ops)
 			continue;
 
-		track->regs[i].selector = NULL;
-		track->regs[i].bitwise = NULL;
+		__nft_reg_track_cancel(track, i);
 	}
 
 	return false;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8f74014d3777..fd91ec99b3d2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -550,6 +550,37 @@ static int nft_delflowtable(struct nft_ctx *ctx,
 	return err;
 }
 
+void nft_reg_track_update(struct nft_regs_track *track,
+			  const struct nft_expr *expr, u8 dreg, int len)
+{
+	track->regs[dreg].selector = expr;
+	track->regs[dreg].bitwise = NULL;
+
+	nft_reg_track_cancel(track, ++dreg, len - NFT_REG32_SIZE);
+}
+EXPORT_SYMBOL_GPL(nft_reg_track_update);
+
+void nft_reg_track_cancel(struct nft_regs_track *track, u8 dreg, int len)
+{
+	unsigned int regcount;
+	int i;
+
+	if (len <= 0)
+		return;
+
+	regcount = DIV_ROUND_UP(len, NFT_REG32_SIZE);
+	for (i = 0; i < regcount; i++, dreg++)
+		__nft_reg_track_cancel(track, dreg);
+}
+EXPORT_SYMBOL_GPL(nft_reg_track_cancel);
+
+void __nft_reg_track_cancel(struct nft_regs_track *track, u8 dreg)
+{
+	track->regs[dreg].selector = NULL;
+	track->regs[dreg].bitwise = NULL;
+}
+EXPORT_SYMBOL_GPL(__nft_reg_track_cancel);
+
 /*
  * Tables
  */
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 7b727d3ebf9d..a588576fe547 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -303,8 +303,7 @@ static bool nft_bitwise_reduce(struct nft_regs_track *track,
 	}
 
 	if (track->regs[priv->sreg].bitwise) {
-		track->regs[priv->dreg].selector = NULL;
-		track->regs[priv->dreg].bitwise = NULL;
+		nft_reg_track_cancel(track, priv->dreg, priv->len);
 		return false;
 	}
 
@@ -313,6 +312,7 @@ static bool nft_bitwise_reduce(struct nft_regs_track *track,
 			track->regs[priv->sreg].selector;
 	}
 	track->regs[priv->dreg].bitwise = expr;
+	nft_reg_track_cancel(track, priv->dreg + 1, priv->len - NFT_REG32_SIZE);
 
 	return false;
 }
@@ -447,8 +447,7 @@ static bool nft_bitwise_fast_reduce(struct nft_regs_track *track,
 	}
 
 	if (track->regs[priv->sreg].bitwise) {
-		track->regs[priv->dreg].selector = NULL;
-		track->regs[priv->dreg].bitwise = NULL;
+		nft_reg_track_cancel(track, priv->dreg, NFT_REG32_SIZE);
 		return false;
 	}
 
diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index e646e9ee4a98..d77609144b26 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -172,8 +172,7 @@ static bool nft_byteorder_reduce(struct nft_regs_track *track,
 {
 	struct nft_byteorder *priv = nft_expr_priv(expr);
 
-	track->regs[priv->dreg].selector = NULL;
-	track->regs[priv->dreg].bitwise = NULL;
+	nft_reg_track_cancel(track, priv->dreg, priv->len);
 
 	return false;
 }
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 5ab4df56c945..994ff41f4119 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -539,6 +539,7 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
+	priv->len = len;
 	return nft_parse_register_store(ctx, tb[NFTA_META_DREG], &priv->dreg,
 					NULL, NFT_DATA_VALUE, len);
 }
@@ -664,6 +665,7 @@ int nft_meta_set_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
+	priv->len = len;
 	err = nft_parse_register_load(tb[NFTA_META_SREG], &priv->sreg, len);
 	if (err < 0)
 		return err;
@@ -758,16 +760,14 @@ static bool nft_meta_get_reduce(struct nft_regs_track *track,
 
 	if (!track->regs[priv->dreg].selector ||
 	    track->regs[priv->dreg].selector->ops != expr->ops) {
-		track->regs[priv->dreg].selector = expr;
-		track->regs[priv->dreg].bitwise = NULL;
+		nft_reg_track_update(track, expr, priv->dreg, priv->len);
 		return false;
 	}
 
 	meta = nft_expr_priv(track->regs[priv->dreg].selector);
 	if (priv->key != meta->key ||
 	    priv->dreg != meta->dreg) {
-		track->regs[priv->dreg].selector = expr;
-		track->regs[priv->dreg].bitwise = NULL;
+		nft_reg_track_update(track, expr, priv->dreg, priv->len);
 		return false;
 	}
 
@@ -800,8 +800,7 @@ static bool nft_meta_set_reduce(struct nft_regs_track *track,
 		if (track->regs[i].selector->ops != &nft_meta_get_ops)
 			continue;
 
-		track->regs[i].selector = NULL;
-		track->regs[i].bitwise = NULL;
+		__nft_reg_track_cancel(track, i);
 	}
 
 	return false;
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 5cc06aef4345..70576f2c1f8b 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -218,8 +218,7 @@ static bool nft_payload_reduce(struct nft_regs_track *track,
 
 	if (!track->regs[priv->dreg].selector ||
 	    track->regs[priv->dreg].selector->ops != expr->ops) {
-		track->regs[priv->dreg].selector = expr;
-		track->regs[priv->dreg].bitwise = NULL;
+		nft_reg_track_update(track, expr, priv->dreg, priv->len);
 		return false;
 	}
 
@@ -227,8 +226,7 @@ static bool nft_payload_reduce(struct nft_regs_track *track,
 	if (priv->base != payload->base ||
 	    priv->offset != payload->offset ||
 	    priv->len != payload->len) {
-		track->regs[priv->dreg].selector = expr;
-		track->regs[priv->dreg].bitwise = NULL;
+		nft_reg_track_update(track, expr, priv->dreg, priv->len);
 		return false;
 	}
 
@@ -815,8 +813,7 @@ static bool nft_payload_set_reduce(struct nft_regs_track *track,
 		    track->regs[i].selector->ops != &nft_payload_fast_ops)
 			continue;
 
-		track->regs[i].selector = NULL;
-		track->regs[i].bitwise = NULL;
+		__nft_reg_track_cancel(track, i);
 	}
 
 	return false;
-- 
2.30.2

