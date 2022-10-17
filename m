Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1B63C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Oct 2022 11:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiJQLE2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Oct 2022 07:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiJQLEW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2022 07:04:22 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B653BE9
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2022 04:04:19 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 08/16] src: add gre support
Date:   Mon, 17 Oct 2022 13:04:00 +0200
Message-Id: <20221017110408.742223-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221017110408.742223-1-pablo@netfilter.org>
References: <20221017110408.742223-1-pablo@netfilter.org>
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
 include/parser.h          |  1 +
 include/payload.h         |  2 ++
 include/proto.h           | 14 ++++++++++++
 src/evaluate.c            | 43 +++++++++++++++++++++++++----------
 src/netlink_delinearize.c | 48 +++++++++++++++++++++++++++++++++++++++
 src/parser_bison.y        | 33 ++++++++++++++++++++++++---
 src/payload.c             | 47 ++++++++++++++++++++++++++++++++++++++
 src/proto.c               | 27 ++++++++++++++++++++++
 src/scanner.l             |  7 ++++--
 9 files changed, 205 insertions(+), 17 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index f55da0fd47bf..5c62e1b17d30 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -37,6 +37,7 @@ enum startcond_type {
 	PARSER_SC_CT,
 	PARSER_SC_COUNTER,
 	PARSER_SC_ETH,
+	PARSER_SC_GRE,
 	PARSER_SC_ICMP,
 	PARSER_SC_IGMP,
 	PARSER_SC_IP,
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
index 32e0744854a5..4b0c71467638 100644
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
@@ -396,7 +397,20 @@ enum vxlan_hdr_fields {
 	VXLANHDR_FLAGS,
 };
 
+struct grehdr {
+	uint16_t flags;
+	uint16_t protocol;
+};
+
+enum gre_hdr_fields {
+	GREHDR_INVALID,
+	GREHDR_VERSION,
+	GREHDR_FLAGS,
+	GREHDR_PROTOCOL,
+};
+
 extern const struct proto_desc proto_vxlan;
+extern const struct proto_desc proto_gre;
 
 extern const struct proto_desc proto_icmp;
 extern const struct proto_desc proto_igmp;
diff --git a/src/evaluate.c b/src/evaluate.c
index 19a232abf431..173de6b67700 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -860,24 +860,43 @@ static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **exprp)
 static int expr_evaluate_inner(struct eval_ctx *ctx, struct expr **exprp)
 {
 	struct proto_ctx *pctx = eval_proto_ctx(ctx);
-	const struct proto_desc *desc;
+	const struct proto_desc *desc = NULL;
 	struct expr *expr = *exprp;
 	int ret;
 
-	desc = pctx->protocol[expr->payload.inner_desc->base - 1].desc;
-	if (!desc) {
-		return expr_error(ctx->msgs, expr,
-				  "no transport protocol specified");
-	}
+	assert(expr->etype == EXPR_PAYLOAD);
 
-	if (proto_find_num(desc, expr->payload.inner_desc) < 0) {
-		return expr_error(ctx->msgs, expr,
-				  "unexpected transport protocol %s",
-				  desc->name);
+	pctx = eval_proto_ctx(ctx);
+	desc = pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc;
+
+	if (desc == NULL &&
+	    expr->payload.inner_desc->base < PROTO_BASE_INNER_HDR) {
+		struct stmt *nstmt;
+
+		if (payload_gen_inner_dependency(ctx, expr, &nstmt) < 0)
+			return -1;
+
+		rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
+
+		proto_ctx_update(pctx, PROTO_BASE_TRANSPORT_HDR, &expr->location, expr->payload.inner_desc);
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
index 54f140c48a13..fbabb7d2203d 100644
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
+	struct stmt *stmt = dl_outer->pdctx.pdeps[expr->payload.inner_desc->base];
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
+		if (expr->payload.inner_desc == &proto_gre)
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
+			if (meta_outer_may_dependency_kill(ctx, expr->left)) {
+				struct dl_proto_ctx *dl_outer = dl_proto_ctx_outer(ctx);
+
+				payload_dependency_release(&dl_outer->pdctx, expr->left->payload.inner_desc->base);
+			}
 		}
 
 		if (payload_is_stacked(dl->pctx.protocol[base].desc, nexpr))
@@ -2739,6 +2780,13 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		break;
 	case EXPR_PAYLOAD:
 		payload_expr_complete(expr, &dl->pctx);
+		if (expr->payload.inner_desc) {
+			if (meta_outer_may_dependency_kill(ctx, expr)) {
+				struct dl_proto_ctx *dl_outer = dl_proto_ctx_outer(ctx);
+
+				payload_dependency_release(&dl_outer->pdctx, expr->payload.inner_desc->base);
+			}
+		}
 		payload_dependency_kill(&dl->pdctx, expr, dl->pctx.family);
 		break;
 	case EXPR_VALUE:
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 213254ecc5f0..9273a09a3727 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -442,6 +442,8 @@ int nft_lex(void *, void *, void *);
 %token VXLAN			"vxlan"
 %token VNI			"vni"
 
+%token GRE			"gre"
+
 %token SCTP			"sctp"
 %token CHUNK			"chunk"
 %token DATA			"data"
@@ -900,9 +902,9 @@ int nft_lex(void *, void *, void *);
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
@@ -962,6 +964,7 @@ close_scope_export	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CMD_EXPORT
 close_scope_fib		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_FIB); };
 close_scope_frag	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_FRAG); };
 close_scope_fwd		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STMT_FWD); };
