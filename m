From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 3/3] expr: add support for the dynset expr
Date: Sun, 12 Apr 2015 20:24:49 +0100
Message-ID: <1428866689-17679-4-git-send-email-kaber@trash.net>
References: <1428866689-17679-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61671 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbbDLTY5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Apr 2015 15:24:57 -0400
In-Reply-To: <1428866689-17679-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/buffer.h                    |   3 +
 include/libnftnl/expr.h             |   9 +
 include/linux/netfilter/nf_tables.h |  27 +++
 src/Makefile.am                     |   1 +
 src/expr/dynset.c                   | 317 ++++++++++++++++++++++++++++++++++++
 src/expr_ops.c                      |   2 +
 6 files changed, 359 insertions(+)

diff --git a/include/buffer.h b/include/buffer.h
index 9d1cb8b..52942ed 100644
--- a/include/buffer.h
+++ b/include/buffer.h
@@ -66,12 +66,15 @@ int nft_buf_reg(struct nft_buf *b, int type, union nft_data_reg *reg,
 #define QTHRESH			"qthreshold"
 #define RATE			"rate"
 #define SET			"set"
+#define SET_NAME		"set_name"
 #define SIZE			"size"
 #define SNAPLEN			"snaplen"
 #define SREG_ADDR_MAX		"sreg_addr_max"
 #define SREG_ADDR_MIN		"sreg_addr_min"
 #define SREG_PROTO_MAX		"sreg_proto_max"
 #define SREG_PROTO_MIN		"sreg_proto_min"
+#define SREG_KEY		"sreg_key"
+#define SREG_DATA		"sreg_data"
 #define SREG			"sreg"
 #define TABLE			"table"
 #define TOTAL			"total"
diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 9f25993..7bc0273 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -111,6 +111,15 @@ enum {
 };
 
 enum {
+	NFT_EXPR_DYNSET_SREG_KEY	= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_DYNSET_SREG_DATA,
+	NFT_EXPR_DYNSET_OP,
+	NFT_EXPR_DYNSET_TIMEOUT,
+	NFT_EXPR_DYNSET_SET_NAME,
+	NFT_EXPR_DYNSET_SET_ID,
+};
+
+enum {
 	NFT_EXPR_LOG_PREFIX	= NFT_RULE_EXPR_ATTR_BASE,
 	NFT_EXPR_LOG_GROUP,
 	NFT_EXPR_LOG_SNAPLEN,
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 334b389..0e96443 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -516,6 +516,33 @@ enum nft_lookup_attributes {
 };
 #define NFTA_LOOKUP_MAX		(__NFTA_LOOKUP_MAX - 1)
 
+enum nft_dynset_ops {
+	NFT_DYNSET_OP_ADD,
+	NFT_DYNSET_OP_UPDATE,
+};
+
+/**
+ * enum nft_dynset_attributes - dynset expression attributes
+ *
+ * @NFTA_DYNSET_SET_NAME: name of set the to add data to (NLA_STRING)
+ * @NFTA_DYNSET_SET_ID: uniquely identifier of the set in the transaction (NLA_U32)
+ * @NFTA_DYNSET_OP: operation (NLA_U32)
+ * @NFTA_DYNSET_SREG_KEY: source register of the key (NLA_U32)
+ * @NFTA_DYNSET_SREG_DATA: source register of the data (NLA_U32)
+ * @NFTA_DYNSET_TIMEOUT: timeout value for the new element (NLA_U64)
+ */
+enum nft_dynset_attributes {
+	NFTA_DYNSET_UNSPEC,
+	NFTA_DYNSET_SET_NAME,
+	NFTA_DYNSET_SET_ID,
+	NFTA_DYNSET_OP,
+	NFTA_DYNSET_SREG_KEY,
+	NFTA_DYNSET_SREG_DATA,
+	NFTA_DYNSET_TIMEOUT,
+	__NFTA_DYNSET_MAX,
+};
+#define NFTA_DYNSET_MAX		(__NFTA_DYNSET_MAX - 1)
+
 /**
  * enum nft_payload_bases - nf_tables payload expression offset bases
  *
diff --git a/src/Makefile.am b/src/Makefile.am
index 3fca5e4..a5cbe85 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -29,6 +29,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      expr/limit.c	\
 		      expr/log.c	\
 		      expr/lookup.c	\
+		      expr/dynset.c	\
 		      expr/immediate.c	\
 		      expr/match.c	\
 		      expr/meta.c	\
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
new file mode 100644
index 0000000..a2c1946
--- /dev/null
+++ b/src/expr/dynset.c
@@ -0,0 +1,317 @@
+/*
+ * Copyright (c) 2014, 2015 Patrick McHardy <kaber@trash.net>
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
+#include <inttypes.h>
+#include <errno.h>
+#include <arpa/inet.h>
+#include <libmnl/libmnl.h>
+#include <linux/netfilter/nf_tables.h>
+#include <libnftnl/rule.h>
+#include <libnftnl/expr.h>
+#include "data_reg.h"
+#include "expr_ops.h"
+#include <buffer.h>
+
+#ifndef IFNAMSIZ
+#define IFNAMSIZ	16
+#endif
+
+struct nft_expr_dynset {
+	enum nft_registers	sreg_key;
+	enum nft_registers	sreg_data;
+	enum nft_dynset_ops	op;
+	uint64_t		timeout;
+	char			set_name[IFNAMSIZ];
+	uint32_t		set_id;
+};
+
+static int
+nft_rule_expr_dynset_set(struct nft_rule_expr *e, uint16_t type,
+			 const void *data, uint32_t data_len)
+{
+	struct nft_expr_dynset *dynset = nft_expr_data(e);
+
+	switch (type) {
+	case NFT_EXPR_DYNSET_SREG_KEY:
+		dynset->sreg_key = *((uint32_t *)data);
+		break;
+	case NFT_EXPR_DYNSET_SREG_DATA:
+		dynset->sreg_data = *((uint32_t *)data);
+		break;
+	case NFT_EXPR_DYNSET_OP:
+		dynset->op = *((uint32_t *)data);
+		break;
+	case NFT_EXPR_DYNSET_TIMEOUT:
+		dynset->timeout = *((uint64_t *)data);
+		break;
+	case NFT_EXPR_DYNSET_SET_NAME:
+		snprintf(dynset->set_name, sizeof(dynset->set_name), "%s",
+			 (const char *)data);
+		break;
+	case NFT_EXPR_DYNSET_SET_ID:
+		dynset->set_id = *((uint32_t *)data);
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static const void *
+nft_rule_expr_dynset_get(const struct nft_rule_expr *e, uint16_t type,
+			 uint32_t *data_len)
+{
+	struct nft_expr_dynset *dynset = nft_expr_data(e);
+
+	switch (type) {
+	case NFT_EXPR_DYNSET_SREG_KEY:
+		*data_len = sizeof(dynset->sreg_key);
+		return &dynset->sreg_key;
+	case NFT_EXPR_DYNSET_SREG_DATA:
+		*data_len = sizeof(dynset->sreg_data);
+		return &dynset->sreg_data;
+	case NFT_EXPR_DYNSET_OP:
+		*data_len = sizeof(dynset->op);
+		return &dynset->op;
+	case NFT_EXPR_DYNSET_TIMEOUT:
+		*data_len = sizeof(dynset->timeout);
+		return &dynset->timeout;
+	case NFT_EXPR_DYNSET_SET_NAME:
+		return dynset->set_name;
+	case NFT_EXPR_DYNSET_SET_ID:
+		return &dynset->set_id;
+	}
+	return NULL;
+}
+
+static int nft_rule_expr_dynset_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_SET_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NFTA_DYNSET_SREG_KEY:
+	case NFTA_DYNSET_SREG_DATA:
+	case NFTA_DYNSET_SET_ID:
+	case NFTA_DYNSET_OP:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
+	case NFTA_DYNSET_TIMEOUT:
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			abi_breakage();
+		break;
+	case NFTA_DYNSET_SET_NAME:
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static void
+nft_rule_expr_dynset_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
+{
+	struct nft_expr_dynset *dynset = nft_expr_data(e);
+
+	if (e->flags & (1 << NFT_EXPR_DYNSET_SREG_KEY))
+		mnl_attr_put_u32(nlh, NFTA_DYNSET_SREG_KEY, htonl(dynset->sreg_key));
+	if (e->flags & (1 << NFT_EXPR_DYNSET_SREG_DATA))
+		mnl_attr_put_u32(nlh, NFTA_DYNSET_SREG_DATA, htonl(dynset->sreg_data));
+	if (e->flags & (1 << NFT_EXPR_DYNSET_OP))
+		mnl_attr_put_u32(nlh, NFTA_DYNSET_OP, htonl(dynset->op));
+	if (e->flags & (1 << NFT_EXPR_DYNSET_TIMEOUT))
+		mnl_attr_put_u64(nlh, NFTA_DYNSET_TIMEOUT, htobe64(dynset->timeout));
+	if (e->flags & (1 << NFT_EXPR_DYNSET_SET_NAME))
+		mnl_attr_put_strz(nlh, NFTA_DYNSET_SET_NAME, dynset->set_name);
+	if (e->flags & (1 << NFT_EXPR_DYNSET_SET_ID))
+		mnl_attr_put_u32(nlh, NFTA_DYNSET_SET_ID, htonl(dynset->set_id));
+}
+
+static int
+nft_rule_expr_dynset_parse(struct nft_rule_expr *e, struct nlattr *attr)
+{
+	struct nft_expr_dynset *dynset = nft_expr_data(e);
+	struct nlattr *tb[NFTA_SET_MAX+1] = {};
+	int ret = 0;
+
+	if (mnl_attr_parse_nested(attr, nft_rule_expr_dynset_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_DYNSET_SREG_KEY]) {
+		dynset->sreg_key = ntohl(mnl_attr_get_u32(tb[NFTA_DYNSET_SREG_KEY]));
+		e->flags |= (1 << NFT_EXPR_DYNSET_SREG_KEY);
+	}
+	if (tb[NFTA_DYNSET_SREG_DATA]) {
+		dynset->sreg_data = ntohl(mnl_attr_get_u32(tb[NFTA_DYNSET_SREG_DATA]));
+		e->flags |= (1 << NFT_EXPR_DYNSET_SREG_DATA);
+	}
+	if (tb[NFTA_DYNSET_OP]) {
+		dynset->op = ntohl(mnl_attr_get_u32(tb[NFTA_DYNSET_OP]));
+		e->flags |= (1 << NFT_EXPR_DYNSET_OP);
+	}
+	if (tb[NFTA_DYNSET_TIMEOUT]) {
+		dynset->timeout = be64toh(mnl_attr_get_u64(tb[NFTA_DYNSET_TIMEOUT]));
+		e->flags |= (1 << NFT_EXPR_DYNSET_TIMEOUT);
+	}
+	if (tb[NFTA_DYNSET_SET_NAME]) {
+		strcpy(dynset->set_name, mnl_attr_get_str(tb[NFTA_DYNSET_SET_NAME]));
+		e->flags |= (1 << NFT_EXPR_DYNSET_SET_NAME);
+	}
+	if (tb[NFTA_DYNSET_SET_ID]) {
+		dynset->set_id = ntohl(mnl_attr_get_u32(tb[NFTA_DYNSET_SET_ID]));
+		e->flags |= (1 << NFT_EXPR_DYNSET_SET_ID);
+	}
+
+	return ret;
+}
+
+static int
+nft_rule_expr_dynset_json_parse(struct nft_rule_expr *e, json_t *root,
+				struct nft_parse_err *err)
+{
+#ifdef JSON_PARSING
+	const char *set_name;
+	uint32_t sreg, dreg;
+
+	set_name = nft_jansson_parse_str(root, "set", err);
+	if (set_name != NULL)
+		nft_rule_expr_dynset_str(e, NFT_EXPR_DYNSET_SET, set_name);
+
+	if (nft_jansson_parse_reg(root, "sreg", NFT_TYPE_U32, &sreg, err) == 0)
+		nft_rule_expr_dynset_u32(e, NFT_EXPR_DYNSET_SREG, sreg);
+
+	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &dreg, err) == 0)
+		nft_rule_expr_dynset_u32(e, NFT_EXPR_DYNSET_DREG, dreg);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
+nft_rule_expr_dynset_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
+			       struct nft_parse_err *err)
+{
+#ifdef XML_PARSING
+	const char *set_name;
+	uint32_t sreg, dreg;
+
+	set_name = nft_mxml_str_parse(tree, "set", MXML_DESCEND_FIRST,
+				      NFT_XML_MAND, err);
+	if (set_name != NULL)
+		nft_rule_expr_dynset_str(e, NFT_EXPR_DYNSET_SET, set_name);
+
+	if (nft_mxml_reg_parse(tree, "sreg", &sreg, MXML_DESCEND, NFT_XML_MAND,
+			       err) == 0)
+		nft_rule_expr_dynset_u32(e, NFT_EXPR_DYNSET_SREG, sreg);
+
+	if (nft_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND, NFT_XML_OPT,
+			       err) == 0)
+		nft_rule_expr_dynset_u32(e, NFT_EXPR_DYNSET_DREG, dreg);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
+nft_rule_expr_dynset_export(char *buf, size_t size,
+			    struct nft_rule_expr *e, int type)
+{
+	struct nft_expr_dynset *dynset = nft_expr_data(e);
+	NFT_BUF_INIT(b, buf, size);
+
+	if (e->flags & (1 << NFT_EXPR_DYNSET_SET_NAME))
+		nft_buf_str(&b, type, dynset->set_name, SET_NAME);
+	if (e->flags & (1 << NFT_EXPR_DYNSET_SREG_KEY))
+		nft_buf_u32(&b, type, dynset->sreg_key, SREG_KEY);
+	if (e->flags & (1 << NFT_EXPR_DYNSET_SREG_DATA))
+		nft_buf_u32(&b, type, dynset->sreg_data, SREG_DATA);
+
+	return nft_buf_done(&b);
+}
+
+static char *op2str_array[] = {
+	[NFT_DYNSET_OP_ADD]		= "add",
+	[NFT_DYNSET_OP_UPDATE] 		= "update",
+};
+
+static const char *op2str(enum nft_dynset_ops op)
+{
+	if (op > NFT_DYNSET_OP_UPDATE)
+		return "unknown";
+	return op2str_array[op];
+}
+
+static int
+nft_rule_expr_dynset_snprintf_default(char *buf, size_t size,
+				      struct nft_rule_expr *e)
+{
+	struct nft_expr_dynset *dynset = nft_expr_data(e);
+	int len = size, offset = 0, ret;
+
+	ret = snprintf(buf, len, "%s reg_key %u set %s ",
+		       op2str(dynset->op), dynset->sreg_key, dynset->set_name);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if (e->flags & (1 << NFT_EXPR_DYNSET_SREG_DATA)) {
+		ret = snprintf(buf+offset, len, "sreg_data %u ", dynset->sreg_data);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_DYNSET_TIMEOUT)) {
+		ret = snprintf(buf+offset, len, "timeout %"PRIu64"ms ",
+			       dynset->timeout);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	return offset;
+}
+
+static int
+nft_rule_expr_dynset_snprintf(char *buf, size_t size, uint32_t type,
+			      uint32_t flags, struct nft_rule_expr *e)
+{
+
+	switch (type) {
+	case NFT_OUTPUT_DEFAULT:
+		return nft_rule_expr_dynset_snprintf_default(buf, size, e);
+	case NFT_OUTPUT_XML:
+	case NFT_OUTPUT_JSON:
+		return nft_rule_expr_dynset_export(buf, size, e, type);
+	default:
+		break;
+	}
+	return -1;
+}
+
+struct expr_ops expr_ops_dynset = {
+	.name		= "dynset",
+	.alloc_len	= sizeof(struct nft_expr_dynset),
+	.max_attr	= NFTA_DYNSET_MAX,
+	.set		= nft_rule_expr_dynset_set,
+	.get		= nft_rule_expr_dynset_get,
+	.parse		= nft_rule_expr_dynset_parse,
+	.build		= nft_rule_expr_dynset_build,
+	.snprintf	= nft_rule_expr_dynset_snprintf,
+	.xml_parse	= nft_rule_expr_dynset_xml_parse,
+	.json_parse	= nft_rule_expr_dynset_json_parse,
+};
diff --git a/src/expr_ops.c b/src/expr_ops.c
index fce5b02..2de5805 100644
--- a/src/expr_ops.c
+++ b/src/expr_ops.c
@@ -23,6 +23,7 @@ extern struct expr_ops expr_ops_redir;
 extern struct expr_ops expr_ops_reject;
 extern struct expr_ops expr_ops_queue;
 extern struct expr_ops expr_ops_target;
+extern struct expr_ops expr_ops_dynset;
 
 static struct expr_ops *expr_ops[] = {
 	&expr_ops_bitwise,
@@ -44,6 +45,7 @@ static struct expr_ops *expr_ops[] = {
 	&expr_ops_reject,
 	&expr_ops_queue,
 	&expr_ops_target,
+	&expr_ops_dynset,
 	NULL,
 };
 
-- 
2.1.0

