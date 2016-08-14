From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH v2 libnftnl] expr: add number generation expression
Date: Sun, 14 Aug 2016 16:48:48 +0200
Message-ID: <20160814144842.GA21465@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34262 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbcHNOsx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Aug 2016 10:48:53 -0400
Received: by mail-wm0-f67.google.com with SMTP id q128so6683673wma.1
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Aug 2016 07:48:52 -0700 (PDT)
Received: from sonyv ([213.143.60.35])
        by smtp.gmail.com with ESMTPSA id ya1sm16966329wjb.23.2016.08.14.07.48.49
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Sun, 14 Aug 2016 07:48:50 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Support for the nft ng expression within libnftnl.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
Changes in V2:
	- Add test
	- Rename nth expression to numgen
	- Add support for types incremental and random

 include/buffer.h                    |   1 +
 include/libnftnl/expr.h             |   6 +
 include/linux/netfilter/nf_tables.h |  27 ++++
 src/Makefile.am                     |   1 +
 src/expr/numgen.c                   | 251 ++++++++++++++++++++++++++++++++++++
 src/expr_ops.c                      |   2 +
 tests/Makefile.am                   |   4 +
 tests/nft-expr_numgen-test.c        |  98 ++++++++++++++
 8 files changed, 390 insertions(+)
 create mode 100644 src/expr/numgen.c
 create mode 100644 tests/nft-expr_numgen-test.c

