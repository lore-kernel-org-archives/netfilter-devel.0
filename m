From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/7,v2] src: fix sub-byte protocol header definitions
Date: Sat,  5 Dec 2015 20:04:21 +0100
Message-ID: <1449342266-2756-2-git-send-email-pablo@netfilter.org>
References: <1449342266-2756-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51087 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbbLETEk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Dec 2015 14:04:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 4947FDA870
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Dec 2015 20:04:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 354DBDA807
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Dec 2015 20:04:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1F85DDA803
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Dec 2015 20:04:36 +0100 (CET)
In-Reply-To: <1449342266-2756-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Update bitfield definitions to match according to the way they are
expressed in RFC and IEEE specifications.

This required a bit of update for c3f0501 ("src: netlink_linearize:
handle sub-byte lengths").

>From the linearize step, to calculate the shift based on the bitfield
offset, we need to obtain the length of the word in bytes:

	len = round_up(expr->len, BITS_PER_BYTE);

Then, we substract the offset bits and the bitfield length.

        shift = len - (offset + expr->len);

>From the delinearize, payload_expr_trim() needs to obtain the real
offset through:

	off = round_up(mask->len, BITS_PER_BYTE) - mask_len;

For vlan id (offset 12), this gets the position of the last bit set in
the mask (ie. 12), then we substract the length we fetch in bytes (16),
so we obtain the real bitfield offset (4).

Then, we add that to the original payload offset that was expressed in
bytes:

	payload_offset += off;

Note that payload_expr_trim() now also adjusts the payload expression to
its real length and offset so we don't need to propagate the mask
expression.

Reported-by: Patrick McHardy <kaber@trash.net>>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: Get rid of payload_expr_expand() change.
    Fully adjust payload expression for payload_trim_expr()
    Use mask_length() instead of mpz_fls()

 include/payload.h         |  3 +--
 include/proto.h           |  4 ++--
 include/utils.h           |  1 +
 src/netlink_delinearize.c | 23 ++++++++++-------------
 src/netlink_linearize.c   | 35 ++++++++++++++++++++++-------------
 src/payload.c             | 32 ++++++++++++++++++--------------
 src/proto.c               | 17 +++++++++--------
 7 files changed, 63 insertions(+), 52 deletions(-)

diff --git a/include/payload.h b/include/payload.h
index ca9b013..9192d6e 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -20,9 +20,8 @@ extern struct expr *payload_expr_join(const struct expr *e1,
 				      const struct expr *e2);
 
 bool payload_expr_trim(struct expr *expr, struct expr *mask,
-		       const struct proto_ctx *ctx);
+		       const struct proto_ctx *ctx, unsigned int *shift);
 extern void payload_expr_expand(struct list_head *list, struct expr *expr,
-				struct expr *mask,
 				const struct proto_ctx *ctx);
 extern void payload_expr_complete(struct expr *expr,
 				  const struct proto_ctx *ctx);
