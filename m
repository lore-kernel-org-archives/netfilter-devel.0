From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 2/3] tests: add tests for the masq expression
Date: Thu, 02 Oct 2014 13:58:42 +0200
Message-ID: <20141002115842.10972.64243.stgit@nfdev.cica.es>
References: <20141002115836.10972.3637.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, anayrey@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:59083 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751176AbaJBL6u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Oct 2014 07:58:50 -0400
In-Reply-To: <20141002115836.10972.3637.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The masq expression is lacking of tests. Let's add some.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/Makefile.am                 |    4 ++
 tests/jsonfiles/68-rule-masq.json |    2 +
 tests/nft-expr_masq-test.c        |   89 +++++++++++++++++++++++++++++++++++++
 tests/test-script.sh              |    1 
 tests/xmlfiles/79-rule-masq.xml   |    2 +
 5 files changed, 98 insertions(+)
 create mode 100644 tests/jsonfiles/68-rule-masq.json
 create mode 100644 tests/nft-expr_masq-test.c
 create mode 100644 tests/xmlfiles/79-rule-masq.xml

diff --git a/tests/Makefile.am b/tests/Makefile.am
index 7942bc0..d4f44af 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -20,6 +20,7 @@ check_PROGRAMS = 	nft-parsing-test		\
 			nft-expr_lookup-test		\
 			nft-expr_log-test		\
 			nft-expr_match-test		\
+			nft-expr_masq-test		\
 			nft-expr_meta-test		\
 			nft-expr_nat-test		\
 			nft-expr_payload-test		\
@@ -75,6 +76,9 @@ nft_expr_log_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 nft_expr_match_test_SOURCES = nft-expr_match-test.c
 nft_expr_match_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
+nft_expr_masq_test_SOURCES = nft-expr_masq-test.c
+nft_expr_masq_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
 nft_expr_meta_test_SOURCES = nft-expr_meta-test.c
 nft_expr_meta_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
diff --git a/tests/jsonfiles/68-rule-masq.json b/tests/jsonfiles/68-rule-masq.json
new file mode 100644
index 0000000..cfaed4c
--- /dev/null
+++ b/tests/jsonfiles/68-rule-masq.json
@@ -0,0 +1,2 @@
+{"nftables":[{"rule":{"family":"ip6","table":"nat","chain":"postrouting","handle":4,"expr":[{"type":"masq","flags":12}]}}]}
+
diff --git a/tests/nft-expr_masq-test.c b/tests/nft-expr_masq-test.c
new file mode 100644
index 0000000..58db7f5
--- /dev/null
+++ b/tests/nft-expr_masq-test.c
@@ -0,0 +1,89 @@
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
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_MASQ_FLAGS) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_MASQ_FLAGS))
+		print_err("Expr NFT_EXPR_MASQ_FLAGS mismatches");
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
+	ex = nft_rule_expr_alloc("nat");
+	if (ex == NULL)
+		print_err("OOM");
+
+	nft_rule_expr_set_u32(ex, NFT_EXPR_MASQ_FLAGS, 0x1234568);
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
diff --git a/tests/test-script.sh b/tests/test-script.sh
index 44725d8..93caeb8 100755
--- a/tests/test-script.sh
+++ b/tests/test-script.sh
@@ -10,6 +10,7 @@
 ./nft-expr_log-test
 ./nft-expr_lookup-test
 ./nft-expr_match-test
+./nft-expr_masq-test
 ./nft-expr_meta-test
 ./nft-expr_nat-test
 ./nft-expr_payload-test
diff --git a/tests/xmlfiles/79-rule-masq.xml b/tests/xmlfiles/79-rule-masq.xml
new file mode 100644
index 0000000..b5c5948
--- /dev/null
+++ b/tests/xmlfiles/79-rule-masq.xml
@@ -0,0 +1,2 @@
+<nftables><rule><family>ip6</family><table>nat</table><chain>postrouting</chain><handle>4</handle><expr type="masq"><flags>12</flags></expr></rule></nftables>
+

