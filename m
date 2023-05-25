Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18FE2C77B7E
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 May 2023 15:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241782AbjEYPkd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 May 2023 11:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241327AbjEYPkc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 May 2023 11:40:32 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F47F195
        for <netfilter-devel@vger.kernel.org>; Thu, 25 May 2023 08:40:30 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v1 3/6] netfilter: nf_tables: add payload combo match
Date:   Thu, 25 May 2023 17:40:21 +0200
Message-Id: <20230525154024.222338-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230525154024.222338-1-pablo@netfilter.org>
References: <20230525154024.222338-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds the expression tracking infrastructure to search
for expressions that can be coalesced into one single operation.

This patch allows to coalesce payload + cmp expression into a single
combo expression if matching length is <= 4 bytes or 16 bytes when
building the ruleset blob.

If .track returns 0, the expression added to the expression stack,
this means that it does not know what to do with this expression yet.
If .track returns 1, then the expressions in the stack are built into
the ruleset blob.

A later patch introduces -1 return value to skip such expression, which
is useful to skip the comment match.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h      | 51 ++++++++++++++
 include/net/netfilter/nf_tables_core.h |  4 ++
 net/netfilter/nf_tables_api.c          | 92 +++++++++++++++++++++++---
 net/netfilter/nf_tables_core.c         | 46 ++++++++++++-
 net/netfilter/nft_cmp.c                | 20 ++++++
 net/netfilter/nft_payload.c            | 61 +++++++++++++++++
 6 files changed, 264 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 588b1904e411..d061777ae860 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -123,6 +123,55 @@ struct nft_regs {
 	};
 };
 
+enum nft_expr_track_type {
+	NFT_EXPR_UNSET = 0,
+	NFT_EXPR_PAYLOAD,
+	NFT_EXPR_CMP
+};
+
+struct nft_expr_track {
+	enum nft_expr_track_type	type;
+	union {
+		struct {
+			u8		dreg;
+			u8		base;
+			u8		offset;
+			u8		len;
+			u32		mask;
+		} payload;
+		struct {
+			u8		sreg;
+			u8		op;
+			u8		len;
+			bool		inv;
+			struct nft_data	data;
+		} cmp;
+	};
+};
+
+struct nft_payload_combo {
+	u8		offset;
+	u8		len;
+	bool		inv;
+	struct nft_data	data;
+	struct nft_data	mask;
+};
+
+/* Same layout as nft_expr but it embeds the private expression data area. */
+struct nft_combo_expr {
+	const struct nft_expr_ops		*ops;
+	union {
+		struct nft_payload_combo	payload;
+	} __attribute__((aligned(__alignof__(u64))));
+};
+
+struct nft_exprs_track {
+	int			num_exprs;
+	struct nft_expr_track	expr[2];
+	const struct nft_expr	*saved_expr[2];
+	struct nft_combo_expr	_expr;
+};
+
 /* Store/load an u8, u16 or u64 integer to/from the u32 data register.
  *
  * Note, when using concatenations, register allocation happens at 32-bit
@@ -934,6 +983,8 @@ struct nft_expr_ops {
 	int				(*validate)(const struct nft_ctx *ctx,
 						    const struct nft_expr *expr,
 						    const struct nft_data **data);
+	int				(*track)(struct nft_expr_track *track,
+						 const struct nft_expr *expr);
 	bool				(*gc)(struct net *net,
 					      const struct nft_expr *expr);
 	int				(*offload)(struct nft_offload_ctx *ctx,
diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index e98b7c244d36..6eb5cf980e66 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -53,6 +53,7 @@ struct nft_payload {
 };
 
 extern const struct nft_expr_ops nft_payload_fast_ops;
+extern const struct nft_expr_ops nft_payload_combo_ops;
 
 extern struct static_key_false nft_counters_enabled;
 extern struct static_key_false nft_trace_enabled;
@@ -152,4 +153,7 @@ void nft_objref_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		     const struct nft_pktinfo *pkt);
 void nft_objref_map_eval(const struct nft_expr *expr, struct nft_regs *regs,
 			 const struct nft_pktinfo *pkt);
+
+void nft_payload_combo_init(struct nft_expr *expr, struct nft_exprs_track *track);
+
 #endif /* _NET_NF_TABLES_CORE_H */
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 80932407b9a6..00bbf8c2fdfd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8901,13 +8901,67 @@ void nf_tables_trans_destroy_flush_work(void)
 }
 EXPORT_SYMBOL_GPL(nf_tables_trans_destroy_flush_work);
 
