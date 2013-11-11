From: Ana Rey <anarey@gmail.com>
Subject: [PATCH v2] tests: tests for libnftables
Date: Mon, 11 Nov 2013 18:32:23 +0100
Message-ID: <1384191143-6447-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, kernel@linuxace.com,
	arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:54062 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab3KKRgY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:36:24 -0500
Received: by mail-we0-f179.google.com with SMTP id x55so910262wes.24
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Nov 2013 09:36:22 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Makefile and tests files for libnftables.

In this patch, I create a initial object 'a' and I set a testing values=
=2E Then,
I convert this object in a Netlink message.

=46rom this Netlink message, I parse that (through nft_table_nlmsg_pars=
e
function) in 'b' objetc.

Thus, we make sure that object transformations are correct.
---
v2: fix writing erorres in messages that I unintentionally added in v1 =
that
were spotted by Phil Oester.

=46ix a multiline comment error. The nft-ruleset-test is not included
in this patch, also, I delete it in the tests/test-script.sh. Those err=
ors were=20
spotted by Arturo Borrero.

 tests/Makefile.am               |  82 ++++++++++++++++++++++++++++-
 tests/nft-chain-test.c          | 105 ++++++++++++++++++++++++++++++++=
+++++
 tests/nft-expr_bitwise-test.c   | 104 ++++++++++++++++++++++++++++++++=
+++++
 tests/nft-expr_byteorder-test.c |  92 ++++++++++++++++++++++++++++++++=
+
 tests/nft-expr_cmp-test.c       |  87 +++++++++++++++++++++++++++++++
 tests/nft-expr_counter-test.c   |  79 ++++++++++++++++++++++++++++
 tests/nft-expr_ct-test.c        |  83 +++++++++++++++++++++++++++++
 tests/nft-expr_exthdr-test.c    |  87 +++++++++++++++++++++++++++++++
 tests/nft-expr_immediate-test.c |  98 ++++++++++++++++++++++++++++++++=
+++
 tests/nft-expr_limit-test.c     |  81 +++++++++++++++++++++++++++++
 tests/nft-expr_log-test.c       |  87 +++++++++++++++++++++++++++++++
 tests/nft-expr_lookup-test.c    |  90 ++++++++++++++++++++++++++++++++
 tests/nft-expr_match-test.c     | 105 ++++++++++++++++++++++++++++++++=
+++++
 tests/nft-expr_meta-test.c      |  79 ++++++++++++++++++++++++++++
 tests/nft-expr_nat-test.c       |  97 ++++++++++++++++++++++++++++++++=
++
 tests/nft-expr_payload-test.c   |  88 +++++++++++++++++++++++++++++++
 tests/nft-expr_reject-test.c    |  81 +++++++++++++++++++++++++++++
 tests/nft-expr_target-test.c    | 112 ++++++++++++++++++++++++++++++++=
