From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 3/4, V2, libnftnl] tests: Consolidate printing error utilities
Date: Fri, 12 Aug 2016 22:17:21 +0200
Message-ID: <20160812201722.10134-3-carlosfg@riseup.net>
References: <20160811233222.GB5108@salvia>
 <20160812201722.10134-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:50321 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbcHLUR6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 16:17:58 -0400
In-Reply-To: <20160812201722.10134-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds libtest.c and libtest.h to reduce test code and
consolidate it.

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 .gitignore                      |  1 +
 tests/Makefile.am               | 52 +++++++++++++++++++++-------------------
 tests/libtest.c                 | 53 +++++++++++++++++++++++++++++++++++++++++
 tests/libtest.h                 | 11 +++++++++
 tests/nft-chain-test.c          | 18 ++++----------
 tests/nft-expr_bitwise-test.c   | 29 +++++++---------------
 tests/nft-expr_byteorder-test.c | 29 +++++++---------------
 tests/nft-expr_cmp-test.c       | 29 +++++++---------------
 tests/nft-expr_counter-test.c   | 27 +++++++--------------
 tests/nft-expr_ct-test.c        | 28 +++++++---------------
 tests/nft-expr_dup-test.c       | 28 +++++++---------------
 tests/nft-expr_exthdr-test.c    | 28 +++++++---------------
 tests/nft-expr_fwd-test.c       | 28 +++++++---------------
 tests/nft-expr_immediate-test.c | 34 ++++++++++----------------
 tests/nft-expr_limit-test.c     | 29 +++++++---------------
 tests/nft-expr_log-test.c       | 29 +++++++---------------
 tests/nft-expr_lookup-test.c    | 30 +++++++----------------
 tests/nft-expr_masq-test.c      | 29 +++++++---------------
 tests/nft-expr_match-test.c     | 38 +++++++++--------------------
 tests/nft-expr_meta-test.c      | 29 +++++++---------------
 tests/nft-expr_nat-test.c       | 29 +++++++---------------
 tests/nft-expr_payload-test.c   | 29 +++++++---------------
 tests/nft-expr_queue-test.c     | 29 +++++++---------------
 tests/nft-expr_redir-test.c     | 29 +++++++---------------
 tests/nft-expr_reject-test.c    | 29 +++++++---------------
 tests/nft-expr_target-test.c    | 37 +++++++++-------------------
 tests/nft-rule-test.c           | 20 ++++------------
 tests/nft-set-test.c            | 18 ++++----------
 tests/nft-table-test.c          | 17 ++++---------
 29 files changed, 305 insertions(+), 511 deletions(-)
 create mode 100644 tests/libtest.c
 create mode 100644 tests/libtest.h

