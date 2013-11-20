From: Ana Rey <anarey@gmail.com>
Subject: [libnftables PATCH v4] tests: tests for libnftables
Date: Wed, 20 Nov 2013 12:23:12 +0100
Message-ID: <1384946592-6109-1-git-send-email-anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:53661 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3KTL0B (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Nov 2013 06:26:01 -0500
Received: by mail-we0-f174.google.com with SMTP id q58so3223255wes.19
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2013 03:25:59 -0800 (PST)
Received: from localhost.localdomain (143.149.20.95.dynamic.jazztel.es. [95.20.149.143])
        by mx.google.com with ESMTPSA id f15sm30522926wik.6.2013.11.20.03.25.57
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Nov 2013 03:25:58 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Makefile and tests files for libnftables.

In this patch, I create a initial object 'a' and I set a testing values. Then,
I convert this object in a Netlink message.

>From this Netlink message, I parse that (through nft_table_nlmsg_parse
function) in 'b' objetc.

Thus, we make sure that object transformations are correct.

---
v2: fix writing erorres in messages that I unintentionally added in v1 that
were spotted by Phil Oester.

Fix a multiline comment error. The nft-ruleset-test is not included
in this patch, also, I delete it in the tests/test-script.sh. Those errors were
spotted by Arturo Borrero.

v3: I fix some initialization errors, I remove unnecessary comments and I
include a copyright notice. Those errors were spotted by Artulo Borreo.

v4: I fix some initialization errors.
Also, I add a global variable 'test_ok' to check if there are some errors in
the test. This way, I make sure that the test is run at all and all memory is
released properly.


 tests/Makefile.am               |  82 ++++++++++++++++++++++++++-
 tests/nft-chain-test.c          | 106 +++++++++++++++++++++++++++++++++++
 tests/nft-expr_bitwise-test.c   | 115 ++++++++++++++++++++++++++++++++++++++
 tests/nft-expr_byteorder-test.c | 107 ++++++++++++++++++++++++++++++++++++
 tests/nft-expr_cmp-test.c       | 101 ++++++++++++++++++++++++++++++++++
 tests/nft-expr_counter-test.c   |  93 +++++++++++++++++++++++++++++++
 tests/nft-expr_ct-test.c        |  97 ++++++++++++++++++++++++++++++++
 tests/nft-expr_exthdr-test.c    | 101 ++++++++++++++++++++++++++++++++++
 tests/nft-expr_immediate-test.c | 111 +++++++++++++++++++++++++++++++++++++
 tests/nft-expr_limit-test.c     |  96 ++++++++++++++++++++++++++++++++
 tests/nft-expr_log-test.c       | 101 ++++++++++++++++++++++++++++++++++
 tests/nft-expr_lookup-test.c    | 104 +++++++++++++++++++++++++++++++++++
 tests/nft-expr_match-test.c     | 119 ++++++++++++++++++++++++++++++++++++++++
 tests/nft-expr_meta-test.c      |  94 +++++++++++++++++++++++++++++++
 tests/nft-expr_nat-test.c       | 112 +++++++++++++++++++++++++++++++++++++
 tests/nft-expr_payload-test.c   | 103 ++++++++++++++++++++++++++++++++++
 tests/nft-expr_reject-test.c    |  96 ++++++++++++++++++++++++++++++++
 tests/nft-expr_target-test.c    | 118 +++++++++++++++++++++++++++++++++++++++
 tests/nft-rule-test.c           |  86 +++++++++++++++++++++++++++++
 tests/nft-set-test.c            |  88 +++++++++++++++++++++++++++++
 tests/nft-table-test.c          |  74 +++++++++++++++++++++++++
 tests/test-script.sh            |  20 +++++++
 22 files changed, 2123 insertions(+), 1 deletion(-)
 create mode 100644 tests/nft-chain-test.c
 create mode 100644 tests/nft-expr_bitwise-test.c
 create mode 100644 tests/nft-expr_byteorder-test.c
 create mode 100644 tests/nft-expr_cmp-test.c
 create mode 100644 tests/nft-expr_counter-test.c
 create mode 100644 tests/nft-expr_ct-test.c
 create mode 100644 tests/nft-expr_exthdr-test.c
 create mode 100644 tests/nft-expr_immediate-test.c
 create mode 100644 tests/nft-expr_limit-test.c
 create mode 100644 tests/nft-expr_log-test.c
 create mode 100644 tests/nft-expr_lookup-test.c
 create mode 100644 tests/nft-expr_match-test.c
 create mode 100644 tests/nft-expr_meta-test.c
 create mode 100644 tests/nft-expr_nat-test.c
 create mode 100644 tests/nft-expr_payload-test.c
 create mode 100644 tests/nft-expr_reject-test.c
 create mode 100644 tests/nft-expr_target-test.c
 create mode 100644 tests/nft-rule-test.c
 create mode 100644 tests/nft-set-test.c
 create mode 100644 tests/nft-table-test.c
 create mode 100755 tests/test-script.sh

diff --git a/tests/Makefile.am b/tests/Makefile.am
index cfa4e8e..362eeac 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -1,6 +1,86 @@
 include $(top_srcdir)/Make_global.am
 
-check_PROGRAMS = nft-parsing-test
+check_PROGRAMS = 	nft-parsing-test		\
+			nft-table-test			\
+			nft-chain-test			\
+			nft-rule-test			\
+			nft-set-test			\
+			nft-expr_bitwise-test		\
+			nft-expr_byteorder-test		\
+			nft-expr_counter-test		\
+			nft-expr_cmp-test		\
+			nft-expr_ct-test		\
+			nft-expr_exthdr-test		\
+			nft-expr_immediate-test		\
+			nft-expr_limit-test		\
+			nft-expr_lookup-test		\
+			nft-expr_log-test		\
+			nft-expr_match-test		\
+			nft-expr_meta-test		\
+			nft-expr_nat-test		\
+			nft-expr_payload-test		\
+			nft-expr_reject-test		\
+			nft-expr_target-test
 
 nft_parsing_test_SOURCES = nft-parsing-test.c
 nft_parsing_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS} ${LIBJSON_LIBS}
