From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 3/7] expr: add stateful object reference expression
Date: Fri,  9 Dec 2016 14:31:55 +0100
Message-ID: <1481290319-10156-3-git-send-email-pablo@netfilter.org>
References: <1481290319-10156-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35556 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753640AbcLINcM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Dec 2016 08:32:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1BB6696EC6
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Dec 2016 14:32:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 09183524C8
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Dec 2016 14:32:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3251B524C8
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Dec 2016 14:32:04 +0100 (CET)
In-Reply-To: <1481290319-10156-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a new "objref" expression that you can use to refer to
stateful objects from rules.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/expr.h      |   5 +
 src/Makefile.am              |   1 +
 src/expr/objref.c            | 215 +++++++++++++++++++++++++++++++++++++++++++
 src/expr_ops.c               |   2 +
 src/object.c                 |   5 +
 tests/Makefile.am            |   4 +
 tests/nft-expr_objref-test.c |  96 +++++++++++++++++++
 tests/test-script.sh         |   1 +
 8 files changed, 329 insertions(+)
 create mode 100644 src/expr/objref.c
 create mode 100644 tests/nft-expr_objref-test.c

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 979241aac535..f6ea69dfacae 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -234,6 +234,11 @@ enum {
 	NFTNL_EXPR_FIB_FLAGS,
 };
 
+enum {
+	NFTNL_EXPR_OBJREF_IMM_TYPE	= NFTNL_EXPR_BASE,
+	NFTNL_EXPR_OBJREF_IMM_NAME,
+};
+
 /*
  * Compat
  */
diff --git a/src/Makefile.am b/src/Makefile.am
index 909c6a668b77..485a8c4acbef 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -42,6 +42,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      expr/meta.c	\
 		      expr/numgen.c	\
 		      expr/nat.c	\
+		      expr/objref.c	\
 		      expr/payload.c	\
 		      expr/queue.c	\
 		      expr/quota.c	\
