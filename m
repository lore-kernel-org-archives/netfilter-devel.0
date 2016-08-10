From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 3/3, libnftnl] tests: Fix tests for immediate and lookup expressions
Date: Wed, 10 Aug 2016 17:12:05 +0200
Message-ID: <20160810151205.24975-3-carlosfg@riseup.net>
References: <20160810151205.24975-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:51716 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933778AbcHJUcS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 16:32:18 -0400
In-Reply-To: <20160810151205.24975-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

An error at Makefile.am has caused that the tests
'nft-expr_immediate-test.c' and 'nft-expr_lookup-tests.c' have not been
compiled since they were created. This patch fix that error and some errors
in both tests.

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 tests/Makefile.am               |  4 +--
 tests/nft-expr_immediate-test.c | 72 ++++++++++++++++++++++++++++-------------
 tests/nft-expr_lookup-test.c    | 26 +++++++++------
 3 files changed, 67 insertions(+), 35 deletions(-)

diff --git a/tests/Makefile.am b/tests/Makefile.am
index c246034..0377081 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -70,13 +70,13 @@ nft_expr_dup_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 nft_expr_fwd_test_SOURCES = nft-expr_fwd-test.c
 nft_expr_fwd_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
-nft_expr_immediate_test_SOURCES = nft-expr_counter-test.c
+nft_expr_immediate_test_SOURCES = nft-expr_immediate-test.c
 nft_expr_immediate_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
 nft_expr_limit_test_SOURCES = nft-expr_limit-test.c
 nft_expr_limit_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
-nft_expr_lookup_test_SOURCES = nft-expr_limit-test.c
+nft_expr_lookup_test_SOURCES = nft-expr_lookup-test.c
 nft_expr_lookup_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
 nft_expr_log_test_SOURCES = nft-expr_log-test.c
diff --git a/tests/nft-expr_immediate-test.c b/tests/nft-expr_immediate-test.c
index 695e0b0..e07092f 100644
--- a/tests/nft-expr_immediate-test.c
+++ b/tests/nft-expr_immediate-test.c
@@ -27,52 +27,71 @@ static void print_err(const char *msg)
 	printf("\033[31mERROR:\e[0m %s\n", msg);
 }
 
-static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
-			      struct nftnl_expr *rule_b)
+static void cmp_nftnl_expr_verdict(struct nftnl_expr *rule_a,
+				   struct nftnl_expr *rule_b)
 {
-	uint32_t data_a, data_b, chain_a, chain_b;
+	uint32_t len_a, len_b;
+	const char *chain_a, *chain_b;
 
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_IMM_DREG) !=
 	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_IMM_DREG))
 		print_err("Expr NFTNL_EXPR_IMM_DREG mismatches");
-	nftnl_expr_get(rule_a, NFTNL_EXPR_IMM_DATA, data_a);
-	nftnl_expr_get(rule_b, NFTNL_EXPR_IMM_DATA, data_b)
+
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_IMM_VERDICT) !=
 	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_IMM_VERDICT))
 		print_err("Expr NFTNL_EXPR_IMM_VERDICT mismatches");
-	nftnl_expr_get(rule_a, NFTNL_EXPR_IMM_CHAIN, chain_a);
-	nftnl_expr_get(rule_b, NFTNL_EXPR_IMM_CHAIN, chain_b);
-	if (data_a != data_b)
-		print_err("Expr NFTNL_EXPR_IMM_DATA. Size mismatches");
-	if (chain_a != chain_b)
-		print_err("Expr NFTNL_EXPR_IMM_CHAIN. Size mismatches");
+
+	chain_a = nftnl_expr_get(rule_a, NFTNL_EXPR_IMM_CHAIN, &len_a);
+	chain_b = nftnl_expr_get(rule_b, NFTNL_EXPR_IMM_CHAIN, &len_b);
+	if (len_a != len_b || strncmp(chain_a, chain_b, len_a))
+		print_err("Expr NFTNL_EXPR_IMM_CHAIN mismatches");
+}
+
+static void cmp_nftnl_expr_value(struct nftnl_expr *rule_a,
+				 struct nftnl_expr *rule_b)
+{
+	const uint32_t *data_a, *data_b;
+	uint32_t len_a, len_b;
+
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_IMM_DREG) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_IMM_DREG))
+		print_err("Expr NFTNL_EXPR_IMM_DREG mismatches");
+
+	data_a = nftnl_expr_get(rule_a, NFTNL_EXPR_IMM_DATA, &len_a);
+	data_b = nftnl_expr_get(rule_b, NFTNL_EXPR_IMM_DATA, &len_b);
+	if (len_a != len_b || memcmp(data_a, data_b, len_a))
+		print_err("Expr NFTNL_EXPR_IMM_DATA mismatches");
 }
 
 int main(int argc, char *argv[])
 {
 	struct nftnl_rule *a, *b;
-	struct nftnl_expr *ex;
+	struct nftnl_expr *ex_val, *ex_ver;
 	struct nlmsghdr *nlh;
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
-	uint32_t chain = 0x12345678;
-	uint32_t data = 0x56781234;
+	char chain[] = "tests_chain01234";
+	char data[] = "test_data_01234";
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
 	if (a == NULL || b == NULL)
 		print_err("OOM");
-	ex = nftnl_expr_alloc("immediate");
-	if (ex == NULL)
+	ex_val = nftnl_expr_alloc("immediate");
+	ex_ver = nftnl_expr_alloc("immediate");
+	if (!ex_val || !ex_ver)
 		print_err("OOM");
 
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_IMM_DREG, 0x1234568);
-	nftnl_expr_set(ex, NFTNL_EXPR_IMM_DATA, &data, sizeof(data));
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_IMM_VERDICT, 0x78123456);
-	nftnl_expr_set(ex, NFTNL_EXPR_IMM_CHAIN, &chain, sizeof(chain));
+	nftnl_expr_set_u32(ex_val, NFTNL_EXPR_IMM_DREG, 0x1234568);
+	nftnl_expr_set(ex_val,     NFTNL_EXPR_IMM_DATA, data, sizeof(data));
+
+	nftnl_expr_set_u32(ex_ver, NFTNL_EXPR_IMM_DREG,    0x1234568);
+	nftnl_expr_set_u32(ex_ver, NFTNL_EXPR_IMM_VERDICT, NFT_GOTO);
+	nftnl_expr_set(ex_ver,     NFTNL_EXPR_IMM_CHAIN, chain, sizeof(chain));
 
