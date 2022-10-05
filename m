Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA6ECC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Oct 2022 22:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiJEWsk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 18:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiJEWsi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 18:48:38 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C69C7F0B1
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 15:48:37 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] src: add gre support
Date:   Thu,  6 Oct 2022 00:48:32 +0200
Message-Id: <20221005224833.24056-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221005224833.24056-1-pablo@netfilter.org>
References: <20221005224833.24056-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

GRE has a number of fields that are conditional based on flags,
which requires custom dependency code similar to icmp and icmpv6.
Matching on optional fields is not supported at this stage.

Since this is a layer 3 tunnel protocol, an implicit dependency on
NFT_META_L4PROTO for IPPROTO_GRE is generated. To achieve this, this
patch adds new infrastructure to remove an outer dependency based on
the inner protocol from delinearize path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_tables.h |  1 +
 include/payload.h                   |  2 ++
 include/proto.h                     | 13 ++++++++
 src/evaluate.c                      | 40 +++++++++++++++++-------
 src/netlink_delinearize.c           | 41 +++++++++++++++++++++++++
 src/parser_bison.y                  | 35 +++++++++++++++++++--
 src/payload.c                       | 47 +++++++++++++++++++++++++++++
 src/proto.c                         | 27 +++++++++++++++++
 src/scanner.l                       |  2 ++
 9 files changed, 194 insertions(+), 14 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 05a15dce8271..e4b739d57480 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -783,6 +783,7 @@ enum nft_payload_csum_flags {
 enum nft_inner_type {
 	NFT_INNER_UNSPEC	= 0,
 	NFT_INNER_VXLAN,
+	NFT_INNER_GENEVE,
 };
 
 enum nft_inner_flags {
diff --git a/include/payload.h b/include/payload.h
index aac553ee6b89..08e45f7f79e2 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -15,6 +15,8 @@ struct eval_ctx;
 struct stmt;
 extern int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 				  struct stmt **res);
+int payload_gen_inner_dependency(struct eval_ctx *ctx, const struct expr *expr,
+				 struct stmt **res);
 extern int payload_gen_icmp_dependency(struct eval_ctx *ctx,
 				       const struct expr *expr,
 				       struct stmt **res);
diff --git a/include/proto.h b/include/proto.h
index 32e0744854a5..2a82c385c330 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -97,6 +97,7 @@ enum proto_desc_id {
 	PROTO_DESC_VLAN,
 	PROTO_DESC_ETHER,
 	PROTO_DESC_VXLAN,
+	PROTO_DESC_GRE,
 	__PROTO_DESC_MAX
 };
 #define PROTO_DESC_MAX	(__PROTO_DESC_MAX - 1)
@@ -396,7 +397,19 @@ enum vxlan_hdr_fields {
 	VXLANHDR_FLAGS,
 };
 
+struct grehdr {
+	uint16_t flags;
+	uint16_t protocol;
+};
+
+enum gre_hdr_fields {
+	GREHDR_INVALID,
+	GREHDR_FLAGS,
+	GREHDR_PROTOCOL,
+};
+
 extern const struct proto_desc proto_vxlan;
+extern const struct proto_desc proto_gre;
 
 extern const struct proto_desc proto_icmp;
 extern const struct proto_desc proto_igmp;
diff --git a/src/evaluate.c b/src/evaluate.c
index 310d00437589..7bc1b2b61a86 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -862,22 +862,40 @@ static int expr_evaluate_inner(struct eval_ctx *ctx, struct expr **exprp)
 	struct proto_ctx *pctx = eval_proto_ctx(ctx);
 	const struct proto_desc *desc;
 	struct expr *expr = *exprp;
+	enum proto_bases base;
 	int ret;
 
-	desc = pctx->protocol[expr->payload.inner_desc->base - 1].desc;
-	if (!desc) {
-		return expr_error(ctx->msgs, expr,
-				  "no transport protocol specified");
-	}
+	assert(expr->etype == EXPR_PAYLOAD);
+	base = expr->payload.base;
 
-	if (proto_find_num(desc, expr->payload.inner_desc) < 0) {
-		return expr_error(ctx->msgs, expr,
-				  "unexpected transport protocol %s",
-				  desc->name);
+	pctx = eval_proto_ctx(ctx);
+	desc = pctx->protocol[base].desc;
+	if (desc == NULL &&
+	    expr->payload.inner_desc->base < PROTO_BASE_INNER_HDR) {
+		struct stmt *nstmt;
+
+		if (payload_gen_inner_dependency(ctx, expr, &nstmt) < 0)
+			return -1;
+
+		rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
 	}
 
-	proto_ctx_update(pctx, PROTO_BASE_INNER_HDR, &expr->location,
-			 expr->payload.inner_desc);
+	if (expr->payload.inner_desc->base == PROTO_BASE_INNER_HDR) {
+		desc = pctx->protocol[expr->payload.inner_desc->base - 1].desc;
+		if (!desc) {
+			return expr_error(ctx->msgs, expr,
+					  "no transport protocol specified");
+		}
+
+		if (proto_find_num(desc, expr->payload.inner_desc) < 0) {
+			return expr_error(ctx->msgs, expr,
+					  "unexpected transport protocol %s",
+					  desc->name);
+		}
+
+		proto_ctx_update(pctx, expr->payload.inner_desc->base, &expr->location,
+				 expr->payload.inner_desc);
+	}
 
 	if (expr->payload.base != PROTO_BASE_INNER_HDR)
 		ctx->inner_desc = expr->payload.inner_desc;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index ea071aa64d5c..68185d477cc1 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -35,6 +35,11 @@ struct dl_proto_ctx *dl_proto_ctx(struct rule_pp_ctx *ctx)
 	return ctx->dl;
 }
 
+static struct dl_proto_ctx *dl_proto_ctx_outer(struct rule_pp_ctx *ctx)
+{
+	return &ctx->_dl[0];
+}
+
 static int netlink_parse_expr(const struct nftnl_expr *nle,
 			      struct netlink_parse_ctx *ctx);
 
@@ -1952,6 +1957,36 @@ struct stmt *netlink_parse_set_expr(const struct set *set,
 	return pctx->stmt;
 }
 
+static bool meta_outer_may_dependency_kill(struct rule_pp_ctx *ctx,
+					   const struct expr *expr)
+{
+	struct dl_proto_ctx *dl_outer = dl_proto_ctx_outer(ctx);
+	struct stmt *stmt = dl_outer->pdctx.pdeps[expr->left->payload.inner_desc->base];
+	struct expr *dep;
+	uint8_t l4proto;
+
+	if (!stmt)
+		return false;
+
+	dep = stmt->expr;
+
+	if (dep->left->meta.key != NFT_META_L4PROTO)
+		return false;
+
+	l4proto = mpz_get_uint8(dep->right->value);
+
+	switch (l4proto) {
+	case IPPROTO_GRE:
+		if (expr->left->payload.inner_desc == &proto_gre)
+			return true;
+		break;
+	default:
+		break;
+	}
+
+	return false;
+}
+
 static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp);
 
 static void payload_match_expand(struct rule_pp_ctx *ctx,
@@ -1995,6 +2030,12 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 				nexpr->left->payload.tmpl = expr->left->payload.tmpl;
 			}
 			nexpr->left->payload.inner_desc = expr->left->payload.inner_desc;
