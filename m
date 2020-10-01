Return-Path: <SRS0=AsZf=DI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E38D9C4727E
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Oct 2020 16:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B44AA2072E
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Oct 2020 16:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732208AbgJAQkL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Oct 2020 12:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731917AbgJAQkL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Oct 2020 12:40:11 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DF4C0613D0
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Oct 2020 09:40:11 -0700 (PDT)
Received: from localhost ([::1]:48008 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kO1cn-0004NY-Sz; Thu, 01 Oct 2020 18:40:09 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [net-next PATCH 2/2] net: netfilter: Implement fast bitwise expression
Date:   Thu,  1 Oct 2020 18:57:44 +0200
Message-Id: <20201001165744.25466-3-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001165744.25466-1-phil@nwl.cc>
References: <20201001165744.25466-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A typical use of bitwise expression is to mask out parts of an IP
address when matching on the network part only. Optimize for this common
use with a fast variant for NFT_BITWISE_BOOL-type expressions operating
on 32bit-sized values.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netfilter/nf_tables_core.h |   9 ++
 net/netfilter/nf_tables_core.c         |  12 +++
 net/netfilter/nft_bitwise.c            | 141 +++++++++++++++++++++++--
 3 files changed, 156 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index df2d91c814cb3..8657e6815b07c 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -23,6 +23,13 @@ extern struct nft_object_type nft_secmark_obj_type;
 int nf_tables_core_module_init(void);
 void nf_tables_core_module_exit(void);
 
+struct nft_bitwise_fast_expr {
+	u32			mask;
+	u32			xor;
+	enum nft_registers	sreg:8;
+	enum nft_registers	dreg:8;
+};
+
 struct nft_cmp_fast_expr {
 	u32			data;
 	u32			mask;
@@ -68,6 +75,8 @@ struct nft_payload_set {
 
 extern const struct nft_expr_ops nft_payload_fast_ops;
 
+extern const struct nft_expr_ops nft_bitwise_fast_ops;
+
 extern struct static_key_false nft_counters_enabled;
 extern struct static_key_false nft_trace_enabled;
 
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index e92feacaf5516..dbc2e945c98eb 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -47,6 +47,16 @@ static inline void nft_trace_packet(struct nft_traceinfo *info,
 	}
 }
 
+static void nft_bitwise_fast_eval(const struct nft_expr *expr,
+				  struct nft_regs *regs)
+{
+	const struct nft_bitwise_fast_expr *priv = nft_expr_priv(expr);
+	u32 *src = &regs->data[priv->sreg];
+	u32 *dst = &regs->data[priv->dreg];
+
+	*dst = (*src & priv->mask) ^ priv->xor;
+}
+
 static void nft_cmp_fast_eval(const struct nft_expr *expr,
 			      struct nft_regs *regs)
 {
@@ -175,6 +185,8 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		nft_rule_for_each_expr(expr, last, rule) {
 			if (expr->ops == &nft_cmp_fast_ops)
 				nft_cmp_fast_eval(expr, &regs);
+			else if (expr->ops == &nft_bitwise_fast_ops)
+				nft_bitwise_fast_eval(expr, &regs);
 			else if (expr->ops != &nft_payload_fast_ops ||
 				 !nft_payload_fast_eval(expr, &regs, pkt))
 				expr_call_ops_eval(expr, &regs, pkt);
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index bc37d6c59db45..bbd773d743773 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -163,11 +163,6 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	u32 len;
 	int err;
 
-	if (!tb[NFTA_BITWISE_SREG] ||
-	    !tb[NFTA_BITWISE_DREG] ||
-	    !tb[NFTA_BITWISE_LEN])
-		return -EINVAL;
-
 	err = nft_parse_u32_check(tb[NFTA_BITWISE_LEN], U8_MAX, &len);
 	if (err < 0)
 		return err;
@@ -292,9 +287,143 @@ static const struct nft_expr_ops nft_bitwise_ops = {
 	.offload	= nft_bitwise_offload,
 };
 
+static int
+nft_bitwise_extract_u32_data(const struct nlattr * const tb, u32 *out)
+{
+	struct nft_data_desc desc;
+	struct nft_data data;
+	int err = 0;
+
+	err = nft_data_init(NULL, &data, sizeof(data), &desc, tb);
+	if (err < 0)
+		return err;
+
+	if (desc.type != NFT_DATA_VALUE || desc.len != sizeof(u32)) {
+		err = -EINVAL;
+		goto err;
+	}
+	*out = data.data[0];
+err:
+	nft_data_release(&data, desc.type);
+	return err;
+}
+
+static int nft_bitwise_fast_init(const struct nft_ctx *ctx,
+				 const struct nft_expr *expr,
+				 const struct nlattr * const tb[])
+{
+	struct nft_bitwise_fast_expr *priv = nft_expr_priv(expr);
+	int err;
+
+	priv->sreg = nft_parse_register(tb[NFTA_BITWISE_SREG]);
+	err = nft_validate_register_load(priv->sreg, sizeof(u32));
+	if (err < 0)
+		return err;
+
+	priv->dreg = nft_parse_register(tb[NFTA_BITWISE_DREG]);
+	err = nft_validate_register_store(ctx, priv->dreg, NULL,
+					  NFT_DATA_VALUE, sizeof(u32));
+	if (err < 0)
+		return err;
+
+	if (tb[NFTA_BITWISE_DATA])
+		return -EINVAL;
+
+	if (!tb[NFTA_BITWISE_MASK] ||
+	    !tb[NFTA_BITWISE_XOR])
+		return -EINVAL;
+
+	err = nft_bitwise_extract_u32_data(tb[NFTA_BITWISE_MASK], &priv->mask);
+	if (err < 0)
+		return err;
+
+	err = nft_bitwise_extract_u32_data(tb[NFTA_BITWISE_XOR], &priv->xor);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+static int
+nft_bitwise_fast_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_bitwise_fast_expr *priv = nft_expr_priv(expr);
+	struct nft_data data;
+
+	if (nft_dump_register(skb, NFTA_BITWISE_SREG, priv->sreg))
+		return -1;
+	if (nft_dump_register(skb, NFTA_BITWISE_DREG, priv->dreg))
+		return -1;
+	if (nla_put_be32(skb, NFTA_BITWISE_LEN, htonl(sizeof(u32))))
+		return -1;
+	if (nla_put_be32(skb, NFTA_BITWISE_OP, htonl(NFT_BITWISE_BOOL)))
+		return -1;
+
+	data.data[0] = priv->mask;
+	if (nft_data_dump(skb, NFTA_BITWISE_MASK, &data,
+			  NFT_DATA_VALUE, sizeof(u32)) < 0)
+		return -1;
+
+	data.data[0] = priv->xor;
+	if (nft_data_dump(skb, NFTA_BITWISE_XOR, &data,
+			  NFT_DATA_VALUE, sizeof(u32)) < 0)
+		return -1;
+
+	return 0;
+}
+
+static int nft_bitwise_fast_offload(struct nft_offload_ctx *ctx,
+				    struct nft_flow_rule *flow,
+				    const struct nft_expr *expr)
+{
+	const struct nft_bitwise_fast_expr *priv = nft_expr_priv(expr);
+	struct nft_offload_reg *reg = &ctx->regs[priv->dreg];
+
+	if (priv->xor || priv->sreg != priv->dreg || reg->len != sizeof(u32))
+		return -EOPNOTSUPP;
+
+	reg->mask.data[0] = priv->mask;
+	return 0;
+}
+
+const struct nft_expr_ops nft_bitwise_fast_ops = {
+	.type		= &nft_bitwise_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_bitwise_fast_expr)),
+	.eval		= NULL, /* inlined */
+	.init		= nft_bitwise_fast_init,
+	.dump		= nft_bitwise_fast_dump,
+	.offload	= nft_bitwise_fast_offload,
+};
+
+static const struct nft_expr_ops *
+nft_bitwise_select_ops(const struct nft_ctx *ctx,
+		       const struct nlattr * const tb[])
+{
+	int err;
+	u32 len;
+
+	if (!tb[NFTA_BITWISE_LEN] ||
+	    !tb[NFTA_BITWISE_SREG] ||
+	    !tb[NFTA_BITWISE_DREG])
+		return ERR_PTR(-EINVAL);
+
+	err = nft_parse_u32_check(tb[NFTA_BITWISE_LEN], U8_MAX, &len);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	if (len != sizeof(u32))
+		return &nft_bitwise_ops;
+
+	if (tb[NFTA_BITWISE_OP] &&
+	    ntohl(nla_get_be32(tb[NFTA_BITWISE_OP])) != NFT_BITWISE_BOOL)
+		return &nft_bitwise_ops;
+
+	return &nft_bitwise_fast_ops;
+}
+
 struct nft_expr_type nft_bitwise_type __read_mostly = {
 	.name		= "bitwise",
-	.ops		= &nft_bitwise_ops,
+	.select_ops	= nft_bitwise_select_ops,
 	.policy		= nft_bitwise_policy,
 	.maxattr	= NFTA_BITWISE_MAX,
 	.owner		= THIS_MODULE,
-- 
2.28.0

