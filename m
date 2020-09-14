Return-Path: <SRS0=xYKs=CX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2514C43461
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Sep 2020 20:09:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ED57208DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Sep 2020 20:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgINUJA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Sep 2020 16:09:00 -0400
Received: from correo.us.es ([193.147.175.20]:55488 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbgINUI4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Sep 2020 16:08:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7121B4A7062
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2020 22:08:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5E7ACDA78B
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2020 22:08:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 53CD2DA78A; Mon, 14 Sep 2020 22:08:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D09EFDA78C
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2020 22:08:51 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 14 Sep 2020 22:08:51 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id BDED74301DE0
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2020 22:08:51 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] src: context tracking for multiple transport protocols
Date:   Mon, 14 Sep 2020 22:08:46 +0200
Message-Id: <20200914200846.31726-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200914200846.31726-1-pablo@netfilter.org>
References: <20200914200846.31726-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch extends the protocol context infrastructure to track multiple
transport protocols when they are specified from sets.

This removes errors like:

 "transport protocol mapping is only valid after transport protocol match"

when invoking:

 # nft add rule x z meta l4proto { tcp, udp } dnat to 1.1.1.1:80

This patch also catches conflicts like:

 # nft add rule x z ip protocol { tcp, udp } tcp dport 20 dnat to 1.1.1.1:80
 Error: conflicting protocols specified: udp vs. tcp
 add rule x z ip protocol { tcp, udp } tcp dport 20 dnat to 1.1.1.1:80
                                       ^^^^^^^^^
and:

 # nft add rule x z meta l4proto { tcp, udp } tcp dport 20 dnat to 1.1.1.1:80
 Error: conflicting protocols specified: udp vs. tcp
 add rule x z meta l4proto { tcp, udp } tcp dport 20 dnat to 1.1.1.1:80
                                        ^^^^^^^^^
Note that:

- the singleton protocol context tracker is left in place until the
  existing users are updated to use this new multiprotocol tracker.
  Moving forward, it would be good to consolidate things around this new
  multiprotocol context tracker infrastructure.

- link and network layers are not updated to use this infrastructure
  yet. The code that deals with vlan conflicts relies on forcing
  protocol context updates to the singleton protocol base.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h |  4 +++-
 include/proto.h      | 11 +++++++++
 src/ct.c             |  8 ++++---
 src/evaluate.c       | 14 +++++++++--
 src/expression.c     | 16 ++++++++++---
 src/meta.c           | 13 +++++-----
 src/payload.c        |  7 +++---
 src/proto.c          | 57 ++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 112 insertions(+), 18 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 130912a89e04..b039882cf1d1 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -167,7 +167,9 @@ struct expr_ops {
 	bool			(*cmp)(const struct expr *e1,
 				       const struct expr *e2);
 	void			(*pctx_update)(struct proto_ctx *ctx,
-					       const struct expr *expr);
+					       const struct location *loc,
+					       const struct expr *left,
+					       const struct expr *right);
 	int			(*build_udata)(struct nftnl_udata_buf *udbuf,
 					       const struct expr *expr);
 	struct expr *		(*parse_udata)(const struct nftnl_udata *ud);
