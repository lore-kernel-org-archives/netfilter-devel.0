From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 2/3 v4 libnftnl] tests: Use libnftnl comparators in all tests
Date: Thu, 18 Aug 2016 07:45:50 +0200
Message-ID: <20160818054551.5136-2-carlosfg@riseup.net>
References: <20160818054551.5136-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:38803 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbcHRFqP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Aug 2016 01:46:15 -0400
In-Reply-To: <20160818054551.5136-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use 'nftnl_expr_cmp' and 'nftnl_rule_cmp' in all tests instead of custom
comparator for each one. If objects differ both are printed.

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 tests/libtest.c                 | 30 ++++++++++++++++++++++++++++++
 tests/libtest.h                 |  6 ++++++
 tests/nft-expr_bitwise-test.c   | 27 +--------------------------
 tests/nft-expr_byteorder-test.c | 22 +---------------------
 tests/nft-expr_cmp-test.c       | 19 +------------------
 tests/nft-expr_counter-test.c   | 13 +------------
 tests/nft-expr_ct-test.c        | 15 +--------------
 tests/nft-expr_dup-test.c       | 13 +------------
 tests/nft-expr_exthdr-test.c    | 19 +------------------
 tests/nft-expr_fwd-test.c       | 10 +---------
 tests/nft-expr_hash-test.c      | 19 +------------------
 tests/nft-expr_immediate-test.c | 40 ++--------------------------------------
 tests/nft-expr_limit-test.c     | 22 +---------------------
 tests/nft-expr_log-test.c       | 19 +------------------
 tests/nft-expr_lookup-test.c    | 25 +------------------------
 tests/nft-expr_masq-test.c      | 16 +---------------
 tests/nft-expr_match-test.c     | 20 +-------------------
 tests/nft-expr_meta-test.c      | 13 +------------
 tests/nft-expr_nat-test.c       | 28 +---------------------------
 tests/nft-expr_payload-test.c   | 19 +------------------
 tests/nft-expr_queue-test.c     | 13 +------------
 tests/nft-expr_redir-test.c     | 16 +---------------
 tests/nft-expr_reject-test.c    | 13 +------------
 tests/nft-expr_target-test.c    | 20 +-------------------
 tests/nft-rule-test.c           | 36 +-----------------------------------
 25 files changed, 60 insertions(+), 433 deletions(-)

diff --git a/tests/libtest.c b/tests/libtest.c
index 29a3172..6c1a123 100644
--- a/tests/libtest.c
+++ b/tests/libtest.c
@@ -51,3 +51,33 @@ int test_report(const char *prog)
 		return EXIT_FAILURE;
 	}
 }
+
+#define SNPRINTF_BUFF_LEN 1024
+
+static const char *rule2str(const struct nftnl_rule *r)
+{
+	static char buff[SNPRINTF_BUFF_LEN];
+	nftnl_rule_snprintf(buff, SNPRINTF_BUFF_LEN, r, NFTNL_OUTPUT_DEFAULT, 0);
+	return buff;
+}
+
+static const char *expr2str(const struct nftnl_expr *e)
+{
+	static char buff[SNPRINTF_BUFF_LEN];
+	nftnl_expr_snprintf(buff, SNPRINTF_BUFF_LEN, e, NFTNL_OUTPUT_DEFAULT, 0);
+	return buff;
+}
+
+void test_assert_expr(const struct nftnl_expr *e1, const struct nftnl_expr *e2)
+{
+	if (!nftnl_expr_cmp(e1, e2))
+		print_err("expressions mismatch:\n\texpr 1: %s\n\texpr 2: %s",
+			  expr2str(e1), expr2str(e2));
+}
+
+void test_assert_rule(const struct nftnl_rule *r1, const struct nftnl_rule *r2)
+{
+	if (!nftnl_rule_cmp(r1, r2))
+		print_err("rules mismatch:\nRULE 1:\n%s\nRULE 2:\n%s",
+			  rule2str(r1), rule2str(r2));
+}
diff --git a/tests/libtest.h b/tests/libtest.h
index f570057..dd1d5cb 100644
--- a/tests/libtest.h
+++ b/tests/libtest.h
@@ -2,10 +2,16 @@
 #define _TESTS_UTILS_H
 
 #include <stdbool.h>
