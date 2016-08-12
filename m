From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH v2 libnftnl] expr: add hash expression
Date: Sat, 13 Aug 2016 01:02:03 +0200
Message-ID: <20160812230200.GA13974@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34310 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbcHLXCb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 19:02:31 -0400
Received: by mail-wm0-f68.google.com with SMTP id q128so62065wma.1
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 16:02:07 -0700 (PDT)
Received: from sonyv (128.red-176-84-210.dynamicip.rima-tde.net. [176.84.210.128])
        by smtp.gmail.com with ESMTPSA id g7sm9456525wjx.10.2016.08.12.16.02.05
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Fri, 12 Aug 2016 16:02:05 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Support for the nft hash expression in libnftnl.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 include/buffer.h                    |   2 +
 include/libnftnl/expr.h             |   8 +
 include/linux/netfilter/nf_tables.h |  21 +++
 src/Makefile.am                     |   1 +
 src/expr/hash.c                     | 294 ++++++++++++++++++++++++++++++++++++
 src/expr_ops.c                      |   2 +
 tests/Makefile.am                   |   6 +-
 tests/nft-expr_hash-test.c          | 102 +++++++++++++
 tests/test-script.sh                |   1 +
 9 files changed, 436 insertions(+), 1 deletion(-)
 create mode 100644 src/expr/hash.c
 create mode 100644 tests/nft-expr_hash-test.c

