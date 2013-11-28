From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [RFC libnftables PATCH 2/2] tests: add tests for expr meta_target
Date: Thu, 28 Nov 2013 12:24:58 +0100
Message-ID: <20131128112458.8424.96912.stgit@nfdev.cica.es>
References: <20131128112453.8424.78042.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36078 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752306Ab3K1LZB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:25:01 -0500
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 54BFC51EDB9
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Nov 2013 11:25:00 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6nTPuN1IN7MW for <netfilter-devel@vger.kernel.org>;
	Thu, 28 Nov 2013 12:25:00 +0100 (CET)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 2701B51ED76
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Nov 2013 12:25:00 +0100 (CET)
In-Reply-To: <20131128112453.8424.78042.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add unit and JSON/XML parsing tests for the expression meta_target.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/Makefile.am                        |    4 +
 tests/jsonfiles/65-rule-meta-target.json |    1 
 tests/nft-expr_meta_target-test.c        |   97 ++++++++++++++++++++++++++++++
 tests/test-script.sh                     |    1 
 tests/xmlfiles/76-rule-meta_target.xml   |    1 
 5 files changed, 104 insertions(+)
 create mode 100644 tests/jsonfiles/65-rule-meta-target.json
 create mode 100644 tests/nft-expr_meta_target-test.c
 create mode 100644 tests/xmlfiles/76-rule-meta_target.xml

diff --git a/tests/Makefile.am b/tests/Makefile.am
index 362eeac..c76b7a8 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -17,6 +17,7 @@ check_PROGRAMS = 	nft-parsing-test		\
 			nft-expr_log-test		\
 			nft-expr_match-test		\
 			nft-expr_meta-test		\
+			nft-expr_meta_target-test	\
 			nft-expr_nat-test		\
 			nft-expr_payload-test		\
 			nft-expr_reject-test		\
@@ -73,6 +74,9 @@ nft_expr_match_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
 nft_expr_meta_test_SOURCES = nft-expr_meta-test.c
 nft_expr_meta_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
 
+nft_expr_meta_target_test_SOURCES = nft-expr_meta_target-test.c
+nft_expr_meta_target_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+
 nft_expr_nat_test_SOURCES = nft-expr_nat-test.c
 nft_expr_nat_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
 
diff --git a/tests/jsonfiles/65-rule-meta-target.json b/tests/jsonfiles/65-rule-meta-target.json
new file mode 100644
index 0000000..4afcdb4
--- /dev/null
+++ b/tests/jsonfiles/65-rule-meta-target.json
@@ -0,0 +1 @@
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":1,"expr":[{"type":"meta_target","key":"secmark","value":"0xaabbccdd"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/nft-expr_meta_target-test.c b/tests/nft-expr_meta_target-test.c
new file mode 100644
index 0000000..c72ffdc
--- /dev/null
+++ b/tests/nft-expr_meta_target-test.c
@@ -0,0 +1,97 @@
+/*
+ * (C) 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ *
+ * based on previous code by: Ana Rey <anarey@gmail.com>
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
+#include <netinet/ip.h>
+
+#include <linux/netfilter/nf_tables.h>
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
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_META_TARGET_KEY) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_META_TARGET_KEY))
+		print_err("Expr NFT_EXPR_META_TARGET_KEY mismatches");
+
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_META_TARGET_VALUE) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_META_TARGET_VALUE))
+		print_err("Expr NFT_EXPR_META_TARGET_VALUE mismatches");
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
+	ex = nft_rule_expr_alloc("meta_target");
+	if (ex == NULL)
+		print_err("OOM");
+
+	nft_rule_expr_set_u32(ex, NFT_EXPR_META_TARGET_KEY, 0x1234568);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_META_TARGET_VALUE, 0x1234568);
+
+	nft_rule_add_expr(a, ex);
+
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nft_rule_nlmsg_build_payload(nlh, a);
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
index 458f818..057e4ac 100755
--- a/tests/test-script.sh
+++ b/tests/test-script.sh
@@ -11,6 +11,7 @@
 ./nft-expr_lookup-test
 ./nft-expr_match-test
 ./nft-expr_meta-test
+./nft-expr_meta_target-test
 ./nft-expr_nat-test
 ./nft-expr_payload-test
 ./nft-expr_reject-test
diff --git a/tests/xmlfiles/76-rule-meta_target.xml b/tests/xmlfiles/76-rule-meta_target.xml
new file mode 100644
index 0000000..4746ede
--- /dev/null
+++ b/tests/xmlfiles/76-rule-meta_target.xml
@@ -0,0 +1 @@
+<rule><family>ip6</family><table>filter</table><chain>test</chain><handle>129</handle><expr type="meta_target"><key>mark</key><value>0xaabbccdd</value></expr></rule>

