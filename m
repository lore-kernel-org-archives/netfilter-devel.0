Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894D210E0
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Dec 2023 15:37:23 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rBkPJ-0002KG-Ah; Sat, 09 Dec 2023 00:37:21 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: validate chain max length
Date: Sat,  9 Dec 2023 00:37:09 +0100
Message-ID: <20231208233714.14316-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The includes test files cause:
BUG: chain is too large (257, 256 max)nft: netlink.c:418: netlink_gen_chain: Assertion `0' failed.

Error out in evaluation step instead.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                | 34 ++++++++++++++++++-
 .../bogons/nft-f/huge_chain_name_assert       |  5 +++
 .../nft-f/huge_chain_name_define_assert       |  7 ++++
 3 files changed, 45 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/huge_chain_name_assert
 create mode 100644 tests/shell/testcases/bogons/nft-f/huge_chain_name_define_assert

diff --git a/src/evaluate.c b/src/evaluate.c
index e3e0c00eb635..1b3e8097454d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2738,6 +2738,35 @@ static int expr_evaluate_flagcmp(struct eval_ctx *ctx, struct expr **exprp)
 	return expr_evaluate(ctx, exprp);
 }
 
+static int verdict_validate_chainlen(struct eval_ctx *ctx,
+				     struct expr *chain)
+{
+	if (chain->len > NFT_CHAIN_MAXNAMELEN * BITS_PER_BYTE)
+		return expr_error(ctx->msgs, chain,
+				  "chain name too long (%u, max %u)",
+				  chain->len / BITS_PER_BYTE,
+				  NFT_CHAIN_MAXNAMELEN);
+
+	return 0;
+}
+
+static int expr_evaluate_verdict(struct eval_ctx *ctx, struct expr **exprp)
+{
+	struct expr *expr = *exprp;
+
+	switch (expr->verdict) {
+	case NFT_GOTO:
+	case NFT_JUMP:
+		if (expr->chain->etype == EXPR_VALUE &&
+		    verdict_validate_chainlen(ctx, expr->chain))
+			return -1;
+
+		break;
+	}
+
+	return expr_evaluate_primary(ctx, exprp);
+}
+
 static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 {
 	if (ctx->nft->debug_mask & NFT_DEBUG_EVALUATION) {
@@ -2763,7 +2792,7 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 	case EXPR_EXTHDR:
 		return expr_evaluate_exthdr(ctx, expr);
 	case EXPR_VERDICT:
-		return expr_evaluate_primary(ctx, expr);
+		return expr_evaluate_verdict(ctx, expr);
 	case EXPR_META:
 		return expr_evaluate_meta(ctx, expr);
 	case EXPR_SOCKET:
@@ -2964,6 +2993,9 @@ static int stmt_evaluate_verdict(struct eval_ctx *ctx, struct stmt *stmt)
 				return expr_error(ctx->msgs, stmt->expr->chain,
 						  "not a value expression");
 			}
+
+			if (verdict_validate_chainlen(ctx, stmt->expr->chain))
+				return -1;
 		}
 		break;
 	case EXPR_MAP:
diff --git a/tests/shell/testcases/bogons/nft-f/huge_chain_name_assert b/tests/shell/testcases/bogons/nft-f/huge_chain_name_assert
new file mode 100644
index 000000000000..161f867dce60
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/huge_chain_name_assert
@@ -0,0 +1,5 @@
+table inet x {
+        chain c {
+                udp length vmap { 1 : goto rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr }
+        }
+}
diff --git a/tests/shell/testcases/bogons/nft-f/huge_chain_name_define_assert b/tests/shell/testcases/bogons/nft-f/huge_chain_name_define_assert
new file mode 100644
index 000000000000..3c2c0d3e3a93
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/huge_chain_name_define_assert
@@ -0,0 +1,7 @@
+define huge = rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
+
+table t {
+	chain d {
+		jump $huge
+	}
+}
-- 
2.41.0

