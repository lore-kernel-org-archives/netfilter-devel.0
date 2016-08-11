From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 2/2, libnftnl] Use libnftnl comparators in all tests
Date: Thu, 11 Aug 2016 15:25:07 +0200
Message-ID: <20160811132507.17842-2-carlosfg@riseup.net>
References: <20160811132507.17842-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:54795 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbcHKNZU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Aug 2016 09:25:20 -0400
In-Reply-To: <20160811132507.17842-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use 'nftnl_expr_cmp' and 'nftnl_rule_cmp' in all tests instead of custom
comparator for each one. If objects differ both are printed.

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 tests/libtest.c                 | 22 +++++++++++++++++++++
 tests/libtest.h                 |  9 +++++++++
 tests/nft-expr_bitwise-test.c   | 29 +++------------------------
 tests/nft-expr_byteorder-test.c | 24 +++-------------------
 tests/nft-expr_cmp-test.c       | 21 +++-----------------
 tests/nft-expr_counter-test.c   | 15 +++-----------
 tests/nft-expr_ct-test.c        | 17 +++-------------
 tests/nft-expr_dup-test.c       | 15 +++-----------
 tests/nft-expr_exthdr-test.c    | 21 +++-----------------
 tests/nft-expr_fwd-test.c       | 12 +++--------
 tests/nft-expr_immediate-test.c | 44 ++++++-----------------------------------
 tests/nft-expr_limit-test.c     | 24 +++-------------------
 tests/nft-expr_log-test.c       | 21 +++-----------------
 tests/nft-expr_lookup-test.c    | 27 +++----------------------
 tests/nft-expr_masq-test.c      | 18 +++--------------
 tests/nft-expr_match-test.c     | 22 +++------------------
 tests/nft-expr_meta-test.c      | 15 +++-----------
 tests/nft-expr_nat-test.c       | 30 +++-------------------------
 tests/nft-expr_payload-test.c   | 21 +++-----------------
 tests/nft-expr_queue-test.c     | 15 +++-----------
 tests/nft-expr_redir-test.c     | 18 +++--------------
 tests/nft-expr_reject-test.c    | 15 +++-----------
 tests/nft-expr_target-test.c    | 22 +++------------------
 tests/nft-rule-test.c           | 38 +++--------------------------------
 24 files changed, 100 insertions(+), 415 deletions(-)

diff --git a/tests/libtest.c b/tests/libtest.c
index 91f2d5e..9ce38ff 100644
--- a/tests/libtest.c
+++ b/tests/libtest.c
@@ -11,6 +11,8 @@
 #define COLOR_GREEN   "\x1b[32m"
 #define COLOR_RESET   "\x1b[0m"
 
+#define SNPRINTF_BUFF_LEN 1024
+
 static bool test_ok = true;
 
 void __oom(const char *prog, const char *file, int line)
@@ -47,3 +49,23 @@ int test_exit(const char *prog)
 		return EXIT_FAILURE;
 	}
 }
+
+const char *rule2str(const struct nftnl_rule *r)
+{
+	static char buff[SNPRINTF_BUFF_LEN];
+
+	nftnl_rule_snprintf(buff, SNPRINTF_BUFF_LEN, r,
+			    NFTNL_OUTPUT_DEFAULT, 0);
+
+	return buff;
+}
+
+const char *expr2str(const struct nftnl_expr *e)
+{
+	static char buff[SNPRINTF_BUFF_LEN];
+
+	nftnl_expr_snprintf(buff, SNPRINTF_BUFF_LEN, e,
+			    NFTNL_OUTPUT_DEFAULT, 0);
+
+	return buff;
+}
diff --git a/tests/libtest.h b/tests/libtest.h
index 810bd82..af469ce 100644
--- a/tests/libtest.h
+++ b/tests/libtest.h
@@ -1,9 +1,18 @@
 #ifndef _TESTS_UTILS_H
 #define _TESTS_UTILS_H
 