diff --git a/.gitignore b/.gitignore
index 1650e58..5a781db 100644
--- a/.gitignore
+++ b/.gitignore
@@ -28,4 +28,5 @@ examples/*
 !examples/Makefile.am
 tests/*
 !tests/*.c
+!tests/*.h
 !tests/Makefile.am
diff --git a/tests/Makefile.am b/tests/Makefile.am
index 0377081..b55aeba 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -4,6 +4,8 @@ EXTRA_DIST =		test-script.sh			\
 			jsonfiles			\
 			xmlfiles
 
+LIBTEST =		libtest.c
+
 check_PROGRAMS = 	nft-parsing-test		\
 			nft-table-test			\
 			nft-chain-test			\
@@ -34,77 +36,77 @@ check_PROGRAMS = 	nft-parsing-test		\
 nft_parsing_test_SOURCES = nft-parsing-test.c
 nft_parsing_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS} ${LIBXML_LIBS} ${LIBJSON_LIBS}
 
-nft_table_test_SOURCES = nft-table-test.c
+nft_table_test_SOURCES = nft-table-test.c ${LIBTEST}
 nft_table_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
-nft_chain_test_SOURCES = nft-chain-test.c
+nft_chain_test_SOURCES = nft-chain-test.c ${LIBTEST}
 nft_chain_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
-nft_rule_test_SOURCES = nft-rule-test.c
+nft_rule_test_SOURCES = nft-rule-test.c ${LIBTEST}
 nft_rule_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
-nft_set_test_SOURCES = nft-set-test.c
+nft_set_test_SOURCES = nft-set-test.c ${LIBTEST}
 nft_set_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
-nft_expr_bitwise_test_SOURCES = nft-expr_bitwise-test.c
+nft_expr_bitwise_test_SOURCES = nft-expr_bitwise-test.c ${LIBTEST}
 nft_expr_bitwise_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
-nft_expr_byteorder_test_SOURCES = nft-expr_byteorder-test.c
+nft_expr_byteorder_test_SOURCES = nft-expr_byteorder-test.c ${LIBTEST}
 nft_expr_byteorder_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
-nft_expr_cmp_test_SOURCES = nft-expr_cmp-test.c
+nft_expr_cmp_test_SOURCES = nft-expr_cmp-test.c ${LIBTEST}
 nft_expr_cmp_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
-nft_expr_counter_test_SOURCES = nft-expr_counter-test.c
+nft_expr_counter_test_SOURCES = nft-expr_counter-test.c ${LIBTEST}
 nft_expr_counter_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
-nft_expr_exthdr_test_SOURCES = nft-expr_exthdr-test.c
+nft_expr_exthdr_test_SOURCES = nft-expr_exthdr-test.c ${LIBTEST}
 nft_expr_exthdr_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
-nft_expr_ct_test_SOURCES = nft-expr_ct-test.c
+nft_expr_ct_test_SOURCES = nft-expr_ct-test.c ${LIBTEST}
 nft_expr_ct_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
-nft_expr_dup_test_SOURCES = nft-expr_dup-test.c
+nft_expr_dup_test_SOURCES = nft-expr_dup-test.c ${LIBTEST}
 nft_expr_dup_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
-nft_expr_fwd_test_SOURCES = nft-expr_fwd-test.c
+nft_expr_fwd_test_SOURCES = nft-expr_fwd-test.c ${LIBTEST}
 nft_expr_fwd_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
-nft_expr_immediate_test_SOURCES = nft-expr_immediate-test.c
+nft_expr_immediate_test_SOURCES = nft-expr_immediate-test.c ${LIBTEST}
 nft_expr_immediate_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
-nft_expr_limit_test_SOURCES = nft-expr_limit-test.c
+nft_expr_limit_test_SOURCES = nft-expr_limit-test.c ${LIBTEST}
 nft_expr_limit_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
-nft_expr_lookup_test_SOURCES = nft-expr_lookup-test.c
+nft_expr_lookup_test_SOURCES = nft-expr_lookup-test.c ${LIBTEST}
 nft_expr_lookup_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
-nft_expr_log_test_SOURCES = nft-expr_log-test.c
+nft_expr_log_test_SOURCES = nft-expr_log-test.c ${LIBTEST}
 nft_expr_log_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
-nft_expr_match_test_SOURCES = nft-expr_match-test.c
+nft_expr_match_test_SOURCES = nft-expr_match-test.c ${LIBTEST}
 nft_expr_match_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
-nft_expr_masq_test_SOURCES = nft-expr_masq-test.c
+nft_expr_masq_test_SOURCES = nft-expr_masq-test.c ${LIBTEST}
 nft_expr_masq_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
-nft_expr_meta_test_SOURCES = nft-expr_meta-test.c
+nft_expr_meta_test_SOURCES = nft-expr_meta-test.c ${LIBTEST}
 nft_expr_meta_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
-nft_expr_nat_test_SOURCES = nft-expr_nat-test.c
+nft_expr_nat_test_SOURCES = nft-expr_nat-test.c ${LIBTEST}
 nft_expr_nat_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
-nft_expr_payload_test_SOURCES = nft-expr_payload-test.c
+nft_expr_payload_test_SOURCES = nft-expr_payload-test.c ${LIBTEST}
 nft_expr_payload_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
-nft_expr_queue_test_SOURCES = nft-expr_queue-test.c
+nft_expr_queue_test_SOURCES = nft-expr_queue-test.c ${LIBTEST}
 nft_expr_queue_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
-nft_expr_reject_test_SOURCES = nft-expr_reject-test.c
+nft_expr_reject_test_SOURCES = nft-expr_reject-test.c ${LIBTEST}
 nft_expr_reject_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
-nft_expr_redir_test_SOURCES = nft-expr_redir-test.c
+nft_expr_redir_test_SOURCES = nft-expr_redir-test.c ${LIBTEST}
 nft_expr_redir_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
-nft_expr_target_test_SOURCES = nft-expr_target-test.c
+nft_expr_target_test_SOURCES = nft-expr_target-test.c ${LIBTEST}
 nft_expr_target_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
diff --git a/tests/libtest.c b/tests/libtest.c
new file mode 100644
index 0000000..ed7eafa
--- /dev/null
+++ b/tests/libtest.c
@@ -0,0 +1,53 @@
+#include <libtest.h>
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdarg.h>
+#include <string.h>
+#include <errno.h>
+#include <stdbool.h>
+
+#define COLOR_RED     "\x1b[31m"
+#define COLOR_GREEN   "\x1b[32m"
+#define COLOR_RESET   "\x1b[0m"
+
+static bool test_ok = true;
+
+void __oom_assert(bool cond, const char *prog, const char *file, int line)
+{
+	if (cond)
+		return;
+
+	fprintf(stderr,
+		COLOR_RED "OOM" COLOR_RESET " at %s:%d\n\t%s\n", file, line,
+		strerror(errno));
+
+	test_ok = false;
+	test_report(prog);
+	exit(EXIT_FAILURE);
+}
+
+void print_err(const char *fmt, ...)
+{
+	va_list args;
+
+	fprintf(stderr, COLOR_RED "ERROR: " COLOR_RESET);
+	va_start(args, fmt);
+	vfprintf(stderr, fmt, args);
+	va_end(args);
+	fprintf(stderr, "\n");
+
+	test_ok = false;
+}
+
+int test_report(const char *prog)
+{
+	switch (test_ok) {
+	case true:
+		printf("%s: " COLOR_GREEN "OK\n" COLOR_RESET, prog);
+		return EXIT_SUCCESS;
+	case false:
+		printf("%s: " COLOR_RED "FAIL\n" COLOR_RESET, prog);
+		return EXIT_FAILURE;
+	}
+}
diff --git a/tests/libtest.h b/tests/libtest.h
new file mode 100644
index 0000000..f570057
--- /dev/null
+++ b/tests/libtest.h
@@ -0,0 +1,11 @@
+#ifndef _TESTS_UTILS_H
+#define _TESTS_UTILS_H
+
+#include <stdbool.h>
+
+#define oom_assert(cond, prog) __oom_assert(cond, prog, __FILE__, __LINE__)
+void __oom_assert(bool cond, const char *prog, const char *file, int line);
+void print_err(const char *fmt, ...);
+int test_report(const char *prog);
+
+#endif
diff --git a/tests/nft-chain-test.c b/tests/nft-chain-test.c
index d678d46..b42fb86 100644
--- a/tests/nft-chain-test.c
+++ b/tests/nft-chain-test.c
@@ -15,13 +15,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <libnftnl/chain.h>
 
-static int test_ok = 1;
-
-static void print_err(const char *msg)
-{
-	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s\n", msg);
-}
+#include "libtest.h"
 
 static void cmp_nftnl_chain(struct nftnl_chain *a, struct nftnl_chain *b)
 {
@@ -72,8 +66,8 @@ int main(int argc, char *argv[])
 
 	a = nftnl_chain_alloc();
 	b = nftnl_chain_alloc();
-	if (a == NULL || b == NULL)
-		print_err("OOM");
+	oom_assert(a, argv[0]);
+	oom_assert(b, argv[0]);
 
 	nftnl_chain_set_str(a, NFTNL_CHAIN_NAME, "test");
 	nftnl_chain_set_u32(a, NFTNL_CHAIN_FAMILY, AF_INET);
@@ -101,10 +95,6 @@ int main(int argc, char *argv[])
 	nftnl_chain_free(a);
 	nftnl_chain_free(b);
 
-	if (!test_ok)
-		exit(EXIT_FAILURE);
-
-	printf("%s: \033[32mOK\e[0m\n", argv[0]);
-	return EXIT_SUCCESS;
+	return test_report(argv[0]);
 
 }
diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-test.c
index 64c1446..42e9bb2 100644
--- a/tests/nft-expr_bitwise-test.c
+++ b/tests/nft-expr_bitwise-test.c
@@ -19,13 +19,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 
-static int test_ok = 1;
-
-static void print_err(const char *msg)
-{
-	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s\n", msg);
-}
+#include "libtest.h"
 
 static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 			      struct nftnl_expr *rule_b)
@@ -65,11 +59,10 @@ int main(int argc, char *argv[])
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
-	if (a == NULL || b == NULL)
-		print_err("OOM");
+	oom_assert(a, argv[0]);
+	oom_assert(b, argv[0]);
 	ex = nftnl_expr_alloc("bitwise");
-	if (ex == NULL)
-		print_err("OOM");
+	oom_assert(ex, argv[0]);
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_SREG, 0x12345678);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BITWISE_DREG, 0x78123456);
@@ -87,13 +80,13 @@ int main(int argc, char *argv[])
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
-	if (iter_a == NULL || iter_b == NULL)
-		print_err("OOM");
+	oom_assert(iter_a, argv[0]);
+	oom_assert(iter_b, argv[0]);
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
-	if (rule_a == NULL || rule_b == NULL)
-		print_err("OOM");
+	oom_assert(rule_a, argv[0]);
+	oom_assert(rule_b, argv[0]);
 
 	if (nftnl_expr_iter_next(iter_a) != NULL ||
 	    nftnl_expr_iter_next(iter_b) != NULL)
@@ -107,9 +100,5 @@ int main(int argc, char *argv[])
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	if (!test_ok)
-		exit(EXIT_FAILURE);
-
-	printf("%s: \033[32mOK\e[0m\n", argv[0]);
-	return EXIT_SUCCESS;
+	return test_report(argv[0]);
 }
diff --git a/tests/nft-expr_byteorder-test.c b/tests/nft-expr_byteorder-test.c
index 5994e5b..9a25667 100644
--- a/tests/nft-expr_byteorder-test.c
+++ b/tests/nft-expr_byteorder-test.c
@@ -19,13 +19,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 
-static int test_ok = 1;
-
-static void print_err(const char *msg)
-{
-	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s\n", msg);
-}
+#include "libtest.h"
 
 static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 			      struct nftnl_expr *rule_b)
@@ -58,11 +52,10 @@ int main(int argc, char *argv[])
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
-	if (a == NULL || b == NULL)
-		print_err("OOM");
+	oom_assert(a, argv[0]);
+	oom_assert(b, argv[0]);
 	ex = nftnl_expr_alloc("byteorder");
-	if (ex == NULL)
-		print_err("OOM");
+	oom_assert(ex, argv[0]);
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BYTEORDER_SREG, 0x12345678);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_BYTEORDER_DREG, 0x12345678);
@@ -80,13 +73,13 @@ int main(int argc, char *argv[])
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
-	if (iter_a == NULL || iter_b == NULL)
-		print_err("OOM");
+	oom_assert(iter_a, argv[0]);
+	oom_assert(iter_b, argv[0]);
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
-	if (rule_a == NULL || rule_b == NULL)
-		print_err("OOM");
+	oom_assert(rule_a, argv[0]);
+	oom_assert(rule_b, argv[0]);
 
 	cmp_nftnl_expr(rule_a,rule_b);
 
@@ -99,9 +92,5 @@ int main(int argc, char *argv[])
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	if (!test_ok)
-		exit(EXIT_FAILURE);
-
-	printf("%s: \033[32mOK\e[0m\n", argv[0]);
-	return EXIT_SUCCESS;
+	return test_report(argv[0]);
 }
diff --git a/tests/nft-expr_cmp-test.c b/tests/nft-expr_cmp-test.c
index 4271940..a8d6eb1 100644
--- a/tests/nft-expr_cmp-test.c
+++ b/tests/nft-expr_cmp-test.c
@@ -19,13 +19,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 
-static int test_ok = 1;
-
-static void print_err(const char *msg)
-{
-	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s\n", msg);
-}
+#include "libtest.h"
 
 static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 			      struct nftnl_expr *rule_b)
@@ -56,11 +50,10 @@ int main(int argc, char *argv[])
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
-	if (a == NULL || b == NULL)
-		print_err("OOM");
+	oom_assert(a, argv[0]);
+	oom_assert(b, argv[0]);
 	ex = nftnl_expr_alloc("cmp");
-	if (ex == NULL)
-		print_err("OOM");
+	oom_assert(ex, argv[0]);
 
 	nftnl_expr_set(ex, NFTNL_EXPR_CMP_DATA, &data_len, sizeof(data_len));
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_CMP_SREG, 0x12345678);
@@ -76,12 +69,12 @@ int main(int argc, char *argv[])
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
-	if (iter_a == NULL || iter_b == NULL)
-		print_err("OOM");
+	oom_assert(iter_a, argv[0]);
+	oom_assert(iter_b, argv[0]);
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
-	if (rule_a == NULL || rule_b == NULL)
-		print_err("OOM");
+	oom_assert(rule_a, argv[0]);
+	oom_assert(rule_b, argv[0]);
 
 	cmp_nftnl_expr(rule_a, rule_b);
 
@@ -94,9 +87,5 @@ int main(int argc, char *argv[])
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	if (!test_ok)
-		exit(EXIT_FAILURE);
-
-	printf("%s: \033[32mOK\e[0m\n", argv[0]);
-	return EXIT_SUCCESS;
+	return test_report(argv[0]);
 }
diff --git a/tests/nft-expr_counter-test.c b/tests/nft-expr_counter-test.c
index 519bc1f..7066c26 100644
--- a/tests/nft-expr_counter-test.c
+++ b/tests/nft-expr_counter-test.c
@@ -19,13 +19,8 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 
-static int test_ok = 1;
+#include "libtest.h"
 
-static void print_err(const char *msg)
-{
-	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s\n", msg);
-}
 
 static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 			      struct nftnl_expr *rule_b)
@@ -49,12 +44,11 @@ int main(int argc, char *argv[])
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
-	if (a == NULL || b == NULL)
-		print_err("OOM");
+	oom_assert(a, argv[0]);
+	oom_assert(b, argv[0]);
 
 	ex = nftnl_expr_alloc("counter");
-	if (ex == NULL)
-		print_err("OOM");
+	oom_assert(ex, argv[0]);
 
 	nftnl_expr_set_u64(ex, NFTNL_EXPR_CTR_BYTES, 0x123456789abcdef0);
 	nftnl_expr_set_u64(ex, NFTNL_EXPR_CTR_PACKETS, 0xf0123456789abcde);
@@ -68,12 +62,12 @@ int main(int argc, char *argv[])
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
-	if (iter_a == NULL || iter_b == NULL)
-		print_err("OOM");
+	oom_assert(iter_a, argv[0]);
+	oom_assert(iter_b, argv[0]);
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
-	if (rule_a == NULL || rule_b == NULL)
-		print_err("OOM");
+	oom_assert(rule_a, argv[0]);
+	oom_assert(rule_b, argv[0]);
 
 	cmp_nftnl_expr(rule_a, rule_b);
 
@@ -86,8 +80,5 @@ int main(int argc, char *argv[])
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	if (!test_ok)
-		exit(EXIT_FAILURE);
-	printf("%s: \033[32mOK\e[0m\n", argv[0]);
-	return EXIT_SUCCESS;
+	return test_report(argv[0]);
 }
diff --git a/tests/nft-expr_ct-test.c b/tests/nft-expr_ct-test.c
index e98fbab..cfbe0d6 100644
--- a/tests/nft-expr_ct-test.c
+++ b/tests/nft-expr_ct-test.c
@@ -19,12 +19,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 
-static int test_ok = 1;
-static void print_err(const char *msg)
-{
-	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s\n", msg);
-}
+#include "libtest.h"
 
 static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 			      struct nftnl_expr *rule_b)
@@ -50,11 +45,10 @@ int main(int argc, char *argv[])
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
-	if (a == NULL || b == NULL)
-		print_err("OOM");
+	oom_assert(a, argv[0]);
+	oom_assert(b, argv[0]);
 	ex = nftnl_expr_alloc("ct");
-	if (ex == NULL)
-		print_err("OOM");
+	oom_assert(ex, argv[0]);
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_CT_KEY, 0x1234568);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_CT_DIR, 0x12);
@@ -70,13 +64,13 @@ int main(int argc, char *argv[])
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
-	if (iter_a == NULL || iter_b == NULL)
-		print_err("OOM");
+	oom_assert(iter_a, argv[0]);
+	oom_assert(iter_b, argv[0]);
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
-	if (rule_a == NULL || rule_b == NULL)
-		print_err("OOM");
+	oom_assert(rule_a, argv[0]);
+	oom_assert(rule_b, argv[0]);
 
 	cmp_nftnl_expr(rule_a, rule_b);
 
@@ -89,9 +83,5 @@ int main(int argc, char *argv[])
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	if (!test_ok)
-		exit(EXIT_FAILURE);
-
-	printf("%s: \033[32mOK\e[0m\n", argv[0]);
-	return EXIT_SUCCESS;
+	return test_report(argv[0]);
 }
diff --git a/tests/nft-expr_dup-test.c b/tests/nft-expr_dup-test.c
index 3c37d4a..4ae112d 100644
--- a/tests/nft-expr_dup-test.c
+++ b/tests/nft-expr_dup-test.c
@@ -19,12 +19,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 
-static int test_ok = 1;
-static void print_err(const char *msg)
-{
-	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s\n", msg);
-}
+#include "libtest.h"
 
 static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 			      struct nftnl_expr *rule_b)
@@ -48,11 +43,10 @@ int main(int argc, char *argv[])
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
-	if (a == NULL || b == NULL)
-		print_err("OOM");
+	oom_assert(a, argv[0]);
+	oom_assert(b, argv[0]);
 	ex = nftnl_expr_alloc("dup");
-	if (ex == NULL)
-		print_err("OOM");
+	oom_assert(ex, argv[0]);
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_DUP_SREG_ADDR, 0x12345678);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_DUP_SREG_DEV,  0x78123456);
@@ -67,13 +61,13 @@ int main(int argc, char *argv[])
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
-	if (iter_a == NULL || iter_b == NULL)
-		print_err("OOM");
+	oom_assert(iter_a, argv[0]);
+	oom_assert(iter_b, argv[0]);
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
-	if (rule_a == NULL || rule_b == NULL)
-		print_err("OOM");
+	oom_assert(rule_a, argv[0]);
+	oom_assert(rule_b, argv[0]);
 
 	cmp_nftnl_expr(rule_a, rule_b);
 
@@ -86,9 +80,5 @@ int main(int argc, char *argv[])
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	if (!test_ok)
-		exit(EXIT_FAILURE);
-
-	printf("%s: \033[32mOK\e[0m\n", argv[0]);
-	return EXIT_SUCCESS;
+	return test_report(argv[0]);
 }
diff --git a/tests/nft-expr_exthdr-test.c b/tests/nft-expr_exthdr-test.c
index fef2dd0..56652b5 100644
--- a/tests/nft-expr_exthdr-test.c
+++ b/tests/nft-expr_exthdr-test.c
@@ -19,13 +19,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 
-static int test_ok = 1;
-
-static void print_err(const char *msg)
-{
-	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s\n", msg);
-}
+#include "libtest.h"
 
 static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 			      struct nftnl_expr *rule_b)
@@ -55,11 +49,10 @@ int main(int argc, char *argv[])
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
-	if (a == NULL || b == NULL)
-		print_err("OOM");
+	oom_assert(a, argv[0]);
+	oom_assert(b, argv[0]);
 	ex = nftnl_expr_alloc("exthdr");
-	if (ex == NULL)
-		print_err("OOM");
+	oom_assert(ex, argv[0]);
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_EXTHDR_DREG, 0x12345678);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_EXTHDR_TYPE, 0x12);
@@ -75,13 +68,13 @@ int main(int argc, char *argv[])
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
-	if (iter_a == NULL || iter_b == NULL)
-		print_err("OOM");
+	oom_assert(iter_a, argv[0]);
+	oom_assert(iter_b, argv[0]);
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
-	if (rule_a == NULL || rule_b == NULL)
-		print_err("OOM");
+	oom_assert(rule_a, argv[0]);
+	oom_assert(rule_b, argv[0]);
 
 	cmp_nftnl_expr(rule_a, rule_b);
 
@@ -93,9 +86,6 @@ int main(int argc, char *argv[])
 	nftnl_expr_iter_destroy(iter_b);
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
-	if (!test_ok)
-		exit(EXIT_FAILURE);
 
-	printf("%s: \033[32mOK\e[0m\n", argv[0]);
-	return EXIT_SUCCESS;
+	return test_report(argv[0]);
 }
diff --git a/tests/nft-expr_fwd-test.c b/tests/nft-expr_fwd-test.c
index 4fdf53d..7a27299 100644
--- a/tests/nft-expr_fwd-test.c
+++ b/tests/nft-expr_fwd-test.c
@@ -19,12 +19,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 
-static int test_ok = 1;
-static void print_err(const char *msg)
-{
-	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s\n", msg);
-}
+#include "libtest.h"
 
 static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 			      struct nftnl_expr *rule_b)
@@ -45,11 +40,10 @@ int main(int argc, char *argv[])
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
-	if (a == NULL || b == NULL)
-		print_err("OOM");
+	oom_assert(a, argv[0]);
+	oom_assert(b, argv[0]);
 	ex = nftnl_expr_alloc("dup");
-	if (ex == NULL)
-		print_err("OOM");
+	oom_assert(ex, argv[0]);
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_FWD_SREG_DEV,  0x78123456);
 
@@ -63,13 +57,13 @@ int main(int argc, char *argv[])
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
-	if (iter_a == NULL || iter_b == NULL)
-		print_err("OOM");
+	oom_assert(iter_a, argv[0]);
+	oom_assert(iter_b, argv[0]);
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
-	if (rule_a == NULL || rule_b == NULL)
-		print_err("OOM");
+	oom_assert(rule_a, argv[0]);
+	oom_assert(rule_b, argv[0]);
 
 	cmp_nftnl_expr(rule_a, rule_b);
 
@@ -82,9 +76,5 @@ int main(int argc, char *argv[])
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	if (!test_ok)
-		exit(EXIT_FAILURE);
-
-	printf("%s: \033[32mOK\e[0m\n", argv[0]);
-	return EXIT_SUCCESS;
+	return test_report(argv[0]);
 }
diff --git a/tests/nft-expr_immediate-test.c b/tests/nft-expr_immediate-test.c
index e07092f..ecc1b5d 100644
--- a/tests/nft-expr_immediate-test.c
+++ b/tests/nft-expr_immediate-test.c
@@ -19,13 +19,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 
-static int test_ok = 1;
-
-static void print_err(const char *msg)
-{
-	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s\n", msg);
-}
+#include "libtest.h"
 
 static void cmp_nftnl_expr_verdict(struct nftnl_expr *rule_a,
 				   struct nftnl_expr *rule_b)
@@ -76,12 +70,12 @@ int main(int argc, char *argv[])
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
-	if (a == NULL || b == NULL)
-		print_err("OOM");
+	oom_assert(a, argv[0]);
+	oom_assert(b, argv[0]);
 	ex_val = nftnl_expr_alloc("immediate");
 	ex_ver = nftnl_expr_alloc("immediate");
-	if (!ex_val || !ex_ver)
-		print_err("OOM");
+	oom_assert(ex_val, argv[0]);
+	oom_assert(ex_ver, argv[0]);
 
 	nftnl_expr_set_u32(ex_val, NFTNL_EXPR_IMM_DREG, 0x1234568);
 	nftnl_expr_set(ex_val,     NFTNL_EXPR_IMM_DATA, data, sizeof(data));
@@ -101,20 +95,20 @@ int main(int argc, char *argv[])
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
-	if (iter_a == NULL || iter_b == NULL)
-		print_err("OOM");
+	oom_assert(iter_a, argv[0]);
+	oom_assert(iter_b, argv[0]);
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
-	if (rule_a == NULL || rule_b == NULL)
-		print_err("OOM");
+	oom_assert(rule_a, argv[0]);
+	oom_assert(rule_b, argv[0]);
 
 	cmp_nftnl_expr_value(rule_a, rule_b);
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
-	if (rule_a == NULL || rule_b == NULL)
-		print_err("OOM");
+	oom_assert(rule_a, argv[0]);
+	oom_assert(rule_b, argv[0]);
 
 	cmp_nftnl_expr_verdict(rule_a, rule_b);
 
@@ -127,9 +121,5 @@ int main(int argc, char *argv[])
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	if (!test_ok)
-		exit(EXIT_FAILURE);
-
-	printf("%s: \033[32mOK\e[0m\n", argv[0]);
-	return EXIT_SUCCESS;
+	return test_report(argv[0]);
 }
diff --git a/tests/nft-expr_limit-test.c b/tests/nft-expr_limit-test.c
index 2838941..7848e29 100644
--- a/tests/nft-expr_limit-test.c
+++ b/tests/nft-expr_limit-test.c
@@ -20,13 +20,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 
-static int test_ok = 1;
-
-static void print_err(const char *msg)
-{
-	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s\n", msg);
-}
+#include "libtest.h"
 
 static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 			      struct nftnl_expr *rule_b)
@@ -59,11 +53,10 @@ int main(int argc, char *argv[])
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
-	if (a == NULL || b == NULL)
-		print_err("OOM");
+	oom_assert(a, argv[0]);
+	oom_assert(b, argv[0]);
 	ex = nftnl_expr_alloc("limit");
-	if (ex == NULL)
-		print_err("OOM");
+	oom_assert(ex, argv[0]);
 
 	nftnl_expr_set_u64(ex, NFTNL_EXPR_LIMIT_RATE, 0x123456789abcdef0);
 	nftnl_expr_set_u64(ex, NFTNL_EXPR_LIMIT_UNIT, 0xf0123456789abcde);
@@ -81,13 +74,13 @@ int main(int argc, char *argv[])
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
-	if (iter_a == NULL || iter_b == NULL)
-		print_err("OOM");
+	oom_assert(iter_a, argv[0]);
+	oom_assert(iter_b, argv[0]);
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
-	if (rule_a == NULL || rule_b == NULL)
-		print_err("OOM");
+	oom_assert(rule_a, argv[0]);
+	oom_assert(rule_b, argv[0]);
 
 	cmp_nftnl_expr(rule_a, rule_b);
 
@@ -100,9 +93,5 @@ int main(int argc, char *argv[])
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	if (!test_ok)
-		exit(EXIT_FAILURE);
-
-	printf("%s: \033[32mOK\e[0m\n", argv[0]);
-	return EXIT_SUCCESS;
+	return test_report(argv[0]);
 }
diff --git a/tests/nft-expr_log-test.c b/tests/nft-expr_log-test.c
index b7aa302..a2c1f1d 100644
--- a/tests/nft-expr_log-test.c
+++ b/tests/nft-expr_log-test.c
@@ -19,13 +19,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 
-static int test_ok = 1;
-
-static void print_err(const char *msg)
-{
-	printf("\033[31mERROR:\e[0m %s\n", msg);
-	test_ok = 0;
-}
+#include "libtest.h"
 
 static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 			      struct nftnl_expr *rule_b)
@@ -55,11 +49,10 @@ int main(int argc, char *argv[])
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
-	if (a == NULL || b == NULL)
-		print_err("OOM");
+	oom_assert(a, argv[0]);
+	oom_assert(b, argv[0]);
 	ex = nftnl_expr_alloc("log");
-	if (ex == NULL)
-		print_err("OOM");
+	oom_assert(ex, argv[0]);
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_LOG_SNAPLEN, 0x12345678);
 	nftnl_expr_set_u16(ex, NFTNL_EXPR_LOG_GROUP, 0x1234);
@@ -75,12 +68,12 @@ int main(int argc, char *argv[])
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
-	if (iter_a == NULL || iter_b == NULL)
-		print_err("OOM");
+	oom_assert(iter_a, argv[0]);
+	oom_assert(iter_b, argv[0]);
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
-	if (rule_a == NULL || rule_b == NULL)
-		print_err("OOM");
+	oom_assert(rule_a, argv[0]);
+	oom_assert(rule_b, argv[0]);
 
 	cmp_nftnl_expr(rule_a, rule_b);
 
@@ -93,9 +86,5 @@ int main(int argc, char *argv[])
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	if (!test_ok)
-		exit(EXIT_FAILURE);
-
-	printf("%s: \033[32mOK\e[0m\n", argv[0]);
-	return EXIT_SUCCESS;
+	return test_report(argv[0]);
 }
diff --git a/tests/nft-expr_lookup-test.c b/tests/nft-expr_lookup-test.c
index d1f017b..f7bb7f4 100644
--- a/tests/nft-expr_lookup-test.c
+++ b/tests/nft-expr_lookup-test.c
@@ -19,13 +19,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 
-static int test_ok = 1;
-
-static void print_err(const char *msg)
-{
-	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s\n", msg);
-}
+#include "libtest.h"
 
 static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 			      struct nftnl_expr *rule_b)
@@ -63,11 +57,10 @@ int main(int argc, char *argv[])
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
-	if (a == NULL || b == NULL)
-		print_err("OOM");
+	oom_assert(a, argv[0]);
+	oom_assert(b, argv[0]);
 	ex = nftnl_expr_alloc("lookup");
-	if (ex == NULL)
-		print_err("OOM");
+	oom_assert(ex, argv[0]);
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_LOOKUP_SREG, 0x12345678);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_LOOKUP_DREG, 0x78123456);
@@ -84,12 +77,12 @@ int main(int argc, char *argv[])
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
-	if (iter_a == NULL || iter_b == NULL)
-		print_err("OOM");
+	oom_assert(iter_a, argv[0]);
+	oom_assert(iter_b, argv[0]);
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
-	if (rule_a == NULL || rule_b == NULL)
-		print_err("OOM");
+	oom_assert(rule_a, argv[0]);
+	oom_assert(rule_b, argv[0]);
 
 	cmp_nftnl_expr(rule_a, rule_b);
 
@@ -102,10 +95,5 @@ int main(int argc, char *argv[])
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	if (!test_ok)
-		exit(EXIT_FAILURE);
-
-	printf("%s: \033[32mOK\e[0m\n", argv[0]);
-
-	return EXIT_SUCCESS;
+	return test_report(argv[0]);
 }
diff --git a/tests/nft-expr_masq-test.c b/tests/nft-expr_masq-test.c
index 3f9903d..fdfbf03 100644
--- a/tests/nft-expr_masq-test.c
+++ b/tests/nft-expr_masq-test.c
@@ -17,13 +17,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 
-static int test_ok = 1;
-
-static void print_err(const char *msg)
-{
-	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s\n", msg);
-}
+#include "libtest.h"
 
 static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 			      struct nftnl_expr *rule_b)
@@ -50,11 +44,10 @@ int main(int argc, char *argv[])
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
-	if (a == NULL || b == NULL)
-		print_err("OOM");
+	oom_assert(a, argv[0]);
+	oom_assert(b, argv[0]);
 	ex = nftnl_expr_alloc("masq");
-	if (ex == NULL)
-		print_err("OOM");
+	oom_assert(ex, argv[0]);
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_MASQ_FLAGS, 0x1234568);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_MASQ_REG_PROTO_MIN, 0x5432178);
@@ -70,13 +63,13 @@ int main(int argc, char *argv[])
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
-	if (iter_a == NULL || iter_b == NULL)
-		print_err("OOM");
+	oom_assert(iter_a, argv[0]);
+	oom_assert(iter_b, argv[0]);
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
-	if (rule_a == NULL || rule_b == NULL)
-		print_err("OOM");
+	oom_assert(rule_a, argv[0]);
+	oom_assert(rule_b, argv[0]);
 
 	cmp_nftnl_expr(rule_a, rule_b);
 
@@ -89,9 +82,5 @@ int main(int argc, char *argv[])
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	if (!test_ok)
-		exit(EXIT_FAILURE);
-
-	printf("%s: \033[32mOK\e[0m\n", argv[0]);
-	return EXIT_SUCCESS;
+	return test_report(argv[0]);
 }
diff --git a/tests/nft-expr_match-test.c b/tests/nft-expr_match-test.c
index 39a49d8..9902d2f 100644
--- a/tests/nft-expr_match-test.c
+++ b/tests/nft-expr_match-test.c
@@ -20,19 +20,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 
-static int test_ok = 1;
-
-static void print_err(const char *msg)
-{
-	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s\n", msg);
-}
-
-static void print_err2(const char *msg, uint32_t a, uint32_t b)
-{
-	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s size a: %d b: %d \n", msg, a, b);
-}
+#include "libtest.h"
 
 static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 			      struct nftnl_expr *rule_b)
@@ -48,7 +36,8 @@ static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 	nftnl_expr_get(rule_a, NFTNL_EXPR_MT_INFO, &lena);
 	nftnl_expr_get(rule_b, NFTNL_EXPR_MT_INFO, &lenb);
 	if (lena != lenb)
-		print_err2("Expr NFTNL_EXPR_MT_INFO size mismatches", lena, lenb);
+		print_err("Expr NFTNL_EXPR_MT_INFO size mismatches: %d != %d",
+			  lena, lenb);
 }
 
 int main(int argc, char *argv[])
@@ -63,11 +52,10 @@ int main(int argc, char *argv[])
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
-	if (a == NULL || b == NULL)
-		print_err("OOM");
+	oom_assert(a, argv[0]);
+	oom_assert(b, argv[0]);
 	ex = nftnl_expr_alloc("match");
-	if (ex == NULL)
-		print_err("OOM");
+	oom_assert(ex, argv[0]);
 
 	nftnl_expr_set_str(ex, NFTNL_EXPR_MT_NAME, "Tests");
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_MT_REV, 0x12345678);
@@ -81,13 +69,13 @@ int main(int argc, char *argv[])
 		print_err("parsing problems");
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
-	if (iter_a == NULL || iter_b == NULL)
-		print_err("OOM");
+	oom_assert(iter_a, argv[0]);
+	oom_assert(iter_b, argv[0]);
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
-	if (rule_a == NULL || rule_b == NULL)
-		print_err("OOM");
+	oom_assert(rule_a, argv[0]);
+	oom_assert(rule_b, argv[0]);
 
 	cmp_nftnl_expr(rule_a, rule_b);
 
@@ -100,9 +88,5 @@ int main(int argc, char *argv[])
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	if (!test_ok)
-		exit(EXIT_FAILURE);
-
-	printf("%s: \033[32mOK\e[0m\n", argv[0]);
-	return EXIT_SUCCESS;
+	return test_report(argv[0]);
 }
diff --git a/tests/nft-expr_meta-test.c b/tests/nft-expr_meta-test.c
index 8fb7873..e528631 100644
--- a/tests/nft-expr_meta-test.c
+++ b/tests/nft-expr_meta-test.c
@@ -19,13 +19,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 
-static int test_ok = 1;
-
-static void print_err(const char *msg)
-{
-	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s\n", msg);
-}
+#include "libtest.h"
 
 static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 			      struct nftnl_expr *rule_b)
@@ -49,11 +43,10 @@ int main(int argc, char *argv[])
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
-	if (a == NULL || b == NULL)
-		print_err("OOM");
+	oom_assert(a, argv[0]);
+	oom_assert(b, argv[0]);
 	ex = nftnl_expr_alloc("meta");
-	if (ex == NULL)
-		print_err("OOM");
+	oom_assert(ex, argv[0]);
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_META_KEY, 0x1234568);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_META_DREG, 0x78123456);
@@ -67,13 +60,13 @@ int main(int argc, char *argv[])
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
-	if (iter_a == NULL || iter_b == NULL)
-		print_err("OOM");
+	oom_assert(iter_a, argv[0]);
+	oom_assert(iter_b, argv[0]);
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
-	if (rule_a == NULL || rule_b == NULL)
-		print_err("OOM");
+	oom_assert(rule_a, argv[0]);
+	oom_assert(rule_b, argv[0]);
 
 	cmp_nftnl_expr(rule_a, rule_b);
 
@@ -86,9 +79,5 @@ int main(int argc, char *argv[])
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	if (!test_ok)
-		exit(EXIT_FAILURE);
-
-	printf("%s: \033[32mOK\e[0m\n", argv[0]);
-	return EXIT_SUCCESS;
+	return test_report(argv[0]);
 }
diff --git a/tests/nft-expr_nat-test.c b/tests/nft-expr_nat-test.c
index 9c15a0a..fdd91ba 100644
--- a/tests/nft-expr_nat-test.c
+++ b/tests/nft-expr_nat-test.c
@@ -20,13 +20,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 
-static int test_ok = 1;
-
-static void print_err(const char *msg)
-{
-	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s\n", msg);
-}
+#include "libtest.h"
 
 static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 			      struct nftnl_expr *rule_b)
@@ -65,11 +59,10 @@ int main(int argc, char *argv[])
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
-	if (a == NULL || b == NULL)
-		print_err("OOM");
+	oom_assert(a, argv[0]);
+	oom_assert(b, argv[0]);
 	ex = nftnl_expr_alloc("nat");
-	if (ex == NULL)
-		print_err("OOM");
+	oom_assert(ex, argv[0]);
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_TYPE, NFT_NAT_SNAT);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_FAMILY, NFPROTO_INET);
@@ -89,13 +82,13 @@ int main(int argc, char *argv[])
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
-	if (iter_a == NULL || iter_b == NULL)
-		print_err("OOM");
+	oom_assert(iter_a, argv[0]);
+	oom_assert(iter_b, argv[0]);
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
-	if (rule_a == NULL || rule_b == NULL)
-		print_err("OOM");
+	oom_assert(rule_a, argv[0]);
+	oom_assert(rule_b, argv[0]);
 
 	cmp_nftnl_expr(rule_a, rule_b);
 
@@ -108,9 +101,5 @@ int main(int argc, char *argv[])
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	if (!test_ok)
-		exit(EXIT_FAILURE);
-
-	printf("%s: \033[32mOK\e[0m\n", argv[0]);
-	return EXIT_SUCCESS;
+	return test_report(argv[0]);
 }
diff --git a/tests/nft-expr_payload-test.c b/tests/nft-expr_payload-test.c
index 371372c..0812d6d 100644
--- a/tests/nft-expr_payload-test.c
+++ b/tests/nft-expr_payload-test.c
@@ -20,13 +20,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 
-static int test_ok = 1;
-
-static void print_err(const char *msg)
-{
-	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s\n", msg);
-}
+#include "libtest.h"
 
 static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 			      struct nftnl_expr *rule_b)
@@ -56,11 +50,10 @@ int main(int argc, char *argv[])
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
-	if (a == NULL || b == NULL)
-		print_err("OOM");
+	oom_assert(a, argv[0]);
+	oom_assert(b, argv[0]);
 	ex = nftnl_expr_alloc("payload");
-	if (ex == NULL)
-		print_err("OOM");
+	oom_assert(ex, argv[0]);
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_PAYLOAD_DREG, 0x1234568);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_PAYLOAD_BASE, 0x78123456);
@@ -76,13 +69,13 @@ int main(int argc, char *argv[])
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
-	if (iter_a == NULL || iter_b == NULL)
-		print_err("OOM");
+	oom_assert(iter_a, argv[0]);
+	oom_assert(iter_b, argv[0]);
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
-	if (rule_a == NULL || rule_b == NULL)
-		print_err("OOM");
+	oom_assert(rule_a, argv[0]);
+	oom_assert(rule_b, argv[0]);
 
 	cmp_nftnl_expr(rule_a, rule_b);
 
@@ -95,9 +88,5 @@ int main(int argc, char *argv[])
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	if (!test_ok)
-		exit(EXIT_FAILURE);
-
-	printf("%s: \033[32mOK\e[0m\n", argv[0]);
-	return EXIT_SUCCESS;
+	return test_report(argv[0]);
 }
diff --git a/tests/nft-expr_queue-test.c b/tests/nft-expr_queue-test.c
index 1cc39aa..327e8fd 100644
--- a/tests/nft-expr_queue-test.c
+++ b/tests/nft-expr_queue-test.c
@@ -22,13 +22,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 
-static int test_ok = 1;
-
-static void print_err(const char *msg)
-{
-	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s\n", msg);
-}
+#include "libtest.h"
 
 static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 			      struct nftnl_expr *rule_b)
@@ -52,11 +46,10 @@ int main(int argc, char *argv[])
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
-	if (a == NULL || b == NULL)
-		print_err("OOM");
+	oom_assert(a, argv[0]);
+	oom_assert(b, argv[0]);
 	ex = nftnl_expr_alloc("queue");
-	if (ex == NULL)
-		print_err("OOM");
+	oom_assert(ex, argv[0]);
 
 	nftnl_expr_set_u16(ex, NFTNL_EXPR_QUEUE_NUM, 0x01010);
 	nftnl_expr_set_u16(ex, NFTNL_EXPR_QUEUE_TOTAL, 0x1234);
@@ -72,13 +65,13 @@ int main(int argc, char *argv[])
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
-	if (iter_a == NULL || iter_b == NULL)
-		print_err("OOM");
+	oom_assert(iter_a, argv[0]);
+	oom_assert(iter_b, argv[0]);
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
-	if (rule_a == NULL || rule_b == NULL)
-		print_err("OOM");
+	oom_assert(rule_a, argv[0]);
+	oom_assert(rule_b, argv[0]);
 
 	cmp_nftnl_expr(rule_a, rule_b);
 
@@ -91,9 +84,5 @@ int main(int argc, char *argv[])
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	if (!test_ok)
-		exit(EXIT_FAILURE);
-
-	printf("%s: \033[32mOK\e[0m\n", argv[0]);
-	return EXIT_SUCCESS;
+	return test_report(argv[0]);
 }
diff --git a/tests/nft-expr_redir-test.c b/tests/nft-expr_redir-test.c
index 6c8caec..ce97928 100644
--- a/tests/nft-expr_redir-test.c
+++ b/tests/nft-expr_redir-test.c
@@ -17,13 +17,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 
-static int test_ok = 1;
-
-static void print_err(const char *msg)
-{
-	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s\n", msg);
-}
+#include "libtest.h"
 
 static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 			      struct nftnl_expr *rule_b)
@@ -50,11 +44,10 @@ int main(int argc, char *argv[])
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
-	if (a == NULL || b == NULL)
-		print_err("OOM");
+	oom_assert(a, argv[0]);
+	oom_assert(b, argv[0]);
 	ex = nftnl_expr_alloc("redir");
-	if (ex == NULL)
-		print_err("OOM");
+	oom_assert(ex, argv[0]);
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_REDIR_REG_PROTO_MIN, 0x12345678);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_REDIR_REG_PROTO_MAX, 0x56781234);
@@ -70,13 +63,13 @@ int main(int argc, char *argv[])
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
-	if (iter_a == NULL || iter_b == NULL)
-		print_err("OOM");
+	oom_assert(iter_a, argv[0]);
+	oom_assert(iter_b, argv[0]);
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
-	if (rule_a == NULL || rule_b == NULL)
-		print_err("OOM");
+	oom_assert(rule_a, argv[0]);
+	oom_assert(rule_b, argv[0]);
 
 	cmp_nftnl_expr(rule_a, rule_b);
 
@@ -89,9 +82,5 @@ int main(int argc, char *argv[])
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	if (!test_ok)
-		exit(EXIT_FAILURE);
-
-	printf("%s: \033[32mOK\e[0m\n", argv[0]);
-	return EXIT_SUCCESS;
+	return test_report(argv[0]);
 }
diff --git a/tests/nft-expr_reject-test.c b/tests/nft-expr_reject-test.c
index d8189ea..426f9e9 100644
--- a/tests/nft-expr_reject-test.c
+++ b/tests/nft-expr_reject-test.c
@@ -20,13 +20,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 
-static int test_ok = 1;
-
-static void print_err(const char *msg)
-{
-	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s\n", msg);
-}
+#include "libtest.h"
 
 static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 			      struct nftnl_expr *rule_b)
@@ -50,11 +44,10 @@ int main(int argc, char *argv[])
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
-	if (a == NULL || b == NULL)
-		print_err("OOM");
+	oom_assert(a, argv[0]);
+	oom_assert(b, argv[0]);
 	ex = nftnl_expr_alloc("reject");
-	if (ex == NULL)
-		print_err("OOM");
+	oom_assert(ex, argv[0]);
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_REJECT_TYPE, 0x12345678);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_REJECT_CODE, 0x45681234);
@@ -69,13 +62,13 @@ int main(int argc, char *argv[])
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
-	if (iter_a == NULL || iter_b == NULL)
-		print_err("OOM");
+	oom_assert(iter_a, argv[0]);
+	oom_assert(iter_b, argv[0]);
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
-	if (rule_a == NULL || rule_b == NULL)
-		print_err("OOM");
+	oom_assert(rule_a, argv[0]);
+	oom_assert(rule_b, argv[0]);
 
 	cmp_nftnl_expr(rule_a, rule_b);
 
@@ -88,9 +81,5 @@ int main(int argc, char *argv[])
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	if (!test_ok)
-		exit(EXIT_FAILURE);
-
-	printf("%s: \033[32mOK\e[0m\n", argv[0]);
-	return EXIT_SUCCESS;
+	return test_report(argv[0]);
 }
diff --git a/tests/nft-expr_target-test.c b/tests/nft-expr_target-test.c
index ba56b27..82a4a9f 100644
--- a/tests/nft-expr_target-test.c
+++ b/tests/nft-expr_target-test.c
@@ -19,19 +19,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 
-static int test_ok = 1;
-
-static void print_err(const char *msg)
-{
-	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s\n", msg);
-}
-
-static void print_err2(const char *msg, uint32_t a, uint32_t b)
-{
-	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s size a: %d b: %d \n",msg, a, b);
-}
+#include "libtest.h"
 
 static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 			      struct nftnl_expr *rule_b)
@@ -47,7 +35,8 @@ static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 	nftnl_expr_get(rule_a, NFTNL_EXPR_TG_INFO, &lena);
 	nftnl_expr_get(rule_b, NFTNL_EXPR_TG_INFO, &lenb);
 	if (lena != lenb)
-		print_err2("Expr NFTNL_EXPR_TG_INFO size mismatches", lena, lenb);
+		print_err("Expr NFTNL_EXPR_TG_INFO size mismatches: %d != %d",
+			  lena, lenb);
 }
 
 int main(int argc, char *argv[])
@@ -62,12 +51,11 @@ int main(int argc, char *argv[])
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
-	if (a == NULL || b == NULL)
-		print_err("OOM");
+	oom_assert(a, argv[0]);
+	oom_assert(b, argv[0]);
 
 	ex = nftnl_expr_alloc("target");
-	if (ex == NULL)
-		print_err("OOM");
+	oom_assert(ex, argv[0]);
 
 	nftnl_expr_set(ex, NFTNL_EXPR_TG_NAME, "test", strlen("test"));
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_TG_REV, 0x56781234);
@@ -82,13 +70,13 @@ int main(int argc, char *argv[])
 
 	iter_a = nftnl_expr_iter_create(a);
 	iter_b = nftnl_expr_iter_create(b);
-	if (iter_a == NULL || iter_b == NULL)
-		print_err("OOM");
+	oom_assert(iter_a, argv[0]);
+	oom_assert(iter_b, argv[0]);
 
 	rule_a = nftnl_expr_iter_next(iter_a);
 	rule_b = nftnl_expr_iter_next(iter_b);
-	if (rule_a == NULL || rule_b == NULL)
-		print_err("OOM");
+	oom_assert(rule_a, argv[0]);
+	oom_assert(rule_b, argv[0]);
 
 	cmp_nftnl_expr(rule_a, rule_b);
 
@@ -101,8 +89,5 @@ int main(int argc, char *argv[])
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 
-	if (!test_ok)
-		exit(EXIT_FAILURE);
-	printf("%s: \033[32mOK\e[0m\n", argv[0]);
-	return EXIT_SUCCESS;
+	return test_report(argv[0]);
 }
diff --git a/tests/nft-rule-test.c b/tests/nft-rule-test.c
index dee3530..c6ba719 100644
--- a/tests/nft-rule-test.c
+++ b/tests/nft-rule-test.c
@@ -17,13 +17,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/udata.h>
 
-static int test_ok = 1;
-
-static void print_err(const char *msg)
-{
-	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s\n", msg);
-}
+#include "libtest.h"
 
 static void cmp_nftnl_rule(struct nftnl_rule *a, struct nftnl_rule *b)
 {
@@ -68,12 +62,11 @@ int main(int argc, char *argv[])
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
-	if (a == NULL || b == NULL)
-		print_err("OOM");
+	oom_assert(a, argv[0]);
+	oom_assert(b, argv[0]);
 
 	udata = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
-	if (!udata)
-		print_err("OOM");
+	oom_assert(udata, argv[0]);
 
 	if (!nftnl_udata_put_strz(udata, 0, "hello world"))
 		print_err("User data too big");
@@ -100,9 +93,6 @@ int main(int argc, char *argv[])
 
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
-	if (!test_ok)
-		exit(EXIT_FAILURE);
 
-	printf("%s: \033[32mOK\e[0m\n", argv[0]);
-	return EXIT_SUCCESS;
+	return test_report(argv[0]);
 }
diff --git a/tests/nft-set-test.c b/tests/nft-set-test.c
index 173c17f..6f9b03d 100644
--- a/tests/nft-set-test.c
+++ b/tests/nft-set-test.c
@@ -16,13 +16,7 @@
 
 #include <libnftnl/set.h>
 
-static int test_ok = 1;
-
-static void print_err(const char *msg)
-{
-	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s\n", msg);
-}
+#include "libtest.h"
 
 static void cmp_nftnl_set(struct nftnl_set *a, struct nftnl_set *b)
 {
@@ -60,8 +54,8 @@ int main(int argc, char *argv[])
 
 	a = nftnl_set_alloc();
 	b = nftnl_set_alloc();
-	if (a == NULL || b == NULL)
-		print_err("OOM");
+	oom_assert(a, argv[0]);
+	oom_assert(b, argv[0]);
 
 	nftnl_set_set_str(a, NFTNL_SET_TABLE, "test-table");
 	nftnl_set_set_str(a, NFTNL_SET_NAME, "test-name");
@@ -84,9 +78,5 @@ int main(int argc, char *argv[])
 
 	nftnl_set_free(a); nftnl_set_free(b);
 
-	if (!test_ok)
-		exit(EXIT_FAILURE);
-
-	printf("%s: \033[32mOK\e[0m\n", argv[0]);
-	return EXIT_SUCCESS;
+	return test_report(argv[0]);
 }
diff --git a/tests/nft-table-test.c b/tests/nft-table-test.c
index 1031ffe..6b0418f 100644
--- a/tests/nft-table-test.c
+++ b/tests/nft-table-test.c
@@ -16,13 +16,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <libnftnl/table.h>
 
-static int test_ok = 1;
-
-static void print_err(const char *msg)
-{
-	test_ok = 0;
-	printf("\033[31mERROR:\e[0m %s\n", msg);
-}
+#include "libtest.h"
 
 static void cmp_nftnl_table(struct nftnl_table *a, struct nftnl_table *b)
 {
@@ -47,8 +41,8 @@ int main(int argc, char *argv[])
 	a = nftnl_table_alloc();
 	b = nftnl_table_alloc();
 
-	if (a == NULL || b == NULL)
-		print_err("OOM");
+	oom_assert(a, argv[0]);
+	oom_assert(b, argv[0]);
 
 	nftnl_table_set_str(a, NFTNL_TABLE_NAME, "test");
 	nftnl_table_set_u32(a, NFTNL_TABLE_FAMILY, AF_INET);
@@ -66,9 +60,6 @@ int main(int argc, char *argv[])
 
 	nftnl_table_free(a);
 	nftnl_table_free(b);
-	if (!test_ok)
-		exit(EXIT_FAILURE);
 
-	printf("%s: \033[32mOK\e[0m\n", argv[0]);
-	return EXIT_SUCCESS;
+	return test_report(argv[0]);
 }
-- 
2.8.3

