Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 640DFC77B7A
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 May 2023 15:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241540AbjEYPkc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 May 2023 11:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241186AbjEYPkb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 May 2023 11:40:31 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8D54E18D
        for <netfilter-devel@vger.kernel.org>; Thu, 25 May 2023 08:40:29 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v1 2/6] netfilter: nf_tables: remove fast bitwise and cmp operations
Date:   Thu, 25 May 2023 17:40:20 +0200
Message-Id: <20230525154024.222338-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230525154024.222338-1-pablo@netfilter.org>
References: <20230525154024.222338-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch removes r10fdd6d80e4c ("netfilter: nf_tables: Implement fast
bitwise expression") and 23f68d462984 ("netfilter: nft_cmp: optimize
comparison for 16-bytes") which aim to speed up matching on 128-bits and
<= 32-bits fields with bitwise operations in favour of the new combo
match approach.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_core.h |  28 ----
 net/netfilter/nf_tables_core.c         |  44 +-----
 net/netfilter/nft_bitwise.c            | 116 +--------------
 net/netfilter/nft_cmp.c                | 192 -------------------------
 4 files changed, 3 insertions(+), 377 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 780a5f6ad4a6..e98b7c244d36 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -29,38 +29,12 @@ extern struct nft_object_type nft_counter_obj_type;
 int nf_tables_core_module_init(void);
 void nf_tables_core_module_exit(void);
 
-struct nft_bitwise_fast_expr {
-	u32			mask;
-	u32			xor;
-	u8			sreg;
-	u8			dreg;
-};
-
-struct nft_cmp_fast_expr {
-	u32			data;
-	u32			mask;
-	u8			sreg;
-	u8			len;
-	bool			inv;
-};
-
-struct nft_cmp16_fast_expr {
-	struct nft_data		data;
-	struct nft_data		mask;
-	u8			sreg;
-	u8			len;
-	bool			inv;
-};
-
 struct nft_immediate_expr {
 	struct nft_data		data;
 	u8			dreg;
 	u8			dlen;
 };
 
-extern const struct nft_expr_ops nft_cmp_fast_ops;
-extern const struct nft_expr_ops nft_cmp16_fast_ops;
-
 struct nft_ct {
 	enum nft_ct_keys	key:8;
 	enum ip_conntrack_dir	dir:8;
@@ -80,8 +54,6 @@ struct nft_payload {
 
 extern const struct nft_expr_ops nft_payload_fast_ops;
 
-extern const struct nft_expr_ops nft_bitwise_fast_ops;
-
 extern struct static_key_false nft_counters_enabled;
 extern struct static_key_false nft_trace_enabled;
 
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 4d0ce12221f6..f7270195db9b 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -74,40 +74,6 @@ static inline void nft_trace_copy_nftrace(const struct nft_pktinfo *pkt,
 		info->nf_trace = pkt->skb->nf_trace;
 }
 
-static void nft_bitwise_fast_eval(const struct nft_expr *expr,
-				  struct nft_regs *regs)
-{
-	const struct nft_bitwise_fast_expr *priv = nft_expr_priv(expr);
-	u32 *src = &regs->data[priv->sreg];
-	u32 *dst = &regs->data[priv->dreg];
-
-	*dst = (*src & priv->mask) ^ priv->xor;
-}
-
-static void nft_cmp_fast_eval(const struct nft_expr *expr,
-			      struct nft_regs *regs)
-{
-	const struct nft_cmp_fast_expr *priv = nft_expr_priv(expr);
-
-	if (((regs->data[priv->sreg] & priv->mask) == priv->data) ^ priv->inv)
-		return;
-	regs->verdict.code = NFT_BREAK;
-}
-
-static void nft_cmp16_fast_eval(const struct nft_expr *expr,
-				struct nft_regs *regs)
-{
-	const struct nft_cmp16_fast_expr *priv = nft_expr_priv(expr);
-	const u64 *reg_data = (const u64 *)&regs->data[priv->sreg];
-	const u64 *mask = (const u64 *)&priv->mask;
-	const u64 *data = (const u64 *)&priv->data;
-
-	if (((reg_data[0] & mask[0]) == data[0] &&
-	    ((reg_data[1] & mask[1]) == data[1])) ^ priv->inv)
-		return;
-	regs->verdict.code = NFT_BREAK;
-}
-
 static noinline void __nft_trace_verdict(const struct nft_pktinfo *pkt,
 					 struct nft_traceinfo *info,
 					 const struct nft_rule_dp *rule,
@@ -277,14 +243,8 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 	regs.verdict.code = NFT_CONTINUE;
 	for (; !rule->is_last ; rule = nft_rule_next(rule)) {
 		nft_rule_dp_for_each_expr(expr, last, rule) {
-			if (expr->ops == &nft_cmp_fast_ops)
-				nft_cmp_fast_eval(expr, &regs);
-			else if (expr->ops == &nft_cmp16_fast_ops)
-				nft_cmp16_fast_eval(expr, &regs);
-			else if (expr->ops == &nft_bitwise_fast_ops)
-				nft_bitwise_fast_eval(expr, &regs);
-			else if (expr->ops != &nft_payload_fast_ops ||
-				 !nft_payload_fast_eval(expr, &regs, pkt))
+			if (expr->ops != &nft_payload_fast_ops ||
+			    !nft_payload_fast_eval(expr, &regs, pkt))
 				expr_call_ops_eval(expr, &regs, pkt);
 
 			if (regs.verdict.code != NFT_CONTINUE)
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 8d2b9249078a..b358c03bdb04 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -290,113 +290,6 @@ static const struct nft_expr_ops nft_bitwise_ops = {
 	.offload	= nft_bitwise_offload,
 };
 
-static int
-nft_bitwise_extract_u32_data(const struct nlattr * const tb, u32 *out)
-{
-	struct nft_data data;
-	struct nft_data_desc desc = {
-		.type	= NFT_DATA_VALUE,
-		.size	= sizeof(data),
-		.len	= sizeof(u32),
-	};
-	int err;
-
-	err = nft_data_init(NULL, &data, &desc, tb);
-	if (err < 0)
-		return err;
-
-	*out = data.data[0];
-
-	return 0;
-}
-
-static int nft_bitwise_fast_init(const struct nft_ctx *ctx,
-				 const struct nft_expr *expr,
-				 const struct nlattr * const tb[])
-{
-	struct nft_bitwise_fast_expr *priv = nft_expr_priv(expr);
-	int err;
-
-	err = nft_parse_register_load(tb[NFTA_BITWISE_SREG], &priv->sreg,
-				      sizeof(u32));
-	if (err < 0)
-		return err;
-
-	err = nft_parse_register_store(ctx, tb[NFTA_BITWISE_DREG], &priv->dreg,
-				       NULL, NFT_DATA_VALUE, sizeof(u32));
-	if (err < 0)
-		return err;
-
-	if (tb[NFTA_BITWISE_DATA])
-		return -EINVAL;
-
-	if (!tb[NFTA_BITWISE_MASK] ||
-	    !tb[NFTA_BITWISE_XOR])
-		return -EINVAL;
-
-	err = nft_bitwise_extract_u32_data(tb[NFTA_BITWISE_MASK], &priv->mask);
-	if (err < 0)
-		return err;
-
-	err = nft_bitwise_extract_u32_data(tb[NFTA_BITWISE_XOR], &priv->xor);
-	if (err < 0)
-		return err;
-
-	return 0;
-}
-
-static int
-nft_bitwise_fast_dump(struct sk_buff *skb,
-		      const struct nft_expr *expr, bool reset)
-{
-	const struct nft_bitwise_fast_expr *priv = nft_expr_priv(expr);
-	struct nft_data data;
-
-	if (nft_dump_register(skb, NFTA_BITWISE_SREG, priv->sreg))
-		return -1;
-	if (nft_dump_register(skb, NFTA_BITWISE_DREG, priv->dreg))
-		return -1;
-	if (nla_put_be32(skb, NFTA_BITWISE_LEN, htonl(sizeof(u32))))
-		return -1;
-	if (nla_put_be32(skb, NFTA_BITWISE_OP, htonl(NFT_BITWISE_BOOL)))
-		return -1;
-
-	data.data[0] = priv->mask;
-	if (nft_data_dump(skb, NFTA_BITWISE_MASK, &data,
-			  NFT_DATA_VALUE, sizeof(u32)) < 0)
-		return -1;
-
-	data.data[0] = priv->xor;
-	if (nft_data_dump(skb, NFTA_BITWISE_XOR, &data,
-			  NFT_DATA_VALUE, sizeof(u32)) < 0)
-		return -1;
-
-	return 0;
-}
-
-static int nft_bitwise_fast_offload(struct nft_offload_ctx *ctx,
-				    struct nft_flow_rule *flow,
-				    const struct nft_expr *expr)
-{
-	const struct nft_bitwise_fast_expr *priv = nft_expr_priv(expr);
-	struct nft_offload_reg *reg = &ctx->regs[priv->dreg];
-
-	if (priv->xor || priv->sreg != priv->dreg || reg->len != sizeof(u32))
-		return -EOPNOTSUPP;
-
-	reg->mask.data[0] = priv->mask;
-	return 0;
-}
-
-const struct nft_expr_ops nft_bitwise_fast_ops = {
-	.type		= &nft_bitwise_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_bitwise_fast_expr)),
-	.eval		= NULL, /* inlined */
-	.init		= nft_bitwise_fast_init,
-	.dump		= nft_bitwise_fast_dump,
-	.offload	= nft_bitwise_fast_offload,
-};
-
 static const struct nft_expr_ops *
 nft_bitwise_select_ops(const struct nft_ctx *ctx,
 		       const struct nlattr * const tb[])
@@ -413,14 +306,7 @@ nft_bitwise_select_ops(const struct nft_ctx *ctx,
 	if (err < 0)
 		return ERR_PTR(err);
 
-	if (len != sizeof(u32))
-		return &nft_bitwise_ops;
-
-	if (tb[NFTA_BITWISE_OP] &&
-	    ntohl(nla_get_be32(tb[NFTA_BITWISE_OP])) != NFT_BITWISE_BOOL)
-		return &nft_bitwise_ops;
-
-	return &nft_bitwise_fast_ops;
+	return &nft_bitwise_ops;
 }
 
 struct nft_expr_type nft_bitwise_type __read_mostly = {
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 75a7b24eeefc..64856ceb60ea 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -193,190 +193,6 @@ static const struct nft_expr_ops nft_cmp_ops = {
 	.offload	= nft_cmp_offload,
 };
 
-/* Calculate the mask for the nft_cmp_fast expression. On big endian the
- * mask needs to include the *upper* bytes when interpreting that data as
- * something smaller than the full u32, therefore a cpu_to_le32 is done.
- */
-static u32 nft_cmp_fast_mask(unsigned int len)
-{
-	__le32 mask = cpu_to_le32(~0U >> (sizeof_field(struct nft_cmp_fast_expr,
-					  data) * BITS_PER_BYTE - len));
-
-	return (__force u32)mask;
-}
-
-static int nft_cmp_fast_init(const struct nft_ctx *ctx,
-			     const struct nft_expr *expr,
-			     const struct nlattr * const tb[])
-{
-	struct nft_cmp_fast_expr *priv = nft_expr_priv(expr);
-	struct nft_data data;
-	struct nft_data_desc desc = {
-		.type	= NFT_DATA_VALUE,
-		.size	= sizeof(data),
-	};
-	int err;
-
-	err = nft_data_init(NULL, &data, &desc, tb[NFTA_CMP_DATA]);
-	if (err < 0)
-		return err;
-
-	err = nft_parse_register_load(tb[NFTA_CMP_SREG], &priv->sreg, desc.len);
-	if (err < 0)
-		return err;
-
-	desc.len *= BITS_PER_BYTE;
-
-	priv->mask = nft_cmp_fast_mask(desc.len);
-	priv->data = data.data[0] & priv->mask;
-	priv->len  = desc.len;
-	priv->inv  = ntohl(nla_get_be32(tb[NFTA_CMP_OP])) != NFT_CMP_EQ;
-	return 0;
-}
-
-static int nft_cmp_fast_offload(struct nft_offload_ctx *ctx,
-				struct nft_flow_rule *flow,
-				const struct nft_expr *expr)
-{
-	const struct nft_cmp_fast_expr *priv = nft_expr_priv(expr);
-	struct nft_cmp_expr cmp = {
-		.data	= {
-			.data	= {
-				[0] = priv->data,
-			},
-		},
-		.sreg	= priv->sreg,
-		.len	= priv->len / BITS_PER_BYTE,
-		.op	= priv->inv ? NFT_CMP_NEQ : NFT_CMP_EQ,
-	};
-
-	return __nft_cmp_offload(ctx, flow, &cmp);
-}
-
-static int nft_cmp_fast_dump(struct sk_buff *skb,
-			     const struct nft_expr *expr, bool reset)
-{
-	const struct nft_cmp_fast_expr *priv = nft_expr_priv(expr);
-	enum nft_cmp_ops op = priv->inv ? NFT_CMP_NEQ : NFT_CMP_EQ;
-	struct nft_data data;
-
-	if (nft_dump_register(skb, NFTA_CMP_SREG, priv->sreg))
-		goto nla_put_failure;
-	if (nla_put_be32(skb, NFTA_CMP_OP, htonl(op)))
-		goto nla_put_failure;
-
-	data.data[0] = priv->data;
-	if (nft_data_dump(skb, NFTA_CMP_DATA, &data,
-			  NFT_DATA_VALUE, priv->len / BITS_PER_BYTE) < 0)
-		goto nla_put_failure;
-	return 0;
-
-nla_put_failure:
-	return -1;
-}
-
-const struct nft_expr_ops nft_cmp_fast_ops = {
-	.type		= &nft_cmp_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_cmp_fast_expr)),
-	.eval		= NULL,	/* inlined */
-	.init		= nft_cmp_fast_init,
-	.dump		= nft_cmp_fast_dump,
-	.offload	= nft_cmp_fast_offload,
-};
-
-static u32 nft_cmp_mask(u32 bitlen)
-{
-	return (__force u32)cpu_to_le32(~0U >> (sizeof(u32) * BITS_PER_BYTE - bitlen));
-}
-
-static void nft_cmp16_fast_mask(struct nft_data *data, unsigned int bitlen)
-{
-	int len = bitlen / BITS_PER_BYTE;
-	int i, words = len / sizeof(u32);
-
-	for (i = 0; i < words; i++) {
-		data->data[i] = 0xffffffff;
-		bitlen -= sizeof(u32) * BITS_PER_BYTE;
-	}
-
-	if (len % sizeof(u32))
-		data->data[i++] = nft_cmp_mask(bitlen);
-
-	for (; i < 4; i++)
-		data->data[i] = 0;
-}
-
-static int nft_cmp16_fast_init(const struct nft_ctx *ctx,
-			       const struct nft_expr *expr,
-			       const struct nlattr * const tb[])
-{
-	struct nft_cmp16_fast_expr *priv = nft_expr_priv(expr);
-	struct nft_data_desc desc = {
-		.type	= NFT_DATA_VALUE,
-		.size	= sizeof(priv->data),
-	};
-	int err;
-
-	err = nft_data_init(NULL, &priv->data, &desc, tb[NFTA_CMP_DATA]);
-	if (err < 0)
-		return err;
-
-	err = nft_parse_register_load(tb[NFTA_CMP_SREG], &priv->sreg, desc.len);
-	if (err < 0)
-		return err;
-
-	nft_cmp16_fast_mask(&priv->mask, desc.len * BITS_PER_BYTE);
-	priv->inv = ntohl(nla_get_be32(tb[NFTA_CMP_OP])) != NFT_CMP_EQ;
-	priv->len = desc.len;
-
-	return 0;
-}
-
-static int nft_cmp16_fast_offload(struct nft_offload_ctx *ctx,
-				  struct nft_flow_rule *flow,
-				  const struct nft_expr *expr)
-{
-	const struct nft_cmp16_fast_expr *priv = nft_expr_priv(expr);
-	struct nft_cmp_expr cmp = {
-		.data	= priv->data,
-		.sreg	= priv->sreg,
-		.len	= priv->len,
-		.op	= priv->inv ? NFT_CMP_NEQ : NFT_CMP_EQ,
-	};
-
-	return __nft_cmp_offload(ctx, flow, &cmp);
-}
-
-static int nft_cmp16_fast_dump(struct sk_buff *skb,
-			       const struct nft_expr *expr, bool reset)
-{
-	const struct nft_cmp16_fast_expr *priv = nft_expr_priv(expr);
-	enum nft_cmp_ops op = priv->inv ? NFT_CMP_NEQ : NFT_CMP_EQ;
-
-	if (nft_dump_register(skb, NFTA_CMP_SREG, priv->sreg))
-		goto nla_put_failure;
-	if (nla_put_be32(skb, NFTA_CMP_OP, htonl(op)))
-		goto nla_put_failure;
-
-	if (nft_data_dump(skb, NFTA_CMP_DATA, &priv->data,
-			  NFT_DATA_VALUE, priv->len) < 0)
-		goto nla_put_failure;
-	return 0;
-
-nla_put_failure:
-	return -1;
-}
-
-
-const struct nft_expr_ops nft_cmp16_fast_ops = {
-	.type		= &nft_cmp_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_cmp16_fast_expr)),
-	.eval		= NULL,	/* inlined */
-	.init		= nft_cmp16_fast_init,
-	.dump		= nft_cmp16_fast_dump,
-	.offload	= nft_cmp16_fast_offload,
-};
-
 static const struct nft_expr_ops *
 nft_cmp_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
 {
@@ -413,14 +229,6 @@ nft_cmp_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
 
 	sreg = ntohl(nla_get_be32(tb[NFTA_CMP_SREG]));
 
-	if (op == NFT_CMP_EQ || op == NFT_CMP_NEQ) {
-		if (desc.len <= sizeof(u32))
-			return &nft_cmp_fast_ops;
-		else if (desc.len <= sizeof(data) &&
-			 ((sreg >= NFT_REG_1 && sreg <= NFT_REG_4) ||
-			  (sreg >= NFT_REG32_00 && sreg <= NFT_REG32_12 && sreg % 2 == 0)))
-			return &nft_cmp16_fast_ops;
-	}
 	return &nft_cmp_ops;
 }
 
-- 
2.30.2

