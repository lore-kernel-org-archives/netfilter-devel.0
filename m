Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EEF1C43217
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Sep 2022 13:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiI3NDA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Sep 2022 09:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiI3NC6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Sep 2022 09:02:58 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6BDF3176AC8
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Sep 2022 06:02:55 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/6] src: add vxlan matching support
Date:   Fri, 30 Sep 2022 15:02:45 +0200
Message-Id: <20220930130248.416386-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220930130248.416386-1-pablo@netfilter.org>
References: <20220930130248.416386-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds the initial infrastructure to support for inner header
tunnel matching and its first user: vxlan.

A new struct proto_desc field for payload and meta expression to specify
that the expression refers to inner header matching is used.

The existing codebase to generate bytecode is fully reused, allowing for
reusing existing supported layer 2, 3 and 4 protocols.

Syntax requires to specify vxlan before the inner protocol field:

	... vxlan ip protocol udp
	... vxlan ip saddr 1.2.3.0/24

This also works with concatenations and anonymous sets, eg.

	... vxlan ip saddr . vxlan ip daddr { 1.2.3.4 . 4.3.2.1 }

You have to restrict vxlan matching to udp traffic, otherwise it
complains on missing transport protocol dependency, e.g.

	... udp dport 4789 vxlan ip daddr 1.2.3.4

The bytecode that is generated uses the new inner expression:

 # nft --debug=netlink add rule netdev x y udp dport 4789 vxlan ip saddr 1.2.3.4
 netdev x y
  [ meta load l4proto => reg 1 ]
  [ cmp eq reg 1 0x00000011 ]
  [ payload load 2b @ transport header + 2 => reg 1 ]
  [ cmp eq reg 1 0x0000b512 ]
  [ inner type 1 hdrsize 8 flags f [ meta load protocol => reg 1 ] ]
  [ cmp eq reg 1 0x00000008 ]
  [ inner type 1 hdrsize 8 flags f [ payload load 4b @ network header + 12 => reg 1 ] ]
  [ cmp eq reg 1 0x04030201 ]