+#include <libmnl/libmnl.h>
+#include <libnftnl/common.h>
+#include <libnftnl/rule.h>
+#include <libnftnl/expr.h>
 
 #define oom_assert(cond, prog) __oom_assert(cond, prog, __FILE__, __LINE__)
 void __oom_assert(bool cond, const char *prog, const char *file, int line);
 void print_err(const char *fmt, ...);
 int test_report(const char *prog);
+void test_assert_expr(const struct nftnl_expr *e1, const struct nftnl_expr *e2);
+void test_assert_rule(const struct nftnl_rule *r1, const struct nftnl_rule *r2);
 
 #endif
diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-test.c
index 42e9bb2..1eff343 100644
--- a/tests/nft-expr_bitwise-test.c
+++ b/tests/nft-expr_bitwise-test.c
@@ -21,31 +21,6 @@
 
 #include "libtest.h"
 
-static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
-			      struct nftnl_expr *rule_b)
-{
-	uint32_t maska, maskb;
-	uint32_t xora, xorb;
-
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_DREG) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_DREG))
-		print_err("Expr BITWISE_DREG mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_SREG) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_SREG))
-		print_err("Expr BITWISE_SREG mismatches");
-	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_LEN) !=
-	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_LEN))
-		print_err("Expr BITWISE_DREG mismatches");
-	nftnl_expr_get(rule_a, NFTNL_EXPR_BITWISE_MASK, &maska);
-	nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_MASK, &maskb);
-	if (maska != maskb)
-		print_err("Size of BITWISE_MASK mismatches");
-	nftnl_expr_get(rule_a, NFTNL_EXPR_BITWISE_XOR, &xora);
-	nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_XOR, &xorb);
-	if (xora != xorb)
-		print_err("Size of BITWISE_XOR mismatches");
-
-}
 int main(int argc, char *argv[])
 {
 	struct nftnl_rule *a, *b = NULL;
@@ -95,7 +70,7 @@ int main(int argc, char *argv[])
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 
-	cmp_nftnl_expr(rule_a,rule_b);
+	test_assert_expr(rule_a, rule_b);
 
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
diff --git a/tests/nft-expr_byteorder-test.c b/tests/nft-expr_byteorder-test.c
index 9a25667..1f77ea7 100644
--- a/tests/nft-expr_byteorder-test.c
+++ b/tests/nft-expr_byteorder-test.c
@@ -21,26 +21,6 @@
 
 #include "libtest.h"
 
-static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
-			      struct nftnl_expr *rule_b)
-{
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BYTEORDER_DREG) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BYTEORDER_DREG))
-		print_err("Expr NFTNL_EXPR_BYTEORDER_DREG mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BYTEORDER_SREG) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BYTEORDER_SREG))
-		print_err("Expr NFTNL_EXPR_BYTEORDER_SREG mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BYTEORDER_OP) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BYTEORDER_OP))
-		print_err("Expr NFTNL_EXPR_BYTEORDER_OP mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BYTEORDER_LEN) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BYTEORDER_LEN))
-		print_err("Expr NFTNL_EXPR_BYTEORDER_DREG mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BYTEORDER_SIZE) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BYTEORDER_SIZE))
-		print_err("Expr NFTNL_EXPR_BITWISE_SIZE mismatches");
-}
-
 int main(int argc, char *argv[])
 {
 	struct nftnl_rule *a, *b;
@@ -81,7 +61,7 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a,rule_b);
+	test_assert_expr(rule_a, rule_b);
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_cmp-test.c b/tests/nft-expr_cmp-test.c
index 570db2c..90c78b0 100644
--- a/tests/nft-expr_cmp-test.c
+++ b/tests/nft-expr_cmp-test.c
@@ -21,23 +21,6 @@
 
 #include "libtest.h"
 
-static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
-			      struct nftnl_expr *rule_b)
-{
-	uint32_t data_lena, data_lenb;
-
-	nftnl_expr_get(rule_a, NFTNL_EXPR_CMP_DATA, &data_lena);
-	nftnl_expr_get(rule_b, NFTNL_EXPR_CMP_DATA, &data_lenb);
-	if (data_lena != data_lenb)
-		print_err("Size of NFTNL_EXPR_CMP_DATA mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_CMP_SREG) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_CMP_SREG))
-		print_err("Expr NFTNL_EXPR_CMP_SREG mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_CMP_OP) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_CMP_OP))
-		print_err("Expr NFTNL_EXPR_CMP_OP mismatches");
-}
-
 int main(int argc, char *argv[])
 {
 	struct nftnl_rule *a, *b;
@@ -76,7 +59,7 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_assert_expr(rule_a, rule_b);
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_counter-test.c b/tests/nft-expr_counter-test.c
index 7066c26..d784a11 100644
--- a/tests/nft-expr_counter-test.c
+++ b/tests/nft-expr_counter-test.c
@@ -22,17 +22,6 @@
 #include "libtest.h"
 
 
-static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
-			      struct nftnl_expr *rule_b)
-{
-	if (nftnl_expr_get_u64(rule_a, NFTNL_EXPR_CTR_BYTES) !=
-	    nftnl_expr_get_u64(rule_b, NFTNL_EXPR_CTR_BYTES))
-		print_err("Expr NFTNL_EXPR_CTR_BYTES mismatches");
-	if (nftnl_expr_get_u64(rule_a, NFTNL_EXPR_CTR_PACKETS) !=
-	    nftnl_expr_get_u64(rule_b, NFTNL_EXPR_CTR_PACKETS))
-		print_err("Expr NFTNL_EXPR_CTR_PACKETS mismatches");
-}
-
 int main(int argc, char *argv[])
 {
 	struct nftnl_rule *a, *b;
@@ -69,7 +58,7 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_assert_expr(rule_a, rule_b);
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_ct-test.c b/tests/nft-expr_ct-test.c
index cfbe0d6..936803e 100644
--- a/tests/nft-expr_ct-test.c
+++ b/tests/nft-expr_ct-test.c
@@ -21,19 +21,6 @@
 
 #include "libtest.h"
 
-static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
-			      struct nftnl_expr *rule_b)
-{
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_CT_KEY) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_CT_KEY))
-		print_err("Expr CT_KEY mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_CT_DIR) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_CT_DIR))
-		print_err("Expr CT_DIR mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_CT_DREG) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_CT_DREG))
-		print_err("Expr CT_DREG mismatches");
-}
 int main(int argc, char *argv[])
 {
 	struct nftnl_rule *a, *b;
@@ -72,7 +59,7 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_assert_expr(rule_a, rule_b);
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_dup-test.c b/tests/nft-expr_dup-test.c
index 4ae112d..9c24764 100644
--- a/tests/nft-expr_dup-test.c
+++ b/tests/nft-expr_dup-test.c
@@ -21,17 +21,6 @@
 
 #include "libtest.h"
 
-static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
-			      struct nftnl_expr *rule_b)
-{
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_DUP_SREG_ADDR) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_DUP_SREG_ADDR))
-		print_err("Expr SREG_TO mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_DUP_SREG_DEV) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_DUP_SREG_DEV))
-		print_err("Expr SREG_OIF mismatches");
-}
-
 int main(int argc, char *argv[])
 {
 	struct nftnl_rule *a, *b;
@@ -69,7 +58,7 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_assert_expr(rule_a, rule_b);
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_exthdr-test.c b/tests/nft-expr_exthdr-test.c
index 56652b5..82c442e 100644
--- a/tests/nft-expr_exthdr-test.c
+++ b/tests/nft-expr_exthdr-test.c
@@ -21,23 +21,6 @@
 
 #include "libtest.h"
 
-static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
-			      struct nftnl_expr *rule_b)
-{
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_EXTHDR_DREG) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_EXTHDR_DREG))
-		print_err("Expr NFTNL_EXPR_EXTHDR_DREG mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_EXTHDR_TYPE) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_EXTHDR_TYPE))
-		print_err("Expr NFTNL_EXPR_EXTHDR_TYPE mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_EXTHDR_OFFSET) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_EXTHDR_OFFSET))
-		print_err("Expr NFTNL_EXPR_EXTHDR_OFFSET mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_EXTHDR_LEN) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_EXTHDR_LEN))
-		print_err("Expr NFTNL_EXPR_EXTHDR_LEN mismatches");
-}
-
 int main(int argc, char *argv[])
 {
 	struct nftnl_rule *a, *b;
@@ -76,7 +59,7 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_assert_expr(rule_a, rule_b);
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_fwd-test.c b/tests/nft-expr_fwd-test.c
index 7a27299..3f04a3f 100644
--- a/tests/nft-expr_fwd-test.c
+++ b/tests/nft-expr_fwd-test.c
@@ -21,14 +21,6 @@
 
 #include "libtest.h"
 
-static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
-			      struct nftnl_expr *rule_b)
-{
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_FWD_SREG_DEV) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_FWD_SREG_DEV))
-		print_err("Expr SREG_OIF mismatches");
-}
-
 int main(int argc, char *argv[])
 {
 	struct nftnl_rule *a, *b;
@@ -65,7 +57,7 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_assert_expr(rule_a, rule_b);
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_hash-test.c b/tests/nft-expr_hash-test.c
index 8040e0e..4472df8 100644
--- a/tests/nft-expr_hash-test.c
+++ b/tests/nft-expr_hash-test.c
@@ -21,23 +21,6 @@
 
 #include "libtest.h"
 
-static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
-			      struct nftnl_expr *rule_b)
-{
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_HASH_SREG) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_HASH_SREG))
-		print_err("Expr NFTNL_EXPR_HASH_SREG mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_HASH_DREG) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_HASH_DREG))
-		print_err("Expr NFTNL_EXPR_HASH_DREG mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_HASH_MODULUS) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_HASH_MODULUS))
-		print_err("Expr NFTNL_EXPR_HASH_MODULUS mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_HASH_SEED) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_HASH_SEED))
-		print_err("Expr NFTNL_EXPR_HASH_SEED mismatches");
-}
-
 int main(int argc, char *argv[])
 {
 	struct nftnl_rule *a, *b;
@@ -76,7 +59,7 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_a, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_assert_expr(rule_a, rule_b);
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_immediate-test.c b/tests/nft-expr_immediate-test.c
index 1e9749f..763eb0f 100644
--- a/tests/nft-expr_immediate-test.c
+++ b/tests/nft-expr_immediate-test.c
@@ -21,42 +21,6 @@
 
 #include "libtest.h"
 
-static void cmp_nftnl_expr_verdict(struct nftnl_expr *rule_a,
-				   struct nftnl_expr *rule_b)
-{
-	const char *chain_a, *chain_b;
-	uint32_t len_a, len_b;
-
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_IMM_DREG) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_IMM_DREG))
-		print_err("Expr NFTNL_EXPR_IMM_DREG mismatches");
-
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_IMM_VERDICT) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_IMM_VERDICT))
-		print_err("Expr NFTNL_EXPR_IMM_VERDICT mismatches");
-
-	chain_a = nftnl_expr_get(rule_a, NFTNL_EXPR_IMM_CHAIN, &len_a);
-	chain_b = nftnl_expr_get(rule_b, NFTNL_EXPR_IMM_CHAIN, &len_b);
-	if (len_a != len_b || strncmp(chain_a, chain_b, len_a))
-		print_err("Expr NFTNL_EXPR_IMM_CHAIN mismatches");
-}
-
-static void cmp_nftnl_expr_value(struct nftnl_expr *rule_a,
-				 struct nftnl_expr *rule_b)
-{
-	const uint32_t *data_a, *data_b;
-	uint32_t len_a, len_b;
-
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_IMM_DREG) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_IMM_DREG))
-		print_err("Expr NFTNL_EXPR_IMM_DREG mismatches");
-
-	data_a = nftnl_expr_get(rule_a, NFTNL_EXPR_IMM_DATA, &len_a);
-	data_b = nftnl_expr_get(rule_b, NFTNL_EXPR_IMM_DATA, &len_b);
-	if (len_a != len_b || memcmp(data_a, data_b, len_a))
-		print_err("Expr NFTNL_EXPR_IMM_DATA mismatches");
-}
-
 int main(int argc, char *argv[])
 {
 	struct nftnl_rule *a, *b;
@@ -103,14 +67,14 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr_value(rule_a, rule_b);
+	test_assert_expr(rule_a, rule_b);
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr_verdict(rule_a, rule_b);
+	test_assert_expr(rule_a, rule_b);
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_limit-test.c b/tests/nft-expr_limit-test.c
index 7848e29..bcdd357 100644
--- a/tests/nft-expr_limit-test.c
+++ b/tests/nft-expr_limit-test.c
@@ -22,26 +22,6 @@
 
 #include "libtest.h"
 
-static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
-			      struct nftnl_expr *rule_b)
-{
-	if (nftnl_expr_get_u64(rule_a, NFTNL_EXPR_LIMIT_RATE) !=
-	    nftnl_expr_get_u64(rule_b, NFTNL_EXPR_LIMIT_RATE))
-		print_err("Expr CTR_BYTES mismatches");
-	if (nftnl_expr_get_u64(rule_a, NFTNL_EXPR_LIMIT_UNIT) !=
-	    nftnl_expr_get_u64(rule_b, NFTNL_EXPR_LIMIT_UNIT))
-		print_err("Expr CTR_PACKET mismatches");
-	if (nftnl_expr_get_u64(rule_a, NFTNL_EXPR_LIMIT_BURST) !=
-	    nftnl_expr_get_u64(rule_b, NFTNL_EXPR_LIMIT_BURST))
-		print_err("Expr CTR_PACKET mismatches");
-	if (nftnl_expr_get_u64(rule_a, NFTNL_EXPR_LIMIT_TYPE) !=
-	    nftnl_expr_get_u64(rule_b, NFTNL_EXPR_LIMIT_TYPE))
-		print_err("Expr TYPE mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_LIMIT_FLAGS) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_LIMIT_FLAGS))
-		print_err("Expr FLAGS mismatches");
-}
-
 int main(int argc, char *argv[])
 {
 	struct nftnl_rule *a, *b;
@@ -82,7 +62,7 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_assert_expr(rule_a, rule_b);
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_log-test.c b/tests/nft-expr_log-test.c
index a2c1f1d..aad71b5 100644
--- a/tests/nft-expr_log-test.c
+++ b/tests/nft-expr_log-test.c
@@ -21,23 +21,6 @@
 
 #include "libtest.h"
 
-static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
-			      struct nftnl_expr *rule_b)
-{
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_LOG_SNAPLEN) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_LOG_SNAPLEN))
-		print_err("Expr NFTNL_EXPR_LOG_SNAPLEN mismatches");
-	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_LOG_GROUP) !=
-	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_LOG_GROUP))
-		print_err("Expr NFTNL_EXPR_LOG_GROUP mismatches");
-	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_LOG_QTHRESHOLD) !=
-	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_LOG_QTHRESHOLD))
-		print_err("Expr NFTNL_EXPR_LOG_QTHRESHOLD mismatches");
-	if(strcmp(nftnl_expr_get_str(rule_a, NFTNL_EXPR_LOG_PREFIX),
-		  nftnl_expr_get_str(rule_b, NFTNL_EXPR_LOG_PREFIX)) != 0)
-		print_err("Expr NFTNL_EXPR_LOG_PREFIX mismatches");
-}
-
 int main(int argc, char *argv[])
 {
 	struct nftnl_rule *a, *b;
@@ -75,7 +58,7 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_assert_expr(rule_a, rule_b);
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_lookup-test.c b/tests/nft-expr_lookup-test.c
index 34dffdf..dcbbcdb 100644
--- a/tests/nft-expr_lookup-test.c
+++ b/tests/nft-expr_lookup-test.c
@@ -21,29 +21,6 @@
 
 #include "libtest.h"
 
-static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
-			      struct nftnl_expr *rule_b)
-{
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_LOOKUP_SREG) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_LOOKUP_SREG))
-		print_err("Expr NFTNL_EXPR_LOOKUP_SREG mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_LOOKUP_DREG) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_LOOKUP_DREG))
-		print_err("Expr NFTNL_EXPR_LOOKUP_DREG mismatches");
-	if (strcmp(nftnl_expr_get_str(rule_a, NFTNL_EXPR_LOOKUP_SET),
-		   nftnl_expr_get_str(rule_b, NFTNL_EXPR_LOOKUP_SET)))
-		print_err("Expr NFTNL_EXPR_LOOKUP_SET mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_LOOKUP_SET_ID) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_LOOKUP_SET_ID))
-		print_err("Expr NFTNL_EXPR_LOOKUP_SET_ID mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_LOOKUP_FLAGS) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_LOOKUP_FLAGS)) {
-		print_err("Expr NFTNL_EXPR_LOOKUP_FLAGS mismatches");
-		printf("%X %X\n",
-			nftnl_expr_get_u32(rule_a, NFTNL_EXPR_LOOKUP_FLAGS),
-			nftnl_expr_get_u32(rule_b, NFTNL_EXPR_LOOKUP_FLAGS));
-	}
-}
 
 int main(int argc, char *argv[])
 {
@@ -84,7 +61,7 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_assert_expr(rule_a, rule_b);
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_masq-test.c b/tests/nft-expr_masq-test.c
index fdfbf03..8b7cfc7 100644
--- a/tests/nft-expr_masq-test.c
+++ b/tests/nft-expr_masq-test.c
@@ -19,20 +19,6 @@
 
 #include "libtest.h"
 
-static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
-			      struct nftnl_expr *rule_b)
-{
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_MASQ_FLAGS) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_MASQ_FLAGS))
-		print_err("Expr NFTNL_EXPR_MASQ_FLAGS mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_MASQ_REG_PROTO_MIN) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_MASQ_REG_PROTO_MIN))
-		print_err("Expr NFTNL_EXPR_MASQ_REG_PROTO_MIN mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_MASQ_REG_PROTO_MAX) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_MASQ_REG_PROTO_MAX))
-		print_err("Expr NFTNL_EXPR_MASQ_REG_PROTO_MAX mismatches");
-}
-
 int main(int argc, char *argv[])
 {
 	struct nftnl_rule *a, *b;
@@ -71,7 +57,7 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_assert_expr(rule_a, rule_b);
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_match-test.c b/tests/nft-expr_match-test.c
index 9902d2f..b410bc9 100644
--- a/tests/nft-expr_match-test.c
+++ b/tests/nft-expr_match-test.c
@@ -22,24 +22,6 @@
 
 #include "libtest.h"
 
-static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
-			      struct nftnl_expr *rule_b)
-{
-	uint32_t lena, lenb;
-
-	if (strcmp(nftnl_expr_get_str(rule_a, NFTNL_EXPR_MT_NAME),
-		   nftnl_expr_get_str(rule_b, NFTNL_EXPR_MT_NAME)) != 0)
-		print_err("Expr NFTNL_EXPR_MT_NAME mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_MT_REV) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_MT_REV))
-		print_err("Expr NFTNL_EXPR_MT_REV mismatches");
-	nftnl_expr_get(rule_a, NFTNL_EXPR_MT_INFO, &lena);
-	nftnl_expr_get(rule_b, NFTNL_EXPR_MT_INFO, &lenb);
-	if (lena != lenb)
-		print_err("Expr NFTNL_EXPR_MT_INFO size mismatches: %d != %d",
-			  lena, lenb);
-}
-
 int main(int argc, char *argv[])
 {
 	struct nftnl_rule *a, *b;
@@ -77,7 +59,7 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_assert_expr(rule_a, rule_b);
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_meta-test.c b/tests/nft-expr_meta-test.c
index e528631..9a812b7 100644
--- a/tests/nft-expr_meta-test.c
+++ b/tests/nft-expr_meta-test.c
@@ -21,17 +21,6 @@
 
 #include "libtest.h"
 
-static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
-			      struct nftnl_expr *rule_b)
-{
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_META_KEY) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_META_KEY))
-		print_err("Expr NFTNL_EXPR_META_KEY mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_META_DREG) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_META_DREG))
-		print_err("Expr NFTNL_EXPR_META_DREG mismatches");
-}
-
 int main(int argc, char *argv[])
 {
 	struct nftnl_rule *a, *b;
@@ -68,7 +57,7 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_assert_expr(rule_a, rule_b);
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_nat-test.c b/tests/nft-expr_nat-test.c
index d1cc0b1..eb8e2a5 100644
--- a/tests/nft-expr_nat-test.c
+++ b/tests/nft-expr_nat-test.c
@@ -22,32 +22,6 @@
 
 #include "libtest.h"
 
-static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
-			      struct nftnl_expr *rule_b)
-{
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_NAT_TYPE) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_NAT_TYPE))
-		print_err("Expr NFTNL_EXPR_NAT_TYPE mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_NAT_FAMILY) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_NAT_FAMILY))
-		print_err("Expr NFTNL_EXPR_NAT_FAMILY mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_NAT_REG_ADDR_MIN) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_NAT_REG_ADDR_MIN))
-		print_err("Expr NFTNL_EXPR_NAT_REG_ADDR_MIN mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_NAT_REG_ADDR_MAX) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_NAT_REG_ADDR_MAX))
-		print_err("Expr NFTNL_EXPR_NAT_REG_ADDR_MAX mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_NAT_REG_PROTO_MIN) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_NAT_REG_PROTO_MIN))
-		print_err("Expr NFTNL_EXPR_NAT_REG_PROTO_MIN mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_NAT_REG_PROTO_MAX) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_NAT_REG_PROTO_MAX))
-		print_err("Expr NFTNL_EXPR_NAT_REG_PROTO_MAX mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_NAT_FLAGS) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_NAT_FLAGS))
-		print_err("Expr NFTNL_EXPR_NAT_FLAGS mismatches");
-}
-
 int main(int argc, char *argv[])
 {
 	struct nftnl_rule *a, *b;
@@ -90,7 +64,7 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_assert_expr(rule_a, rule_b);
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_payload-test.c b/tests/nft-expr_payload-test.c
index 0812d6d..78f11ba 100644
--- a/tests/nft-expr_payload-test.c
+++ b/tests/nft-expr_payload-test.c
@@ -22,23 +22,6 @@
 
 #include "libtest.h"
 
-static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
-			      struct nftnl_expr *rule_b)
-{
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_PAYLOAD_DREG) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_PAYLOAD_DREG))
-		print_err("Expr NFTNL_EXPR_PAYLOAD_DREG mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_PAYLOAD_BASE) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_PAYLOAD_BASE))
-		print_err("Expr NFTNL_EXPR_PAYLOAD_BASE mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_PAYLOAD_OFFSET) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_PAYLOAD_OFFSET))
-		print_err("Expr NFTNL_EXPR_PAYLOAD_OFFSET mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_PAYLOAD_LEN) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_PAYLOAD_LEN))
-		print_err("Expr NFTNL_EXPR_PAYLOAD_LEN mismatches");
-}
-
 int main(int argc, char *argv[])
 {
 	struct nftnl_rule *a, *b;
@@ -77,7 +60,7 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_assert_expr(rule_a, rule_b);
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_queue-test.c b/tests/nft-expr_queue-test.c
index 327e8fd..1106766 100644
--- a/tests/nft-expr_queue-test.c
+++ b/tests/nft-expr_queue-test.c
@@ -24,17 +24,6 @@
 
 #include "libtest.h"
 
-static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
-			      struct nftnl_expr *rule_b)
-{
-	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_QUEUE_NUM) !=
-	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_QUEUE_NUM))
-		print_err("Expr NFTNL_EXPR_QUEUE_NUM mismatches");
-	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_QUEUE_TOTAL) !=
-	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_QUEUE_TOTAL))
-		print_err("Expr NFTNL_EXPR_QUEUE_TOTAL mismatches");
-}
-
 int main(int argc, char *argv[])
 {
 	struct nftnl_rule *a, *b;
@@ -73,7 +62,7 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_assert_expr(rule_a, rule_b);
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_redir-test.c b/tests/nft-expr_redir-test.c
index ce97928..978f09f 100644
--- a/tests/nft-expr_redir-test.c
+++ b/tests/nft-expr_redir-test.c
@@ -19,20 +19,6 @@
 
 #include "libtest.h"
 
-static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
-			      struct nftnl_expr *rule_b)
-{
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_REDIR_REG_PROTO_MIN) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_REDIR_REG_PROTO_MIN))
-		print_err("Expr NFTNL_EXPR_REDIR_REG_PROTO_MIN mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_REDIR_REG_PROTO_MAX) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_REDIR_REG_PROTO_MAX))
-		print_err("Expr NFTNL_EXPR_REDIR_REG_PROTO_MAX mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_REDIR_FLAGS) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_REDIR_FLAGS))
-		print_err("Expr NFTNL_EXPR_REDIR_FLAGS mismatches");
-}
-
 int main(int argc, char *argv[])
 {
 	struct nftnl_rule *a, *b;
@@ -71,7 +57,7 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_assert_expr(rule_a, rule_b);
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_reject-test.c b/tests/nft-expr_reject-test.c
index 426f9e9..0e42ae1 100644
--- a/tests/nft-expr_reject-test.c
+++ b/tests/nft-expr_reject-test.c
@@ -22,17 +22,6 @@
 
 #include "libtest.h"
 
-static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
-			      struct nftnl_expr *rule_b)
-{
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_REJECT_TYPE) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_REJECT_TYPE))
-		print_err("Expr NFTNL_EXPR_REJECT_TYPE mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_REJECT_CODE) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_REJECT_CODE))
-		print_err("Expr NFTNL_EXPR_REJECT_CODE mismatches");
-}
-
 int main(int argc, char *argv[])
 {
 	struct nftnl_rule *a, *b;
@@ -70,7 +59,7 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_assert_expr(rule_a, rule_b);
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_target-test.c b/tests/nft-expr_target-test.c
index 82a4a9f..1c750b6 100644
--- a/tests/nft-expr_target-test.c
+++ b/tests/nft-expr_target-test.c
@@ -21,24 +21,6 @@
 
 #include "libtest.h"
 
-static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
-			      struct nftnl_expr *rule_b)
-{
-	uint32_t lena, lenb;
-
-	if (strcmp(nftnl_expr_get_str(rule_a, NFTNL_EXPR_TG_NAME),
-		   nftnl_expr_get_str(rule_b, NFTNL_EXPR_TG_NAME)) != 0)
-		print_err("Expr NFTNL_EXPR_TG_NAME mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_TG_REV) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_TG_REV))
-		print_err("Expr NFTNL_EXPR_TG_REV mismatches");
-	nftnl_expr_get(rule_a, NFTNL_EXPR_TG_INFO, &lena);
-	nftnl_expr_get(rule_b, NFTNL_EXPR_TG_INFO, &lenb);
-	if (lena != lenb)
-		print_err("Expr NFTNL_EXPR_TG_INFO size mismatches: %d != %d",
-			  lena, lenb);
-}
-
 int main(int argc, char *argv[])
 {
 	struct nftnl_rule *a, *b;
@@ -78,7 +60,7 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_assert_expr(rule_a, rule_b);
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-rule-test.c b/tests/nft-rule-test.c
index c6ba719..a02abbc 100644
--- a/tests/nft-rule-test.c
+++ b/tests/nft-rule-test.c
@@ -19,40 +19,6 @@
 
 #include "libtest.h"
 
-static void cmp_nftnl_rule(struct nftnl_rule *a, struct nftnl_rule *b)
-{
-	const void *udata_a, *udata_b;
-	uint32_t len_a, len_b;
-
-	if (nftnl_rule_get_u32(a, NFTNL_RULE_FAMILY) !=
-	    nftnl_rule_get_u32(b, NFTNL_RULE_FAMILY))
-		print_err("Rule family mismatches");
-	if (strcmp(nftnl_rule_get_str(a, NFTNL_RULE_TABLE),
-		   nftnl_rule_get_str(b, NFTNL_RULE_TABLE)) != 0)
-		print_err("Rule table mismatches");
-	if (strcmp(nftnl_rule_get_str(a, NFTNL_RULE_CHAIN),
-		   nftnl_rule_get_str(b, NFTNL_RULE_CHAIN)) != 0)
-		print_err("Rule table mismatches");
-	if (nftnl_rule_get_u64(a, NFTNL_RULE_HANDLE) !=
-	    nftnl_rule_get_u64(b, NFTNL_RULE_HANDLE))
-		print_err("Rule handle mismatches");
-	if (nftnl_rule_get_u32(a, NFTNL_RULE_COMPAT_PROTO) !=
-	    nftnl_rule_get_u32(b, NFTNL_RULE_COMPAT_PROTO))
-		print_err("Rule compat_proto mismatches");
-	if (nftnl_rule_get_u32(a, NFTNL_RULE_COMPAT_FLAGS) !=
-	    nftnl_rule_get_u32(b, NFTNL_RULE_COMPAT_FLAGS))
-		print_err("Rule compat_flags mismatches");
-	if (nftnl_rule_get_u64(a, NFTNL_RULE_POSITION) !=
-	    nftnl_rule_get_u64(b, NFTNL_RULE_POSITION))
-		print_err("Rule compat_position mismatches");
-
-	udata_a = nftnl_rule_get_data(a, NFTNL_RULE_USERDATA, &len_a);
-	udata_b = nftnl_rule_get_data(b, NFTNL_RULE_USERDATA, &len_b);
-
-	if (len_a != len_b || memcmp(udata_a, udata_b, len_a) != 0)
-		print_err("Rule userdata mismatches");
-}
-
 int main(int argc, char *argv[])
 {
 	struct nftnl_udata_buf *udata;
@@ -89,7 +55,7 @@ int main(int argc, char *argv[])
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
 		print_err("parsing problems");
 
-	cmp_nftnl_rule(a,b);
+	test_assert_rule(a, b);
 
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
-- 
2.8.3