+
+nft_table_test_SOURCES = nft-table-test.c
+nft_table_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_chain_test_SOURCES = nft-chain-test.c
+nft_chain_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_rule_test_SOURCES = nft-rule-test.c
+nft_rule_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_set_test_SOURCES = nft-set-test.c
+nft_set_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_bitwise_test_SOURCES = nft-expr_bitwise-test.c
+nft_expr_bitwise_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_byteorder_test_SOURCES = nft-expr_byteorder-test.c
+nft_expr_byteorder_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_cmp_test_SOURCES = nft-expr_cmp-test.c
+nft_expr_cmp_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_counter_test_SOURCES = nft-expr_counter-test.c
+nft_expr_counter_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_exthdr_test_SOURCES = nft-expr_exthdr-test.c
+nft_expr_exthdr_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_ct_test_SOURCES = nft-expr_ct-test.c
+nft_expr_ct_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_immediate_test_SOURCES = nft-expr_counter-test.c
+nft_expr_immediate_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_limit_test_SOURCES = nft-expr_limit-test.c
+nft_expr_limit_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_lookup_test_SOURCES = nft-expr_limit-test.c
+nft_expr_lookup_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_log_test_SOURCES = nft-expr_log-test.c
+nft_expr_log_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_match_test_SOURCES = nft-expr_match-test.c
+nft_expr_match_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_meta_test_SOURCES = nft-expr_meta-test.c
+nft_expr_meta_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_nat_test_SOURCES = nft-expr_nat-test.c
+nft_expr_nat_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_payload_test_SOURCES = nft-expr_payload-test.c
+nft_expr_payload_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_reject_test_SOURCES = nft-expr_reject-test.c
+nft_expr_reject_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_target_test_SOURCES = nft-expr_target-test.c
+nft_expr_target_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
diff --git a/tests/nft-chain-test.c b/tests/nft-chain-test.c
new file mode 100644
index 0000000..c2775e6
--- /dev/null
+++ b/tests/nft-chain-test.c
@@ -0,0 +1,106 @@
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
+#include <netinet/in.h>
+#include <linux/netfilter/nf_tables.h>
+#include <libnftables/chain.h>
+
+static int test_ok = 1;
+
+static void die(const char *msg)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+}
+
+static void cmp_nft_chain(struct nft_chain *a, struct nft_chain *b)
+{
+
+	if (strcmp(nft_chain_attr_get_str(a, NFT_CHAIN_ATTR_NAME),
+		   nft_chain_attr_get_str(b, NFT_CHAIN_ATTR_NAME)) != 0)
+		die("Chain name mismatches");
+	if (strcmp(nft_chain_attr_get_str(a, NFT_CHAIN_ATTR_TABLE),
+		   nft_chain_attr_get_str(b, NFT_CHAIN_ATTR_TABLE)) != 0)
+		die("Chain table mismatches");
+	if (nft_chain_attr_get_u8(a, NFT_CHAIN_ATTR_FAMILY) !=
+	    nft_chain_attr_get_u8(b, NFT_CHAIN_ATTR_FAMILY))
+		die("Chain family mismatches");
+	if (nft_chain_attr_get_u32(a, NFT_CHAIN_ATTR_POLICY) !=
+	    nft_chain_attr_get_u32(b, NFT_CHAIN_ATTR_POLICY))
+		die("Chain policy mismatches");
+	if (nft_chain_attr_get_u32(a, NFT_CHAIN_ATTR_HOOKNUM) !=
+	    nft_chain_attr_get_u32(b, NFT_CHAIN_ATTR_HOOKNUM))
+		die("Chain hooknum mismatches");
+	if (nft_chain_attr_get_s32(a, NFT_CHAIN_ATTR_PRIO) !=
+	    nft_chain_attr_get_s32(b, NFT_CHAIN_ATTR_PRIO))
+		die("Chain Prio mismatches");
+	if (nft_chain_attr_get_u32(a, NFT_CHAIN_ATTR_USE) !=
+	    nft_chain_attr_get_u32(b, NFT_CHAIN_ATTR_USE))
+		die("Chain use mismatches");
+	if (nft_chain_attr_get_u64(a, NFT_CHAIN_ATTR_PACKETS) !=
+	    nft_chain_attr_get_u64(b, NFT_CHAIN_ATTR_PACKETS))
+		die("Chain packets mismatches");
+	if (nft_chain_attr_get_u64(a, NFT_CHAIN_ATTR_BYTES) !=
+	    nft_chain_attr_get_u64(b, NFT_CHAIN_ATTR_BYTES))
+		die("Chain bytes mismatches");
+	if (nft_chain_attr_get_u64(a, NFT_CHAIN_ATTR_HANDLE) !=
+	    nft_chain_attr_get_u64(b, NFT_CHAIN_ATTR_HANDLE))
+		die("Chain handle mismatches");
+	if (strcmp(nft_chain_attr_get_str(a, NFT_CHAIN_ATTR_TYPE),
+		   nft_chain_attr_get_str(b, NFT_CHAIN_ATTR_TYPE)) != 0)
+		die("Chain type mismatches");
+}
+
+int main(int argc, char *argv[])
+{
+	struct nft_chain *a, *b;
+	char buf[4096];
+	struct nlmsghdr *nlh;
+
+	a = nft_chain_alloc();
+	b = nft_chain_alloc();
+	if (a == NULL || b == NULL)
+		die("OOM");
+
+	nft_chain_attr_set_str(a, NFT_CHAIN_ATTR_NAME, "test");
+	nft_chain_attr_set_u8(a, NFT_CHAIN_ATTR_FAMILY, AF_INET);
+	nft_chain_attr_set_str(a, NFT_CHAIN_ATTR_TABLE, "Table");
+	nft_chain_attr_set_u32(a, NFT_CHAIN_ATTR_POLICY,0x12345678);
+	nft_chain_attr_set_u32(a, NFT_CHAIN_ATTR_HOOKNUM, 0x12345678);
+	nft_chain_attr_set_s32(a, NFT_CHAIN_ATTR_PRIO, 0x12345678);
+	nft_chain_attr_set_u32(a, NFT_CHAIN_ATTR_USE, 0x12345678 );
+	nft_chain_attr_set_u64(a, NFT_CHAIN_ATTR_PACKETS, 0x1234567812345678);
+	nft_chain_attr_set_u64(a, NFT_CHAIN_ATTR_BYTES, 0x1234567812345678);
+	nft_chain_attr_set_u64(a, NFT_CHAIN_ATTR_HANDLE, 0x1234567812345678);
+	nft_chain_attr_set_str(a, NFT_CHAIN_ATTR_TYPE, "Prueba");
+
+	/* cmd extracted from include/linux/netfilter/nf_tables.h */
+	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, AF_INET,
+					0, 1234);
+	nft_chain_nlmsg_build_payload(nlh, a);
+
+	if (nft_chain_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	cmp_nft_chain(a, b);
+
+	nft_chain_free(a);
+	nft_chain_free(b);
+
+	if (!test_ok)
+		exit(EXIT_FAILURE);
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+
+}
diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-test.c
new file mode 100644
index 0000000..c1b9378
--- /dev/null
+++ b/tests/nft-expr_bitwise-test.c
@@ -0,0 +1,115 @@
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
+#include <netinet/in.h>
+#include <netinet/ip.h>
+#include <linux/netfilter/nf_tables.h>
+#include <libmnl/libmnl.h>
+#include <libnftables/rule.h>
+#include <libnftables/expr.h>
+
+static int test_ok = 1;
+
+static void die(const char *msg)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	uint32_t maska, maskb;
+	uint32_t xora, xorb;
+
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_BITWISE_DREG) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_BITWISE_DREG))
+		die("Expr BITWISE_DREG mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_BITWISE_SREG) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_BITWISE_SREG))
+		die("Expr BITWISE_SREG mismatches");
+	if (nft_rule_expr_get_u16(rule_a, NFT_EXPR_BITWISE_LEN) !=
+	    nft_rule_expr_get_u16(rule_b, NFT_EXPR_BITWISE_LEN))
+		die("Expr BITWISE_DREG mismatches");
+	nft_rule_expr_get(rule_a, NFT_EXPR_BITWISE_MASK, &maska);
+	nft_rule_expr_get(rule_b, NFT_EXPR_BITWISE_MASK, &maskb);
+	if (maska != maskb)
+		die("Size of BITWISE_MASK mismatches");
+	nft_rule_expr_get(rule_a, NFT_EXPR_BITWISE_XOR, &xora);
+	nft_rule_expr_get(rule_b, NFT_EXPR_BITWISE_XOR, &xorb);
+	if (xora != xorb)
+		die("Size of BITWISE_XOR mismatches");
+
+}
+int main(int argc, char *argv[])
+{
+	struct nft_rule *a, *b = NULL;
+	struct nft_rule_expr *ex = NULL;
+	struct nlmsghdr *nlh;
+	char buf[4096];
+	struct nft_rule_expr_iter *iter_a, *iter_b = NULL;
+	struct nft_rule_expr *rule_a, *rule_b = NULL;
+	uint32_t mask = 0x01010101;
+	uint32_t xor = 0x12345678;
+
+	a = nft_rule_alloc();
+	b = nft_rule_alloc();
+	if (a == NULL || b == NULL)
+		die("OOM");
+	ex = nft_rule_expr_alloc("bitwise");
+	if (ex == NULL)
+		die("OOM");
+
+	nft_rule_expr_set_u32(ex, NFT_EXPR_BITWISE_SREG, 0x12345678);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_BITWISE_DREG, 0x12345678);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_BITWISE_LEN, 0x12345678);
+	nft_rule_expr_set(ex, NFT_EXPR_BITWISE_MASK, &mask, sizeof(mask));
+	nft_rule_expr_set(ex, NFT_EXPR_BITWISE_XOR, &xor, sizeof(xor));
+
+	nft_rule_add_expr(a, ex);
+
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a = nft_rule_expr_iter_create(a);
+	iter_b = nft_rule_expr_iter_create(b);
+	if (iter_a == NULL || iter_b == NULL)
+		die("OOM");
+
+	rule_a = nft_rule_expr_iter_next(iter_a);
+	rule_b = nft_rule_expr_iter_next(iter_b);
+	if (rule_a == NULL || rule_b == NULL)
+		die("OOM");
+
+	if (nft_rule_expr_iter_next(iter_a) != NULL ||
+	    nft_rule_expr_iter_next(iter_b) != NULL)
+		die("More 1 expr.");
+
+	nft_rule_expr_iter_destroy(iter_a);
+	nft_rule_expr_iter_destroy(iter_b);
+
+	cmp_nft_rule_expr(rule_a,rule_b);
+
+	nft_rule_free(a);
+	nft_rule_free(b);
+
+	if (!test_ok)
+		exit(EXIT_FAILURE);
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/nft-expr_byteorder-test.c b/tests/nft-expr_byteorder-test.c
new file mode 100644
index 0000000..db6a703
--- /dev/null
+++ b/tests/nft-expr_byteorder-test.c
@@ -0,0 +1,107 @@
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
+#include <netinet/in.h>
+#include <netinet/ip.h>
+#include <linux/netfilter/nf_tables.h>
+#include <libmnl/libmnl.h>
+#include <libnftables/rule.h>
+#include <libnftables/expr.h>
+
+static int test_ok = 1;
+
+static void die(const char *msg)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_BYTEORDER_DREG) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_BYTEORDER_DREG))
+		die("Expr NFT_EXPR_BYTEORDER_DREG mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_BYTEORDER_SREG) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_BYTEORDER_SREG))
+		die("Expr NFT_EXPR_BYTEORDER_SREG mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_BYTEORDER_OP) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_BYTEORDER_OP))
+		die("Expr NFT_EXPR_BYTEORDER_OP mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_BYTEORDER_LEN) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_BYTEORDER_LEN))
+		die("Expr NFT_EXPR_BYTEORDER_DREG mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_BYTEORDER_SIZE) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_BYTEORDER_SIZE))
+		die("Expr NFT_EXPR_BITWISE_SIZE mismatches");
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
+		die("OOM");
+	ex = nft_rule_expr_alloc("byteorder");
+	if (ex == NULL)
+		die("OOM");
+
+	nft_rule_expr_set_u32(ex, NFT_EXPR_BYTEORDER_SREG, 0x12345678);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_BYTEORDER_DREG, 0x12345678);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_BYTEORDER_OP, 0x12345678);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_BYTEORDER_LEN, 0x12345678);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_BYTEORDER_SIZE, 0x12345678);
+
+	nft_rule_add_expr(a, ex);
+
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a = nft_rule_expr_iter_create(a);
+	iter_b = nft_rule_expr_iter_create(b);
+	if (iter_a == NULL || iter_b == NULL)
+		die("OOM");
+
+	rule_a = nft_rule_expr_iter_next(iter_a);
+	rule_b = nft_rule_expr_iter_next(iter_b);
+	if (rule_a == NULL || rule_b == NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a,rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) != NULL ||
+	    nft_rule_expr_iter_next(iter_b) != NULL)
+		die("More 1 expr.");
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
diff --git a/tests/nft-expr_cmp-test.c b/tests/nft-expr_cmp-test.c
new file mode 100644
index 0000000..ca65a6a
--- /dev/null
+++ b/tests/nft-expr_cmp-test.c
@@ -0,0 +1,101 @@
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
+#include <netinet/in.h>
+#include <netinet/ip.h>
+#include <linux/netfilter/nf_tables.h>
+#include <libmnl/libmnl.h>
+#include <libnftables/rule.h>
+#include <libnftables/expr.h>
+
+static int test_ok = 1;
+
+static void die(const char *msg)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	uint32_t data_lena, data_lenb;
+
+	nft_rule_expr_get(rule_a, NFT_EXPR_CMP_DATA, &data_lena);
+	nft_rule_expr_get(rule_b, NFT_EXPR_CMP_DATA, &data_lenb);
+	if (data_lena != data_lenb)
+		die("Size of NFT_EXPR_CMP_DATA mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_CMP_SREG) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_CMP_SREG))
+		die("Expr NFT_EXPR_CMP_SREG mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_CMP_OP) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_CMP_OP))
+		die("Expr NFT_EXPR_CMP_OP mismatches");
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
+	uint32_t data_len = 0x01010101;
+	a = nft_rule_alloc();
+	b = nft_rule_alloc();
+	if (a == NULL || b == NULL)
+		die("OOM");
+	ex = nft_rule_expr_alloc("cmp");
+	if (ex == NULL)
+		die("OOM");
+
+	nft_rule_expr_set(ex, NFT_EXPR_CMP_DATA, &data_len, sizeof(data_len));
+	nft_rule_expr_set_u32(ex, NFT_EXPR_CMP_SREG, 0x12345678);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_CMP_OP, 0x12345678);
+
+	nft_rule_add_expr(a, ex);
+
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a = nft_rule_expr_iter_create(a);
+	iter_b = nft_rule_expr_iter_create(b);
+	if (iter_a == NULL || iter_b == NULL)
+		die("OOM");
+	rule_a = nft_rule_expr_iter_next(iter_a);
+	rule_b = nft_rule_expr_iter_next(iter_b);
+	if (rule_a == NULL || rule_b == NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) != NULL ||
+	    nft_rule_expr_iter_next(iter_b) != NULL)
+		die("More 1 expr.");
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
diff --git a/tests/nft-expr_counter-test.c b/tests/nft-expr_counter-test.c
new file mode 100644
index 0000000..9061e19
--- /dev/null
+++ b/tests/nft-expr_counter-test.c
@@ -0,0 +1,93 @@
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
+#include <netinet/in.h>
+#include <netinet/ip.h>
+#include <linux/netfilter/nf_tables.h>
+#include <libmnl/libmnl.h>
+#include <libnftables/rule.h>
+#include <libnftables/expr.h>
+
+static int test_ok = 1;
+
+static void die(const char *msg)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	if (nft_rule_expr_get_u64(rule_a, NFT_EXPR_CTR_BYTES) !=
+	    nft_rule_expr_get_u64(rule_b, NFT_EXPR_CTR_BYTES))
+		die("Expr NFT_EXPR_CTR_BYTES mismatches");
+	if (nft_rule_expr_get_u64(rule_a, NFT_EXPR_CTR_PACKETS) !=
+	    nft_rule_expr_get_u64(rule_b, NFT_EXPR_CTR_PACKETS))
+		die("Expr NFT_EXPR_CTR_PACKETS mismatches");
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
+		die("OOM");
+
+	ex = nft_rule_expr_alloc("counter");
+	if (ex == NULL)
+		die("OOM");
+
+	nft_rule_expr_set_u64(ex, NFT_EXPR_CTR_BYTES, 0x123456789abcdef0);
+	nft_rule_expr_set_u64(ex, NFT_EXPR_CTR_PACKETS, 0x123456789abcdef0);
+	nft_rule_add_expr(a, ex);
+
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a = nft_rule_expr_iter_create(a);
+	iter_b = nft_rule_expr_iter_create(b);
+	if (iter_a == NULL || iter_b == NULL)
+		die("OOM");
+	rule_a = nft_rule_expr_iter_next(iter_a);
+	rule_b = nft_rule_expr_iter_next(iter_b);
+	if (rule_a == NULL || rule_b == NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) != NULL ||
+	    nft_rule_expr_iter_next(iter_b) != NULL)
+		die("More 1 expr.");
+
+	nft_rule_expr_iter_destroy(iter_a);
+	nft_rule_expr_iter_destroy(iter_b);
+	nft_rule_free(a);
+	nft_rule_free(b);
+
+	if (!test_ok)
+		exit(EXIT_FAILURE);
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/nft-expr_ct-test.c b/tests/nft-expr_ct-test.c
new file mode 100644
index 0000000..15127e7
--- /dev/null
+++ b/tests/nft-expr_ct-test.c
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
+#include <netinet/in.h>
+#include <netinet/ip.h>
+
+#include <linux/netfilter/nf_tables.h>
+#include <libmnl/libmnl.h>
+#include <libnftables/rule.h>
+#include <libnftables/expr.h>
+
+static int test_ok = 1;
+static void die(const char *msg)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_CT_KEY) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_CT_KEY))
+		die("Expr CT_KEY mismatches");
+	if (nft_rule_expr_get_u8(rule_a, NFT_EXPR_CT_DIR) !=
+	    nft_rule_expr_get_u8(rule_b, NFT_EXPR_CT_DIR))
+		die("Expr CT_DIR mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_CT_DREG) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_CT_DREG))
+		die("Expr CT_DREG mismatches");
+}
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
+		die("OOM");
+	ex = nft_rule_expr_alloc("ct");
+	if (ex == NULL)
+		die("OOM");
+
+	nft_rule_expr_set_u32(ex, NFT_EXPR_CT_KEY, 0x1234568);
+	nft_rule_expr_set_u8(ex, NFT_EXPR_CT_DIR, 0x12);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_CT_DREG, 0x12345678);
+
+	nft_rule_add_expr(a, ex);
+
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a = nft_rule_expr_iter_create(a);
+	iter_b = nft_rule_expr_iter_create(b);
+	if (iter_a == NULL || iter_b == NULL)
+		die("OOM");
+
+	rule_a = nft_rule_expr_iter_next(iter_a);
+	rule_b = nft_rule_expr_iter_next(iter_b);
+	if (rule_a == NULL || rule_b == NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) != NULL ||
+	    nft_rule_expr_iter_next(iter_b) != NULL)
+		die("More 1 expr.");
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
diff --git a/tests/nft-expr_exthdr-test.c b/tests/nft-expr_exthdr-test.c
new file mode 100644
index 0000000..b8676fa
--- /dev/null
+++ b/tests/nft-expr_exthdr-test.c
@@ -0,0 +1,101 @@
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
+#include <netinet/in.h>
+#include <netinet/ip.h>
+#include <linux/netfilter/nf_tables.h>
+#include <libmnl/libmnl.h>
+#include <libnftables/rule.h>
+#include <libnftables/expr.h>
+
+static int test_ok = 1;
+
+static void die(const char *msg)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_EXTHDR_DREG) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_EXTHDR_DREG))
+		die("Expr NFT_EXPR_EXTHDR_DREG mismatches");
+	if (nft_rule_expr_get_u8(rule_a, NFT_EXPR_EXTHDR_TYPE) !=
+	    nft_rule_expr_get_u8(rule_b, NFT_EXPR_EXTHDR_TYPE))
+		die("Expr NFT_EXPR_EXTHDR_TYPE mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_EXTHDR_OFFSET) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_EXTHDR_OFFSET))
+		die("Expr NFT_EXPR_EXTHDR_OFFSET mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_EXTHDR_LEN) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_EXTHDR_LEN))
+		die("Expr NFT_EXPR_EXTHDR_LEN mismatches");
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
+		die("OOM");
+	ex = nft_rule_expr_alloc("exthdr");
+	if (ex == NULL)
+		die("OOM");
+
+	nft_rule_expr_set_u32(ex, NFT_EXPR_EXTHDR_DREG, 0x12345678);
+	nft_rule_expr_set_u8(ex, NFT_EXPR_EXTHDR_TYPE, 0x12);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_EXTHDR_OFFSET, 0x12345678);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_EXTHDR_LEN, 0x12345678);
+
+	nft_rule_add_expr(a, ex);
+
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nft_rule_nlmsg_build_payload(nlh, a);
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a = nft_rule_expr_iter_create(a);
+	iter_b = nft_rule_expr_iter_create(b);
+	if (iter_a == NULL || iter_b == NULL)
+		die("OOM");
+
+	rule_a = nft_rule_expr_iter_next(iter_a);
+	rule_b = nft_rule_expr_iter_next(iter_b);
+	if (rule_a == NULL || rule_b == NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) != NULL ||
+	    nft_rule_expr_iter_next(iter_b) != NULL)
+		die("More 1 expr.");
+
+	nft_rule_expr_iter_destroy(iter_a);
+	nft_rule_expr_iter_destroy(iter_b);
+	nft_rule_free(a);
+	nft_rule_free(b);
+	if (!test_ok)
+		exit(EXIT_FAILURE);
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/nft-expr_immediate-test.c b/tests/nft-expr_immediate-test.c
new file mode 100644
index 0000000..a937a37
--- /dev/null
+++ b/tests/nft-expr_immediate-test.c
@@ -0,0 +1,111 @@
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
+static void die(const char *msg)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	uint32_t data_a, data_b, chain_a, chain_b;
+/*	data_a, data_b, chain_a, chain_b = 0x12345678;*/
+
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_IMM_DREG) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_IMM_DREG))
+		die("Expr NFT_EXPR_IMM_DREG mismatches");
+	nft_rule_expr_get(rule_a, NFT_EXPR_IMM_DATA, data_a);
+	nft_rule_expr_get(rule_b, NFT_EXPR_IMM_DATA, data_b)
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_IMM_VERDICT) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_IMM_VERDICT))
+		die("Expr NFT_EXPR_IMM_VERDICT mismatches");
+	nft_rule_expr_get(rule_a, NFT_EXPR_IMM_CHAIN, chain_a);
+	nft_rule_expr_get(rule_b, NFT_EXPR_IMM_CHAIN, chain_b);
+	if (data_a != data_b)
+		die("Expr NFT_EXPR_IMM_DATA. Size mismatches");
+	if (chain_a != chain_b)
+		die("Expr NFT_EXPR_IMM_CHAIN. Size mismatches");
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
+		die("OOM");
+	ex = nft_rule_expr_alloc("immediate");
+	if (ex == NULL)
+		die("OOM");
+
+	uint32_t chain_t = 0x12345678;
+	uint32_t data_t = 0x12345678;
+
+	nft_rule_expr_set_u32(ex, NFT_EXPR_IMM_DREG, 0x1234568);
+	nft_rule_expr_set(ex, NFT_EXPR_IMM_DATA, &chain_t, sizeof(chain_t));
+	nft_rule_expr_set_u32(ex, NFT_EXPR_IMM_VERDICT, 0x12345678);
+	nft_rule_expr_set(ex, NFT_EXPR_IMM_CHAIN, &data_t, sizeof(data_t));
+
+	nft_rule_add_expr(a, ex);
+
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a = nft_rule_expr_iter_create(a);
+	iter_b = nft_rule_expr_iter_create(b);
+	if (iter_a == NULL || iter_b == NULL)
+		die("OOM");
+
+	rule_a = nft_rule_expr_iter_next(iter_a);
+	rule_b = nft_rule_expr_iter_next(iter_b);
+	if (rule_a == NULL || rule_b == NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) != NULL ||
+	    nft_rule_expr_iter_next(iter_b) != NULL)
+		die("More 1 expr.");
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
diff --git a/tests/nft-expr_limit-test.c b/tests/nft-expr_limit-test.c
new file mode 100644
index 0000000..71570b6
--- /dev/null
+++ b/tests/nft-expr_limit-test.c
@@ -0,0 +1,96 @@
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
+#include <netinet/in.h>
+#include <netinet/ip.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include <libmnl/libmnl.h>
+#include <libnftables/rule.h>
+#include <libnftables/expr.h>
+
+static int test_ok = 1;
+
+static void die(const char *msg)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	if (nft_rule_expr_get_u64(rule_a, NFT_EXPR_LIMIT_RATE) !=
+	    nft_rule_expr_get_u64(rule_b, NFT_EXPR_LIMIT_RATE))
+		die("Expr CTR_BYTES mismatches");
+	if (nft_rule_expr_get_u64(rule_a, NFT_EXPR_LIMIT_UNIT) !=
+	    nft_rule_expr_get_u64(rule_b, NFT_EXPR_LIMIT_UNIT))
+		die("Expr CTR_PACKET mismatches");
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
+		die("OOM");
+	ex = nft_rule_expr_alloc("limit");
+	if (ex == NULL)
+		die("OOM");
+
+	nft_rule_expr_set_u64(ex, NFT_EXPR_LIMIT_RATE, 0x123456789abcdef0);
+	nft_rule_expr_set_u64(ex, NFT_EXPR_LIMIT_UNIT, 0x123456789abcdef0);
+
+	nft_rule_add_expr(a, ex);
+
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a = nft_rule_expr_iter_create(a);
+	iter_b = nft_rule_expr_iter_create(b);
+	if (iter_a == NULL || iter_b == NULL)
+		die("OOM");
+
+	rule_a = nft_rule_expr_iter_next(iter_a);
+	rule_b = nft_rule_expr_iter_next(iter_b);
+	if (rule_a == NULL || rule_b == NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) != NULL ||
+	    nft_rule_expr_iter_next(iter_b) != NULL)
+		die("More 1 expr.");
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
diff --git a/tests/nft-expr_log-test.c b/tests/nft-expr_log-test.c
new file mode 100644
index 0000000..dcfc0bc
--- /dev/null
+++ b/tests/nft-expr_log-test.c
@@ -0,0 +1,101 @@
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
+static void die(const char *msg)
+{
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+	test_ok = 0;
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_LOG_SNAPLEN) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_LOG_SNAPLEN))
+		die("Expr NFT_EXPR_LOG_SNAPLEN mismatches");
+	if (nft_rule_expr_get_u16(rule_a, NFT_EXPR_LOG_GROUP) !=
+	    nft_rule_expr_get_u16(rule_b, NFT_EXPR_LOG_GROUP))
+		die("Expr NFT_EXPR_LOG_GROUP mismatches");
+	if (nft_rule_expr_get_u16(rule_a, NFT_EXPR_LOG_QTHRESHOLD) !=
+	    nft_rule_expr_get_u16(rule_b, NFT_EXPR_LOG_QTHRESHOLD))
+		die("Expr NFT_EXPR_LOG_QTHRESHOLD mismatches");
+	if(strcmp(nft_rule_expr_get_str(rule_a, NFT_EXPR_LOG_PREFIX),
+		  nft_rule_expr_get_str(rule_b, NFT_EXPR_LOG_PREFIX)) != 0)
+		die("Expr NFT_EXPR_LOG_PREFIX mismatches");
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
+		die("OOM");
+	ex = nft_rule_expr_alloc("log");
+	if (ex == NULL)
+		die("OOM");
+
+	nft_rule_expr_set_u32(ex, NFT_EXPR_LOG_SNAPLEN, 0x12345678);
+	nft_rule_expr_set_u16(ex, NFT_EXPR_LOG_GROUP, 0x1234);
+	nft_rule_expr_set_u16(ex, NFT_EXPR_LOG_QTHRESHOLD, 0x1234);
+	nft_rule_expr_set_str(ex, NFT_EXPR_LOG_PREFIX, "test");
+
+	nft_rule_add_expr(a, ex);
+
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nft_rule_nlmsg_build_payload(nlh, a);
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a = nft_rule_expr_iter_create(a);
+	iter_b = nft_rule_expr_iter_create(b);
+	if (iter_a == NULL || iter_b == NULL)
+		die("OOM");
+	rule_a = nft_rule_expr_iter_next(iter_a);
+	rule_b = nft_rule_expr_iter_next(iter_b);
+	if (rule_a == NULL || rule_b == NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) != NULL ||
+	    nft_rule_expr_iter_next(iter_b) != NULL)
+		die("More 1 expr.");
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
diff --git a/tests/nft-expr_lookup-test.c b/tests/nft-expr_lookup-test.c
new file mode 100644
index 0000000..9dc86c6
--- /dev/null
+++ b/tests/nft-expr_lookup-test.c
@@ -0,0 +1,104 @@
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
+#include <netinet/in.h>
+#include <netinet/ip.h>
+#include <linux/netfilter/nf_tables.h>
+#include <libmnl/libmnl.h>
+#include <libnftables/rule.h>
+#include <libnftables/expr.h>
+
+static int test_ok = 1;
+
+static void die(const char *msg)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	uint32_t data_lena, data_lenb;
+
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_LOOKUP_SREG) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_LOOPUP_SREG))
+		die("Expr NFT_EXPR_LOOkUP_SREG mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_LOOKUP_DREG) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_LOOPUP_DREG))
+		die("Expr NFT_EXPR_LOOkUP_DREG mismatches");
+	nft_rule_expr_get(rule_a, NFT_EXPR_LOOKUP_SET, &data_lena);
+	nft_rule_expr_get(rule_b, NFT_EXPR_LOOKUP_SET, &data_lenb);
+	if (data_lena != data_lenb)
+		die("Expr NFT_EXPR_LOOKUP_SET size mismatches");
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
+	uint32_t lookup_set = 0x12345678;
+
+	a = nft_rule_alloc();
+	b = nft_rule_alloc();
+	if (a == NULL || b == NULL)
+		die("OOM");
+	ex = nft_rule_expr_alloc("lookup");
+	if (ex == NULL)
+		die("OOM");
+
+	nft_rule_expr_set_u32(ex, NFT_EXPR_LOOKUP_SREG, 0x12345678);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_LOOKUP_DREG, 0x12345678);
+	nft_rule_expr_set(ex, NFT_EXPR_LOOKUP_SET, &lookup_set,
+			  sizeof(lookup_set));
+
+	nft_rule_add_expr(a, ex);
+
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a = nft_rule_expr_iter_create(a);
+	iter_b = nft_rule_expr_iter_create(b);
+	if (iter_a == NULL || iter_b == NULL)
+		die("OOM");
+	rule_a = nft_rule_expr_iter_next(iter_a);
+	rule_b = nft_rule_expr_iter_next(iter_b);
+	if (rule_a == NULL || rule_b == NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) != NULL ||
+	    nft_rule_expr_iter_next(iter_b) != NULL)
+		die("More 1 expr.");
+
+	nft_rule_expr_iter_destroy(iter_a);
+	nft_rule_expr_iter_destroy(iter_b);
+	nft_rule_free(a);
+	nft_rule_free(b);
+
+	if (!test_ok)
+		exit(EXIT_FAILURE);
+
+	print(_"%s: \033[32mOK\e[0m\n", argv[0]);
+
+	return EXIT_SUCCESS;
+}
diff --git a/tests/nft-expr_match-test.c b/tests/nft-expr_match-test.c
new file mode 100644
index 0000000..4fd34c4
--- /dev/null
+++ b/tests/nft-expr_match-test.c
@@ -0,0 +1,119 @@
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
+#include <arpa/inet.h>
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
+static void die(const char *msg)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+}
+
+static void die2(const char *msg, uint32_t a, uint32_t b)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s size a: %d b: %d \n", msg, a, b);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	uint32_t lena, lenb;
+	if (strcmp(nft_rule_expr_get_str(rule_a, NFT_EXPR_MT_NAME),
+		   nft_rule_expr_get_str(rule_b, NFT_EXPR_MT_NAME)) != 0)
+		die("Expr NFT_EXPR_MT_NAME mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_MT_REV) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_MT_REV))
+		die("Expr NFT_EXPR_MT_REV mismatches");
+	nft_rule_expr_get(rule_a, NFT_EXPR_MT_INFO, &lena);
+	nft_rule_expr_get(rule_b, NFT_EXPR_MT_INFO, &lenb);
+	if (lena != lenb)
+		die2("Expr NFT_EXPR_MT_INFO size mismatches", lena, lenb);
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
+		die("OOM");
+	ex = nft_rule_expr_alloc("match");
+	if (ex == NULL)
+		die("OOM");
+
+	struct xt_iprange_mtinfo *info;
+
+	nft_rule_expr_set_str(ex, NFT_EXPR_MT_NAME, "Tests");
+	nft_rule_expr_set_u32(ex, NFT_EXPR_MT_REV, 0x12345678);
+
+        info = calloc(1, sizeof(struct xt_iprange_mtinfo));
+        if (info == NULL)
+                die("OOM");
+
+        info->src_min.ip = info->dst_min.ip = inet_addr("127.0.0.1");
+        info->src_max.ip = info->dst_max.ip = inet_addr("127.0.0.1");
+        info->flags = IPRANGE_SRC;
+
+        nft_rule_expr_set(ex, NFT_EXPR_MT_INFO, info, sizeof(info));
+
+	nft_rule_add_expr(a, ex);
+
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+	iter_a = nft_rule_expr_iter_create(a);
+	iter_b = nft_rule_expr_iter_create(b);
+	if (iter_a == NULL || iter_b == NULL)
+		die("OOM");
+
+	rule_a = nft_rule_expr_iter_next(iter_a);
+	rule_b = nft_rule_expr_iter_next(iter_b);
+	if (rule_a == NULL || rule_b == NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) != NULL ||
+	    nft_rule_expr_iter_next(iter_b) != NULL)
+		die("More 1 expr.");
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
diff --git a/tests/nft-expr_meta-test.c b/tests/nft-expr_meta-test.c
new file mode 100644
index 0000000..b3d7c66
--- /dev/null
+++ b/tests/nft-expr_meta-test.c
@@ -0,0 +1,94 @@
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
+static void die(const char *msg)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_META_KEY) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_META_KEY))
+		die("Expr NFT_EXPR_META_KEY mismatches");
+	if (nft_rule_expr_get_u8(rule_a, NFT_EXPR_META_DREG) !=
+	    nft_rule_expr_get_u8(rule_b, NFT_EXPR_META_DREG))
+		die("Expr NFT_EXPR_META_DREG mismatches");
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
+		die("OOM");
+	ex = nft_rule_expr_alloc("meta");
+	if (ex == NULL)
+		die("OOM");
+
+	nft_rule_expr_set_u32(ex, NFT_EXPR_META_KEY, 0x1234568);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_META_DREG, 0x12345678);
+
+	nft_rule_add_expr(a, ex);
+
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nft_rule_nlmsg_build_payload(nlh, a);
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a = nft_rule_expr_iter_create(a);
+	iter_b = nft_rule_expr_iter_create(b);
+	if (iter_a == NULL || iter_b == NULL)
+		die("OOM");
+
+	rule_a = nft_rule_expr_iter_next(iter_a);
+	rule_b = nft_rule_expr_iter_next(iter_b);
+	if (rule_a == NULL || rule_b == NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) != NULL ||
+	    nft_rule_expr_iter_next(iter_b) != NULL)
+		die("More 1 expr.");
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
diff --git a/tests/nft-expr_nat-test.c b/tests/nft-expr_nat-test.c
new file mode 100644
index 0000000..9cd87d9
--- /dev/null
+++ b/tests/nft-expr_nat-test.c
@@ -0,0 +1,112 @@
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
+static void die(const char *msg)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_NAT_TYPE) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_NAT_TYPE))
+		die("Expr NFT_EXPR_NAT_TYPE mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_NAT_FAMILY) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_NAT_FAMILY))
+		die("Expr NFT_EXPR_NAT_FAMILY mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_NAT_REG_ADDR_MIN) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_NAT_REG_ADDR_MIN))
+		die("Expr NFT_EXPR_NAT_REG_ADDR_MIN mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_NAT_REG_ADDR_MAX) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_NAT_REG_ADDR_MAX))
+		die("Expr NFT_EXPR_NAT_REG_ADDR_MAX mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_NAT_REG_PROTO_MIN) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_NAT_REG_PROTO_MIN))
+		die("Expr NFT_EXPR_NAT_REG_PROTO_MIN mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_NAT_REG_PROTO_MAX) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_NAT_REG_PROTO_MAX))
+		die("Expr NFT_EXPR_NAT_REG_PROTO_MAX mismatches");
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
+		die("OOM");
+	ex = nft_rule_expr_alloc("nat");
+	if (ex == NULL)
+		die("OOM");
+
+	nft_rule_expr_set_u32(ex, NFT_EXPR_NAT_TYPE, 0x1234568);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_NAT_FAMILY, 0x1234568);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_NAT_REG_ADDR_MIN, 0x1234568);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_NAT_REG_ADDR_MAX, 0x1234568);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_NAT_REG_PROTO_MIN, 0x1234568);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_NAT_REG_PROTO_MAX, 0x1234568);
+
+	nft_rule_add_expr(a, ex);
+
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a = nft_rule_expr_iter_create(a);
+	iter_b = nft_rule_expr_iter_create(b);
+	if (iter_a == NULL || iter_b == NULL)
+		die("OOM");
+
+	rule_a = nft_rule_expr_iter_next(iter_a);
+	rule_b = nft_rule_expr_iter_next(iter_b);
+	if (rule_a == NULL || rule_b == NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) != NULL ||
+	    nft_rule_expr_iter_next(iter_b) != NULL)
+		die("More 1 expr.");
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
diff --git a/tests/nft-expr_payload-test.c b/tests/nft-expr_payload-test.c
new file mode 100644
index 0000000..2a6c64d
--- /dev/null
+++ b/tests/nft-expr_payload-test.c
@@ -0,0 +1,103 @@
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
+#include <netinet/in.h>
+#include <netinet/ip.h>
+
+#include <linux/netfilter/nf_tables.h>
+#include <linux/netfilter/xt_iprange.h>
+#include <libmnl/libmnl.h>
+#include <libnftables/rule.h>
+#include <libnftables/expr.h>
+
+static int test_ok = 1;
+
+static void die(const char *msg)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_PAYLOAD_DREG) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_PAYLOAD_DREG))
+		die("Expr NFT_EXPR_PAYLOAD_DREG mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_PAYLOAD_BASE) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_PAYLOAD_BASE))
+		die("Expr NFT_EXPR_PAYLOAD_BASE mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_PAYLOAD_OFFSET) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_PAYLOAD_OFFSET))
+		die("Expr NFT_EXPR_PAYLOAD_OFFSET mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_PAYLOAD_LEN) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_PAYLOAD_LEN))
+		die("Expr NFT_EXPR_PAYLOAD_LEN mismatches");
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
+		die("OOM");
+	ex = nft_rule_expr_alloc("payload");
+	if (ex == NULL)
+		die("OOM");
+
+	nft_rule_expr_set_u32(ex, NFT_EXPR_PAYLOAD_DREG, 0x1234568);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_PAYLOAD_BASE, 0x12345678);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_PAYLOAD_OFFSET, 0x12345678);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_PAYLOAD_LEN, 0x12345678);
+
+	nft_rule_add_expr(a, ex);
+
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nft_rule_nlmsg_build_payload(nlh, a);
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a = nft_rule_expr_iter_create(a);
+	iter_b = nft_rule_expr_iter_create(b);
+	if (iter_a == NULL || iter_b == NULL)
+		die("OOM");
+
+	rule_a = nft_rule_expr_iter_next(iter_a);
+	rule_b = nft_rule_expr_iter_next(iter_b);
+	if (rule_a == NULL || rule_b == NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) != NULL ||
+	    nft_rule_expr_iter_next(iter_b) != NULL)
+		die("More 1 expr.");
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
diff --git a/tests/nft-expr_reject-test.c b/tests/nft-expr_reject-test.c
new file mode 100644
index 0000000..ae9dfd0
--- /dev/null
+++ b/tests/nft-expr_reject-test.c
@@ -0,0 +1,96 @@
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
+static void die(const char *msg)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_REJECT_TYPE) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_REJECT_TYPE))
+		die("Expr NFT_EXPR_REJECT_TYPE mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_REJECT_CODE) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_REJECT_CODE))
+		die("Expr NFT_EXPR_REJECT_CODE mismatches");
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
+		die("OOM");
+	ex = nft_rule_expr_alloc("reject");
+	if (ex == NULL)
+		die("OOM");
+
+	nft_rule_expr_set_u32(ex, NFT_EXPR_REJECT_TYPE, 0x1234568);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_REJECT_CODE, 0x1234568);
+
+	nft_rule_add_expr(a, ex);
+
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a = nft_rule_expr_iter_create(a);
+	iter_b = nft_rule_expr_iter_create(b);
+	if (iter_a == NULL || iter_b == NULL)
+		die("OOM");
+
+	rule_a = nft_rule_expr_iter_next(iter_a);
+	rule_b = nft_rule_expr_iter_next(iter_b);
+	if (rule_a == NULL || rule_b == NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) != NULL ||
+	    nft_rule_expr_iter_next(iter_b) != NULL)
+		die("More 1 expr.");
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
diff --git a/tests/nft-expr_target-test.c b/tests/nft-expr_target-test.c
new file mode 100644
index 0000000..8772a4d
--- /dev/null
+++ b/tests/nft-expr_target-test.c
@@ -0,0 +1,118 @@
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
+#include <netinet/in.h>
+#include <netinet/ip.h>
+#include <linux/netfilter/nf_tables.h>
+#include <linux/netfilter/xt_iprange.h>
+#include <linux/netfilter_ipv4/ipt_LOG.h>
+#include <libmnl/libmnl.h>
+#include <libnftables/rule.h>
+#include <libnftables/expr.h>
+
+static int test_ok = 1;
+
+static void die(const char *msg)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+}
+
+static void die2(const char *msg, uint32_t a, uint32_t b)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s size a: %d b: %d \n",msg, a, b);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	uint32_t lena, lenb;
+
+	if (strcmp(nft_rule_expr_get_str(rule_a, NFT_EXPR_TG_NAME),
+		   nft_rule_expr_get_str(rule_b, NFT_EXPR_TG_NAME)) != 0)
+		die("Expr NFT_EXPR_TG_NAME mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_TG_REV) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_TG_REV))
+		die("Expr NFT_EXPR_TG_REV mismatches");
+	nft_rule_expr_get(rule_a, NFT_EXPR_TG_INFO, &lena);
+	nft_rule_expr_get(rule_b, NFT_EXPR_TG_INFO, &lenb);
+	if (lena != lenb)
+		die2("Expr NFT_EXPR_TG_INFO size mismatches", lena, lenb);
+}
+
+int main(int argc, char *argv[])
+{
+	struct nft_rule *a, *b;
+	struct nft_rule_expr *ex;
+	struct nlmsghdr *nlh;
+	struct ipt_log_info *info;
+	char buf[4096];
+	struct nft_rule_expr_iter *iter_a, *iter_b;
+	struct nft_rule_expr *rule_a, *rule_b;
+
+	a = nft_rule_alloc();
+	b = nft_rule_alloc();
+	if (a == NULL || b == NULL)
+		die("OOM");
+
+	ex = nft_rule_expr_alloc("target");
+	if (ex == NULL)
+		die("OOM");
+	nft_rule_expr_set(ex, NFT_EXPR_TG_NAME, "test", strlen("test"));
+	nft_rule_expr_set_u32(ex, NFT_EXPR_TG_REV, 0x12345678);
+
+	info = calloc(1, sizeof(struct ipt_log_info));
+	if (info == NULL)
+		die("OOM");
+	sprintf(info->prefix, "test: ");
+	info->prefix[sizeof(info->prefix)-1] = '\0';
+	info->logflags = 0x0f;
+	info->level = 5;
+	nft_rule_expr_set(ex, NFT_EXPR_TG_INFO, info, sizeof(*info));
+
+	nft_rule_add_expr(a, ex);
+
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a = nft_rule_expr_iter_create(a);
+	iter_b = nft_rule_expr_iter_create(b);
+	if (iter_a == NULL || iter_b == NULL)
+		die("OOM");
+
+	rule_a = nft_rule_expr_iter_next(iter_a);
+	rule_b = nft_rule_expr_iter_next(iter_b);
+	if (rule_a == NULL || rule_b == NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) != NULL ||
+	    nft_rule_expr_iter_next(iter_b) != NULL)
+		die("More 1 expr.");
+
+	nft_rule_expr_iter_destroy(iter_a);
+	nft_rule_expr_iter_destroy(iter_b);
+	nft_rule_free(a);
+	nft_rule_free(b);
+
+	if (!test_ok)
+		exit(EXIT_FAILURE);
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/nft-rule-test.c b/tests/nft-rule-test.c
new file mode 100644
index 0000000..957749d
--- /dev/null
+++ b/tests/nft-rule-test.c
@@ -0,0 +1,86 @@
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
+#include <netinet/in.h>
+#include <linux/netfilter/nf_tables.h>
+#include <libnftables/rule.h>
+
+static int test_ok = 1;
+
+static void die(const char *msg)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+}
+
+static void cmp_nft_rule(struct nft_rule *a, struct nft_rule *b)
+{
+	if (nft_rule_attr_get_u32(a, NFT_RULE_ATTR_FAMILY) !=
+	    nft_rule_attr_get_u32(b, NFT_RULE_ATTR_FAMILY))
+		die("Rule family mismatches");
+	if (strcmp(nft_rule_attr_get_str(a, NFT_RULE_ATTR_TABLE),
+		   nft_rule_attr_get_str(b, NFT_RULE_ATTR_TABLE)) != 0)
+		die("Rule table mismatches");
+	if (strcmp(nft_rule_attr_get_str(a, NFT_RULE_ATTR_CHAIN),
+		   nft_rule_attr_get_str(b, NFT_RULE_ATTR_CHAIN)) != 0)
+		die("Rule table mismatches");
+	if (nft_rule_attr_get_u64(a, NFT_RULE_ATTR_HANDLE) !=
+	    nft_rule_attr_get_u64(b, NFT_RULE_ATTR_HANDLE))
+		die("Rule handle mismatches");
+	if (nft_rule_attr_get_u32(a, NFT_RULE_ATTR_COMPAT_PROTO) !=
+	    nft_rule_attr_get_u32(b, NFT_RULE_ATTR_COMPAT_PROTO))
+		die("Rule compat_proto mismatches");
+	if (nft_rule_attr_get_u32(a, NFT_RULE_ATTR_COMPAT_FLAGS) !=
+	    nft_rule_attr_get_u32(b, NFT_RULE_ATTR_COMPAT_FLAGS))
+		die("Rule compat_flags mismatches");
+	if (nft_rule_attr_get_u64(a, NFT_RULE_ATTR_POSITION) !=
+	    nft_rule_attr_get_u64(b, NFT_RULE_ATTR_POSITION))
+		die("Rule compat_position mismatches");
+}
+
+int main(int argc, char *argv[])
+{
+	struct nft_rule *a, *b;
+	char buf[4096];
+	struct nlmsghdr *nlh;
+
+	a = nft_rule_alloc();
+	b = nft_rule_alloc();
+	if (a == NULL || b == NULL)
+		die("OOM");
+
+	nft_rule_attr_set_u32(a, NFT_RULE_ATTR_FAMILY, AF_INET);
+	nft_rule_attr_set_str(a, NFT_RULE_ATTR_TABLE, "table");
+	nft_rule_attr_set_str(a, NFT_RULE_ATTR_CHAIN, "chain");
+	nft_rule_attr_set_u64(a, NFT_RULE_ATTR_HANDLE, 0x1234567812345678);
+	nft_rule_attr_set_u32(a, NFT_RULE_ATTR_COMPAT_PROTO, 0x12345678);
+	nft_rule_attr_set_u32(a, NFT_RULE_ATTR_COMPAT_FLAGS, 0x12345678);
+	nft_rule_attr_set_u64(a, NFT_RULE_ATTR_POSITION, 0x1234567812345678);
+
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	cmp_nft_rule(a,b);
+
+	nft_rule_free(a);
+	nft_rule_free(b);
+	if (!test_ok)
+		exit(EXIT_FAILURE);
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/nft-set-test.c b/tests/nft-set-test.c
new file mode 100644
index 0000000..fa2f30e
--- /dev/null
+++ b/tests/nft-set-test.c
@@ -0,0 +1,88 @@
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
+#include <netinet/in.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include <libnftables/set.h>
+
+static int test_ok = 1;
+
+static void die(const char *msg)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+}
+
+static void cmp_nft_set(struct nft_set *a, struct nft_set *b)
+{
+	if (strcmp(nft_set_attr_get_str(a, NFT_SET_ATTR_TABLE),
+		   nft_set_attr_get_str(b, NFT_SET_ATTR_TABLE)) != 0)
+		die("Set table mismatches");
+	if (strcmp(nft_set_attr_get_str(a, NFT_SET_ATTR_NAME),
+		   nft_set_attr_get_str(b, NFT_SET_ATTR_NAME)) != 0)
+		die("Set name mismatches");
+	if (nft_set_attr_get_u32(a, NFT_SET_ATTR_FLAGS) !=
+	    nft_set_attr_get_u32(b, NFT_SET_ATTR_FLAGS))
+		die("Set flags mismatches");
+	if (nft_set_attr_get_u32(a, NFT_SET_ATTR_KEY_TYPE) !=
+	    nft_set_attr_get_u32(b, NFT_SET_ATTR_KEY_TYPE))
+		die("Set key-type mismatches");
+	if (nft_set_attr_get_u32(a, NFT_SET_ATTR_KEY_LEN) !=
+	    nft_set_attr_get_u32(b, NFT_SET_ATTR_KEY_LEN))
+		die("Set key-len mismatches");
+	if (nft_set_attr_get_u32(a, NFT_SET_ATTR_DATA_TYPE) !=
+	    nft_set_attr_get_u32(b, NFT_SET_ATTR_DATA_TYPE))
+		die("Set data-type mismatches");
+	if (nft_set_attr_get_u32(a, NFT_SET_ATTR_DATA_LEN) !=
+	    nft_set_attr_get_u32(b, NFT_SET_ATTR_DATA_LEN))
+		die("Set data-len mismatches");
+}
+
+int main(int argc, char *argv[])
+{
+	struct nft_set *a, *b = NULL;
+	char buf[4096];
+	struct nlmsghdr *nlh;
+
+	a = nft_set_alloc();
+	b = nft_set_alloc();
+	if (a == NULL || b == NULL)
+		die("OOM");
+
+	nft_set_attr_set_str(a, NFT_SET_ATTR_TABLE, "test-table");
+	nft_set_attr_set_str(a, NFT_SET_ATTR_NAME, "test-name");
+	nft_set_attr_set_u32(a, NFT_SET_ATTR_FLAGS, 0x12345678);
+	nft_set_attr_set_u32(a, NFT_SET_ATTR_KEY_TYPE, 0x12345678);
+	nft_set_attr_set_u32(a, NFT_SET_ATTR_KEY_LEN, 0x12345678);
+	nft_set_attr_set_u32(a, NFT_SET_ATTR_DATA_TYPE, 0x12345678);
+	nft_set_attr_set_u32(a, NFT_SET_ATTR_DATA_LEN, 0x12345678);
+	nft_set_attr_set_u32(a, NFT_SET_ATTR_FAMILY, 0x12345678);
+
+	/* cmd extracted from include/linux/netfilter/nf_tables.h */
+	nlh = nft_set_nlmsg_build_hdr(buf, NFT_MSG_NEWSET, AF_INET, 0, 1234);
+	nft_set_nlmsg_build_payload(nlh, a);
+
+	if (nft_set_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	cmp_nft_set(a,b);
+
+	nft_set_free(a); nft_set_free(b);
+
+	if (!test_ok)
+		exit(EXIT_FAILURE);
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/nft-table-test.c b/tests/nft-table-test.c
new file mode 100644
index 0000000..48fed55
--- /dev/null
+++ b/tests/nft-table-test.c
@@ -0,0 +1,74 @@
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
+#include <netinet/in.h>
+
+#include <linux/netfilter/nf_tables.h>
+#include <libnftables/table.h>
+
+static int test_ok = 1;
+
+static void die(const char *msg)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+}
+
+static void cmp_nft_table(struct nft_table *a, struct nft_table *b)
+{
+	if (strcmp(nft_table_attr_get_str(a, NFT_TABLE_ATTR_NAME),
+		   nft_table_attr_get_str(b, NFT_TABLE_ATTR_NAME)) != 0)
+		die("table name mismatches");
+	if (nft_table_attr_get_u32(a, NFT_TABLE_ATTR_FLAGS) !=
+	    nft_table_attr_get_u32(b, NFT_TABLE_ATTR_FLAGS))
+		die("table flags mismatches");
+	if (nft_table_attr_get_u8(a, NFT_TABLE_ATTR_FAMILY) !=
+	    nft_table_attr_get_u8(b, NFT_TABLE_ATTR_FAMILY))
+		die("tabke family mismatches");
+}
+
+int main(int argc, char *argv[])
+{
+	char buf[4096];
+	struct nlmsghdr *nlh;
+
+	struct nft_table *a = NULL;
+	struct nft_table *b = NULL;
+	a = nft_table_alloc();
+	b = nft_table_alloc();
+
+	if (a == NULL || b == NULL)
+		die("OOM");
+
+	nft_table_attr_set_str(a, NFT_TABLE_ATTR_NAME, "test");
+	nft_table_attr_set_u8(a, NFT_TABLE_ATTR_FAMILY, AF_INET);
+	nft_table_attr_set_u32(a, NFT_TABLE_ATTR_FLAGS, 0);
+
+	/* cmd extracted from include/linux/netfilter/nf_tables.h */
+	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE, AF_INET, 0,
+					1234);
+	nft_table_nlmsg_build_payload(nlh, a);
+
+	if (nft_table_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	cmp_nft_table(a,b);
+
+	nft_table_free(a);
+	nft_table_free(b);
+	if (!test_ok)
+		exit(EXIT_FAILURE);
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/test-script.sh b/tests/test-script.sh
new file mode 100755
index 0000000..458f818
--- /dev/null
+++ b/tests/test-script.sh
@@ -0,0 +1,20 @@
+./nft-chain-test
+./nft-expr_bitwise-test
+./nft-expr_byteorder-test
+./nft-expr_cmp-test
+./nft-expr_counter-test
+./nft-expr_ct-test
+./nft-expr_exthdr-test
+./nft-expr_immediate-test
+./nft-expr_limit-test
+./nft-expr_log-test
+./nft-expr_lookup-test
+./nft-expr_match-test
+./nft-expr_meta-test
+./nft-expr_nat-test
+./nft-expr_payload-test
+./nft-expr_reject-test
+./nft-expr_target-test
+./nft-rule-test
+./nft-set-test
+./nft-table-test
-- 
1.8.4.rc3