+static int nft_expr_track(struct nft_exprs_track *expr_track,
+			  const struct nft_expr *expr)
+{
+	int ret;
+
+	expr_track->saved_expr[expr_track->num_exprs] = expr;
+
+	if (!expr->ops->track) {
+		expr_track->num_exprs++;
+		return 1;
+	}
+
+	ret = expr->ops->track(&expr_track->expr[expr_track->num_exprs], expr);
+	if (ret > 0) {
+		expr_track->num_exprs++;
+		return 1;
+	}
+
+	switch (expr_track->num_exprs) {
+	case 0:
+		switch (expr_track->expr[0].type) {
+		case NFT_EXPR_PAYLOAD:
+			expr_track->num_exprs++;
+			return 0;
+		default:
+			return 1;
+		}
+		break;
+	case 1:
+		switch (expr_track->expr[0].type) {
+		case NFT_EXPR_PAYLOAD:
+			if (expr_track->expr[1].type == NFT_EXPR_CMP) {
+				nft_payload_combo_init((struct nft_expr *)&expr_track->_expr, expr_track);
+				expr_track->saved_expr[0] = (struct nft_expr *)&expr_track->_expr;
+				expr_track->num_exprs = 1;
+				return 1;
+			}
+			break;
+		default:
+			return 1;
+		}
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+
+	expr_track->num_exprs++;
+
+	return 1;
+}
+
 static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *chain)
 {
+	struct nft_exprs_track expr_track = {};
 	const struct nft_expr *expr, *last;
 	unsigned int size, data_size;
 	void *data, *data_boundary;
 	struct nft_rule_dp *prule;
 	struct nft_rule *rule;
+	int i;
 
 	/* already handled or inactive chain? */
 	if (chain->blob_next || !nft_is_active_next(net, chain))
@@ -8915,11 +8969,26 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 
 	data_size = 0;
 	list_for_each_entry(rule, &chain->rules, list) {
-		if (nft_is_active_next(net, rule)) {
-			data_size += sizeof(*prule) + rule->dlen;
-			if (data_size > INT_MAX)
-				return -ENOMEM;
+		if (!nft_is_active_next(net, rule))
+			continue;
+
+		size = 0;
+		nft_rule_for_each_expr(expr, last, rule) {
+			if (!nft_expr_track(&expr_track, expr))
+				continue;
+
+			for (i = 0; i < expr_track.num_exprs; i++)
+				size += expr_track.saved_expr[i]->ops->size;
+
+			expr_track.num_exprs = 0;
 		}
+
+		if (WARN_ON_ONCE(size >= 1 << 12))
+			return -ENOMEM;
+
+		data_size += sizeof(*prule) + size;
+		if (data_size > INT_MAX)
+			return -ENOMEM;
 	}
 
 	chain->blob_next = nf_tables_chain_alloc_rules(chain, data_size);
@@ -8929,6 +8998,7 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 	data = (void *)chain->blob_next->data;
 	data_boundary = data + data_size;
 	size = 0;
+	expr_track.num_exprs = 0;
 
 	list_for_each_entry(rule, &chain->rules, list) {
 		if (!nft_is_active_next(net, rule))
@@ -8941,12 +9011,18 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 
 		size = 0;
 		nft_rule_for_each_expr(expr, last, rule) {
+			if (!nft_expr_track(&expr_track, expr))
+				continue;
 
-			if (WARN_ON_ONCE(data + expr->ops->size > data_boundary))
-				return -ENOMEM;
+			for (i = 0; i < expr_track.num_exprs; i++) {
+				if (WARN_ON_ONCE(data + expr_track.saved_expr[i]->ops->size > data_boundary))
+					return -ENOMEM;
 
-			memcpy(data + size, expr, expr->ops->size);
-			size += expr->ops->size;
+				memcpy(data + size, expr_track.saved_expr[i],
+				       expr_track.saved_expr[i]->ops->size);
+				size += expr_track.saved_expr[i]->ops->size;
+			}
+			expr_track.num_exprs = 0;
 		}
 		if (WARN_ON_ONCE(size >= 1 << 12))
 			return -ENOMEM;
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index f7270195db9b..db0c667ea5d0 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -142,6 +142,46 @@ static bool nft_payload_fast_eval(const struct nft_expr *expr,
 	return true;
 }
 
+static inline int nft_payload_combo_match16(const u64 *x,
+					    struct nft_payload_combo *priv)
+{
+	const u64 *mask = (const u64 *)&priv->mask;
+	const u64 *data = (const u64 *)&priv->data;
+
+	return ((x[0] & mask[0]) == data[0] &&
+		(x[1] & mask[1]) == data[1]) ^ priv->inv;
+}
+
+static inline int nft_payload_combo_match4(const u32 *x,
+					   const struct nft_payload_combo *priv)
+{
+	return ((*x & priv->mask.data[0]) == priv->data.data[0]) ^ priv->inv;
+}
+
+static inline void nft_payload_combo_eval(const struct nft_expr *expr,
+					  struct nft_regs *regs,
+					  const struct nft_pktinfo *pkt)
+{
+	struct nft_payload_combo *priv = nft_expr_priv(expr);
+	char __buf[16];
+	void *ptr;
+	bool ret;
+
+	ptr = skb_header_pointer(pkt->skb, priv->offset, priv->len, __buf);
+	if (!ptr)
+		goto err;
+
+	if (priv->len == 16)
+		ret = nft_payload_combo_match16(ptr, priv);
+	else
+		ret = nft_payload_combo_match4(ptr, priv);
+
+	if (ret)
+		return;
+err:
+	regs->verdict.code = NFT_BREAK;
+}
+
 DEFINE_STATIC_KEY_FALSE(nft_counters_enabled);
 
 static noinline void nft_update_chain_stats(const struct nft_chain *chain,
@@ -243,8 +283,10 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 	regs.verdict.code = NFT_CONTINUE;
 	for (; !rule->is_last ; rule = nft_rule_next(rule)) {
 		nft_rule_dp_for_each_expr(expr, last, rule) {
-			if (expr->ops != &nft_payload_fast_ops ||
-			    !nft_payload_fast_eval(expr, &regs, pkt))
+			if (expr->ops == &nft_payload_combo_ops)
+				nft_payload_combo_eval(expr, &regs, pkt);
+			else if (expr->ops != &nft_payload_fast_ops ||
+				 !nft_payload_fast_eval(expr, &regs, pkt))
 				expr_call_ops_eval(expr, &regs, pkt);
 
 			if (regs.verdict.code != NFT_CONTINUE)
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 64856ceb60ea..800c3ec76b59 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -184,12 +184,32 @@ static int nft_cmp_offload(struct nft_offload_ctx *ctx,
 	return __nft_cmp_offload(ctx, flow, priv);
 }
 
+static int nft_cmp_track(struct nft_expr_track *track,
+			 const struct nft_expr *expr)
+{
+	const struct nft_cmp_expr *priv = nft_expr_priv(expr);
+
+	if (priv->op != NFT_CMP_EQ &&
+	    priv->op != NFT_CMP_NEQ)
+		return 1;
+
+	track->type = NFT_EXPR_CMP;
+	track->cmp.sreg = priv->sreg;
+	track->cmp.op = priv->op;
+	track->cmp.len = priv->len;
+	track->cmp.inv = (priv->op == NFT_CMP_NEQ);
+	memcpy(&track->cmp.data, &priv->data, sizeof(priv->data));
+
+	return 0;
+}
+
 static const struct nft_expr_ops nft_cmp_ops = {
 	.type		= &nft_cmp_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_cmp_expr)),
 	.eval		= nft_cmp_eval,
 	.init		= nft_cmp_init,
 	.dump		= nft_cmp_dump,
+	.track		= nft_cmp_track,
 	.offload	= nft_cmp_offload,
 };
 
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 2c06aca301cb..5b6affe18ffc 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -247,6 +247,23 @@ static int nft_payload_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_payload_track(struct nft_expr_track *track,
+			     const struct nft_expr *expr)
+{
+	const struct nft_payload *priv = nft_expr_priv(expr);
+
+	if (priv->len > 4 && priv->len < 16)
+		return 1;
+
+	track->type = NFT_EXPR_PAYLOAD;
+	track->payload.dreg = priv->dreg;
+	track->payload.base = priv->base;
+	track->payload.offset = priv->offset;
+	track->payload.len = priv->len;
+
+	return 0;
+}
+
 static bool nft_payload_offload_mask(struct nft_offload_reg *reg,
 				     u32 priv_len, u32 field_len)
 {
@@ -550,6 +567,7 @@ static const struct nft_expr_ops nft_payload_ops = {
 	.eval		= nft_payload_eval,
 	.init		= nft_payload_init,
 	.dump		= nft_payload_dump,
+	.track		= nft_payload_track,
 	.offload	= nft_payload_offload,
 };
 
@@ -559,6 +577,7 @@ const struct nft_expr_ops nft_payload_fast_ops = {
 	.eval		= nft_payload_eval,
 	.init		= nft_payload_init,
 	.dump		= nft_payload_dump,
+	.track		= nft_payload_track,
 	.offload	= nft_payload_offload,
 };
 
@@ -977,3 +996,45 @@ struct nft_expr_type nft_payload_type __read_mostly = {
 	.maxattr	= NFTA_PAYLOAD_MAX,
 	.owner		= THIS_MODULE,
 };
+
+/* Calculate the mask for the nft_cmp_fast expression. On big endian the
+ * mask needs to include the *upper* bytes when interpreting that data as
+ * something smaller than the full u32, therefore a cpu_to_le32 is done.
+ */
+static u32 nft_cmp_mask(u32 bitlen)
+{
+	return (__force u32)cpu_to_le32(~0U >> (sizeof(u32) * BITS_PER_BYTE - bitlen));
+}
+
+static void nft_cmp16_mask(struct nft_data *data, unsigned int len)
+{
+	unsigned int bitlen = len * BITS_PER_BYTE;
+	int i, words = len / sizeof(u32);
+
+	for (i = 0; i < words; i++) {
+		data->data[i] = 0xffffffff;
+		bitlen -= sizeof(u32) * BITS_PER_BYTE;
+	}
+
+	if (len % sizeof(u32))
+		data->data[i++] = nft_cmp_mask(bitlen);
+
+	for (; i < 4; i++)
+		data->data[i] = 0;
+}
+
+void nft_payload_combo_init(struct nft_expr *expr, struct nft_exprs_track *track)
+{
+	struct nft_payload_combo *priv = nft_expr_priv(expr);
+
+	expr->ops = &nft_payload_combo_ops;
+	priv->offset = track->expr[0].payload.offset;
+	priv->len = track->expr[0].payload.len;
+	memcpy(&priv->data, &track->expr[1].cmp.data, sizeof(priv->data));
+	priv->inv = track->expr[1].cmp.inv;
+	nft_cmp16_mask(&priv->mask, track->expr[1].cmp.len);
+}
+
+const struct nft_expr_ops nft_payload_combo_ops = {
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_payload_combo)),
+};
-- 
2.30.2

