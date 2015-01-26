From: Ana Rey Botello <ana@soleta.eu>
Subject: [libnftnl v2 2/2] tests: add unit tests for counters
Date: Mon, 26 Jan 2015 20:43:31 +0100
Message-ID: <65bfae59a26c8229e0745cbb4174b77d116cb74b.1422299705.git.ana@soleta.eu>
References: <cover.1422299627.git.ana@soleta.eu>
Cc: Ana Rey Botello <ana@soleta.eu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 129.166.216.87.static.jazztel.es ([87.216.166.129]:47441 "EHLO
	correo.soleta.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240AbbAZTm6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:42:58 -0500
In-Reply-To: <cover.1422299627.git.ana@soleta.eu>
In-Reply-To: <cover.1422299705.git.ana@soleta.eu>
References: <cover.1422299705.git.ana@soleta.eu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds unit test for counters and updates the expr-counter test.

Signed-off-by: Ana Rey Botello <ana@soleta.eu>
---
 tests/Makefile.am             |    4 ++
 tests/nft-counter-test.c      |   86 +++++++++++++++++++++++++++++++++++++++++
 tests/nft-expr_counter-test.c |    4 ++
 3 files changed, 94 insertions(+)
 create mode 100644 tests/nft-counter-test.c

diff --git a/tests/Makefile.am b/tests/Makefile.am
index c0356f1..471cda5 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -9,6 +9,7 @@ check_PROGRAMS = 	nft-parsing-test		\
 			nft-chain-test			\
 			nft-rule-test			\
 			nft-set-test			\
+			nft-counter-test		\
 			nft-expr_bitwise-test		\
 			nft-expr_byteorder-test		\
 			nft-expr_counter-test		\
@@ -44,6 +45,9 @@ nft_rule_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 nft_set_test_SOURCES = nft-set-test.c
 nft_set_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
+nft_counter_test_SOURCES = nft-counter-test.c
+nft_counter_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
 nft_expr_bitwise_test_SOURCES = nft-expr_bitwise-test.c
 nft_expr_bitwise_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
diff --git a/tests/nft-counter-test.c b/tests/nft-counter-test.c
new file mode 100644
index 0000000..6a96ab5
--- /dev/null
+++ b/tests/nft-counter-test.c
@@ -0,0 +1,86 @@
+/*
+ * (C) 2015 by Ana Rey <ana@soleta.eu>
+ * (C) 2014 Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2014 Intra2net AG <http://www.intra2net.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <netinet/in.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include <libnftnl/counter.h>
+
+static int test_ok = 1;
+
+static void print_err(const char *msg)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+}
+
+static void cmp_nft_counter(struct nft_counter *a, struct nft_counter *b)
+{
+	if (strcmp(nft_counter_attr_get_str(a, NFT_COUNTER_ATTR_TABLE),
+		   nft_counter_attr_get_str(b, NFT_COUNTER_ATTR_TABLE)) != 0)
+		print_err("Counter table mismatches");
+	if (strcmp(nft_counter_attr_get_str(a, NFT_COUNTER_ATTR_NAME),
+		   nft_counter_attr_get_str(b, NFT_COUNTER_ATTR_NAME)) != 0)
+		print_err("Counter name mismatches");
+	if (nft_counter_attr_get_u32(a, NFT_COUNTER_ATTR_FAMILY) !=
+	    nft_counter_attr_get_u32(b, NFT_COUNTER_ATTR_FAMILY))
+		print_err("Counter family mismatches");
+	if (nft_counter_attr_get_u32(a, NFT_COUNTER_ATTR_USE) !=
+	    nft_counter_attr_get_u32(b, NFT_COUNTER_ATTR_USE))
+		print_err("Counter use mismatches");
+	if (nft_counter_attr_get_u64(a, NFT_COUNTER_ATTR_PKTS) !=
+	    nft_counter_attr_get_u64(b, NFT_COUNTER_ATTR_PKTS))
+		print_err("Counter packets mismatches");
+	if (nft_counter_attr_get_u64(a, NFT_COUNTER_ATTR_BYTES) !=
+	    nft_counter_attr_get_u64(b, NFT_COUNTER_ATTR_BYTES))
+		print_err("Counter bytes mismatches");
+}
+
+int main(int argc, char *argv[])
+{
+	struct nft_counter *a, *b = NULL;
+	char buf[4096];
+	struct nlmsghdr *nlh;
+
+	a = nft_counter_alloc();
+	b = nft_counter_alloc();
+	if (a == NULL || b == NULL)
+		print_err("OOM");
+
+	nft_counter_attr_set_str(a, NFT_COUNTER_ATTR_TABLE, "test-table");
+	nft_counter_attr_set_str(a, NFT_COUNTER_ATTR_NAME, "counter-name");
+	nft_counter_attr_set_u32(a, NFT_COUNTER_ATTR_FAMILY, 0x12345678);
+	nft_counter_attr_set_u32(a, NFT_COUNTER_ATTR_USE, 0x12345678);
+	nft_counter_attr_set_u64(a, NFT_COUNTER_ATTR_PKTS, 0x123456789abcdef0);
+	nft_counter_attr_set_u64(a, NFT_COUNTER_ATTR_BYTES, 0x123456789abcdef0);
+
+	/* cmd extracted from include/linux/netfilter/nf_tables.h */
+	nlh = nft_counter_nlmsg_build_hdr(buf, NFT_MSG_NEWCOUNTER, AF_INET,
+					  0, 1234);
+	nft_counter_nlmsg_build_payload(nlh, a);
+
+	if (nft_counter_nlmsg_parse(nlh, b) < 0)
+		print_err("parsing problems");
+
+	cmp_nft_counter(a, b);
+
+	nft_counter_free(a); nft_counter_free(b);
+
+	if (!test_ok)
+		exit(EXIT_FAILURE);
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/nft-expr_counter-test.c b/tests/nft-expr_counter-test.c
index e27d20a..a961fa7 100644
--- a/tests/nft-expr_counter-test.c
+++ b/tests/nft-expr_counter-test.c
@@ -36,6 +36,9 @@ static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
 	if (nft_rule_expr_get_u64(rule_a, NFT_EXPR_CTR_PACKETS) !=
 	    nft_rule_expr_get_u64(rule_b, NFT_EXPR_CTR_PACKETS))
 		print_err("Expr NFT_EXPR_CTR_PACKETS mismatches");
+	if (strcmp(nft_rule_expr_get_str(rule_a, NFT_EXPR_CTR_NAME),
+		   nft_rule_expr_get_str(rule_b, NFT_EXPR_CTR_NAME)) != 0)
+		print_err("Expr NFT_EXPR_CTR_NAME mismatches");
 }
 
 int main(int argc, char *argv[])
@@ -56,6 +59,7 @@ int main(int argc, char *argv[])
 	if (ex == NULL)
 		print_err("OOM");
 
+	nft_rule_expr_set_str(ex, NFT_EXPR_CTR_NAME, "counter-name");
 	nft_rule_expr_set_u64(ex, NFT_EXPR_CTR_BYTES, 0x123456789abcdef0);
 	nft_rule_expr_set_u64(ex, NFT_EXPR_CTR_PACKETS, 0x123456789abcdef0);
 	nft_rule_add_expr(a, ex);
-- 
1.7.10.4

