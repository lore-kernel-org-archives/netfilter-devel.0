Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E956618BC12
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Oct 2024 10:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728296636; cv=none; b=R0dMltlA3l1fYNMo54SlIxWKsRBtaG8KXaxbFRj6GCLiCk4yzIrjKHyYJgNPk+x1Z4a3PochDBE90zWXdSfEo7DZp5PJ5/S6yle959lJYylN/bPlSKgaE0YHJFwZmrC8TdLFdXKu2FWHwgj5gYIxhGSVXeo6X/QI6LQrc6QI73c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728296636; c=relaxed/simple;
	bh=wvipdPP60s/wxCcMGdHqfadZlYBuOiUV+Zic9z03PuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpIdcsa0J9tJ2qPpItFiLku4p4+hXovxzSPFRg/9O+7aJJSYi9q8GdSt6ueEK1IbkFo8ZP3nKaQc5krMZOtrL49v3pBOc/uo6+esnhpZznluK3BASCuOVDrIFhQEsyj90a12SMEywIXeZmscLy8wdycPnQ/JKvUcpcVP+p+mF2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sxku9-0006fr-6W; Mon, 07 Oct 2024 12:23:53 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 4/5] netlink: tell user if libnftnl detected unknown attributes/features
Date: Mon,  7 Oct 2024 11:49:37 +0200
Message-ID: <20241007094943.7544-5-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241007094943.7544-1-fw@strlen.de>
References: <20241007094943.7544-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a warning in case libnftl failed to decode all attributes coming
from the kernel.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/netlink.h         |  1 +
 src/netlink_delinearize.c | 24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/netlink.h b/include/netlink.h
index cf7ba3693885..66fd6b414a0b 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -42,6 +42,7 @@ struct netlink_parse_ctx {
 	struct netlink_ctx	*nlctx;
 	bool			inner;
 	uint8_t			inner_reg;
+	uint8_t			incomplete_exprs;
 };
 
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index e3d9cfbbede5..5c7c11352abf 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1915,6 +1915,23 @@ static const struct expr_handler netlink_parsers[] = {
 	{ .name = "synproxy",	.parse = netlink_parse_synproxy },
 };
 
+static void netlink_incomplete_expr(struct netlink_parse_ctx *ctx)
+{
+	static const char incomplete[] = "# Unknown features used (old nft version?)";
+	struct stmt *stmt;
+	struct expr *e;
+
+	netlink_error(ctx, &ctx->rule->location, incomplete);
+
+	e = constant_expr_alloc(&ctx->rule->location, &string_type,
+				BYTEORDER_HOST_ENDIAN,
+				sizeof(incomplete) * BITS_PER_BYTE, incomplete);
+
+	__mpz_switch_byteorder(e->value, sizeof(incomplete));
+	stmt = expr_stmt_alloc(&ctx->rule->location, e);
+	rule_stmt_append(ctx->rule, stmt);
+}
+
 static int netlink_parse_expr(const struct nftnl_expr *nle,
 			      struct netlink_parse_ctx *ctx)
 {
@@ -1947,6 +1964,10 @@ static int netlink_parse_rule_expr(struct nftnl_expr *nle, void *arg)
 	err = netlink_parse_expr(nle, ctx);
 	if (err < 0)
 		return err;
+
+	if (!nftnl_expr_complete(nle))
+		ctx->incomplete_exprs++;
+
 	if (ctx->stmt != NULL) {
 		rule_stmt_append(ctx->rule, ctx->stmt);
 		ctx->stmt = NULL;
@@ -3508,6 +3529,9 @@ struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
 
 	nftnl_expr_foreach(nlr, netlink_parse_rule_expr, pctx);
 
+	if (pctx->incomplete_exprs)
+		netlink_incomplete_expr(pctx);
+
 	rule_parse_postprocess(pctx, pctx->rule);
 	netlink_release_registers(pctx);
 	return pctx->rule;
-- 
2.45.2

