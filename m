Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAF9202982
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Mar 2025 12:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743425064; cv=none; b=qiBTthvqJxnnYa2PipzUg6UAYYuq+6cPHOcfNAGP8USHsIXY22xmguOV4tyL2yZSBCY+N3Ie5muX8Rq/dB3i9Hbj7if3fxkWM0qbByKeGmFUXPHpaZ16G0OHfGBeYGoQxHi5zkSUmhN6AccaFjXLcLg1JyAxWzzABHzys4tnc9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743425064; c=relaxed/simple;
	bh=PsJxchrowX48nBrBe9NE0zeTSisH/2Hhgr15LjzaLjI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c/GndqfgPJEEuMD5WIA56pypORXZdzVkAsBPx/+DZP38AcDdm5RTGqSyPYq/Nj1/ynMCzn+2rTFaegPy2mj7Htm+AszL/uBD/OrxLAad97+NsjQoHOrBDzhgqAkdGK8qZs6YeIuSOjW5ihqLUwvonP5hcPOBCy6OtmRDwGmkslQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tzEV2-0003QS-Lk; Mon, 31 Mar 2025 14:44:20 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/2] evaluate: reject: remove unused expr function argument
Date: Mon, 31 Mar 2025 14:43:33 +0200
Message-ID: <20250331124341.12151-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

stmt_evaluate_reject passes cmd->expr argument but its never used.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 0db3d80f8b56..507b1c86cafc 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3624,8 +3624,7 @@ static int reject_payload_gen_dependency_family(struct eval_ctx *ctx,
 	return 1;
 }
 
-static int stmt_reject_gen_dependency(struct eval_ctx *ctx, struct stmt *stmt,
-				      struct expr *expr)
+static int stmt_reject_gen_dependency(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	struct expr *payload = NULL;
 	struct stmt *nstmt;
@@ -3705,8 +3704,7 @@ static int stmt_evaluate_reject_inet_family(struct eval_ctx *ctx,
 	return 0;
 }
 
-static int stmt_evaluate_reject_inet(struct eval_ctx *ctx, struct stmt *stmt,
-				     struct expr *expr)
+static int stmt_evaluate_reject_inet(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	struct proto_ctx *pctx = eval_proto_ctx(ctx);
 	const struct proto_desc *desc;
@@ -3717,7 +3715,7 @@ static int stmt_evaluate_reject_inet(struct eval_ctx *ctx, struct stmt *stmt,
 		return -1;
 	if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH)
 		return 0;
-	if (stmt_reject_gen_dependency(ctx, stmt, expr) < 0)
+	if (stmt_reject_gen_dependency(ctx, stmt) < 0)
 		return -1;
 	return 0;
 }
@@ -3772,8 +3770,7 @@ static int stmt_evaluate_reject_bridge_family(struct eval_ctx *ctx,
 	return 0;
 }
 
-static int stmt_evaluate_reject_bridge(struct eval_ctx *ctx, struct stmt *stmt,
-				       struct expr *expr)
+static int stmt_evaluate_reject_bridge(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	struct proto_ctx *pctx = eval_proto_ctx(ctx);
 	const struct proto_desc *desc;
@@ -3789,13 +3786,12 @@ static int stmt_evaluate_reject_bridge(struct eval_ctx *ctx, struct stmt *stmt,
 		return -1;
 	if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH)
 		return 0;
-	if (stmt_reject_gen_dependency(ctx, stmt, expr) < 0)
+	if (stmt_reject_gen_dependency(ctx, stmt) < 0)
 		return -1;
 	return 0;
 }
 
-static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt,
-				       struct expr *expr)
+static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	struct proto_ctx *pctx = eval_proto_ctx(ctx);
 
@@ -3806,7 +3802,7 @@ static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt,
 	case NFPROTO_IPV6:
 		switch (stmt->reject.type) {
 		case NFT_REJECT_TCP_RST:
-			if (stmt_reject_gen_dependency(ctx, stmt, expr) < 0)
+			if (stmt_reject_gen_dependency(ctx, stmt) < 0)
 				return -1;
 			break;
 		case NFT_REJECT_ICMPX_UNREACH:
@@ -3821,11 +3817,11 @@ static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt,
 		break;
 	case NFPROTO_BRIDGE:
 	case NFPROTO_NETDEV:
-		if (stmt_evaluate_reject_bridge(ctx, stmt, expr) < 0)
+		if (stmt_evaluate_reject_bridge(ctx, stmt) < 0)
 			return -1;
 		break;
 	case NFPROTO_INET:
-		if (stmt_evaluate_reject_inet(ctx, stmt, expr) < 0)
+		if (stmt_evaluate_reject_inet(ctx, stmt) < 0)
 			return -1;
 		break;
 	}
@@ -3958,8 +3954,6 @@ static int stmt_evaluate_reset(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_reject(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	struct expr *expr = ctx->cmd->expr;
-
 	if (stmt->reject.icmp_code < 0) {
 		if (stmt_evaluate_reject_default(ctx, stmt) < 0)
 			return -1;
@@ -3971,7 +3965,7 @@ static int stmt_evaluate_reject(struct eval_ctx *ctx, struct stmt *stmt)
 			return -1;
 	}
 
-	return stmt_evaluate_reject_family(ctx, stmt, expr);
+	return stmt_evaluate_reject_family(ctx, stmt);
 }
 
 static int nat_evaluate_family(struct eval_ctx *ctx, struct stmt *stmt)
-- 
2.49.0

