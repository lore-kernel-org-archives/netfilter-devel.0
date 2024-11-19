Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6B181D0157
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2024 15:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732030975; cv=none; b=OUVCxBg8b0lbgXL2nwGSEX94f/DsuY1Osz9zi5GA/9//iPo6brmN97flj6FbslQog+5oQ6d6PhwFwB45lvwAuXFzJ0E9/lfpUEjKN7wVbR4YTSgduhck1T1CPnB6c7SVHzP/JiUMXd8wmUME12ScfHxMpp0ruyAJapg7ofTXQ2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732030975; c=relaxed/simple;
	bh=t6GpqHZV6ICLJzjgA+tmMEV/AFUvswknxf3ecnhTaSs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TFw5caNhpl3/B+wBYndj27eGmnnlo2ytQBnZsdm/UU5Bu8jV53eLzqoCYw251bhu1jf63RwLeTQVXhIoDFcxrmTE7OGLT3TSZyFyNooBSmLlJY4rslfmJlSbL9/6GD8wyl/B7tNQP4cCpIS0LmJN0g/6Ze78JAkWsqLMbkAvK44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: jeremy@azazel.net
Subject: [PATCH libnftnl,v2 2/5] expr: bitwise: rename some boolean operation functions
Date: Tue, 19 Nov 2024 16:42:42 +0100
Message-Id: <20241119154245.442961-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241119154245.442961-1-pablo@netfilter.org>
References: <20241119154245.442961-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jeremy Sowden <jeremy@azazel.net>

In the next patch we add support for doing AND, OR and XOR operations
directly in the kernel, so rename some functions and an enum constant
related to mask-and-xor boolean operations.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr/bitwise.c            |  8 ++++----
 tests/nft-expr_bitwise-test.c | 34 +++++++++++++++++-----------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 1a945e9167c6..9385219a38b5 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -198,8 +198,8 @@ nftnl_expr_bitwise_parse(struct nftnl_expr *e, struct nlattr *attr)
 }
 
 static int
-nftnl_expr_bitwise_snprintf_bool(char *buf, size_t remain,
-				 const struct nftnl_expr_bitwise *bitwise)
+nftnl_expr_bitwise_snprintf_mask_xor(char *buf, size_t remain,
+				     const struct nftnl_expr_bitwise *bitwise)
 {
 	int offset = 0, ret;
 
@@ -248,8 +248,8 @@ nftnl_expr_bitwise_snprintf(char *buf, size_t size,
 	int err = -1;
 
 	switch (bitwise->op) {
-	case NFT_BITWISE_BOOL:
-		err = nftnl_expr_bitwise_snprintf_bool(buf, size, bitwise);
+	case NFT_BITWISE_MASK_XOR:
+		err = nftnl_expr_bitwise_snprintf_mask_xor(buf, size, bitwise);
 		break;
 	case NFT_BITWISE_LSHIFT:
 		err = nftnl_expr_bitwise_snprintf_shift(buf, size, "<<", bitwise);
diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-test.c
index d98569ce4a8f..04bf95c7ff6b 100644
--- a/tests/nft-expr_bitwise-test.c
+++ b/tests/nft-expr_bitwise-test.c
@@ -22,32 +22,32 @@ static void print_err(const char *test, const char *msg)
 	printf("\033[31mERROR:\e[0m [%s] %s\n", test, msg);
 }
 
-static void cmp_nftnl_expr_bool(struct nftnl_expr *rule_a,
-				struct nftnl_expr *rule_b)
+static void cmp_nftnl_expr_mask_xor(struct nftnl_expr *rule_a,
+				    struct nftnl_expr *rule_b)
 {
 	uint32_t maska, maskb;
 	uint32_t xora, xorb;
 
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_DREG) !=
 	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_DREG))
-		print_err("bool", "Expr BITWISE_DREG mismatches");
+		print_err("mask & xor", "Expr BITWISE_DREG mismatches");
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_SREG) !=
 	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_SREG))
-		print_err("bool", "Expr BITWISE_SREG mismatches");
+		print_err("mask & xor", "Expr BITWISE_SREG mismatches");
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_OP) !=
 	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_OP))
-		print_err("bool", "Expr BITWISE_OP mismatches");
+		print_err("mask & xor", "Expr BITWISE_OP mismatches");
 	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_LEN) !=
 	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_LEN))
-		print_err("bool", "Expr BITWISE_LEN mismatches");
+		print_err("mask & xor", "Expr BITWISE_LEN mismatches");
 	nftnl_expr_get(rule_a, NFTNL_EXPR_BITWISE_MASK, &maska);
 	nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_MASK, &maskb);
 	if (maska != maskb)
-		print_err("bool", "Size of BITWISE_MASK mismatches");
+		print_err("mask & xor", "Size of BITWISE_MASK mismatches");
 	nftnl_expr_get(rule_a, NFTNL_EXPR_BITWISE_XOR, &xora);
 	nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_XOR, &xorb);
 	if (xora != xorb)
-		print_err("bool", "Size of BITWISE_XOR mismatches");
+		print_err("mask & xor", "Size of BITWISE_XOR mismatches");
 }
 
 static void cmp_nftnl_expr_lshift(struct nftnl_expr *rule_a,
@@ -96,7 +96,7 @@ static void cmp_nftnl_expr_rshift(struct nftnl_expr *rule_a,
 		print_err("rshift", "Expr BITWISE_DATA mismatches");
 }
 
-static void test_bool(void)
+static void test_mask_xor(void)
 {
 	struct nftnl_rule *a, *b = NULL;
 	struct nftnl_expr *ex = NULL;
@@ -110,10 +110,10 @@ static void test_bool(void)
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
 	if (a == NULL || b == NULL)
-		print_err("bool", "OOM");
+		print_err("mask & xor", "OOM");
 	ex = nftnl_expr_alloc("bitwise");
 	if (ex == NULL)
-		print_err("bool", "OOM");
+		print_err("mask & xor", "OOM");
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_SREG, 0x12345678);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DREG, 0x78123456);
@@ -128,26 +128,26 @@ static void test_bool(void)
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("bool", "parsing problems");
+		print_err("mask & xor", "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
 	if (iter_a == NULL || iter_b == NULL)
-		print_err("bool", "OOM");
+		print_err("mask & xor", "OOM");
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
 	if (rule_a == NULL || rule_b == NULL)
-		print_err("bool", "OOM");
+		print_err("mask & xor", "OOM");
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("bool", "More 1 expr.");
+		print_err("mask & xor", "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 
-	cmp_nftnl_expr_bool(rule_a,rule_b);
+	cmp_nftnl_expr_mask_xor(rule_a,rule_b);
 
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
@@ -263,7 +263,7 @@ static void test_rshift(void)
 
 int main(int argc, char *argv[])
 {
-	test_bool();
+	test_mask_xor();
 	if (!test_ok)
 		exit(EXIT_FAILURE);
 
-- 
2.30.2

