From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH libnftables] Add support for nft_connmark
Date: Mon,  6 Jan 2014 13:29:27 +0100
Message-ID: <1389011367-11489-1-git-send-email-kristian.evensen@gmail.com>
Cc: Kristian Evensen <kristian.evensen@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:46186 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaAFM3g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:29:36 -0500
Received: by mail-ee0-f51.google.com with SMTP id b15so7834141eek.24
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jan 2014 04:29:35 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Kristian Evensen <kristian.evensen@gmail.com>

This patch adds support for the connmark target.

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 include/libnftables/expr.h          |   7 +
 include/linux/netfilter/nf_tables.h |  35 ++++
 src/Makefile.am                     |   1 +
 src/expr/connmark.c                 | 316 ++++++++++++++++++++++++++++++++++++
 tests/Makefile.am                   |   4 +
 tests/nft-expr_connmark-test.c      | 206 +++++++++++++++++++++++
 6 files changed, 569 insertions(+)
 create mode 100644 src/expr/connmark.c
 create mode 100644 tests/nft-expr_connmark-test.c

diff --git a/include/libnftables/expr.h b/include/libnftables/expr.h
index 25455e4..efa3715 100644
--- a/include/libnftables/expr.h
+++ b/include/libnftables/expr.h
@@ -149,6 +149,13 @@ enum {
 	NFT_EXPR_QUEUE_TOTAL,
 	NFT_EXPR_QUEUE_FLAGS,
 };