++++++++
 tests/nft-rule-test.c           |  76 +++++++++++++++++++++++++++
 tests/nft-set-test.c            |  74 ++++++++++++++++++++++++++
 tests/nft-table-test.c          |  64 +++++++++++++++++++++++
 tests/test-script.sh            |  19 +++++++
 22 files changed, 1869 insertions(+), 1 deletion(-)
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
=20
-check_PROGRAMS =3D nft-parsing-test
+check_PROGRAMS =3D 	nft-parsing-test		\
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
=20
 nft_parsing_test_SOURCES =3D nft-parsing-test.c
 nft_parsing_test_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS} ${LIBX=
ML_LIBS} ${LIBJSON_LIBS}
+
+nft_table_test_SOURCES =3D nft-table-test.c
+nft_table_test_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_chain_test_SOURCES =3D nft-chain-test.c
+nft_chain_test_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_rule_test_SOURCES =3D nft-rule-test.c
+nft_rule_test_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_set_test_SOURCES =3D nft-set-test.c
+nft_set_test_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_bitwise_test_SOURCES =3D nft-expr_bitwise-test.c
+nft_expr_bitwise_test_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_byteorder_test_SOURCES =3D nft-expr_byteorder-test.c
+nft_expr_byteorder_test_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_cmp_test_SOURCES =3D nft-expr_cmp-test.c
+nft_expr_cmp_test_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_counter_test_SOURCES =3D nft-expr_counter-test.c
+nft_expr_counter_test_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_exthdr_test_SOURCES =3D nft-expr_exthdr-test.c
+nft_expr_exthdr_test_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_ct_test_SOURCES =3D nft-expr_ct-test.c
+nft_expr_ct_test_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_immediate_test_SOURCES =3D nft-expr_counter-test.c
+nft_expr_immediate_test_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_limit_test_SOURCES =3D nft-expr_limit-test.c
+nft_expr_limit_test_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_lookup_test_SOURCES =3D nft-expr_limit-test.c
+nft_expr_lookup_test_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_log_test_SOURCES =3D nft-expr_log-test.c
+nft_expr_log_test_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_match_test_SOURCES =3D nft-expr_match-test.c
+nft_expr_match_test_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_meta_test_SOURCES =3D nft-expr_meta-test.c
+nft_expr_meta_test_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_nat_test_SOURCES =3D nft-expr_nat-test.c
+nft_expr_nat_test_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_payload_test_SOURCES =3D nft-expr_payload-test.c
+nft_expr_payload_test_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_reject_test_SOURCES =3D nft-expr_reject-test.c
+nft_expr_reject_test_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
+
+nft_expr_target_test_SOURCES =3D nft-expr_target-test.c
+nft_expr_target_test_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
diff --git a/tests/nft-chain-test.c b/tests/nft-chain-test.c
new file mode 100644
index 0000000..dba2c69
--- /dev/null
+++ b/tests/nft-chain-test.c
@@ -0,0 +1,105 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <netinet/in.h>
+#include <linux/netfilter/nf_tables.h>
+
+struct nlmsghdr;
+
+#include <libnftables/chain.h>
+
+static void die(const char *msg)
+{
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+	exit(EXIT_FAILURE);
+}
+
+static void cmp_nft_chain(struct nft_chain *a, struct nft_chain *b)
+{
+
+	if (strcmp(nft_chain_attr_get_str(a, NFT_CHAIN_ATTR_NAME),
+		   nft_chain_attr_get_str(b, NFT_CHAIN_ATTR_NAME)) !=3D 0)
+		die("Chain name mismatches");
+
+	if (strcmp(nft_chain_attr_get_str(a, NFT_CHAIN_ATTR_TABLE),
+		   nft_chain_attr_get_str(b, NFT_CHAIN_ATTR_TABLE)) !=3D 0)
+		die("Chain table mismatches");
+
+	if (nft_chain_attr_get_u32(a, NFT_CHAIN_ATTR_FAMILY) !=3D
+	    nft_chain_attr_get_u32(b, NFT_CHAIN_ATTR_FAMILY))
+		die("Chain family mismatches");
+
+	if (nft_chain_attr_get_u32(a, NFT_CHAIN_ATTR_POLICY) !=3D
+	    nft_chain_attr_get_u32(b, NFT_CHAIN_ATTR_POLICY))
+		die("Chain policy mismatches");
+
+	if (nft_chain_attr_get_u32(a, NFT_CHAIN_ATTR_HOOKNUM) !=3D
+	    nft_chain_attr_get_u32(b, NFT_CHAIN_ATTR_HOOKNUM))
+		die("Chain hooknum mismatches");
+
+	if (nft_chain_attr_get_s32(a, NFT_CHAIN_ATTR_PRIO) !=3D
+	    nft_chain_attr_get_s32(b, NFT_CHAIN_ATTR_PRIO))
+		die("Chain Prio mismatches");
+
+	if (nft_chain_attr_get_u32(a, NFT_CHAIN_ATTR_USE) !=3D
+	    nft_chain_attr_get_u32(b, NFT_CHAIN_ATTR_USE))
+		die("Chain use mismatches");
+
+	if (nft_chain_attr_get_u64(a, NFT_CHAIN_ATTR_PACKETS) !=3D
+	    nft_chain_attr_get_u64(b, NFT_CHAIN_ATTR_PACKETS))
+		die("Chain packets mismatches");
+
+	if (nft_chain_attr_get_u64(a, NFT_CHAIN_ATTR_BYTES) !=3D
+	    nft_chain_attr_get_u64(b, NFT_CHAIN_ATTR_BYTES))
+		die("Chain bytes mismatches");
+
+	if (nft_chain_attr_get_u64(a, NFT_CHAIN_ATTR_HANDLE) !=3D
+	    nft_chain_attr_get_u64(b, NFT_CHAIN_ATTR_HANDLE))
+		die("Chain handle mismatches");
+
+	if (strcmp(nft_chain_attr_get_str(a, NFT_CHAIN_ATTR_TYPE),
+		   nft_chain_attr_get_str(b, NFT_CHAIN_ATTR_TYPE)) !=3D 0)
+		die("Chain type mismatches");
+}
+
+int main(int argc, char *argv[])
+{
+	struct nft_chain *a, *b;
+	char buf[4096];
+	struct nlmsghdr *nlh;
+
+	a =3D nft_chain_alloc();
+	b =3D nft_chain_alloc();
+	if (a =3D=3D NULL || b =3D=3D NULL)
+		die("OOM");
+
+	nft_chain_attr_set_str(a, NFT_CHAIN_ATTR_NAME, "test");
+	/* TODO nft_chain_attr_set_u8 and get */
+	nft_chain_attr_set_u32(a, NFT_CHAIN_ATTR_FAMILY, AF_INET);
+	nft_chain_attr_set_str(a, NFT_CHAIN_ATTR_TABLE, "Table");
+	nft_chain_attr_set_u32(a, NFT_CHAIN_ATTR_POLICY,0x12345678);
+	nft_chain_attr_set_u32(a, NFT_CHAIN_ATTR_HOOKNUM, 0x12345678);
+	nft_chain_attr_set_s32(a, NFT_CHAIN_ATTR_PRIO, 0x12345678);
+	nft_chain_attr_set_u32(a, NFT_CHAIN_ATTR_USE, 0x12345678 );
+	nft_chain_attr_set_u64(a, NFT_CHAIN_ATTR_PACKETS, 0x1234567812345678)=
;
+	nft_chain_attr_set_u64(a, NFT_CHAIN_ATTR_BYTES, 0x1234567812345678);
+	nft_chain_attr_set_u64(a, NFT_CHAIN_ATTR_HANDLE, 0x1234567812345678);
+	nft_chain_attr_set_str(a, NFT_CHAIN_ATTR_TYPE, "Prueba");
+
+	/* cmd extracted from include/linux/netfilter/nf_tables.h */
+	nlh =3D nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, AF_INET,
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
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+
+}
diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-tes=
t.c
new file mode 100644
index 0000000..46823d8
--- /dev/null
+++ b/tests/nft-expr_bitwise-test.c
@@ -0,0 +1,104 @@
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
+static void die(const char *msg)
+{
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+	exit(EXIT_FAILURE);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	uint32_t maska =3D NULL;
+	uint32_t maskb =3D NULL;
+	uint32_t xora =3D NULL;
+	uint32_t xorb =3D NULL;
+
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_BITWISE_DREG) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_BITWISE_DREG))
+		die("Expr BITWISE_DREG mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_BITWISE_SREG) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_BITWISE_SREG))
+		die("Expr BITWISE_SREG mismatches");
+	if (nft_rule_expr_get_u16(rule_a, NFT_EXPR_BITWISE_LEN) !=3D
+	    nft_rule_expr_get_u16(rule_b, NFT_EXPR_BITWISE_LEN))
+		die("Expr BITWISE_DREG mismatches");
+
+	nft_rule_expr_get(rule_a, NFT_EXPR_BITWISE_MASK, &maska);
+	nft_rule_expr_get(rule_b, NFT_EXPR_BITWISE_MASK, &maskb);
+	if (maska !=3D maskb)
+		die("Size of BITWISE_MASK mismatches");
+
+	nft_rule_expr_get(rule_a, NFT_EXPR_BITWISE_XOR, &xora);
+	nft_rule_expr_get(rule_b, NFT_EXPR_BITWISE_XOR, &xorb);
+	if (xora !=3D xorb)
+		die("Size of BITWISE_XOR mismatches");
+
+}
+int main(int argc, char *argv[])
+{
+	struct nft_rule *a, *b =3D NULL;
+	struct nft_rule_expr *ex =3D NULL;
+	struct nlmsghdr *nlh;
+	char buf[4096];
+	struct nft_rule_expr_iter *iter_a, *iter_b =3D NULL;
+	struct nft_rule_expr *rule_a, *rule_b =3D NULL;
+	uint32_t mask =3D 0x01010101;
+	uint32_t xor =3D 0x12345678;
+
+	a =3D nft_rule_alloc();
+	b =3D nft_rule_alloc();
+	if (a =3D=3D NULL || b =3D=3D NULL)
+		die("OOM");
+	ex =3D nft_rule_expr_alloc("limit");
+	if (ex =3D=3D NULL)
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
+	nlh =3D nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 12=
34);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a =3D nft_rule_expr_iter_create(a);
+	iter_b =3D nft_rule_expr_iter_create(b);
+	if (iter_a =3D=3D NULL || iter_b =3D=3D NULL)
+		die("OOM");
+
+	rule_a =3D nft_rule_expr_iter_next(iter_a);
+	rule_b =3D nft_rule_expr_iter_next(iter_b);
+	if (rule_a =3D=3D NULL || rule_b =3D=3D NULL)
+		die("OOM");
+
+	if (nft_rule_expr_iter_next(iter_a) !=3D NULL ||
+	    nft_rule_expr_iter_next(iter_b) !=3D NULL)
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
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/nft-expr_byteorder-test.c b/tests/nft-expr_byteorder=
-test.c
new file mode 100644
index 0000000..8731481
--- /dev/null
+++ b/tests/nft-expr_byteorder-test.c
@@ -0,0 +1,92 @@
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
+static void die(const char *msg)
+{
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+	exit(EXIT_FAILURE);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_BYTEORDER_DREG) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_BYTEORDER_DREG))
+		die("Expr BYTEORDER_DREG mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_BYTEORDER_SREG) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_BYTEORDER_SREG))
+		die("Expr BYTEORDER_SREG mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_BYTEORDER_OP) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_BYTEORDER_OP))
+		die("Expr BYTEORDER_OP mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_BYTEORDER_LEN) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_BYTEORDER_LEN))
+		die("Expr BYTEORDER_DREG mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_BYTEORDER_SIZE) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_BYTEORDER_SIZE))
+		die("Expr BITWISE_SIZE mismatches");
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
+	a =3D nft_rule_alloc();
+	b =3D nft_rule_alloc();
+	if (a =3D=3D NULL || b =3D=3D NULL)
+		die("OOM");
+	ex =3D nft_rule_expr_alloc("limit");
+	if (ex =3D=3D NULL)
+		die("OOM");
+
+	nft_rule_expr_set_u32(ex, NFT_EXPR_BYTEORDER_SREG, 0x12345678);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_BYTEORDER_DREG, 0x12345678);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_BYTEORDER_OP, 0x12345678);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_BYTEORDER_LEN, 0x1234);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_BYTEORDER_SIZE, 0x1234);
+
+	nft_rule_add_expr(a, ex);
+
+	nlh =3D nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 12=
34);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a =3D nft_rule_expr_iter_create(a);
+	iter_b =3D nft_rule_expr_iter_create(b);
+	if (iter_a =3D=3D NULL || iter_b =3D=3D NULL)
+		die("OOM");
+
+	rule_a =3D nft_rule_expr_iter_next(iter_a);
+	rule_b =3D nft_rule_expr_iter_next(iter_b);
+	if (rule_a =3D=3D NULL || rule_b =3D=3D NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a,rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) !=3D NULL ||
+	    nft_rule_expr_iter_next(iter_b) !=3D NULL)
+		die("More 1 expr.");
+
+	nft_rule_expr_iter_destroy(iter_a);
+	nft_rule_expr_iter_destroy(iter_b);
+	nft_rule_free(a);
+	nft_rule_free(b);
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/nft-expr_cmp-test.c b/tests/nft-expr_cmp-test.c
new file mode 100644
index 0000000..744bfcf
--- /dev/null
+++ b/tests/nft-expr_cmp-test.c
@@ -0,0 +1,87 @@
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
+static void die(const char *msg)
+{
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+	exit(EXIT_FAILURE);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	uint32_t data_lena =3D NULL;
+	uint32_t data_lenb =3D NULL;
+
+	nft_rule_expr_get(rule_a, NFT_EXPR_CMP_DATA, &data_lena);
+	nft_rule_expr_get(rule_b, NFT_EXPR_CMP_DATA, &data_lenb);
+	if (data_lena !=3D data_lenb)
+		die("Size of CMP_DATA mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_CMP_SREG) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_CMP_SREG))
+		die("Expr CMP_SREG mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_CMP_OP) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_CMP_OP))
+		die("Expr CMP_OP mismatches");
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
+	uint32_t data_len =3D 0x01010101;
+	a =3D nft_rule_alloc();
+	b =3D nft_rule_alloc();
+	if (a =3D=3D NULL || b =3D=3D NULL)
+		die("OOM");
+	ex =3D nft_rule_expr_alloc("cmp");
+	if (ex =3D=3D NULL)
+		die("OOM");
+
+	nft_rule_expr_set(ex, NFT_EXPR_CMP_DATA, &data_len, sizeof(data_len))=
;
+	nft_rule_expr_set_u32(ex, NFT_EXPR_CMP_SREG, 0x12345678);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_CMP_OP, 0x12345678);
+
+	nft_rule_add_expr(a, ex);
+
+	nlh =3D nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 12=
34);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a =3D nft_rule_expr_iter_create(a);
+	iter_b =3D nft_rule_expr_iter_create(b);
+	if (iter_a =3D=3D NULL || iter_b =3D=3D NULL)
+		die("OOM");
+	rule_a =3D nft_rule_expr_iter_next(iter_a);
+	rule_b =3D nft_rule_expr_iter_next(iter_b);
+	if (rule_a =3D=3D NULL || rule_b =3D=3D NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) !=3D NULL ||
+	    nft_rule_expr_iter_next(iter_b) !=3D NULL)
+		die("More 1 expr.");
+
+	nft_rule_expr_iter_destroy(iter_a);
+	nft_rule_expr_iter_destroy(iter_b);
+	nft_rule_free(a);
+	nft_rule_free(b);
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/nft-expr_counter-test.c b/tests/nft-expr_counter-tes=
t.c
new file mode 100644
index 0000000..3d84fa3
--- /dev/null
+++ b/tests/nft-expr_counter-test.c
@@ -0,0 +1,79 @@
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
+static void die(const char *msg)
+{
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+	exit(EXIT_FAILURE);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	if (nft_rule_expr_get_u64(rule_a, NFT_EXPR_CTR_BYTES) !=3D
+	    nft_rule_expr_get_u64(rule_b, NFT_EXPR_CTR_BYTES))
+		die("Expr CTR_BYTES mismatches");
+	if (nft_rule_expr_get_u64(rule_a, NFT_EXPR_CTR_PACKETS) !=3D
+	    nft_rule_expr_get_u64(rule_b, NFT_EXPR_CTR_PACKETS))
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
+	a =3D nft_rule_alloc();
+	b =3D nft_rule_alloc();
+	if (a =3D=3D NULL || b =3D=3D NULL)
+		die("OOM");
+
+	ex =3D nft_rule_expr_alloc("counter");
+	if (ex =3D=3D NULL)
+		die("OOM");
+
+	nft_rule_expr_set_u64(ex, NFT_EXPR_CTR_BYTES, 0x123456789abcdef0);
+	nft_rule_expr_set_u64(ex, NFT_EXPR_CTR_PACKETS, 0x123456789abcdef0);
+	nft_rule_add_expr(a, ex);
+
+	nlh =3D nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 12=
34);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a =3D nft_rule_expr_iter_create(a);
+	iter_b =3D nft_rule_expr_iter_create(b);
+	if (iter_a =3D=3D NULL || iter_b =3D=3D NULL)
+		die("OOM");
+	rule_a =3D nft_rule_expr_iter_next(iter_a);
+	rule_b =3D nft_rule_expr_iter_next(iter_b);
+	if (rule_a =3D=3D NULL || rule_b =3D=3D NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) !=3D NULL ||
+	    nft_rule_expr_iter_next(iter_b) !=3D NULL)
+		die("More 1 expr.");
+
+	nft_rule_expr_iter_destroy(iter_a);
+	nft_rule_expr_iter_destroy(iter_b);
+	nft_rule_free(a);
+	nft_rule_free(b);
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/nft-expr_ct-test.c b/tests/nft-expr_ct-test.c
new file mode 100644
index 0000000..5c56796
--- /dev/null
+++ b/tests/nft-expr_ct-test.c
@@ -0,0 +1,83 @@
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
+static void die(const char *msg)
+{
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+	exit(EXIT_FAILURE);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_CT_KEY) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_CT_KEY))
+		die("Expr CT_KEY mismatches");
+	if (nft_rule_expr_get_u8(rule_a, NFT_EXPR_CT_DIR) !=3D
+	    nft_rule_expr_get_u8(rule_b, NFT_EXPR_CT_DIR))
+		die("Expr CT_DIR mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_CT_DREG) !=3D
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
+	a =3D nft_rule_alloc();
+	b =3D nft_rule_alloc();
+	if (a =3D=3D NULL || b =3D=3D NULL)
+		die("OOM");
+	ex =3D nft_rule_expr_alloc("ct");
+	if (ex =3D=3D NULL)
+		die("OOM");
+
+	nft_rule_expr_set_u32(ex, NFT_EXPR_CT_KEY, 0x1234568);
+	nft_rule_expr_set_u8(ex, NFT_EXPR_CT_DIR, 0x12);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_CT_DREG, 0x12345678);
+
+	nft_rule_add_expr(a, ex);
+
+	nlh =3D nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 12=
34);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a =3D nft_rule_expr_iter_create(a);
+	iter_b =3D nft_rule_expr_iter_create(b);
+	if (iter_a =3D=3D NULL || iter_b =3D=3D NULL)
+		die("OOM");
+
+	rule_a =3D nft_rule_expr_iter_next(iter_a);
+	rule_b =3D nft_rule_expr_iter_next(iter_b);
+	if (rule_a =3D=3D NULL || rule_b =3D=3D NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) !=3D NULL ||
+	    nft_rule_expr_iter_next(iter_b) !=3D NULL)
+		die("More 1 expr.");
+
+	nft_rule_expr_iter_destroy(iter_a);
+	nft_rule_expr_iter_destroy(iter_b);
+	nft_rule_free(a);
+	nft_rule_free(b);
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/nft-expr_exthdr-test.c b/tests/nft-expr_exthdr-test.=
c
new file mode 100644
index 0000000..bac3408
--- /dev/null
+++ b/tests/nft-expr_exthdr-test.c
@@ -0,0 +1,87 @@
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
+static void die(const char *msg)
+{
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+	exit(EXIT_FAILURE);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_EXTHDR_DREG) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_EXTHDR_DREG))
+		die("Expr EXTHDR_DREG mismatches");
+	if (nft_rule_expr_get_u8(rule_a, NFT_EXPR_EXTHDR_TYPE) !=3D
+	    nft_rule_expr_get_u8(rule_b, NFT_EXPR_EXTHDR_TYPE))
+		die("Expr EXTHDR_TYPE mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_EXTHDR_OFFSET) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_EXTHDR_OFFSET))
+		die("Expr EXTHDR_OFFSET mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_EXTHDR_LEN) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_EXTHDR_LEN))
+		die("Expr EXTHDR_LEN mismatches");
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
+	a =3D nft_rule_alloc();
+	b =3D nft_rule_alloc();
+	if (a =3D=3D NULL || b =3D=3D NULL)
+		die("OOM");
+	ex =3D nft_rule_expr_alloc("exthdr");
+	if (ex =3D=3D NULL)
+		die("OOM");
+
+	nft_rule_expr_set_u32(ex, NFT_EXPR_EXTHDR_DREG, 0x12345678);
+	nft_rule_expr_set_u8(ex, NFT_EXPR_EXTHDR_TYPE, 0x12);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_EXTHDR_OFFSET, 0x12345678);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_EXTHDR_LEN, 0x12345678);
+
+	nft_rule_add_expr(a, ex);
+
+	nlh =3D nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 12=
34);
+	nft_rule_nlmsg_build_payload(nlh, a);
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a =3D nft_rule_expr_iter_create(a);
+	iter_b =3D nft_rule_expr_iter_create(b);
+	if (iter_a =3D=3D NULL || iter_b =3D=3D NULL)
+		die("OOM");
+
+	rule_a =3D nft_rule_expr_iter_next(iter_a);
+	rule_b =3D nft_rule_expr_iter_next(iter_b);
+	if (rule_a =3D=3D NULL || rule_b =3D=3D NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) !=3D NULL ||
+	    nft_rule_expr_iter_next(iter_b) !=3D NULL)
+		die("More 1 expr.");
+
+	nft_rule_expr_iter_destroy(iter_a);
+	nft_rule_expr_iter_destroy(iter_b);
+	nft_rule_free(a);
+	nft_rule_free(b);
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/nft-expr_immediate-test.c b/tests/nft-expr_immediate=
-test.c
new file mode 100644
index 0000000..b0e466d
--- /dev/null
+++ b/tests/nft-expr_immediate-test.c
@@ -0,0 +1,98 @@
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
+static void die(const char *msg)
+{
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+	exit(EXIT_FAILURE);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	uint32_t data_a, data_b =3D NULL;
+	uint32_t chain_a, chain_b =3D NULL;
+
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_IMM_DREG) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_IMM_DREG))
+		die("Expr IMM_DREG mismatches");
+	if (nft_rule_expr_get(rule_a, NFT_EXPR_IMM_DATA, data_a) !=3D
+	    nft_rule_expr_get(rule_b, NFT_EXPR_IMM_DATA, data_b))
+		die("Expr IMM_DATA mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_IMM_VERDICT) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_IMM_VERDICT))
+		die("Expr IMM_VERDICT mismatches");
+	if (nft_rule_expr_get(rule_a, NFT_EXPR_IMM_CHAIN, chain_a) !=3D
+	    nft_rule_expr_get(rule_b, NFT_EXPR_IMM_CHAIN, chain_b))
+		die("Expr IMM_CHAIN mismatches");
+	if (data_a !=3D data_b)
+		die("Expr IMM_DATA. Size mismatches");
+	if (chain_a !=3D chain_b)
+		die("Expr IMM_CHAIN. Size mismatches");
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
+	a =3D nft_rule_alloc();
+	b =3D nft_rule_alloc();
+	if (a =3D=3D NULL || b =3D=3D NULL)
+		die("OOM");
+	ex =3D nft_rule_expr_alloc("ct");
+	if (ex =3D=3D NULL)
+		die("OOM");
+
+	uint32_t chain_t =3D 0x12345678;
+	uint32_t data_t =3D 0x12345678;
+
+	nft_rule_expr_set_u32(ex, NFT_EXPR_IMM_DREG, 0x1234568);
+	nft_rule_expr_set(ex, NFT_EXPR_IMM_DATA, &chain_t, sizeof(chain_t));
+	nft_rule_expr_set_u32(ex, NFT_EXPR_IMM_VERDICT, 0x12345678);
+	nft_rule_expr_set(ex, NFT_EXPR_IMM_CHAIN, &data_t, sizeof(data_t));
+
+	nft_rule_add_expr(a, ex);
+
+	nlh =3D nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 12=
34);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a =3D nft_rule_expr_iter_create(a);
+	iter_b =3D nft_rule_expr_iter_create(b);
+	if (iter_a =3D=3D NULL || iter_b =3D=3D NULL)
+		die("OOM");
+
+	rule_a =3D nft_rule_expr_iter_next(iter_a);
+	rule_b =3D nft_rule_expr_iter_next(iter_b);
+	if (rule_a =3D=3D NULL || rule_b =3D=3D NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) !=3D NULL ||
+	    nft_rule_expr_iter_next(iter_b) !=3D NULL)
+		die("More 1 expr.");
+
+	nft_rule_expr_iter_destroy(iter_a);
+	nft_rule_expr_iter_destroy(iter_b);
+	nft_rule_free(a);
+	nft_rule_free(b);
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/nft-expr_limit-test.c b/tests/nft-expr_limit-test.c
new file mode 100644
index 0000000..a2adeaf
--- /dev/null
+++ b/tests/nft-expr_limit-test.c
@@ -0,0 +1,81 @@
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
+static void die(const char *msg)
+{
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+	exit(EXIT_FAILURE);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	if (nft_rule_expr_get_u64(rule_a, NFT_EXPR_LIMIT_RATE) !=3D
+	    nft_rule_expr_get_u64(rule_b, NFT_EXPR_LIMIT_RATE))
+		die("Expr CTR_BYTES mismatches");
+	if (nft_rule_expr_get_u64(rule_a, NFT_EXPR_LIMIT_UNIT) !=3D
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
+	a =3D nft_rule_alloc();
+	b =3D nft_rule_alloc();
+	if (a =3D=3D NULL || b =3D=3D NULL)
+		die("OOM");
+	ex =3D nft_rule_expr_alloc("limit");
+	if (ex =3D=3D NULL)
+		die("OOM");
+
+	nft_rule_expr_set_u64(ex, NFT_EXPR_LIMIT_RATE, 0x123456789abcdef0);
+	nft_rule_expr_set_u64(ex, NFT_EXPR_LIMIT_UNIT, 0x123456789abcdef0);
+
+	nft_rule_add_expr(a, ex);
+
+	nlh =3D nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 12=
34);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a =3D nft_rule_expr_iter_create(a);
+	iter_b =3D nft_rule_expr_iter_create(b);
+	if (iter_a =3D=3D NULL || iter_b =3D=3D NULL)
+		die("OOM");
+
+	rule_a =3D nft_rule_expr_iter_next(iter_a);
+	rule_b =3D nft_rule_expr_iter_next(iter_b);
+	if (rule_a =3D=3D NULL || rule_b =3D=3D NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) !=3D NULL ||
+	    nft_rule_expr_iter_next(iter_b) !=3D NULL)
+		die("More 1 expr.");
+
+	nft_rule_expr_iter_destroy(iter_a);
+	nft_rule_expr_iter_destroy(iter_b);
+	nft_rule_free(a);
+	nft_rule_free(b);
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/nft-expr_log-test.c b/tests/nft-expr_log-test.c
new file mode 100644
index 0000000..98926d9
--- /dev/null
+++ b/tests/nft-expr_log-test.c
@@ -0,0 +1,87 @@
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
+static void die(const char *msg)
+{
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+	exit(EXIT_FAILURE);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_LOG_SNAPLEN) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_LOG_SNAPLEN))
+		die("Expr LOG_SNAPLEN mismatches");
+	if (nft_rule_expr_get_u16(rule_a, NFT_EXPR_LOG_GROUP) !=3D
+	    nft_rule_expr_get_u16(rule_b, NFT_EXPR_LOG_GROUP))
+		die("Expr LOG_GROUP mismatches");
+	if (nft_rule_expr_get_u16(rule_a, NFT_EXPR_LOG_QTHRESHOLD) !=3D
+	    nft_rule_expr_get_u16(rule_b, NFT_EXPR_LOG_QTHRESHOLD))
+		die("Expr CTR_BYTES mismatches");
+	if (strcmp(nft_rule_expr_get_str(rule_a, NFT_EXPR_LOG_PREFIX),
+	    nft_rule_expr_get_str(rule_b, NFT_EXPR_LOG_PREFIX)) !=3D 0)
+		die("Expr CTR_BYTES mismatches");
+}
+
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
+	a =3D nft_rule_alloc();
+	b =3D nft_rule_alloc();
+	if (a =3D=3D NULL || b =3D=3D NULL)
+		die("OOM");
+	ex =3D nft_rule_expr_alloc("counter");
+	if (ex =3D=3D NULL)
+		die("OOM");
+
+	nft_rule_expr_set_u32(ex, NFT_EXPR_LOG_SNAPLEN, 0x12345678);
+	nft_rule_expr_set_u16(ex, NFT_EXPR_LOG_GROUP, 0x1234);
+	nft_rule_expr_set_u16(ex, NFT_EXPR_LOG_QTHRESHOLD, 0x1234);
+	nft_rule_expr_set_str(ex, NFT_EXPR_LOG_PREFIX, "test-expr-log-prefix"=
);
+
+	nft_rule_add_expr(a, ex);
+
+	nlh =3D nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 12=
34);
+	nft_rule_nlmsg_build_payload(nlh, a);
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a =3D nft_rule_expr_iter_create(a);
+	iter_b =3D nft_rule_expr_iter_create(b);
+	if (iter_a =3D=3D NULL || iter_b =3D=3D NULL)
+		die("OOM");
+	rule_a =3D nft_rule_expr_iter_next(iter_a);
+	rule_b =3D nft_rule_expr_iter_next(iter_b);
+	if (rule_a =3D=3D NULL || rule_b =3D=3D NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) !=3D NULL ||
+	    nft_rule_expr_iter_next(iter_b) !=3D NULL)
+		die("More 1 expr.");
+
+	nft_rule_expr_iter_destroy(iter_a);
+	nft_rule_expr_iter_destroy(iter_b);
+	nft_rule_free(a);
+	nft_rule_free(b);
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/nft-expr_lookup-test.c b/tests/nft-expr_lookup-test.=
c
new file mode 100644
index 0000000..5d865e0
--- /dev/null
+++ b/tests/nft-expr_lookup-test.c
@@ -0,0 +1,90 @@
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
+static void die(const char *msg)
+{
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+	exit(EXIT_FAILURE);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	uint32_t data_lena;
+	uint32_t data_lenb;
+
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_LOOKUP_SREG) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_LOOPUP_SREG))
+		die("Expr LOOPUP_SREG mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_LOOKUP_DREG) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_LOOPUP_DREG))
+		die("Expr LOOPUP_DREG mismatches");
+	nft_rule_expr_get(rule_a, NFT_EXPR_LOOKUP_SET, &data_lena);
+	nft_rule_expr_get(rule_b, NFT_EXPR_LOOKUP_SET, &data_lenb);
+	if (data_lena !=3D data_lenb)
+		die("Expr LOOKUP_SET size mismatches");
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
+	uint32_t lookup_set =3D 0x12345678;
+
+	a =3D nft_rule_alloc();
+	b =3D nft_rule_alloc();
+	if (a =3D=3D NULL || b =3D=3D NULL)
+		die("OOM");
+	ex =3D nft_rule_expr_alloc("lookup");
+	if (ex =3D=3D NULL)
+		die("OOM");
+
+	nft_rule_expr_set_u32(ex, NFT_EXPR_LOOKUP_SREG, 0x12345678);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_LOOKUP_DREG, 0x12345678);
+	nft_rule_expr_set(ex, NFT_EXPR_LOOKUP_SET, &lookup_set,
+			  sizeof(lookup_set));
+
+	nft_rule_add_expr(a, ex);
+
+	nlh =3D nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 12=
34);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a =3D nft_rule_expr_iter_create(a);
+	iter_b =3D nft_rule_expr_iter_create(b);
+	if (iter_a =3D=3D NULL || iter_b =3D=3D NULL)
+		die("OOM");
+	rule_a =3D nft_rule_expr_iter_next(iter_a);
+	rule_b =3D nft_rule_expr_iter_next(iter_b);
+	if (rule_a =3D=3D NULL || rule_b =3D=3D NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) !=3D NULL ||
+	    nft_rule_expr_iter_next(iter_b) !=3D NULL)
+		die("More 1 expr.");
+
+	nft_rule_expr_iter_destroy(iter_a);
+	nft_rule_expr_iter_destroy(iter_b);
+	nft_rule_free(a);
+	nft_rule_free(b);
+
+	print(_"%s: \033[32mOK\e[0m\n", argv[0]);
+
+	return EXIT_SUCCESS;
+}
diff --git a/tests/nft-expr_match-test.c b/tests/nft-expr_match-test.c
new file mode 100644
index 0000000..9a8b634
--- /dev/null
+++ b/tests/nft-expr_match-test.c
@@ -0,0 +1,105 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <arpa/inet.h>
+#include <netinet/in.h>
+#include <netinet/ip.h>
+#include <linux/netfilter/nf_tables.h>
+#include <linux/netfilter/xt_iprange.h>
+#include <linux/netfilter_ipv4/ipt_LOG.h>
+#include <libmnl/libmnl.h>
+#include <libnftables/rule.h>
+#include <libnftables/expr.h>
+
+static void die(const char *msg)
+{
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+	exit(EXIT_FAILURE);
+}
+
+static void die2(const char *msg, uint32_t a, uint32_t b)
+{
+	printf("\033[31mERROR:\e[0m %s size a: %d b: %d \n",msg, a,b);
+	exit(EXIT_FAILURE);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	uint32_t lena, lenb;
+	if (strcmp(nft_rule_expr_get_str(rule_a, NFT_EXPR_MT_NAME),
+		   nft_rule_expr_get_str(rule_b, NFT_EXPR_MT_NAME)) !=3D 0)
+		die("Expr MT_NAME mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_MT_REV) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_MT_REV))
+		die("Expr MT_REV mismatches");
+	nft_rule_expr_get(rule_a, NFT_EXPR_MT_INFO, &lena);
+	nft_rule_expr_get(rule_b, NFT_EXPR_MT_INFO, &lenb);
+	if (lena !=3D lenb)
+		die2("Expr MT_INFO size mismatches", lena, lenb);
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
+	a =3D nft_rule_alloc();
+	b =3D nft_rule_alloc();
+	if (a =3D=3D NULL || b =3D=3D NULL)
+		die("OOM");
+	ex =3D nft_rule_expr_alloc("ct");
+	if (ex =3D=3D NULL)
+		die("OOM");
+
+	struct xt_iprange_mtinfo *info;
+
+	nft_rule_expr_set_str(ex, NFT_EXPR_MT_NAME, "TEST name");
+	nft_rule_expr_set_u32(ex, NFT_EXPR_MT_REV, 0x12345678);
+
+        info =3D calloc(1, sizeof(struct xt_iprange_mtinfo));
+        if (info =3D=3D NULL)
+                die("OOM");
+
+        info->src_min.ip =3D info->dst_min.ip =3D inet_addr("127.0.0.1=
");
+        info->src_max.ip =3D info->dst_max.ip =3D inet_addr("127.0.0.1=
");
+        info->flags =3D IPRANGE_SRC;
+
+        nft_rule_expr_set(ex, NFT_EXPR_MT_INFO, info, sizeof(info));
+
+	nft_rule_add_expr(a, ex);
+
+	nlh =3D nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 12=
34);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+	iter_a =3D nft_rule_expr_iter_create(a);
+	iter_b =3D nft_rule_expr_iter_create(b);
+	if (iter_a =3D=3D NULL || iter_b =3D=3D NULL)
+		die("OOM");
+
+	rule_a =3D nft_rule_expr_iter_next(iter_a);
+	rule_b =3D nft_rule_expr_iter_next(iter_b);
+	if (rule_a =3D=3D NULL || rule_b =3D=3D NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) !=3D NULL ||
+	    nft_rule_expr_iter_next(iter_b) !=3D NULL)
+		die("More 1 expr.");
+
+	nft_rule_expr_iter_destroy(iter_a);
+	nft_rule_expr_iter_destroy(iter_b);
+	nft_rule_free(a);
+	nft_rule_free(b);
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/nft-expr_meta-test.c b/tests/nft-expr_meta-test.c
new file mode 100644
index 0000000..f92af61
--- /dev/null
+++ b/tests/nft-expr_meta-test.c
@@ -0,0 +1,79 @@
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
+static void die(const char *msg)
+{
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+	exit(EXIT_FAILURE);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_META_KEY) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_META_KEY))
+		die("Expr META_KEY mismatches");
+	if (nft_rule_expr_get_u8(rule_a, NFT_EXPR_META_DREG) !=3D
+	    nft_rule_expr_get_u8(rule_b, NFT_EXPR_META_DREG))
+		die("Expr META_DREG mismatches");
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
+	a =3D nft_rule_alloc();
+	b =3D nft_rule_alloc();
+	if (a =3D=3D NULL || b =3D=3D NULL)
+		die("OOM");
+	ex =3D nft_rule_expr_alloc("meta");
+	if (ex =3D=3D NULL)
+		die("OOM");
+
+	nft_rule_expr_set_u32(ex, NFT_EXPR_META_KEY, 0x1234568);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_META_DREG, 0x12345678);
+
+	nft_rule_add_expr(a, ex);
+
+	nlh =3D nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 12=
34);
+	nft_rule_nlmsg_build_payload(nlh, a);
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a =3D nft_rule_expr_iter_create(a);
+	iter_b =3D nft_rule_expr_iter_create(b);
+	if (iter_a =3D=3D NULL || iter_b =3D=3D NULL)
+		die("OOM");
+
+	rule_a =3D nft_rule_expr_iter_next(iter_a);
+	rule_b =3D nft_rule_expr_iter_next(iter_b);
+	if (rule_a =3D=3D NULL || rule_b =3D=3D NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) !=3D NULL ||
+	    nft_rule_expr_iter_next(iter_b) !=3D NULL)
+		die("More 1 expr.");
+
+	nft_rule_expr_iter_destroy(iter_a);
+	nft_rule_expr_iter_destroy(iter_b);
+	nft_rule_free(a);
+	nft_rule_free(b);
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/nft-expr_nat-test.c b/tests/nft-expr_nat-test.c
new file mode 100644
index 0000000..c1f9df9
--- /dev/null
+++ b/tests/nft-expr_nat-test.c
@@ -0,0 +1,97 @@
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
+static void die(const char *msg)
+{
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+	exit(EXIT_FAILURE);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_NAT_TYPE) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_NAT_TYPE))
+		die("Expr NAT_TYPE mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_NAT_FAMILY) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_NAT_FAMILY))
+		die("Expr NAT_FAMILY mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_NAT_REG_ADDR_MIN) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_NAT_REG_ADDR_MIN))
+		die("Expr NAT_REG_ADDR_MIN mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_NAT_REG_ADDR_MAX) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_NAT_REG_ADDR_MAX))
+		die("Expr NAT_REG_ADDR_MAX mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_NAT_REG_PROTO_MIN) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_NAT_REG_PROTO_MIN))
+		die("Expr NAT_REG_PROTO_MIN mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_NAT_REG_PROTO_MAX) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_NAT_REG_PROTO_MAX))
+		die("Expr NAT_REG_PROTO_MAX mismatches");
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
+	a =3D nft_rule_alloc();
+	b =3D nft_rule_alloc();
+	if (a =3D=3D NULL || b =3D=3D NULL)
+		die("OOM");
+	ex =3D nft_rule_expr_alloc("ct");
+	if (ex =3D=3D NULL)
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
+	nlh =3D nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 12=
34);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a =3D nft_rule_expr_iter_create(a);
+	iter_b =3D nft_rule_expr_iter_create(b);
+	if (iter_a =3D=3D NULL || iter_b =3D=3D NULL)
+		die("OOM");
+
+	rule_a =3D nft_rule_expr_iter_next(iter_a);
+	rule_b =3D nft_rule_expr_iter_next(iter_b);
+	if (rule_a =3D=3D NULL || rule_b =3D=3D NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) !=3D NULL ||
+	    nft_rule_expr_iter_next(iter_b) !=3D NULL)
+		die("More 1 expr.");
+
+	nft_rule_expr_iter_destroy(iter_a);
+	nft_rule_expr_iter_destroy(iter_b);
+	nft_rule_free(a);
+	nft_rule_free(b);
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/nft-expr_payload-test.c b/tests/nft-expr_payload-tes=
t.c
new file mode 100644
index 0000000..a708969
--- /dev/null
+++ b/tests/nft-expr_payload-test.c
@@ -0,0 +1,88 @@
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
+static void die(const char *msg)
+{
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+	exit(EXIT_FAILURE);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_PAYLOAD_DREG) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_PAYLOAD_DREG))
+		die("Expr PAYLOAD_DREG mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_PAYLOAD_BASE) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_PAYLOAD_BASE))
+		die("Expr PAYLOAD_BASE mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_PAYLOAD_OFFSET) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_PAYLOAD_OFFSET))
+		die("Expr PAYLOAD_OFFSET mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_PAYLOAD_LEN) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_PAYLOAD_LEN))
+		die("Expr PAYLOAD_LEN mismatches");
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
+	a =3D nft_rule_alloc();
+	b =3D nft_rule_alloc();
+	if (a =3D=3D NULL || b =3D=3D NULL)
+		die("OOM");
+	ex =3D nft_rule_expr_alloc("payload");
+	if (ex =3D=3D NULL)
+		die("OOM");
+
+	nft_rule_expr_set_u32(ex, NFT_EXPR_PAYLOAD_DREG, 0x1234568);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_PAYLOAD_BASE, 0x12345678);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_PAYLOAD_OFFSET, 0x12345678);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_PAYLOAD_LEN, 0x12345678);
+
+	nft_rule_add_expr(a, ex);
+
+	nlh =3D nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 12=
34);
+	nft_rule_nlmsg_build_payload(nlh, a);
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a =3D nft_rule_expr_iter_create(a);
+	iter_b =3D nft_rule_expr_iter_create(b);
+	if (iter_a =3D=3D NULL || iter_b =3D=3D NULL)
+		die("OOM");
+
+	rule_a =3D nft_rule_expr_iter_next(iter_a);
+	rule_b =3D nft_rule_expr_iter_next(iter_b);
+	if (rule_a =3D=3D NULL || rule_b =3D=3D NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) !=3D NULL ||
+	    nft_rule_expr_iter_next(iter_b) !=3D NULL)
+		die("More 1 expr.");
+
+	nft_rule_expr_iter_destroy(iter_a);
+	nft_rule_expr_iter_destroy(iter_b);
+	nft_rule_free(a);
+	nft_rule_free(b);
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/nft-expr_reject-test.c b/tests/nft-expr_reject-test.=
c
new file mode 100644
index 0000000..9971068
--- /dev/null
+++ b/tests/nft-expr_reject-test.c
@@ -0,0 +1,81 @@
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
+static void die(const char *msg)
+{
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+	exit(EXIT_FAILURE);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_REJECT_TYPE) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_REJECT_TYPE))
+		die("Expr NFT_EXPR_REJECT_TYPE mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_REJECT_CODE) !=3D
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
+	a =3D nft_rule_alloc();
+	b =3D nft_rule_alloc();
+	if (a =3D=3D NULL || b =3D=3D NULL)
+		die("OOM");
+	ex =3D nft_rule_expr_alloc("ct");
+	if (ex =3D=3D NULL)
+		die("OOM");
+
+	nft_rule_expr_set_u32(ex, NFT_EXPR_REJECT_TYPE, 0x1234568);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_REJECT_CODE, 0x1234568);
+
+	nft_rule_add_expr(a, ex);
+
+	nlh =3D nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 12=
34);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a =3D nft_rule_expr_iter_create(a);
+	iter_b =3D nft_rule_expr_iter_create(b);
+	if (iter_a =3D=3D NULL || iter_b =3D=3D NULL)
+		die("OOM");
+
+	rule_a =3D nft_rule_expr_iter_next(iter_a);
+	rule_b =3D nft_rule_expr_iter_next(iter_b);
+	if (rule_a =3D=3D NULL || rule_b =3D=3D NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) !=3D NULL ||
+	    nft_rule_expr_iter_next(iter_b) !=3D NULL)
+		die("More 1 expr.");
+
+	nft_rule_expr_iter_destroy(iter_a);
+	nft_rule_expr_iter_destroy(iter_b);
+	nft_rule_free(a);
+	nft_rule_free(b);
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/nft-expr_target-test.c b/tests/nft-expr_target-test.=
c
new file mode 100644
index 0000000..756ab2d
--- /dev/null
+++ b/tests/nft-expr_target-test.c
@@ -0,0 +1,112 @@
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
+static void die(const char *msg)
+{
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+	exit(EXIT_FAILURE);
+}
+
+static void die2(const char *msg, uint32_t a, uint32_t b)
+{
+	printf("\033[31mERROR:\e[0m %s size a: %d b: %d \n",msg, a, b);
+	exit(EXIT_FAILURE);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	uint32_t lena, lenb;
+
+	if (strcmp(nft_rule_expr_get_str(rule_a, NFT_EXPR_TG_NAME),
+		   nft_rule_expr_get_str(rule_b, NFT_EXPR_TG_NAME)) !=3D 0)
+		die("Expr TG_NAME mismatches");
+
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_TG_REV) !=3D
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_TG_REV))
+		die("Expr TG_REV mismatches");
+
+	nft_rule_expr_get(rule_a, NFT_EXPR_TG_INFO, &lena);
+	nft_rule_expr_get(rule_b, NFT_EXPR_TG_INFO, &lenb);
+
+	/* TODO =C2=BFBUG? */
+	if (lena !=3D lenb)
+		die2("Expr TG_DATA size mismatches", lena, lenb);
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
+	a =3D nft_rule_alloc();
+	b =3D nft_rule_alloc();
+	if (a =3D=3D NULL || b =3D=3D NULL)
+		die("OOM");
+
+	ex =3D nft_rule_expr_alloc("target");
+	if (ex =3D=3D NULL)
+		die("OOM");
+	nft_rule_expr_set(ex, NFT_EXPR_TG_NAME, "LOG", strlen("LOG"));
+	nft_rule_expr_set_u32(ex, NFT_EXPR_TG_REV, 0x12345678);
+
+	info =3D calloc(1, sizeof(struct ipt_log_info));
+	if (info =3D=3D NULL)
+		die("OOM");
+	sprintf(info->prefix, "test: ");
+	info->prefix[sizeof(info->prefix)-1] =3D '\0';
+	info->logflags =3D 0x0f;
+	info->level =3D 5;
+	nft_rule_expr_set(ex, NFT_EXPR_TG_INFO, info, sizeof(*info));
+
+	nft_rule_add_expr(a, ex);
+
+	nlh =3D nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 12=
34);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	iter_a =3D nft_rule_expr_iter_create(a);
+	iter_b =3D nft_rule_expr_iter_create(b);
+	if (iter_a =3D=3D NULL || iter_b =3D=3D NULL)
+		die("OOM");
+
+	rule_a =3D nft_rule_expr_iter_next(iter_a);
+	rule_b =3D nft_rule_expr_iter_next(iter_b);
+	if (rule_a =3D=3D NULL || rule_b =3D=3D NULL)
+		die("OOM");
+
+	cmp_nft_rule_expr(rule_a, rule_b);
+
+	if (nft_rule_expr_iter_next(iter_a) !=3D NULL ||
+	    nft_rule_expr_iter_next(iter_b) !=3D NULL)
+		die("More 1 expr.");
+
+	nft_rule_expr_iter_destroy(iter_a);
+	nft_rule_expr_iter_destroy(iter_b);
+	nft_rule_free(a);
+	nft_rule_free(b);
+	/* BUG: leak memory
+	   =3D=3D28351=3D=3D HEAP SUMMARY:
+	 * =3D=3D28351=3D=3D     in use at exit: 436 bytes in 8 blocks
+	 * =3D=3D28351=3D=3D   total heap usage: 8 allocs, 0 frees, 436 bytes=
 allocated
+	*/
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/nft-rule-test.c b/tests/nft-rule-test.c
new file mode 100644
index 0000000..14044e6
--- /dev/null
+++ b/tests/nft-rule-test.c
@@ -0,0 +1,76 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <netinet/in.h>
+#include <linux/netfilter/nf_tables.h>
+#include <libnftables/rule.h>
+
+static void die(const char *msg)
+{
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+	exit(EXIT_FAILURE);
+}
+static void cmp_nft_rule(struct nft_rule *a, struct nft_rule *b)
+{
+	if (nft_rule_attr_get_u32(a, NFT_RULE_ATTR_FAMILY) !=3D
+	    nft_rule_attr_get_u32(b, NFT_RULE_ATTR_FAMILY))
+		die("Rule family mismatches");
+
+	if (strcmp(nft_rule_attr_get_str(a, NFT_RULE_ATTR_TABLE),
+		   nft_rule_attr_get_str(b, NFT_RULE_ATTR_TABLE)) !=3D 0)
+		die("Rule table mismatches");
+	if (strcmp(nft_rule_attr_get_str(a, NFT_RULE_ATTR_CHAIN),
+		   nft_rule_attr_get_str(b, NFT_RULE_ATTR_CHAIN)) !=3D 0)
+		die("Rule table mismatches");
+
+	if (nft_rule_attr_get_u64(a, NFT_RULE_ATTR_HANDLE) !=3D
+	    nft_rule_attr_get_u64(b, NFT_RULE_ATTR_HANDLE))
+		die("Rule handle mismatches");
+
+	if (nft_rule_attr_get_u32(a, NFT_RULE_ATTR_COMPAT_PROTO) !=3D
+	    nft_rule_attr_get_u32(b, NFT_RULE_ATTR_COMPAT_PROTO))
+		die("Rule compat_proto mismatches");
+
+	if (nft_rule_attr_get_u32(a, NFT_RULE_ATTR_COMPAT_FLAGS) !=3D
+	    nft_rule_attr_get_u32(b, NFT_RULE_ATTR_COMPAT_FLAGS))
+		die("Rule compat_flags mismatches");
+
+	if (nft_rule_attr_get_u64(a, NFT_RULE_ATTR_POSITION) !=3D
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
+	a =3D nft_rule_alloc();
+	b =3D nft_rule_alloc();
+	if (a =3D=3D NULL || b =3D=3D NULL)
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
+	nlh =3D nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 12=
34);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	cmp_nft_rule(a,b);
+
+	nft_rule_free(a);
+	nft_rule_free(b);
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/nft-set-test.c b/tests/nft-set-test.c
new file mode 100644
index 0000000..3ab439d
--- /dev/null
+++ b/tests/nft-set-test.c
@@ -0,0 +1,74 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <netinet/in.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include <libnftables/set.h>
+
+static void die(const char *msg)
+{
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+	exit(EXIT_FAILURE);
+}
+
+static void cmp_nft_set(struct nft_set *a, struct nft_set *b)
+{
+	if (strcmp(nft_set_attr_get_str(a, NFT_SET_ATTR_TABLE),
+		   nft_set_attr_get_str(b, NFT_SET_ATTR_TABLE)) !=3D 0)
+		die("Set table mismatches");
+	if (strcmp(nft_set_attr_get_str(a, NFT_SET_ATTR_NAME),
+		   nft_set_attr_get_str(b, NFT_SET_ATTR_NAME)) !=3D 0)
+		die("Set name mismatches");
+	if (nft_set_attr_get_u32(a, NFT_SET_ATTR_FLAGS) !=3D
+	    nft_set_attr_get_u32(b, NFT_SET_ATTR_FLAGS))
+		die("Set flags mismatches");
+	if (nft_set_attr_get_u32(a, NFT_SET_ATTR_KEY_TYPE) !=3D
+	    nft_set_attr_get_u32(b, NFT_SET_ATTR_KEY_TYPE))
+		die("Set key-type mismatches");
+	if (nft_set_attr_get_u32(a, NFT_SET_ATTR_KEY_LEN) !=3D
+	    nft_set_attr_get_u32(b, NFT_SET_ATTR_KEY_LEN))
+		die("Set key-len mismatches");
+	if (nft_set_attr_get_u32(a, NFT_SET_ATTR_DATA_TYPE) !=3D
+	    nft_set_attr_get_u32(b, NFT_SET_ATTR_DATA_TYPE))
+		die("Set data-type mismatches");
+	if (nft_set_attr_get_u32(a, NFT_SET_ATTR_DATA_LEN) !=3D
+	    nft_set_attr_get_u32(b, NFT_SET_ATTR_DATA_LEN))
+		die("Set data-len mismatches");
+}
+
+
+int main(int argc, char *argv[])
+{
+	struct nft_set *a, *b =3D NULL;
+	char buf[4096];
+	struct nlmsghdr *nlh;
+
+	a =3D nft_set_alloc();
+	b =3D nft_set_alloc();
+	if (a =3D=3D NULL || b =3D=3D NULL)
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
+	nlh =3D nft_set_nlmsg_build_hdr(buf, NFT_MSG_NEWSET, AF_INET, 0, 1234=
);
+	nft_set_nlmsg_build_payload(nlh, a);
+
+	if (nft_set_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	cmp_nft_set(a,b);
+
+	nft_set_free(a); nft_set_free(b);
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/nft-table-test.c b/tests/nft-table-test.c
new file mode 100644
index 0000000..3aebc89
--- /dev/null
+++ b/tests/nft-table-test.c
@@ -0,0 +1,64 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <netinet/in.h>
+
+#include <linux/netfilter/nf_tables.h>
+#include <libnftables/table.h>
+
+static void die(const char *msg)
+{
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+	exit(EXIT_FAILURE);
+}
+
+static void cmp_nft_table(struct nft_table *a, struct nft_table *b)
+{
+	if (strcmp(nft_table_attr_get_str(a, NFT_TABLE_ATTR_NAME),
+		   nft_table_attr_get_str(b, NFT_TABLE_ATTR_NAME)) !=3D 0)
+		die("table name mismatches");
+	if (nft_table_attr_get_u32(a, NFT_TABLE_ATTR_FLAGS) !=3D
+	    nft_table_attr_get_u32(b, NFT_TABLE_ATTR_FLAGS))
+		die("table flags mismatches");
+		/*
+		 * TODO nft_table_attr_get_u8
+		 * nft_table_atrr_set
+		 * NFT_TABLE_ATTR_FAMILY is uint8_t
+		 */
+	if (nft_table_attr_get_u32(a, NFT_TABLE_ATTR_FAMILY) !=3D
+	    nft_table_attr_get_u32(b, NFT_TABLE_ATTR_FAMILY))
+		die("tabke family mismatches");
+}
+
+int main(int argc, char *argv[])
+{
+	char buf[4096];
+	struct nlmsghdr *nlh;
+
+	struct nft_table *a =3D NULL;
+	struct nft_table *b =3D NULL;
+	a =3D nft_table_alloc();
+	b =3D nft_table_alloc();
+
+	if (a =3D=3D NULL || b =3D=3D NULL)
+		die("OOM");
+
+	nft_table_attr_set_str(a, NFT_TABLE_ATTR_NAME, "test");
+	nft_table_attr_set_u32(a, NFT_TABLE_ATTR_FAMILY, AF_INET);
+	nft_table_attr_set_u32(a, NFT_TABLE_ATTR_FLAGS, 0);
+
+	/* cmd extracted from include/linux/netfilter/nf_tables.h */
+	nlh =3D nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE, AF_INET, 0, =
1234);
+	nft_table_nlmsg_build_payload(nlh, a);
+
+	if (nft_table_nlmsg_parse(nlh, b) < 0)
+		die("parsing problems");
+
+	cmp_nft_table(a,b);
+
+	nft_table_free(a);
+	nft_table_free(b);
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/test-script.sh b/tests/test-script.sh
new file mode 100755
index 0000000..b5ef5f8
--- /dev/null
+++ b/tests/test-script.sh
@@ -0,0 +1,19 @@
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
+./nft-expr_target-test
+./nft-rule-test
+./nft-set-test
+./nft-table-test
--=20
1.8.4.rc3

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
