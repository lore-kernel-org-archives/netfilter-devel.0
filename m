Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 413FEC7EE24
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jun 2023 16:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237934AbjFFQfp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jun 2023 12:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236543AbjFFQfp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2023 12:35:45 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 70D0310C2
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2023 09:35:41 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nf-next,v2 4/7] netfilter: nf_tables: add payload + cmp combo match
Date:   Tue,  6 Jun 2023 18:35:30 +0200
Message-Id: <20230606163533.1533-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230606163533.1533-1-pablo@netfilter.org>
References: <20230606163533.1533-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch uses the register tracking infrastructure to search for
expressions that can be coalesced into one single operation.

This patch allows to coalesce payload + cmp expression into a single
combo expression if matching length is <= 4 bytes or 16 bytes when
building the ruleset blob.

If .track returns 0, the expression added to the expression stack,
this means that it does not know what to do with this expression yet.
If .track returns 1, then the expressions in the stack are built into
the ruleset blob.

A later patch introduces -1 return value to skip such expression, which
is useful to skip the comment match.

If an expression accesses a register that has not been initialized via
previous load, then toggle the rule->skip_track flag and fall back to
use the normal expression representation. An attempt to recycle register
data that has been coalesced also triggers the skip_track fallback.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: use register tracking infrastructure and add skip_track fallback.
    call nft_expr_track_reset_dreg() to reset combo'ed register in bitmap.

 include/net/netfilter/nf_tables.h      |  50 +++++++++-
 include/net/netfilter/nf_tables_core.h |   4 +
 net/netfilter/nf_tables_api.c          | 123 +++++++++++++++++++++++--
 net/netfilter/nf_tables_core.c         |  44 ++++++++-
 net/netfilter/nft_cmp.c                |  22 ++++-
 net/netfilter/nft_payload.c            |  66 ++++++++++++-
 6 files changed, 296 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 81adf294da25..542b43f2be89 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -152,7 +152,54 @@ static inline void nft_expr_track_reset_dreg(struct nft_expr_track_ctx *ctx, u8
 #define __NFT_TRACK_GENERIC	1UL
 #define NFT_TRACK_GENERIC	(void *)__NFT_TRACK_GENERIC
 
+enum nft_expr_track_type {
+	NFT_EXPR_UNSET = 0,
+	NFT_EXPR_PAYLOAD,
+	NFT_EXPR_CMP
+};
+
 struct nft_expr_track {
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
+	u8		base;
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
 };
 
 /* Store/load an u8, u16 or u64 integer to/from the u32 data register.
@@ -996,7 +1043,8 @@ struct nft_rule {
 	u64				handle:42,
 					genmask:2,
 					dlen:12,
-					udata:1;
+					udata:1,
+					skip_track:1;
 	unsigned char			data[]
 		__attribute__((aligned(__alignof__(struct nft_expr))));
 };
diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 56b60dbe96d1..663a41605371 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -63,6 +63,7 @@ struct nft_payload {
 };
 
 extern const struct nft_expr_ops nft_payload_fast_ops;
+extern const struct nft_expr_ops nft_payload_combo_ops;
 
 extern struct static_key_false nft_counters_enabled;
 extern struct static_key_false nft_trace_enabled;
@@ -162,4 +163,7 @@ void nft_objref_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		     const struct nft_pktinfo *pkt);
 void nft_objref_map_eval(const struct nft_expr *expr, struct nft_regs *regs,
 			 const struct nft_pktinfo *pkt);
+
+void nft_payload_combo_init(struct nft_expr *expr, struct nft_exprs_track *track);
+
 #endif /* _NET_NF_TABLES_CORE_H */
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 80932407b9a6..119e92730553 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8901,13 +8901,70 @@ void nf_tables_trans_destroy_flush_work(void)
 }
 EXPORT_SYMBOL_GPL(nf_tables_trans_destroy_flush_work);
 
