From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 03/12] nft: allow stacking vlan header on top of ethernet
Date: Sun, 16 Aug 2015 21:05:46 +0200
Message-ID: <1439751955-31190-4-git-send-email-fw@strlen.de>
References: <1439751955-31190-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34744 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081AbbHPTGJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Aug 2015 15:06:09 -0400
In-Reply-To: <1439751955-31190-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

currently 'vlan id 42' or even 'vlan type ip' doesn't work since
we expect ethernet header but get vlan.

So if we want to add another protocol header to the same base, we
attempt to figure out if the new header can fit on top of the existing
one (i.e. proto_find_num gives a protocol number when asking to find
link between the two).

We also annotate protocol description for eth and vlan with the full
header size and track the offset from the current base.

Otherwise, 'vlan type ip' fetches the protocol field from mac header
offset 0, which is some mac address.

Instead, we must consider full size of ethernet header.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/proto.h           |  4 +++
 src/evaluate.c            | 78 ++++++++++++++++++++++++++++++++++++++++++++++-
 src/netlink_delinearize.c | 48 +++++++++++++++++++++++------
 src/payload.c             |  1 +
 src/proto.c               |  2 ++
 5 files changed, 123 insertions(+), 10 deletions(-)

diff --git a/include/proto.h b/include/proto.h
index 0e531b2..a43bf98 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -69,6 +69,7 @@ struct proto_hdr_template {
  * @name:	protocol name
  * @base:	header base
  * @protocol_key: key of template containing upper layer protocol description
+ * @length:	total size of the header, in bits
  * @protocols:	link to upper layer protocol descriptions indexed by protocol value
  * @templates:	header templates
  */
@@ -76,6 +77,7 @@ struct proto_desc {
 	const char			*name;
 	enum proto_bases		base;
 	unsigned int			protocol_key;
+	unsigned int			length;
 	struct {
 		unsigned int			num;
 		const struct proto_desc		*desc;
@@ -122,6 +124,7 @@ extern const struct proto_desc *proto_dev_desc(uint16_t type);
  * @family:	hook family
  * @location:	location of the relational expression defining the context
  * @desc:	protocol description for this layer
+ * @offset:	offset from the base, for stacked headers (eg 8*14 for vlan on top of ether)
  *
  * The location of the context is the location of the relational expression
  * defining it, either directly through a protocol match or indirectly
@@ -132,6 +135,7 @@ struct proto_ctx {
 	struct {
 		struct location			location;
 		const struct proto_desc		*desc;
+		unsigned int			offset;
 	} protocol[PROTO_BASE_MAX + 1];
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index d99b38f..c95d154 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -271,6 +271,82 @@ static int expr_evaluate_primary(struct eval_ctx *ctx, struct expr **expr)
 	return 0;
 }
 
+static int
+conflict_resolution_gen_dependency(struct eval_ctx *ctx, int protocol,
+				   const struct expr *expr,
+				   struct stmt **res)
+{
+	enum proto_bases base = expr->payload.base;
+	const struct proto_hdr_template *tmpl;
+	const struct proto_desc *desc = NULL;
+	struct expr *dep, *left, *right;
+	struct stmt *stmt;
+
+	assert(expr->payload.base == PROTO_BASE_LL_HDR);
+
+	desc = ctx->pctx.protocol[base].desc;
+	tmpl = &desc->templates[desc->protocol_key];
+	left = payload_expr_alloc(&expr->location, desc, desc->protocol_key);
+
+	right = constant_expr_alloc(&expr->location, tmpl->dtype,
+				    tmpl->dtype->byteorder, tmpl->len,
+				    constant_data_ptr(protocol, tmpl->len));
+
+	dep = relational_expr_alloc(&expr->location, OP_EQ, left, right);
+	stmt = expr_stmt_alloc(&dep->location, dep);
+	if (stmt_evaluate(ctx, stmt) < 0)
+		return expr_error(ctx->msgs, expr,
+					  "dependency statement is invalid");
+
+	ctx->pctx.protocol[base].desc = expr->payload.desc;
+	assert(ctx->pctx.protocol[base].offset == 0);
+
+	assert(desc->length);
+	ctx->pctx.protocol[base].offset += desc->length;
+
+	*res = stmt;
+	return 0;
+}
+
+static bool resolve_protocol_conflict(struct eval_ctx *ctx,
+				      struct expr *payload)
+{
+	const struct hook_proto_desc *h = &hook_proto_desc[ctx->pctx.family];
+	enum proto_bases base = payload->payload.base;
+	const struct proto_desc *desc;
+	struct stmt *nstmt = NULL;
+	int link;
+
+	desc = ctx->pctx.protocol[base].desc;
+
+	if (desc == payload->payload.desc) {
+		payload->payload.offset += ctx->pctx.protocol[base].offset;
+		return true;
+	}
+
+	if (payload->payload.base != h->base)
+		return false;
+
+	assert(desc->length);
+	if (base < PROTO_BASE_MAX) {
+		const struct proto_desc *next = ctx->pctx.protocol[base + 1].desc;
+
+		if (payload->payload.desc == next) {
+			payload->payload.offset += desc->length;
+			return true;
+		}
+	}
+
+	link = proto_find_num(desc, payload->payload.desc);
+	if (link < 0 || conflict_resolution_gen_dependency(ctx, link, payload, &nstmt) < 0)
+		return false;
+
+	payload->payload.offset += ctx->pctx.protocol[base].offset;
+	list_add_tail(&nstmt->list, &ctx->stmt->list);
+
+	return true;
+}
+
 /*
  * Payload expression: check whether dependencies are fulfilled, otherwise
  * generate the necessary relational expression and prepend it to the current
@@ -286,7 +362,7 @@ static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **expr)
 		if (payload_gen_dependency(ctx, payload, &nstmt) < 0)
 			return -1;
 		list_add_tail(&nstmt->list, &ctx->stmt->list);
-	} else if (ctx->pctx.protocol[base].desc != payload->payload.desc)
+	} else if (!resolve_protocol_conflict(ctx, payload))
 		return expr_error(ctx->msgs, payload,
 				  "conflicting protocols specified: %s vs. %s",
 				  ctx->pctx.protocol[base].desc->name,
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 4226b82..76c07c5 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -923,7 +923,9 @@ static void payload_match_expand(struct rule_pp_ctx *ctx, struct expr *expr)
 	struct expr *left = expr->left, *right = expr->right, *tmp;
 	struct list_head list = LIST_HEAD_INIT(list);
 	struct stmt *nstmt;
-	struct expr *nexpr;
+	struct expr *nexpr = NULL;
+	enum proto_bases base = left->payload.base;
+	const struct expr_ops *payload_ops = left->ops;
 
 	payload_expr_expand(&list, left, &ctx->pctx);
 	list_for_each_entry(left, &list, list) {
@@ -940,17 +942,39 @@ static void payload_match_expand(struct rule_pp_ctx *ctx, struct expr *expr)
 		nstmt = expr_stmt_alloc(&ctx->stmt->location, nexpr);
 		list_add_tail(&nstmt->list, &ctx->stmt->list);
 
+		assert(left->ops == payload_ops);
+		assert(left->payload.base);
+		assert(base == left->payload.base);
+
 		/* Remember the first payload protocol expression to
 		 * kill it later on if made redundant by a higher layer
 		 * payload expression.
 		 */
 		if (ctx->pbase == PROTO_BASE_INVALID &&
-		    left->flags & EXPR_F_PROTOCOL)
-			payload_dependency_store(ctx, nstmt,
-						 left->payload.base);
-		else
+		    left->flags & EXPR_F_PROTOCOL) {
+			unsigned int proto = mpz_get_be16(tmp->value);
+			const struct proto_desc *desc, *next;
+			bool stacked_header = false;
+
+			desc = ctx->pctx.protocol[base].desc;
+			assert(desc);
+			if (desc) {
+				next = proto_find_upper(desc, proto);
+				stacked_header = next && next->base == base;
+			}
+
+			if (stacked_header) {
+				ctx->pctx.protocol[base].desc = next;
+				ctx->pctx.protocol[base].offset += desc->length;
+				payload_dependency_store(ctx, nstmt, base - 1);
+			} else {
+				payload_dependency_store(ctx, nstmt, base);
+			}
+		} else {
 			payload_dependency_kill(ctx, nexpr->left);
+		}
 	}
+
 	list_del(&ctx->stmt->list);
 	stmt_free(ctx->stmt);
 	ctx->stmt = NULL;
@@ -959,6 +983,12 @@ static void payload_match_expand(struct rule_pp_ctx *ctx, struct expr *expr)
 static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 				      struct expr *expr)
 {
+	enum proto_bases base = expr->left->payload.base;
+	struct expr *payload = expr->left;
+
+	assert(payload->payload.offset >= ctx->pctx.protocol[base].offset);
+	payload->payload.offset -= ctx->pctx.protocol[base].offset;
+
 	switch (expr->op) {
 	case OP_EQ:
 	case OP_NEQ:
@@ -968,10 +998,10 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 		}
 		/* Fall through */
 	default:
-		payload_expr_complete(expr->left, &ctx->pctx);
-		expr_set_type(expr->right, expr->left->dtype,
-			      expr->left->byteorder);
-		payload_dependency_kill(ctx, expr->left);
+		payload_expr_complete(payload, &ctx->pctx);
+		expr_set_type(expr->right, payload->dtype,
+			      payload->byteorder);
+		payload_dependency_kill(ctx, payload);
 		break;
 	}
 }
