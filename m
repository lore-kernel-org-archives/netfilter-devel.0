From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] src: add range expression
Date: Thu, 13 Oct 2016 10:33:15 +0200
Message-ID: <1476347595-27604-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37632 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751171AbcJMIeR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Oct 2016 04:34:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0D51225D2F
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 10:33:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EBDC8DA84E
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 10:33:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BD651DA84C
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 10:33:27 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add range expression available that is scheduled for linux kernel 4.9.
This range expression allows us to check if a given value placed in a
register is within/outside a specified interval.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/expr.h             |   7 +
 include/linux/netfilter/nf_tables.h |  29 ++++
 src/Makefile.am                     |   1 +
 src/expr/range.c                    | 288 ++++++++++++++++++++++++++++++++++++
 src/expr_ops.c                      |   2 +
 tests/Makefile.am                   |   4 +
 tests/nft-expr_range-test.c         | 109 ++++++++++++++
 tests/test-script.sh                |   1 +
 8 files changed, 441 insertions(+)
 create mode 100644 src/expr/range.c
 create mode 100644 tests/nft-expr_range-test.c

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 4ce2592b1b50..edf86a966fc0 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -70,6 +70,13 @@ enum {
 };
 
 enum {
+	NFTNL_EXPR_RANGE_SREG	= NFTNL_EXPR_BASE,
+	NFTNL_EXPR_RANGE_OP,
+	NFTNL_EXPR_RANGE_FROM_DATA,
+	NFTNL_EXPR_RANGE_TO_DATA,
+};
+
+enum {
 	NFTNL_EXPR_IMM_DREG	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_IMM_DATA,
 	NFTNL_EXPR_IMM_VERDICT,
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 681082e68130..30e3b21418c5 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -546,6 +546,35 @@ enum nft_cmp_attributes {
 };
 #define NFTA_CMP_MAX		(__NFTA_CMP_MAX - 1)
 
+/**
+ * enum nft_range_ops - nf_tables range operator
+ *
+ * @NFT_RANGE_EQ: equal
+ * @NFT_RANGE_NEQ: not equal
+ */
+enum nft_range_ops {
+	NFT_RANGE_EQ,
+	NFT_RANGE_NEQ,
+};
+
+/**
+ * enum nft_range_attributes - nf_tables range expression netlink attributes
+ *
+ * @NFTA_RANGE_SREG: source register of data to compare (NLA_U32: nft_registers)
+ * @NFTA_RANGE_OP: cmp operation (NLA_U32: nft_cmp_ops)
+ * @NFTA_RANGE_FROM_DATA: data range from (NLA_NESTED: nft_data_attributes)
+ * @NFTA_RANGE_TO_DATA: data range to (NLA_NESTED: nft_data_attributes)
+ */
+enum nft_range_attributes {
+	NFTA_RANGE_UNSPEC,
+	NFTA_RANGE_SREG,
+	NFTA_RANGE_OP,
+	NFTA_RANGE_FROM_DATA,
+	NFTA_RANGE_TO_DATA,
+	__NFTA_RANGE_MAX
+};
+#define NFTA_RANGE_MAX         (__NFTA_RANGE_MAX - 1)
+
 enum nft_lookup_flags {
 	NFT_LOOKUP_F_INV = (1 << 0),
 };
diff --git a/src/Makefile.am b/src/Makefile.am
index 4ab8fcaff5ce..eac7a5678009 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -24,6 +24,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      expr/bitwise.c	\
 		      expr/byteorder.c	\
 		      expr/cmp.c	\
+		      expr/range.c	\
 		      expr/counter.c	\
 		      expr/ct.c		\
 		      expr/data_reg.c	\
diff --git a/src/expr/range.c b/src/expr/range.c
new file mode 100644
index 000000000000..1489d5849451
--- /dev/null
+++ b/src/expr/range.c
@@ -0,0 +1,288 @@
+/*
+ * (C) 2016 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include "internal.h"
+
+#include <stdio.h>
+#include <stdint.h>
+#include <string.h>
+#include <arpa/inet.h>
+#include <errno.h>
+
+#include <libmnl/libmnl.h>
+#include <linux/netfilter/nf_tables.h>
+#include <libnftnl/expr.h>
+#include <libnftnl/rule.h>
+
+struct nftnl_expr_range {
+	union nftnl_data_reg	data_from;
+	union nftnl_data_reg	data_to;
+	enum nft_registers	sreg;
+	enum nft_range_ops	op;
+};
+
+static int nftnl_expr_range_set(struct nftnl_expr *e, uint16_t type,
+				const void *data, uint32_t data_len)
+{
+	struct nftnl_expr_range *range = nftnl_expr_data(e);
+
+	switch(type) {
+	case NFTNL_EXPR_RANGE_SREG:
+		range->sreg = *((uint32_t *)data);
+		break;
+	case NFTNL_EXPR_RANGE_OP:
+		range->op = *((uint32_t *)data);
+		break;
+	case NFTNL_EXPR_RANGE_FROM_DATA:
+		memcpy(&range->data_from.val, data, data_len);
+		range->data_from.len = data_len;
+		break;
+	case NFTNL_EXPR_RANGE_TO_DATA:
+		memcpy(&range->data_to.val, data, data_len);
+		range->data_to.len = data_len;
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static const void *nftnl_expr_range_get(const struct nftnl_expr *e,
+					uint16_t type, uint32_t *data_len)
+{
+	struct nftnl_expr_range *range = nftnl_expr_data(e);
+
+	switch(type) {
+	case NFTNL_EXPR_RANGE_SREG:
+		*data_len = sizeof(range->sreg);
+		return &range->sreg;
+	case NFTNL_EXPR_RANGE_OP:
+		*data_len = sizeof(range->op);
+		return &range->op;
+	case NFTNL_EXPR_RANGE_FROM_DATA:
+		*data_len = range->data_from.len;
+		return &range->data_from.val;
+	case NFTNL_EXPR_RANGE_TO_DATA:
+		*data_len = range->data_to.len;
+		return &range->data_to.val;
+	}
+	return NULL;
+}
+
+static int nftnl_expr_range_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_RANGE_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch(type) {
+	case NFTA_RANGE_SREG:
+	case NFTA_RANGE_OP:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
+	case NFTA_RANGE_FROM_DATA:
+	case NFTA_RANGE_TO_DATA:
+		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static void
+nftnl_expr_range_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
+{
+	struct nftnl_expr_range *range = nftnl_expr_data(e);
+
+	if (e->flags & (1 << NFTNL_EXPR_RANGE_SREG))
+		mnl_attr_put_u32(nlh, NFTA_RANGE_SREG, htonl(range->sreg));
+	if (e->flags & (1 << NFTNL_EXPR_RANGE_OP))
+		mnl_attr_put_u32(nlh, NFTA_RANGE_OP, htonl(range->op));
+	if (e->flags & (1 << NFTNL_EXPR_RANGE_FROM_DATA)) {
+		struct nlattr *nest;
+
+		nest = mnl_attr_nest_start(nlh, NFTA_RANGE_FROM_DATA);
+		mnl_attr_put(nlh, NFTA_DATA_VALUE, range->data_from.len,
+			     range->data_from.val);
+		mnl_attr_nest_end(nlh, nest);
+	}
+	if (e->flags & (1 << NFTNL_EXPR_RANGE_TO_DATA)) {
+		struct nlattr *nest;
+
+		nest = mnl_attr_nest_start(nlh, NFTA_RANGE_TO_DATA);
+		mnl_attr_put(nlh, NFTA_DATA_VALUE, range->data_to.len,
+			     range->data_to.val);
+		mnl_attr_nest_end(nlh, nest);
+	}
+}
+
+static int
+nftnl_expr_range_parse(struct nftnl_expr *e, struct nlattr *attr)
+{
+	struct nftnl_expr_range *range = nftnl_expr_data(e);
+	struct nlattr *tb[NFTA_RANGE_MAX+1] = {};
+	int ret = 0;
+
+	if (mnl_attr_parse_nested(attr, nftnl_expr_range_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_RANGE_SREG]) {
+		range->sreg = ntohl(mnl_attr_get_u32(tb[NFTA_RANGE_SREG]));
+		e->flags |= (1 << NFTA_RANGE_SREG);
+	}
+	if (tb[NFTA_RANGE_OP]) {
+		range->op = ntohl(mnl_attr_get_u32(tb[NFTA_RANGE_OP]));
+		e->flags |= (1 << NFTA_RANGE_OP);
+	}
+	if (tb[NFTA_RANGE_FROM_DATA]) {
+		ret = nftnl_parse_data(&range->data_from,
+				       tb[NFTA_RANGE_FROM_DATA], NULL);
+		e->flags |= (1 << NFTA_RANGE_FROM_DATA);
+	}
+	if (tb[NFTA_RANGE_TO_DATA]) {
+		ret = nftnl_parse_data(&range->data_to,
+				       tb[NFTA_RANGE_TO_DATA], NULL);
+		e->flags |= (1 << NFTA_RANGE_TO_DATA);
+	}
+
+	return ret;
+}
+
+static char *expr_range_str[] = {
+	[NFT_RANGE_EQ]	= "eq",
+	[NFT_RANGE_NEQ]	= "neq",
+};
+
+static const char *range2str(uint32_t op)
+{
+	if (op > NFT_RANGE_NEQ)
+		return "unknown";
+
+	return expr_range_str[op];
+}
+
+static inline int nftnl_str2range(const char *op)
+{
+	if (strcmp(op, "eq") == 0)
+		return NFT_RANGE_EQ;
+	else if (strcmp(op, "neq") == 0)
+		return NFT_RANGE_NEQ;
+	else {
+		errno = EINVAL;
+		return -1;
+	}
+}
+
+static int nftnl_expr_range_json_parse(struct nftnl_expr *e, json_t *root,
+				       struct nftnl_parse_err *err)
+{
+#ifdef JSON_PARSING
+	struct nftnl_expr_range *range = nftnl_expr_data(e);
+	const char *op;
+	uint32_t uval32;
+	int base;
+
+	if (nftnl_jansson_parse_val(root, "sreg", NFTNL_TYPE_U32, &uval32,
+				  err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_RANGE_SREG, uval32);
+
+	op = nftnl_jansson_parse_str(root, "op", err);
+	if (op != NULL) {
+		base = nftnl_str2range(op);
+		if (base < 0)
+			return -1;
+
+		nftnl_expr_set_u32(e, NFTNL_EXPR_RANGE_OP, base);
+	}
+
+	if (nftnl_jansson_data_reg_parse(root, "data_from",
+					 &range->data_from, err) == DATA_VALUE)
+		e->flags |= (1 << NFTNL_EXPR_RANGE_FROM_DATA);
+
+	if (nftnl_jansson_data_reg_parse(root, "data_to",
+					 &range->data_to, err) == DATA_VALUE)
+		e->flags |= (1 << NFTNL_EXPR_RANGE_TO_DATA);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int nftnl_expr_range_export(char *buf, size_t size,
+				 const struct nftnl_expr *e, int type)
+{
+	struct nftnl_expr_range *range = nftnl_expr_data(e);
+	NFTNL_BUF_INIT(b, buf, size);
+
+	if (e->flags & (1 << NFTNL_EXPR_RANGE_SREG))
+		nftnl_buf_u32(&b, type, range->sreg, SREG);
+	if (e->flags & (1 << NFTNL_EXPR_RANGE_OP))
+		nftnl_buf_str(&b, type, range2str(range->op), OP);
+	if (e->flags & (1 << NFTNL_EXPR_RANGE_FROM_DATA))
+		nftnl_buf_reg(&b, type, &range->data_from, DATA_VALUE, DATA);
+	if (e->flags & (1 << NFTNL_EXPR_RANGE_TO_DATA))
+		nftnl_buf_reg(&b, type, &range->data_to, DATA_VALUE, DATA);
+
+	return nftnl_buf_done(&b);
+}
+
+static int nftnl_expr_range_snprintf_default(char *buf, size_t size,
+					   const struct nftnl_expr *e)
+{
+	struct nftnl_expr_range *range = nftnl_expr_data(e);
+	int len = size, offset = 0, ret;
+
+	ret = snprintf(buf, len, "%s reg %u ",
+		       expr_range_str[range->op], range->sreg);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = nftnl_data_reg_snprintf(buf + offset, len, &range->data_from,
+				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = nftnl_data_reg_snprintf(buf + offset, len, &range->data_to,
+				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+static int nftnl_expr_range_snprintf(char *buf, size_t size, uint32_t type,
+				     uint32_t flags, const struct nftnl_expr *e)
+{
+	switch (type) {
+	case NFTNL_OUTPUT_DEFAULT:
+		return nftnl_expr_range_snprintf_default(buf, size, e);
+	case NFTNL_OUTPUT_XML:
+	case NFTNL_OUTPUT_JSON:
+		return nftnl_expr_range_export(buf, size, e, type);
+	default:
+		break;
+	}
+	return -1;
+}
+
+struct expr_ops expr_ops_range = {
+	.name		= "range",
+	.alloc_len	= sizeof(struct nftnl_expr_range),
+	.max_attr	= NFTA_RANGE_MAX,
+	.set		= nftnl_expr_range_set,
+	.get		= nftnl_expr_range_get,
+	.parse		= nftnl_expr_range_parse,
+	.build		= nftnl_expr_range_build,
+	.snprintf	= nftnl_expr_range_snprintf,
+	.json_parse	= nftnl_expr_range_json_parse,
+};
diff --git a/src/expr_ops.c b/src/expr_ops.c
index 2a047d2bd18e..55748d64989a 100644
--- a/src/expr_ops.c
+++ b/src/expr_ops.c
@@ -22,6 +22,7 @@ extern struct expr_ops expr_ops_meta;
 extern struct expr_ops expr_ops_ng;
 extern struct expr_ops expr_ops_nat;
 extern struct expr_ops expr_ops_payload;
+extern struct expr_ops expr_ops_range;
 extern struct expr_ops expr_ops_redir;
 extern struct expr_ops expr_ops_reject;
 extern struct expr_ops expr_ops_queue;
@@ -49,6 +50,7 @@ static struct expr_ops *expr_ops[] = {
 	&expr_ops_ng,
 	&expr_ops_nat,
 	&expr_ops_payload,
+	&expr_ops_range,
 	&expr_ops_redir,
 	&expr_ops_reject,
 	&expr_ops_queue,
diff --git a/tests/Makefile.am b/tests/Makefile.am
index 99d29746e179..d51895974406 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -27,6 +27,7 @@ check_PROGRAMS = 	nft-parsing-test		\
 			nft-expr_nat-test		\
 			nft-expr_payload-test		\
 			nft-expr_queue-test		\
+			nft-expr_range-test             \
 			nft-expr_quota-test		\
 			nft-expr_redir-test		\
 			nft-expr_reject-test		\
@@ -108,6 +109,9 @@ nft_expr_queue_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 nft_expr_quota_test_SOURCES = nft-expr_quota-test.c
 nft_expr_quota_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
+nft_expr_range_test_SOURCES = nft-expr_range-test.c
+nft_expr_range_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
 nft_expr_reject_test_SOURCES = nft-expr_reject-test.c
 nft_expr_reject_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
diff --git a/tests/nft-expr_range-test.c b/tests/nft-expr_range-test.c
new file mode 100644
index 000000000000..b92dfc0b94e6
--- /dev/null
+++ b/tests/nft-expr_range-test.c
@@ -0,0 +1,109 @@
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
+static void range_nftnl_expr(struct nftnl_expr *rule_a,
+			     struct nftnl_expr *rule_b)
+{
+	uint32_t data_a, data_b;
+
+	nftnl_expr_get(rule_a, NFTNL_EXPR_RANGE_FROM_DATA, &data_a);
+	nftnl_expr_get(rule_b, NFTNL_EXPR_RANGE_FROM_DATA, &data_b);
+	if (data_a != data_b)
+		print_err("Size of NFTNL_EXPR_RANGE_FROM_DATA mismatches");
+	nftnl_expr_get(rule_a, NFTNL_EXPR_RANGE_TO_DATA, &data_a);
+	nftnl_expr_get(rule_b, NFTNL_EXPR_RANGE_TO_DATA, &data_b);
+	if (data_a != data_b)
+		print_err("Size of NFTNL_EXPR_RANGE_TO_DATA mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_RANGE_SREG) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_RANGE_SREG))
+		print_err("Expr NFTNL_EXPR_RANGE_SREG mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_RANGE_OP) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_RANGE_OP))
+		print_err("Expr NFTNL_EXPR_RANGE_OP mismatches");
+}
+
+int main(int argc, char *argv[])
+{
+	struct nftnl_rule *a, *b;
+	struct nftnl_expr *ex;
+	struct nlmsghdr *nlh;
+	char buf[4096];
+	struct nftnl_expr_iter *iter_a, *iter_b;
+	struct nftnl_expr *rule_a, *rule_b;
+	uint32_t data_a = 0x01010101, data_b = 0x02020202;
+
+	a = nftnl_rule_alloc();
+	b = nftnl_rule_alloc();
+	if (a == NULL || b == NULL)
+		print_err("OOM");
+	ex = nftnl_expr_alloc("range");
+	if (ex == NULL)
+		print_err("OOM");
+
+	nftnl_expr_set(ex, NFTNL_EXPR_RANGE_FROM_DATA,
+		       &data_a, sizeof(data_a));
+	nftnl_expr_set(ex, NFTNL_EXPR_RANGE_TO_DATA,
+		       &data_b, sizeof(data_b));
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_RANGE_SREG, 0x12345678);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_RANGE_OP, 0x78123456);
+
+	nftnl_rule_add_expr(a, ex);
+
+	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nftnl_rule_nlmsg_build_payload(nlh, a);
+
+	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
+		print_err("parsing problems");
+
+	iter_a = nftnl_expr_iter_create(a);
+	iter_b = nftnl_expr_iter_create(b);
+	if (iter_a == NULL || iter_b == NULL)
+		print_err("OOM");
+	rule_a = nftnl_expr_iter_next(iter_a);
+	rule_b = nftnl_expr_iter_next(iter_b);
+	if (rule_a == NULL || rule_b == NULL)
+		print_err("OOM");
+
+	range_nftnl_expr(rule_a, rule_b);
+
+	if (nftnl_expr_iter_next(iter_a) != NULL ||
+	    nftnl_expr_iter_next(iter_b) != NULL)
+		print_err("More 1 expr.");
+
+	nftnl_expr_iter_destroy(iter_a);
+	nftnl_expr_iter_destroy(iter_b);
+	nftnl_rule_free(a);
+	nftnl_rule_free(b);
+
+	if (!test_ok)
+		exit(EXIT_FAILURE);
+
+	printf("%s: \033[32mOK\e[0m\n", argv[0]);
+	return EXIT_SUCCESS;
+}
diff --git a/tests/test-script.sh b/tests/test-script.sh
index 1c93e93df71c..3244f802e1cb 100755
--- a/tests/test-script.sh
+++ b/tests/test-script.sh
@@ -16,6 +16,7 @@
 ./nft-expr_meta-test
 ./nft-expr_numgen-test
 ./nft-expr_queue-test
+./nft-expr_range-test
 ./nft-expr_redir-test
 ./nft-expr_nat-test
 ./nft-expr_payload-test
-- 
2.1.4

