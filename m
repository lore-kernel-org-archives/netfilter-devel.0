Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FE47139597
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jul 2024 21:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720128872; cv=none; b=aLDDWxioe0P03zbCFPpFobdOzztetIXTbStUtOM4VZiAyEneyh2ZLv/lJxiHDCXlwp3W7MY8yyjqn7x1+0laAomQMu8IIY5NCdEsIbD9klZhDSWTw6YB9InlQswNVvDc3nHDY0V9tcIEo8dJxzrYbAKZjh9uyyoPoVFld/HIfsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720128872; c=relaxed/simple;
	bh=+3Ex74Ddali02HyW21y3ljM6AH4OJ6KpjnSqpYea6oA=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QfZ1yPgzyhO1Y5sUtTkfasQp2tSweVNNjBtWovpSSk1kxLF/k5YOdRTAOp8MoUvKGSvZ/mV1ItwHcYaott0spECJ3z1ZQtBn975SrW2HJlhQTQJl9p3s2/J4UogjSj6TtjZ8afevtrg6+ZTGw9/ZBFBa9VrSI8Yx4UEA5qnhgpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/4] evaluate: set on expr->len for catchall set elements
Date: Thu,  4 Jul 2024 23:34:20 +0200
Message-Id: <20240704213423.254356-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240704213423.254356-1-pablo@netfilter.org>
References: <20240704213423.254356-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Catchall elements coming from the parser provide expr->len == 0.
However, the existing mergesort implementation requires expr->len to be
set up to the length of the set key to properly sort elements.

In particular, set element deletion leverages such list sorting to find
if elements exists in the set.

Fixes: 419d19688688 ("src: add set element catch-all support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index aa9293a87856..0a31c73e4276 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1877,6 +1877,16 @@ err_missing_flag:
 			  set_is_map(ctx->set->flags) ? "map" : "set", expr_name(key));
 }
 
+static int expr_evaluate_set_elem_catchall(struct eval_ctx *ctx, struct expr **expr)
+{
+	struct expr *elem = *expr;
+
+	if (ctx->set)
+		elem->len = ctx->set->key->len;
+
+	return 0;
+}
+
 static const struct expr *expr_set_elem(const struct expr *expr)
 {
 	if (expr->etype == EXPR_MAPPING)
@@ -2996,7 +3006,7 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 	case EXPR_XFRM:
 		return expr_evaluate_xfrm(ctx, expr);
 	case EXPR_SET_ELEM_CATCHALL:
-		return 0;
+		return expr_evaluate_set_elem_catchall(ctx, expr);
 	case EXPR_FLAGCMP:
 		return expr_evaluate_flagcmp(ctx, expr);
 	default:
-- 
2.30.2

