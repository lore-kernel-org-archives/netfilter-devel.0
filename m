Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10851922FC
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 11:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728474510; cv=none; b=EstVAU6rZBLrdh0SQo5u9TTKoZH/TlsRom+zn8CmDVto9hjX+/UFGUCgpNUisc2c+UffTJm42rCKLtD/YaCgDKReDNoxq29CnexhXA/GX9I5VGw+HFBCLAGv9hxbv7k7/nToZP2V7WV3Y7Y3/Jb7iTTdP6ndzJtrsNGKZsSD1vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728474510; c=relaxed/simple;
	bh=Uy/rlPF7B1O9eNM6l9sFjEK1FJ5t1EJL3HUC3RLHkuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htnYtEynJ6hQJTRQFjx3oDGCPVLgoaPZQJsmbw5Tv4l7wk1REczEob1iMtfB5sOeBnQWfCNyVvGVct9lwRDOxrht9L1qrifqBJBtyZSxWjjT1OF6FDb7u6p65NZNipG9ZJmBA+7oPaILHshJL5uJrGMVP7P3dEXfYD3k0Bc7LYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=i1jwmKpC; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="i1jwmKpC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=h6xw4ZNlwE5iIF1GTF0lmThD8c0bnmXsYszid0siSPE=; b=i1jwmKpCeHnqpjNoFOvvAMnst4
	7qqxAe8zEDBituCjStrQSjZCfNOV/V36xk0JIA+rKQs/LI34GbOhw8rxejXbkqDOU+9xW7AkcmKXf
	l3N/OmaWXYqrat8yD7z/9zItYbKyBl2pdjnHHkyprU2ZMy6ahZ1Ilh+0tOioQRV0T3vYHa6NG0YZZ
	9An0VML10TZq8CSW84pEYG1XI4u7JhrBFKFSDclVHbgw0+lDCGDxIGKjdU5tUkFkUMjsBY8Y3MPd1
	8FUVRwKjPavFliSEdLobUNBctwrtNdi5qHg1tPzVcq1RJ2JBZ8qbLn4PPutKvMtfvv8EKrb9TmpB6
	wM8/kb7g==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1syVB5-000000008Hp-06TO;
	Wed, 09 Oct 2024 13:48:27 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH v2 2/8] nft: ruleparse: Introduce nft_parse_rule_expr()
Date: Wed,  9 Oct 2024 13:48:13 +0200
Message-ID: <20241009114819.15379-3-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241009114819.15379-1-phil@nwl.cc>
References: <20241009114819.15379-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extract the parsing of one expression into a separate function and
export it, preparing for following code changes.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-ruleparse.c | 73 ++++++++++++++++++++++------------------
 iptables/nft-ruleparse.h |  4 +++
 2 files changed, 44 insertions(+), 33 deletions(-)

diff --git a/iptables/nft-ruleparse.c b/iptables/nft-ruleparse.c
index 1ee7a94db59de..757d3c29fc816 100644
--- a/iptables/nft-ruleparse.c
+++ b/iptables/nft-ruleparse.c
@@ -887,6 +887,45 @@ static void nft_parse_range(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 	}
 }
 
+bool nft_parse_rule_expr(struct nft_handle *h,
+			 struct nftnl_expr *expr,
+			 struct nft_xt_ctx *ctx)
+{
+	const char *name = nftnl_expr_get_str(expr, NFTNL_EXPR_NAME);
+
+	if (strcmp(name, "counter") == 0)
+		nft_parse_counter(expr, &ctx->cs->counters);
+	else if (strcmp(name, "payload") == 0)
+		nft_parse_payload(ctx, expr);
+	else if (strcmp(name, "meta") == 0)
+		nft_parse_meta(ctx, expr);
+	else if (strcmp(name, "bitwise") == 0)
+		nft_parse_bitwise(ctx, expr);
+	else if (strcmp(name, "cmp") == 0)
+		nft_parse_cmp(ctx, expr);
+	else if (strcmp(name, "immediate") == 0)
+		nft_parse_immediate(ctx, expr);
+	else if (strcmp(name, "match") == 0)
+		nft_parse_match(ctx, expr);
+	else if (strcmp(name, "target") == 0)
+		nft_parse_target(ctx, expr);
+	else if (strcmp(name, "limit") == 0)
+		nft_parse_limit(ctx, expr);
+	else if (strcmp(name, "lookup") == 0)
+		nft_parse_lookup(ctx, h, expr);
+	else if (strcmp(name, "log") == 0)
+		nft_parse_log(ctx, expr);
+	else if (strcmp(name, "range") == 0)
+		nft_parse_range(ctx, expr);
+
+	if (ctx->errmsg) {
+		fprintf(stderr, "Error: %s\n", ctx->errmsg);
+		ctx->errmsg = NULL;
+		return false;
+	}
+	return true;
+}
+
 bool nft_rule_to_iptables_command_state(struct nft_handle *h,
 					const struct nftnl_rule *r,
 					struct iptables_command_state *cs)
@@ -905,40 +944,8 @@ bool nft_rule_to_iptables_command_state(struct nft_handle *h,
 
 	expr = nftnl_expr_iter_next(ctx.iter);
 	while (expr != NULL) {
-		const char *name =
-			nftnl_expr_get_str(expr, NFTNL_EXPR_NAME);
-
-		if (strcmp(name, "counter") == 0)
-			nft_parse_counter(expr, &ctx.cs->counters);
-		else if (strcmp(name, "payload") == 0)
-			nft_parse_payload(&ctx, expr);
-		else if (strcmp(name, "meta") == 0)
-			nft_parse_meta(&ctx, expr);
-		else if (strcmp(name, "bitwise") == 0)
-			nft_parse_bitwise(&ctx, expr);
-		else if (strcmp(name, "cmp") == 0)
-			nft_parse_cmp(&ctx, expr);
-		else if (strcmp(name, "immediate") == 0)
-			nft_parse_immediate(&ctx, expr);
-		else if (strcmp(name, "match") == 0)
-			nft_parse_match(&ctx, expr);
-		else if (strcmp(name, "target") == 0)
-			nft_parse_target(&ctx, expr);
-		else if (strcmp(name, "limit") == 0)
-			nft_parse_limit(&ctx, expr);
-		else if (strcmp(name, "lookup") == 0)
-			nft_parse_lookup(&ctx, h, expr);
-		else if (strcmp(name, "log") == 0)
-			nft_parse_log(&ctx, expr);
-		else if (strcmp(name, "range") == 0)
-			nft_parse_range(&ctx, expr);
-
-		if (ctx.errmsg) {
-			fprintf(stderr, "Error: %s\n", ctx.errmsg);
-			ctx.errmsg = NULL;
+		if (!nft_parse_rule_expr(h, expr, &ctx))
 			ret = false;
-		}
-
 		expr = nftnl_expr_iter_next(ctx.iter);
 	}
 
diff --git a/iptables/nft-ruleparse.h b/iptables/nft-ruleparse.h
index 62c9160d77711..0377e4ae17a6e 100644
--- a/iptables/nft-ruleparse.h
+++ b/iptables/nft-ruleparse.h
@@ -133,4 +133,8 @@ int parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e, uint8_t key,
 int nft_parse_hl(struct nft_xt_ctx *ctx, struct nftnl_expr *e,
 		 struct iptables_command_state *cs);
 
+bool nft_parse_rule_expr(struct nft_handle *h,
+			 struct nftnl_expr *expr,
+			 struct nft_xt_ctx *ctx);
+
 #endif /* _NFT_RULEPARSE_H_ */
-- 
2.43.0

