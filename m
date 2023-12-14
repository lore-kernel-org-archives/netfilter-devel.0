Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F153F114
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 08:57:09 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rDp1H-0002Qa-MK; Thu, 14 Dec 2023 17:57:07 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: exthdr: statement arg must be not be a range
Date: Thu, 14 Dec 2023 17:56:59 +0100
Message-ID: <20231214165703.12520-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Else we get:
BUG: unknown expression type range
nft: src/netlink_linearize.c:909: netlink_gen_expr: Assertion `0' failed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                | 19 ++++++++++++++++---
 .../bogons/nft-f/exthdr_with_range_bug        |  1 +
 2 files changed, 17 insertions(+), 3 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/exthdr_with_range_bug

diff --git a/src/evaluate.c b/src/evaluate.c
index 70d80eb48556..1c5078d67c13 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3024,14 +3024,27 @@ static bool stmt_evaluate_payload_need_csum(const struct expr *payload)
 static int stmt_evaluate_exthdr(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	struct expr *exthdr;
+	int ret;
 
 	if (__expr_evaluate_exthdr(ctx, &stmt->exthdr.expr) < 0)
 		return -1;
 
 	exthdr = stmt->exthdr.expr;
-	return stmt_evaluate_arg(ctx, stmt, exthdr->dtype, exthdr->len,
-				 BYTEORDER_BIG_ENDIAN,
-				 &stmt->exthdr.val);
+	ret = stmt_evaluate_arg(ctx, stmt, exthdr->dtype, exthdr->len,
+				BYTEORDER_BIG_ENDIAN,
+				&stmt->exthdr.val);
+	if (ret < 0)
+		return ret;
+
+	switch (stmt->exthdr.val->etype) {
+	case EXPR_RANGE:
+		return expr_error(ctx->msgs, stmt->exthdr.val,
+				   "cannot be a range");
+	default:
+		break;
+	}
+
+	return 0;
 }
 
 static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
diff --git a/tests/shell/testcases/bogons/nft-f/exthdr_with_range_bug b/tests/shell/testcases/bogons/nft-f/exthdr_with_range_bug
new file mode 100644
index 000000000000..e307e7cc5482
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/exthdr_with_range_bug
@@ -0,0 +1 @@
+add rule t c ip option ra set 0-1
-- 
2.41.0