+
+			if (meta_outer_may_dependency_kill(ctx, expr)) {
+				struct dl_proto_ctx *dl_outer = dl_proto_ctx_outer(ctx);
+
+				payload_dependency_release(&dl_outer->pdctx, expr->left->payload.inner_desc->base);
+			}
 		}
 
 		if (payload_is_stacked(dl->pctx.protocol[base].desc, nexpr))
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 7a7210c68f42..52fb17a83879 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -431,6 +431,8 @@ int nft_lex(void *, void *, void *);
 %token VXLAN			"vxlan"
 %token VNI			"vni"
 
+%token GRE			"gre"
+
 %token SCTP			"sctp"
 %token CHUNK			"chunk"
 %token DATA			"data"
@@ -889,9 +891,9 @@ int nft_lex(void *, void *, void *);
 %type <val>			tcpopt_field_maxseg	tcpopt_field_mptcp	tcpopt_field_sack	 tcpopt_field_tsopt	tcpopt_field_window
 %type <tcp_kind_field>		tcp_hdr_option_kind_and_field
 
-%type <expr>			inner_eth_expr inner_inet_expr inner_expr vxlan_hdr_expr
-%destructor { expr_free($$); }	inner_eth_expr inner_inet_expr inner_expr vxlan_hdr_expr
-%type <val>			vxlan_hdr_field
+%type <expr>			inner_eth_expr inner_inet_expr inner_expr vxlan_hdr_expr gre_hdr_expr
+%destructor { expr_free($$); }	inner_eth_expr inner_inet_expr inner_expr vxlan_hdr_expr gre_hdr_expr
+%type <val>			vxlan_hdr_field gre_hdr_field
 
 %type <stmt>			optstrip_stmt
 %destructor { stmt_free($$); }	optstrip_stmt
