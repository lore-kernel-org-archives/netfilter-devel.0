Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AB5A1CC174
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2024 15:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732030977; cv=none; b=hDvKJW4jIrlOFHVjiomxetAxOMdsjMx4Ik1OjpJoOIlYDIISWeHYWZhUuLVaSIn5oyLCOX+QdF4+5AGcmKuT+wcie+JvKNoPRJn7Zt9iqcnzlXKcHX+s7V51X5JzkdDFojWHJ5d98Sky4VVkWOnG57oYE61x3tfUVU6WEnT271E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732030977; c=relaxed/simple;
	bh=dwavaD1y6DIQrEAPLhgOZIDSO/CpQysaXzjvThudLkE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=trxkbrXcL1Mf0ZXBWP9jZb6naRg0jB7MG0/QfNQbQMaUh+nqcZy7/KxDicd3dohqyDWeQpzc/XF4LKy+KN7DmVOtbvJfkBAzg5l7bm7eHeAPKBUIav5dFnyaZomD0/3pkexKRx5M4bp5tLUjwNDDQkPi5WDcqXG2ec7tbggYxRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: jeremy@azazel.net
Subject: [PATCH libnftnl,v2 5/5] tests: bitwise: add tests for new boolean operations
Date: Tue, 19 Nov 2024 16:42:45 +0100
Message-Id: <20241119154245.442961-6-pablo@netfilter.org>
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

We already have tests for mask-and-xor operations with constant RHS
operands.  Add tests for new operations with variable RHS operands.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/nft-expr_bitwise-test.c | 105 ++++++++++++++++++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-test.c
index 0f3c26d2495a..784619e1d9c1 100644
--- a/tests/nft-expr_bitwise-test.c
+++ b/tests/nft-expr_bitwise-test.c
@@ -196,6 +196,99 @@ static void test_rshift(void)
 	test_shift(NFT_BITWISE_RSHIFT);
 }
 
+static void cmp_nftnl_expr_bool(const char *opname,
+				const struct nftnl_expr *rule_a,
+				const struct nftnl_expr *rule_b)
+{
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_DREG) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_DREG))
+		print_err(opname, "Expr BITWISE_DREG mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_SREG) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_SREG))
+		print_err(opname, "Expr BITWISE_SREG mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_SREG2) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_SREG2))
+		print_err(opname, "Expr BITWISE_SREG2 mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_OP) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_OP))
+		print_err(opname, "Expr BITWISE_OP mismatches");
+	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_LEN) !=
+	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_LEN))
+		print_err(opname, "Expr BITWISE_LEN mismatches");
+}
+
+static void test_bool(enum nft_bitwise_ops op)
+{
+	struct nftnl_rule *a, *b;
+	struct nftnl_expr *ex;
+	struct nlmsghdr *nlh;
+	char buf[4096];
+	struct nftnl_expr_iter *iter_a, *iter_b;
+	struct nftnl_expr *rule_a, *rule_b;
+	const char *opname =
+		op == NFT_BITWISE_AND ? "and" :
+		op == NFT_BITWISE_OR  ? "or"  : "xor";
+
+	a = nftnl_rule_alloc();
+	b = nftnl_rule_alloc();
+	if (a == NULL || b == NULL)
+		print_err(opname, "OOM");
+	ex = nftnl_expr_alloc("bitwise");
+	if (ex == NULL)
+		print_err(opname, "OOM");
+
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_SREG, 0x12345678);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_SREG2, 0x90abcdef);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DREG, 0x78123456);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_OP, op);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_LEN, 0x56781234);
+
+	nftnl_rule_add_expr(a, ex);
+
+	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nftnl_rule_nlmsg_build_payload(nlh, a);
+
+	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
+		print_err(opname, "parsing problems");
+
+	iter_a = nftnl_expr_iter_create(a);
+	iter_b = nftnl_expr_iter_create(b);
+	if (iter_a == NULL || iter_b == NULL)
+		print_err(opname, "OOM");
+
+	rule_a = nftnl_expr_iter_next(iter_a);
+	rule_b = nftnl_expr_iter_next(iter_b);
+	if (rule_a == NULL || rule_b == NULL)
+		print_err(opname, "OOM");
+
+	if (nftnl_expr_iter_next(iter_a) != NULL ||
+	    nftnl_expr_iter_next(iter_b) != NULL)
+		print_err(opname, "More 1 expr.");
+
+	nftnl_expr_iter_destroy(iter_a);
+	nftnl_expr_iter_destroy(iter_b);
+
+	cmp_nftnl_expr_bool(opname, rule_a, rule_b);
+
+	nftnl_rule_free(a);
+	nftnl_rule_free(b);
+}
+
+static void test_and(void)
+{
+	test_bool(NFT_BITWISE_AND);
+}
+
+static void test_or(void)
+{
+	test_bool(NFT_BITWISE_OR);
+}
+
+static void test_xor(void)
+{
+	test_bool(NFT_BITWISE_XOR);
+}
+
 int main(int argc, char *argv[])
 {
 	test_mask_xor();
@@ -210,6 +303,18 @@ int main(int argc, char *argv[])
 	if (!test_ok)
 		exit(EXIT_FAILURE);
 
+	test_and();
+	if (!test_ok)
+		exit(EXIT_FAILURE);
+
+	test_or();
+	if (!test_ok)
+		exit(EXIT_FAILURE);
+
+	test_xor();
+	if (!test_ok)
+		exit(EXIT_FAILURE);
+
 	printf("%s: \033[32mOK\e[0m\n", argv[0]);
 	return EXIT_SUCCESS;
 }
-- 
2.30.2

