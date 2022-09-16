Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22105C54EE9
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Sep 2022 11:48:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbiIPLss (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Sep 2022 07:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbiIPLsn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Sep 2022 07:48:43 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E915FA9C04
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Sep 2022 04:48:39 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,RFC] src: add vxlan matching support
Date:   Fri, 16 Sep 2022 13:48:35 +0200
Message-Id: <20220916114835.32054-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use inner expression, currently supports for:

	... vxlan ip protocol udp
	... vxlan ip saddr 1.2.3.0/24

matching on transport is broken, eg.

	... vxlan tcp dport 22

for two reasons:

- Conflicting protocols being reported: proto_ctx logic needs to be
  maintained for both outer and inner packets.

- implicit dependencies also are still broken, so 'vxlan tcp dport 22'
  generates an implicit 'meta l4proto'. Hence, nft_inner kernel needs to
  be extended to support for meta.

This also works with concatenations and anonymous sets.

	... vxlan ip saddr . vxlan ip daddr { 1.2.3.4 . 4.3.2.1 }

You have to restrict vxlan matching to udp traffic, otherwise it
complains on missing transport protocol dependency, e.g.

	... udp dport 7777 vxlan ip daddr 1.2.3.4

The bytecode that is generated uses the inner expression:

 # nft --debug=netlink add rule x y udp dport 7777 vxlan ip saddr 1.2.3.4
 ip x y
  [ meta load l4proto => reg 1 ]
  [ cmp eq reg 1 0x00000011 ]
  [ payload load 2b @ transport header + 2 => reg 1 ]
  [ cmp eq reg 1 0x0000611e ]
  [ inner hdrsize 8 flags f type 1 nfproto 2 [ payload load 4b @ network header + 12 => reg 1 ] ]
  [ cmp eq reg 1 0x04030201 ]

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h                |  9 ++-
 include/inner.h                     |  7 +++
 include/linux/netfilter/nf_tables.h | 31 +++++++++-
 include/netlink.h                   |  2 +
 include/proto.h                     | 21 ++++++-
 src/Makefile.am                     |  1 +
 src/evaluate.c                      | 27 +++++++++
 src/expression.c                    |  2 +
 src/inner.c                         | 77 ++++++++++++++++++++++++
 src/netlink_delinearize.c           | 92 +++++++++++++++++++++++++++++
 src/netlink_linearize.c             | 54 ++++++++++++++++-
 src/parser_bison.y                  | 32 ++++++++++
 src/proto.c                         | 30 ++++++++++
 src/scanner.l                       |  3 +
 14 files changed, 382 insertions(+), 6 deletions(-)
 create mode 100644 include/inner.h
 create mode 100644 src/inner.c