@@ -4844,6 +4846,13 @@ primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
 							 BYTEORDER_HOST_ENDIAN,
 							 sizeof(data) * BITS_PER_BYTE, &data);
 			}
+			|	GRE
+			{
+				uint8_t data = IPPROTO_GRE;
+				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 sizeof(data) * BITS_PER_BYTE, &data);
+			}
 			|	COMP	close_scope_comp
 			{
 				uint8_t data = IPPROTO_COMP;
@@ -5300,6 +5309,7 @@ payload_expr		:	payload_raw_expr
 			|	sctp_hdr_expr
 			|	th_hdr_expr
 			|	vxlan_hdr_expr
+			|	gre_hdr_expr
 			;
 
 payload_raw_expr	:	AT	payload_base_spec	COMMA	NUM	COMMA	NUM	close_scope_at
@@ -5596,6 +5606,25 @@ vxlan_hdr_field		:	VNI			{ $$ = VXLANHDR_VNI; }
 			|	FLAGS			{ $$ = VXLANHDR_FLAGS; }
 			;
 
+gre_hdr_expr		:	GRE	gre_hdr_field
+			{
+				struct expr *expr;
+
+				expr = payload_expr_alloc(&@$, &proto_gre, $2);
+				expr->payload.inner_desc = &proto_gre;
+				$$ = expr;
+			}
+			|	GRE	inner_expr
+			{
+				$$ = $2;
+				$$->payload.inner_desc = &proto_gre;
+			}
+			;
+
+gre_hdr_field		:	FLAGS			{ $$ = GREHDR_FLAGS; }
+			|	PROTOCOL		{ $$ = GREHDR_PROTOCOL; }
+			;
+
 optstrip_stmt		:	RESET	TCP	OPTION	tcp_hdr_option_type	close_scope_tcp
 			{
 				$$ = optstrip_stmt_alloc(&@$, tcpopt_expr_alloc(&@$,
diff --git a/src/payload.c b/src/payload.c
index 7abb5f5cbf51..32061278574a 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -487,6 +487,14 @@ payload_gen_special_dependency(struct eval_ctx *ctx, const struct expr *expr)
 					break;
 			}
 
+			/* this tunnel protocol does not encapsulate an inner
+			 * link layer, use proto_netdev which relies on
+			 * NFT_META_PROTOCOL for dependencies.
+			 */
+			if (expr->payload.inner_desc &&
+			    !(expr->payload.inner_desc->inner.flags & NFT_INNER_LL))
+				desc = &proto_netdev;
+
 			desc_upper = &proto_ip6;
 			if (expr->payload.desc == &proto_icmp ||
 			    expr->payload.desc == &proto_igmp)
@@ -1355,3 +1363,42 @@ bad_proto:
 	return expr_error(ctx->msgs, expr, "incompatible icmp match: rule has %d, need %u",
 			  pctx->th_dep.icmp.type, type);
 }
+
+int payload_gen_inner_dependency(struct eval_ctx *ctx, const struct expr *expr,
+				 struct stmt **res)
+{
+	struct proto_ctx *pctx = eval_proto_ctx(ctx);
+	const struct proto_hdr_template *tmpl;
+	const struct proto_desc *desc, *inner_desc;
+	struct expr *left, *right, *dep;
+	struct stmt *stmt = NULL;
+	int protocol;
+
+	assert(expr->etype == EXPR_PAYLOAD);
+
+	inner_desc = expr->payload.inner_desc;
+	desc = pctx->protocol[inner_desc->base - 1].desc;
+	if (desc == NULL)
+		desc = &proto_ip;
+
+	tmpl = &inner_desc->templates[0];
+	assert(tmpl);
+
+	protocol = proto_find_num(desc, inner_desc);
+	if (protocol < 0)
+                return expr_error(ctx->msgs, expr,
+                                  "conflicting protocols specified: %s vs. %s",
+                                  desc->name, inner_desc->name);
+
+	left = meta_expr_alloc(&expr->location, tmpl->meta_key);
+
+	right = constant_expr_alloc(&expr->location, tmpl->dtype,
+				    tmpl->dtype->byteorder, tmpl->len,
+				    constant_data_ptr(protocol, tmpl->len));
+
+	dep = relational_expr_alloc(&expr->location, OP_EQ, left, right);
+	stmt = expr_stmt_alloc(&dep->location, dep);
+
+	*res = stmt;
+	return 0;
+}
diff --git a/src/proto.c b/src/proto.c
index e6c1100bb448..10454d405888 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -90,6 +90,7 @@ int proto_find_num(const struct proto_desc *base,
 
 static const struct proto_desc *inner_protocols[] = {
 	&proto_vxlan,
+	&proto_gre,
 };
 
 const struct proto_desc *proto_find_inner(uint32_t type, uint32_t hdrsize,
@@ -771,6 +772,29 @@ const struct datatype ecn_type = {
 	.sym_tbl	= &ecn_type_tbl,
 };
 
+#define GREHDR_FIELD(__name, __member) \
+	HDR_FIELD(__name, struct grehdr, __member)
+#define GREHDR_TEMPLATE(__name, __dtype, __member) \
+	HDR_TEMPLATE(__name, __dtype, struct grehdr, __member)
+#define GREHDR_TYPE(__name, __member) \
+	GREHDR_TEMPLATE(__name, &ethertype_type, __member)
+
+const struct proto_desc proto_gre = {
+	.name		= "gre",
+	.id		= PROTO_DESC_GRE,
+	.base		= PROTO_BASE_TRANSPORT_HDR,
+	.templates	= {
+		[0] = PROTO_META_TEMPLATE("l4proto", &inet_protocol_type, NFT_META_L4PROTO, 8),
+		[GREHDR_PROTOCOL]	= GREHDR_TYPE("protocol", flags),
+		[GREHDR_FLAGS]		= GREHDR_FIELD("flags", protocol),
+	},
+	.inner		= {
+		.hdrsize	= 0,
+		.flags		= NFT_INNER_NH | NFT_INNER_TH,
+		.type		= NFT_INNER_GENEVE + 1,
+	},
+};
+
 #define IPHDR_FIELD(__name, __member) \
 	HDR_FIELD(__name, struct iphdr, __member)
 #define IPHDR_ADDR(__name, __member) \
@@ -794,6 +818,7 @@ const struct proto_desc proto_ip = {
 		PROTO_LINK(IPPROTO_TCP,		&proto_tcp),
 		PROTO_LINK(IPPROTO_DCCP,	&proto_dccp),
 		PROTO_LINK(IPPROTO_SCTP,	&proto_sctp),
+		PROTO_LINK(IPPROTO_GRE,		&proto_gre),
 	},
 	.templates	= {
 		[0]	= PROTO_META_TEMPLATE("l4proto", &inet_protocol_type, NFT_META_L4PROTO, 8),
@@ -985,6 +1010,7 @@ const struct proto_desc proto_inet_service = {
 		PROTO_LINK(IPPROTO_ICMP,	&proto_icmp),
 		PROTO_LINK(IPPROTO_IGMP,	&proto_igmp),
 		PROTO_LINK(IPPROTO_ICMPV6,	&proto_icmp6),
+		PROTO_LINK(IPPROTO_GRE,		&proto_gre),
 	},
 	.templates	= {
 		[0]	= PROTO_META_TEMPLATE("l4proto", &inet_protocol_type, NFT_META_L4PROTO, 8),
@@ -1226,6 +1252,7 @@ static const struct proto_desc *proto_definitions[PROTO_DESC_MAX + 1] = {
 	[PROTO_DESC_VLAN]	= &proto_vlan,
 	[PROTO_DESC_ETHER]	= &proto_eth,
 	[PROTO_DESC_VXLAN]	= &proto_vxlan,
+	[PROTO_DESC_GRE]	= &proto_gre,
 };
 
 const struct proto_desc *proto_find_desc(enum proto_desc_id desc_id)
diff --git a/src/scanner.l b/src/scanner.l
index 289b4d078855..2fc4c6c5e64a 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -623,6 +623,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "vxlan"			{ return VXLAN; }
 "vni"			{ return VNI; }
 
+"gre"			{ return GRE; }
+
 "tcp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_TCP); return TCP; }
 
 "dccp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_DCCP); return DCCP; }
-- 
2.30.2