diff --git a/include/buffer.h b/include/buffer.h
index cc4bfbc..f83c3ba 100644
--- a/include/buffer.h
+++ b/include/buffer.h
@@ -82,6 +82,7 @@ int nftnl_buf_reg(struct nftnl_buf *b, int type, union nftnl_data_reg *reg,
 #define TOTAL			"total"
 #define TYPE			"type"
 #define UNIT			"unit"
+#define UNTIL			"until"
 #define USE			"use"
 #define XOR			"xor"
 #define ADD			"add"
diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 17f60bd..57dfb34 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -49,6 +49,12 @@ enum {
 };
 
 enum {
+	NFTNL_EXPR_NG_DREG	= NFTNL_EXPR_BASE,
+	NFTNL_EXPR_NG_UNTIL,
+	NFTNL_EXPR_NG_TYPE,
+};
+
+enum {
 	NFTNL_EXPR_META_KEY	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_META_DREG,
 	NFTNL_EXPR_META_SREG,
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 01751fa..de2979c 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -667,6 +667,33 @@ enum nft_exthdr_attributes {
 #define NFTA_EXTHDR_MAX		(__NFTA_EXTHDR_MAX - 1)
 
 /**
+ * enum nft_ng_attributes - nf_tables number generator expression attributes
+ *
+ * @NFTA_NG_DREG: destination register (NLA_U32)
+ * @NFTA_NG_UNTIL: limit value (NLA_U32)
+ * @NFTA_NG_TYPE: type of operation (NLA_U32)
+ */
+enum nft_ng_attributes {
+	NFTA_NG_UNSPEC,
+	NFTA_NG_DREG,
+	NFTA_NG_UNTIL,
+	NFTA_NG_TYPE,
+	__NFTA_NG_MAX
+};
+#define NFTA_NG_MAX		(__NFTA_NG_MAX - 1)
+
+/**
+ * enum nft_ng_type - nf_tables number generator expression reject types
+ *
+ * @NFT_NG_INCREMENTAL: Incremental number generator
+ * @NFT_NG_RANDOM: Random number generator
+ */
+enum nft_ng_type {
+	NFT_NG_INCREMENTAL,
+	NFT_NG_RANDOM
+};
+
+/**
  * enum nft_meta_keys - nf_tables meta expression keys
  *
  * @NFT_META_LEN: packet length (skb->len)
diff --git a/src/Makefile.am b/src/Makefile.am
index 7e580e4..a5d3f12 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -38,6 +38,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      expr/immediate.c	\
 		      expr/match.c	\
 		      expr/meta.c	\
+		      expr/numgen.c	\
 		      expr/nat.c	\
 		      expr/payload.c	\
 		      expr/queue.c	\
diff --git a/src/expr/numgen.c b/src/expr/numgen.c
new file mode 100644
index 0000000..0981d72
--- /dev/null
+++ b/src/expr/numgen.c
@@ -0,0 +1,251 @@
+/*
+ * (C) 2016 by Laura Garcia <nevola@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <stdio.h>
+#include <stdint.h>
+#include <string.h>
+#include <arpa/inet.h>
+#include <errno.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include "internal.h"
+#include <libmnl/libmnl.h>
+#include <libnftnl/expr.h>
+#include <libnftnl/rule.h>
+
+struct nftnl_expr_ng {
+	enum nft_registers	dreg;
+	unsigned int		until;
+	enum nft_ng_type	type;
+};
+
+static int
+nftnl_expr_ng_set(struct nftnl_expr *e, uint16_t type,
+		  const void *data, uint32_t data_len)
+{
+	struct nftnl_expr_ng *ng = nftnl_expr_data(e);
+
+	switch (type) {
+	case NFTNL_EXPR_NG_DREG:
+		ng->dreg = *((uint32_t *)data);
+		break;
+	case NFTNL_EXPR_NG_UNTIL:
+		ng->until = *((uint32_t *)data);
+		break;
+	case NFTNL_EXPR_NG_TYPE:
+		ng->type = *((uint32_t *)data);
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static const void *
+nftnl_expr_ng_get(const struct nftnl_expr *e, uint16_t type,
+		  uint32_t *data_len)
+{
+	struct nftnl_expr_ng *ng = nftnl_expr_data(e);
+
+	switch (type) {
+	case NFTNL_EXPR_NG_DREG:
+		*data_len = sizeof(ng->dreg);
+		return &ng->dreg;
+	case NFTNL_EXPR_NG_UNTIL:
+		*data_len = sizeof(ng->until);
+		return &ng->until;
+	case NFTNL_EXPR_NG_TYPE:
+		*data_len = sizeof(ng->type);
+		return &ng->type;
+	}
+	return NULL;
+}
+
+static int nftnl_expr_ng_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_NG_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NFTA_NG_DREG:
+	case NFTA_NG_UNTIL:
+	case NFTA_NG_TYPE:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static void
+nftnl_expr_ng_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
+{
+	struct nftnl_expr_ng *ng = nftnl_expr_data(e);
+
+	if (e->flags & (1 << NFTNL_EXPR_NG_DREG))
+		mnl_attr_put_u32(nlh, NFTA_NG_DREG, htonl(ng->dreg));
+	if (e->flags & (1 << NFTNL_EXPR_NG_UNTIL))
+		mnl_attr_put_u32(nlh, NFTA_NG_UNTIL, htonl(ng->until));
+	if (e->flags & (1 << NFTNL_EXPR_NG_TYPE))
+		mnl_attr_put_u32(nlh, NFTA_NG_TYPE, htonl(ng->type));
+}
+
+static int
+nftnl_expr_ng_parse(struct nftnl_expr *e, struct nlattr *attr)
+{
+	struct nftnl_expr_ng *ng = nftnl_expr_data(e);
+	struct nlattr *tb[NFTA_NG_MAX+1] = {};
+	int ret = 0;
+
+	if (mnl_attr_parse_nested(attr, nftnl_expr_ng_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_NG_DREG]) {
+		ng->dreg = ntohl(mnl_attr_get_u32(tb[NFTA_NG_DREG]));
+		e->flags |= (1 << NFTNL_EXPR_NG_DREG);
+	}
+	if (tb[NFTA_NG_UNTIL]) {
+		ng->until = ntohl(mnl_attr_get_u32(tb[NFTA_NG_UNTIL]));
+		e->flags |= (1 << NFTNL_EXPR_NG_UNTIL);
+	}
+	if (tb[NFTA_NG_TYPE]) {
+		ng->type = ntohl(mnl_attr_get_u32(tb[NFTA_NG_TYPE]));
+		e->flags |= (1 << NFTNL_EXPR_NG_TYPE);
+	}
+
+	return ret;
+}
+
+static int nftnl_expr_ng_json_parse(struct nftnl_expr *e, json_t *root,
+				    struct nftnl_parse_err *err)
+{
+#ifdef JSON_PARSING
+	uint32_t dreg, until, type;
+
+	if (nftnl_jansson_parse_reg(root, "dreg", NFTNL_TYPE_U32,
+				    &dreg, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_DREG, dreg);
+
+	if (nftnl_jansson_parse_val(root, "until", NFTNL_TYPE_U32,
+				    &until, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_UNTIL, until);
+
+	if (nftnl_jansson_parse_val(root, "type", NFTNL_TYPE_U32,
+				    &type, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_TYPE, type);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+
+static int nftnl_expr_ng_xml_parse(struct nftnl_expr *e,
+				   mxml_node_t *tree,
+				   struct nftnl_parse_err *err)
+{
+#ifdef XML_PARSING
+	uint32_t dreg, until, type;
+
+	if (nftnl_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND_FIRST,
+				 NFTNL_XML_MAND, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_DREG, dreg);
+
+	if (nftnl_mxml_num_parse(tree, "until", MXML_DESCEND_FIRST, BASE_DEC,
+				 &until, NFTNL_TYPE_U32, NFTNL_XML_MAND,
+				 err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_UNTIL, until);
+
+	if (nftnl_mxml_num_parse(tree, "type", MXML_DESCEND_FIRST, BASE_DEC,
+				 &type, NFTNL_TYPE_U32, NFTNL_XML_MAND,
+				 err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_TYPE, type);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
+nftnl_expr_ng_snprintf_default(char *buf, size_t size,
+			       const struct nftnl_expr *e)
+{
+	struct nftnl_expr_ng *ng = nftnl_expr_data(e);
+	int len = size, offset = 0, ret;
+
+	if (ng->type == NFT_NG_INCREMENTAL) {
+		ret = snprintf(buf, len, "reg %u = inc(%u)", ng->dreg,
+			       ng->until);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (ng->type == NFT_NG_RANDOM) {
+		ret = snprintf(buf, len, "reg %u = random(%u)", ng->dreg,
+			       ng->until);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
+}
+
+static int nftnl_expr_ng_export(char *buf, size_t size,
+				const struct nftnl_expr *e, int type)
+{
+	struct nftnl_expr_ng *ng = nftnl_expr_data(e);
+
+	NFTNL_BUF_INIT(b, buf, size);
+
+	if (e->flags & (1 << NFTNL_EXPR_NG_DREG))
+		nftnl_buf_u32(&b, type, ng->dreg, DREG);
+	if (e->flags & (1 << NFTNL_EXPR_NG_UNTIL))
+		nftnl_buf_u32(&b, type, ng->until, UNTIL);
+	if (e->flags & (1 << NFTNL_EXPR_NG_TYPE))
+		nftnl_buf_u32(&b, type, ng->type, TYPE);
+
+	return nftnl_buf_done(&b);
+}
+
+static int
+nftnl_expr_ng_snprintf(char *buf, size_t len, uint32_t type,
+		       uint32_t flags, const struct nftnl_expr *e)
+{
+	switch (type) {
+	case NFTNL_OUTPUT_DEFAULT:
+		return nftnl_expr_ng_snprintf_default(buf, len, e);
+	case NFTNL_OUTPUT_XML:
+	case NFTNL_OUTPUT_JSON:
+		return nftnl_expr_ng_export(buf, len, e, type);
+	default:
+		break;
+	}
+	return -1;
+}
+
+struct expr_ops expr_ops_ng = {
+	.name		= "numgen",
+	.alloc_len	= sizeof(struct nftnl_expr_ng),
+	.max_attr	= NFTA_NG_MAX,
+	.set		= nftnl_expr_ng_set,
+	.get		= nftnl_expr_ng_get,
+	.parse		= nftnl_expr_ng_parse,
+	.build		= nftnl_expr_ng_build,
+	.snprintf	= nftnl_expr_ng_snprintf,
+	.xml_parse	= nftnl_expr_ng_xml_parse,
+	.json_parse	= nftnl_expr_ng_json_parse,
+};
diff --git a/src/expr_ops.c b/src/expr_ops.c
index ae515af..c3b8474 100644
--- a/src/expr_ops.c
+++ b/src/expr_ops.c
@@ -19,6 +19,7 @@ extern struct expr_ops expr_ops_lookup;
 extern struct expr_ops expr_ops_masq;
 extern struct expr_ops expr_ops_match;
 extern struct expr_ops expr_ops_meta;
+extern struct expr_ops expr_ops_ng;
 extern struct expr_ops expr_ops_nat;
 extern struct expr_ops expr_ops_payload;
 extern struct expr_ops expr_ops_redir;
@@ -43,6 +44,7 @@ static struct expr_ops *expr_ops[] = {
 	&expr_ops_masq,
 	&expr_ops_match,
 	&expr_ops_meta,
+	&expr_ops_ng,
 	&expr_ops_nat,
 	&expr_ops_payload,
 	&expr_ops_redir,
diff --git a/tests/Makefile.am b/tests/Makefile.am
index 0377081..54fa2aa 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -24,6 +24,7 @@ check_PROGRAMS = 	nft-parsing-test		\
 			nft-expr_match-test		\
 			nft-expr_masq-test		\
 			nft-expr_meta-test		\
+			nft-expr_numgen-test		\
 			nft-expr_nat-test		\
 			nft-expr_payload-test		\
 			nft-expr_queue-test		\
@@ -91,6 +92,9 @@ nft_expr_masq_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 nft_expr_meta_test_SOURCES = nft-expr_meta-test.c
 nft_expr_meta_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
+nft_expr_numgen_test_SOURCES = nft-expr_numgen-test.c
+nft_expr_numgen_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
 nft_expr_nat_test_SOURCES = nft-expr_nat-test.c
 nft_expr_nat_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
diff --git a/tests/nft-expr_numgen-test.c b/tests/nft-expr_numgen-test.c
new file mode 100644
index 0000000..b78ee76
--- /dev/null
+++ b/tests/nft-expr_numgen-test.c
@@ -0,0 +1,98 @@
+/*
+ * (C) 2016 by Laura Garcia <nevola@gmail.com>
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
+
+static void print_err(const char *msg)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+}
+
+static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
+			      struct nftnl_expr *rule_b)
+{
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_NG_DREG) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_NG_DREG))
+		print_err("Expr NFTNL_EXPR_NG_DREG mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_NG_UNTIL) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_NG_UNTIL))
+		print_err("Expr NFTNL_EXPR_NG_UNTIL mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_NG_TYPE) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_NG_TYPE))
+		print_err("Expr NFTNL_EXPR_NG_TYPE mismatches");
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
+
+	a = nftnl_rule_alloc();
+	b = nftnl_rule_alloc();
+	if (a == NULL || b == NULL)
+		print_err("OOM");
+	ex = nftnl_expr_alloc("numgen");
+	if (ex == NULL)
+		print_err("OOM");
+
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_NG_DREG, 0x1234568);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_NG_UNTIL, 0x78123456);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_NG_TYPE, NFT_NG_INCREMENTAL);
+
+	nftnl_rule_add_expr(a, ex);
+
+	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nftnl_rule_nlmsg_build_payload(nlh, a);
+	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
+		print_err("parsing problems");
+
+	iter_a = nftnl_expr_iter_create(a);
+	iter_b = nftnl_expr_iter_create(b);
+	if (iter_a == NULL || iter_b == NULL)
+		print_err("OOM");
+
+	rule_a = nftnl_expr_iter_next(iter_a);
+	rule_b = nftnl_expr_iter_next(iter_b);
+	if (rule_a == NULL || rule_b == NULL)
+		print_err("OOM");
+
+	cmp_nftnl_expr(rule_a, rule_b);
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
-- 
2.8.1