diff --git a/include/expression.h b/include/expression.h
index 3f06a38ae2d3..9a2cd32a3167 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -77,8 +77,9 @@ enum expr_types {
 	EXPR_XFRM,
 	EXPR_SET_ELEM_CATCHALL,
 	EXPR_FLAGCMP,
+	EXPR_INNER,
 
-	EXPR_MAX = EXPR_FLAGCMP
+	EXPR_MAX = EXPR_INNER
 };
 
 enum ops {
@@ -213,6 +214,7 @@ enum expr_flags {
 #include <payload.h>
 #include <exthdr.h>
 #include <fib.h>
+#include <inner.h>
 #include <numgen.h>
 #include <meta.h>
 #include <rt.h>
@@ -321,6 +323,11 @@ struct expr {
 			bool				is_raw;
 			bool				evaluated;
 		} payload;
+		struct {
+			/* EXPR_INNER */
+			const struct proto_desc		*desc;
+			struct expr			*expr;
+		} inner;
 		struct {
 			/* EXPR_EXTHDR */
 			const struct exthdr_desc	*desc;
diff --git a/include/inner.h b/include/inner.h
new file mode 100644
index 000000000000..69452a53c810
--- /dev/null
+++ b/include/inner.h
@@ -0,0 +1,7 @@
+#ifndef _INNER_H_
+#define _INNER_H_
+
+struct expr *inner_expr_alloc(const struct location *loc, struct expr *expr,
+			      const struct proto_desc *desc);
+
+#endif
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 466fd3f4447c..99cb5536d2aa 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -760,6 +760,7 @@ enum nft_payload_bases {
 	NFT_PAYLOAD_NETWORK_HEADER,
 	NFT_PAYLOAD_TRANSPORT_HEADER,
 	NFT_PAYLOAD_INNER_HEADER,
+	NFT_PAYLOAD_TUN_HEADER,
 };
 
 /**
@@ -779,6 +780,32 @@ enum nft_payload_csum_flags {
 	NFT_PAYLOAD_L4CSUM_PSEUDOHDR = (1 << 0),
 };
 
+enum nft_inner_type {
+	NFT_INNER_UNSPEC	= 0,
+	NFT_INNER_VXLAN,
+};
+
+enum nft_inner_flags {
+	NFT_INNER_HDRSIZE	= (1 << 0),
+	NFT_INNER_LL		= (1 << 1),
+	NFT_INNER_NH		= (1 << 2),
+	NFT_INNER_TH		= (1 << 3),
+};
+#define NFT_INNER_MASK		(NFT_INNER_HDRSIZE | NFT_INNER_LL | \
+				 NFT_INNER_NH | NFT_INNER_TH)
+
+enum nft_inner_attributes {
+	NFTA_INNER_UNSPEC,
+	NFTA_INNER_NUM,
+	NFTA_INNER_TYPE,
+	NFTA_INNER_FLAGS,
+	NFTA_INNER_HDRSIZE,
+	NFTA_INNER_NFPROTO,
+	NFTA_INNER_EXPR,
+	__NFTA_INNER_MAX
+};
+#define NFTA_INNER_MAX	(__NFTA_INNER_MAX - 1)
+
 /**
  * enum nft_payload_attributes - nf_tables payload expression netlink attributes
  *
@@ -790,6 +817,7 @@ enum nft_payload_csum_flags {
  * @NFTA_PAYLOAD_CSUM_TYPE: checksum type (NLA_U32)
  * @NFTA_PAYLOAD_CSUM_OFFSET: checksum offset relative to base (NLA_U32)
  * @NFTA_PAYLOAD_CSUM_FLAGS: checksum flags (NLA_U32)
+ * @NFTA_PAYLOAD_FLAGS: flags (NLA_U32)
  */
 enum nft_payload_attributes {
 	NFTA_PAYLOAD_UNSPEC,
@@ -800,7 +828,8 @@ enum nft_payload_attributes {
 	NFTA_PAYLOAD_SREG,
 	NFTA_PAYLOAD_CSUM_TYPE,
 	NFTA_PAYLOAD_CSUM_OFFSET,
-	NFTA_PAYLOAD_CSUM_FLAGS,
+	NFTA_PAYLOAD_FLAGS,
+#define NFTA_PAYLOAD_CSUM_FLAGS	NFTA_PAYLOAD_FLAGS
 	__NFTA_PAYLOAD_MAX
 };
 #define NFTA_PAYLOAD_MAX	(__NFTA_PAYLOAD_MAX - 1)
diff --git a/include/netlink.h b/include/netlink.h
index 63d07edf419e..453a5a22e585 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -40,6 +40,8 @@ struct netlink_parse_ctx {
 	struct expr		*registers[MAX_REGS + 1];
 	unsigned int		debug_mask;
 	struct netlink_ctx	*nlctx;
+	bool			inner;
+	uint8_t			inner_reg;
 };
 
 
diff --git a/include/proto.h b/include/proto.h
index 35e760c7e16e..472c763bcba7 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -96,6 +96,7 @@ enum proto_desc_id {
 	PROTO_DESC_ARP,
 	PROTO_DESC_VLAN,
 	PROTO_DESC_ETHER,
+	PROTO_DESC_VXLAN,
 	__PROTO_DESC_MAX
 };
 #define PROTO_DESC_MAX	(__PROTO_DESC_MAX - 1)
@@ -131,7 +132,11 @@ struct proto_desc {
 		uint32_t			filter;
 	}				format;
 	unsigned int			pseudohdr[PROTO_HDRS_MAX];
-
+	struct {
+		uint32_t		hdrsize;
+		uint32_t		flags;
+		enum nft_inner_type	type;
+	} inner;
 };
 
 #define PROTO_LINK(__num, __desc)	{ .num = (__num), .desc = (__desc), }
@@ -263,6 +268,7 @@ enum ip_hdr_fields {
 	IPHDR_SADDR,
 	IPHDR_DADDR,
 };
+#define IPHDR_MAX	IPHDR_DADDR
 
 enum icmp_hdr_fields {
 	ICMPHDR_INVALID,
@@ -376,6 +382,19 @@ enum th_hdr_fields {
 	THDR_DPORT,
 };
 
+struct vxlanhdr {
+	uint32_t vx_flags;
+	uint32_t vx_vni;
+};
+
+enum vxlan_hdr_fields {
+	VXLANHDR_INVALID,
+	VXLANHDR_VNI,
+	VXLANHDR_FLAGS,
+};
+
+extern const struct proto_desc proto_vxlan;
+
 extern const struct proto_desc proto_icmp;
 extern const struct proto_desc proto_igmp;
 extern const struct proto_desc proto_ah;
diff --git a/src/Makefile.am b/src/Makefile.am
index 264d981e20c7..8e2585323da6 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -49,6 +49,7 @@ libnftables_la_SOURCES =			\
 		fib.c				\
 		hash.c				\
 		intervals.c			\
+		inner.c				\
 		ipopt.c				\
 		meta.c				\
 		rt.c				\
diff --git a/src/evaluate.c b/src/evaluate.c
index d9c9ca28a53a..f206c6f0fe26 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2385,6 +2385,31 @@ static int expr_evaluate_flagcmp(struct eval_ctx *ctx, struct expr **exprp)
 	return expr_evaluate(ctx, exprp);
 }
 
+static int expr_evaluate_inner(struct eval_ctx *ctx, struct expr **exprp)
+{
+	const struct proto_desc *desc;
+	struct expr *expr = *exprp;
+
+	assert(expr->inner.desc->base == PROTO_BASE_INNER_HDR);
+
+	desc = ctx->pctx.protocol[expr->inner.desc->base - 1].desc;
+	if (!desc) {
+		return expr_error(ctx->msgs, expr,
+				  "no transport protocol specified");
+	}
+
+	if (proto_find_num(desc, expr->inner.desc) < 0) {
+		return expr_error(ctx->msgs, expr,
+				  "unexpected transport protocol %s",
+				  desc->name);
+	}
+
+	proto_ctx_update(&ctx->pctx, PROTO_BASE_INNER_HDR, &expr->location,
+			 expr->inner.desc);
+
+	return expr_evaluate(ctx, &expr->inner.expr);
+}
+
 static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 {
 	if (ctx->nft->debug_mask & NFT_DEBUG_EVALUATION) {
@@ -2456,6 +2481,8 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 		return 0;
 	case EXPR_FLAGCMP:
 		return expr_evaluate_flagcmp(ctx, expr);
+	case EXPR_INNER:
+		return expr_evaluate_inner(ctx, expr);
 	default:
 		BUG("unknown expression type %s\n", expr_name(*expr));
 	}
diff --git a/src/expression.c b/src/expression.c
index 7390089cf57d..80faeb94272c 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -29,6 +29,7 @@
 extern const struct expr_ops ct_expr_ops;
 extern const struct expr_ops fib_expr_ops;
 extern const struct expr_ops hash_expr_ops;
+extern const struct expr_ops inner_expr_ops;
 extern const struct expr_ops meta_expr_ops;
 extern const struct expr_ops numgen_expr_ops;
 extern const struct expr_ops osf_expr_ops;
@@ -1529,6 +1530,7 @@ static const struct expr_ops *__expr_ops_by_type(enum expr_types etype)
 	case EXPR_XFRM: return &xfrm_expr_ops;
 	case EXPR_SET_ELEM_CATCHALL: return &set_elem_catchall_expr_ops;
 	case EXPR_FLAGCMP: return &flagcmp_expr_ops;
+	case EXPR_INNER: return &inner_expr_ops;
 	}
 
 	BUG("Unknown expression type %d\n", etype);
diff --git a/src/inner.c b/src/inner.c
new file mode 100644
index 000000000000..78aa16ad60d3
--- /dev/null
+++ b/src/inner.c
@@ -0,0 +1,77 @@
+/*
+ * Copyright (c) 2022 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
+ */
+
+/* Funded through the NGI0 PET Fund established by NLnet (https://nlnet.nl)
+ * with support from the European Commission's Next Generation Internet
+ * programme.
+ */
+
+#include <nftables.h>
+#include <expression.h>
+#include <utils.h>
+#include <inner.h>
+
+static void inner_expr_print(const struct expr *expr, struct output_ctx *octx)
+{
+	if (expr->inner.expr->etype == EXPR_PAYLOAD &&
+	    expr->inner.expr->payload.base != PROTO_BASE_INNER_HDR)
+		nft_print(octx, "%s ", expr->inner.desc->name);
+
+	expr_print(expr->inner.expr, octx);
+}
+
+static void inner_expr_clone(struct expr *new, const struct expr *expr)
+{
+	new->inner.expr = expr_clone(expr->inner.expr);
+	new->inner.desc = expr->inner.desc;
+}
+
+static bool inner_expr_cmp(const struct expr *e1, const struct expr *e2)
+{
+	return expr_cmp(e1->inner.expr, e2->inner.expr) &&
+	       e1->inner.desc == e2->inner.desc;
+}
+
+static int inner_expr_build_udata(struct nftnl_udata_buf *udbuf,
+				  const struct expr *expr)
+{
+	return 0;
+}
+
+static struct expr *inner_expr_parse_udata(const struct nftnl_udata *attr)
+{
+	return inner_expr_alloc(&internal_location, NULL, NULL);
+}
+
+static void inner_expr_destroy(struct expr *expr)
+{
+	expr_free(expr->inner.expr);
+}
+
+const struct expr_ops inner_expr_ops = {
+	.type		= EXPR_INNER,
+	.name		= "inner",
+	.print		= inner_expr_print,
+	.destroy	= inner_expr_destroy,
+	.clone		= inner_expr_clone,
+	.cmp		= inner_expr_cmp,
+	.parse_udata	= inner_expr_parse_udata,
+	.build_udata	= inner_expr_build_udata,
+};
+
+struct expr *inner_expr_alloc(const struct location *loc, struct expr *expr,
+			      const struct proto_desc *desc)
+{
+	struct expr *inner;
+
+	inner = expr_alloc(loc, EXPR_INNER, expr->dtype, expr->byteorder, expr->len);
+	inner->inner.desc = desc;
+	inner->inner.expr = expr;
+
+	return inner;
+}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 0da6cc78f94f..58cbdfbe1914 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -613,6 +613,10 @@ static void netlink_parse_payload_expr(struct netlink_parse_ctx *ctx,
 	struct expr *expr;
 
 	base   = nftnl_expr_get_u32(nle, NFTNL_EXPR_PAYLOAD_BASE) + 1;
+
+	if (base == NFT_PAYLOAD_TUN_HEADER + 1)
+		base = NFT_PAYLOAD_INNER_HEADER + 1;
+
 	offset = nftnl_expr_get_u32(nle, NFTNL_EXPR_PAYLOAD_OFFSET) * BITS_PER_BYTE;
 	len    = nftnl_expr_get_u32(nle, NFTNL_EXPR_PAYLOAD_LEN) * BITS_PER_BYTE;
 
@@ -620,9 +624,68 @@ static void netlink_parse_payload_expr(struct netlink_parse_ctx *ctx,
 	payload_init_raw(expr, base, offset, len);
 
 	dreg = netlink_parse_register(nle, NFTNL_EXPR_PAYLOAD_DREG);
+
+	if (ctx->inner)
+		ctx->inner_reg = dreg;
+
 	netlink_set_register(ctx, dreg, expr);
 }
 
+static void netlink_parse_inner(struct netlink_parse_ctx *ctx,
+				const struct location *loc,
+				const struct nftnl_expr *nle)
+{
+	uint32_t hdrsize, flags, type, nfproto;
+	const struct nftnl_expr *inner_nle;
+	struct expr *expr, *inner;
+
+	hdrsize = nftnl_expr_get_u32(nle, NFTNL_EXPR_INNER_HDRSIZE);
+	type    = nftnl_expr_get_u32(nle, NFTNL_EXPR_INNER_TYPE);
+	flags   = nftnl_expr_get_u32(nle, NFTNL_EXPR_INNER_FLAGS);
+	nfproto = nftnl_expr_get_u32(nle, NFTNL_EXPR_INNER_NFPROTO);
+
+	inner_nle = nftnl_expr_get(nle, NFTNL_EXPR_INNER_EXPR, NULL);
+	if (!inner_nle) {
+		netlink_error(ctx, loc, "Could not parse inner expression");
+		return;
+	}
+
+	ctx->inner = true;
+	if (netlink_parse_expr(inner_nle, ctx) < 0)
+		return;
+
+	ctx->inner = false;
+
+	expr = netlink_get_register(ctx, loc, ctx->inner_reg);
+	assert(expr);
+
+	if (expr->payload.base == PROTO_BASE_INNER_HDR) {
+		const struct proto_hdr_template *tmpl;
+		const struct proto_desc *desc;
+		int i;
+
+		desc = &proto_vxlan;
+
+		for (i = 1; i < array_size(desc->templates); i++) {
+			tmpl = &desc->templates[i];
+
+			if (tmpl->len == 0)
+				return;
+
+			if (tmpl->offset != expr->payload.offset ||
+			    tmpl->len != expr->len)
+				continue;
+
+			expr->payload.desc = desc;
+			expr->payload.tmpl = tmpl;
+			break;
+		}
+	}
+
+	inner = inner_expr_alloc(loc, expr, &proto_vxlan);
+	netlink_set_register(ctx, ctx->inner_reg, inner);
+}
+
 static void netlink_parse_payload_stmt(struct netlink_parse_ctx *ctx,
 				       const struct location *loc,
 				       const struct nftnl_expr *nle)
@@ -1772,6 +1835,7 @@ static const struct expr_handler netlink_parsers[] = {
 	{ .name = "bitwise",	.parse = netlink_parse_bitwise },
 	{ .name = "byteorder",	.parse = netlink_parse_byteorder },
 	{ .name = "payload",	.parse = netlink_parse_payload },
+	{ .name = "inner",	.parse = netlink_parse_inner },
 	{ .name = "exthdr",	.parse = netlink_parse_exthdr },
 	{ .name = "meta",	.parse = netlink_parse_meta },
 	{ .name = "socket",	.parse = netlink_parse_socket },
@@ -1904,6 +1968,24 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 		assert(left->payload.base);
 		assert(base == left->payload.base);
 
+		if (expr->left->etype == EXPR_INNER) {
+			const struct proto_desc *desc;
+			const struct proto_hdr_template *tmpl;
+			const struct expr *inner;
+
+			nexpr->left = expr_get(expr->left);
+			inner = expr->left->inner.expr;
+			desc = inner->payload.desc;
+			tmpl = inner->payload.tmpl;
+			if (left->payload.base == PROTO_BASE_INNER_HDR) {
+				left->payload.desc = desc;
+				left->payload.tmpl = tmpl;
+				expr_set_type(left, inner->dtype, inner->byteorder);
+			}
+			expr_free(nexpr->left->inner.expr);
+			nexpr->left->inner.expr = left;
+		}
+
 		if (payload_is_stacked(ctx->pctx.protocol[base].desc, nexpr))
 			base--;
 
@@ -2612,6 +2694,12 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		switch (expr->left->etype) {
 		case EXPR_PAYLOAD:
 			payload_match_postprocess(ctx, expr, expr->left);
+			return;
+		case EXPR_INNER:
+			expr_postprocess(ctx, &expr->left);
+			if (expr->left->inner.expr->etype == EXPR_PAYLOAD)
+				payload_match_postprocess(ctx, expr, expr->left->inner.expr);
+
 			return;
 		default:
 			expr_postprocess(ctx, &expr->left);
@@ -2685,6 +2773,10 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 	case EXPR_CT:
 		ct_expr_update_type(&ctx->pctx, expr);
 		break;
+	case EXPR_INNER:
+		expr_postprocess(ctx, &expr->inner.expr);
+		expr_set_type(expr, expr->inner.expr->dtype, expr->inner.expr->byteorder);
+		break;
 	default:
 		BUG("unknown expression type %s\n", expr_name(expr));
 	}
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index c8bbcb7452b0..f829a926dfbe 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -178,9 +178,8 @@ static void netlink_gen_hash(struct netlink_linearize_ctx *ctx,
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
-static void netlink_gen_payload(struct netlink_linearize_ctx *ctx,
-				const struct expr *expr,
-				enum nft_registers dreg)
+static struct nftnl_expr *
+__netlink_gen_payload(const struct expr *expr, enum nft_registers dreg)
 {
 	struct nftnl_expr *nle;
 
@@ -193,6 +192,53 @@ static void netlink_gen_payload(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_PAYLOAD_LEN,
 			   div_round_up(expr->len, BITS_PER_BYTE));
 
+	return nle;
+}
+
+static void netlink_gen_payload(struct netlink_linearize_ctx *ctx,
+				const struct expr *expr,
+				enum nft_registers dreg)
+{
+	struct nftnl_expr *nle;
+
+	nle = __netlink_gen_payload(expr, dreg);
+	nft_rule_add_expr(ctx, nle, &expr->location);
+}
+
+static struct nftnl_expr *netlink_gen_inner_expr(const struct expr *expr,
+						 enum nft_registers dreg)
+{
+	struct nftnl_expr *nle;
+
+	switch (expr->inner.expr->etype) {
+	case EXPR_PAYLOAD:
+		if (expr->inner.expr->payload.base == NFT_PAYLOAD_INNER_HEADER + 1)
+			expr->inner.expr->payload.base = NFT_PAYLOAD_TUN_HEADER + 1;
+
+		expr->inner.expr->len = expr->len;
+		nle = __netlink_gen_payload(expr->inner.expr, dreg);
+		break;
+	default:
+		assert(0);
+		break;
+	}
+
+	return nle;
+}
+
+static void netlink_gen_inner(struct netlink_linearize_ctx *ctx,
+			      const struct expr *expr,
+			      enum nft_registers dreg)
+{
+	const struct proto_desc *desc = expr->inner.desc;
+	struct nftnl_expr *nle;
+
+	nle = alloc_nft_expr("inner");
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_INNER_HDRSIZE, desc->inner.hdrsize);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_INNER_FLAGS, desc->inner.flags);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_INNER_TYPE, desc->inner.type);
+	nftnl_expr_set(nle, NFTNL_EXPR_INNER_EXPR, netlink_gen_inner_expr(expr, dreg), 0);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_INNER_NFPROTO, NFPROTO_IPV4);
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
@@ -836,6 +882,8 @@ static void netlink_gen_expr(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_osf(ctx, expr, dreg);
 	case EXPR_XFRM:
 		return netlink_gen_xfrm(ctx, expr, dreg);
+	case EXPR_INNER:
+		return netlink_gen_inner(ctx, expr, dreg);
 	default:
 		BUG("unknown expression type %s\n", expr_name(expr));
 	}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 0266819a779b..174db883db02 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -428,6 +428,9 @@ int nft_lex(void *, void *, void *);
 
 %token DCCP			"dccp"
 
+%token VXLAN			"vxlan"
+%token VNI			"vni"
+
 %token SCTP			"sctp"
 %token CHUNK			"chunk"
 %token DATA			"data"
@@ -886,6 +889,10 @@ int nft_lex(void *, void *, void *);
 %type <val>			tcpopt_field_maxseg	tcpopt_field_mptcp	tcpopt_field_sack	 tcpopt_field_tsopt	tcpopt_field_window
 %type <tcp_kind_field>		tcp_hdr_option_kind_and_field
 
+%type <expr>			inner_expr vxlan_hdr_expr
+%destructor { expr_free($$); }	inner_expr vxlan_hdr_expr
+%type <val>			vxlan_hdr_field
+
 %type <stmt>			optstrip_stmt
 %destructor { stmt_free($$); }	optstrip_stmt
 
@@ -5292,6 +5299,7 @@ payload_expr		:	payload_raw_expr
 			|	dccp_hdr_expr
 			|	sctp_hdr_expr
 			|	th_hdr_expr
+			|	vxlan_hdr_expr
 			;
 
 payload_raw_expr	:	AT	payload_base_spec	COMMA	NUM	COMMA	NUM	close_scope_at
@@ -5543,6 +5551,30 @@ tcp_hdr_expr		:	TCP	tcp_hdr_field
 			}
 			;
 
+inner_expr		:	eth_hdr_expr	{ $$ = $1; }
+			|	ip_hdr_expr	{ $$ = $1; }
+			|	ip6_hdr_expr	{ $$ = $1; }
+			|	udp_hdr_expr	{ $$ = $1; }
+			|	tcp_hdr_expr	{ $$ = $1; }
+			;
+
+vxlan_hdr_expr		:	VXLAN	vxlan_hdr_field
+			{
+				struct expr *expr;
+
+				expr = payload_expr_alloc(&@$, &proto_vxlan, $2);
+				$$ = inner_expr_alloc(&@$, expr, &proto_vxlan);
+			}
+			|	VXLAN	inner_expr
+			{
+				$$ = inner_expr_alloc(&@$, $2, &proto_vxlan);
+			}
+			;
+
+vxlan_hdr_field		:	VNI			{ $$ = VXLANHDR_VNI; }
+			|	FLAGS			{ $$ = VXLANHDR_FLAGS; }
+			;
+
 optstrip_stmt		:	RESET	TCP	OPTION	tcp_hdr_option_type	close_scope_tcp
 			{
 				$$ = optstrip_stmt_alloc(&@$, tcpopt_expr_alloc(&@$,
diff --git a/src/proto.c b/src/proto.c
index c8b3361bbee6..678826b53623 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -228,6 +228,8 @@ void proto_ctx_update(struct proto_ctx *ctx, enum proto_bases base,
 			ctx->protocol[base].protos[i].location = *loc;
 		}
 		break;
+	case PROTO_BASE_INNER_HDR:
+		break;
 	default:
 		BUG("unknown protocol base %d", base);
 	}
@@ -513,6 +515,9 @@ const struct proto_desc proto_udp = {
 		[UDPHDR_LENGTH]		= UDPHDR_FIELD("length", len),
 		[UDPHDR_CHECKSUM]	= UDPHDR_FIELD("checksum", check),
 	},
+	.protocols	= {
+		PROTO_LINK(0,	&proto_vxlan),
+	},
 };
 
 const struct proto_desc proto_udplite = {
@@ -1135,6 +1140,31 @@ const struct proto_desc proto_eth = {
 
 };
 
+/*
+ * VXLAN
+ */
+
+const struct proto_desc proto_vxlan = {
+	.name		= "vxlan",
+	.id		= PROTO_DESC_VXLAN,
+	.base		= PROTO_BASE_INNER_HDR,
+	.templates	= {
+		[VXLANHDR_VNI]		= HDR_FIELD("vni", struct vxlanhdr, vx_vni),
+	},
+	.protocols	= {
+		PROTO_LINK(__constant_htons(ETH_P_IP),		&proto_ip),
+		PROTO_LINK(__constant_htons(ETH_P_ARP),		&proto_arp),
+		PROTO_LINK(__constant_htons(ETH_P_IPV6),	&proto_ip6),
+		PROTO_LINK(__constant_htons(ETH_P_8021Q),	&proto_vlan),
+		PROTO_LINK(__constant_htons(ETH_P_8021AD),	&proto_vlan),
+	},
+	.inner		= {
+		.hdrsize	= sizeof(struct vxlanhdr),
+		.flags		= NFT_INNER_HDRSIZE | NFT_INNER_LL | NFT_INNER_NH | NFT_INNER_TH,
+		.type		= NFT_INNER_VXLAN,
+	},
+};
+
 /*
  * Dummy protocol for netdev tables.
  */
diff --git a/src/scanner.l b/src/scanner.l
index 1371cd044b65..289b4d078855 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -620,6 +620,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"dport"			{ return DPORT; }
 }
 
+"vxlan"			{ return VXLAN; }
+"vni"			{ return VNI; }
+
 "tcp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_TCP); return TCP; }
 
 "dccp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_DCCP); return DCCP; }
-- 
2.30.2

