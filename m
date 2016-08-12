From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 4/4, V2, libnftnl] tests: Use libnftnl comparators in all tests
Date: Fri, 12 Aug 2016 22:17:22 +0200
Message-ID: <20160812201722.10134-4-carlosfg@riseup.net>
References: <20160811233222.GB5108@salvia>
 <20160812201722.10134-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:50327 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbcHLUSC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 16:18:02 -0400
In-Reply-To: <20160812201722.10134-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use 'nftnl_expr_cmp' and 'nftnl_rule_cmp' in all tests instead of custom
comparator for each one. If objects differ both are printed.

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 tests/libtest.c                 | 44 +++++++++++++++----
 tests/libtest.h                 | 15 ++++++-
 tests/nft-chain-test.c          | 93 ++++++++++++++++++++++++-----------------
 tests/nft-expr_bitwise-test.c   | 40 ++++--------------
 tests/nft-expr_byteorder-test.c | 35 ++++------------
 tests/nft-expr_cmp-test.c       | 32 ++++----------
 tests/nft-expr_counter-test.c   | 26 ++++--------
 tests/nft-expr_ct-test.c        | 28 ++++---------
 tests/nft-expr_dup-test.c       | 26 ++++--------
 tests/nft-expr_exthdr-test.c    | 32 ++++----------
 tests/nft-expr_fwd-test.c       | 23 ++++------
 tests/nft-expr_immediate-test.c | 53 ++++-------------------
 tests/nft-expr_limit-test.c     | 35 ++++------------
 tests/nft-expr_log-test.c       | 32 ++++----------
 tests/nft-expr_lookup-test.c    | 38 ++++-------------
 tests/nft-expr_masq-test.c      | 29 ++++---------
 tests/nft-expr_match-test.c     | 33 ++++-----------
 tests/nft-expr_meta-test.c      | 26 ++++--------
 tests/nft-expr_nat-test.c       | 41 ++++--------------
 tests/nft-expr_payload-test.c   | 32 ++++----------
 tests/nft-expr_queue-test.c     | 26 ++++--------
 tests/nft-expr_redir-test.c     | 29 ++++---------
 tests/nft-expr_reject-test.c    | 26 ++++--------
 tests/nft-expr_target-test.c    | 33 ++++-----------
 tests/nft-rule-test.c           | 48 ++++-----------------
 tests/nft-set-test.c            | 72 ++++++++++++++++++-------------
 tests/nft-table-test.c          | 38 ++++++++++-------
 27 files changed, 348 insertions(+), 637 deletions(-)

diff --git a/tests/libtest.c b/tests/libtest.c
index ed7eafa..4b36f55 100644
--- a/tests/libtest.c
+++ b/tests/libtest.c
@@ -11,8 +11,6 @@
 #define COLOR_GREEN   "\x1b[32m"
 #define COLOR_RESET   "\x1b[0m"
 
-static bool test_ok = true;
-
 void __oom_assert(bool cond, const char *prog, const char *file, int line)
 {
 	if (cond)
@@ -22,25 +20,27 @@ void __oom_assert(bool cond, const char *prog, const char *file, int line)
 		COLOR_RED "OOM" COLOR_RESET " at %s:%d\n\t%s\n", file, line,
 		strerror(errno));
 
-	test_ok = false;
-	test_report(prog);
+	test_report(false, prog);
 	exit(EXIT_FAILURE);
 }
 
-void print_err(const char *fmt, ...)
+bool test_assert(bool cond, const char *fmt, ...)
 {
 	va_list args;
 
+	if (cond)
+		return true;
+
 	fprintf(stderr, COLOR_RED "ERROR: " COLOR_RESET);
 	va_start(args, fmt);
 	vfprintf(stderr, fmt, args);
 	va_end(args);
 	fprintf(stderr, "\n");
 
-	test_ok = false;
+	return false;
 }
 
