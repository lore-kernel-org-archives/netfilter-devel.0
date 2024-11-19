Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FB491CCEDF
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2024 15:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732030975; cv=none; b=AjyegRrm/jJSp2LpUZlkjBpU/0ypVsHiWwGZ2OMw9VMymshRjiYp9B6pW8q+KTUQR2DO3KuHIfsjHbgDiYce734RjIn8ncyWRf48wQXtgVqgkvD5YaWxn9HG0ibgNY33/j/VnSxTE+ZSSXXd/VlflodR/ZiMrz2eQ1zOj9l7eK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732030975; c=relaxed/simple;
	bh=db6YYxLcrDv6sG6Wq6hfPLaLlNLbW/2TJuHRGy7bikU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oIZ/IBAD8nVx+VfRcuo+PXbaBNr2lYjU1t51PY/4HrK4+r3lflv2x9b2gInJk3dE6jj7PQixPHX+W6s77ZhR5ZL7nsu7t4QyEsW9RqGhEovrDLS8FsYK9YtTatkO9RrynHAq2fKsJSevdYJ9Nk19LHq8ujk90gsObXIif3hz51A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: jeremy@azazel.net
Subject: [PATCH libnftnl,v2 4/5] tests: bitwise: refactor shift tests
Date: Tue, 19 Nov 2024 16:42:44 +0100
Message-Id: <20241119154245.442961-5-pablo@netfilter.org>
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

Deduplicate shift tests: instead of having separate implementations
for left- and right-shifts, have one and pass the operation to it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/nft-expr_bitwise-test.c | 153 ++++++++++------------------------
 1 file changed, 44 insertions(+), 109 deletions(-)

diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-test.c
index 04bf95c7ff6b..0f3c26d2495a 100644
--- a/tests/nft-expr_bitwise-test.c
+++ b/tests/nft-expr_bitwise-test.c
@@ -50,52 +50,6 @@ static void cmp_nftnl_expr_mask_xor(struct nftnl_expr *rule_a,
 		print_err("mask & xor", "Size of BITWISE_XOR mismatches");
 }
 
-static void cmp_nftnl_expr_lshift(struct nftnl_expr *rule_a,
-				  struct nftnl_expr *rule_b)
-{
-	uint32_t data_a, data_b;
-
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_DREG) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_DREG))
-		print_err("lshift", "Expr BITWISE_DREG mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_SREG) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_SREG))
-		print_err("lshift", "Expr BITWISE_SREG mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_OP) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_OP))
-		print_err("lshift", "Expr BITWISE_OP mismatches");
-	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_LEN) !=
-	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_LEN))
-		print_err("lshift", "Expr BITWISE_LEN mismatches");
-	nftnl_expr_get(rule_a, NFTNL_EXPR_BITWISE_DATA, &data_a);
-	nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_DATA, &data_b);
-	if (data_a != data_b)
-		print_err("lshift", "Expr BITWISE_DATA mismatches");
-}
-
-static void cmp_nftnl_expr_rshift(struct nftnl_expr *rule_a,
-				  struct nftnl_expr *rule_b)
-{
-	uint32_t data_a, data_b;
-
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_DREG) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_DREG))
-		print_err("rshift", "Expr BITWISE_DREG mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_SREG) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_SREG))
-		print_err("rshift", "Expr BITWISE_SREG mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_OP) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_OP))
-		print_err("rshift", "Expr BITWISE_OP mismatches");
-	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_LEN) !=
-	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_LEN))
-		print_err("rshift", "Expr BITWISE_LEN mismatches");
-	nftnl_expr_get(rule_a, NFTNL_EXPR_BITWISE_DATA, &data_a);
-	nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_DATA, &data_b);
-	if (data_a != data_b)
-		print_err("rshift", "Expr BITWISE_DATA mismatches");
-}
-
 static void test_mask_xor(void)
 {
 	struct nftnl_rule *a, *b = NULL;
@@ -153,26 +107,51 @@ static void test_mask_xor(void)
 	nftnl_rule_free(b);
 }
 
