Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43704F1E3
	for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2024 12:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705668446; cv=none; b=Aepx07PUIs1OS2dH5a0Atbq4+9mWxaTPlO33qr5Vhce5uOqz65c/YOQCbxeJlWyQSU/KfZ/Zkq6OcCF8PcTrzmnyBWU99TqJiLyQbeRZJl1KNOdsD9cWu511Bpgv2AB2SMBS0Lt1pv1PeFFMajapvxCndwVAIRgbz3l1YkPjZvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705668446; c=relaxed/simple;
	bh=CrZIiCGAhGRfXIzdFDFQtavoSIuNWsmIxz0GVjdEmYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKdvtL7m8nBrxFm3n+4Y60lCj+hBXfG0WgIolvKbUraI7nTwTSwYrT3vQRDaEZ4MiYkUg/MwEwiR/IDUYjur9WT1gGdU4M4ERgebI5gnNgqcAeyLvrrgC1l4M1tBlnZBwTOObaEyQCiVAC/Ft5WUKkIkSinBM2NWv1SGE1dt6uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rQoHL-00083Y-0e; Fri, 19 Jan 2024 13:47:23 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/2] netlink_delinearize: move concat and value postprocessing to helpers
Date: Fri, 19 Jan 2024 13:47:08 +0100
Message-ID: <20240119124713.6506-2-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240119124713.6506-1-fw@strlen.de>
References: <20240119124713.6506-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The new helpers will be used in a followup patch to avoid
need to annotate more things in *ctx when doing postprocessing
of values embedded in a concatenation.

No functional changes intended.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c | 82 ++++++++++++++++++++++-----------------
 1 file changed, 47 insertions(+), 35 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index e21451044451..27630a8a9b34 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2720,6 +2720,50 @@ static struct expr *expr_postprocess_string(struct expr *expr)
 	return out;
 }
 
+static void expr_postprocess_value(struct rule_pp_ctx *ctx, struct expr **exprp)
+{
+	struct expr *expr = *exprp;
+
+	// FIXME
+	if (expr->byteorder == BYTEORDER_HOST_ENDIAN)
+		mpz_switch_byteorder(expr->value, expr->len / BITS_PER_BYTE);
+
+	if (expr_basetype(expr)->type == TYPE_STRING)
+		*exprp = expr_postprocess_string(expr);
+
+	expr = *exprp;
+	if (expr->dtype->basetype != NULL &&
+	    expr->dtype->basetype->type == TYPE_BITMASK)
+		*exprp = bitmask_expr_to_binops(expr);
+}
+
+static void expr_postprocess_concat(struct rule_pp_ctx *ctx, struct expr **exprp)
+{
+	struct expr *i, *n, *expr = *exprp;
+	unsigned int type = expr->dtype->type, ntype = 0;
+	int off = expr->dtype->subtypes;
+	const struct datatype *dtype;
+	LIST_HEAD(tmp);
+
+	assert(expr->etype == EXPR_CONCAT);
+
+	ctx->flags |= RULE_PP_IN_CONCATENATION;
+	list_for_each_entry_safe(i, n, &expr->expressions, list) {
+		if (type) {
+			dtype = concat_subtype_lookup(type, --off);
+			expr_set_type(i, dtype, dtype->byteorder);
+		}
+		list_del(&i->list);
+		expr_postprocess(ctx, &i);
+		list_add_tail(&i->list, &tmp);
+
+		ntype = concat_subtype_add(ntype, i->dtype->type);
+	}
+	ctx->flags &= ~RULE_PP_IN_CONCATENATION;
+	list_splice(&tmp, &expr->expressions);
+	__datatype_set(expr, concat_type_alloc(ntype));
+}
+
 static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 {
 	struct dl_proto_ctx *dl = dl_proto_ctx(ctx);
@@ -2746,30 +2790,9 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		list_for_each_entry(i, &expr->expressions, list)
 			expr_postprocess(ctx, &i);
 		break;
-	case EXPR_CONCAT: {
-		unsigned int type = expr->dtype->type, ntype = 0;
-		int off = expr->dtype->subtypes;
-		const struct datatype *dtype;
-		LIST_HEAD(tmp);
-		struct expr *n;
-
-		ctx->flags |= RULE_PP_IN_CONCATENATION;
-		list_for_each_entry_safe(i, n, &expr->expressions, list) {
-			if (type) {
-				dtype = concat_subtype_lookup(type, --off);
-				expr_set_type(i, dtype, dtype->byteorder);
-			}
-			list_del(&i->list);
-			expr_postprocess(ctx, &i);
-			list_add_tail(&i->list, &tmp);
-
-			ntype = concat_subtype_add(ntype, i->dtype->type);
-		}
-		ctx->flags &= ~RULE_PP_IN_CONCATENATION;
-		list_splice(&tmp, &expr->expressions);
-		__datatype_set(expr, concat_type_alloc(ntype));
+	case EXPR_CONCAT:
+		expr_postprocess_concat(ctx, exprp);
 		break;
-	}
 	case EXPR_UNARY:
 		expr_postprocess(ctx, &expr->arg);
 		expr_set_type(expr, expr->arg->dtype, !expr->arg->byteorder);
@@ -2882,18 +2905,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		payload_dependency_kill(&dl->pdctx, expr, dl->pctx.family);
 		break;
 	case EXPR_VALUE:
-		// FIXME
-		if (expr->byteorder == BYTEORDER_HOST_ENDIAN)
-			mpz_switch_byteorder(expr->value, expr->len / BITS_PER_BYTE);
-
-		if (expr_basetype(expr)->type == TYPE_STRING)
-			*exprp = expr_postprocess_string(expr);
-
-		expr = *exprp;
-		if (expr->dtype->basetype != NULL &&
-		    expr->dtype->basetype->type == TYPE_BITMASK)
-			*exprp = bitmask_expr_to_binops(expr);
-
+		expr_postprocess_value(ctx, exprp);
 		break;
 	case EXPR_RANGE:
 		expr_postprocess(ctx, &expr->left);
-- 
2.43.0