+
+enum {
+	NFT_EXPR_CONNMARK_MODE = NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_CONNMARK_CTMARK,
+	NFT_EXPR_CONNMARK_CTMASK,
+	NFT_EXPR_CONNMARK_NFMASK,
+};
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index e08f80e..46126fb 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -603,6 +603,41 @@ enum nft_queue_attributes {
 #define NFT_QUEUE_FLAG_MASK		0x03
 
 /**
+ * enum nft_connmark_types - nf_tables connmark expression types
+ *
+ * @NFT_CONNMARK_SAVE: save connmark
+ * @NFT_CONNMARK_RESTORE: restore connmark
+ * @NFT_CONNMARK_SET: set connmark (iptables set-xmark)
+ */
+enum nft_connmark_types {
+	NFT_CONNMARK_SAVE,
+	NFT_CONNMARK_RESTORE,
+	NFT_CONNMARK_SET
+};
+
+/**
+ * enum nft_connmark_attributes - nf_tables connmark expression netlink
+ * attributes
+ *
+ * @NFTA_CONNMARK_MODE: conntrack action (save, set or restore) (NLA_U8)
+ * @NFTA_CONNMARK_CTMARK: conntrack ctmark (NLA_U32)
+ * @NFTA_CONNMARK_CTMASK: conntrack ctmask (NLA_U32)
+ * @NFTA_CONNMARK_NFMASK: conntrack nfmask (NLA_U32)
+ */
+
+enum nft_connmark_attributes {
+	NFTA_CONNMARK_UNSPEC,
+	NFTA_CONNMARK_MODE,
+	NFTA_CONNMARK_CTMARK,
+	NFTA_CONNMARK_CTMASK,
+	NFTA_CONNMARK_NFMASK,
+	__NFTA_CONNMARK_MAX,
+};
+#define NFTA_CONNMARK_MAX		(__NFTA_CONNMARK_MAX - 1)
+
+#define NFT_CONNMARK_DEFAULT_MASK	0xFFFFFFFF
+
+/**
  * enum nft_reject_types - nf_tables reject expression reject types
  *
  * @NFT_REJECT_ICMP_UNREACH: reject using ICMP unreachable
diff --git a/src/Makefile.am b/src/Makefile.am
index 441e96e..811e061 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -19,6 +19,7 @@ libnftables_la_SOURCES = utils.c		\
 			 expr/bitwise.c		\
 			 expr/byteorder.c	\
 			 expr/cmp.c		\
+			 expr/connmark.c	\
 			 expr/counter.c		\
 			 expr/ct.c		\
 			 expr/data_reg.c	\
diff --git a/src/expr/connmark.c b/src/expr/connmark.c
new file mode 100644
index 0000000..42ff348
--- /dev/null
+++ b/src/expr/connmark.c
@@ -0,0 +1,316 @@
+/*
+ * (C) 2013 by Kristian Evensen <kristian.evensen@gmail.com>
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
+#include <linux/netfilter/nf_tables.h>
+
+#include "internal.h"
+#include <libmnl/libmnl.h>
+#include <libnftables/expr.h>
+#include <libnftables/rule.h>
+#include "expr_ops.h"
+
+/* Even though nfmask and ctmark is mutually exclusive, do not use union here.
+ * The user can provide incorrect json/xml input containing both values. */
+struct nft_expr_connmark {
+	uint32_t		ctmark;
+	uint32_t		ctmask;
+	uint32_t		nfmask;
+	uint8_t			mode;
+};
+
+static int nft_rule_expr_connmark_set(struct nft_rule_expr *e, uint16_t type,
+				      const void *data, uint32_t data_len)
+{
+	struct nft_expr_connmark *connmark = nft_expr_data(e);
+
+	switch (type) {
+	case NFT_EXPR_CONNMARK_MODE:
+		connmark->mode = *((uint8_t *) data);
+		break;
+	case NFT_EXPR_CONNMARK_CTMARK:
+		connmark->ctmark = *((uint32_t *) data);
+		break;
+	case NFT_EXPR_CONNMARK_CTMASK:
+		connmark->ctmask = *((uint32_t *) data);
+		break;
+	case NFT_EXPR_CONNMARK_NFMASK:
+		connmark->nfmask = *((uint32_t *) data);
+		break;
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+static const void *
+nft_rule_expr_connmark_get(const struct nft_rule_expr *e, uint16_t type,
+			 uint32_t *data_len)
+{
+	struct nft_expr_connmark *connmark = nft_expr_data(e);
+
+	switch (type) {
+	case NFT_EXPR_CONNMARK_MODE:
+		*data_len = sizeof(connmark->mode);
+		return &connmark->mode;
+	case NFT_EXPR_CONNMARK_CTMARK:
+		*data_len = sizeof(connmark->ctmark);
+		return &connmark->ctmark;
+	case NFT_EXPR_CONNMARK_CTMASK:
+		*data_len = sizeof(connmark->ctmask);
+		return &connmark->ctmask;
+	case NFT_EXPR_CONNMARK_NFMASK:
+		*data_len = sizeof(connmark->nfmask);
+		return &connmark->nfmask;
+	default:
+		return NULL;
+	}
+}
+
+static int nft_rule_expr_connmark_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_CONNMARK_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NFTA_CONNMARK_CTMARK:
+	case NFTA_CONNMARK_CTMASK:
+	case NFTA_CONNMARK_NFMASK:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
+	case NFTA_CONNMARK_MODE:
+		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
+	}
+
+	tb[type] = attr;
+
+	return MNL_CB_OK;
+}
+
+static void
+nft_rule_expr_connmark_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
+{
+	struct nft_expr_connmark *connmark = nft_expr_data(e);
+
+	if (e->flags & (1 << NFT_EXPR_CONNMARK_MODE))
+		mnl_attr_put_u8(nlh, NFTA_CONNMARK_MODE, connmark->mode);
+	if (e->flags & (1 << NFT_EXPR_CONNMARK_CTMARK))
+		mnl_attr_put_u32(nlh, NFTA_CONNMARK_CTMARK,
+				 htonl(connmark->ctmark));
+	if (e->flags & (1 << NFT_EXPR_CONNMARK_CTMASK))
+		mnl_attr_put_u32(nlh, NFTA_CONNMARK_CTMASK,
+				 htonl(connmark->ctmask));
+	if (e->flags & (1 << NFT_EXPR_CONNMARK_NFMASK))
+		mnl_attr_put_u32(nlh, NFTA_CONNMARK_NFMASK,
+				 htonl(connmark->nfmask));
+}
+
+static int
+nft_rule_expr_connmark_parse(struct nft_rule_expr *e, struct nlattr *attr)
+{
+	struct nft_expr_connmark *connmark = nft_expr_data(e);
+	struct nlattr *tb[NFTA_CONNMARK_MAX+1] = {};
+
+	if (mnl_attr_parse_nested(attr, nft_rule_expr_connmark_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_CONNMARK_MODE]) {
+		connmark->mode = mnl_attr_get_u8(tb[NFTA_CONNMARK_MODE]);
+		e->flags |= (1 << NFT_EXPR_CONNMARK_MODE);
+	}
+
+	if (tb[NFTA_CONNMARK_CTMARK]) {
+		connmark->ctmark =
+			ntohl(mnl_attr_get_u32(tb[NFTA_CONNMARK_CTMARK]));
+		e->flags |= (1 << NFT_EXPR_CONNMARK_CTMARK);
+	}
+
+	if (tb[NFTA_CONNMARK_CTMASK]) {
+		connmark->ctmask =
+			ntohl(mnl_attr_get_u32(tb[NFTA_CONNMARK_CTMASK]));
+		e->flags |= (1 << NFT_EXPR_CONNMARK_CTMASK);
+	}
+
+	if (tb[NFTA_CONNMARK_NFMASK]) {
+		connmark->nfmask =
+			ntohl(mnl_attr_get_u32(tb[NFTA_CONNMARK_NFMASK]));
+		e->flags |= (1 << NFT_EXPR_CONNMARK_NFMASK);
+	}
+
+	return 0;
+}
+
+static int
+nft_rule_expr_connmark_json_parse(struct nft_rule_expr *e, json_t *root)
+{
+#ifdef JSON_PARSING
+	uint32_t ctmark;
+	uint32_t ctmask;
+	uint32_t nfmask;
+	uint8_t mode;
+
+	printf("Json parsing\n");
+	if (nft_jansson_parse_val(root, "ctmark", NFT_TYPE_U32, &ctmark) < 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_CONNMARK_CTMARK, ctmark);
+
+	if (nft_jansson_parse_val(root, "ctmask", NFT_TYPE_U32, &ctmask) < 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_CONNMARK_CTMASK, ctmask);
+
+	if (nft_jansson_parse_val(root, "nfmask", NFT_TYPE_U32, &nfmask) < 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_CONNMARK_NFMASK, nfmask);
+
+	if (nft_jansson_parse_val(root, "mode", NFT_TYPE_U8, &mode) < 0)
+		return -1;
+
+	nft_rule_expr_set_u8(e, NFT_EXPR_CONNMARK, mode);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
+nft_rule_expr_connmark_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
+{
+#ifdef XML_PARSING
+	struct nft_expr_connmark *connmark = nft_expr_data(e);
+
+	if (nft_mxml_num_parse(tree, "ctmark", MXML_DESCEND_FIRST, BASE_DEC,
+			       &connmark->ctmark, NFT_TYPE_U32, NFT_XML_MAND) != 0)
+		return -1;
+
+	e->flags |= (1 << NFT_EXPR_CONNMARK_CTMARK);
+
+	if (nft_mxml_num_parse(tree, "ctmask", MXML_DESCEND_FIRST, BASE_DEC,
+			       &connmark->ctmask, NFT_TYPE_U32, NFT_XML_MAND) != 0)
+		return -1;
+
+	e->flags |= (1 << NFT_EXPR_CONNMARK_CTMASK);
+
+	if (nft_mxml_num_parse(tree, "nfmask", MXML_DESCEND_FIRST, BASE_DEC,
+			       &connmark->nfmask, NFT_TYPE_U32, NFT_XML_MAND) != 0)
+		return -1;
+
+	e->flags |= (1 << NFT_EXPR_CONNMARK_NFMASK);
+
+	if (nft_mxml_num_parse(tree, "mode", MXML_DESCEND_FIRST, BASE_DEC,
+			       &connmark->mode, NFT_TYPE_U8, NFT_XML_MAND) != 0)
+		return -1;
+
+	e->flags |= (1 << NFT_EXPR_CONNMARK_MODE);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
+nft_rule_expr_connmark_snprintf(char *buf, size_t len, uint32_t type,
+			      uint32_t flags, struct nft_rule_expr *e)
+{
+	struct nft_expr_connmark *connmark = nft_expr_data(e);
+
+	switch (type) {
+	case NFT_OUTPUT_DEFAULT:
+		if (connmark->mode == NFT_CONNMARK_SAVE)
+			return snprintf(buf, len,
+					"save-mark nfmask 0x%x ctmask 0x%x",
+					connmark->nfmask, connmark->ctmask);
+		else if (connmark->mode == NFT_CONNMARK_RESTORE)
+			return snprintf(buf, len,
+					"restore-mark nfmask 0x%x ctmask 0x%x",
+					connmark->nfmask, connmark->ctmask);
+		else if (connmark->mode == NFT_CONNMARK_SET)
+			return snprintf(buf, len,
+					"set-xmark 0x%x/0x%x",
+					connmark->ctmark, connmark->ctmask);
+		break;
+	case NFT_OUTPUT_XML:
+		if (connmark->mode == NFT_CONNMARK_SAVE ||
+		    connmark->mode == NFT_CONNMARK_RESTORE)
+			return snprintf(buf, len, "<mode>%u</mode>"
+						  "<ctmask>0x%x</ctmask>"
+						  "<nfmask>0x%x</nfmask>",
+						  connmark->mode,
+						  connmark->ctmask,
+						  connmark->nfmask);
+		else if (connmark->mode == NFT_CONNMARK_SET)
+			return snprintf(buf, len, "<mode>%u</mode>"
+						  "<ctmark>0x%x</ctmark>"
+						  "<ctmask>0x%x</ctmask>",
+						  connmark->mode,
+						  connmark->ctmark,
+						  connmark->ctmask);
+
+	case NFT_OUTPUT_JSON:
+		if (connmark->mode == NFT_CONNMARK_SAVE ||
+		    connmark->mode == NFT_CONNMARK_RESTORE)
+			return snprintf(buf, len, "\"mode\":%u,"
+						  "\"ctmask\":0x%x,"
+						  "\"nfmask\":0x%x,",
+						  connmark->mode,
+						  connmark->ctmask,
+						  connmark->nfmask);
+		else if (connmark->mode == NFT_CONNMARK_SET)
+			return snprintf(buf, len, "\"mode\":%u,"
+						  "\"ctmark\":0x%x,"
+						  "\"ctmask\":0x%x,",
+						  connmark->mode,
+						  connmark->ctmark,
+						  connmark->ctmask);
+
+	default:
+		break;
+	}
+
+	return -1;
+}
+
+struct expr_ops expr_ops_connmark = {
+	.name		= "connmark",
+	.alloc_len	= sizeof(struct nft_expr_connmark),
+	.max_attr	= NFTA_CONNMARK_MAX,
+	.set		= nft_rule_expr_connmark_set,
+	.get		= nft_rule_expr_connmark_get,
+	.parse		= nft_rule_expr_connmark_parse,
+	.build		= nft_rule_expr_connmark_build,
+	.snprintf	= nft_rule_expr_connmark_snprintf,
+	.xml_parse	= nft_rule_expr_connmark_xml_parse,
+	.json_parse	= nft_rule_expr_connmark_json_parse,
+};
+
+static void __init expr_connmark_init(void)
+{
+	nft_expr_ops_register(&expr_ops_connmark);
+}
diff --git a/tests/Makefile.am b/tests/Makefile.am
index 576bf73..225bb2a 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -9,6 +9,7 @@ check_PROGRAMS = 	nft-parsing-test		\
 			nft-expr_byteorder-test		\
 			nft-expr_counter-test		\
 			nft-expr_cmp-test		\
+			nft-expr_connmark-test		\
 			nft-expr_ct-test		\
 			nft-expr_exthdr-test		\
 			nft-expr_immediate-test		\
@@ -47,6 +48,9 @@ nft_expr_byteorder_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
 nft_expr_cmp_test_SOURCES = nft-expr_cmp-test.c
 nft_expr_cmp_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
 
+nft_expr_connmark_test_SOURCES = nft-expr_connmark-test.c
+nft_expr_connmark_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBJSON_LIBS}
+
 nft_expr_counter_test_SOURCES = nft-expr_counter-test.c
 nft_expr_counter_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
 
diff --git a/tests/nft-expr_connmark-test.c b/tests/nft-expr_connmark-test.c
new file mode 100644
index 0000000..cf26510
--- /dev/null
+++ b/tests/nft-expr_connmark-test.c
@@ -0,0 +1,206 @@
+/*
+ * (C) 2013 by Eric Leblond <eric@regit.org>
+ *
+ * Based on test framework by Ana Rey Botello <anarey@gmail.com>
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
+static void print_err(const char *msg)
+{
+	test_ok = 0;
+	printf("\033[31mERROR:\e[0m %s\n", msg);
+}
+
+static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
+			      struct nft_rule_expr *rule_b)
+{
+	uint8_t mode = nft_rule_expr_get_u8(rule_a, NFT_EXPR_CONNMARK_MODE);
+
+	if (nft_rule_expr_get_u8(rule_a, NFT_EXPR_CONNMARK_MODE) !=
+	    nft_rule_expr_get_u8(rule_b, NFT_EXPR_CONNMARK_MODE))
+		print_err("Expr NFT_EXPR_CONNMARK_MODE mismatch");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_CONNMARK_CTMASK) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_CONNMARK_CTMASK))
+		print_err("Expr NFT_EXPR_CONNMARK_MODE mismatch");
+
+	switch (mode) {
+	case NFT_CONNMARK_SAVE:
+	case NFT_CONNMARK_RESTORE:
+		if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_CONNMARK_NFMASK) !=
+		    nft_rule_expr_get_u32(rule_b, NFT_EXPR_CONNMARK_NFMASK))
+			print_err("Expr NFT_EXPR_CONNMARK_NFMASK mistmatch");
+		break;
+	case NFT_CONNMARK_SET:
+		if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_CONNMARK_CTMARK) !=
+		    nft_rule_expr_get_u32(rule_b, NFT_EXPR_CONNMARK_CTMARK))
+			print_err("Expr NFT_EXPR_CONNMARK_CTMARK mismatch");
+		break;
+	}
+}
+
+static void test_connmark_cmp(char *expression, char *cmd, struct nft_rule *a,
+		struct nft_rule *b){
+	struct nft_rule_expr_iter *iter_a, *iter_b;
+	struct nft_rule_expr *rule_a, *rule_b;
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
+		print_err("More than one expression");
+
+	nft_rule_expr_iter_destroy(iter_a);
+	nft_rule_expr_iter_destroy(iter_b);
+
+	if (test_ok)
+		printf("%s %s: \033[32mOK\e[0m\n", expression, cmd);
+
+}
+
+static void test_connmark_set(char *expression)
+{
+	struct nft_rule *a, *b;
+	struct nft_rule_expr *ex;
+	struct nlmsghdr *nlh;
+	char buf[4096];
+
+	a = nft_rule_alloc();
+	b = nft_rule_alloc();
+	if (a == NULL || b == NULL)
+		print_err("OOM");
+	ex = nft_rule_expr_alloc("connmark");
+	if (ex == NULL)
+		print_err("OOM");
+
+	nft_rule_expr_set_u8(ex, NFT_EXPR_CONNMARK_MODE, NFT_CONNMARK_SET);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_CONNMARK_CTMARK, 0x1);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_CONNMARK_CTMASK, 0x2);
+
+	nft_rule_add_expr(a, ex);
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		print_err("parsing problems");
+
+	test_connmark_cmp("connmark", "set-xmark", a, b);
+
+	nft_rule_free(a);
+	nft_rule_free(b);
+}
+
+static void test_connmark_restore(char *expression)
+{
+	struct nft_rule *a, *b;
+	struct nft_rule_expr *ex;
+	struct nlmsghdr *nlh;
+	char buf[4096];
+
+	a = nft_rule_alloc();
+	b = nft_rule_alloc();
+	if (a == NULL || b == NULL)
+		print_err("OOM");
+	ex = nft_rule_expr_alloc("connmark");
+	if (ex == NULL)
+		print_err("OOM");
+
+	nft_rule_expr_set_u8(ex, NFT_EXPR_CONNMARK_MODE,
+			     NFT_CONNMARK_RESTORE);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_CONNMARK_CTMASK, 0x2);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_CONNMARK_NFMASK, 0x2);
+
+	nft_rule_add_expr(a, ex);
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		print_err("parsing problems");
+
+	test_connmark_cmp("connmark", "restore-mark", a, b);
+
+	nft_rule_free(a);
+	nft_rule_free(b);
+}
+
+static void test_connmark_save(char *expression)
+{
+	struct nft_rule *a, *b;
+	struct nft_rule_expr *ex;
+	struct nlmsghdr *nlh;
+	char buf[4096];
+
+	a = nft_rule_alloc();
+	b = nft_rule_alloc();
+	if (a == NULL || b == NULL)
+		print_err("OOM");
+	ex = nft_rule_expr_alloc("connmark");
+	if (ex == NULL)
+		print_err("OOM");
+
+	nft_rule_expr_set_u8(ex, NFT_EXPR_CONNMARK_MODE,
+			     NFT_CONNMARK_SAVE);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_CONNMARK_CTMASK, 0x1);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_CONNMARK_NFMASK, 0x2);
+
+	nft_rule_add_expr(a, ex);
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nft_rule_nlmsg_build_payload(nlh, a);
+
+	if (nft_rule_nlmsg_parse(nlh, b) < 0)
+		print_err("parsing problems");
+
+	test_connmark_cmp("connmark", "save-mark", a, b);
+
+	nft_rule_free(a);
+	nft_rule_free(b);
+}
+
+int main(int argc, char *argv[])
+{
+	int retval = EXIT_SUCCESS;
+
+	test_connmark_set(argv[0]);
+	/* Only return success if no test cases fail  */
+	if (!test_ok)
+		retval = EXIT_FAILURE;
+	test_ok = 1;
+	test_connmark_restore(argv[0]);
+	if (!test_ok)
+		retval = EXIT_FAILURE;
+	test_ok = 1;
+	test_connmark_save(argv[0]);
+	if (!test_ok)
+		retval = EXIT_FAILURE;
+
+
+	return retval;
+}
-- 
1.8.3.2

