Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9FF83
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Dec 2023 09:21:27 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rACdJ-0001Or-QJ; Mon, 04 Dec 2023 18:21:25 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: turn assert into real error check
Date: Mon,  4 Dec 2023 18:21:18 +0100
Message-ID: <20231204172121.5154-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

large '& VAL' results in:
src/evaluate.c:531: expr_evaluate_bits: Assertion `masklen <= NFT_REG_SIZE * BITS_PER_BYTE' failed.

Turn this into expr_error().

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                | 25 ++++++++++++++-----
 .../bogons/nft-f/bitwise_masklen_assert       |  5 ++++
 2 files changed, 24 insertions(+), 6 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/bitwise_masklen_assert

diff --git a/src/evaluate.c b/src/evaluate.c
index e4dc5f65e3bd..64deb31a6ec4 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -506,7 +506,7 @@ static uint8_t expr_offset_shift(const struct expr *expr, unsigned int offset,
 	return shift;
 }
 
-static void expr_evaluate_bits(struct eval_ctx *ctx, struct expr **exprp)
+static int expr_evaluate_bits(struct eval_ctx *ctx, struct expr **exprp)
 {
 	struct expr *expr = *exprp, *and, *mask, *rshift, *off;
 	unsigned masklen, len = expr->len, extra_len = 0;
@@ -528,7 +528,10 @@ static void expr_evaluate_bits(struct eval_ctx *ctx, struct expr **exprp)
 	}
 
 	masklen = len + shift;
-	assert(masklen <= NFT_REG_SIZE * BITS_PER_BYTE);
+
+	if (masklen > NFT_REG_SIZE * BITS_PER_BYTE)
+		return expr_error(ctx->msgs, expr, "mask length %u exceeds allowed maximum of %u\n",
+				  masklen, NFT_REG_SIZE * BITS_PER_BYTE);
 
 	mpz_init2(bitmask, masklen);
 	mpz_bitmask(bitmask, len);
@@ -571,6 +574,8 @@ static void expr_evaluate_bits(struct eval_ctx *ctx, struct expr **exprp)
 
 	if (extra_len)
 		expr->len += extra_len;
+
+	return 0;
 }
 
 static int __expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
@@ -587,8 +592,12 @@ static int __expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
 	ctx->ectx.key = key;
 
 	if (expr->exthdr.offset % BITS_PER_BYTE != 0 ||
-	    expr->len % BITS_PER_BYTE != 0)
-		expr_evaluate_bits(ctx, exprp);
+	    expr->len % BITS_PER_BYTE != 0) {
+		int err = expr_evaluate_bits(ctx, exprp);
+
+		if (err)
+			return err;
+	}
 
 	switch (expr->exthdr.op) {
 	case NFT_EXTHDR_OP_TCPOPT: {
@@ -896,8 +905,12 @@ static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **exprp)
 
 	ctx->ectx.key = key;
 
-	if (payload_needs_adjustment(expr))
-		expr_evaluate_bits(ctx, exprp);
+	if (payload_needs_adjustment(expr)) {
+		int err = expr_evaluate_bits(ctx, exprp);
+
+		if (err)
+			return err;
+	}
 
 	expr->payload.evaluated = true;
 
diff --git a/tests/shell/testcases/bogons/nft-f/bitwise_masklen_assert b/tests/shell/testcases/bogons/nft-f/bitwise_masklen_assert
new file mode 100644
index 000000000000..0e75e6f1d708
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/bitwise_masklen_assert
@@ -0,0 +1,5 @@
+table inet t {
+        chain c {
+                udp length . @th,160,138 vmap { 47-63 . 0xe37313536313033&131303735353203 : accept }
+        }
+}
-- 
2.41.0