JSON support is not included in this patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h                |   2 +
 include/linux/netfilter/nf_tables.h |  26 +++++
 include/netlink.h                   |   5 +-
 include/payload.h                   |   2 +
 include/proto.h                     |  23 ++++-
 include/rule.h                      |   3 +-
 src/evaluate.c                      |  81 +++++++++++++--
 src/expression.c                    |   1 +
 src/meta.c                          |  21 +++-
 src/netlink_delinearize.c           | 155 ++++++++++++++++++++++++++--
 src/netlink_linearize.c             |  80 ++++++++++++--
 src/parser_bison.y                  |  53 ++++++++++
 src/payload.c                       |  37 ++++++-
 src/proto.c                         |  52 ++++++++++
 src/rule.c                          |   3 +-
 src/scanner.l                       |   3 +
 16 files changed, 519 insertions(+), 28 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 3f06a38ae2d3..1f58a68c329f 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -316,6 +316,7 @@ struct expr {
 			/* EXPR_PAYLOAD */
 			const struct proto_desc		*desc;
 			const struct proto_hdr_template	*tmpl;
+			const struct proto_desc		*inner_desc;
 			enum proto_bases		base;
 			unsigned int			offset;
 			bool				is_raw;
@@ -334,6 +335,7 @@ struct expr {
 			/* EXPR_META */
 			enum nft_meta_keys	key;
 			enum proto_bases	base;
+			const struct proto_desc	*inner_desc;
 		} meta;
 		struct {
 			/* SOCKET */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 466fd3f4447c..05a15dce8271 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -760,6 +760,7 @@ enum nft_payload_bases {
 	NFT_PAYLOAD_NETWORK_HEADER,
 	NFT_PAYLOAD_TRANSPORT_HEADER,
 	NFT_PAYLOAD_INNER_HEADER,
+	NFT_PAYLOAD_TUN_HEADER,
 };
 
 /**
@@ -779,6 +780,31 @@ enum nft_payload_csum_flags {
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
+	NFTA_INNER_EXPR,
+	__NFTA_INNER_MAX
+};
+#define NFTA_INNER_MAX	(__NFTA_INNER_MAX - 1)
+
 /**
  * enum nft_payload_attributes - nf_tables payload expression netlink attributes
  *
diff --git a/include/netlink.h b/include/netlink.h
index 4823f1e65d67..5a7f6a1e28ef 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -40,6 +40,8 @@ struct netlink_parse_ctx {
 	struct expr		*registers[MAX_REGS + 1];
 	unsigned int		debug_mask;
 	struct netlink_ctx	*nlctx;
+	bool			inner;
+	uint8_t			inner_reg;
 };
 
 
@@ -55,7 +57,8 @@ struct dl_proto_ctx {
 };
 
 struct rule_pp_ctx {
-	struct dl_proto_ctx	_dl;
+	struct dl_proto_ctx	_dl[2];
+	struct dl_proto_ctx	*dl;
 	struct stmt		*stmt;
 	unsigned int		flags;
 };
diff --git a/include/payload.h b/include/payload.h
index 378699283c0a..aac553ee6b89 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -67,4 +67,6 @@ extern void payload_expr_complete(struct expr *expr,
 
 bool payload_expr_cmp(const struct expr *e1, const struct expr *e2);
 
+const struct proto_desc *find_proto_desc(const struct nftnl_udata *ud);
+
 #endif /* NFTABLES_PAYLOAD_H */
diff --git a/include/proto.h b/include/proto.h
index 6a9289b17f05..5bb7562db94b 100644
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
@@ -216,6 +221,8 @@ extern const struct proto_desc *proto_find_upper(const struct proto_desc *base,
 						 unsigned int num);
 extern int proto_find_num(const struct proto_desc *base,
 			  const struct proto_desc *desc);
+const struct proto_desc *proto_find_inner(uint32_t type, uint32_t hdrsize,
+					  uint32_t flags);
 
 extern const struct proto_desc *proto_find_desc(enum proto_desc_id desc_id);
 
@@ -263,6 +270,7 @@ enum ip_hdr_fields {
 	IPHDR_SADDR,
 	IPHDR_DADDR,
 };
+#define IPHDR_MAX	IPHDR_DADDR
 
 enum icmp_hdr_fields {
 	ICMPHDR_INVALID,
@@ -376,6 +384,19 @@ enum th_hdr_fields {
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
diff --git a/include/rule.h b/include/rule.h
index 795951326886..48bef290c86e 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -768,7 +768,8 @@ struct eval_ctx {
 	struct set		*set;
 	struct stmt		*stmt;
 	struct expr_ctx		ectx;
-	struct proto_ctx	_pctx;
+	struct proto_ctx	_pctx[2];
+	const struct proto_desc	*inner_desc;
 };
 
 extern int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd);
diff --git a/src/evaluate.c b/src/evaluate.c
index 46e688a6081b..253b7b199e49 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -41,7 +41,9 @@
 
 struct proto_ctx *eval_proto_ctx(struct eval_ctx *ctx)
 {
-	return &ctx->_pctx;
+	uint8_t idx = ctx->inner_desc ? 1 : 0;
+
+	return &ctx->_pctx[idx];
 }
 
 static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr);
@@ -452,6 +454,9 @@ conflict_resolution_gen_dependency(struct eval_ctx *ctx, int protocol,
 		return expr_error(ctx->msgs, expr,
 					  "dependency statement is invalid");
 
+	if (ctx->inner_desc)
+		left->payload.inner_desc = ctx->inner_desc;
+
 	*res = stmt;
 	return 0;
 }
@@ -651,6 +656,9 @@ static int meta_iiftype_gen_dependency(struct eval_ctx *ctx,
 		return expr_error(ctx->msgs, payload,
 				  "dependency statement is invalid");
 
+	if (ctx->inner_desc)
+		nstmt->expr->left->meta.inner_desc = ctx->inner_desc;
+
 	*res = nstmt;
 	return 0;
 }
@@ -673,11 +681,15 @@ static int resolve_protocol_conflict(struct eval_ctx *ctx,
 
 	if (payload->payload.base == PROTO_BASE_LL_HDR) {
 		if (proto_is_dummy(desc)) {
-			err = meta_iiftype_gen_dependency(ctx, payload, &nstmt);
-			if (err < 0)
-				return err;
-
-			rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
+			if (ctx->inner_desc) {
+		                proto_ctx_update(pctx, PROTO_BASE_LL_HDR, &payload->location, &proto_eth);
+			} else {
+				err = meta_iiftype_gen_dependency(ctx, payload, &nstmt);
+				if (err < 0)
+					return err;
+
+				rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
+			}
 		} else {
 			unsigned int i;
 
@@ -824,6 +836,48 @@ static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **exprp)
 	return 0;
 }
 
+static int expr_evaluate_inner(struct eval_ctx *ctx, struct expr **exprp)
+{
+	struct proto_ctx *pctx = eval_proto_ctx(ctx);
+	const struct proto_desc *desc;
+	struct expr *expr = *exprp;
+	int ret;
+
+	desc = pctx->protocol[expr->payload.inner_desc->base - 1].desc;
+	if (!desc) {
+		return expr_error(ctx->msgs, expr,
+				  "no transport protocol specified");
+	}
+
+	if (proto_find_num(desc, expr->payload.inner_desc) < 0) {
+		return expr_error(ctx->msgs, expr,
+				  "unexpected transport protocol %s",
+				  desc->name);
+	}
+
+	proto_ctx_update(pctx, PROTO_BASE_INNER_HDR, &expr->location,
+			 expr->payload.inner_desc);
+
+	if (expr->payload.base != PROTO_BASE_INNER_HDR)
+		ctx->inner_desc = expr->payload.inner_desc;
+
+	ret = expr_evaluate_payload(ctx, exprp);
+
+	return ret;
+}
+
+static int expr_evaluate_payload_inner(struct eval_ctx *ctx, struct expr **exprp)
+{
+	int ret;
+
+	if ((*exprp)->payload.inner_desc)
+		ret = expr_evaluate_inner(ctx, exprp);
+	else
+		ret = expr_evaluate_payload(ctx, exprp);
+
+	return ret;
+}
+
 /*
  * RT expression: validate protocol dependencies.
  */
@@ -1370,6 +1424,8 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 		size += netlink_padded_len(dsize);
 		if (key)
 			key = list_next_entry(key, list);
+
+		ctx->inner_desc = NULL;
 	}
 
 	(*expr)->flags |= flags;
@@ -2444,7 +2500,7 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 	case EXPR_FIB:
 		return expr_evaluate_fib(ctx, expr);
 	case EXPR_PAYLOAD:
-		return expr_evaluate_payload(ctx, expr);
+		return expr_evaluate_payload_inner(ctx, expr);
 	case EXPR_RT:
 		return expr_evaluate_rt(ctx, expr);
 	case EXPR_CT:
@@ -2652,6 +2708,11 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 	mpz_t bitmask, ff;
 	bool need_csum;
 
+	if (stmt->payload.expr->payload.inner_desc) {
+		return expr_error(ctx->msgs, stmt->payload.expr,
+				  "payload statement for this expression is not supported");
+	}
+
 	if (__expr_evaluate_payload(ctx, stmt->payload.expr) < 0)
 		return -1;
 
@@ -4508,7 +4569,9 @@ static int rule_evaluate(struct eval_ctx *ctx, struct rule *rule,
 	struct stmt *stmt, *tstmt = NULL;
 	struct error_record *erec;
 
-	proto_ctx_init(&ctx->_pctx, rule->handle.family, ctx->nft->debug_mask);
+	proto_ctx_init(&ctx->_pctx[0], rule->handle.family, ctx->nft->debug_mask);
+	/* use NFPROTO_BRIDGE to set up proto_eth as base protocol. */
+	proto_ctx_init(&ctx->_pctx[1], NFPROTO_BRIDGE, ctx->nft->debug_mask);
 	memset(&ctx->ectx, 0, sizeof(ctx->ectx));
 
 	ctx->rule = rule;
@@ -4523,6 +4586,8 @@ static int rule_evaluate(struct eval_ctx *ctx, struct rule *rule,
 			return -1;
 		if (stmt->flags & STMT_F_TERMINAL)
 			tstmt = stmt;
+
+		ctx->inner_desc = NULL;
 	}
 
 	erec = rule_postprocess(rule);
diff --git a/src/expression.c b/src/expression.c
index 7390089cf57d..ce7fef091764 100644
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
diff --git a/src/meta.c b/src/meta.c
index 257bbc9fe97b..bd8a41ba3a03 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -734,6 +734,7 @@ static void meta_expr_clone(struct expr *new, const struct expr *expr)
 {
 	new->meta.key = expr->meta.key;
 	new->meta.base = expr->meta.base;
+	new->meta.inner_desc = expr->meta.inner_desc;
 }
 
 /**
@@ -807,13 +808,19 @@ static void meta_expr_pctx_update(struct proto_ctx *ctx,
 }
 
 #define NFTNL_UDATA_META_KEY 0
-#define NFTNL_UDATA_META_MAX 1
+#define NFTNL_UDATA_META_INNER_DESC 1
+#define NFTNL_UDATA_META_MAX 2
 
 static int meta_expr_build_udata(struct nftnl_udata_buf *udbuf,
 				 const struct expr *expr)
 {
 	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_META_KEY, expr->meta.key);
 
+	if (expr->meta.inner_desc) {
+		nftnl_udata_put_u32(udbuf, NFTNL_UDATA_META_INNER_DESC,
+				    expr->meta.inner_desc->id);
+	}
+
 	return 0;
 }
 
@@ -825,6 +832,7 @@ static int meta_parse_udata(const struct nftnl_udata *attr, void *data)
 
 	switch (type) {
 	case NFTNL_UDATA_META_KEY:
+	case NFTNL_UDATA_META_INNER_DESC:
 		if (len != sizeof(uint32_t))
 			return -1;
 		break;
@@ -839,6 +847,8 @@ static int meta_parse_udata(const struct nftnl_udata *attr, void *data)
 static struct expr *meta_expr_parse_udata(const struct nftnl_udata *attr)
 {
 	const struct nftnl_udata *ud[NFTNL_UDATA_META_MAX + 1] = {};
+	const struct proto_desc *desc;
+	struct expr *expr;
 	uint32_t key;
 	int err;
 
@@ -852,7 +862,14 @@ static struct expr *meta_expr_parse_udata(const struct nftnl_udata *attr)
 
 	key = nftnl_udata_get_u32(ud[NFTNL_UDATA_META_KEY]);
 
-	return meta_expr_alloc(&internal_location, key);
+	expr = meta_expr_alloc(&internal_location, key);
+
+	if (ud[NFTNL_UDATA_META_INNER_DESC]) {
+		desc = find_proto_desc(ud[NFTNL_UDATA_META_INNER_DESC]);
+		expr->meta.inner_desc = desc;
+	}
+
+	return expr;
 }
 
 const struct expr_ops meta_expr_ops = {
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 7ebe0ef87092..9a38a506fe95 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -32,7 +32,7 @@
 
 struct dl_proto_ctx *dl_proto_ctx(struct rule_pp_ctx *ctx)
 {
-	return &ctx->_dl;
+	return ctx->dl;
 }
 
 static int netlink_parse_expr(const struct nftnl_expr *nle,
@@ -618,6 +618,10 @@ static void netlink_parse_payload_expr(struct netlink_parse_ctx *ctx,
 	struct expr *expr;
 
 	base   = nftnl_expr_get_u32(nle, NFTNL_EXPR_PAYLOAD_BASE) + 1;
+
+	if (base == NFT_PAYLOAD_TUN_HEADER + 1)
+		base = NFT_PAYLOAD_INNER_HEADER + 1;
+
 	offset = nftnl_expr_get_u32(nle, NFTNL_EXPR_PAYLOAD_OFFSET) * BITS_PER_BYTE;
 	len    = nftnl_expr_get_u32(nle, NFTNL_EXPR_PAYLOAD_LEN) * BITS_PER_BYTE;
 
@@ -625,9 +629,80 @@ static void netlink_parse_payload_expr(struct netlink_parse_ctx *ctx,
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
+	const struct proto_desc *inner_desc;
+	const struct nftnl_expr *inner_nle;
+	uint32_t hdrsize, flags, type;
+	struct expr *expr;
+
+	hdrsize = nftnl_expr_get_u32(nle, NFTNL_EXPR_INNER_HDRSIZE);
+	type    = nftnl_expr_get_u32(nle, NFTNL_EXPR_INNER_TYPE);
+	flags   = nftnl_expr_get_u32(nle, NFTNL_EXPR_INNER_FLAGS);
+
+	inner_nle = nftnl_expr_get(nle, NFTNL_EXPR_INNER_EXPR, NULL);
+	if (!inner_nle) {
+		netlink_error(ctx, loc, "Could not parse inner expression");
+		return;
+	}
+
+	inner_desc = proto_find_inner(type, hdrsize, flags);
+
+	ctx->inner = true;
+	if (netlink_parse_expr(inner_nle, ctx) < 0) {
+		ctx->inner = false;
+		return;
+	}
+	ctx->inner = false;
+
+	expr = netlink_get_register(ctx, loc, ctx->inner_reg);
+	assert(expr);
+
+	if (expr->etype == EXPR_PAYLOAD &&
+	    expr->payload.base == PROTO_BASE_INNER_HDR) {
+		const struct proto_hdr_template *tmpl;
+		unsigned int i;
+
+		for (i = 1; i < array_size(inner_desc->templates); i++) {
+			tmpl = &inner_desc->templates[i];
+
+			if (tmpl->len == 0)
+				return;
+
+			if (tmpl->offset != expr->payload.offset ||
+			    tmpl->len != expr->len)
+				continue;
+
+			expr->payload.desc = inner_desc;
+			expr->payload.tmpl = tmpl;
+			break;
+		}
+	}
+
+	switch (expr->etype) {
+	case EXPR_PAYLOAD:
+		expr->payload.inner_desc = inner_desc;
+		break;
+	case EXPR_META:
+		expr->meta.inner_desc = inner_desc;
+		break;
+	default:
+		assert(0);
+		break;
+	}
+
+	netlink_set_register(ctx, ctx->inner_reg, expr);
+}
+
 static void netlink_parse_payload_stmt(struct netlink_parse_ctx *ctx,
 				       const struct location *loc,
 				       const struct nftnl_expr *nle)
@@ -784,6 +859,9 @@ static void netlink_parse_meta_expr(struct netlink_parse_ctx *ctx,
 	expr = meta_expr_alloc(loc, key);
 
 	dreg = netlink_parse_register(nle, NFTNL_EXPR_META_DREG);
+	if (ctx->inner)
+		ctx->inner_reg = dreg;
+
 	netlink_set_register(ctx, dreg, expr);
 }
 
@@ -1777,6 +1855,7 @@ static const struct expr_handler netlink_parsers[] = {
 	{ .name = "bitwise",	.parse = netlink_parse_bitwise },
 	{ .name = "byteorder",	.parse = netlink_parse_byteorder },
 	{ .name = "payload",	.parse = netlink_parse_payload },
+	{ .name = "inner",	.parse = netlink_parse_inner },
 	{ .name = "exthdr",	.parse = netlink_parse_exthdr },
 	{ .name = "meta",	.parse = netlink_parse_meta },
 	{ .name = "socket",	.parse = netlink_parse_socket },
@@ -1910,6 +1989,14 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 		assert(left->payload.base);
 		assert(base == left->payload.base);
 
+		if (expr->left->payload.inner_desc) {
+			if (expr->left->payload.inner_desc == expr->left->payload.desc) {
+				nexpr->left->payload.desc = expr->left->payload.desc;
+				nexpr->left->payload.tmpl = expr->left->payload.tmpl;
+			}
+			nexpr->left->payload.inner_desc = expr->left->payload.inner_desc;
+		}
+
 		if (payload_is_stacked(dl->pctx.protocol[base].desc, nexpr))
 			base--;
 
@@ -3053,19 +3140,75 @@ rule_maybe_reset_payload_deps(struct payload_dep_ctx *pdctx, enum stmt_types t)
 	payload_dependency_reset(pdctx);
 }
 
+static bool has_inner_desc(const struct expr *expr)
+{
+	struct expr *i;
+
+	switch (expr->etype) {
+	case EXPR_BINOP:
+		return has_inner_desc(expr->left);
+	case EXPR_CONCAT:
+		list_for_each_entry(i, &expr->expressions, list) {
+			if (has_inner_desc(i))
+				return true;
+		}
+		break;
+	case EXPR_META:
+		return expr->meta.inner_desc;
+	case EXPR_PAYLOAD:
+		return expr->payload.inner_desc;
+	case EXPR_SET_ELEM:
+		return has_inner_desc(expr->key);
+	default:
+		break;
+	}
+
+	return false;
+}
+
+static struct dl_proto_ctx *rule_update_dl_proto_ctx(struct rule_pp_ctx *rctx)
+{
+	const struct stmt *stmt = rctx->stmt;
+	bool inner = false;
+
+	switch (stmt->ops->type) {
+	case STMT_EXPRESSION:
+		if (has_inner_desc(stmt->expr->left))
+			inner = true;
+		break;
+	case STMT_SET:
+		if (has_inner_desc(stmt->set.key))
+			inner = true;
+		break;
+	default:
+		break;
+	}
+
+	if (inner)
+		rctx->dl = &rctx->_dl[1];
+	else
+		rctx->dl = &rctx->_dl[0];
+
+	return rctx->dl;
+}
+
 static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *rule)
 {
 	struct stmt *stmt, *next;
+	struct dl_proto_ctx *dl;
 	struct rule_pp_ctx rctx;
 	struct expr *expr;
 
 	memset(&rctx, 0, sizeof(rctx));
-	proto_ctx_init(&rctx._dl.pctx, rule->handle.family, ctx->debug_mask);
+	proto_ctx_init(&rctx._dl[0].pctx, rule->handle.family, ctx->debug_mask);
+	/* use NFPROTO_BRIDGE to set up proto_eth as base protocol. */
+	proto_ctx_init(&rctx._dl[1].pctx, NFPROTO_BRIDGE, ctx->debug_mask);
 
 	list_for_each_entry_safe(stmt, next, &rule->stmts, list) {
 		enum stmt_types type = stmt->ops->type;
 
 		rctx.stmt = stmt;
+		dl = rule_update_dl_proto_ctx(&rctx);
 
 		switch (type) {
 		case STMT_EXPRESSION:
@@ -3097,7 +3240,7 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 			if (stmt->nat.addr != NULL)
 				expr_postprocess(&rctx, &stmt->nat.addr);
 			if (stmt->nat.proto != NULL) {
-				payload_dependency_reset(&rctx._dl.pdctx);
+				payload_dependency_reset(&dl->pdctx);
 				expr_postprocess(&rctx, &stmt->nat.proto);
 			}
 			break;
@@ -3105,7 +3248,7 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 			if (stmt->tproxy.addr)
 				expr_postprocess(&rctx, &stmt->tproxy.addr);
 			if (stmt->tproxy.port) {
-				payload_dependency_reset(&rctx._dl.pdctx);
+				payload_dependency_reset(&dl->pdctx);
 				expr_postprocess(&rctx, &stmt->tproxy.port);
 			}
 			break;
@@ -3143,9 +3286,9 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 			break;
 		}
 
-		rctx._dl.pdctx.prev = rctx.stmt;
+		dl->pdctx.prev = rctx.stmt;
 
-		rule_maybe_reset_payload_deps(&rctx._dl.pdctx, type);
+		rule_maybe_reset_payload_deps(&dl->pdctx, type);
 	}
 }
 
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index c8bbcb7452b0..b5a3c855aabd 100644
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
 
@@ -193,6 +192,72 @@ static void netlink_gen_payload(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_PAYLOAD_LEN,
 			   div_round_up(expr->len, BITS_PER_BYTE));
 
+	return nle;
+}
+
+static struct nftnl_expr *
+__netlink_gen_meta(const struct expr *expr, enum nft_registers dreg)
+{
+	struct nftnl_expr *nle;
+
+	nle = alloc_nft_expr("meta");
+	netlink_put_register(nle, NFTNL_EXPR_META_DREG, dreg);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_META_KEY, expr->meta.key);
+
+	return nle;
+}
+
+static struct nftnl_expr *netlink_gen_inner_expr(const struct expr *expr,
+						 enum nft_registers dreg)
+{
+	struct expr *_expr = (struct expr *)expr;
+	struct nftnl_expr *nle;
+
+	switch (expr->etype) {
+	case EXPR_PAYLOAD:
+		if (expr->payload.base == NFT_PAYLOAD_INNER_HEADER + 1)
+			_expr->payload.base = NFT_PAYLOAD_TUN_HEADER + 1;
+
+		nle = __netlink_gen_payload(expr, dreg);
+		break;
+	case EXPR_META:
+		nle = __netlink_gen_meta(expr, dreg);
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
+			      enum nft_registers dreg,
+			      const struct proto_desc *desc)
+{
+	struct nftnl_expr *nle;
+
+	nle = alloc_nft_expr("inner");
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_INNER_HDRSIZE, desc->inner.hdrsize);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_INNER_FLAGS, desc->inner.flags);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_INNER_TYPE, desc->inner.type);
+	nftnl_expr_set(nle, NFTNL_EXPR_INNER_EXPR, netlink_gen_inner_expr(expr, dreg), 0);
+	nft_rule_add_expr(ctx, nle, &expr->location);
+}
+
+static void netlink_gen_payload(struct netlink_linearize_ctx *ctx,
+				const struct expr *expr,
+				enum nft_registers dreg)
+{
+	struct nftnl_expr *nle;
+
+	if (expr->payload.inner_desc) {
+		netlink_gen_inner(ctx, expr, dreg, expr->payload.inner_desc);
+		return;
+	}
+
+	nle = __netlink_gen_payload(expr, dreg);
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
@@ -221,9 +286,12 @@ static void netlink_gen_meta(struct netlink_linearize_ctx *ctx,
 {
 	struct nftnl_expr *nle;
 
-	nle = alloc_nft_expr("meta");
-	netlink_put_register(nle, NFTNL_EXPR_META_DREG, dreg);
-	nftnl_expr_set_u32(nle, NFTNL_EXPR_META_KEY, expr->meta.key);
+	if (expr->meta.inner_desc) {
+		netlink_gen_inner(ctx, expr, dreg, expr->meta.inner_desc);
+		return;
+	}
+
+	nle = __netlink_gen_meta(expr, dreg);
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 0266819a779b..7a7210c68f42 100644
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
 
+%type <expr>			inner_eth_expr inner_inet_expr inner_expr vxlan_hdr_expr
+%destructor { expr_free($$); }	inner_eth_expr inner_inet_expr inner_expr vxlan_hdr_expr
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
@@ -5543,6 +5551,51 @@ tcp_hdr_expr		:	TCP	tcp_hdr_field
 			}
 			;
 
+inner_inet_expr		:	ip_hdr_expr
+			|	icmp_hdr_expr
+			|	igmp_hdr_expr
+			|	ip6_hdr_expr
+			|	icmp6_hdr_expr
+			|	auth_hdr_expr
+			|	esp_hdr_expr
+			|	comp_hdr_expr
+			|	udp_hdr_expr
+			|	udplite_hdr_expr
+			|	tcp_hdr_expr	close_scope_tcp
+			|	dccp_hdr_expr
+			|	sctp_hdr_expr
+			|	th_hdr_expr
+			;
+
+inner_eth_expr		:	eth_hdr_expr
+			|	vlan_hdr_expr
+			|	arp_hdr_expr
+			;
+
+inner_expr		:	inner_eth_expr
+			|	inner_inet_expr
+			;
+
+vxlan_hdr_expr		:	VXLAN	vxlan_hdr_field
+			{
+				struct expr *expr;
+
+				expr = payload_expr_alloc(&@$, &proto_vxlan, $2);
+				expr->payload.inner_desc = &proto_vxlan;
+				$$ = expr;
+			}
+			|	VXLAN	inner_expr
+			{
+				$$ = $2;
+				$$->location = @$;
+				$$->payload.inner_desc = &proto_vxlan;
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
diff --git a/src/payload.c b/src/payload.c
index 07f02359a7e7..7abb5f5cbf51 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -47,6 +47,10 @@ static void payload_expr_print(const struct expr *expr, struct output_ctx *octx)
 	const struct proto_desc *desc;
 	const struct proto_hdr_template *tmpl;
 
+	if (expr->payload.inner_desc &&
+	    expr->payload.inner_desc != expr->payload.desc)
+		nft_print(octx, "%s ", expr->payload.inner_desc->name);
+
 	desc = expr->payload.desc;
 	tmpl = expr->payload.tmpl;
 	if (payload_is_known(expr))
@@ -67,6 +71,7 @@ bool payload_expr_cmp(const struct expr *e1, const struct expr *e2)
 
 static void payload_expr_clone(struct expr *new, const struct expr *expr)
 {
+	new->payload.inner_desc   = expr->payload.inner_desc;
 	new->payload.desc   = expr->payload.desc;
 	new->payload.tmpl   = expr->payload.tmpl;
 	new->payload.base   = expr->payload.base;
@@ -132,7 +137,8 @@ static void payload_expr_pctx_update(struct proto_ctx *ctx,
 #define NFTNL_UDATA_SET_KEY_PAYLOAD_BASE 2
 #define NFTNL_UDATA_SET_KEY_PAYLOAD_OFFSET 3
 #define NFTNL_UDATA_SET_KEY_PAYLOAD_LEN 4
-#define NFTNL_UDATA_SET_KEY_PAYLOAD_MAX 5
+#define NFTNL_UDATA_SET_KEY_PAYLOAD_INNER_DESC 5
+#define NFTNL_UDATA_SET_KEY_PAYLOAD_MAX 6
 
 static unsigned int expr_payload_type(const struct proto_desc *desc,
 				      const struct proto_hdr_template *tmpl)
@@ -162,10 +168,15 @@ static int payload_expr_build_udata(struct nftnl_udata_buf *udbuf,
 	if (expr->dtype->type == TYPE_INTEGER)
 		nftnl_udata_put_u32(udbuf, NFTNL_UDATA_SET_KEY_PAYLOAD_LEN, expr->len);
 
+	if (expr->payload.inner_desc) {
+		nftnl_udata_put_u32(udbuf, NFTNL_UDATA_SET_KEY_PAYLOAD_INNER_DESC,
+				    expr->payload.inner_desc->id);
+	}
+
 	return 0;
 }
 
-static const struct proto_desc *find_proto_desc(const struct nftnl_udata *ud)
+const struct proto_desc *find_proto_desc(const struct nftnl_udata *ud)
 {
 	return proto_find_desc(nftnl_udata_get_u32(ud));
 }
@@ -182,6 +193,7 @@ static int payload_parse_udata(const struct nftnl_udata *attr, void *data)
 	case NFTNL_UDATA_SET_KEY_PAYLOAD_BASE:
 	case NFTNL_UDATA_SET_KEY_PAYLOAD_OFFSET:
 	case NFTNL_UDATA_SET_KEY_PAYLOAD_LEN:
+	case NFTNL_UDATA_SET_KEY_PAYLOAD_INNER_DESC:
 		if (len != sizeof(uint32_t))
 			return -1;
 		break;
@@ -245,6 +257,11 @@ static struct expr *payload_expr_parse_udata(const struct nftnl_udata *attr)
 		expr->dtype = dtype;
 	}
 
+	if (ud[NFTNL_UDATA_SET_KEY_PAYLOAD_INNER_DESC]) {
+		desc = find_proto_desc(ud[NFTNL_UDATA_SET_KEY_PAYLOAD_INNER_DESC]);
+		expr->payload.inner_desc = desc;
+	}
+
 	return expr;
 }
 
@@ -418,6 +435,13 @@ static int payload_add_dependency(struct eval_ctx *ctx,
 					  "dependency statement is invalid");
 	}
 
+	if (ctx->inner_desc) {
+		if (tmpl->meta_key)
+			left->meta.inner_desc = ctx->inner_desc;
+		else
+			left->payload.inner_desc = ctx->inner_desc;
+	}
+
 	pctx = eval_proto_ctx(ctx);
 	relational_expr_pctx_update(pctx, dep);
 	*res = stmt;
@@ -1109,6 +1133,10 @@ raw:
 	new = payload_expr_alloc(&expr->location, NULL, 0);
 	payload_init_raw(new, expr->payload.base, payload_offset,
 			 expr->len);
+
+	if (expr->payload.inner_desc)
+		new->dtype = &integer_type;
+
 	list_add_tail(&new->list, list);
 }
 
@@ -1130,6 +1158,9 @@ bool payload_can_merge(const struct expr *e1, const struct expr *e2)
 {
 	unsigned int total;
 
+	if (e1->payload.inner_desc != e2->payload.inner_desc)
+		return false;
+
 	if (!payload_is_adjacent(e1, e2))
 		return false;
 
@@ -1186,6 +1217,8 @@ struct expr *payload_expr_join(const struct expr *e1, const struct expr *e2)
 	expr->payload.base   = e1->payload.base;
 	expr->payload.offset = e1->payload.offset;
 	expr->len	     = e1->len + e2->len;
+	expr->payload.inner_desc = e1->payload.inner_desc;
+
 	return expr;
 }
 
diff --git a/src/proto.c b/src/proto.c
index c8b3361bbee6..1e0476bacffe 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -88,6 +88,27 @@ int proto_find_num(const struct proto_desc *base,
 	return -1;
 }
 
+static const struct proto_desc *inner_protocols[] = {
+	&proto_vxlan,
+};
+
+const struct proto_desc *proto_find_inner(uint32_t type, uint32_t hdrsize,
+					  uint32_t flags)
+{
+	const struct proto_desc *desc;
+	unsigned int i;
+
+	for (i = 0; i < array_size(inner_protocols); i++) {
+		desc = inner_protocols[i];
+		if (desc->inner.type == type &&
+		    desc->inner.hdrsize == hdrsize &&
+		    desc->inner.flags == flags)
+			return inner_protocols[i];
+	}
+
+	return &proto_unknown;
+}
+
 static const struct dev_proto_desc dev_proto_desc[] = {
 	DEV_PROTO_DESC(ARPHRD_ETHER, &proto_eth),
 };
@@ -228,6 +249,8 @@ void proto_ctx_update(struct proto_ctx *ctx, enum proto_bases base,
 			ctx->protocol[base].protos[i].location = *loc;
 		}
 		break;
+	case PROTO_BASE_INNER_HDR:
+		break;
 	default:
 		BUG("unknown protocol base %d", base);
 	}
