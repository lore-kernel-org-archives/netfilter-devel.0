Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFA915EB9
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Jan 2024 12:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rNuSU-0007q6-G5; Thu, 11 Jan 2024 13:46:54 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: disable ct set with ranges
Date: Thu, 11 Jan 2024 13:46:47 +0100
Message-ID: <20240111124649.27222-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

... this will cause an assertion in netlink linearization, catch this
at eval stage instead.

before:
BUG: unknown expression type range
nft: netlink_linearize.c:908: netlink_gen_expr: Assertion `0' failed.

after:
/unknown_expr_type_range_assert:3:31-40: Error: ct expression cannot be a range
ct mark set 0x001-3434
            ^^^^^^^^^^

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                       | 12 +++++++++++-
 .../bogons/nft-f/unknown_expr_type_range_assert      |  1 +
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index b6e602308163..6c6841679f1e 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3331,7 +3331,17 @@ static int stmt_evaluate_ct(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_error(ctx, stmt,
 				  "ct secmark must not be set to constant value");
 
-	return 0;
+	switch (stmt->meta.expr->etype) {
+	case EXPR_RANGE:
+		ret = expr_error(ctx->msgs, stmt->ct.expr,
+				 "ct expression cannot be a range");
+		break;
+	default:
+		break;
+
+	}
+
+	return ret;
 }
 
 static int reject_payload_gen_dependency_tcp(struct eval_ctx *ctx,
diff --git a/tests/shell/testcases/bogons/nft-f/unknown_expr_type_range_assert b/tests/shell/testcases/bogons/nft-f/unknown_expr_type_range_assert
index 234dd623167d..1a42d751e880 100644
--- a/tests/shell/testcases/bogons/nft-f/unknown_expr_type_range_assert
+++ b/tests/shell/testcases/bogons/nft-f/unknown_expr_type_range_assert
@@ -1,5 +1,6 @@
 table ip x {
         chain k {
                 meta mark set 0x001-3434
+                ct mark set 0x001-3434
         }
 }
-- 
2.41.0