diff --git a/include/proto.h b/include/proto.h
index 974116f..d90bccd 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -159,9 +159,9 @@ enum eth_hdr_fields {
 
 enum vlan_hdr_fields {
 	VLANHDR_INVALID,
-	VLANHDR_VID,
-	VLANHDR_CFI,
 	VLANHDR_PCP,
+	VLANHDR_CFI,
+	VLANHDR_VID,
 	VLANHDR_TYPE,
 };
 
diff --git a/include/utils.h b/include/utils.h
index e94ae81..8a1dc5e 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -69,6 +69,7 @@
 #define field_sizeof(t, f)	(sizeof(((t *)NULL)->f))
 #define array_size(arr)		(sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 #define div_round_up(n, d)	(((n) + (d) - 1) / (d))
+#define round_up(n, b)		(div_round_up(n, b) * b)
 
 #define min(x, y) ({				\
 	typeof(x) _min1 = (x);			\
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 3e1f912..e5cee16 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -998,8 +998,7 @@ static void integer_type_postprocess(struct expr *expr)
 
 static void payload_match_expand(struct rule_pp_ctx *ctx,
 				 struct expr *expr,
-				 struct expr *payload,
-				 struct expr *mask)
+				 struct expr *payload)
 {
 	struct expr *left = payload, *right = expr->right, *tmp;
 	struct list_head list = LIST_HEAD_INIT(list);
@@ -1008,7 +1007,7 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 	enum proto_bases base = left->payload.base;
 	const struct expr_ops *payload_ops = left->ops;
 
-	payload_expr_expand(&list, left, mask, &ctx->pctx);
+	payload_expr_expand(&list, left, &ctx->pctx);
 
 	list_for_each_entry(left, &list, list) {
 		tmp = constant_expr_splice(right, left->len);
@@ -1063,8 +1062,7 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 
 static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 				      struct expr *expr,
-				      struct expr *payload,
-				      struct expr *mask)
+				      struct expr *payload)
 {
 	enum proto_bases base = payload->payload.base;
 
@@ -1075,7 +1073,7 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 	case OP_EQ:
 	case OP_NEQ:
 		if (expr->right->ops->type == EXPR_VALUE) {
-			payload_match_expand(ctx, expr, payload, mask);
+			payload_match_expand(ctx, expr, payload);
 			break;
 		}
 		/* Fall through */
@@ -1190,6 +1188,7 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *e
 		   binop->right->ops->type == EXPR_VALUE) {
 		struct expr *payload = binop->left;
 		struct expr *mask = binop->right;
+		unsigned int shift;
 
 		/*
 		 * This *might* be a payload match testing header fields that
@@ -1214,7 +1213,7 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *e
 		 * payload_expr_trim will figure out if the mask is needed to match
 		 * templates.
 		 */
-		if (payload_expr_trim(payload, mask, &ctx->pctx)) {
+		if (payload_expr_trim(payload, mask, &ctx->pctx, &shift)) {
 			/* mask is implicit, binop needs to be removed.
 			 *
 			 * Fix all values of the expression according to the mask
@@ -1226,13 +1225,11 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *e
 			 */
 			if (value->ops->type == EXPR_VALUE) {
 				assert(value->len >= expr->left->right->len);
-				value->len = mask->len;
+				mpz_rshift_ui(value->value, shift);
+				value->len = payload->len;
 			}
 
-			payload->len = mask->len;
-			payload->payload.offset += mpz_scan1(mask->value, 0);
-
-			payload_match_postprocess(ctx, expr, payload, mask);
+			payload_match_postprocess(ctx, expr, payload);
 
 			assert(expr->left->ops->type == EXPR_BINOP);
 
@@ -1383,7 +1380,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 	case EXPR_RELATIONAL:
 		switch (expr->left->ops->type) {
 		case EXPR_PAYLOAD:
-			payload_match_postprocess(ctx, expr, expr->left, NULL);
+			payload_match_postprocess(ctx, expr, expr->left);
 			return;
 		default:
 			expr_postprocess(ctx, &expr->left);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 0790dce..131c3f9 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -103,27 +103,37 @@ static void netlink_gen_concat(struct netlink_linearize_ctx *ctx,
 	}
 }
 
+static unsigned int payload_shift_calc(const struct expr *expr)
+{
+	unsigned int offset, len;
+	int shift;
+
+	offset = expr->payload.offset % BITS_PER_BYTE;
+	len = round_up(expr->len, BITS_PER_BYTE);
+	shift = len - (offset + expr->len);
+	assert(shift >= 0);
+
+	return shift;
+}
+
 static void netlink_gen_payload_mask(struct netlink_linearize_ctx *ctx,
 				     const struct expr *expr,
 				     enum nft_registers dreg)
 {
 	struct nft_data_linearize nld, zero = {};
+	unsigned int shift, len, masklen;
 	struct nftnl_expr *nle;
-	unsigned int offset, len, masklen;
 	mpz_t mask;
 
-	offset = expr->payload.offset % BITS_PER_BYTE;
-	masklen = expr->len + offset;
-
-	if (masklen > 128)
-		BUG("expr mask length is %u (len %u, offset %u)\n",
-				masklen, expr->len, offset);
+	shift = payload_shift_calc(expr);
+	if (!shift && expr->payload.offset % BITS_PER_BYTE == 0)
+		return;
 
+	masklen = expr->len + shift;
+	assert(masklen <= NFT_REG_SIZE * BITS_PER_BYTE);
 	mpz_init2(mask, masklen);
 	mpz_bitmask(mask, expr->len);
-
-	if (offset)
-		mpz_lshift_ui(mask, offset);
+	mpz_lshift_ui(mask, shift);
 
 	nle = alloc_nft_expr("bitwise");
 
@@ -158,8 +168,7 @@ static void netlink_gen_payload(struct netlink_linearize_ctx *ctx,
 
 	nftnl_rule_add_expr(ctx->nlr, nle);
 
-	if (expr->len % BITS_PER_BYTE)
-		netlink_gen_payload_mask(ctx, expr, dreg);
+	netlink_gen_payload_mask(ctx, expr, dreg);
 }
 
 static void netlink_gen_exthdr(struct netlink_linearize_ctx *ctx,
@@ -287,7 +296,7 @@ static void payload_shift_value(const struct expr *left, struct expr *right)
 	    left->ops->type != EXPR_PAYLOAD)
 		return;
 
-	mpz_lshift_ui(right->value, left->payload.offset % BITS_PER_BYTE);
+	mpz_lshift_ui(right->value, payload_shift_calc(left));
 }
 
 static struct expr *netlink_gen_prefix(struct netlink_linearize_ctx *ctx,
diff --git a/src/payload.c b/src/payload.c
index a97041e..fe91ee0 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -339,18 +339,21 @@ static unsigned int mask_length(const struct expr *mask)
  * Walk the template list and determine if a match can be found without
  * using the provided mask.
  *
- * If the mask has to be used, trim the mask length accordingly
- * and return true to let the caller know that the mask is a dependency.
+ * If the mask has to be used, trim the payload expression length accordingly,
+ * adjust the payload offset and return true to let the caller know that the
+ * mask can be removed. This function also returns the shift for the right hand
+ * constant side of the expression.
  */
 bool payload_expr_trim(struct expr *expr, struct expr *mask,
-		       const struct proto_ctx *ctx)
+		       const struct proto_ctx *ctx, unsigned int *shift)
 {
-	unsigned int payload_offset = expr->payload.offset + mask_to_offset(mask);
+	unsigned int payload_offset = expr->payload.offset;
+	unsigned int mask_offset = mask_to_offset(mask);
 	unsigned int mask_len = mask_length(mask);
 	const struct proto_hdr_template *tmpl;
 	unsigned int payload_len = expr->len;
 	const struct proto_desc *desc;
-	unsigned int i, matched_len = mask_to_offset(mask);
+	unsigned int off, i, len = 0;
 
 	assert(expr->ops->type == EXPR_PAYLOAD);
 
@@ -365,6 +368,9 @@ bool payload_expr_trim(struct expr *expr, struct expr *mask,
 		payload_offset -= ctx->protocol[expr->payload.base].offset;
 	}
 
+	off = round_up(mask->len, BITS_PER_BYTE) - mask_len;
+	payload_offset += off;
+
 	for (i = 1; i < array_size(desc->templates); i++) {
 		tmpl = &desc->templates[i];
 		if (tmpl->offset != payload_offset)
@@ -374,14 +380,15 @@ bool payload_expr_trim(struct expr *expr, struct expr *mask,
 			return false;
 
 		payload_len -= tmpl->len;
-		matched_len += tmpl->len;
 		payload_offset += tmpl->len;
+		len += tmpl->len;
 		if (payload_len == 0)
 			return false;
 
-		if (matched_len == mask_len) {
-			assert(mask->len >= mask_len);
-			mask->len = mask_len;
+		if (mask_offset + len == mask_len) {
+			expr->payload.offset += off;
+			expr->len = len;
+			*shift = mask_offset;
 			return true;
 		}
 	}
@@ -395,7 +402,6 @@ bool payload_expr_trim(struct expr *expr, struct expr *mask,
  *
  * @list:	list to append expanded payload expressions to
  * @expr:	the payload expression to expand
- * @mask:	optional/implicit mask to use when searching templates
  * @ctx:	protocol context
  *
  * Expand a merged adjacent payload expression into its original components
@@ -405,16 +411,14 @@ bool payload_expr_trim(struct expr *expr, struct expr *mask,
  * 	 offset order.
  */
 void payload_expr_expand(struct list_head *list, struct expr *expr,
-			 struct expr *mask, const struct proto_ctx *ctx)
+			 const struct proto_ctx *ctx)
 {
-	unsigned int off = mask_to_offset(mask);
 	const struct proto_hdr_template *tmpl;
 	const struct proto_desc *desc;
 	struct expr *new;
 	unsigned int i;
 
 	assert(expr->ops->type == EXPR_PAYLOAD);
-	assert(!mask || mask->len != 0);
 
 	desc = ctx->protocol[expr->payload.base].desc;
 	if (desc == NULL)
@@ -431,7 +435,7 @@ void payload_expr_expand(struct list_head *list, struct expr *expr,
 			list_add_tail(&new->list, list);
 			expr->len	     -= tmpl->len;
 			expr->payload.offset += tmpl->len;
-			if (expr->len == off)
+			if (expr->len == 0)
 				return;
 		} else
 			break;
diff --git a/src/proto.c b/src/proto.c
index 0fe0b88..68d635f 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -407,9 +407,9 @@ const struct proto_desc proto_tcp = {
 		[TCPHDR_SEQ]		= TCPHDR_FIELD("sequence", seq),
 		[TCPHDR_ACKSEQ]		= TCPHDR_FIELD("ackseq", ack_seq),
 		[TCPHDR_DOFF]		= HDR_BITFIELD("doff", &integer_type,
-						       (12 * BITS_PER_BYTE) + 4, 4),
+						       (12 * BITS_PER_BYTE), 4),
 		[TCPHDR_RESERVED]	= HDR_BITFIELD("reserved", &integer_type,
-						       (12 * BITS_PER_BYTE) + 0, 4),
+						       (12 * BITS_PER_BYTE) + 4, 4),
 		[TCPHDR_FLAGS]		= HDR_BITFIELD("flags", &tcp_flag_type,
 						       13 * BITS_PER_BYTE,
 						       BITS_PER_BYTE),
@@ -459,7 +459,8 @@ const struct proto_desc proto_dccp = {
 	.templates	= {
 		[DCCPHDR_SPORT]		= INET_SERVICE("sport", struct dccp_hdr, dccph_sport),
 		[DCCPHDR_DPORT]		= INET_SERVICE("dport", struct dccp_hdr, dccph_dport),
-		[DCCPHDR_TYPE]		= HDR_BITFIELD("type", &dccp_pkttype_type, 67, 4),
+		[DCCPHDR_TYPE]		= HDR_BITFIELD("type", &dccp_pkttype_type,
+						       (8 * BITS_PER_BYTE) + 3, 4),
 	},
 };
 
@@ -508,8 +509,8 @@ const struct proto_desc proto_ip = {
 		PROTO_LINK(IPPROTO_SCTP,	&proto_sctp),
 	},
 	.templates	= {
-		[IPHDR_VERSION]		= HDR_BITFIELD("version", &integer_type, 4, 4),
-		[IPHDR_HDRLENGTH]	= HDR_BITFIELD("hdrlength", &integer_type, 0, 4),
+		[IPHDR_VERSION]		= HDR_BITFIELD("version", &integer_type, 0, 4),
+		[IPHDR_HDRLENGTH]	= HDR_BITFIELD("hdrlength", &integer_type, 4, 4),
 		[IPHDR_TOS]		= IPHDR_FIELD("tos",		tos),
 		[IPHDR_LENGTH]		= IPHDR_FIELD("length",		tot_len),
 		[IPHDR_ID]		= IPHDR_FIELD("id",		id),
@@ -730,9 +731,9 @@ const struct proto_desc proto_vlan = {
 
 	},
 	.templates	= {
-		[VLANHDR_VID]		= VLANHDR_BITFIELD("id", 0, 12),
-		[VLANHDR_CFI]		= VLANHDR_BITFIELD("cfi", 12, 1),
-		[VLANHDR_PCP]		= VLANHDR_BITFIELD("pcp", 13, 3),
+		[VLANHDR_PCP]		= VLANHDR_BITFIELD("pcp", 0, 3),
+		[VLANHDR_CFI]		= VLANHDR_BITFIELD("cfi", 3, 1),
+		[VLANHDR_VID]		= VLANHDR_BITFIELD("id", 4, 12),
 		[VLANHDR_TYPE]		= VLANHDR_TYPE("type", &ethertype_type, vlan_type),
 	},
 };
-- 
2.1.4

