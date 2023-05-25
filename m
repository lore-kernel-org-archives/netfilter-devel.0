Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C03ECC7EE2F
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 May 2023 15:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241784AbjEYPke (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 May 2023 11:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241770AbjEYPkc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 May 2023 11:40:32 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E5805197
        for <netfilter-devel@vger.kernel.org>; Thu, 25 May 2023 08:40:30 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v1 5/6] netfilter: nf_tables: add payload bitwise combo match
Date:   Thu, 25 May 2023 17:40:23 +0200
Message-Id: <20230525154024.222338-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230525154024.222338-1-pablo@netfilter.org>
References: <20230525154024.222338-1-pablo@netfilter.org>
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
 include/net/netfilter/nf_tables.h      | 10 ++++++++--
 include/net/netfilter/nf_tables_core.h |  2 +-
 net/netfilter/nf_tables_api.c          | 20 +++++++++++++++++++-
 net/netfilter/nft_bitwise.c            | 20 ++++++++++++++++++++
 net/netfilter/nft_payload.c            | 13 +++++++++----
 5 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 6ae056dde789..85df4b23264f 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -127,6 +127,7 @@ enum nft_expr_track_type {
 	NFT_EXPR_UNSET = 0,
 	NFT_EXPR_PAYLOAD,
 	NFT_EXPR_META,
+	NFT_EXPR_BITWISE,
 	NFT_EXPR_CMP
 };
 
@@ -152,6 +153,11 @@ struct nft_expr_track {
 			bool		inv;
 			struct nft_data	data;
 		} cmp;
+		struct {
+			u8		sreg;
+			u8		dreg;
+			struct nft_data	mask;
+		} bitwise;
 	};
 };
 
@@ -183,8 +189,8 @@ struct nft_combo_expr {
 
 struct nft_exprs_track {
 	int			num_exprs;
-	struct nft_expr_track	expr[2];
-	const struct nft_expr	*saved_expr[2];
+	struct nft_expr_track	expr[3];
+	const struct nft_expr	*saved_expr[3];
 	struct nft_combo_expr	_expr;
 };
 
diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 424aca2f54e0..2d8c984e3955 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -155,7 +155,7 @@ void nft_objref_eval(const struct nft_expr *expr, struct nft_regs *regs,
 void nft_objref_map_eval(const struct nft_expr *expr, struct nft_regs *regs,
 			 const struct nft_pktinfo *pkt);
 
-void nft_payload_combo_init(struct nft_expr *expr, struct nft_exprs_track *track);
+void nft_payload_combo_init(struct nft_expr *expr, struct nft_exprs_track *track, bool mask);
 void nft_meta_combo_init(struct nft_expr *expr, struct nft_exprs_track *track);
 
 #endif /* _NET_NF_TABLES_CORE_H */
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ceae7a9bb989..3c5c3f3af333 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8934,7 +8934,7 @@ static int nft_expr_track(struct nft_exprs_track *expr_track,
 		switch (expr_track->expr[0].type) {
 		case NFT_EXPR_PAYLOAD:
 			if (expr_track->expr[1].type == NFT_EXPR_CMP) {
-				nft_payload_combo_init((struct nft_expr *)&expr_track->_expr, expr_track);
+				nft_payload_combo_init((struct nft_expr *)&expr_track->_expr, expr_track, false);
 				expr_track->saved_expr[0] = (struct nft_expr *)&expr_track->_expr;
 				expr_track->num_exprs = 1;
 				return 1;
@@ -8948,6 +8948,24 @@ static int nft_expr_track(struct nft_exprs_track *expr_track,
 				return 1;
 			}
 			break;
+		case NFT_EXPR_BITWISE:
+			expr_track->num_exprs++;
+			return 0;
+		default:
+			return 1;
+		}
+		break;
+	case 2:
+		switch (expr_track->expr[0].type) {
+		case NFT_EXPR_PAYLOAD:
+			if (expr_track->expr[2].type == NFT_EXPR_CMP) {
+				nft_payload_combo_init((struct nft_expr *)&expr_track->_expr, expr_track, true);
+				expr_track->saved_expr[0] = (struct nft_expr *)&expr_track->_expr;
+				expr_track->num_exprs = 1;
+				pr_info("collapsing\n");
+				return 1;
+			}
+			break;
 		default:
 			return 1;
 		}
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index b358c03bdb04..4bea8d36b027 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -262,6 +262,25 @@ static int nft_bitwise_dump(struct sk_buff *skb,
 
 static struct nft_data zero;
 
+static int nft_bitwise_track(struct nft_expr_track *track,
+			     const struct nft_expr *expr)
+{
+	const struct nft_bitwise *priv = nft_expr_priv(expr);
+
+	if (priv->op != NFT_BITWISE_BOOL)
+		return 1;
+
+	if (memcmp(&priv->xor, &zero, sizeof(priv->xor)))
+		return 1;
+
+	track->type = NFT_EXPR_BITWISE;
+	track->bitwise.sreg = priv->sreg;
+	track->bitwise.dreg = priv->dreg;
+	memcpy(&track->bitwise.mask, &priv->mask, sizeof(priv->mask));
+
+	return 0;
+}
+
 static int nft_bitwise_offload(struct nft_offload_ctx *ctx,
 			       struct nft_flow_rule *flow,
 			       const struct nft_expr *expr)
@@ -287,6 +306,7 @@ static const struct nft_expr_ops nft_bitwise_ops = {
 	.eval		= nft_bitwise_eval,
 	.init		= nft_bitwise_init,
 	.dump		= nft_bitwise_dump,
+	.track		= nft_bitwise_track,
 	.offload	= nft_bitwise_offload,
 };
 
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 5c99eca32e84..b1910287a0a0 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -1023,16 +1023,21 @@ void nft_cmp16_mask(struct nft_data *data, unsigned int len)
 		data->data[i] = 0;
 }
 
-void nft_payload_combo_init(struct nft_expr *expr, struct nft_exprs_track *track)
+void nft_payload_combo_init(struct nft_expr *expr,
+			    struct nft_exprs_track *track, bool bitmask)
 {
 	struct nft_payload_combo *priv = nft_expr_priv(expr);
+	int index = bitmask ? 2 : 1;
 
 	expr->ops = &nft_payload_combo_ops;
 	priv->offset = track->expr[0].payload.offset;
 	priv->len = track->expr[0].payload.len;
-	memcpy(&priv->data, &track->expr[1].cmp.data, sizeof(priv->data));
-	priv->inv = track->expr[1].cmp.inv;
-	nft_cmp16_mask(&priv->mask, track->expr[1].cmp.len);
+	memcpy(&priv->data, &track->expr[index].cmp.data, sizeof(priv->data));
+	priv->inv = track->expr[index].cmp.inv;
+	nft_cmp16_mask(&priv->mask, track->expr[index].cmp.len);
+
+	if (bitmask)
+		priv->mask.data[0] &= track->expr[1].bitwise.mask.data[0];
 }
 
 const struct nft_expr_ops nft_payload_combo_ops = {
-- 
2.30.2

