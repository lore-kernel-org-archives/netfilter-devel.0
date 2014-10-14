From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 2/2] tests: add tests for nft_redir expression
Date: Tue, 14 Oct 2014 19:36:22 +0200
Message-ID: <20141014173622.12044.59088.stgit@nfdev.cica.es>
References: <20141014173616.12044.90963.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:38894 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754438AbaJNRgb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Oct 2014 13:36:31 -0400
In-Reply-To: <20141014173616.12044.90963.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch add some tests for the nft_redir expression.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/Makefile.am                  |    4 +
 tests/jsonfiles/69-rule-redir.json |    1 
 tests/nft-expr_redir-test.c        |   97 ++++++++++++++++++++++++++++++++++++
 tests/test-script.sh               |    1 
 tests/xmlfiles/80-rule-redir.xml   |    1 
 5 files changed, 104 insertions(+)
 create mode 100644 tests/jsonfiles/69-rule-redir.json
 create mode 100644 tests/nft-expr_redir-test.c
 create mode 100644 tests/xmlfiles/80-rule-redir.xml

diff --git a/tests/Makefile.am b/tests/Makefile.am
index d4f44af..bac2106 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -21,6 +21,7 @@ check_PROGRAMS = 	nft-parsing-test		\
 			nft-expr_log-test		\
 			nft-expr_match-test		\
 			nft-expr_masq-test		\
+			nft-expr_redir-test		\
 			nft-expr_meta-test		\
 			nft-expr_nat-test		\
 			nft-expr_payload-test		\
@@ -79,6 +80,9 @@ nft_expr_match_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 nft_expr_masq_test_SOURCES = nft-expr_masq-test.c
 nft_expr_masq_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
+nft_expr_redir_test_SOURCES = nft-expr_redir-test.c
+nft_expr_redir_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
 nft_expr_meta_test_SOURCES = nft-expr_meta-test.c
 nft_expr_meta_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
diff --git a/tests/jsonfiles/69-rule-redir.json b/tests/jsonfiles/69-rule-redir.json
new file mode 100644
index 0000000..043fff2
--- /dev/null
+++ b/tests/jsonfiles/69-rule-redir.json
@@ -0,0 +1 @@
+{"nftables":[{"rule":{"family":"ip6","table":"nat","chain":"prerouting","handle":4,"expr":[{"type":"redir"}]}}]}
diff --git a/tests/nft-expr_redir-test.c b/tests/nft-expr_redir-test.c
new file mode 100644
index 0000000..4d41c61
--- /dev/null
+++ b/tests/nft-expr_redir-test.c
@@ -0,0 +1,97 @@
+/*
+ * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
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
+#include <linux/netfilter/nf_tables.h>
+#include <libmnl/libmnl.h>
+#include <libnftnl/rule.h>
+#include <libnftnl/expr.h>
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
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_REDIR_REG_PROTO_MIN) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_REDIR_REG_PROTO_MIN))
+		print_err("Expr NFT_EXPR_REDIR_REG_PROTO_MIN mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_REDIR_REG_PROTO_MAX) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_REDIR_REG_PROTO_MAX))
+		print_err("Expr NFT_EXPR_REDIR_REG_PROTO_MAX mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_REDIR_FLAGS) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_REDIR_FLAGS))
+		print_err("Expr NFT_EXPR_REDIR_FLAGS mismatches");
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
+	ex = nft_rule_expr_alloc("redir");
+	if (ex == NULL)
+		print_err("OOM");
+
+	nft_rule_expr_set_u32(ex, NFT_EXPR_REDIR_REG_PROTO_MIN, 0x1234568);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_REDIR_REG_PROTO_MAX, 0x23456);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_REDIR_FLAGS, 0x1234568);
+
+	nft_rule_add_expr(a, ex);
+
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		print_err("Parsing problems");
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
+		print_err("More than 1 expr.");
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
diff --git a/tests/test-script.sh b/tests/test-script.sh
index 93caeb8..b040158 100755
--- a/tests/test-script.sh
+++ b/tests/test-script.sh
@@ -12,6 +12,7 @@
 ./nft-expr_match-test
 ./nft-expr_masq-test
 ./nft-expr_meta-test
+./nft-expr_redir-test
 ./nft-expr_nat-test
 ./nft-expr_payload-test
 ./nft-expr_reject-test
diff --git a/tests/xmlfiles/80-rule-redir.xml b/tests/xmlfiles/80-rule-redir.xml
new file mode 100644
index 0000000..f7dd453
--- /dev/null
+++ b/tests/xmlfiles/80-rule-redir.xml
@@ -0,0 +1 @@
+<nftables><rule><family>ip6</family><table>nat</table><chain>prerouting</chain><handle>4</handle><expr type="redir"></expr></rule></nftables>

