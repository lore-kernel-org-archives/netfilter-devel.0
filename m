Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4382CC7EE2A
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jun 2023 16:35:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237905AbjFFQfr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jun 2023 12:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238001AbjFFQfp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2023 12:35:45 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3F05710D5
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2023 09:35:44 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nf-next,v2 5/7] netfilter: nf_tables: add meta + cmp combo match
Date:   Tue,  6 Jun 2023 18:35:31 +0200
Message-Id: <20230606163533.1533-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230606163533.1533-1-pablo@netfilter.org>
References: <20230606163533.1533-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch allows to coalesce meta iifname,oifname + cmp into one combo
expression.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: fix nft_cmp16_mask() bitmask byteorder.
    call nft_expr_track_reset_dreg() to reset combo'ed register.

 include/net/netfilter/nf_tables.h      | 17 +++++++++++
 include/net/netfilter/nf_tables_core.h |  2 ++
 net/netfilter/nf_tables_api.c          | 19 ++++++++++++
 net/netfilter/nf_tables_core.c         | 40 ++++++++++++++++++++++++++
 net/netfilter/nft_meta.c               | 27 ++++++++++++++++-
 net/netfilter/nft_payload.c            |  2 +-
 6 files changed, 105 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 542b43f2be89..51bb7e295222 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -155,6 +155,7 @@ static inline void nft_expr_track_reset_dreg(struct nft_expr_track_ctx *ctx, u8
 enum nft_expr_track_type {
 	NFT_EXPR_UNSET = 0,
 	NFT_EXPR_PAYLOAD,
+	NFT_EXPR_META,
 	NFT_EXPR_CMP
 };
 
@@ -168,6 +169,12 @@ struct nft_expr_track {
 			u8		len;
 			u32		mask;
 		} payload;
+		struct {
+			u8		dreg;
+			u8		key;
+			u8		len;
+			bool		inv;
+		} meta;
 		struct {
 			u8		sreg;
 			u8		op;
@@ -187,11 +194,21 @@ struct nft_payload_combo {
 	struct nft_data	mask;
 };
 
+struct nft_meta_combo {
+	u8		key;
+	bool		inv;
+	struct nft_data	data;
+	struct nft_data	mask;
+};
+
+void nft_cmp16_mask(struct nft_data *data, unsigned int len, bool be);
+
 /* Same layout as nft_expr but it embeds the private expression data area. */
 struct nft_combo_expr {
 	const struct nft_expr_ops		*ops;
 	union {
 		struct nft_payload_combo	payload;
+		struct nft_meta_combo		meta;
 	} __attribute__((aligned(__alignof__(u64))));
 };
 
diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 663a41605371..1e101f66b26b 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -64,6 +64,7 @@ struct nft_payload {
 
 extern const struct nft_expr_ops nft_payload_fast_ops;
 extern const struct nft_expr_ops nft_payload_combo_ops;
+extern const struct nft_expr_ops nft_meta_combo_ops;
 
 extern struct static_key_false nft_counters_enabled;
 extern struct static_key_false nft_trace_enabled;
@@ -165,5 +166,6 @@ void nft_objref_map_eval(const struct nft_expr *expr, struct nft_regs *regs,
 			 const struct nft_pktinfo *pkt);
 
 void nft_payload_combo_init(struct nft_expr *expr, struct nft_exprs_track *track);
+void nft_meta_combo_init(struct nft_expr *expr, struct nft_exprs_track *track);
 
 #endif /* _NET_NF_TABLES_CORE_H */
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 119e92730553..007d184bd684 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8926,6 +8926,11 @@ static int nft_expr_track(struct nft_expr_track_ctx *ctx,
 			if (expr_track->expr[0].payload.base == NFT_PAYLOAD_NETWORK_HEADER)
 				return 0;
 			break;
+		case NFT_EXPR_META:
+			if (expr_track->expr[0].meta.key == NFT_META_IIFNAME ||
+			    expr_track->expr[0].meta.key == NFT_META_OIFNAME)
+				return 0;
+			break;
 		default:
 			break;
 		}
@@ -8943,6 +8948,20 @@ static int nft_expr_track(struct nft_expr_track_ctx *ctx,
 				return 1;
 			}
 			break;
+		case NFT_EXPR_META:
+			if (expr_track->expr[1].type == NFT_EXPR_CMP &&
+			    expr_track->expr[0].meta.dreg == expr_track->expr[1].cmp.sreg &&
+			    expr_track->expr[0].meta.len >= expr_track->expr[1].cmp.len) {
+				if (expr_track->expr[0].meta.key == NFT_META_IIFNAME ||
+				    expr_track->expr[0].meta.key == NFT_META_OIFNAME) {
+					nft_expr_track_reset_dreg(ctx, expr_track->expr[0].meta.dreg, expr_track->expr[0].meta.len);
+					nft_meta_combo_init((struct nft_expr *)&expr_track->_expr, expr_track);
+					expr_track->saved_expr[0] = (struct nft_expr *)&expr_track->_expr;
+					expr_track->num_exprs = 1;
+					return 1;
+				}
+			}
+			break;
 		default:
 			break;
 		}
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 749bd81ca33c..cf3f96f0bf2f 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -192,6 +192,44 @@ static inline void nft_payload_combo_eval(const struct nft_expr *expr,
 	regs->verdict.code = NFT_BREAK;
 }
 
+static inline int nft_combo_ifname(const u64 *x, struct nft_meta_combo *priv)
+{
+	const u64 *mask = (const u64 *)&priv->mask;
+	const u64 *data = (const u64 *)&priv->data;
+
+	return ((x[0] & mask[0]) == data[0] &&
+		(x[1] & mask[1]) == data[1]) ^ priv->inv;
+}
+
+static noinline void nft_meta_combo_eval(const struct nft_expr *expr,
+					 struct nft_regs *regs,
+					 const struct nft_pktinfo *pkt)
+{
+	struct nft_meta_combo *priv = nft_expr_priv(expr);
+	const struct net_device *dev;
+	const void *ptr;
+	bool ret;
+
+	switch (priv->key) {
+	case NFT_META_IIFNAME:
+		dev = nft_in(pkt);
+		break;
+	case NFT_META_OIFNAME:
+		dev = nft_out(pkt);
+		break;
+	}
+
+	if (unlikely(!dev))
+		goto err;
+
+	ptr = dev->name;
+	ret = nft_combo_ifname(ptr, priv);
+	if (ret)
+		return;
+err:
+	regs->verdict.code = NFT_BREAK;
+}
+
 DEFINE_STATIC_KEY_FALSE(nft_counters_enabled);
 
 static noinline void nft_update_chain_stats(const struct nft_chain *chain,
@@ -295,6 +333,8 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		nft_rule_dp_for_each_expr(expr, last, rule) {
 			if (expr->ops == &nft_payload_combo_ops)
 				nft_payload_combo_eval(expr, &regs, pkt);
+			else if (expr->ops == &nft_meta_combo_ops)
+				nft_meta_combo_eval(expr, &regs, pkt);
 			else if (expr->ops == &nft_cmp_fast_ops)
 				nft_cmp_fast_eval(expr, &regs);
 			else if (expr->ops != &nft_payload_fast_ops ||
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index db445f8c9f9f..2467bab717b6 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -752,7 +752,16 @@ int nft_meta_get_track(struct nft_expr_track_ctx *ctx,
 
 	nft_expr_track_dreg(ctx, priv->dreg, priv->len);
 
-	return 1;
+	if (priv->key != NFT_META_IIFNAME &&
+	    priv->key != NFT_META_OIFNAME)
+		return 1;
+
+	track->type = NFT_EXPR_META;
+	track->meta.dreg = priv->dreg;
+	track->meta.key = priv->key;
+	track->meta.len = IFNAMSIZ;
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(nft_meta_get_track);
 
@@ -774,6 +783,7 @@ static const struct nft_expr_ops nft_meta_get_ops = {
 	.eval		= nft_meta_get_eval,
 	.init		= nft_meta_get_init,
 	.dump		= nft_meta_get_dump,
+	.track		= nft_meta_get_track,
 	.validate	= nft_meta_get_validate,
 	.offload	= nft_meta_get_offload,
 };
@@ -990,3 +1000,18 @@ struct nft_object_type nft_secmark_obj_type __read_mostly = {
 	.owner		= THIS_MODULE,
 };
 #endif /* CONFIG_NETWORK_SECMARK */
+
+void nft_meta_combo_init(struct nft_expr *expr, struct nft_exprs_track *track)
+{
+	struct nft_meta_combo *priv = nft_expr_priv(expr);
+
+	expr->ops = &nft_meta_combo_ops;
+	priv->key = track->expr[0].meta.key;
+	memcpy(&priv->data, &track->expr[1].cmp.data, sizeof(priv->data));
+	priv->inv = track->expr[1].cmp.inv;
+	nft_cmp16_mask(&priv->mask, track->expr[1].cmp.len, false);
+}
+
+const struct nft_expr_ops nft_meta_combo_ops = {
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta_combo)),
+};
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index d6f59c82e14e..0169ced11704 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -1027,7 +1027,7 @@ static u32 nft_cmp_be_mask(u32 bitlen)
 	return (__force u32)cpu_to_le32(nft_cmp_mask(bitlen));
 }
 
-static void nft_cmp16_mask(struct nft_data *data, unsigned int len, bool be)
+void nft_cmp16_mask(struct nft_data *data, unsigned int len, bool be)
 {
 	unsigned int bitlen = len * BITS_PER_BYTE;
 	int i, words = len / sizeof(u32);
-- 
2.30.2

