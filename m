From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] expr: add forward expression
Date: Mon, 11 Jan 2016 19:43:01 +0100
Message-ID: <1452537781-15466-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49710 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933143AbcAKSnJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jan 2016 13:43:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C4659E3A05
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jan 2016 19:43:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B1383DA804
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jan 2016 19:43:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7FD95DA804
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jan 2016 19:43:05 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add forward expression for the netdev family.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/expr.h             |   4 +
 include/linux/netfilter/nf_tables.h |  12 +++
 src/Makefile.am                     |   1 +
 src/expr/fwd.c                      | 187 ++++++++++++++++++++++++++++++++++++
 src/expr_ops.c                      |   2 +
 tests/Makefile.am                   |   4 +
 tests/nft-expr_fwd-test.c           |  90 +++++++++++++++++
 7 files changed, 300 insertions(+)
 create mode 100644 src/expr/fwd.c
 create mode 100644 tests/nft-expr_fwd-test.c

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index ab2c5ba..7093759 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -183,6 +183,10 @@ enum {
 	NFTNL_EXPR_DUP_SREG_DEV,
 };
 
+enum {
+	NFTNL_EXPR_FWD_SREG_DEV = NFTNL_EXPR_BASE,
+};
+
 /*
  * Compat
  */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index f77693b..27baeca 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -978,6 +978,18 @@ enum nft_dup_attributes {
 #define NFTA_DUP_MAX		(__NFTA_DUP_MAX - 1)
 
 /**
+ * enum nft_fwd_attributes - nf_tables fwd expression netlink attributes
+ *
+ * @NFTA_FWD_SREG_DEV: output interface name (NLA_U32: nft_register)
+ */
+enum nft_fwd_attributes {
+	NFTA_FWD_UNSPEC,
+	NFTA_FWD_SREG_DEV,
+	__NFTA_FWD_MAX
+};
+#define NFTA_FWD_MAX	(__NFTA_FWD_MAX - 1)
+
+/**
  * enum nft_gen_attributes - nf_tables ruleset generation attributes
  *
  * @NFTA_GEN_ID: Ruleset generation ID (NLA_U32)
diff --git a/src/Makefile.am b/src/Makefile.am
index 795307d..a27e292 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -29,6 +29,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      expr/data_reg.c	\
 		      expr/dup.c	\
 		      expr/exthdr.c	\
+		      expr/fwd.c	\
 		      expr/limit.c	\
 		      expr/log.c	\
 		      expr/lookup.c	\
diff --git a/src/expr/fwd.c b/src/expr/fwd.c
new file mode 100644
index 0000000..1131c10
--- /dev/null
+++ b/src/expr/fwd.c
@@ -0,0 +1,187 @@
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
+struct nftnl_expr_fwd {
+	enum nft_registers	sreg_dev;
+};
+
+static int nftnl_expr_fwd_set(struct nftnl_expr *e, uint16_t type,
+				  const void *data, uint32_t data_len)
+{
+	struct nftnl_expr_fwd *fwd = nftnl_expr_data(e);
+
+	switch (type) {
+	case NFTNL_EXPR_FWD_SREG_DEV:
+		fwd->sreg_dev= *((uint32_t *)data);
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static const void *nftnl_expr_fwd_get(const struct nftnl_expr *e,
+				      uint16_t type, uint32_t *data_len)
+{
+	struct nftnl_expr_fwd *fwd = nftnl_expr_data(e);
+
+	switch (type) {
+	case NFTNL_EXPR_FWD_SREG_DEV:
+		*data_len = sizeof(fwd->sreg_dev);
+		return &fwd->sreg_dev;
+	}
+	return NULL;
+}
+
+static int nftnl_expr_fwd_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_FWD_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NFTA_FWD_SREG_DEV:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static void nftnl_expr_fwd_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
+{
+	struct nftnl_expr_fwd *fwd = nftnl_expr_data(e);
+
+	if (e->flags & (1 << NFTNL_EXPR_FWD_SREG_DEV))
+		mnl_attr_put_u32(nlh, NFTA_FWD_SREG_DEV, htonl(fwd->sreg_dev));
+}
+
+static int nftnl_expr_fwd_parse(struct nftnl_expr *e, struct nlattr *attr)
+{
+	struct nftnl_expr_fwd *fwd = nftnl_expr_data(e);
+	struct nlattr *tb[NFTA_FWD_MAX + 1] = {};
+	int ret = 0;
+
+	if (mnl_attr_parse_nested(attr, nftnl_expr_fwd_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_FWD_SREG_DEV]) {
+		fwd->sreg_dev = ntohl(mnl_attr_get_u32(tb[NFTA_FWD_SREG_DEV]));
+		e->flags |= (1 << NFTNL_EXPR_FWD_SREG_DEV);
+	}
+
+	return ret;
+}
+
+static int nftnl_expr_fwd_json_parse(struct nftnl_expr *e, json_t *root,
+				     struct nftnl_parse_err *err)
+{
+#ifdef JSON_PARSING
+	uint32_t sreg_dev;
+	int ret;
+
+	ret = nftnl_jansson_parse_val(root, "sreg_dev", NFTNL_TYPE_U32, &sreg_dev, err);
+	if (ret >= 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_FWD_SREG_DEV, sreg_dev);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int nftnl_expr_fwd_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
+				    struct nftnl_parse_err *err)
+{
+#ifdef XML_PARSING
+	uint32_t sreg_dev;
+
+	if (nftnl_mxml_reg_parse(tree, "sreg_dev", &sreg_dev, MXML_DESCEND_FIRST,
+			       NFTNL_XML_OPT, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_FWD_SREG_DEV, sreg_dev);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int nftnl_expr_fwd_export(char *buf, size_t size, struct nftnl_expr *e,
+				 int type)
+{
+	struct nftnl_expr_fwd *fwd = nftnl_expr_data(e);
+	NFTNL_BUF_INIT(b, buf, size);
+
+	if (e->flags & (1 << NFTNL_EXPR_FWD_SREG_DEV))
+		nftnl_buf_u32(&b, type, fwd->sreg_dev, "sreg_dev");
+
+	return nftnl_buf_done(&b);
+}
+
+static int nftnl_expr_fwd_snprintf_default(char *buf, size_t len,
+					   struct nftnl_expr *e, uint32_t flags)
+{
+	int size = len, offset = 0, ret;
+	struct nftnl_expr_fwd *fwd = nftnl_expr_data(e);
+
+	if (e->flags & (1 << NFTNL_EXPR_FWD_SREG_DEV)) {
+		ret = snprintf(buf + offset, len, "sreg_dev %u ", fwd->sreg_dev);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
+}
+
+static int nftnl_expr_fwd_snprintf(char *buf, size_t len, uint32_t type,
+				   uint32_t flags, struct nftnl_expr *e)
+{
+	switch (type) {
+	case NFTNL_OUTPUT_DEFAULT:
+		return nftnl_expr_fwd_snprintf_default(buf, len, e, flags);
+	case NFTNL_OUTPUT_XML:
+	case NFTNL_OUTPUT_JSON:
+		return nftnl_expr_fwd_export(buf, len, e, type);
+	default:
+		break;
+	}
+	return -1;
+}
+
+struct expr_ops expr_ops_fwd = {
+	.name		= "fwd",
+	.alloc_len	= sizeof(struct nftnl_expr_fwd),
+	.max_attr	= NFTA_FWD_MAX,
+	.set		= nftnl_expr_fwd_set,
+	.get		= nftnl_expr_fwd_get,
+	.parse		= nftnl_expr_fwd_parse,
+	.build		= nftnl_expr_fwd_build,
+	.snprintf	= nftnl_expr_fwd_snprintf,
+	.xml_parse	= nftnl_expr_fwd_xml_parse,
+	.json_parse	= nftnl_expr_fwd_json_parse,
+};
diff --git a/src/expr_ops.c b/src/expr_ops.c
index bfb3ba2..ae515af 100644
--- a/src/expr_ops.c
+++ b/src/expr_ops.c
@@ -11,6 +11,7 @@ extern struct expr_ops expr_ops_counter;
 extern struct expr_ops expr_ops_ct;
 extern struct expr_ops expr_ops_dup;
 extern struct expr_ops expr_ops_exthdr;
+extern struct expr_ops expr_ops_fwd;
 extern struct expr_ops expr_ops_immediate;
 extern struct expr_ops expr_ops_limit;
 extern struct expr_ops expr_ops_log;
@@ -34,6 +35,7 @@ static struct expr_ops *expr_ops[] = {
 	&expr_ops_ct,
 	&expr_ops_dup,
 	&expr_ops_exthdr,
+	&expr_ops_fwd,
 	&expr_ops_immediate,
 	&expr_ops_limit,
 	&expr_ops_log,
diff --git a/tests/Makefile.am b/tests/Makefile.am
index 51403e5..c246034 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -15,6 +15,7 @@ check_PROGRAMS = 	nft-parsing-test		\
 			nft-expr_cmp-test		\
 			nft-expr_ct-test		\
 			nft-expr_dup-test		\
+			nft-expr_fwd-test		\
 			nft-expr_exthdr-test		\
 			nft-expr_immediate-test		\
 			nft-expr_limit-test		\
@@ -66,6 +67,9 @@ nft_expr_ct_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 nft_expr_dup_test_SOURCES = nft-expr_dup-test.c
 nft_expr_dup_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
+nft_expr_fwd_test_SOURCES = nft-expr_fwd-test.c
+nft_expr_fwd_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
 nft_expr_immediate_test_SOURCES = nft-expr_counter-test.c
 nft_expr_immediate_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
diff --git a/tests/nft-expr_fwd-test.c b/tests/nft-expr_fwd-test.c
new file mode 100644
index 0000000..4fdf53d
--- /dev/null
+++ b/tests/nft-expr_fwd-test.c
@@ -0,0 +1,90 @@
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
+static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
+			      struct nftnl_expr *rule_b)
+{
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_FWD_SREG_DEV) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_FWD_SREG_DEV))
+		print_err("Expr SREG_OIF mismatches");
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
+	ex = nftnl_expr_alloc("dup");
+	if (ex == NULL)
+		print_err("OOM");
+
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_FWD_SREG_DEV,  0x78123456);
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
2.1.4