+static int nft_expr_track(struct nft_expr_track_ctx *ctx,
+			  struct nft_exprs_track *expr_track,
+			  const struct nft_expr *expr)
+{
+	int ret, num_exprs = expr_track->num_exprs - 1;
+
+	if (WARN_ON_ONCE(!expr->ops->track)) {
+		pr_warn_once("%s has no track callback\n", expr->ops->type->name);
+		return 1;
+	}
+
+	if (expr->ops->track == NFT_TRACK_GENERIC)
+		return 1;
+
+	ret = expr->ops->track(ctx, &expr_track->expr[num_exprs], expr);
+	if (ret > 0)
+		return 1;
+
+	switch (num_exprs) {
+	case 0:
+		switch (expr_track->expr[0].type) {
+		case NFT_EXPR_PAYLOAD:
+			if (expr_track->expr[0].payload.base == NFT_PAYLOAD_NETWORK_HEADER)
+				return 0;
+			break;
+		default:
+			break;
+		}
+		break;
+	case 1:
+		switch (expr_track->expr[0].type) {
+		case NFT_EXPR_PAYLOAD:
+			if (expr_track->expr[1].type == NFT_EXPR_CMP &&
+			    expr_track->expr[0].payload.dreg == expr_track->expr[1].cmp.sreg &&
+			    expr_track->expr[0].payload.len == expr_track->expr[1].cmp.len) {
+				nft_expr_track_reset_dreg(ctx, expr_track->expr[0].payload.dreg, expr_track->expr[0].payload.len);
+				nft_payload_combo_init((struct nft_expr *)&expr_track->_expr, expr_track);
+				expr_track->saved_expr[0] = (struct nft_expr *)&expr_track->_expr;
+				expr_track->num_exprs = 1;
+				return 1;
+			}
+			break;
+		default:
+			break;
+		}
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+
+	return 1;
+}
+
 static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *chain)
 {
+	struct nft_exprs_track expr_track = {};
 	const struct nft_expr *expr, *last;
+	struct nft_expr_track_ctx ctx;
 	unsigned int size, data_size;
 	void *data, *data_boundary;
 	struct nft_rule_dp *prule;
 	struct nft_rule *rule;
+	int i, ret;
 
 	/* already handled or inactive chain? */
 	if (chain->blob_next || !nft_is_active_next(net, chain))
@@ -8915,11 +8972,44 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 
 	data_size = 0;
 	list_for_each_entry(rule, &chain->rules, list) {
-		if (nft_is_active_next(net, rule)) {
-			data_size += sizeof(*prule) + rule->dlen;
-			if (data_size > INT_MAX)
-				return -ENOMEM;
+		if (!nft_is_active_next(net, rule))
+			continue;
+skip_track:
+		size = 0;
+		memset(&ctx, 0, sizeof(ctx));
+
+		nft_rule_for_each_expr(expr, last, rule) {
+			expr_track.saved_expr[expr_track.num_exprs] = expr;
+			expr_track.num_exprs++;
+
+			if (!rule->skip_track) {
+				ret = nft_expr_track(&ctx, &expr_track, expr);
+
+				if (ctx.cancel) {
+					if (WARN_ON_ONCE(rule->skip_track))
+						return -ENOMEM;
+
+					rule->skip_track = true;
+					pr_warn_once("skip tracking for %s\n", expr->ops->type->name);
+					goto skip_track;
+				}
+
+				if (ret == 0)
+					continue;
+			}
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
@@ -8929,6 +9019,8 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 	data = (void *)chain->blob_next->data;
 	data_boundary = data + data_size;
 	size = 0;
+	expr_track.num_exprs = 0;
+	memset(&ctx, 0, sizeof(ctx));
 
 	list_for_each_entry(rule, &chain->rules, list) {
 		if (!nft_is_active_next(net, rule))
@@ -8941,12 +9033,27 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 
 		size = 0;
 		nft_rule_for_each_expr(expr, last, rule) {
+			expr_track.saved_expr[expr_track.num_exprs] = expr;
+			expr_track.num_exprs++;
 
-			if (WARN_ON_ONCE(data + expr->ops->size > data_boundary))
-				return -ENOMEM;
+			if (!rule->skip_track) {
+				ret = nft_expr_track(&ctx, &expr_track, expr);
 
-			memcpy(data + size, expr, expr->ops->size);
-			size += expr->ops->size;
+				WARN_ON_ONCE(ctx.cancel);
+
+				if (ret == 0)
+					continue;
+			}
+
+			for (i = 0; i < expr_track.num_exprs; i++) {
+				if (WARN_ON_ONCE(data + size + expr_track.saved_expr[i]->ops->size > data_boundary))
+					return -ENOMEM;
+
+				memcpy(data + size, expr_track.saved_expr[i],
+				       expr_track.saved_expr[i]->ops->size);
+				size += expr_track.saved_expr[i]->ops->size;
+			}
+			expr_track.num_exprs = 0;
 		}
 		if (WARN_ON_ONCE(size >= 1 << 12))
 			return -ENOMEM;
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 0590f377a0fd..749bd81ca33c 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -152,6 +152,46 @@ static bool nft_payload_fast_eval(const struct nft_expr *expr,
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
+	if (unlikely(!ptr))
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
@@ -253,7 +293,9 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 	regs.verdict.code = NFT_CONTINUE;
 	for (; !rule->is_last ; rule = nft_rule_next(rule)) {
 		nft_rule_dp_for_each_expr(expr, last, rule) {
-			if (expr->ops == &nft_cmp_fast_ops)
+			if (expr->ops == &nft_payload_combo_ops)
+				nft_payload_combo_eval(expr, &regs, pkt);
+			else if (expr->ops == &nft_cmp_fast_ops)
 				nft_cmp_fast_eval(expr, &regs);
 			else if (expr->ops != &nft_payload_fast_ops ||
 				 !nft_payload_fast_eval(expr, &regs, pkt))
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index dc026cd4458d..c022e141db61 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -192,7 +192,18 @@ static int nft_cmp_track(struct nft_expr_track_ctx *ctx,
 
 	nft_expr_track_sreg(ctx, priv->sreg, priv->len);
 
-	return 1;
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
 }
 
 static const struct nft_expr_ops nft_cmp_ops = {
@@ -295,7 +306,14 @@ static int nft_cmp_fast_track(struct nft_expr_track_ctx *ctx,
 
 	nft_expr_track_sreg(ctx, priv->sreg, sizeof(u32));
 
-	return 1;
+	track->type = NFT_EXPR_CMP;
+	track->cmp.sreg = priv->sreg;
+	track->cmp.op = priv->inv ? NFT_CMP_NEQ : NFT_CMP_EQ;
+	track->cmp.len = sizeof(u32);
+	track->cmp.inv = priv->inv;
+	memcpy(&track->cmp.data, &priv->data, sizeof(priv->data));
+
+	return 0;
 }
 
 const struct nft_expr_ops nft_cmp_fast_ops = {
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index e5929aea685f..d6f59c82e14e 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -255,7 +255,16 @@ static int nft_payload_track(struct nft_expr_track_ctx *ctx,
 
 	nft_expr_track_dreg(ctx, priv->dreg, priv->len);
 
-	return 1;
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
 }
 
 static bool nft_payload_offload_mask(struct nft_offload_reg *reg,
@@ -1003,3 +1012,58 @@ struct nft_expr_type nft_payload_type __read_mostly = {
 	.maxattr	= NFTA_PAYLOAD_MAX,
 	.owner		= THIS_MODULE,
 };
+
+static u32 nft_cmp_mask(u32 bitlen)
+{
+	return ~0U >> (sizeof(u32) * BITS_PER_BYTE - bitlen);
+}
+
+/* Calculate the mask for the nft_cmp_fast expression. On big endian the
+ * mask needs to include the *upper* bytes when interpreting that data as
+ * something smaller than the full u32, therefore a cpu_to_le32 is done.
+ */
+static u32 nft_cmp_be_mask(u32 bitlen)
+{
+	return (__force u32)cpu_to_le32(nft_cmp_mask(bitlen));
+}
+
+static void nft_cmp16_mask(struct nft_data *data, unsigned int len, bool be)
+{
+	unsigned int bitlen = len * BITS_PER_BYTE;
+	int i, words = len / sizeof(u32);
+	u32 mask;
+
+	for (i = 0; i < words; i++) {
+		data->data[i] = 0xffffffff;
+		bitlen -= sizeof(u32) * BITS_PER_BYTE;
+	}
+
+	if (len % sizeof(u32)) {
+		if (be)
+			mask = nft_cmp_be_mask(bitlen);
+		else
+			mask = nft_cmp_mask(bitlen);
+
+		data->data[i++] = mask;
+	}
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
+	priv->base = track->expr[0].payload.base;
+	priv->offset = track->expr[0].payload.offset;
+	priv->len = track->expr[0].payload.len;
+	memcpy(&priv->data, &track->expr[1].cmp.data, sizeof(priv->data));
+	priv->inv = track->expr[1].cmp.inv;
+	nft_cmp16_mask(&priv->mask, track->expr[1].cmp.len, true);
+}
+
+const struct nft_expr_ops nft_payload_combo_ops = {
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_payload_combo)),
+};
-- 
2.30.2