+#include <stdbool.h>
+#include <libmnl/libmnl.h>
+#include <libnftnl/common.h>
+#include <libnftnl/rule.h>
+#include <libnftnl/expr.h>
+
 #define oom(prog) __oom(prog, __FILE__, __LINE__)
 void __oom(const char *prog, const char *file, int line);
 void print_err(const char *fmt, ...);
 int test_exit(const char *prog);
 
+const char *rule2str(const struct nftnl_rule *r);
+const char *expr2str(const struct nftnl_expr *e);
+
 #endif
diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-test.c
index bf76cb2..a661be6 100644
--- a/tests/nft-expr_bitwise-test.c
+++ b/tests/nft-expr_bitwise-test.c
@@ -21,31 +21,6 @@
 
 #include <libtest.h>
 
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
@@ -96,7 +71,9 @@ int main(int argc, char *argv[])
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 
-	cmp_nftnl_expr(rule_a,rule_b);
+	if (!nftnl_expr_cmp(rule_a, rule_b))
+		print_err("expressions mismatches:\n\texpr 1: %s\n\texpr 2: %s",
+			  expr2str(rule_a), expr2str(rule_b));
 
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
diff --git a/tests/nft-expr_byteorder-test.c b/tests/nft-expr_byteorder-test.c
index cbdd1d7..46bfd44 100644
--- a/tests/nft-expr_byteorder-test.c
+++ b/tests/nft-expr_byteorder-test.c
@@ -21,26 +21,6 @@
 
 #include <libtest.h>
 
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
@@ -82,7 +62,9 @@ int main(int argc, char *argv[])
 	if (rule_a == NULL || rule_b == NULL)
 		oom(argv[0]);
 