-int test_report(const char *prog)
+int test_report(bool test_ok, const char *prog)
 {
 	switch (test_ok) {
 	case true:
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
+bool test_assert_expr(const struct nftnl_expr *e1, const struct nftnl_expr *e2)
+{
+	return test_assert(nftnl_expr_cmp(e1, e2),
+			   "expressions mismatch:\n\texpr 1: %s\n\texpr 2: %s",
+			   expr2str(e1), expr2str(e2));
+}
+
+bool test_assert_rule(const struct nftnl_rule *r1, const struct nftnl_rule *r2)
+{
+	return test_assert(nftnl_rule_cmp(r1, r2),
+			   "rules mismatch:\nRULE 1:\n%s\nRULE 2:\n%s",
+			   rule2str(r1), rule2str(r2));
+}
diff --git a/tests/libtest.h b/tests/libtest.h
index f570057..0f5aa9f 100644
--- a/tests/libtest.h
+++ b/tests/libtest.h
@@ -2,10 +2,21 @@
 #define _TESTS_UTILS_H
 
 #include <stdbool.h>
+#include <libmnl/libmnl.h>
+#include <libnftnl/common.h>
+#include <libnftnl/rule.h>
+#include <libnftnl/expr.h>
 
 #define oom_assert(cond, prog) __oom_assert(cond, prog, __FILE__, __LINE__)
 void __oom_assert(bool cond, const char *prog, const char *file, int line);
-void print_err(const char *fmt, ...);
-int test_report(const char *prog);
+bool test_assert(bool cond, const char *fmt, ...);
+int test_report(bool test_ok, const char *prog);
+bool test_assert_expr(const struct nftnl_expr *e1, const struct nftnl_expr *e2);
+bool test_assert_rule(const struct nftnl_rule *r1, const struct nftnl_rule *r2);
+
+/*
+ * const char *rule2str(const struct nftnl_rule *r);
+ * const char *expr2str(const struct nftnl_expr *e);
+ */
 
 #endif
diff --git a/tests/nft-chain-test.c b/tests/nft-chain-test.c
index b42fb86..1b6672a 100644
--- a/tests/nft-chain-test.c
+++ b/tests/nft-chain-test.c
@@ -19,43 +19,56 @@
 
 static void cmp_nftnl_chain(struct nftnl_chain *a, struct nftnl_chain *b)
 {
+	bool test_ok = true;
+	bool ret;
 
-	if (strcmp(nftnl_chain_get_str(a, NFTNL_CHAIN_NAME),
-		   nftnl_chain_get_str(b, NFTNL_CHAIN_NAME)) != 0)
-		print_err("Chain name mismatches");
-	if (strcmp(nftnl_chain_get_str(a, NFTNL_CHAIN_TABLE),
-		   nftnl_chain_get_str(b, NFTNL_CHAIN_TABLE)) != 0)
-		print_err("Chain table mismatches");
-	if (nftnl_chain_get_u32(a, NFTNL_CHAIN_FAMILY) !=
-	    nftnl_chain_get_u32(b, NFTNL_CHAIN_FAMILY))
-		print_err("Chain family mismatches");
-	if (nftnl_chain_get_u32(a, NFTNL_CHAIN_POLICY) !=
-	    nftnl_chain_get_u32(b, NFTNL_CHAIN_POLICY))
-		print_err("Chain policy mismatches");
-	if (nftnl_chain_get_u32(a, NFTNL_CHAIN_HOOKNUM) !=
-	    nftnl_chain_get_u32(b, NFTNL_CHAIN_HOOKNUM))
-		print_err("Chain hooknum mismatches");
-	if (nftnl_chain_get_s32(a, NFTNL_CHAIN_PRIO) !=
-	    nftnl_chain_get_s32(b, NFTNL_CHAIN_PRIO))
-		print_err("Chain Prio mismatches");
-	if (nftnl_chain_get_u32(a, NFTNL_CHAIN_USE) !=
-	    nftnl_chain_get_u32(b, NFTNL_CHAIN_USE))
-		print_err("Chain use mismatches");
-	if (nftnl_chain_get_u64(a, NFTNL_CHAIN_PACKETS) !=
-	    nftnl_chain_get_u64(b, NFTNL_CHAIN_PACKETS))
-		print_err("Chain packets mismatches");
-	if (nftnl_chain_get_u64(a, NFTNL_CHAIN_BYTES) !=
-	    nftnl_chain_get_u64(b, NFTNL_CHAIN_BYTES))
-		print_err("Chain bytes mismatches");
-	if (nftnl_chain_get_u64(a, NFTNL_CHAIN_HANDLE) !=
-	    nftnl_chain_get_u64(b, NFTNL_CHAIN_HANDLE))
-		print_err("Chain handle mismatches");
-	if (strcmp(nftnl_chain_get_str(a, NFTNL_CHAIN_TYPE),
-		   nftnl_chain_get_str(b, NFTNL_CHAIN_TYPE)) != 0)
-		print_err("Chain type mismatches");
-	if (strcmp(nftnl_chain_get_str(a, NFTNL_CHAIN_DEV),
-		   nftnl_chain_get_str(b, NFTNL_CHAIN_DEV)) != 0)
-		print_err("Chain device mismatches");
+	ret = !strcmp(nftnl_chain_get_str(a, NFTNL_CHAIN_NAME),
+		      nftnl_chain_get_str(b, NFTNL_CHAIN_NAME));
+	test_ok &= test_assert(ret, "Chain name mismatches");
+
+	ret = !strcmp(nftnl_chain_get_str(a, NFTNL_CHAIN_TABLE),
+		      nftnl_chain_get_str(b, NFTNL_CHAIN_TABLE));
+	test_ok &= test_assert(ret, "Chain table mismatches");
+
+	ret = nftnl_chain_get_u32(a, NFTNL_CHAIN_FAMILY) ==
+	      nftnl_chain_get_u32(b, NFTNL_CHAIN_FAMILY);
+	test_ok &= test_assert(ret, "Chain family mismatches");
+
+	ret = nftnl_chain_get_u32(a, NFTNL_CHAIN_POLICY) ==
+	      nftnl_chain_get_u32(b, NFTNL_CHAIN_POLICY);
+	test_ok &= test_assert(ret, "Chain policy mismatches");
+
+	ret = nftnl_chain_get_u32(a, NFTNL_CHAIN_HOOKNUM) ==
+	      nftnl_chain_get_u32(b, NFTNL_CHAIN_HOOKNUM);
+	test_ok &= test_assert(ret, "Chain hooknum mismatches");
+
+	ret = nftnl_chain_get_s32(a, NFTNL_CHAIN_PRIO) ==
+	      nftnl_chain_get_s32(b, NFTNL_CHAIN_PRIO);
+	test_ok &= test_assert(ret, "Chain Prio mismatches");
+
+	ret = nftnl_chain_get_u32(a, NFTNL_CHAIN_USE) ==
+	      nftnl_chain_get_u32(b, NFTNL_CHAIN_USE);
+	test_ok &= test_assert(ret, "Chain use mismatches");
+
+	ret = nftnl_chain_get_u64(a, NFTNL_CHAIN_PACKETS) ==
+	      nftnl_chain_get_u64(b, NFTNL_CHAIN_PACKETS);
+	test_ok &= test_assert(ret, "Chain packets mismatches");
+
+	ret = nftnl_chain_get_u64(a, NFTNL_CHAIN_BYTES) ==
+	      nftnl_chain_get_u64(b, NFTNL_CHAIN_BYTES);
+	test_ok &= test_assert(ret, "Chain bytes mismatches");
+
+	ret = nftnl_chain_get_u64(a, NFTNL_CHAIN_HANDLE) ==
+	      nftnl_chain_get_u64(b, NFTNL_CHAIN_HANDLE);
+	test_ok &= test_assert(ret, "Chain handle mismatches");
+
+	ret = !strcmp(nftnl_chain_get_str(a, NFTNL_CHAIN_TYPE),
+		      nftnl_chain_get_str(b, NFTNL_CHAIN_TYPE));
+	test_ok &= test_assert(ret, "Chain type mismatches");
+
+	ret = !strcmp(nftnl_chain_get_str(a, NFTNL_CHAIN_DEV),
+		      nftnl_chain_get_str(b, NFTNL_CHAIN_DEV));
+	test_ok &= test_assert(ret, "Chain device mismatches");
 }
 
 int main(int argc, char *argv[])
@@ -63,6 +76,8 @@ int main(int argc, char *argv[])
 	struct nftnl_chain *a, *b;
 	char buf[4096];
 	struct nlmsghdr *nlh;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_chain_alloc();
 	b = nftnl_chain_alloc();
@@ -87,14 +102,14 @@ int main(int argc, char *argv[])
 					0, 1234);
 	nftnl_chain_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_chain_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_chain_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	cmp_nftnl_chain(a, b);
 
 	nftnl_chain_free(a);
 	nftnl_chain_free(b);
 
-	return test_report(argv[0]);
+	return test_report(test_ok, argv[0]);
 
 }
diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-test.c
index 42e9bb2..8f6781f 100644
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
@@ -56,6 +31,8 @@ int main(int argc, char *argv[])
 	struct nftnl_expr *rule_a, *rule_b = NULL;
 	uint32_t mask = 0x01010101;
 	uint32_t xor = 0x12345678;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -75,8 +52,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -88,17 +65,16 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	if (nftnl_expr_iter_next(iter_a) != NULL ||
-	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("More 1 expr.");
+	ret = !nftnl_expr_iter_next(iter_a) && !nftnl_expr_iter_next(iter_b);
+	test_ok &= test_assert(ret, "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 
-	cmp_nftnl_expr(rule_a,rule_b);
+	test_ok &= test_assert_expr(rule_a, rule_b);
 
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	return test_report(argv[0]);
+	return test_report(test_ok, argv[0]);
 }
diff --git a/tests/nft-expr_byteorder-test.c b/tests/nft-expr_byteorder-test.c
index 9a25667..29df7a6 100644
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
@@ -49,6 +29,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -68,8 +50,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -81,16 +63,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a,rule_b);
+	test_ok &= test_assert_expr(rule_a, rule_b);
 
-	if (nftnl_expr_iter_next(iter_a) != NULL ||
-	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("More 1 expr.");
+	ret = !nftnl_expr_iter_next(iter_a) && !nftnl_expr_iter_next(iter_b);
+	test_ok &= test_assert(ret, "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	return test_report(argv[0]);
+	return test_report(test_ok, argv[0]);
 }
diff --git a/tests/nft-expr_cmp-test.c b/tests/nft-expr_cmp-test.c
index a8d6eb1..6c0d550 100644
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
@@ -47,6 +30,8 @@ int main(int argc, char *argv[])
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
 	uint32_t data_len = 0x01010101;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -64,8 +49,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -76,16 +61,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_ok &= test_assert_expr(rule_a, rule_b);
 
-	if (nftnl_expr_iter_next(iter_a) != NULL ||
-	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("More 1 expr.");
+	ret = !nftnl_expr_iter_next(iter_a) && !nftnl_expr_iter_next(iter_b);
+	test_ok &= test_assert(ret, "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	return test_report(argv[0]);
+	return test_report(test_ok, argv[0]);
 }
diff --git a/tests/nft-expr_counter-test.c b/tests/nft-expr_counter-test.c
index 7066c26..a6cb95d 100644
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
@@ -41,6 +30,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -57,8 +48,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -69,16 +60,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_ok &= test_assert_expr(rule_a, rule_b);
 
-	if (nftnl_expr_iter_next(iter_a) != NULL ||
-	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("More 1 expr.");
+	ret = !nftnl_expr_iter_next(iter_a) && !nftnl_expr_iter_next(iter_b);
+	test_ok &= test_assert(ret, "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	return test_report(argv[0]);
+	return test_report(test_ok, argv[0]);
 }
diff --git a/tests/nft-expr_ct-test.c b/tests/nft-expr_ct-test.c
index cfbe0d6..55f6d52 100644
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
@@ -42,6 +29,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -59,8 +48,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -72,16 +61,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_ok &= test_assert_expr(rule_a, rule_b);
 
-	if (nftnl_expr_iter_next(iter_a) != NULL ||
-	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("More 1 expr.");
+	ret = !nftnl_expr_iter_next(iter_a) && !nftnl_expr_iter_next(iter_b);
+	test_ok &= test_assert(ret, "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	return test_report(argv[0]);
+	return test_report(test_ok, argv[0]);
 }
diff --git a/tests/nft-expr_dup-test.c b/tests/nft-expr_dup-test.c
index 4ae112d..4c90b41 100644
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
@@ -40,6 +29,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -56,8 +47,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -69,16 +60,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_ok &= test_assert_expr(rule_a, rule_b);
 
-	if (nftnl_expr_iter_next(iter_a) != NULL ||
-	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("More 1 expr.");
+	ret = !nftnl_expr_iter_next(iter_a) && !nftnl_expr_iter_next(iter_b);
+	test_ok &= test_assert(ret, "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	return test_report(argv[0]);
+	return test_report(test_ok, argv[0]);
 }
diff --git a/tests/nft-expr_exthdr-test.c b/tests/nft-expr_exthdr-test.c
index 56652b5..26642c3 100644
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
@@ -46,6 +29,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -63,8 +48,8 @@ int main(int argc, char *argv[])
 
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -76,16 +61,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_ok &= test_assert_expr(rule_a, rule_b);
 
-	if (nftnl_expr_iter_next(iter_a) != NULL ||
-	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("More 1 expr.");
+	ret = !nftnl_expr_iter_next(iter_a) && !nftnl_expr_iter_next(iter_b);
+	test_ok &= test_assert(ret, "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	return test_report(argv[0]);
+	return test_report(test_ok, argv[0]);
 }
diff --git a/tests/nft-expr_fwd-test.c b/tests/nft-expr_fwd-test.c
index 7a27299..385ca8e 100644
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
@@ -37,6 +29,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -52,8 +46,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -65,16 +59,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_ok &= test_assert_expr(rule_a, rule_b);
 
-	if (nftnl_expr_iter_next(iter_a) != NULL ||
-	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("More 1 expr.");
+	ret = !nftnl_expr_iter_next(iter_a) && !nftnl_expr_iter_next(iter_b);
+	test_ok &= test_assert(ret, "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	return test_report(argv[0]);
+	return test_report(test_ok, argv[0]);
 }
diff --git a/tests/nft-expr_immediate-test.c b/tests/nft-expr_immediate-test.c
index ecc1b5d..fba84f1 100644
--- a/tests/nft-expr_immediate-test.c
+++ b/tests/nft-expr_immediate-test.c
@@ -21,42 +21,6 @@
 
 #include "libtest.h"
 
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
@@ -67,6 +31,8 @@ int main(int argc, char *argv[])
 	struct nftnl_expr *rule_a, *rule_b;
 	char chain[] = "tests_chain01234";
 	char data[] = "test_data_01234";
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -90,8 +56,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -103,23 +69,22 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr_value(rule_a, rule_b);
+	test_ok &= test_assert_expr(rule_a, rule_b);
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr_verdict(rule_a, rule_b);
+	test_ok &= test_assert_expr(rule_a, rule_b);
 
-	if (nftnl_expr_iter_next(iter_a) != NULL ||
-	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("More 2 expr.");
+	ret = !nftnl_expr_iter_next(iter_a) && !nftnl_expr_iter_next(iter_b);
+	test_ok &= test_assert(ret, "More 2 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	return test_report(argv[0]);
+	return test_report(test_ok, argv[0]);
 }
diff --git a/tests/nft-expr_limit-test.c b/tests/nft-expr_limit-test.c
index 7848e29..a5cb137 100644
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
@@ -50,6 +30,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -69,8 +51,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -82,16 +64,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_ok &= test_assert_expr(rule_a, rule_b);
 
-	if (nftnl_expr_iter_next(iter_a) != NULL ||
-	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("More 1 expr.");
+	ret = !nftnl_expr_iter_next(iter_a) && !nftnl_expr_iter_next(iter_b);
+	test_ok &= test_assert(ret, "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	return test_report(argv[0]);
+	return test_report(test_ok, argv[0]);
 }
diff --git a/tests/nft-expr_log-test.c b/tests/nft-expr_log-test.c
index a2c1f1d..7dbbf34 100644
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
@@ -46,6 +29,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -63,8 +48,8 @@ int main(int argc, char *argv[])
 
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -75,16 +60,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_ok &= test_assert_expr(rule_a, rule_b);
 
-	if (nftnl_expr_iter_next(iter_a) != NULL ||
-	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("More 1 expr.");
+	ret = !nftnl_expr_iter_next(iter_a) && !nftnl_expr_iter_next(iter_b);
+	test_ok &= test_assert(ret, "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	return test_report(argv[0]);
+	return test_report(test_ok, argv[0]);
 }
diff --git a/tests/nft-expr_lookup-test.c b/tests/nft-expr_lookup-test.c
index f7bb7f4..8301a11 100644
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
@@ -54,6 +31,8 @@ int main(int argc, char *argv[])
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
 	char lookup_set[] = "test_set_01243";
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -72,8 +51,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -84,16 +63,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_ok &= test_assert_expr(rule_a, rule_b);
 
-	if (nftnl_expr_iter_next(iter_a) != NULL ||
-	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("More 1 expr.");
+	ret = !nftnl_expr_iter_next(iter_a) && !nftnl_expr_iter_next(iter_b);
+	test_ok &= test_assert(ret, "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	return test_report(argv[0]);
+	return test_report(test_ok, argv[0]);
 }
diff --git a/tests/nft-expr_masq-test.c b/tests/nft-expr_masq-test.c
index fdfbf03..b93fc27 100644
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
@@ -41,6 +27,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -58,8 +46,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -71,16 +59,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_ok &= test_assert_expr(rule_a, rule_b);
 
-	if (nftnl_expr_iter_next(iter_a) != NULL ||
-	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("More 1 expr.");
+	ret = !nftnl_expr_iter_next(iter_a) && !nftnl_expr_iter_next(iter_b);
+	test_ok &= test_assert(ret, "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	return test_report(argv[0]);
+	return test_report(test_ok, argv[0]);
 }
diff --git a/tests/nft-expr_match-test.c b/tests/nft-expr_match-test.c
index 9902d2f..78868bf 100644
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
@@ -49,6 +31,8 @@ int main(int argc, char *argv[])
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
 	char data[16] = "0123456789abcdef";
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -65,8 +49,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
 	oom_assert(iter_a, argv[0]);
@@ -77,16 +61,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_ok &= test_assert_expr(rule_a, rule_b);
 
-	if (nftnl_expr_iter_next(iter_a) != NULL ||
-	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("More 1 expr.");
+	ret = !nftnl_expr_iter_next(iter_a) && !nftnl_expr_iter_next(iter_b);
+	test_ok &= test_assert(ret, "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	return test_report(argv[0]);
+	return test_report(test_ok, argv[0]);
 }
diff --git a/tests/nft-expr_meta-test.c b/tests/nft-expr_meta-test.c
index e528631..44fa022 100644
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
@@ -40,6 +29,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -55,8 +46,8 @@ int main(int argc, char *argv[])
 
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -68,16 +59,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_ok &= test_assert_expr(rule_a, rule_b);
 
-	if (nftnl_expr_iter_next(iter_a) != NULL ||
-	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("More 1 expr.");
+	ret = !nftnl_expr_iter_next(iter_a) && !nftnl_expr_iter_next(iter_b);
+	test_ok &= test_assert(ret, "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	return test_report(argv[0]);
+	return test_report(test_ok, argv[0]);
 }
diff --git a/tests/nft-expr_nat-test.c b/tests/nft-expr_nat-test.c
index fdd91ba..9e8447a 100644
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
@@ -56,6 +30,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -77,8 +53,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -90,16 +66,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_ok &= test_assert_expr(rule_a, rule_b);
 
-	if (nftnl_expr_iter_next(iter_a) != NULL ||
-	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("More 1 expr.");
+	ret = !nftnl_expr_iter_next(iter_a) && !nftnl_expr_iter_next(iter_b);
+	test_ok &= test_assert(ret, "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	return test_report(argv[0]);
+	return test_report(test_ok, argv[0]);
 }
diff --git a/tests/nft-expr_payload-test.c b/tests/nft-expr_payload-test.c
index 0812d6d..dc52916 100644
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
@@ -47,6 +30,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -64,8 +49,8 @@ int main(int argc, char *argv[])
 
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -77,16 +62,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_ok &= test_assert_expr(rule_a, rule_b);
 
-	if (nftnl_expr_iter_next(iter_a) != NULL ||
-	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("More 1 expr.");
+	ret = !nftnl_expr_iter_next(iter_a) && !nftnl_expr_iter_next(iter_b);
+	test_ok &= test_assert(ret, "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	return test_report(argv[0]);
+	return test_report(test_ok, argv[0]);
 }
diff --git a/tests/nft-expr_queue-test.c b/tests/nft-expr_queue-test.c
index 327e8fd..d266882 100644
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
@@ -43,6 +32,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -60,8 +51,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -73,16 +64,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_ok &= test_assert_expr(rule_a, rule_b);
 
-	if (nftnl_expr_iter_next(iter_a) != NULL ||
-	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("More 1 expr.");
+	ret = !nftnl_expr_iter_next(iter_a) && !nftnl_expr_iter_next(iter_b);
+	test_ok &= test_assert(ret, "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	return test_report(argv[0]);
+	return test_report(test_ok, argv[0]);
 }
diff --git a/tests/nft-expr_redir-test.c b/tests/nft-expr_redir-test.c
index ce97928..ed3ff65 100644
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
@@ -41,6 +27,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -58,8 +46,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("Parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "Parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -71,16 +59,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_ok &= test_assert_expr(rule_a, rule_b);
 
-	if (nftnl_expr_iter_next(iter_a) != NULL ||
-	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("More than 1 expr.");
+	ret = !nftnl_expr_iter_next(iter_a) && !nftnl_expr_iter_next(iter_b);
+	test_ok &= test_assert(ret, "More than 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	return test_report(argv[0]);
+	return test_report(test_ok, argv[0]);
 }
diff --git a/tests/nft-expr_reject-test.c b/tests/nft-expr_reject-test.c
index 426f9e9..8edc240 100644
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
@@ -41,6 +30,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -57,8 +48,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -70,16 +61,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_ok &= test_assert_expr(rule_a, rule_b);
 
-	if (nftnl_expr_iter_next(iter_a) != NULL ||
-	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("More 1 expr.");
+	ret = !nftnl_expr_iter_next(iter_a) && !nftnl_expr_iter_next(iter_b);
+	test_ok &= test_assert(ret, "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	return test_report(argv[0]);
+	return test_report(test_ok, argv[0]);
 }
diff --git a/tests/nft-expr_target-test.c b/tests/nft-expr_target-test.c
index 82a4a9f..00a3c0d 100644
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
@@ -48,6 +30,8 @@ int main(int argc, char *argv[])
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
 	char data[16] = "0123456789abcdef";
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -65,8 +49,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -78,16 +62,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	test_ok &= test_assert_expr(rule_a, rule_b);
 
-	if (nftnl_expr_iter_next(iter_a) != NULL ||
-	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("More 1 expr.");
+	ret = !nftnl_expr_iter_next(iter_a) && !nftnl_expr_iter_next(iter_b);
+	test_ok &= test_assert(ret, "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	return test_report(argv[0]);
+	return test_report(test_ok, argv[0]);
 }
diff --git a/tests/nft-rule-test.c b/tests/nft-rule-test.c
index c6ba719..2479cc3 100644
--- a/tests/nft-rule-test.c
+++ b/tests/nft-rule-test.c
@@ -19,46 +19,14 @@
 
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
 	struct nftnl_rule *a, *b;
 	char buf[4096];
 	struct nlmsghdr *nlh;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -68,8 +36,8 @@ int main(int argc, char *argv[])
 	udata = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
 	oom_assert(udata, argv[0]);
 
-	if (!nftnl_udata_put_strz(udata, 0, "hello world"))
-		print_err("User data too big");
+	ret = nftnl_udata_put_strz(udata, 0, "hello world");
+	test_ok &= test_assert(ret, "User data too big");
 
 	nftnl_rule_set_u32(a, NFTNL_RULE_FAMILY, AF_INET);
 	nftnl_rule_set_str(a, NFTNL_RULE_TABLE, "table");
@@ -86,13 +54,13 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
-	cmp_nftnl_rule(a,b);
+	test_ok &= test_assert_rule(a, b);
 
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	return test_report(argv[0]);
+	return test_report(test_ok, argv[0]);
 }
diff --git a/tests/nft-set-test.c b/tests/nft-set-test.c
index 6f9b03d..24e1c62 100644
--- a/tests/nft-set-test.c
+++ b/tests/nft-set-test.c
@@ -18,32 +18,44 @@
 
 #include "libtest.h"
 
-static void cmp_nftnl_set(struct nftnl_set *a, struct nftnl_set *b)
+static bool cmp_nftnl_set(struct nftnl_set *a, struct nftnl_set *b)
 {
-	if (strcmp(nftnl_set_get_str(a, NFTNL_SET_TABLE),
-		   nftnl_set_get_str(b, NFTNL_SET_TABLE)) != 0)
-		print_err("Set table mismatches");
-	if (strcmp(nftnl_set_get_str(a, NFTNL_SET_NAME),
-		   nftnl_set_get_str(b, NFTNL_SET_NAME)) != 0)
-		print_err("Set name mismatches");
-	if (nftnl_set_get_u32(a, NFTNL_SET_FLAGS) !=
-	    nftnl_set_get_u32(b, NFTNL_SET_FLAGS))
-		print_err("Set flags mismatches");
-	if (nftnl_set_get_u32(a, NFTNL_SET_KEY_TYPE) !=
-	    nftnl_set_get_u32(b, NFTNL_SET_KEY_TYPE))
-		print_err("Set key-type mismatches");
-	if (nftnl_set_get_u32(a, NFTNL_SET_KEY_LEN) !=
-	    nftnl_set_get_u32(b, NFTNL_SET_KEY_LEN))
-		print_err("Set key-len mismatches");
-	if (nftnl_set_get_u32(a, NFTNL_SET_DATA_TYPE) !=
-	    nftnl_set_get_u32(b, NFTNL_SET_DATA_TYPE))
-		print_err("Set data-type mismatches");
-	if (nftnl_set_get_u32(a, NFTNL_SET_DATA_LEN) !=
-	    nftnl_set_get_u32(b, NFTNL_SET_DATA_LEN))
-		print_err("Set data-len mismatches");
-	if (strcmp(nftnl_set_get_str(a, NFTNL_SET_USERDATA),
-		   nftnl_set_get_str(b, NFTNL_SET_USERDATA)) != 0)
-		print_err("Set userdata mismatches");
+	bool test_ok = true;
+	bool ret;
+
+	ret = !strcmp(nftnl_set_get_str(a, NFTNL_SET_TABLE),
+		      nftnl_set_get_str(b, NFTNL_SET_TABLE));
+	test_ok &= test_assert(ret, "Set table mismatches");
+
+	ret = !strcmp(nftnl_set_get_str(a, NFTNL_SET_NAME),
+		      nftnl_set_get_str(b, NFTNL_SET_NAME));
+	test_ok &= test_assert(ret, "Set name mismatches");
+
+	ret = nftnl_set_get_u32(a, NFTNL_SET_FLAGS) ==
+	      nftnl_set_get_u32(b, NFTNL_SET_FLAGS);
+	test_ok &= test_assert(ret, "Set flags mismatches");
+
+	ret = nftnl_set_get_u32(a, NFTNL_SET_KEY_TYPE) ==
+	      nftnl_set_get_u32(b, NFTNL_SET_KEY_TYPE);
+	test_ok &= test_assert(ret, "Set key-type mismatches");
+
+	ret = nftnl_set_get_u32(a, NFTNL_SET_KEY_LEN) ==
+	      nftnl_set_get_u32(b, NFTNL_SET_KEY_LEN);
+	test_ok &= test_assert(ret, "Set key-len mismatches");
+
+	ret = nftnl_set_get_u32(a, NFTNL_SET_DATA_TYPE) ==
+	      nftnl_set_get_u32(b, NFTNL_SET_DATA_TYPE);
+	test_ok &= test_assert(ret, "Set data-type mismatches");
+
+	ret = nftnl_set_get_u32(a, NFTNL_SET_DATA_LEN) ==
+	      nftnl_set_get_u32(b, NFTNL_SET_DATA_LEN);
+	test_ok &= test_assert(ret, "Set data-len mismatches");
+
+	ret = !strcmp(nftnl_set_get_str(a, NFTNL_SET_USERDATA),
+		    nftnl_set_get_str(b, NFTNL_SET_USERDATA));
+	test_ok &= test_assert(ret, "Set userdata mismatches");
+
+	return test_ok;
 }
 
 int main(int argc, char *argv[])
@@ -51,6 +63,8 @@ int main(int argc, char *argv[])
 	struct nftnl_set *a, *b = NULL;
 	char buf[4096];
 	struct nlmsghdr *nlh;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_set_alloc();
 	b = nftnl_set_alloc();
@@ -71,12 +85,12 @@ int main(int argc, char *argv[])
 	nlh = nftnl_set_nlmsg_build_hdr(buf, NFT_MSG_NEWSET, AF_INET, 0, 1234);
 	nftnl_set_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_set_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_set_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
-	cmp_nftnl_set(a,b);
+	test_ok &= cmp_nftnl_set(a,b);
 
 	nftnl_set_free(a); nftnl_set_free(b);
 
-	return test_report(argv[0]);
+	return test_report(test_ok, argv[0]);
 }
diff --git a/tests/nft-table-test.c b/tests/nft-table-test.c
index 6b0418f..d53541a 100644
--- a/tests/nft-table-test.c
+++ b/tests/nft-table-test.c
@@ -18,17 +18,24 @@
 
 #include "libtest.h"
 
-static void cmp_nftnl_table(struct nftnl_table *a, struct nftnl_table *b)
+static bool cmp_nftnl_table(struct nftnl_table *a, struct nftnl_table *b)
 {
-	if (strcmp(nftnl_table_get_str(a, NFTNL_TABLE_NAME),
-		   nftnl_table_get_str(b, NFTNL_TABLE_NAME)) != 0)
-		print_err("table name mismatches");
-	if (nftnl_table_get_u32(a, NFTNL_TABLE_FLAGS) !=
-	    nftnl_table_get_u32(b, NFTNL_TABLE_FLAGS))
-		print_err("table flags mismatches");
-	if (nftnl_table_get_u32(a, NFTNL_TABLE_FAMILY) !=
-	    nftnl_table_get_u32(b, NFTNL_TABLE_FAMILY))
-		print_err("tabke family mismatches");
+	bool test_ok = true;
+	bool ret;
+
+	ret = !strcmp(nftnl_table_get_str(a, NFTNL_TABLE_NAME),
+		      nftnl_table_get_str(b, NFTNL_TABLE_NAME));
+	test_ok &= test_assert(ret, "table name mismatches");
+
+	ret = nftnl_table_get_u32(a, NFTNL_TABLE_FLAGS) ==
+	      nftnl_table_get_u32(b, NFTNL_TABLE_FLAGS);
+	test_ok &= test_assert(ret, "table flags mismatches");
+
+	ret = nftnl_table_get_u32(a, NFTNL_TABLE_FAMILY) ==
+	      nftnl_table_get_u32(b, NFTNL_TABLE_FAMILY);
+	test_ok &= test_assert(ret, "table family mismatches");
+
+	return test_ok;
 }
 
 int main(int argc, char *argv[])
@@ -38,6 +45,9 @@ int main(int argc, char *argv[])
 
 	struct nftnl_table *a = NULL;
 	struct nftnl_table *b = NULL;
+	bool test_ok = true;
+	bool ret;
+
 	a = nftnl_table_alloc();
 	b = nftnl_table_alloc();
 
@@ -53,13 +63,13 @@ int main(int argc, char *argv[])
 					1234);
 	nftnl_table_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_table_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_table_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
-	cmp_nftnl_table(a,b);
+	test_ok &= cmp_nftnl_table(a,b);
 
 	nftnl_table_free(a);
 	nftnl_table_free(b);
 
-	return test_report(argv[0]);
+	return test_report(test_ok, argv[0]);
 }
-- 
2.8.3