+close_scope_gre		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_GRE); };
 close_scope_hash	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_HASH); };
 close_scope_hbh		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_HBH); };
 close_scope_ip		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_IP); };
@@ -4863,6 +4866,13 @@ primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
 							 BYTEORDER_HOST_ENDIAN,
 							 sizeof(data) * BITS_PER_BYTE, &data);
 			}
+			|	GRE close_scope_gre
+			{
+				uint8_t data = IPPROTO_GRE;
+				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 sizeof(data) * BITS_PER_BYTE, &data);
+			}
 			|	COMP	close_scope_comp
 			{
 				uint8_t data = IPPROTO_COMP;
@@ -5319,6 +5329,7 @@ payload_expr		:	payload_raw_expr
 			|	sctp_hdr_expr
 			|	th_hdr_expr
 			|	vxlan_hdr_expr
+			|	gre_hdr_expr
 			;
 
 payload_raw_expr	:	AT	payload_base_spec	COMMA	NUM	COMMA	NUM	close_scope_at
@@ -5615,6 +5626,22 @@ vxlan_hdr_field		:	VNI			{ $$ = VXLANHDR_VNI; }
 			|	FLAGS			{ $$ = VXLANHDR_FLAGS; }
 			;
 
+gre_hdr_expr		:	GRE	gre_hdr_field	close_scope_gre
+			{
+				$$ = payload_expr_alloc(&@$, &proto_gre, $2);
+			}
+			|	GRE	close_scope_gre inner_inet_expr
+			{
+				$$ = $3;
+				$$->payload.inner_desc = &proto_gre;
+			}
+			;
+
+gre_hdr_field		:	HDRVERSION		{ $$ = GREHDR_VERSION;	}
+			|	FLAGS			{ $$ = GREHDR_FLAGS; }
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
index e6c1100bb448..3bb4ae74a439 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -90,6 +90,7 @@ int proto_find_num(const struct proto_desc *base,
 
 static const struct proto_desc *inner_protocols[] = {
 	&proto_vxlan,
+	&proto_gre,
 };
 
 const struct proto_desc *proto_find_inner(uint32_t type, uint32_t hdrsize,
@@ -771,6 +772,28 @@ const struct datatype ecn_type = {
 	.sym_tbl	= &ecn_type_tbl,
 };
 
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
+		[GREHDR_FLAGS]		= HDR_BITFIELD("flags", &integer_type, 0, 5),
+		[GREHDR_VERSION]	= HDR_BITFIELD("version", &integer_type, 13, 3),
+		[GREHDR_PROTOCOL]	= HDR_BITFIELD("protocol", &ethertype_type, 16, 16),
+	},
+	.inner		= {
+		.hdrsize	= sizeof(struct grehdr),
+		.flags		= NFT_INNER_NH | NFT_INNER_TH,
+		.type		= NFT_INNER_GENEVE + 1,
+	},
+};
+
 #define IPHDR_FIELD(__name, __member) \
 	HDR_FIELD(__name, struct iphdr, __member)
 #define IPHDR_ADDR(__name, __member) \
@@ -794,6 +817,7 @@ const struct proto_desc proto_ip = {
 		PROTO_LINK(IPPROTO_TCP,		&proto_tcp),
 		PROTO_LINK(IPPROTO_DCCP,	&proto_dccp),
 		PROTO_LINK(IPPROTO_SCTP,	&proto_sctp),
+		PROTO_LINK(IPPROTO_GRE,		&proto_gre),
 	},
 	.templates	= {
 		[0]	= PROTO_META_TEMPLATE("l4proto", &inet_protocol_type, NFT_META_L4PROTO, 8),
@@ -920,6 +944,7 @@ const struct proto_desc proto_ip6 = {
 		PROTO_LINK(IPPROTO_ICMP,	&proto_icmp),
 		PROTO_LINK(IPPROTO_IGMP,	&proto_igmp),
 		PROTO_LINK(IPPROTO_ICMPV6,	&proto_icmp6),
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
index 289b4d078855..06ca4059f266 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -201,6 +201,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_CT
 %s SCANSTATE_COUNTER
 %s SCANSTATE_ETH
+%s SCANSTATE_GRE
 %s SCANSTATE_ICMP
 %s SCANSTATE_IGMP
 %s SCANSTATE_IP
@@ -491,7 +492,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 }
 
 "ip"			{ scanner_push_start_cond(yyscanner, SCANSTATE_IP); return IP; }
-<SCANSTATE_IP,SCANSTATE_IP6,SCANSTATE_EXPR_OSF>{
+<SCANSTATE_IP,SCANSTATE_IP6,SCANSTATE_EXPR_OSF,SCANSTATE_GRE>{
 	"version"		{ return HDRVERSION; }
 }
 <SCANSTATE_EXPR_AH,SCANSTATE_EXPR_DST,SCANSTATE_EXPR_HBH,SCANSTATE_EXPR_MH,SCANSTATE_EXPR_RT,SCANSTATE_IP>{
@@ -508,7 +509,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 <SCANSTATE_EXPR_OSF,SCANSTATE_IP>{
 	"ttl"			{ return TTL; }
 }
-<SCANSTATE_CT,SCANSTATE_IP,SCANSTATE_META,SCANSTATE_TYPE>"protocol"		{ return PROTOCOL; }
+<SCANSTATE_CT,SCANSTATE_IP,SCANSTATE_META,SCANSTATE_TYPE,SCANSTATE_GRE>"protocol"		{ return PROTOCOL; }
 <SCANSTATE_EXPR_MH,SCANSTATE_EXPR_UDP,SCANSTATE_EXPR_UDPLITE,SCANSTATE_ICMP,SCANSTATE_IGMP,SCANSTATE_IP,SCANSTATE_SCTP,SCANSTATE_TCP>{
 	"checksum"		{ return CHECKSUM; }
 }
@@ -623,6 +624,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "vxlan"			{ return VXLAN; }
 "vni"			{ return VNI; }
 
+"gre"			{ scanner_push_start_cond(yyscanner, SCANSTATE_GRE); return GRE; }
+
 "tcp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_TCP); return TCP; }
 
 "dccp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_DCCP); return DCCP; }
-- 
2.30.2