diff --git a/include/buffer.h b/include/buffer.h
index cc4bfbc..a753c78 100644
--- a/include/buffer.h
+++ b/include/buffer.h
@@ -89,5 +89,7 @@ int nftnl_buf_reg(struct nftnl_buf *b, int type, union nftnl_data_reg *reg,
 #define DELETE			"delete"
 #define REPLACE			"replace"
 #define FLUSH			"flush"
+#define MODULUS			"modulus"
+#define SEED			"seed"
 
 #endif
diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 57dfb34..b8e5d6d 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -197,6 +197,14 @@ enum {
 	NFTNL_EXPR_FWD_SREG_DEV = NFTNL_EXPR_BASE,
 };
 
+enum {
+	NFTNL_EXPR_HASH_SREG	= NFTNL_EXPR_BASE,
+	NFTNL_EXPR_HASH_DREG,
+	NFTNL_EXPR_HASH_LEN,
+	NFTNL_EXPR_HASH_MODULUS,
+	NFTNL_EXPR_HASH_SEED,
+};
+
 /*
  * Compat
  */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 0940631..a9a9b0b 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1109,4 +1109,25 @@ enum nft_trace_types {
 	__NFT_TRACETYPE_MAX
 };
 #define NFT_TRACETYPE_MAX (__NFT_TRACETYPE_MAX - 1)
+
+/**
+ * enum nft_hash_attributes - nf_tables hash expression attributes
+ *
+ * @NFTA_HASH_SREG: source register (NLA_U32)
+ * @NFTA_HASH_DREG: destination register (NLA_U32)
+ * @NFTA_HASH_LEN: data length (NLA_U32)
+ * @NFTA_HASH_MODULUS: Modulus value (NLA_U32)
+ * @NFTA_HASH_SEED: hash initial value (NLA_U32)
+ */
+enum nft_hash_attributes {
+	NFTA_HASH_UNSPEC,
+	NFTA_HASH_SREG,
+	NFTA_HASH_DREG,
+	NFTA_HASH_LEN,
+	NFTA_HASH_MODULUS,
+	NFTA_HASH_SEED,
+	__NFTA_HASH_MAX
+};
+#define NFTA_HASH_MAX		(__NFTA_HASH_MAX - 1)
+
 #endif /* _LINUX_NF_TABLES_H */
diff --git a/src/Makefile.am b/src/Makefile.am
index adc5ff0..44adc85 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -46,4 +46,5 @@ libnftnl_la_SOURCES = utils.c		\
 		      expr/target.c	\
 		      expr/masq.c	\
 		      expr/redir.c	\
+		      expr/hash.c	\
 		      libnftnl.map
diff --git a/src/expr/hash.c b/src/expr/hash.c
new file mode 100644
index 0000000..7309907
--- /dev/null
+++ b/src/expr/hash.c
@@ -0,0 +1,294 @@
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
+struct nftnl_expr_hash {
+	enum nft_registers	sreg;
+	enum nft_registers	dreg;
+	unsigned int		len;
+	unsigned int		modulus;
+	unsigned int		seed;
+};
+
+static int
+nftnl_expr_hash_set(struct nftnl_expr *e, uint16_t type,
+		    const void *data, uint32_t data_len)
+{
+	struct nftnl_expr_hash *hash = nftnl_expr_data(e);
+
+	switch (type) {
+	case NFTNL_EXPR_HASH_SREG:
+		hash->sreg = *((uint32_t *)data);
+		break;
+	case NFTNL_EXPR_HASH_DREG:
+		hash->dreg = *((uint32_t *)data);
+		break;
+	case NFTNL_EXPR_HASH_LEN:
+		hash->len = *((uint32_t *)data);
+		break;
+	case NFTNL_EXPR_HASH_MODULUS:
+		hash->modulus = *((uint32_t *)data);
+		break;
+	case NFTNL_EXPR_HASH_SEED:
+		hash->seed = *((uint32_t *)data);
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static const void *
+nftnl_expr_hash_get(const struct nftnl_expr *e, uint16_t type,
+		    uint32_t *data_len)
+{
+	struct nftnl_expr_hash *hash = nftnl_expr_data(e);
+
+	switch (type) {
+	case NFTNL_EXPR_HASH_SREG:
+		*data_len = sizeof(hash->sreg);
+		return &hash->sreg;
+	case NFTNL_EXPR_HASH_DREG:
+		*data_len = sizeof(hash->dreg);
+		return &hash->dreg;
+	case NFTNL_EXPR_HASH_LEN:
+		*data_len = sizeof(hash->len);
+		return &hash->len;
+	case NFTNL_EXPR_HASH_MODULUS:
+		*data_len = sizeof(hash->modulus);
+		return &hash->modulus;
+	case NFTNL_EXPR_HASH_SEED:
+		*data_len = sizeof(hash->seed);
+		return &hash->seed;
+	}
+	return NULL;
+}
+
+static int nftnl_expr_hash_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_HASH_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NFTA_HASH_SREG:
+	case NFTA_HASH_DREG:
+	case NFTA_HASH_LEN:
+	case NFTA_HASH_MODULUS:
+	case NFTA_HASH_SEED:
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
+nftnl_expr_hash_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
+{
+	struct nftnl_expr_hash *hash = nftnl_expr_data(e);
+
+	if (e->flags & (1 << NFTNL_EXPR_HASH_SREG))
+		mnl_attr_put_u32(nlh, NFTA_HASH_SREG, htonl(hash->sreg));
+	if (e->flags & (1 << NFTNL_EXPR_HASH_DREG))
+		mnl_attr_put_u32(nlh, NFTA_HASH_DREG, htonl(hash->dreg));
+	if (e->flags & (1 << NFTNL_EXPR_HASH_LEN))
+		mnl_attr_put_u32(nlh, NFTA_HASH_LEN, htonl(hash->len));
+	if (e->flags & (1 << NFTNL_EXPR_HASH_MODULUS))
+		mnl_attr_put_u32(nlh, NFTA_HASH_MODULUS, htonl(hash->modulus));
+	if (e->flags & (1 << NFTNL_EXPR_HASH_SEED))
+		mnl_attr_put_u32(nlh, NFTA_HASH_SEED, htonl(hash->seed));
+
+}
+
+static int
+nftnl_expr_hash_parse(struct nftnl_expr *e, struct nlattr *attr)
+{
+	struct nftnl_expr_hash *hash = nftnl_expr_data(e);
+	struct nlattr *tb[NFTA_HASH_MAX+1] = {};
+	int ret = 0;
+
+	if (mnl_attr_parse_nested(attr, nftnl_expr_hash_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_HASH_SREG]) {
+		hash->sreg = ntohl(mnl_attr_get_u32(tb[NFTA_HASH_SREG]));
+		e->flags |= (1 << NFTNL_EXPR_HASH_SREG);
+	}
+	if (tb[NFTA_HASH_DREG]) {
+		hash->dreg = ntohl(mnl_attr_get_u32(tb[NFTA_HASH_DREG]));
+		e->flags |= (1 << NFTNL_EXPR_HASH_DREG);
+	}
+	if (tb[NFTA_HASH_LEN]) {
+		hash->len = ntohl(mnl_attr_get_u32(tb[NFTA_HASH_LEN]));
+		e->flags |= (1 << NFTNL_EXPR_HASH_LEN);
+	}
+	if (tb[NFTA_HASH_MODULUS]) {
+		hash->modulus = ntohl(mnl_attr_get_u32(tb[NFTA_HASH_MODULUS]));
+		e->flags |= (1 << NFTNL_EXPR_HASH_MODULUS);
+	}
+	if (tb[NFTA_HASH_SEED]) {
+		hash->seed = ntohl(mnl_attr_get_u32(tb[NFTA_HASH_SEED]));
+		e->flags |= (1 << NFTNL_EXPR_HASH_SEED);
+	}
+
+	return ret;
+}
+
+static int nftnl_expr_hash_json_parse(struct nftnl_expr *e, json_t *root,
+				      struct nftnl_parse_err *err)
+{
+#ifdef JSON_PARSING
+	uint32_t sreg, dreg, len, modulus, seed;
+
+	if (nftnl_jansson_parse_reg(root, "sreg", NFTNL_TYPE_U32,
+				    &sreg, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_SREG, sreg);
+
+	if (nftnl_jansson_parse_reg(root, "dreg", NFTNL_TYPE_U32,
+				    &dreg, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_DREG, dreg);
+
+	if (nftnl_jansson_parse_val(root, "len", NFTNL_TYPE_U32,
+				    &len, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_LEN, len);
+
+	if (nftnl_jansson_parse_val(root, "modulus", NFTNL_TYPE_U32,
+				    &modulus, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_MODULUS, modulus);
+
+	if (nftnl_jansson_parse_val(root, "seed", NFTNL_TYPE_U32,
+				    &seed, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_SEED, seed);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+
+static int nftnl_expr_hash_xml_parse(struct nftnl_expr *e,
+				     mxml_node_t *tree,
+				     struct nftnl_parse_err *err)
+{
+#ifdef XML_PARSING
+	uint32_t sreg, dreg, len, modulus, seed;
+
+	if (nftnl_mxml_reg_parse(tree, "sreg", &sreg, MXML_DESCEND_FIRST,
+				 NFTNL_XML_MAND, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_SREG, sreg);
+
+	if (nftnl_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND_FIRST,
+				 NFTNL_XML_MAND, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_DREG, dreg);
+
+	if (nftnl_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_DEC,
+				 &len, NFTNL_TYPE_U32, NFTNL_XML_MAND,
+				 err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_LEN, len);
+
+	if (nftnl_mxml_num_parse(tree, "modulus", MXML_DESCEND_FIRST, BASE_DEC,
+				 &modulus, NFTNL_TYPE_U32, NFTNL_XML_MAND,
+				 err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_MODULUS, modulus);
+
+	if (nftnl_mxml_num_parse(tree, "seed", MXML_DESCEND_FIRST, BASE_DEC,
+				 &seed, NFTNL_TYPE_U32, NFTNL_XML_MAND,
+				 err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_SEED, seed);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
+nftnl_expr_hash_snprintf_default(char *buf, size_t size,
+				 const struct nftnl_expr *e)
+{
+	struct nftnl_expr_hash *hash = nftnl_expr_data(e);
+	int len = size, offset = 0, ret;
+
+	ret = snprintf(buf, len, "reg %u = jhash(reg %u, %u, %u) %% modulus %u",
+		       hash->dreg, hash->sreg, hash->len, hash->seed,
+		       hash->modulus);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+static int nftnl_expr_hash_export(char *buf, size_t size,
+				  const struct nftnl_expr *e, int type)
+{
+	struct nftnl_expr_hash *hash = nftnl_expr_data(e);
+
+	NFTNL_BUF_INIT(b, buf, size);
+
+	if (e->flags & (1 << NFTNL_EXPR_HASH_SREG))
+		nftnl_buf_u32(&b, type, hash->sreg, SREG);
+	if (e->flags & (1 << NFTNL_EXPR_HASH_DREG))
+		nftnl_buf_u32(&b, type, hash->dreg, DREG);
+	if (e->flags & (1 << NFTNL_EXPR_HASH_LEN))
+		nftnl_buf_u32(&b, type, hash->len, LEN);
+	if (e->flags & (1 << NFTNL_EXPR_HASH_MODULUS))
+		nftnl_buf_u32(&b, type, hash->modulus, MODULUS);
+	if (e->flags & (1 << NFTNL_EXPR_HASH_SEED))
+		nftnl_buf_u32(&b, type, hash->seed, SEED);
+
+	return nftnl_buf_done(&b);
+}
+
+static int
+nftnl_expr_hash_snprintf(char *buf, size_t len, uint32_t type,
+			 uint32_t flags, const struct nftnl_expr *e)
+{
+	switch (type) {
+	case NFTNL_OUTPUT_DEFAULT:
+		return nftnl_expr_hash_snprintf_default(buf, len, e);
+	case NFTNL_OUTPUT_XML:
+	case NFTNL_OUTPUT_JSON:
+		return nftnl_expr_hash_export(buf, len, e, type);
+	default:
+		break;
+	}
+	return -1;
+}
+
+struct expr_ops expr_ops_hash = {
+	.name		= "hash",
+	.alloc_len	= sizeof(struct nftnl_expr_hash),
+	.max_attr	= NFTA_HASH_MAX,
+	.set		= nftnl_expr_hash_set,
+	.get		= nftnl_expr_hash_get,
+	.parse		= nftnl_expr_hash_parse,
+	.build		= nftnl_expr_hash_build,
+	.snprintf	= nftnl_expr_hash_snprintf,
+	.xml_parse	= nftnl_expr_hash_xml_parse,
+	.json_parse	= nftnl_expr_hash_json_parse,
+};
diff --git a/src/expr_ops.c b/src/expr_ops.c
index c3b8474..7818b7e 100644
--- a/src/expr_ops.c
+++ b/src/expr_ops.c
@@ -27,6 +27,7 @@ extern struct expr_ops expr_ops_reject;
 extern struct expr_ops expr_ops_queue;
 extern struct expr_ops expr_ops_target;
 extern struct expr_ops expr_ops_dynset;
+extern struct expr_ops expr_ops_hash;
 
 static struct expr_ops *expr_ops[] = {
 	&expr_ops_bitwise,
@@ -52,6 +53,7 @@ static struct expr_ops *expr_ops[] = {
 	&expr_ops_queue,
 	&expr_ops_target,
 	&expr_ops_dynset,
+	&expr_ops_hash,
 	NULL,
 };
 
diff --git a/tests/Makefile.am b/tests/Makefile.am
index 0377081..86766f3 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -29,7 +29,8 @@ check_PROGRAMS = 	nft-parsing-test		\
 			nft-expr_queue-test		\
 			nft-expr_redir-test		\
 			nft-expr_reject-test		\
-			nft-expr_target-test
+			nft-expr_target-test		\
+			nft-expr_hash-test
 
 nft_parsing_test_SOURCES = nft-parsing-test.c
 nft_parsing_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS} ${LIBXML_LIBS} ${LIBJSON_LIBS}
@@ -108,3 +109,6 @@ nft_expr_redir_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
 nft_expr_target_test_SOURCES = nft-expr_target-test.c
 nft_expr_target_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
+nft_expr_hash_test_SOURCES = nft-expr_hash-test.c
+nft_expr_hash_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
diff --git a/tests/nft-expr_hash-test.c b/tests/nft-expr_hash-test.c
new file mode 100644
index 0000000..699197c
--- /dev/null
+++ b/tests/nft-expr_hash-test.c
@@ -0,0 +1,102 @@
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
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_HASH_SREG) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_HASH_SREG))
+		print_err("Expr NFTNL_EXPR_HASH_SREG mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_HASH_DREG) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_HASH_DREG))
+		print_err("Expr NFTNL_EXPR_HASH_DREG mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_HASH_MODULUS) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_HASH_MODULUS))
+		print_err("Expr NFTNL_EXPR_HASH_MODULUS mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_HASH_SEED) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_HASH_SEED))
+		print_err("Expr NFTNL_EXPR_HASH_SEED mismatches");
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
+	ex = nftnl_expr_alloc("hash");
+	if (ex == NULL)
+		print_err("OOM");
+
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_HASH_SREG, 0x1234568);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_HASH_DREG, 0x78123456);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_HASH_MODULUS, 0x78123456);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_HASH_SEED, 0x78123456);
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
diff --git a/tests/test-script.sh b/tests/test-script.sh
index ba13571..48f002f 100755
--- a/tests/test-script.sh
+++ b/tests/test-script.sh
@@ -20,6 +20,7 @@
 ./nft-expr_payload-test
 ./nft-expr_reject-test
 ./nft-expr_target-test
+./nft-expr_hash-test
 ./nft-rule-test
 ./nft-set-test
 ./nft-table-test
-- 
2.8.1