-	nftnl_rule_add_expr(a, ex);
+	nftnl_rule_add_expr(a, ex_val);
+	nftnl_rule_add_expr(a, ex_ver);
 
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
@@ -90,11 +109,18 @@ int main(int argc, char *argv[])
 	if (rule_a == NULL || rule_b == NULL)
 		print_err("OOM");
 
-	cmp_nftnl_expr(rule_a, rule_b);
+	cmp_nftnl_expr_value(rule_a, rule_b);
+
+	rule_a = nftnl_expr_iter_next(iter_a);
+	rule_b = nftnl_expr_iter_next(iter_b);
+	if (rule_a == NULL || rule_b == NULL)
+		print_err("OOM");
+
+	cmp_nftnl_expr_verdict(rule_a, rule_b);
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
-		print_err("More 1 expr.");
+		print_err("More 2 expr.");
 
 	nftnl_expr_iter_destroy(iter_a);
 	nftnl_expr_iter_destroy(iter_b);
diff --git a/tests/nft-expr_lookup-test.c b/tests/nft-expr_lookup-test.c
index e52345f..d1f017b 100644
--- a/tests/nft-expr_lookup-test.c
+++ b/tests/nft-expr_lookup-test.c
@@ -31,17 +31,24 @@ static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 			      struct nftnl_expr *rule_b)
 {
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_LOOKUP_SREG) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_LOOPUP_SREG))
-		print_err("Expr NFTNL_EXPR_LOOkUP_SREG mismatches");
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_LOOKUP_SREG))
+		print_err("Expr NFTNL_EXPR_LOOKUP_SREG mismatches");
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_LOOKUP_DREG) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_LOOPUP_DREG))
-		print_err("Expr NFTNL_EXPR_LOOkUP_DREG mismatches");
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_LOOKUP_DREG))
+		print_err("Expr NFTNL_EXPR_LOOKUP_DREG mismatches");
 	if (strcmp(nftnl_expr_get_str(rule_a, NFTNL_EXPR_LOOKUP_SET),
 		   nftnl_expr_get_str(rule_b, NFTNL_EXPR_LOOKUP_SET)))
 		print_err("Expr NFTNL_EXPR_LOOKUP_SET mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_LOOKUP_SET_ID) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_LOOKUP_SET_ID))
+		print_err("Expr NFTNL_EXPR_LOOKUP_SET_ID mismatches");
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_LOOKUP_FLAGS) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_LOOPUP_FLAGS))
-		print_err("Expr NFTNL_EXPR_LOOkUP_FLAGS mismatches");
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_LOOKUP_FLAGS)) {
+		print_err("Expr NFTNL_EXPR_LOOKUP_FLAGS mismatches");
+		printf("%X %X\n",
+			nftnl_expr_get_u32(rule_a, NFTNL_EXPR_LOOKUP_FLAGS),
+			nftnl_expr_get_u32(rule_b, NFTNL_EXPR_LOOKUP_FLAGS));
+	}
 }
 
 int main(int argc, char *argv[])
@@ -52,7 +59,7 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
-	uint32_t lookup_set = 0x12345678;
+	char lookup_set[] = "test_set_01243";
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
@@ -64,8 +71,7 @@ int main(int argc, char *argv[])
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_LOOKUP_SREG, 0x12345678);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_LOOKUP_DREG, 0x78123456);
-	nftnl_expr_set(ex, NFTNL_EXPR_LOOKUP_SET, &lookup_set,
-			  sizeof(lookup_set));
+	nftnl_expr_set_str(ex, NFTNL_EXPR_LOOKUP_SET,  lookup_set);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_LOOKUP_FLAGS, 0x12345678);
 
 	nftnl_rule_add_expr(a, ex);
@@ -99,7 +105,7 @@ int main(int argc, char *argv[])
 	if (!test_ok)
 		exit(EXIT_FAILURE);
 
-	print(_"%s: \033[32mOK\e[0m\n", argv[0]);
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
 
 	return EXIT_SUCCESS;
 }
-- 
2.8.3

