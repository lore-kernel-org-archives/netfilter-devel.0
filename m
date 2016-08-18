From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 3/3 v4 libnftnl] tests: Elimine static variable 'test_ok'
Date: Thu, 18 Aug 2016 07:45:51 +0200
Message-ID: <20160818054551.5136-3-carlosfg@riseup.net>
References: <20160818054551.5136-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:38806 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbcHRFqS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Aug 2016 01:46:18 -0400
In-Reply-To: <20160818054551.5136-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* Modifies 'test_report' to receive a boolean that replaces 'test_ok'.
* Renames 'print_err' to 'test_assert' and adds a similar parameter.
* 'test_assert_{expr|rule}()' returns a boolean.
* Adapts all test to the new functions.

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 tests/libtest.c                 | 30 ++++++-------
 tests/libtest.h                 |  8 ++--
 tests/nft-chain-test.c          | 93 ++++++++++++++++++++++++-----------------
 tests/nft-expr_bitwise-test.c   | 15 +++----
 tests/nft-expr_byteorder-test.c | 15 +++----
 tests/nft-expr_cmp-test.c       | 15 +++----
 tests/nft-expr_counter-test.c   | 15 +++----
 tests/nft-expr_ct-test.c        | 15 +++----
 tests/nft-expr_dup-test.c       | 15 +++----
 tests/nft-expr_exthdr-test.c    | 15 +++----
 tests/nft-expr_fwd-test.c       | 15 +++----
 tests/nft-expr_hash-test.c      | 15 +++----
 tests/nft-expr_immediate-test.c | 17 ++++----
 tests/nft-expr_limit-test.c     | 15 +++----
 tests/nft-expr_log-test.c       | 15 +++----
 tests/nft-expr_lookup-test.c    | 15 +++----
 tests/nft-expr_masq-test.c      | 15 +++----
 tests/nft-expr_match-test.c     | 15 +++----
 tests/nft-expr_meta-test.c      | 15 +++----
 tests/nft-expr_nat-test.c       | 15 +++----
 tests/nft-expr_payload-test.c   | 15 +++----
 tests/nft-expr_queue-test.c     | 15 +++----
 tests/nft-expr_redir-test.c     | 15 +++----
 tests/nft-expr_reject-test.c    | 15 +++----
 tests/nft-expr_target-test.c    | 15 +++----
 tests/nft-rule-test.c           | 14 ++++---
 tests/nft-set-test.c            | 72 ++++++++++++++++++-------------
 tests/nft-table-test.c          | 38 ++++++++++-------
 28 files changed, 325 insertions(+), 262 deletions(-)

diff --git a/tests/libtest.c b/tests/libtest.c
index 6c1a123..d30a089 100644
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
@@ -68,16 +68,16 @@ static const char *expr2str(const struct nftnl_expr *e)
 	return buff;
 }
 
-void test_assert_expr(const struct nftnl_expr *e1, const struct nftnl_expr *e2)
+bool test_assert_expr(const struct nftnl_expr *e1, const struct nftnl_expr *e2)
 {
-	if (!nftnl_expr_cmp(e1, e2))
-		print_err("expressions mismatch:\n\texpr 1: %s\n\texpr 2: %s",
-			  expr2str(e1), expr2str(e2));
+	return test_assert(nftnl_expr_cmp(e1, e2),
+			   "expressions mismatch:\n\texpr 1: %s\n\texpr 2: %s",
+			   expr2str(e1), expr2str(e2));
 }
 
-void test_assert_rule(const struct nftnl_rule *r1, const struct nftnl_rule *r2)
+bool test_assert_rule(const struct nftnl_rule *r1, const struct nftnl_rule *r2)
 {
-	if (!nftnl_rule_cmp(r1, r2))
-		print_err("rules mismatch:\nRULE 1:\n%s\nRULE 2:\n%s",
-			  rule2str(r1), rule2str(r2));
+	return test_assert(nftnl_rule_cmp(r1, r2),
+			   "rules mismatch:\nRULE 1:\n%s\nRULE 2:\n%s",
+			   rule2str(r1), rule2str(r2));
 }
diff --git a/tests/libtest.h b/tests/libtest.h
index dd1d5cb..969fcdc 100644
--- a/tests/libtest.h
+++ b/tests/libtest.h
@@ -9,9 +9,9 @@
 
 #define oom_assert(cond, prog) __oom_assert(cond, prog, __FILE__, __LINE__)
 void __oom_assert(bool cond, const char *prog, const char *file, int line);