diff --git a/src/payload.c b/src/payload.c
index 5f8c4fe..bd574ee 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -340,6 +340,7 @@ void payload_expr_expand(struct list_head *list, struct expr *expr,
 		} else
 			break;
 	}
+
 raw:
 	new = payload_expr_alloc(&expr->location, NULL, 0);
 	payload_init_raw(new, expr->payload.base, expr->payload.offset,
diff --git a/src/proto.c b/src/proto.c
index 6302016..27ab4a2 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -713,6 +713,7 @@ const struct proto_desc proto_vlan = {
 	.name		= "vlan",
 	.base		= PROTO_BASE_LL_HDR,
 	.protocol_key	= VLANHDR_TYPE,
+	.length		= sizeof(struct vlan_hdr) * BITS_PER_BYTE,
 	.protocols	= {
 		PROTO_LINK(__constant_htons(ETH_P_IP),		&proto_ip),
 		PROTO_LINK(__constant_htons(ETH_P_ARP),		&proto_arp),
@@ -782,6 +783,7 @@ const struct proto_desc proto_eth = {
 	.name		= "ether",
 	.base		= PROTO_BASE_LL_HDR,
 	.protocol_key	= ETHHDR_TYPE,
+	.length		= sizeof(struct ether_header) * BITS_PER_BYTE,
 	.protocols	= {
 		PROTO_LINK(__constant_htons(ETH_P_IP),		&proto_ip),
 		PROTO_LINK(__constant_htons(ETH_P_ARP),		&proto_arp),
-- 
2.0.5