@@ -513,6 +536,9 @@ const struct proto_desc proto_udp = {
 		[UDPHDR_LENGTH]		= UDPHDR_FIELD("length", len),
 		[UDPHDR_CHECKSUM]	= UDPHDR_FIELD("checksum", check),
 	},
+	.protocols	= {
+		PROTO_LINK(0,	&proto_vxlan),
+	},
 };
 
 const struct proto_desc proto_udplite = {
@@ -1135,6 +1161,31 @@ const struct proto_desc proto_eth = {
 
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
+		[VXLANHDR_FLAGS] = HDR_BITFIELD("flags", &bitmask_type, 0, 8),
+		[VXLANHDR_VNI]	 = HDR_BITFIELD("vni", &integer_type, (4 * BITS_PER_BYTE), 24),
+	},
+	.protocols	= {
+		PROTO_LINK(__constant_htons(ETH_P_IP),		&proto_ip),
+		PROTO_LINK(__constant_htons(ETH_P_ARP),		&proto_arp),
+		PROTO_LINK(__constant_htons(ETH_P_IPV6),	&proto_ip6),
+		PROTO_LINK(__constant_htons(ETH_P_8021Q),	&proto_vlan),
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
@@ -1171,6 +1222,7 @@ static const struct proto_desc *proto_definitions[PROTO_DESC_MAX + 1] = {
 	[PROTO_DESC_ARP]	= &proto_arp,
 	[PROTO_DESC_VLAN]	= &proto_vlan,
 	[PROTO_DESC_ETHER]	= &proto_eth,
+	[PROTO_DESC_VXLAN]	= &proto_vxlan,
 };
 
 const struct proto_desc *proto_find_desc(enum proto_desc_id desc_id)
diff --git a/src/rule.c b/src/rule.c
index 1caee58fb762..4e9fb273a244 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2886,7 +2886,8 @@ static void stmt_reduce(const struct rule *rule)
 			switch (stmt->expr->op) {
 			case OP_EQ:
 			case OP_IMPLICIT:
-				if (stmt->expr->left->meta.key == NFT_META_PROTOCOL) {
+				if (stmt->expr->left->meta.key == NFT_META_PROTOCOL &&
+				    !stmt->expr->left->meta.inner_desc) {
 					uint16_t protocol;
 
 					protocol = mpz_get_uint16(stmt->expr->right->value);
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

