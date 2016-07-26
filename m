From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH libnftnl] expr: nth: match every n packets
Date: Tue, 26 Jul 2016 16:23:11 +0200
Message-ID: <20160726142308.GA18602@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33327 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbcGZOXQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jul 2016 10:23:16 -0400
Received: by mail-wm0-f66.google.com with SMTP id o80so1941802wme.0
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Jul 2016 07:23:15 -0700 (PDT)
Received: from sonyv ([91.126.73.162])
        by smtp.gmail.com with ESMTPSA id d62sm2000359wmd.7.2016.07.26.07.23.13
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 26 Jul 2016 07:23:13 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Support for the nft nth expression within libnftnl.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 include/libnftnl/expr.h             |  10 ++
 include/linux/netfilter/nf_tables.h |  14 +++
 src/Makefile.am                     |   1 +
 src/expr/nth.c                      | 239 ++++++++++++++++++++++++++++++++++++
 src/expr_ops.c                      |   2 +
 5 files changed, 266 insertions(+)
 create mode 100644 src/expr/nth.c

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 17f60bd..6d245cd 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -49,6 +49,11 @@ enum {
 };
 
 enum {
+	NFTNL_EXPR_NTH_DREG	= NFTNL_EXPR_BASE,
+	NFTNL_EXPR_NTH_DATA,
+};
+
+enum {
 	NFTNL_EXPR_META_KEY	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_META_DREG,
 	NFTNL_EXPR_META_SREG,
@@ -235,6 +240,11 @@ enum {
 };
 
 enum {
+	NFT_EXPR_NTH_DREG	= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_NTH_DATA,
+};
+
+enum {
 	NFT_EXPR_META_KEY	= NFT_RULE_EXPR_ATTR_BASE,
 	NFT_EXPR_META_DREG,
 	NFT_EXPR_META_SREG,
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 01751fa..f90ef48 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -667,6 +667,20 @@ enum nft_exthdr_attributes {
 #define NFTA_EXTHDR_MAX		(__NFTA_EXTHDR_MAX - 1)
 
 /**
+ * enum nft_nth_attributes - nf_tables nth expression attributes
+ *
+ * @NFTA_NTH_DREG: destination register (NLA_U32)
+ * @NFTA_NTH_DATA: data input (NLA_NESTED)
+ */
+enum nft_nth_attributes {
+	NFTA_NTH_UNSPEC,
+	NFTA_NTH_DREG,
+	NFTA_NTH_DATA,
+	__NFTA_NTH_MAX
+};
+#define NFTA_NTH_MAX		(__NFTA_NTH_MAX - 1)
+
+/**
  * enum nft_meta_keys - nf_tables meta expression keys
  *
  * @NFT_META_LEN: packet length (skb->len)
diff --git a/src/Makefile.am b/src/Makefile.am
index 7e580e4..69b61ef 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -38,6 +38,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      expr/immediate.c	\
 		      expr/match.c	\
 		      expr/meta.c	\
+		      expr/nth.c	\
 		      expr/nat.c	\
 		      expr/payload.c	\
 		      expr/queue.c	\
diff --git a/src/expr/nth.c b/src/expr/nth.c
new file mode 100644
index 0000000..4da2968
--- /dev/null
+++ b/src/expr/nth.c
@@ -0,0 +1,239 @@
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
+
+struct nftnl_expr_nth {
+	enum nft_registers	dreg;
+	union nftnl_data_reg	data;
+};
+
+static int
+nftnl_expr_nth_set(struct nftnl_expr *e, uint16_t type,
+		   const void *data, uint32_t data_len)
+{
+	struct nftnl_expr_nth *nth = nftnl_expr_data(e);
+
+	switch (type) {
+	case NFTNL_EXPR_NTH_DREG:
+		nth->dreg = *((uint32_t *)data);
+		break;
+	case NFTNL_EXPR_NTH_DATA:
+		memcpy(&nth->data.val, data, data_len);
+		nth->data.len = data_len;
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static const void *
+nftnl_expr_nth_get(const struct nftnl_expr *e, uint16_t type,
+		   uint32_t *data_len)
+{
+	struct nftnl_expr_nth *nth = nftnl_expr_data(e);
+
+	switch (type) {
+	case NFTNL_EXPR_NTH_DREG:
+		*data_len = sizeof(nth->dreg);
+		return &nth->dreg;
+	case NFTNL_EXPR_NTH_DATA:
+		*data_len = nth->data.len;
+		return &nth->data.val;
+	}
+	return NULL;
+}
+
+static int nftnl_expr_nth_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_NTH_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NFTA_NTH_DREG:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
+	case NFTA_NTH_DATA:
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
+nftnl_expr_nth_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
+{
+	struct nftnl_expr_nth *nth = nftnl_expr_data(e);
+
+	if (e->flags & (1 << NFTNL_EXPR_NTH_DREG))
+		mnl_attr_put_u32(nlh, NFTA_NTH_DREG, htonl(nth->dreg));
+	if (e->flags & (1 << NFTNL_EXPR_NTH_DATA)) {
+		struct nlattr *nest;
+
+		nest = mnl_attr_nest_start(nlh, NFTA_NTH_DATA);
+		mnl_attr_put(nlh, NFTA_DATA_VALUE, nth->data.len,
+			     nth->data.val);
+		mnl_attr_nest_end(nlh, nest);
+	}
+}
+
+static int
+nftnl_expr_nth_parse(struct nftnl_expr *e, struct nlattr *attr)
+{
+	struct nftnl_expr_nth *nth = nftnl_expr_data(e);
+	struct nlattr *tb[NFTA_NTH_MAX+1] = {};
+	int ret = 0;
+
+	if (mnl_attr_parse_nested(attr, nftnl_expr_nth_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_NTH_DREG]) {
+		nth->dreg = ntohl(mnl_attr_get_u32(tb[NFTA_NTH_DREG]));
+		e->flags |= (1 << NFTNL_EXPR_NTH_DREG);
+	}
+	if (tb[NFTA_NTH_DATA]) {
+		ret = nftnl_parse_data(&nth->data, tb[NFTA_NTH_DATA],
+				       NULL);
+		e->flags |= (1 << NFTA_NTH_DATA);
+	}
+
+	return ret;
+}
+
+static int nftnl_expr_nth_json_parse(struct nftnl_expr *e, json_t *root,
+				     struct nftnl_parse_err *err)
+{
+#ifdef JSON_PARSING
+	struct nftnl_expr_nth *nth = nftnl_expr_data(e);
+	uint32_t reg;
+
+	if (nftnl_jansson_node_exist(root, "dreg")) {
+		if (nftnl_jansson_parse_reg(root, "dreg", NFTNL_TYPE_U32,
+					    &reg, err) == 0)
+			nftnl_expr_set_u32(e, NFTNL_EXPR_NTH_DREG, reg);
+	}
+
+	if (nftnl_jansson_data_reg_parse(root, "data",
+					 &nth->data, err) == DATA_VALUE)
+		e->flags |= (1 << NFTNL_EXPR_NTH_DATA);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+
+static int nftnl_expr_nth_xml_parse(struct nftnl_expr *e,
+				    mxml_node_t *tree,
+				    struct nftnl_parse_err *err)
+{
+#ifdef XML_PARSING
+	struct nftnl_expr_nth *nth = nftnl_expr_data(e);
+	uint32_t dreg;
+
+	if (nftnl_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND_FIRST,
+				 NFTNL_XML_OPT, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_NTH_DREG, dreg);
+
+	if (nftnl_mxml_data_reg_parse(tree, "data",
+				      &nth->data, NFTNL_XML_MAND,
+				      err) == DATA_VALUE)
+		e->flags |= (1 << NFTNL_EXPR_NTH_DATA);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
+nftnl_expr_nth_snprintf_default(char *buf, size_t size,
+				const struct nftnl_expr *e)
+{
+	struct nftnl_expr_nth *nth = nftnl_expr_data(e);
+	int len = size, offset = 0, ret;
+
+	ret = nftnl_data_reg_snprintf(buf+offset, len, &nth->data,
+				      NFTNL_OUTPUT_DEFAULT, 0,
+				      DATA_VALUE);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = snprintf(buf, len, "load reg %u ",
+		       nth->dreg);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+static int nftnl_expr_nth_export(char *buf, size_t size,
+				 const struct nftnl_expr *e, int type)
+{
+	struct nftnl_expr_nth *nth = nftnl_expr_data(e);
+
+	NFTNL_BUF_INIT(b, buf, size);
+
+	if (e->flags & (1 << NFTNL_EXPR_NTH_DREG))
+		nftnl_buf_u32(&b, type, nth->dreg, DREG);
+	if (e->flags & (1 << NFTNL_EXPR_NTH_DATA))
+		nftnl_buf_reg(&b, type, &nth->data, DATA_VALUE, DATA);
+
+	return nftnl_buf_done(&b);
+}
+
+static int
+nftnl_expr_nth_snprintf(char *buf, size_t len, uint32_t type,
+			uint32_t flags, const struct nftnl_expr *e)
+{
+	switch (type) {
+	case NFTNL_OUTPUT_DEFAULT:
+		return nftnl_expr_nth_snprintf_default(buf, len, e);
+	case NFTNL_OUTPUT_XML:
+	case NFTNL_OUTPUT_JSON:
+		return nftnl_expr_nth_export(buf, len, e, type);
+	default:
+		break;
+	}
+	return -1;
+}
+
+struct expr_ops expr_ops_nth = {
+	.name		= "nth",
+	.alloc_len	= sizeof(struct nftnl_expr_nth),
+	.max_attr	= NFTA_NTH_MAX,
+	.set		= nftnl_expr_nth_set,
+	.get		= nftnl_expr_nth_get,
+	.parse		= nftnl_expr_nth_parse,
+	.build		= nftnl_expr_nth_build,
+	.snprintf	= nftnl_expr_nth_snprintf,
+	.xml_parse	= nftnl_expr_nth_xml_parse,
+	.json_parse	= nftnl_expr_nth_json_parse,
+};
diff --git a/src/expr_ops.c b/src/expr_ops.c
index ae515af..928bb5e 100644
--- a/src/expr_ops.c
+++ b/src/expr_ops.c
@@ -19,6 +19,7 @@ extern struct expr_ops expr_ops_lookup;
 extern struct expr_ops expr_ops_masq;
 extern struct expr_ops expr_ops_match;
 extern struct expr_ops expr_ops_meta;
+extern struct expr_ops expr_ops_nth;
 extern struct expr_ops expr_ops_nat;
 extern struct expr_ops expr_ops_payload;
 extern struct expr_ops expr_ops_redir;
@@ -43,6 +44,7 @@ static struct expr_ops *expr_ops[] = {
 	&expr_ops_masq,
 	&expr_ops_match,
 	&expr_ops_meta,
+	&expr_ops_nth,
 	&expr_ops_nat,
 	&expr_ops_payload,
 	&expr_ops_redir,
-- 
2.8.1

