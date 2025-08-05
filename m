Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF26115ECCC
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Aug 2025 19:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754422848; cv=none; b=pSh3FMk8H7BWJmZPilEKZ4QMpUs+mHGUW/7RmoQcCjkFT12TgdgEpr2ZAbRLcVybIshADp2JSMl6UuaY59wEV/GgPSm4EDMHImukEorxKDaKmJ7yWRmqrvRFBaUZFhmhdYAaNj1ojE52zQQe0xnY9fY9+RYM1lx/mTFLBt/vM5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754422848; c=relaxed/simple;
	bh=KtcaEO9LFi2MTsY2rsWCeykqCBiWyr1iZKphOXOf3Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bTRh7isbwaQB3Zw2jCUyOsNBsXkke0gPRNvkP408aseLP2FfY8e0cb0Zp0C6LyrETrciYnG9T4lIt3XoQDCqJ+9lVa3NNQv/qNRH7nCYsKqlPPhJW6K0WGwhSyFFVsdty/vYL6nksyb4dxAGXs0GHk/Lne53IB1cwoeSnufW3Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 612B16123D; Tue,  5 Aug 2025 21:40:37 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/2] evaluate: check XOR RHS operand is a constant value
Date: Tue,  5 Aug 2025 21:40:14 +0200
Message-ID: <20250805194032.18288-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that we support non-constant RHS side in binary operations,
reject XOR with non-constant key: we cannot transfer the expression.

Fixes: 54bfc38c522b ("src: allow binop expressions with variable right-hand operands")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 I suggest to defer this until after 1.1.4 is out.

 src/evaluate.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 81e88d11aecb..1d102f842df0 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2578,16 +2578,20 @@ static int binop_can_transfer(struct eval_ctx *ctx,
 
 	switch (left->op) {
 	case OP_LSHIFT:
+		assert(left->right->etype == EXPR_VALUE);
+		assert(right->etype == EXPR_VALUE);
+
 		if (mpz_scan1(right->value, 0) < mpz_get_uint32(left->right->value))
 			return expr_binary_error(ctx->msgs, right, left,
 						 "Comparison is always false");
 		return 1;
 	case OP_RSHIFT:
+		assert(left->right->etype == EXPR_VALUE);
 		if (ctx->ectx.len < right->len + mpz_get_uint32(left->right->value))
 			ctx->ectx.len += mpz_get_uint32(left->right->value);
 		return 1;
 	case OP_XOR:
-		return 1;
+		return expr_is_constant(left->right);
 	default:
 		return 0;
 	}
-- 
2.49.1

