Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A2E50264
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Jan 2024 17:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rNydU-0000rw-RY; Thu, 11 Jan 2024 18:14:32 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2 2/2] evaluate: add missing range checks for dup,fwd and payload statements
Date: Thu, 11 Jan 2024 18:14:16 +0100
Message-ID: <20240111171419.15210-3-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240111171419.15210-1-fw@strlen.de>
References: <20240111171419.15210-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Else we assert with:
BUG: unknown expression type range
nft: src/netlink_linearize.c:912: netlink_gen_expr: Assertion `0' failed.

While at it, condense meta and exthdr to reuse the same helper.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 This supersedes:
 https://patchwork.ozlabs.org/project/netfilter-devel/patch/20240111124649.27222-1-fw@strlen.de/

 src/evaluate.c                                | 88 +++++++++++--------
 .../testcases/bogons/nft-f/dup_fwd_ranges     | 14 +++
 .../nft-f/unknown_expr_type_range_assert      |  8 +-
 3 files changed, 69 insertions(+), 41 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/dup_fwd_ranges

diff --git a/src/evaluate.c b/src/evaluate.c
index ff42d97d32e0..319efd21d8a0 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -74,6 +74,33 @@ static int __fmtstring(3, 4) set_error(struct eval_ctx *ctx,
 	return -1;
 }
 
+static const char *stmt_name(const struct stmt *stmt)
+{
+	switch (stmt->ops->type) {
+	case STMT_NAT:
+		switch (stmt->nat.type) {
+		case NFT_NAT_SNAT:
+			return "snat";
+		case NFT_NAT_DNAT:
+			return "dnat";
+		case NFT_NAT_REDIR:
+			return "redirect";
+		case NFT_NAT_MASQ:
+			return "masquerade";
+		}
+		break;
+	default:
+		break;
+	}
+
+	return stmt->ops->name;
+}
+
+static int stmt_error_range(struct eval_ctx *ctx, const struct stmt *stmt, const struct expr *e)
+{
+	return expr_error(ctx->msgs, e, "%s: range argument not supported", stmt_name(stmt));
+}
+
 static void key_fix_dtype_byteorder(struct expr *key)
 {
 	const struct datatype *dtype = key->dtype;
@@ -3105,13 +3132,8 @@ static int stmt_evaluate_exthdr(struct eval_ctx *ctx, struct stmt *stmt)
 	if (ret < 0)
 		return ret;
 
-	switch (stmt->exthdr.val->etype) {
-	case EXPR_RANGE:
-		return expr_error(ctx->msgs, stmt->exthdr.val,
-				   "cannot be a range");
-	default:
-		break;
-	}
+	if (stmt->exthdr.val->etype == EXPR_RANGE)
+		return stmt_error_range(ctx, stmt, stmt->exthdr.val);
 
 	return 0;
 }
@@ -3144,6 +3166,9 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 				 payload->byteorder) < 0)
 		return -1;
 
+	if (stmt->payload.val->etype == EXPR_RANGE)
+		return stmt_error_range(ctx, stmt, stmt->payload.val);
+
 	need_csum = stmt_evaluate_payload_need_csum(payload);
 
 	if (!payload_needs_adjustment(payload)) {
@@ -3305,15 +3330,8 @@ static int stmt_evaluate_meta(struct eval_ctx *ctx, struct stmt *stmt)
 	if (ret < 0)
 		return ret;
 
-	switch (stmt->meta.expr->etype) {
-	case EXPR_RANGE:
-		ret = expr_error(ctx->msgs, stmt->meta.expr,
-				 "Meta expression cannot be a range");
-		break;
-	default:
-		break;
-
-	}
+	if (stmt->meta.expr->etype == EXPR_RANGE)
+		return stmt_error_range(ctx, stmt, stmt->meta.expr);
 
 	return ret;
 }
@@ -3336,6 +3354,9 @@ static int stmt_evaluate_ct(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_error(ctx, stmt,
 				  "ct secmark must not be set to constant value");
 
+	if (stmt->ct.expr->etype == EXPR_RANGE)
+		return stmt_error_range(ctx, stmt, stmt->ct.expr);
+
 	return 0;
 }
 
@@ -3853,28 +3874,6 @@ static int nat_evaluate_transport(struct eval_ctx *ctx, struct stmt *stmt,
 	return 0;
 }
 
-static const char *stmt_name(const struct stmt *stmt)
-{
-	switch (stmt->ops->type) {
-	case STMT_NAT:
-		switch (stmt->nat.type) {
-		case NFT_NAT_SNAT:
-			return "snat";
-		case NFT_NAT_DNAT:
-			return "dnat";
-		case NFT_NAT_REDIR:
-			return "redirect";
-		case NFT_NAT_MASQ:
-			return "masquerade";
-		}
-		break;
-	default:
-		break;
-	}
-
-	return stmt->ops->name;
-}
-
 static int stmt_evaluate_l3proto(struct eval_ctx *ctx,
 				 struct stmt *stmt, uint8_t family)
 {
@@ -4272,6 +4271,9 @@ static int stmt_evaluate_dup(struct eval_ctx *ctx, struct stmt *stmt)
 						&stmt->dup.dev);
 			if (err < 0)
 				return err;
+
+			if (stmt->dup.dev->etype == EXPR_RANGE)
+				return stmt_error_range(ctx, stmt, stmt->dup.dev);
 		}
 		break;
 	case NFPROTO_NETDEV:
@@ -4290,6 +4292,10 @@ static int stmt_evaluate_dup(struct eval_ctx *ctx, struct stmt *stmt)
 	default:
 		return stmt_error(ctx, stmt, "unsupported family");
 	}
+
+	if (stmt->dup.to->etype == EXPR_RANGE)
+		return stmt_error_range(ctx, stmt, stmt->dup.to);
+
 	return 0;
 }
 
@@ -4311,6 +4317,9 @@ static int stmt_evaluate_fwd(struct eval_ctx *ctx, struct stmt *stmt)
 		if (err < 0)
 			return err;
 
+		if (stmt->fwd.dev->etype == EXPR_RANGE)
+			return stmt_error_range(ctx, stmt, stmt->fwd.dev);
+
 		if (stmt->fwd.addr != NULL) {
 			switch (stmt->fwd.family) {
 			case NFPROTO_IPV4:
@@ -4329,6 +4338,9 @@ static int stmt_evaluate_fwd(struct eval_ctx *ctx, struct stmt *stmt)
 						&stmt->fwd.addr);
 			if (err < 0)
 				return err;
+
+			if (stmt->fwd.addr->etype == EXPR_RANGE)
+				return stmt_error_range(ctx, stmt, stmt->fwd.addr);
 		}
 		break;
 	default:
diff --git a/tests/shell/testcases/bogons/nft-f/dup_fwd_ranges b/tests/shell/testcases/bogons/nft-f/dup_fwd_ranges
new file mode 100644
index 000000000000..efaff9e542c0
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/dup_fwd_ranges
@@ -0,0 +1,14 @@
+define dev = "1"-"2"
+
+table netdev t {
+	chain c {
+		fwd to 1-2
+		dup to 1-2
+	}
+}
+
+table ip t {
+	chain c {
+		dup to 1-2 device $dev
+	}
+}
diff --git a/tests/shell/testcases/bogons/nft-f/unknown_expr_type_range_assert b/tests/shell/testcases/bogons/nft-f/unknown_expr_type_range_assert
index 234dd623167d..e6206736f120 100644
--- a/tests/shell/testcases/bogons/nft-f/unknown_expr_type_range_assert
+++ b/tests/shell/testcases/bogons/nft-f/unknown_expr_type_range_assert
@@ -1,5 +1,7 @@
 table ip x {
-        chain k {
-                meta mark set 0x001-3434
-        }
+	chain k {
+		meta mark set 0x001-3434
+		ct mark set 0x001-3434
+		tcp dport set 1-3
+	}
 }
-- 
2.41.0

