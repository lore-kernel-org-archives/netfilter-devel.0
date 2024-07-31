Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2BF16D9A8
	for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2024 22:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722464833; cv=none; b=nTyc3xG5epPyztbedEGvgK8Ga+IIIVCgg7bHt6dAoGEl9CrjgA87pcgGbEWO/+LBuDwdx50UpZuG0mvQu7EKCITC/K7qfA1NRXroSeRea5sfxIHdyl3KdnyTn3NNmy38tPTnwPbqHLlM4jZllsywNTwx376Qlu3UYf1HxAiJ94M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722464833; c=relaxed/simple;
	bh=Uy/rlPF7B1O9eNM6l9sFjEK1FJ5t1EJL3HUC3RLHkuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8uuWTzPGETTANWK/m2glG17+CIL1D9Uoqnwu0ZUtDB9cq7bSmRvR/Z3feQNsZ+oGGKUvDOmVCD/AdkkPCcOTwl9PHjjrShuxNdvEk55wsVPQb/ZkjxeIPIemjjieLC9OEh/PP3KKWyBlUNruDK+AlglOV0RvexzJjyDTJ6ZVQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Vvq+pmnb; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Vvq+pmnb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=h6xw4ZNlwE5iIF1GTF0lmThD8c0bnmXsYszid0siSPE=; b=Vvq+pmnbWHGD78lOquODQBl7Fr
	RkpwZf1GqwZP72knV645lW64VRFSGXcENEHjhYOqaoJ9+0U6ZHDhLhhlLp+oLZXxDYTWIfzfnG2vI
	gvKnE7EL9N/okJqfRFXwJ3pJ6MCX1gHYLZRJ0XhQYPU6GSdmpyLJ+Qo56JTwdeFK6QymQT2De5/Mi
	1ckFWrZwLwk7584T2yZpi5/4V1MTMfCV8skIWdkisv7pKJIA2yl7XEHapMhPLCo8dBavnvfg1VPRv
	N1KpOU/x+UUiqQJXIf3bpD7X4w9+SaCVwBNdIhhGhmXy7zwXy++o0xOeOPCDWJD71VzwGQvVZnXN+
	lqzu0+QQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sZHmo-000000003iq-3BMy;
	Thu, 01 Aug 2024 00:27:10 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH 5/8] nft: ruleparse: Introduce nft_parse_rule_expr()
Date: Thu,  1 Aug 2024 00:27:00 +0200
Message-ID: <20240731222703.22741-6-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240731222703.22741-1-phil@nwl.cc>
References: <20240731222703.22741-1-phil@nwl.cc>
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

