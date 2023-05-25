Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F2FFC7EE2D
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 May 2023 15:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241327AbjEYPkh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 May 2023 11:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241186AbjEYPkc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 May 2023 11:40:32 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B1DDA99
        for <netfilter-devel@vger.kernel.org>; Thu, 25 May 2023 08:40:30 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v1 4/6] netfilter: nf_tables: add meta combo match
Date:   Thu, 25 May 2023 17:40:22 +0200
Message-Id: <20230525154024.222338-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230525154024.222338-1-pablo@netfilter.org>
References: <20230525154024.222338-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch allows to coalesce meta iifname,oifname + cmp into one combo
expression.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h      | 16 +++++++++++
 include/net/netfilter/nf_tables_core.h |  2 ++
 net/netfilter/nf_tables_api.c          |  9 ++++++
 net/netfilter/nf_tables_core.c         | 40 ++++++++++++++++++++++++++
 net/netfilter/nft_meta.c               | 32 +++++++++++++++++++++
 net/netfilter/nft_payload.c            |  2 +-
 6 files changed, 100 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index d061777ae860..6ae056dde789 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -126,6 +126,7 @@ struct nft_regs {
 enum nft_expr_track_type {
 	NFT_EXPR_UNSET = 0,
 	NFT_EXPR_PAYLOAD,
+	NFT_EXPR_META,
 	NFT_EXPR_CMP
 };
 
@@ -139,6 +140,11 @@ struct nft_expr_track {
 			u8		len;
 			u32		mask;
 		} payload;
+		struct {
+			u8		dreg;
+			u8		key;
+			bool		inv;
+		} meta;
 		struct {
 			u8		sreg;
 			u8		op;
@@ -157,11 +163,21 @@ struct nft_payload_combo {
 	struct nft_data	mask;
 };
 
+struct nft_meta_combo {
+	u8		key;
+	bool		inv;
+	struct nft_data	data;
+	struct nft_data	mask;
+};
+
+void nft_cmp16_mask(struct nft_data *data, unsigned int len);
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
index 6eb5cf980e66..424aca2f54e0 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -54,6 +54,7 @@ struct nft_payload {
 
 extern const struct nft_expr_ops nft_payload_fast_ops;
 extern const struct nft_expr_ops nft_payload_combo_ops;
+extern const struct nft_expr_ops nft_meta_combo_ops;
 
 extern struct static_key_false nft_counters_enabled;
 extern struct static_key_false nft_trace_enabled;
@@ -155,5 +156,6 @@ void nft_objref_map_eval(const struct nft_expr *expr, struct nft_regs *regs,
 			 const struct nft_pktinfo *pkt);
 
 void nft_payload_combo_init(struct nft_expr *expr, struct nft_exprs_track *track);
+void nft_meta_combo_init(struct nft_expr *expr, struct nft_exprs_track *track);
 
 #endif /* _NET_NF_TABLES_CORE_H */
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 00bbf8c2fdfd..ceae7a9bb989 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8923,6 +8923,7 @@ static int nft_expr_track(struct nft_exprs_track *expr_track,
 	case 0:
 		switch (expr_track->expr[0].type) {
 		case NFT_EXPR_PAYLOAD:
+		case NFT_EXPR_META:
 			expr_track->num_exprs++;
 			return 0;
 		default:
@@ -8939,6 +8940,14 @@ static int nft_expr_track(struct nft_exprs_track *expr_track,
 				return 1;
 			}
 			break;
+		case NFT_EXPR_META:
+			if (expr_track->expr[1].type == NFT_EXPR_CMP) {
+				nft_meta_combo_init((struct nft_expr *)&expr_track->_expr, expr_track);
+				expr_track->saved_expr[0] = (struct nft_expr *)&expr_track->_expr;
+				expr_track->num_exprs = 1;
+				return 1;
+			}
+			break;
 		default:
 			return 1;
 		}
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index db0c667ea5d0..417724330538 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -182,6 +182,44 @@ static inline void nft_payload_combo_eval(const struct nft_expr *expr,
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
+static inline void nft_meta_combo_eval(const struct nft_expr *expr,
+				       struct nft_regs *regs,
+				       const struct nft_pktinfo *pkt)
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
@@ -285,6 +323,8 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		nft_rule_dp_for_each_expr(expr, last, rule) {
 			if (expr->ops == &nft_payload_combo_ops)
 				nft_payload_combo_eval(expr, &regs, pkt);
+			else if (expr->ops == &nft_meta_combo_ops)
+				nft_meta_combo_eval(expr, &regs, pkt);
 			else if (expr->ops != &nft_payload_fast_ops ||
 				 !nft_payload_fast_eval(expr, &regs, pkt))
 				expr_call_ops_eval(expr, &regs, pkt);
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 73128d73fc99..b0e8255cdcd0 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -711,6 +711,22 @@ void nft_meta_set_destroy(const struct nft_ctx *ctx,
 }
 EXPORT_SYMBOL_GPL(nft_meta_set_destroy);
 
+static int nft_meta_get_track(struct nft_expr_track *track,
+			      const struct nft_expr *expr)
+{
+	const struct nft_meta *priv = nft_expr_priv(expr);
+
+	if (priv->key != NFT_META_IIFNAME &&
+	    priv->key != NFT_META_OIFNAME)
+		return 1;
+
+	track->type = NFT_EXPR_META;
+	track->meta.dreg = priv->dreg;
+	track->meta.key = priv->key;
+
+	return 0;
+}
+
 static int nft_meta_get_offload(struct nft_offload_ctx *ctx,
 				struct nft_flow_rule *flow,
 				const struct nft_expr *expr)
@@ -750,6 +766,7 @@ static const struct nft_expr_ops nft_meta_get_ops = {
 	.eval		= nft_meta_get_eval,
 	.init		= nft_meta_get_init,
 	.dump		= nft_meta_get_dump,
+	.track		= nft_meta_get_track,
 	.validate	= nft_meta_get_validate,
 	.offload	= nft_meta_get_offload,
 };
@@ -964,3 +981,18 @@ struct nft_object_type nft_secmark_obj_type __read_mostly = {
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
+	nft_cmp16_mask(&priv->mask, track->expr[1].cmp.len);
+}
+
+const struct nft_expr_ops nft_meta_combo_ops = {
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta_combo)),
+};
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 5b6affe18ffc..5c99eca32e84 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -1006,7 +1006,7 @@ static u32 nft_cmp_mask(u32 bitlen)
 	return (__force u32)cpu_to_le32(~0U >> (sizeof(u32) * BITS_PER_BYTE - bitlen));
 }
 
-static void nft_cmp16_mask(struct nft_data *data, unsigned int len)
+void nft_cmp16_mask(struct nft_data *data, unsigned int len)
 {
 	unsigned int bitlen = len * BITS_PER_BYTE;
 	int i, words = len / sizeof(u32);
-- 
2.30.2