-	cmp_nftnl_expr(rule_a,rule_b);
+	if (!nftnl_expr_cmp(rule_a,rule_b))
+		print_err("expressions mismatches:\n\texpr 1: %s\n\texpr 2: %s",
+			  expr2str(rule_a), expr2str(rule_b));
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_cmp-test.c b/tests/nft-expr_cmp-test.c
index 5c1917d..ffa4e9a 100644
--- a/tests/nft-expr_cmp-test.c
+++ b/tests/nft-expr_cmp-test.c
@@ -21,23 +21,6 @@
 
 #include <libtest.h>
 
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
@@ -77,7 +60,9 @@ int main(int argc, char *argv[])
 	if (rule_a == NULL || rule_b == NULL)
 		oom(argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	if (!nftnl_expr_cmp(rule_a, rule_b))
+		print_err("expressions mismatches:\n\texpr 1: %s\n\texpr 2: %s",
+			  expr2str(rule_a), expr2str(rule_b));
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_counter-test.c b/tests/nft-expr_counter-test.c
index 5bbaf68..8b592b1 100644
--- a/tests/nft-expr_counter-test.c
+++ b/tests/nft-expr_counter-test.c
@@ -22,17 +22,6 @@
 #include <libtest.h>
 
 
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
@@ -70,7 +59,9 @@ int main(int argc, char *argv[])
 	if (rule_a == NULL || rule_b == NULL)
 		oom(argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	if (!nftnl_expr_cmp(rule_a, rule_b))
+		print_err("expressions mismatches:\n\texpr 1: %s\n\texpr 2: %s",
+			  expr2str(rule_a), expr2str(rule_b));
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_ct-test.c b/tests/nft-expr_ct-test.c
index 0a19513..327b25e 100644
--- a/tests/nft-expr_ct-test.c
+++ b/tests/nft-expr_ct-test.c
@@ -21,19 +21,6 @@
 
 #include <libtest.h>
 
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
@@ -73,7 +60,9 @@ int main(int argc, char *argv[])
 	if (rule_a == NULL || rule_b == NULL)
 		oom(argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	if (!nftnl_expr_cmp(rule_a, rule_b))
+		print_err("expressions mismatches:\n\texpr 1: %s\n\texpr 2: %s",
+			  expr2str(rule_a), expr2str(rule_b));
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_dup-test.c b/tests/nft-expr_dup-test.c
index 11acd14..85702b7 100644
--- a/tests/nft-expr_dup-test.c
+++ b/tests/nft-expr_dup-test.c
@@ -21,17 +21,6 @@
 
 #include <libtest.h>
 
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
@@ -70,7 +59,9 @@ int main(int argc, char *argv[])
 	if (rule_a == NULL || rule_b == NULL)
 		oom(argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	if (!nftnl_expr_cmp(rule_a, rule_b))
+		print_err("expressions mismatches:\n\texpr 1: %s\n\texpr 2: %s",
+			  expr2str(rule_a), expr2str(rule_b));
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_exthdr-test.c b/tests/nft-expr_exthdr-test.c
index 1418bb5..562275c 100644
--- a/tests/nft-expr_exthdr-test.c
+++ b/tests/nft-expr_exthdr-test.c
@@ -21,23 +21,6 @@
 
 #include <libtest.h>
 
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
@@ -77,7 +60,9 @@ int main(int argc, char *argv[])
 	if (rule_a == NULL || rule_b == NULL)
 		oom(argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	if (!nftnl_expr_cmp(rule_a, rule_b))
+		print_err("expressions mismatches:\n\texpr 1: %s\n\texpr 2: %s",
+			  expr2str(rule_a), expr2str(rule_b));
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_fwd-test.c b/tests/nft-expr_fwd-test.c
index 70a72c3..4b5c739 100644
--- a/tests/nft-expr_fwd-test.c
+++ b/tests/nft-expr_fwd-test.c
@@ -21,14 +21,6 @@
 
 #include <libtest.h>
 
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
@@ -66,7 +58,9 @@ int main(int argc, char *argv[])
 	if (rule_a == NULL || rule_b == NULL)
 		oom(argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	if (!nftnl_expr_cmp(rule_a, rule_b))
+		print_err("expressions mismatches:\n\texpr 1: %s\n\texpr 2: %s",
+			  expr2str(rule_a), expr2str(rule_b));
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_immediate-test.c b/tests/nft-expr_immediate-test.c
index 088987f..731ba40 100644
--- a/tests/nft-expr_immediate-test.c
+++ b/tests/nft-expr_immediate-test.c
@@ -21,42 +21,6 @@
 
 #include <libtest.h>
 
-static void cmp_nftnl_expr_verdict(struct nftnl_expr *rule_a,
-				   struct nftnl_expr *rule_b)
-{
-	uint32_t len_a, len_b;
-	const char *chain_a, *chain_b;
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
@@ -103,14 +67,18 @@ int main(int argc, char *argv[])
 	if (rule_a == NULL || rule_b == NULL)
 		oom(argv[0]);
 
-	cmp_nftnl_expr_value(rule_a, rule_b);
+	if (!nftnl_expr_cmp(rule_a, rule_b))
+		print_err("expressions mismatches:\n\texpr 1: %s\n\texpr 2: %s",
+			  expr2str(rule_a), expr2str(rule_b));
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
 	if (rule_a == NULL || rule_b == NULL)
 		oom(argv[0]);
 
-	cmp_nftnl_expr_verdict(rule_a, rule_b);
+	if (!nftnl_expr_cmp(rule_a, rule_b))
+		print_err("expressions mismatches:\n\texpr 1: %s\n\texpr 2: %s",
+			  expr2str(rule_a), expr2str(rule_b));
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_limit-test.c b/tests/nft-expr_limit-test.c
index fc57775..197fb04 100644
--- a/tests/nft-expr_limit-test.c
+++ b/tests/nft-expr_limit-test.c
@@ -22,26 +22,6 @@
 
 #include <libtest.h>
 
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
@@ -83,7 +63,9 @@ int main(int argc, char *argv[])
 	if (rule_a == NULL || rule_b == NULL)
 		oom(argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	if (!nftnl_expr_cmp(rule_a, rule_b))
+		print_err("expressions mismatches:\n\texpr 1: %s\n\texpr 2: %s",
+			  expr2str(rule_a), expr2str(rule_b));
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_log-test.c b/tests/nft-expr_log-test.c
index 1ddad82..12bba13 100644
--- a/tests/nft-expr_log-test.c
+++ b/tests/nft-expr_log-test.c
@@ -21,23 +21,6 @@
 
 #include <libtest.h>
 
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
@@ -76,7 +59,9 @@ int main(int argc, char *argv[])
 	if (rule_a == NULL || rule_b == NULL)
 		oom(argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	if (!nftnl_expr_cmp(rule_a, rule_b))
+		print_err("expressions mismatches:\n\texpr 1: %s\n\texpr 2: %s",
+			  expr2str(rule_a), expr2str(rule_b));
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_lookup-test.c b/tests/nft-expr_lookup-test.c
index 68643f2..49a54ff 100644
--- a/tests/nft-expr_lookup-test.c
+++ b/tests/nft-expr_lookup-test.c
@@ -21,29 +21,6 @@
 
 #include <libtest.h>
 
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
@@ -85,7 +62,9 @@ int main(int argc, char *argv[])
 	if (rule_a == NULL || rule_b == NULL)
 		oom(argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	if (!nftnl_expr_cmp(rule_a, rule_b))
+		print_err("expressions mismatches:\n\texpr 1: %s\n\texpr 2: %s",
+			  expr2str(rule_a), expr2str(rule_b));
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_masq-test.c b/tests/nft-expr_masq-test.c
index 2727f37..a81f54c 100644
--- a/tests/nft-expr_masq-test.c
+++ b/tests/nft-expr_masq-test.c
@@ -19,20 +19,6 @@
 
 #include <libtest.h>
 
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
@@ -72,7 +58,9 @@ int main(int argc, char *argv[])
 	if (rule_a == NULL || rule_b == NULL)
 		oom(argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	if (!nftnl_expr_cmp(rule_a, rule_b))
+		print_err("expressions mismatches:\n\texpr 1: %s\n\texpr 2: %s",
+			  expr2str(rule_a), expr2str(rule_b));
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_match-test.c b/tests/nft-expr_match-test.c
index 14c32ab..700b6ff 100644
--- a/tests/nft-expr_match-test.c
+++ b/tests/nft-expr_match-test.c
@@ -22,24 +22,6 @@
 
 #include <libtest.h>
 
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
@@ -78,7 +60,9 @@ int main(int argc, char *argv[])
 	if (rule_a == NULL || rule_b == NULL)
 		oom(argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	if (!nftnl_expr_cmp(rule_a, rule_b))
+		print_err("expressions mismatches:\n\texpr 1: %s\n\texpr 2: %s",
+			  expr2str(rule_a), expr2str(rule_b));
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_meta-test.c b/tests/nft-expr_meta-test.c
index 72bfd1e..943ead2 100644
--- a/tests/nft-expr_meta-test.c
+++ b/tests/nft-expr_meta-test.c
@@ -21,17 +21,6 @@
 
 #include <libtest.h>
 
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
@@ -69,7 +58,9 @@ int main(int argc, char *argv[])
 	if (rule_a == NULL || rule_b == NULL)
 		oom(argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	if (!nftnl_expr_cmp(rule_a, rule_b))
+		print_err("expressions mismatches:\n\texpr 1: %s\n\texpr 2: %s",
+			  expr2str(rule_a), expr2str(rule_b));
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_nat-test.c b/tests/nft-expr_nat-test.c
index 5829d1d..fe20bcd 100644
--- a/tests/nft-expr_nat-test.c
+++ b/tests/nft-expr_nat-test.c
@@ -22,32 +22,6 @@
 
 #include <libtest.h>
 
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
@@ -91,7 +65,9 @@ int main(int argc, char *argv[])
 	if (rule_a == NULL || rule_b == NULL)
 		oom(argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	if (!nftnl_expr_cmp(rule_a, rule_b))
+		print_err("expressions mismatches:\n\texpr 1: %s\n\texpr 2: %s",
+			  expr2str(rule_a), expr2str(rule_b));
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_payload-test.c b/tests/nft-expr_payload-test.c
index f452f96..0999941 100644
--- a/tests/nft-expr_payload-test.c
+++ b/tests/nft-expr_payload-test.c
@@ -22,23 +22,6 @@
 
 #include <libtest.h>
 
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
@@ -78,7 +61,9 @@ int main(int argc, char *argv[])
 	if (rule_a == NULL || rule_b == NULL)
 		oom(argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	if (!nftnl_expr_cmp(rule_a, rule_b))
+		print_err("expressions mismatches:\n\texpr 1: %s\n\texpr 2: %s",
+			  expr2str(rule_a), expr2str(rule_b));
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_queue-test.c b/tests/nft-expr_queue-test.c
index b3c6848..210143e 100644
--- a/tests/nft-expr_queue-test.c
+++ b/tests/nft-expr_queue-test.c
@@ -24,17 +24,6 @@
 
 #include <libtest.h>
 
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
@@ -74,7 +63,9 @@ int main(int argc, char *argv[])
 	if (rule_a == NULL || rule_b == NULL)
 		oom(argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	if (!nftnl_expr_cmp(rule_a, rule_b))
+		print_err("expressions mismatches:\n\texpr 1: %s\n\texpr 2: %s",
+			  expr2str(rule_a), expr2str(rule_b));
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_redir-test.c b/tests/nft-expr_redir-test.c
index ce21dca..3948921 100644
--- a/tests/nft-expr_redir-test.c
+++ b/tests/nft-expr_redir-test.c
@@ -19,20 +19,6 @@
 
 #include <libtest.h>
 
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
@@ -72,7 +58,9 @@ int main(int argc, char *argv[])
 	if (rule_a == NULL || rule_b == NULL)
 		oom(argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	if (!nftnl_expr_cmp(rule_a, rule_b))
+		print_err("expressions mismatches:\n\texpr 1: %s\n\texpr 2: %s",
+			  expr2str(rule_a), expr2str(rule_b));
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_reject-test.c b/tests/nft-expr_reject-test.c
index cafd4ba..d92d4e0 100644
--- a/tests/nft-expr_reject-test.c
+++ b/tests/nft-expr_reject-test.c
@@ -22,17 +22,6 @@
 
 #include <libtest.h>
 
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
@@ -71,7 +60,9 @@ int main(int argc, char *argv[])
 	if (rule_a == NULL || rule_b == NULL)
 		oom(argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	if (!nftnl_expr_cmp(rule_a, rule_b))
+		print_err("expressions mismatches:\n\texpr 1: %s\n\texpr 2: %s",
+			  expr2str(rule_a), expr2str(rule_b));
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-expr_target-test.c b/tests/nft-expr_target-test.c
index 77d877c..c8611f3 100644
--- a/tests/nft-expr_target-test.c
+++ b/tests/nft-expr_target-test.c
@@ -21,24 +21,6 @@
 
 #include <libtest.h>
 
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
@@ -79,7 +61,9 @@ int main(int argc, char *argv[])
 	if (rule_a == NULL || rule_b == NULL)
 		oom(argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	if (!nftnl_expr_cmp(rule_a, rule_b))
+		print_err("expressions mismatches:\n\texpr 1: %s\n\texpr 2: %s",
+			  expr2str(rule_a), expr2str(rule_b));
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
diff --git a/tests/nft-rule-test.c b/tests/nft-rule-test.c
index 5c1b52d..57f5bb4 100644
--- a/tests/nft-rule-test.c
+++ b/tests/nft-rule-test.c
@@ -19,40 +19,6 @@
 
 #include <libtest.h>
 
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
@@ -90,7 +56,9 @@ int main(int argc, char *argv[])
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
 		print_err("parsing problems");
 
-	cmp_nftnl_rule(a,b);
+	if (!nftnl_rule_cmp(a, b))
+		print_err("rules mismatches:\nRULE 1:\n%s\nRULE 2:\n%s",
+			  rule2str(a), rule2str(b));
 
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
-- 
2.8.3