diff --git a/src/expr/objref.c b/src/expr/objref.c
new file mode 100644
index 000000000000..01bea7b8b4b1
--- /dev/null
+++ b/src/expr/objref.c
@@ -0,0 +1,215 @@
+/*
+ * (C) 2016 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <stdio.h>
+#include <stdint.h>
+#include <arpa/inet.h>
+#include <errno.h>
+#include <inttypes.h>
+
+#include <linux/netfilter/nf_tables.h>
+
+#include "internal.h"
+#include <libmnl/libmnl.h>
+#include <libnftnl/expr.h>
+#include <libnftnl/rule.h>
+
+struct nftnl_expr_objref {
+	struct {
+		uint32_t	type;
+		const char	*name;
+	} imm;
+};
+
+static int nftnl_expr_objref_set(struct nftnl_expr *e, uint16_t type,
+				 const void *data, uint32_t data_len)
+{
+	struct nftnl_expr_objref *objref = nftnl_expr_data(e);
+
+	switch(type) {
+	case NFTNL_EXPR_OBJREF_IMM_TYPE:
+		objref->imm.type = *((uint32_t *)data);
+		break;
+	case NFTNL_EXPR_OBJREF_IMM_NAME:
+		objref->imm.name = strdup(data);
+		if (!objref->imm.name)
+			return -1;
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static const void *nftnl_expr_objref_get(const struct nftnl_expr *e,
+					 uint16_t type, uint32_t *data_len)
+{
+	struct nftnl_expr_objref *objref = nftnl_expr_data(e);
+
+	switch(type) {
+	case NFTNL_EXPR_OBJREF_IMM_TYPE:
+		*data_len = sizeof(objref->imm.type);
+		return &objref->imm.type;
+	case NFTNL_EXPR_OBJREF_IMM_NAME:
+		*data_len = strlen(objref->imm.name) + 1;
+		return objref->imm.name;
+	}
+	return NULL;
+}
+
+static int nftnl_expr_objref_cb(const struct nlattr *attr, void *data)
+{
+	int type = mnl_attr_get_type(attr);
+	const struct nlattr **tb = data;
+
+	if (mnl_attr_type_valid(attr, NFTA_OBJREF_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch(type) {
+	case NFTA_OBJREF_IMM_TYPE:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
+	case NFTA_OBJREF_IMM_NAME:
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static void nftnl_expr_objref_build(struct nlmsghdr *nlh,
+				    const struct nftnl_expr *e)
+{
+	struct nftnl_expr_objref *objref = nftnl_expr_data(e);
+
+	if (e->flags & (1 << NFTNL_EXPR_OBJREF_IMM_TYPE))
+		mnl_attr_put_u32(nlh, NFTA_OBJREF_IMM_TYPE,
+				 htonl(objref->imm.type));
+	if (e->flags & (1 << NFTNL_EXPR_OBJREF_IMM_NAME))
+		mnl_attr_put_str(nlh, NFTA_OBJREF_IMM_NAME, objref->imm.name);
+}
+
+static int nftnl_expr_objref_parse(struct nftnl_expr *e, struct nlattr *attr)
+{
+	struct nftnl_expr_objref *objref = nftnl_expr_data(e);
+	struct nlattr *tb[NFTA_OBJREF_MAX + 1] = {};
+
+	if (mnl_attr_parse_nested(attr, nftnl_expr_objref_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_OBJREF_IMM_TYPE]) {
+		objref->imm.type =
+			ntohl(mnl_attr_get_u32(tb[NFTA_OBJREF_IMM_TYPE]));
+		e->flags |= (1 << NFTNL_EXPR_OBJREF_IMM_TYPE);
+	}
+	if (tb[NFTA_OBJREF_IMM_NAME]) {
+		objref->imm.name =
+			strdup(mnl_attr_get_str(tb[NFTA_OBJREF_IMM_NAME]));
+		e->flags |= (1 << NFTNL_EXPR_OBJREF_IMM_NAME);
+	}
+
+	return 0;
+}
+
+static int
+nftnl_expr_objref_json_parse(struct nftnl_expr *e, json_t *root,
+			     struct nftnl_parse_err *err)
+{
+#ifdef JSON_PARSING
+	uint32_t uval32;
+	const char *str;
+
+	if (nftnl_jansson_node_exist(root, "name")) {
+		str = nftnl_jansson_parse_str(root, "name", err);
+		if (str == NULL)
+			return -1;
+
+		nftnl_expr_set_str(e, NFTNL_EXPR_OBJREF_IMM_NAME, str);
+	}
+
+	if (nftnl_jansson_parse_val(root, "type", NFTNL_TYPE_U32, &uval32,
+				    err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_OBJREF_IMM_TYPE, uval32);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int nftnl_expr_objref_export(char *buf, size_t size,
+				    const struct nftnl_expr *e, int type)
+{
+	struct nftnl_expr_objref *objref = nftnl_expr_data(e);
+	NFTNL_BUF_INIT(b, buf, size);
+
+	if (e->flags & (1 << NFTNL_EXPR_OBJREF_IMM_TYPE))
+		nftnl_buf_u32(&b, type, objref->imm.type, BYTES);
+	if (e->flags & (1 << NFTNL_EXPR_OBJREF_IMM_NAME))
+		nftnl_buf_str(&b, type, objref->imm.name, NAME);
+
+	return nftnl_buf_done(&b);
+}
+
+static int nftnl_expr_objref_snprintf_default(char *buf, size_t len,
+					      const struct nftnl_expr *e)
+{
+	struct nftnl_expr_objref *objref = nftnl_expr_data(e);
+
+	return snprintf(buf, len, "type %u name %s ",
+			objref->imm.type, objref->imm.name);
+}
+
+static int nftnl_expr_objref_snprintf(char *buf, size_t len, uint32_t type,
+				      uint32_t flags,
+				      const struct nftnl_expr *e)
+{
+	switch (type) {
+	case NFTNL_OUTPUT_DEFAULT:
+		return nftnl_expr_objref_snprintf_default(buf, len, e);
+	case NFTNL_OUTPUT_XML:
+	case NFTNL_OUTPUT_JSON:
+		return nftnl_expr_objref_export(buf, len, e, type);
+	default:
+		break;
+	}
+	return -1;
+}
+
+static bool nftnl_expr_objref_cmp(const struct nftnl_expr *e1,
+				   const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_objref *c1 = nftnl_expr_data(e1);
+	struct nftnl_expr_objref *c2 = nftnl_expr_data(e2);
+	bool eq = true;
+
+	if (e1->flags & (1 << NFTNL_EXPR_OBJREF_IMM_TYPE))
+		eq &= (c1->imm.type == c2->imm.type);
+	if (e1->flags & (1 << NFTNL_EXPR_OBJREF_IMM_NAME))
+		eq &= !strcmp(c1->imm.name, c2->imm.name);
+
+	return eq;
+}
+
+struct expr_ops expr_ops_objref = {
+	.name		= "objref",
+	.alloc_len	= sizeof(struct nftnl_expr_objref),
+	.max_attr	= NFTA_OBJREF_MAX,
+	.cmp		= nftnl_expr_objref_cmp,
+	.set		= nftnl_expr_objref_set,
+	.get		= nftnl_expr_objref_get,
+	.parse		= nftnl_expr_objref_parse,
+	.build		= nftnl_expr_objref_build,
+	.snprintf	= nftnl_expr_objref_snprintf,
+	.json_parse	= nftnl_expr_objref_json_parse,
+};
diff --git a/src/expr_ops.c b/src/expr_ops.c
index 4d7d1fab4577..7a0e1e3d0a26 100644
--- a/src/expr_ops.c
+++ b/src/expr_ops.c
@@ -21,6 +21,7 @@ extern struct expr_ops expr_ops_match;
 extern struct expr_ops expr_ops_meta;
 extern struct expr_ops expr_ops_ng;
 extern struct expr_ops expr_ops_nat;
+extern struct expr_ops expr_ops_objref;
 extern struct expr_ops expr_ops_payload;
 extern struct expr_ops expr_ops_range;
 extern struct expr_ops expr_ops_redir;
@@ -67,6 +68,7 @@ static struct expr_ops *expr_ops[] = {
 	&expr_ops_dynset,
 	&expr_ops_hash,
 	&expr_ops_fib,
+	&expr_ops_objref,
 	NULL,
 };
 
diff --git a/src/object.c b/src/object.c
index 0190e9409797..0d3dc2b1e678 100644
--- a/src/object.c
+++ b/src/object.c
@@ -276,6 +276,7 @@ static int nftnl_jansson_parse_obj(struct nftnl_obj *t, json_t *tree,
 			    struct nftnl_parse_err *err)
 {
 	const char *str;
+	uint32_t type;
 	json_t *root;
 
 	root = nftnl_jansson_get_node(tree, "obj", err);
@@ -290,6 +291,10 @@ static int nftnl_jansson_parse_obj(struct nftnl_obj *t, json_t *tree,
 	if (str != NULL)
 		nftnl_obj_set_str(t, NFTNL_OBJ_NAME, str);
 
+	if (nftnl_jansson_parse_val(root, "type", NFTNL_TYPE_U32, &type,
+				    err) < 0)
+		nftnl_obj_set_u32(t, NFTNL_OBJ_TYPE, type);
+
 	return 0;
 }
 #endif
diff --git a/tests/Makefile.am b/tests/Makefile.am
index 812ebff17126..1467d99aa62c 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -26,6 +26,7 @@ check_PROGRAMS = 	nft-parsing-test		\
 			nft-expr_meta-test		\
 			nft-expr_numgen-test		\
 			nft-expr_nat-test		\
+			nft-expr_objref-test		\
 			nft-expr_payload-test		\
 			nft-expr_queue-test		\
 			nft-expr_range-test             \
@@ -104,6 +105,9 @@ nft_expr_numgen_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 nft_expr_nat_test_SOURCES = nft-expr_nat-test.c
 nft_expr_nat_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
+nft_expr_objref_test_SOURCES = nft-expr_objref-test.c
+nft_expr_objref_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
+
 nft_expr_payload_test_SOURCES = nft-expr_payload-test.c
 nft_expr_payload_test_LDADD = ../src/libnftnl.la ${LIBMNL_LIBS}
 
diff --git a/tests/nft-expr_objref-test.c b/tests/nft-expr_objref-test.c
new file mode 100644
index 000000000000..ae4da9ac8cb4
--- /dev/null
+++ b/tests/nft-expr_objref-test.c
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
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_OBJREF_IMM_TYPE) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_OBJREF_IMM_TYPE))
+		print_err("Expr NFTNL_EXPR_OBJREF_IMM_TYPE mismatches");
+	if (strcmp(nftnl_expr_get_str(rule_a, NFTNL_EXPR_OBJREF_IMM_NAME),
+		   nftnl_expr_get_str(rule_b, NFTNL_EXPR_OBJREF_IMM_NAME)))
+		print_err("Expr NFTNL_EXPR_OBJREF_IMM_NAME mismatches");
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
+	char *name = "test_set_01243";
+
+	a = nftnl_rule_alloc();
+	b = nftnl_rule_alloc();
+	if (a == NULL || b == NULL)
+		print_err("OOM");
+	ex = nftnl_expr_alloc("lookup");
+	if (ex == NULL)
+		print_err("OOM");
+
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_OBJREF_IMM_TYPE, 0x78123456);
+	nftnl_expr_set_str(ex, NFTNL_EXPR_OBJREF_IMM_NAME,  name);
+
+	nftnl_rule_add_expr(a, ex);
+
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
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
+
+	return EXIT_SUCCESS;
+}
diff --git a/tests/test-script.sh b/tests/test-script.sh
index 743e514da698..2bd7ef0e6716 100755
--- a/tests/test-script.sh
+++ b/tests/test-script.sh
@@ -19,6 +19,7 @@
 ./nft-expr_range-test
 ./nft-expr_redir-test
 ./nft-expr_nat-test
+./nft-expr_objref-test
 ./nft-expr_payload-test
 ./nft-expr_quota-test
 ./nft-expr_reject-test
-- 
2.1.4

