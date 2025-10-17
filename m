Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED98211F
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Oct 2025 11:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760701548; cv=none; b=dKQNzItrD9Kauyj4pDD86yScNdS0grhmm0XbUDuXyAxOINaKuPzTx+nxvrSA4rl9jvE2/US5p0gIp91z9LfeBdMH9fDx0Hs4KnOTetH2hCG6hLMcaYwVBsNb93vo13GbNUZa67SJ2L1+H4ChwxjZ8D1hm1no7O5Loj9dkIiJs+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760701548; c=relaxed/simple;
	bh=nxCYP5zrYt0WlKTVbsMZWNkxPwI8zBra1C7C1+R3XsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j5s+vdgYcb0Ti0JSbabOgLe8z4vHlcDnP2fkNytrmMkJrn3G+bwevRfnzxn238/+O7bPzikC/h/aotPYdpJxAEXGeR7C7mv/xI6AJSrnRxm42OgIDLESj2OwT3wvGaZO4acNW/+LB54YFj3Hu/6J2usmJGxQHO3FDsQRu43Mku8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 21ADF60329; Fri, 17 Oct 2025 13:45:39 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: follow prefix expression recursively
Date: Fri, 17 Oct 2025 13:45:26 +0200
Message-ID: <20251017114529.20280-1-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Included bogons assert:
Assertion `!expr_is_constant(*expr) || expr_is_singleton(*expr)' failed

This is because the "foo*" + prefix combination causes expr_evaluate
to replace the binop + string expression with another prefix that
gets allocated while handling "foo*" (wildcard).

This causes expr_evaluate_prefix to build
a prefix -> prefix -> binop chain.

After this, we get:

Error: Right hand side of relational expression (implicit) must be constant
a b ct helper "2.2.2.2.3*1"/80
    ~~~~~~~~~~^^^^^^^^^^^^^^^^
Error: Binary operation (&) is undefined for prefix expressions
a b ct helper "2.2.2.****02"/80
              ^^^^^^^^^^^^^^^^^

for those inputs rather than hitting assert() in byteorder_conversion()
later on.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                         | 10 ++++++++++
 src/expression.c                                       |  1 +
 .../testcases/bogons/nft-f/byteorder_conversion_assert |  2 ++
 3 files changed, 13 insertions(+)
 create mode 100644 tests/shell/testcases/bogons/nft-f/byteorder_conversion_assert

diff --git a/src/evaluate.c b/src/evaluate.c
index ffd3ce626859..b984ae4f89b5 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1273,6 +1273,16 @@ static int expr_evaluate_prefix(struct eval_ctx *ctx, struct expr **expr)
 	if (expr_evaluate(ctx, &prefix->prefix) < 0)
 		return -1;
 	base = prefix->prefix;
+
+	/* expr_evaluate may simplify EXPR_AND to another
+	 * prefix expression for inputs like "2.2.2.2.3*1"/80.
+	 *
+	 * Recurse until all the expressions have been simplified.
+	 * This also gets us the error checks for the expression
+	 * chain.
+	 */
+	if (base->etype == EXPR_PREFIX)
+		return expr_evaluate_prefix(ctx, &prefix->prefix);
 	assert(expr_is_constant(base));
 
 	prefix->dtype	  = datatype_get(base->dtype);
diff --git a/src/expression.c b/src/expression.c
index 019c263f187b..81359ad4cc4e 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -765,6 +765,7 @@ struct expr *prefix_expr_alloc(const struct location *loc,
 
 const char *expr_op_symbols[] = {
 	[OP_INVALID]	= "invalid",
+	[OP_IMPLICIT]	= "implicit",
 	[OP_HTON]	= "hton",
 	[OP_NTOH]	= "ntoh",
 	[OP_AND]	= "&",
diff --git a/tests/shell/testcases/bogons/nft-f/byteorder_conversion_assert b/tests/shell/testcases/bogons/nft-f/byteorder_conversion_assert
new file mode 100644
index 000000000000..26c8914e7bba
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/byteorder_conversion_assert
@@ -0,0 +1,2 @@
+a b ct helper "2.2.2.2.3*1"/80
+a b ct helper "2.2.2.****02"/80
-- 
2.51.0

