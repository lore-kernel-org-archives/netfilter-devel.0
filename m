Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC65DC7EE33
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jun 2023 16:35:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238001AbjFFQfr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jun 2023 12:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbjFFQfq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2023 12:35:46 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3F55710D7
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2023 09:35:44 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nf-next,v2 6/7] netfilter: nf_tables: add payload + bitwise + cmp combo match
Date:   Tue,  6 Jun 2023 18:35:32 +0200
Message-Id: <20230606163533.1533-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230606163533.1533-1-pablo@netfilter.org>
References: <20230606163533.1533-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This allows to coalesce payload + bitwise + cmp expression into one
combo expression. This does not require updates on the datapath, the
existing mask field is adjusted based on the bitwise mask.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: call nft_expr_track_reset_dreg() to reset register that has been combo'ed
    in the register bitmap.

 include/net/netfilter/nf_tables.h      | 11 +++++++++--
 include/net/netfilter/nf_tables_core.h |  3 ++-
 net/netfilter/nf_tables_api.c          | 26 +++++++++++++++++++++++++-
 net/netfilter/nft_bitwise.c            | 16 +++++++++++++++-
 net/netfilter/nft_payload.c            | 11 ++++++++---
 5 files changed, 59 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 51bb7e295222..28c12fb870d9 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -156,6 +156,7 @@ enum nft_expr_track_type {
 	NFT_EXPR_UNSET = 0,
 	NFT_EXPR_PAYLOAD,
 	NFT_EXPR_META,
+	NFT_EXPR_BITWISE,
 	NFT_EXPR_CMP
 };
 
@@ -182,6 +183,12 @@ struct nft_expr_track {
 			bool		inv;
 			struct nft_data	data;
 		} cmp;
+		struct {
+			u8		sreg;
+			u8		dreg;
+			u8		len;
+			struct nft_data	mask;
+		} bitwise;
 	};
 };
 
@@ -214,8 +221,8 @@ struct nft_combo_expr {
 
 struct nft_exprs_track {
 	int			num_exprs;
-	struct nft_expr_track	expr[2];
-	const struct nft_expr	*saved_expr[2];
+	struct nft_expr_track	expr[3];
+	const struct nft_expr	*saved_expr[3];
 	struct nft_combo_expr	_expr;
 };
 
diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 1e101f66b26b..419ae7a2d413 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -165,7 +165,8 @@ void nft_objref_eval(const struct nft_expr *expr, struct nft_regs *regs,
 void nft_objref_map_eval(const struct nft_expr *expr, struct nft_regs *regs,
 			 const struct nft_pktinfo *pkt);
 
-void nft_payload_combo_init(struct nft_expr *expr, struct nft_exprs_track *track);
+void nft_payload_combo_init(struct nft_expr *expr, struct nft_exprs_track *track,
+			    bool bitmask);
 void nft_meta_combo_init(struct nft_expr *expr, struct nft_exprs_track *track);
 
 #endif /* _NET_NF_TABLES_CORE_H */
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 007d184bd684..dc0b5e1ada16 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8942,7 +8942,7 @@ static int nft_expr_track(struct nft_expr_track_ctx *ctx,
 			    expr_track->expr[0].payload.dreg == expr_track->expr[1].cmp.sreg &&
 			    expr_track->expr[0].payload.len == expr_track->expr[1].cmp.len) {
 				nft_expr_track_reset_dreg(ctx, expr_track->expr[0].payload.dreg, expr_track->expr[0].payload.len);
-				nft_payload_combo_init((struct nft_expr *)&expr_track->_expr, expr_track);
+				nft_payload_combo_init((struct nft_expr *)&expr_track->_expr, expr_track, false);
 				expr_track->saved_expr[0] = (struct nft_expr *)&expr_track->_expr;
 				expr_track->num_exprs = 1;
 				return 1;
@@ -8962,6 +8962,30 @@ static int nft_expr_track(struct nft_expr_track_ctx *ctx,
 				}
 			}
 			break;
+		case NFT_EXPR_BITWISE:
+			if (expr_track->expr[0].type == NFT_EXPR_PAYLOAD &&
+			    expr_track->expr[0].payload.dreg == expr_track->expr[1].bitwise.sreg &&
+			    expr_track->expr[0].payload.len >= expr_track->expr[1].bitwise.len)
+				return 0;
+			break;
+		default:
+			return 1;
+		}
+		break;
+	case 2:
+		switch (expr_track->expr[0].type) {
+		case NFT_EXPR_PAYLOAD:
+			if (expr_track->expr[1].type == NFT_EXPR_BITWISE &&
+			    expr_track->expr[2].type == NFT_EXPR_CMP &&
+			    expr_track->expr[1].bitwise.dreg == expr_track->expr[2].cmp.sreg &&
+			    expr_track->expr[1].bitwise.len >= expr_track->expr[2].cmp.len) {
+				nft_expr_track_reset_dreg(ctx, expr_track->expr[0].payload.dreg, expr_track->expr[0].payload.len);
+				nft_payload_combo_init((struct nft_expr *)&expr_track->_expr, expr_track, true);
+				expr_track->saved_expr[0] = (struct nft_expr *)&expr_track->_expr;
+				expr_track->num_exprs = 1;
+				return 1;
+			}
+			break;
 		default:
 			break;
 		}
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 0ab2d281f245..a263f8ca59c5 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -271,7 +271,21 @@ static int nft_bitwise_track(struct nft_expr_track_ctx *ctx,
 	nft_expr_track_sreg(ctx, priv->sreg, priv->len);
 	nft_expr_track_dreg(ctx, priv->dreg, priv->len);
 
-	return 1;
+	if (priv->op != NFT_BITWISE_BOOL)
+		return 1;
+
+	if (memcmp(&priv->xor, &zero, sizeof(priv->xor)))
+		return 1;
+
+	if (priv->sreg != priv->dreg)
+		return 1;
+
+	track->type = NFT_EXPR_BITWISE;
+	track->bitwise.sreg = priv->sreg;
+	track->bitwise.dreg = priv->dreg;
+	memcpy(&track->bitwise.mask, &priv->mask, sizeof(priv->mask));
+
+	return 0;
 }
 
 static int nft_bitwise_offload(struct nft_offload_ctx *ctx,
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 0169ced11704..8d1d4df2f90a 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -1051,17 +1051,22 @@ void nft_cmp16_mask(struct nft_data *data, unsigned int len, bool be)
 		data->data[i] = 0;
 }
 
-void nft_payload_combo_init(struct nft_expr *expr, struct nft_exprs_track *track)
+void nft_payload_combo_init(struct nft_expr *expr,
+			    struct nft_exprs_track *track, bool bitmask)
 {
 	struct nft_payload_combo *priv = nft_expr_priv(expr);
+	int index = bitmask ? 2 : 1;
 
 	expr->ops = &nft_payload_combo_ops;
 	priv->base = track->expr[0].payload.base;
 	priv->offset = track->expr[0].payload.offset;
 	priv->len = track->expr[0].payload.len;
-	memcpy(&priv->data, &track->expr[1].cmp.data, sizeof(priv->data));
-	priv->inv = track->expr[1].cmp.inv;
+	memcpy(&priv->data, &track->expr[index].cmp.data, sizeof(priv->data));
+	priv->inv = track->expr[index].cmp.inv;
 	nft_cmp16_mask(&priv->mask, track->expr[1].cmp.len, true);
+
+	if (bitmask)
+		priv->mask.data[0] &= track->expr[1].bitwise.mask.data[0];
 }
 
 const struct nft_expr_ops nft_payload_combo_ops = {
-- 
2.30.2

