From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] expr: add new nft_masq expression
Date: Mon, 08 Sep 2014 13:38:46 +0200
Message-ID: <20140908113846.12172.17163.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:33600 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753231AbaIHLjB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Sep 2014 07:39:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds userspace support to nft_masq, the new expression to perform
masquerade.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/libnftnl/expr.h             |    5 +
 include/linux/netfilter/nf_tables.h |   14 ++
 src/Makefile.am                     |    1 
 src/expr/masq.c                     |  210 +++++++++++++++++++++++++++++++++++
 4 files changed, 230 insertions(+)
 create mode 100644 src/expr/masq.c

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index b493ba8..e599082 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -155,6 +155,11 @@ enum {
 	NFT_EXPR_QUEUE_TOTAL,
 	NFT_EXPR_QUEUE_FLAGS,
 };
+
+enum {
+	NFT_EXPR_MASQ_FLAGS	= NFT_RULE_EXPR_ATTR_BASE,
+};
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index c000947..9bbcb7b 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -785,6 +785,7 @@ enum nft_nat_types {
  * @NFTA_NAT_REG_ADDR_MAX: source register of address range end (NLA_U32: nft_registers)
  * @NFTA_NAT_REG_PROTO_MIN: source register of proto range start (NLA_U32: nft_registers)
  * @NFTA_NAT_REG_PROTO_MAX: source register of proto range end (NLA_U32: nft_registers)
+ * @NFTA_NAT_FLAGS: additional NAT configuration (NF_NAT_RANGE_*) (NLA_U32)
  */
 enum nft_nat_attributes {
 	NFTA_NAT_UNSPEC,
@@ -794,8 +795,21 @@ enum nft_nat_attributes {
 	NFTA_NAT_REG_ADDR_MAX,
 	NFTA_NAT_REG_PROTO_MIN,
 	NFTA_NAT_REG_PROTO_MAX,
+	NFTA_NAT_FLAGS,
 	__NFTA_NAT_MAX
 };
 #define NFTA_NAT_MAX		(__NFTA_NAT_MAX - 1)
 
+/**
+ * enum nft_masq_attributes - nf_tables masquerade expression attributes
+ *
+ * @NFTA_MASQ_FLAGS: additional masquerade configuration (NF_NAT_RANGE_*) (NLA_U32)
+ */
+enum nft_masq_attributes {
+	NFTA_MASQ_FLAGS,
+	__NFTA_MASQ_MAX
+};
+#define NFTA_MASQ_MAX		(__NFTA_MASQ_MAX - 1)
+
+
 #endif /* _LINUX_NF_TABLES_H */
diff --git a/src/Makefile.am b/src/Makefile.am
index 047bf01..d57ff96 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -35,6 +35,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      expr/queue.c	\
 		      expr/reject.c	\
 		      expr/target.c	\
+		      expr/masq.c	\
 		      expr/data_reg.h	\
 		      libnftnl.map	\
 		      expr_ops.h	\
diff --git a/src/expr/masq.c b/src/expr/masq.c
new file mode 100644
index 0000000..568191e
--- /dev/null
+++ b/src/expr/masq.c
@@ -0,0 +1,210 @@
+/*
+ * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
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
+#include "expr_ops.h"
+
+struct nft_expr_masq {
+	uint32_t	flags;
+};
+
+static int
+nft_rule_expr_masq_set(struct nft_rule_expr *e, uint16_t type,
+		       const void *data, uint32_t data_len)
+{
+	struct nft_expr_masq *masq = nft_expr_data(e);
+
+	switch (type) {
+	case NFT_EXPR_MASQ_FLAGS:
+		masq->flags = *((uint32_t *)data);
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static const void *
+nft_rule_expr_masq_get(const struct nft_rule_expr *e, uint16_t type,
+		       uint32_t *data_len)
+{
+	struct nft_expr_masq *masq = nft_expr_data(e);
+
+	switch (type) {
+	case NFT_EXPR_MASQ_FLAGS:
+		*data_len = sizeof(masq->flags);
+		return &masq->flags;
+	}
+	return NULL;
+}
+
+static int nft_rule_expr_masq_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_MASQ_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NFTA_MASQ_FLAGS:
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
+nft_rule_expr_masq_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
+{
+	struct nft_expr_masq *masq = nft_expr_data(e);
+
+	if (e->flags & (1 << NFT_EXPR_MASQ_FLAGS))
+		mnl_attr_put_u32(nlh, NFTA_MASQ_FLAGS, htobe32(masq->flags));
+}
+
+static int
+nft_rule_expr_masq_parse(struct nft_rule_expr *e, struct nlattr *attr)
+{
+	struct nft_expr_masq *masq = nft_expr_data(e);
+	struct nlattr *tb[NFTA_MASQ_MAX+1] = {};
+
+	if (mnl_attr_parse_nested(attr, nft_rule_expr_masq_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_MASQ_FLAGS]) {
+		masq->flags = be32toh(mnl_attr_get_u32(tb[NFTA_MASQ_FLAGS]));
+		e->flags |= (1 << NFT_EXPR_MASQ_FLAGS);
+	}
+
+	return 0;
+}
+
+static int
+nft_rule_expr_masq_json_parse(struct nft_rule_expr *e, json_t *root,
+			      struct nft_parse_err *err)
+{
+#ifdef JSON_PARSING
+	uint32_t flags;
+
+	if (nft_jansson_parse_val(root, "flags", NFT_TYPE_U32, &flags,
+				  err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_MASQ_FLAGS, flags);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
+nft_rule_expr_masq_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
+			     struct nft_parse_err *err)
+{
+#ifdef XML_PARSING
+	uint32_t flags;
+
+	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
+			       &flags, NFT_TYPE_U32, NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_MASQ_FLAGS, flags);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+static int nft_rule_expr_masq_snprintf_json(char *buf, size_t len,
+					    struct nft_rule_expr *e)
+{
+	int ret, size = len, offset = 0;
+	struct nft_expr_masq *masq = nft_expr_data(e);
+
+	if (e->flags & (1 << NFT_EXPR_MASQ_FLAGS)) {
+		ret = snprintf(buf + offset, len, "\"flags\":%u", masq->flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
+}
+
+static int nft_rule_expr_masq_snprintf_xml(char *buf, size_t len,
+					   struct nft_rule_expr *e)
+{
+	int ret, size = len, offset = 0;
+	struct nft_expr_masq *masq = nft_expr_data(e);
+
+	if (e->flags & (1 << NFT_EXPR_MASQ_FLAGS)) {
+		ret = snprintf(buf + offset, len, "<flags>%u</flags>",
+			       masq->flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
+}
+
+static int nft_rule_expr_masq_snprintf_default(char *buf, size_t len,
+					       struct nft_rule_expr *e)
+{
+	struct nft_expr_masq *masq = nft_expr_data(e);
+
+	return snprintf(buf, len, " flags %u ",
+			 masq->flags);
+}
+
+static int nft_rule_expr_masq_snprintf(char *buf, size_t len, uint32_t type,
+				       uint32_t flags, struct nft_rule_expr *e)
+{
+	switch (type) {
+	case NFT_OUTPUT_DEFAULT:
+		return nft_rule_expr_masq_snprintf_default(buf, len, e);
+	case NFT_OUTPUT_XML:
+		return nft_rule_expr_masq_snprintf_xml(buf, len, e);
+	case NFT_OUTPUT_JSON:
+		return nft_rule_expr_masq_snprintf_json(buf, len, e);
+	default:
+		break;
+	}
+	return -1;
+}
+
+struct expr_ops expr_ops_masq = {
+	.name		= "masq",
+	.alloc_len	= sizeof(struct nft_expr_masq),
+	.max_attr	= NFTA_MASQ_MAX,
+	.set		= nft_rule_expr_masq_set,
+	.get		= nft_rule_expr_masq_get,
+	.parse		= nft_rule_expr_masq_parse,
+	.build		= nft_rule_expr_masq_build,
+	.snprintf	= nft_rule_expr_masq_snprintf,
+	.xml_parse	= nft_rule_expr_masq_xml_parse,
+	.json_parse	= nft_rule_expr_masq_json_parse,
+};
+
+static void __init expr_masq_init(void)
+{
+	nft_expr_ops_register(&expr_ops_masq);
+}