diff --git a/include/proto.h b/include/proto.h
index 1771ba8e8d8c..304b048e4e60 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -152,6 +152,8 @@ struct dev_proto_desc {
 extern int proto_dev_type(const struct proto_desc *desc, uint16_t *res);
 extern const struct proto_desc *proto_dev_desc(uint16_t type);
 
+#define PROTO_CTX_NUM_PROTOS	16
+
 /**
  * struct proto_ctx - protocol context
  *
@@ -172,6 +174,11 @@ struct proto_ctx {
 		struct location			location;
 		const struct proto_desc		*desc;
 		unsigned int			offset;
+		struct {
+			struct location		location;
+			const struct proto_desc	*desc;
+		} protos[PROTO_CTX_NUM_PROTOS];
+		unsigned int			num_protos;
 	} protocol[PROTO_BASE_MAX + 1];
 };
 
@@ -180,6 +187,10 @@ extern void proto_ctx_init(struct proto_ctx *ctx, unsigned int family,
 extern void proto_ctx_update(struct proto_ctx *ctx, enum proto_bases base,
 			     const struct location *loc,
 			     const struct proto_desc *desc);
+bool proto_ctx_is_ambiguous(struct proto_ctx *ctx, enum proto_bases bases);
+const struct proto_desc *proto_ctx_find_conflict(struct proto_ctx *ctx,
+						 enum proto_bases base,
+						 const struct proto_desc *desc);
 extern const struct proto_desc *proto_find_upper(const struct proto_desc *base,
 						 unsigned int num);
 extern int proto_find_num(const struct proto_desc *base,
diff --git a/src/ct.c b/src/ct.c
index 0842c838b913..2218ecc7a684 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -351,9 +351,11 @@ static void ct_expr_clone(struct expr *new, const struct expr *expr)
 	new->ct = expr->ct;
 }
 
-static void ct_expr_pctx_update(struct proto_ctx *ctx, const struct expr *expr)
+static void ct_expr_pctx_update(struct proto_ctx *ctx,
+				const struct location *loc,
+				const struct expr *left,
+				const struct expr *right)
 {
-	const struct expr *left = expr->left, *right = expr->right;
 	const struct proto_desc *base = NULL, *desc;
 	uint32_t nhproto;
 
@@ -366,7 +368,7 @@ static void ct_expr_pctx_update(struct proto_ctx *ctx, const struct expr *expr)
 	if (!desc)
 		return;
 
-	proto_ctx_update(ctx, left->ct.base + 1, &expr->location, desc);
+	proto_ctx_update(ctx, left->ct.base + 1, loc, desc);
 }
 
 #define NFTNL_UDATA_CT_KEY 0
diff --git a/src/evaluate.c b/src/evaluate.c
index e3fe70624699..c8045e5ded72 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -710,6 +710,17 @@ static int __expr_evaluate_payload(struct eval_ctx *ctx, struct expr *expr)
 		return 0;
 	}
 
+	if (payload->payload.base == desc->base &&
+	    proto_ctx_is_ambiguous(&ctx->pctx, base)) {
+		desc = proto_ctx_find_conflict(&ctx->pctx, base, payload->payload.desc);
+		assert(desc);
+
+		return expr_error(ctx->msgs, payload,
+				  "conflicting protocols specified: %s vs. %s",
+				  desc->name,
+				  payload->payload.desc->name);
+	}
+
 	/* No conflict: Same payload protocol as context, adjust offset
 	 * if needed.
 	 */
@@ -1874,8 +1885,7 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 		 * Update protocol context for payload and meta iiftype
 		 * equality expressions.
 		 */
-		if (expr_is_singleton(right))
-			relational_expr_pctx_update(&ctx->pctx, rel);
+		relational_expr_pctx_update(&ctx->pctx, rel);
 
 		/* fall through */
 	case OP_NEQ:
diff --git a/src/expression.c b/src/expression.c
index fe529f98de7b..87bd4d01bb72 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -708,16 +708,26 @@ struct expr *relational_expr_alloc(const struct location *loc, enum ops op,
 void relational_expr_pctx_update(struct proto_ctx *ctx,
 				 const struct expr *expr)
 {
-	const struct expr *left = expr->left;
+	const struct expr *left = expr->left, *right = expr->right;
 	const struct expr_ops *ops;
+	const struct expr *i;
 
 	assert(expr->etype == EXPR_RELATIONAL);
 	assert(expr->op == OP_EQ || expr->op == OP_IMPLICIT);
 
 	ops = expr_ops(left);
 	if (ops->pctx_update &&
-	    (left->flags & EXPR_F_PROTOCOL))
-		ops->pctx_update(ctx, expr);
+	    (left->flags & EXPR_F_PROTOCOL)) {
+		if (expr_is_singleton(right))
+			ops->pctx_update(ctx, &expr->location, left, right);
+		else if (right->etype == EXPR_SET) {
+			list_for_each_entry(i, &right->expressions, list) {
+				if (i->etype == EXPR_SET_ELEM &&
+				    i->key->etype == EXPR_VALUE)
+					ops->pctx_update(ctx, &expr->location, left, i->key);
+			}
+		}
+	}
 }
 
 static void range_expr_print(const struct expr *expr, struct output_ctx *octx)
diff --git a/src/meta.c b/src/meta.c
index d92d0d323b9b..73d58b1f53b5 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -753,10 +753,11 @@ static void meta_expr_clone(struct expr *new, const struct expr *expr)
  * Update LL protocol context based on IIFTYPE meta match in non-LL hooks.
  */
 static void meta_expr_pctx_update(struct proto_ctx *ctx,
-				  const struct expr *expr)
+				  const struct location *loc,
+				  const struct expr *left,
+				  const struct expr *right)
 {
 	const struct hook_proto_desc *h = &hook_proto_desc[ctx->family];
-	const struct expr *left = expr->left, *right = expr->right;
 	const struct proto_desc *desc;
 	uint8_t protonum;
 
@@ -771,7 +772,7 @@ static void meta_expr_pctx_update(struct proto_ctx *ctx,
 		if (desc == NULL)
 			desc = &proto_unknown;
 
-		proto_ctx_update(ctx, PROTO_BASE_LL_HDR, &expr->location, desc);
+		proto_ctx_update(ctx, PROTO_BASE_LL_HDR, loc, desc);
 		break;
 	case NFT_META_NFPROTO:
 		protonum = mpz_get_uint8(right->value);
@@ -784,7 +785,7 @@ static void meta_expr_pctx_update(struct proto_ctx *ctx,
 				desc = h->desc;
 		}
 
-		proto_ctx_update(ctx, PROTO_BASE_NETWORK_HDR, &expr->location, desc);
+		proto_ctx_update(ctx, PROTO_BASE_NETWORK_HDR, loc, desc);
 		break;
 	case NFT_META_L4PROTO:
 		desc = proto_find_upper(&proto_inet_service,
@@ -792,7 +793,7 @@ static void meta_expr_pctx_update(struct proto_ctx *ctx,
 		if (desc == NULL)
 			desc = &proto_unknown;
 
-		proto_ctx_update(ctx, PROTO_BASE_TRANSPORT_HDR, &expr->location, desc);
+		proto_ctx_update(ctx, PROTO_BASE_TRANSPORT_HDR, loc, desc);
 		break;
 	case NFT_META_PROTOCOL:
 		if (h->base != PROTO_BASE_LL_HDR)
@@ -806,7 +807,7 @@ static void meta_expr_pctx_update(struct proto_ctx *ctx,
 		if (desc == NULL)
 			desc = &proto_unknown;
 
-		proto_ctx_update(ctx, PROTO_BASE_NETWORK_HDR, &expr->location, desc);
+		proto_ctx_update(ctx, PROTO_BASE_NETWORK_HDR, loc, desc);
 		break;
 	default:
 		break;
diff --git a/src/payload.c b/src/payload.c
index 29242537237e..ca422d5bcd56 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -80,9 +80,10 @@ static void payload_expr_clone(struct expr *new, const struct expr *expr)
  * Update protocol context for relational payload expressions.
  */
 static void payload_expr_pctx_update(struct proto_ctx *ctx,
-				     const struct expr *expr)
+				     const struct location *loc,
+				     const struct expr *left,
+				     const struct expr *right)
 {
-	const struct expr *left = expr->left, *right = expr->right;
 	const struct proto_desc *base, *desc;
 	unsigned int proto = 0;
 
@@ -102,7 +103,7 @@ static void payload_expr_pctx_update(struct proto_ctx *ctx,
 		assert(base->length > 0);
 		ctx->protocol[base->base].offset += base->length;
 	}
-	proto_ctx_update(ctx, desc->base, &expr->location, desc);
+	proto_ctx_update(ctx, desc->base, loc, desc);
 }
 
 #define NFTNL_UDATA_SET_KEY_PAYLOAD_DESC 0
diff --git a/src/proto.c b/src/proto.c
index 7d001501d7d2..7de2bbf91ae4 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -193,12 +193,69 @@ void proto_ctx_update(struct proto_ctx *ctx, enum proto_bases base,
 		      const struct location *loc,
 		      const struct proto_desc *desc)
 {
+	bool found = false;
+	unsigned int i;
+
+	switch (base) {
+	case PROTO_BASE_LL_HDR:
+	case PROTO_BASE_NETWORK_HDR:
+		break;
+	case PROTO_BASE_TRANSPORT_HDR:
+		if (ctx->protocol[base].num_protos >= PROTO_CTX_NUM_PROTOS)
+			break;
+
+		for (i = 0; i < ctx->protocol[base].num_protos; i++) {
+			if (ctx->protocol[base].protos[i].desc == desc) {
+				found = true;
+				break;
+			}
+		}
+		if (!found) {
+			i = ctx->protocol[base].num_protos++;
+			ctx->protocol[base].protos[i].desc = desc;
+			ctx->protocol[base].protos[i].location = *loc;
+		}
+		break;
+	default:
+		BUG("unknown protocol base %d", base);
+	}
+
 	ctx->protocol[base].location	= *loc;
 	ctx->protocol[base].desc	= desc;
 
 	proto_ctx_debug(ctx, base, ctx->debug_mask);
 }
 
+bool proto_ctx_is_ambiguous(struct proto_ctx *ctx, enum proto_bases base)
+{
+	return ctx->protocol[base].num_protos > 1;
+}
+
+const struct proto_desc *proto_ctx_find_conflict(struct proto_ctx *ctx,
+						 enum proto_bases base,
+						 const struct proto_desc *desc)
+{
+	unsigned int i;
+
+	switch (base) {
+	case PROTO_BASE_LL_HDR:
+	case PROTO_BASE_NETWORK_HDR:
+		if (desc != ctx->protocol[base].desc)
+			return ctx->protocol[base].desc;
+		break;
+	case PROTO_BASE_TRANSPORT_HDR:
+		for (i = 0; i < ctx->protocol[base].num_protos; i++) {
+			if (desc != ctx->protocol[base].protos[i].desc)
+				return ctx->protocol[base].protos[i].desc;
+		}
+		break;
+	default:
+		BUG("unknown protocol base %d", base);
+	}
+
+	return NULL;
+}
+
 #define HDR_TEMPLATE(__name, __dtype, __type, __member)			\
 	PROTO_HDR_TEMPLATE(__name, __dtype,				\
 			   BYTEORDER_BIG_ENDIAN,			\
-- 
2.20.1