-void print_err(const char *fmt, ...);
-int test_report(const char *prog);
-void test_assert_expr(const struct nftnl_expr *e1, const struct nftnl_expr *e2);
-void test_assert_rule(const struct nftnl_rule *r1, const struct nftnl_rule *r2);
+bool test_assert(bool cond, const char *fmt, ...);
+int test_report(bool test_ok, const char *prog);
+bool test_assert_expr(const struct nftnl_expr *e1, const struct nftnl_expr *e2);
+bool test_assert_rule(const struct nftnl_rule *r1, const struct nftnl_rule *r2);
 
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
index 1eff343..8f6781f 100644
--- a/tests/nft-expr_bitwise-test.c
+++ b/tests/nft-expr_bitwise-test.c
@@ -31,6 +31,8 @@ int main(int argc, char *argv[])
 	struct nftnl_expr *rule_a, *rule_b = NULL;
 	uint32_t mask = 0x01010101;
 	uint32_t xor = 0x12345678;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -50,8 +52,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -63,17 +65,16 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	if (nftnl_expr_iter_next(iter_a) != NULL ||
-	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("More 1 expr.");
+	ret = !nftnl_expr_iter_next(iter_a) && !nftnl_expr_iter_next(iter_b);
+	test_ok &= test_assert(ret, "More 1 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
 
-	test_assert_expr(rule_a, rule_b);
+	test_ok &= test_assert_expr(rule_a, rule_b);
 
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	return test_report(argv[0]);
+	return test_report(test_ok, argv[0]);
 }
diff --git a/tests/nft-expr_byteorder-test.c b/tests/nft-expr_byteorder-test.c
index 1f77ea7..29df7a6 100644
--- a/tests/nft-expr_byteorder-test.c
+++ b/tests/nft-expr_byteorder-test.c
@@ -29,6 +29,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -48,8 +50,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -61,16 +63,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	test_assert_expr(rule_a, rule_b);
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
index 90c78b0..e8cd90b 100644
--- a/tests/nft-expr_cmp-test.c
+++ b/tests/nft-expr_cmp-test.c
@@ -30,6 +30,8 @@ int main(int argc, char *argv[])
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
 	uint32_t data_len = 0x01010101;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -47,8 +49,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -59,16 +61,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	test_assert_expr(rule_a, rule_b);
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
index d784a11..a6cb95d 100644
--- a/tests/nft-expr_counter-test.c
+++ b/tests/nft-expr_counter-test.c
@@ -30,6 +30,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -46,8 +48,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -58,16 +60,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	test_assert_expr(rule_a, rule_b);
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
index 936803e..55f6d52 100644
--- a/tests/nft-expr_ct-test.c
+++ b/tests/nft-expr_ct-test.c
@@ -29,6 +29,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -46,8 +48,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -59,16 +61,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	test_assert_expr(rule_a, rule_b);
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
index 9c24764..4c90b41 100644
--- a/tests/nft-expr_dup-test.c
+++ b/tests/nft-expr_dup-test.c
@@ -29,6 +29,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -45,8 +47,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -58,16 +60,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	test_assert_expr(rule_a, rule_b);
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
index 82c442e..26642c3 100644
--- a/tests/nft-expr_exthdr-test.c
+++ b/tests/nft-expr_exthdr-test.c
@@ -29,6 +29,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -46,8 +48,8 @@ int main(int argc, char *argv[])
 
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -59,16 +61,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	test_assert_expr(rule_a, rule_b);
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
index 3f04a3f..385ca8e 100644
--- a/tests/nft-expr_fwd-test.c
+++ b/tests/nft-expr_fwd-test.c
@@ -29,6 +29,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -44,8 +46,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -57,16 +59,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	test_assert_expr(rule_a, rule_b);
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
diff --git a/tests/nft-expr_hash-test.c b/tests/nft-expr_hash-test.c
index 4472df8..8293b9a 100644
--- a/tests/nft-expr_hash-test.c
+++ b/tests/nft-expr_hash-test.c
@@ -29,6 +29,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -46,8 +48,8 @@ int main(int argc, char *argv[])
 
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -59,16 +61,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_a, argv[0]);
 
