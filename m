From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 1/3] expr: add dup expression support
Date: Mon, 17 Aug 2015 04:24:16 +0200
Message-ID: <1439778258-7546-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55859 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823AbbHQCSY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Aug 2015 22:18:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/expr.h             |    5 +
 include/linux/netfilter/nf_tables.h |   14 +++
 src/Makefile.am                     |    1 +
 src/expr/dup.c                      |  220 +++++++++++++++++++++++++++++++++++
 src/expr_ops.c                      |    2 +
 tests/Makefile.am                   |    4 +
 tests/nft-expr_dup-test.c           |   94 +++++++++++++++
 7 files changed, 340 insertions(+)
 create mode 100644 src/expr/dup.c
 create mode 100644 tests/nft-expr_dup-test.c

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 59ae2d7..91875ff 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -173,6 +173,11 @@ enum {
 	NFT_EXPR_REDIR_FLAGS,
 };
 
+enum {
+	NFT_EXPR_DUP_SREG_ADDR		= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_DUP_SREG_DEV,
+};
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index a99e6a9..cf4a1ce 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -936,6 +936,20 @@ enum nft_redir_attributes {
 #define NFTA_REDIR_MAX		(__NFTA_REDIR_MAX - 1)
 
 /**
+ * enum nft_tee_attributes - nf_tables tee expression netlink attributes
+ *
+ * @NFTA_DUP_SREG_ADDR: source register of destination (NLA_U32: nft_registers)
+ * @NFTA_DUP_SREG_DEV: output interface name (NLA_U32: nft_register)
+ */
+enum nft_tee_attributes {
+	NFTA_DUP_UNSPEC,
+	NFTA_DUP_SREG_ADDR,
+	NFTA_DUP_SREG_DEV,
+	__NFTA_DUP_MAX
+};
+#define NFTA_DUP_MAX		(__NFTA_DUP_MAX - 1)
+
+/**
  * enum nft_gen_attributes - nf_tables ruleset generation attributes
  *
  * @NFTA_GEN_ID: Ruleset generation ID (NLA_U32)
diff --git a/src/Makefile.am b/src/Makefile.am
index dd87240..107cae5 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -26,6 +26,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      expr/counter.c	\
 		      expr/ct.c		\
 		      expr/data_reg.c	\
+		      expr/dup.c	\
 		      expr/exthdr.c	\
 		      expr/limit.c	\
 		      expr/log.c	\
diff --git a/src/expr/dup.c b/src/expr/dup.c
new file mode 100644
index 0000000..3617fe3
--- /dev/null
+++ b/src/expr/dup.c
@@ -0,0 +1,220 @@
+/*
+ * (C) 2015 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <stdio.h>
+#include <stdint.h>
+#include <string.h>
+#include <arpa/inet.h>
+#include <errno.h>
+#include "internal.h"
+#include <libmnl/libmnl.h>
+#include <linux/netfilter/nf_tables.h>
+#include <libnftnl/expr.h>
+#include <libnftnl/rule.h>
+#include "expr_ops.h"
+#include "data_reg.h"
+#include <buffer.h>
+
+struct nft_expr_dup {
+	enum nft_registers	sreg_addr;
+	enum nft_registers	sreg_dev;
+};
+
+static int nft_rule_expr_dup_set(struct nft_rule_expr *e, uint16_t type,
+				 const void *data, uint32_t data_len)
+{
+	struct nft_expr_dup *dup = nft_expr_data(e);
+
+	switch (type) {
+	case NFT_EXPR_DUP_SREG_ADDR:
+		dup->sreg_addr = *((uint32_t *)data);
+		break;
+	case NFT_EXPR_DUP_SREG_DEV:
+		dup->sreg_dev= *((uint32_t *)data);
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static const void *nft_rule_expr_dup_get(const struct nft_rule_expr *e,
+					 uint16_t type, uint32_t *data_len)
+{
+	struct nft_expr_dup *dup = nft_expr_data(e);
+
+	switch (type) {
+	case NFT_EXPR_DUP_SREG_ADDR:
+		*data_len = sizeof(dup->sreg_addr);
+		return &dup->sreg_addr;
+	case NFT_EXPR_DUP_SREG_DEV:
+		*data_len = sizeof(dup->sreg_dev);
+		return &dup->sreg_dev;
+	}
+	return NULL;
+}
+
+static int nft_rule_expr_dup_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_DUP_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NFTA_DUP_SREG_ADDR:
+	case NFTA_DUP_SREG_DEV:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static void nft_rule_expr_dup_build(struct nlmsghdr *nlh,
+				    struct nft_rule_expr *e)
+{
+	struct nft_expr_dup *dup = nft_expr_data(e);
+
+	if (e->flags & (1 << NFT_EXPR_DUP_SREG_ADDR))
+		mnl_attr_put_u32(nlh, NFTA_DUP_SREG_ADDR, htonl(dup->sreg_addr));
+	if (e->flags & (1 << NFT_EXPR_DUP_SREG_DEV))
+		mnl_attr_put_u32(nlh, NFTA_DUP_SREG_DEV, htonl(dup->sreg_dev));
+}
+
+static int nft_rule_expr_dup_parse(struct nft_rule_expr *e, struct nlattr *attr)
+{
+	struct nft_expr_dup *dup = nft_expr_data(e);
+	struct nlattr *tb[NFTA_DUP_MAX + 1] = {};
+	int ret = 0;
+
+	if (mnl_attr_parse_nested(attr, nft_rule_expr_dup_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_DUP_SREG_ADDR]) {
+		dup->sreg_addr = ntohl(mnl_attr_get_u32(tb[NFTA_DUP_SREG_ADDR]));
+		e->flags |= (1 << NFT_EXPR_DUP_SREG_ADDR);
+	}
+	if (tb[NFTA_DUP_SREG_DEV]) {
+		dup->sreg_dev = ntohl(mnl_attr_get_u32(tb[NFTA_DUP_SREG_DEV]));
+		e->flags |= (1 << NFT_EXPR_DUP_SREG_DEV);
+	}
+
+	return ret;
+}
+
+static int nft_rule_expr_dup_json_parse(struct nft_rule_expr *e, json_t *root,
+					struct nft_parse_err *err)
+{
+#ifdef JSON_PARSING
+	struct nft_expr_dup *dup = nft_expr_data(e);
+	uint32_t sreg_addr, sreg_dev;
+	int datareg_type;
+
+	ret = nft_jansson_parse_val(root, "sreg_addr", NFT_TYPE_U32, &sreg_addr, err);
+	if (ret >= 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_DUP_SREG_DEV, sreg_addr);
+	ret = nft_jansson_parse_val(root, "sreg_dev", NFT_TYPE_U32, &sreg_dev, err);
+	if (ret >= 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_DUP_SREG_DEV, sreg_dev);
+
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int nft_rule_expr_dup_xml_parse(struct nft_rule_expr *e,
+				       mxml_node_t *tree,
+				       struct nft_parse_err *err)
+{
+#ifdef XML_PARSING
+	struct nft_expr_dup *dup = nft_expr_data(e);
+	uint32_t sreg_addr, sreg_dev;
+
+	if (nft_mxml_reg_parse(tree, "sreg_addr", &sreg_addr, MXML_DESCEND_FIRST,
+			       NFT_XML_OPT, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_DUP_SREG_ADDR, sreg_addr);
+	if (nft_mxml_reg_parse(tree, "sreg_dev", &sreg_dev, MXML_DESCEND_FIRST,
+			       NFT_XML_OPT, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_DUP_SREG_DEV, sreg_dev);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int nft_rule_expr_dup_export(char *buf, size_t size,
+				    struct nft_rule_expr *e, int type)
+{
+	struct nft_expr_dup *dup = nft_expr_data(e);
+	NFT_BUF_INIT(b, buf, size);
+
+	if (e->flags & (1 << NFT_EXPR_DUP_SREG_ADDR))
+		nft_buf_u32(&b, type, dup->sreg_addr, "sreg_addr");
+	if (e->flags & (1 << NFT_EXPR_DUP_SREG_DEV))
+		nft_buf_u32(&b, type, dup->sreg_addr, "sreg_dev");
+
+	return nft_buf_done(&b);
+}
+
+static int nft_rule_expr_dup_snprintf_default(char *buf, size_t len,
+					      struct nft_rule_expr *e,
+					      uint32_t flags)
+{
+	int size = len, offset = 0, ret;
+	struct nft_expr_dup *dup = nft_expr_data(e);
+
+	if (e->flags & (1 << NFT_EXPR_DUP_SREG_ADDR)) {
+		ret = snprintf(buf + offset, len, "sreg_addr %u", dup->sreg_addr);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (e->flags & (1 << NFT_EXPR_DUP_SREG_DEV)) {
+		ret = snprintf(buf + offset, len, "sreg_dev %u", dup->sreg_dev);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
+}
+
+static int nft_rule_expr_dup_snprintf(char *buf, size_t len, uint32_t type,
+				      uint32_t flags, struct nft_rule_expr *e)
+{
+	switch (type) {
+	case NFT_OUTPUT_DEFAULT:
+		return nft_rule_expr_dup_snprintf_default(buf, len, e, flags);
+	case NFT_OUTPUT_XML:
+	case NFT_OUTPUT_JSON:
+		return nft_rule_expr_dup_export(buf, len, e, type);
+	default:
+		break;
+	}
+	return -1;
+}
+
+struct expr_ops expr_ops_dup = {
+	.name		= "dup",
+	.alloc_len	= sizeof(struct nft_expr_dup),
+	.max_attr	= NFTA_DUP_MAX,
+	.set		= nft_rule_expr_dup_set,
+	.get		= nft_rule_expr_dup_get,
+	.parse		= nft_rule_expr_dup_parse,
+	.build		= nft_rule_expr_dup_build,
+	.snprintf	= nft_rule_expr_dup_snprintf,
+	.xml_parse	= nft_rule_expr_dup_xml_parse,
+	.json_parse	= nft_rule_expr_dup_json_parse,
+};
diff --git a/src/expr_ops.c b/src/expr_ops.c
index 2de5805..c93d7de 100644
--- a/src/expr_ops.c
+++ b/src/expr_ops.c
@@ -9,6 +9,7 @@ extern struct expr_ops expr_ops_byteorder;
 extern struct expr_ops expr_ops_cmp;
 extern struct expr_ops expr_ops_counter;
 extern struct expr_ops expr_ops_ct;
+extern struct expr_ops expr_ops_dup;
 extern struct expr_ops expr_ops_exthdr;
 extern struct expr_ops expr_ops_immediate;
 extern struct expr_ops expr_ops_limit;
@@ -31,6 +32,7 @@ static struct expr_ops *expr_ops[] = {
 	&expr_ops_cmp,
 	&expr_ops_counter,
 	&expr_ops_ct,
+	&expr_ops_dup,
 	&expr_ops_exthdr,
 	&expr_ops_immediate,
 	&expr_ops_limit,
diff --git a/tests/Makefile.am b/tests/Makefile.am
index c0356f1..51403e5 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -14,6 +14,7 @@ check_PROGRAMS = 	nft-parsing-test		\
 			nft-expr_counter-test		\
 			nft-expr_cmp-test		\
 			nft-expr_ct-test		\
+			nft-expr_dup-test		\
 			nft-expr_exthdr-test		\
 			nft-expr_immediate-test		\
 			nft-expr_limit-test		\
@@ -62,6 +63,9 @@ nft_expr_exthdr_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 nft_expr_ct_test_SOURCES = nft-expr_ct-test.c
 nft_expr_ct_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
+nft_expr_dup_test_SOURCES = nft-expr_dup-test.c
+nft_expr_dup_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
 nft_expr_immediate_test_SOURCES = nft-expr_counter-test.c
 nft_expr_immediate_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
diff --git a/tests/nft-expr_dup-test.c b/tests/nft-expr_dup-test.c
new file mode 100644
index 0000000..ed060af
--- /dev/null
+++ b/tests/nft-expr_dup-test.c
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
+#include <libnftnl/rule.h>
+#include <libnftnl/expr.h>
+
+static int test_ok = 1;
+static void print_err(const char *msg)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_DUP_SREG_ADDR) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_DUP_SREG_ADDR))
+		print_err("Expr SREG_TO mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_DUP_SREG_DEV) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_DUP_SREG_DEV))
+		print_err("Expr SREG_OIF mismatches");
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
+	ex = nft_rule_expr_alloc("dup");
+	if (ex == NULL)
+		print_err("OOM");
+
+	nft_rule_expr_set_u32(ex, NFT_EXPR_DUP_SREG_ADDR, 0x12345678);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_DUP_SREG_DEV,  0x78123456);
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
1.7.10.4