-static void test_lshift(void)
+static void cmp_nftnl_expr_shift(const char *opname,
+				 const struct nftnl_expr *rule_a,
+				 const struct nftnl_expr *rule_b)
 {
-	struct nftnl_rule *a, *b = NULL;
-	struct nftnl_expr *ex = NULL;
+	uint32_t data_a, data_b;
+
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_DREG) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_DREG))
+		print_err(opname, "Expr BITWISE_DREG mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_SREG) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_SREG))
+		print_err(opname, "Expr BITWISE_SREG mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_OP) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_OP))
+		print_err(opname, "Expr BITWISE_OP mismatches");
+	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_LEN) !=
+	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_LEN))
+		print_err(opname, "Expr BITWISE_LEN mismatches");
+	nftnl_expr_get(rule_a, NFTNL_EXPR_BITWISE_DATA, &data_a);
+	nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_DATA, &data_b);
+	if (data_a != data_b)
+		print_err(opname, "Expr BITWISE_DATA mismatches");
+}
+
+static void test_shift(enum nft_bitwise_ops op)
+{
+	struct nftnl_rule *a, *b;
+	struct nftnl_expr *ex;
 	struct nlmsghdr *nlh;
 	char buf[4096];
-	struct nftnl_expr_iter *iter_a, *iter_b = NULL;
-	struct nftnl_expr *rule_a, *rule_b = NULL;
+	struct nftnl_expr_iter *iter_a, *iter_b;
+	struct nftnl_expr *rule_a, *rule_b;
+	const char *opname = op == NFT_BITWISE_LSHIFT ? "lshift" : "rshift";
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
 	if (a == NULL || b == NULL)
-		print_err("lshift", "OOM");
+		print_err(opname, "OOM");
 	ex = nftnl_expr_alloc("bitwise");
 	if (ex == NULL)
-		print_err("lshift", "OOM");
+		print_err(opname, "OOM");
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_SREG, 0x12345678);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DREG, 0x78123456);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_LSHIFT);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_OP, op);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_LEN, 0x56781234);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DATA, 13);
 
@@ -182,83 +161,39 @@ static void test_lshift(void)
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("lshift", "parsing problems");
+		print_err(opname, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
 	if (iter_a == NULL || iter_b == NULL)
-		print_err("lshift", "OOM");
+		print_err(opname, "OOM");
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
 	if (rule_a == NULL || rule_b == NULL)
-		print_err("lshift", "OOM");
+		print_err(opname, "OOM");
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("lshift", "More 1 expr.");
+		print_err(opname, "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 
-	cmp_nftnl_expr_lshift(rule_a,rule_b);
+	cmp_nftnl_expr_shift(opname, rule_a, rule_b);
 
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 }
 
-static void test_rshift(void)
+static void test_lshift(void)
 {
-	struct nftnl_rule *a, *b = NULL;
-	struct nftnl_expr *ex = NULL;
-	struct nlmsghdr *nlh;
-	char buf[4096];
-	struct nftnl_expr_iter *iter_a, *iter_b = NULL;
-	struct nftnl_expr *rule_a, *rule_b = NULL;
-
-	a = nftnl_rule_alloc();
-	b = nftnl_rule_alloc();
-	if (a == NULL || b == NULL)
-		print_err("rshift", "OOM");
-	ex = nftnl_expr_alloc("bitwise");
-	if (ex == NULL)
-		print_err("rshift", "OOM");
-
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_SREG, 0x12345678);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DREG, 0x78123456);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_RSHIFT);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_LEN, 0x56781234);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DATA, 17);
-
-	nftnl_rule_add_expr(a, ex);
-
-	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
-	nftnl_rule_nlmsg_build_payload(nlh, a);
-
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("rshift", "parsing problems");
-
-	iter_a = nftnl_expr_iter_create(a);
-	iter_b = nftnl_expr_iter_create(b);
-	if (iter_a == NULL || iter_b == NULL)
-		print_err("rshift", "OOM");
-
-	rule_a = nftnl_expr_iter_next(iter_a);
-	rule_b = nftnl_expr_iter_next(iter_b);
-	if (rule_a == NULL || rule_b == NULL)
-		print_err("rshift", "OOM");
-
-	if (nftnl_expr_iter_next(iter_a) != NULL ||
-	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("rshift", "More 1 expr.");
-
-	nftnl_expr_iter_destroy(iter_a);
-	nftnl_expr_iter_destroy(iter_b);
-
-	cmp_nftnl_expr_rshift(rule_a,rule_b);
+	test_shift(NFT_BITWISE_LSHIFT);
+}
 
-	nftnl_rule_free(a);
-	nftnl_rule_free(b);
+static void test_rshift(void)
+{
+	test_shift(NFT_BITWISE_RSHIFT);
 }
 
 int main(int argc, char *argv[])
-- 
2.30.2