-	test_assert_expr(rule_a, rule_b);
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
index 763eb0f..8987677 100644
--- a/tests/nft-expr_immediate-test.c
+++ b/tests/nft-expr_immediate-test.c
@@ -31,6 +31,8 @@ int main(int argc, char *argv[])
 	struct nftnl_expr *rule_a, *rule_b;
 	char *chain = "tests_chain01234";
 	char *data = "test_data_01234";
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -54,8 +56,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -67,23 +69,22 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	test_assert_expr(rule_a, rule_b);
+	test_ok &= test_assert_expr(rule_a, rule_b);
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	test_assert_expr(rule_a, rule_b);
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
index bcdd357..a5cb137 100644
--- a/tests/nft-expr_limit-test.c
+++ b/tests/nft-expr_limit-test.c
@@ -30,6 +30,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -49,8 +51,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -62,16 +64,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	test_assert_expr(rule_a, rule_b);
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
index aad71b5..7dbbf34 100644
--- a/tests/nft-expr_log-test.c
+++ b/tests/nft-expr_log-test.c
@@ -29,6 +29,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -46,8 +48,8 @@ int main(int argc, char *argv[])
 
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -58,16 +60,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	test_assert_expr(rule_a, rule_b);
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
index dcbbcdb..537adfd 100644
--- a/tests/nft-expr_lookup-test.c
+++ b/tests/nft-expr_lookup-test.c
@@ -31,6 +31,8 @@ int main(int argc, char *argv[])
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
 	char *lookup_set = "test_set_01243";
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -49,8 +51,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -61,16 +63,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	test_assert_expr(rule_a, rule_b);
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
index 8b7cfc7..b93fc27 100644
--- a/tests/nft-expr_masq-test.c
+++ b/tests/nft-expr_masq-test.c
@@ -27,6 +27,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -44,8 +46,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -57,16 +59,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	test_assert_expr(rule_a, rule_b);
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
index b410bc9..78868bf 100644
--- a/tests/nft-expr_match-test.c
+++ b/tests/nft-expr_match-test.c
@@ -31,6 +31,8 @@ int main(int argc, char *argv[])
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
 	char data[16] = "0123456789abcdef";
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -47,8 +49,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
 	oom_assert(iter_a, argv[0]);
@@ -59,16 +61,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	test_assert_expr(rule_a, rule_b);
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
index 9a812b7..44fa022 100644
--- a/tests/nft-expr_meta-test.c
+++ b/tests/nft-expr_meta-test.c
@@ -29,6 +29,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -44,8 +46,8 @@ int main(int argc, char *argv[])
 
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -57,16 +59,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	test_assert_expr(rule_a, rule_b);
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
index eb8e2a5..ea26e7c 100644
--- a/tests/nft-expr_nat-test.c
+++ b/tests/nft-expr_nat-test.c
@@ -30,6 +30,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -51,8 +53,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -64,16 +66,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	test_assert_expr(rule_a, rule_b);
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
index 78f11ba..dc52916 100644
--- a/tests/nft-expr_payload-test.c
+++ b/tests/nft-expr_payload-test.c
@@ -30,6 +30,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -47,8 +49,8 @@ int main(int argc, char *argv[])
 
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -60,16 +62,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	test_assert_expr(rule_a, rule_b);
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
index 1106766..d266882 100644
--- a/tests/nft-expr_queue-test.c
+++ b/tests/nft-expr_queue-test.c
@@ -32,6 +32,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -49,8 +51,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -62,16 +64,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	test_assert_expr(rule_a, rule_b);
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
index 978f09f..ed3ff65 100644
--- a/tests/nft-expr_redir-test.c
+++ b/tests/nft-expr_redir-test.c
@@ -27,6 +27,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -44,8 +46,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("Parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "Parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -57,16 +59,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	test_assert_expr(rule_a, rule_b);
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
index 0e42ae1..8edc240 100644
--- a/tests/nft-expr_reject-test.c
+++ b/tests/nft-expr_reject-test.c
@@ -30,6 +30,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -46,8 +48,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -59,16 +61,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	test_assert_expr(rule_a, rule_b);
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
index 1c750b6..00a3c0d 100644
--- a/tests/nft-expr_target-test.c
+++ b/tests/nft-expr_target-test.c
@@ -30,6 +30,8 @@ int main(int argc, char *argv[])
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
 	char data[16] = "0123456789abcdef";
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -47,8 +49,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
@@ -60,16 +62,15 @@ int main(int argc, char *argv[])
 	oom_assert(rule_a, argv[0]);
 	oom_assert(rule_b, argv[0]);
 
-	test_assert_expr(rule_a, rule_b);
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
index a02abbc..2479cc3 100644
--- a/tests/nft-rule-test.c
+++ b/tests/nft-rule-test.c
@@ -25,6 +25,8 @@ int main(int argc, char *argv[])
 	struct nftnl_rule *a, *b;
 	char buf[4096];
 	struct nlmsghdr *nlh;
+	bool test_ok = true;
+	bool ret;
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -34,8 +36,8 @@ int main(int argc, char *argv[])
 	udata = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
 	oom_assert(udata, argv[0]);
 
-	if (!nftnl_udata_put_strz(udata, 0, "hello world"))
-		print_err("User data too big");
+	ret = nftnl_udata_put_strz(udata, 0, "hello world");
+	test_ok &= test_assert(ret, "User data too big");
 
 	nftnl_rule_set_u32(a, NFTNL_RULE_FAMILY, AF_INET);
 	nftnl_rule_set_str(a, NFTNL_RULE_TABLE, "table");
@@ -52,13 +54,13 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
-	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
-		print_err("parsing problems");
+	ret = nftnl_rule_nlmsg_parse(nlh, b) >= 0;
+	test_ok &= test_assert(ret, "parsing problems");
 
-	test_assert_rule(a, b);
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

