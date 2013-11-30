From: Eric Leblond <eric@regit.org>
Subject: [libnftables PATCH 2/2] test: add tests for expr queue
Date: Sat, 30 Nov 2013 11:57:22 +0100
Message-ID: <1385809042-20049-2-git-send-email-eric@regit.org>
References: <1385808722.4321.19.camel@ice-age2.regit.org>
 <1385809042-20049-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:38776 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab3K3K5i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Nov 2013 05:57:38 -0500
In-Reply-To: <1385809042-20049-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Eric Leblond <eric@regit.org>
---
 tests/Makefile.am           |  4 ++
 tests/nft-expr_queue-test.c | 99 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 103 insertions(+)
 create mode 100644 tests/nft-expr_queue-test.c

diff --git a/tests/Makefile.am b/tests/Makefile.am
index 362eeac..576bf73 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -19,6 +19,7 @@ check_PROGRAMS = 	nft-parsing-test		\
 			nft-expr_meta-test		\
 			nft-expr_nat-test		\
 			nft-expr_payload-test		\
+			nft-expr_queue-test		\
 			nft-expr_reject-test		\
 			nft-expr_target-test
 
@@ -79,6 +80,9 @@ nft_expr_nat_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
 nft_expr_payload_test_SOURCES = nft-expr_payload-test.c
 nft_expr_payload_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
 
+nft_expr_queue_test_SOURCES = nft-expr_queue-test.c
+nft_expr_queue_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+
 nft_expr_reject_test_SOURCES = nft-expr_reject-test.c
 nft_expr_reject_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
 
diff --git a/tests/nft-expr_queue-test.c b/tests/nft-expr_queue-test.c
new file mode 100644
index 0000000..eb741f4
--- /dev/null
+++ b/tests/nft-expr_queue-test.c
@@ -0,0 +1,99 @@
+/*
+ * (C) 2013 by Eric Leblond <eric@regit.org>
+ *
+ * Based on test framework by Ana Rey Botello <anarey@gmail.com>
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
+
+#include <netinet/in.h>
+#include <netinet/ip.h>
+#include <linux/netfilter/nf_tables.h>
+#include <linux/netfilter/xt_iprange.h>
+#include <libmnl/libmnl.h>
+#include <libnftables/rule.h>
+#include <libnftables/expr.h>
+
+static int test_ok = 1;
+
+static void print_err(const char *msg)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	if (nft_rule_expr_get_u16(rule_a, NFT_EXPR_QUEUE_NUM) !=
+	    nft_rule_expr_get_u16(rule_b, NFT_EXPR_QUEUE_NUM))
+		print_err("Expr NFT_EXPR_QUEUE_NUM mismatches");
+	if (nft_rule_expr_get_u16(rule_a, NFT_EXPR_QUEUE_TOTAL) !=
+	    nft_rule_expr_get_u16(rule_b, NFT_EXPR_QUEUE_TOTAL))
+		print_err("Expr NFT_EXPR_QUEUE_TOTAL mismatches");
+}
+
+int main(int argc, char *argv[])
+{
+	struct nft_rule *a, *b;
+	struct nft_rule_expr *ex;
+	struct nlmsghdr *nlh;
+	char buf[4096];
+	struct nft_rule_expr_iter *iter_a, *iter_b;
+	struct nft_rule_expr *rule_a, *rule_b;
+
+	a = nft_rule_alloc();
+	b = nft_rule_alloc();
+	if (a == NULL || b == NULL)
+		print_err("OOM");
+	ex = nft_rule_expr_alloc("queue");
+	if (ex == NULL)
+		print_err("OOM");
+
+	nft_rule_expr_set_u16(ex, NFT_EXPR_QUEUE_NUM, 0x123);
+	nft_rule_expr_set_u16(ex, NFT_EXPR_QUEUE_TOTAL, 0x2);
+	nft_rule_expr_set_u16(ex, NFT_EXPR_QUEUE_FLAGS, 0x2);
+
+	nft_rule_add_expr(a, ex);
+
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		print_err("parsing problems");
+
+	iter_a = nft_rule_expr_iter_create(a);
+	iter_b = nft_rule_expr_iter_create(b);
+	if (iter_a == NULL || iter_b == NULL)
+		print_err("OOM");
+
+	rule_a = nft_rule_expr_iter_next(iter_a);
+	rule_b = nft_rule_expr_iter_next(iter_b);
+	if (rule_a == NULL || rule_b == NULL)
+		print_err("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) != NULL ||
+	    nft_rule_expr_iter_next(iter_b) != NULL)
+		print_err("More 1 expr.");
+
+	nft_rule_expr_iter_destroy(iter_a);
+	nft_rule_expr_iter_destroy(iter_b);
+	nft_rule_free(a);
+	nft_rule_free(b);
+
+	if (!test_ok)
+		exit(EXIT_FAILURE);
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
-- 
1.8.4.4

