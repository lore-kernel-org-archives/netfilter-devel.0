From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [RFC PATCH] src/expr: add new nft_tee expression
Date: Wed, 11 Feb 2015 19:40:26 +0100
Message-ID: <20150211184026.5199.36185.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:57005 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753104AbbBKSkh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2015 13:40:37 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch gives support in libnftnl to the new nft_tee expression.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/libnftnl/expr.h             |    5 +
 include/linux/netfilter/nf_tables.h |   14 ++
 src/Makefile.am                     |    1 
 src/expr/tee.c                      |  280 +++++++++++++++++++++++++++++++++++
 4 files changed, 300 insertions(+)
 create mode 100644 src/expr/tee.c

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 9f25993..868a681 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -167,6 +167,11 @@ enum {
 	NFT_EXPR_REDIR_FLAGS,
 };
 
+enum {
+	NFT_EXPR_TEE_GW			= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_TEE_OIF,
+};
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 832bc46..8dade0a 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -856,6 +856,20 @@ enum nft_redir_attributes {
 #define NFTA_REDIR_MAX		(__NFTA_REDIR_MAX - 1)
 
 /**
+ * enum nft_tee_attributes - nf_tables tee expression netlink attributes
+ *
+ * @NFTA_TEE_GW: tee gateway (NLA_NESTED: nft_data_attributes)
+ * @NFTA_TEE_OIF: tee output interface name (NLA_STRING)
+ */
+enum nft_tee_attributes {
+	NFTA_TEE_UNSPEC,
+	NFTA_TEE_GW,
+	NFTA_TEE_OIF,
+	__NFTA_TEE_MAX
+};
+#define NFTA_TEE_MAX		(__NFTA_TEE_MAX - 1)
+
+/**
  * enum nft_gen_attributes - nf_tables ruleset generation attributes
  *
  * @NFTA_GEN_ID: Ruleset generation ID (NLA_U32)
diff --git a/src/Makefile.am b/src/Makefile.am
index c77c3cc..c77bd49 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -39,6 +39,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      expr/target.c	\
 		      expr/masq.c	\
 		      expr/redir.c	\
+		      expr/tee.c	\
 		      expr/data_reg.h	\
 		      libnftnl.map	\
 		      expr_ops.h	\
diff --git a/src/expr/tee.c b/src/expr/tee.c
new file mode 100644
index 0000000..f6808d0
--- /dev/null
+++ b/src/expr/tee.c
@@ -0,0 +1,280 @@
+/*
+ * (C) 2015 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
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
+struct nft_expr_tee {
+	union nft_data_reg	data;
+	char			*oif;
+};
+
+static int
+nft_rule_expr_tee_set(struct nft_rule_expr *e, uint16_t type,
+		      const void *data, uint32_t data_len)
+{
+	struct nft_expr_tee *tee = nft_expr_data(e);
+
+	switch (type) {
+	case NFT_EXPR_TEE_GW:
+		memcpy(&tee->data.val, data, data_len);
+		tee->data.len = data_len;
+		break;
+	case NFT_EXPR_TEE_OIF:
+		if (tee->oif)
+			xfree(tee->oif);
+
+		tee->oif = strdup(data);
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static const void *
+nft_rule_expr_tee_get(const struct nft_rule_expr *e, uint16_t type,
+		      uint32_t *data_len)
+{
+	struct nft_expr_tee *tee = nft_expr_data(e);
+
+	switch (type) {
+	case NFT_EXPR_TEE_GW:
+		*data_len = tee->data.len;
+		return &tee->data.val;
+	case NFT_EXPR_TEE_OIF:
+		*data_len = strlen(tee->oif) + 1;
+		return tee->oif;
+	}
+	return NULL;
+}
+
+static int nft_rule_expr_tee_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_TEE_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NFTA_TEE_GW:
+		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0)
+			abi_breakage();
+		break;
+	case NFTA_TEE_OIF:
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
+nft_rule_expr_tee_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
+{
+	struct nft_expr_tee *tee = nft_expr_data(e);
+
+	if (e->flags & (1 << NFT_EXPR_TEE_GW)) {
+		struct nlattr *nest;
+
+		nest = mnl_attr_nest_start(nlh, NFTA_TEE_GW);
+		mnl_attr_put(nlh, NFTA_DATA_VALUE, tee->data.len,
+			     tee->data.val);
+		mnl_attr_nest_end(nlh, nest);
+	}
+
+	if (e->flags & (1 << NFT_EXPR_TEE_OIF))
+		mnl_attr_put_strz(nlh, NFTA_TEE_OIF, tee->oif);
+}
+
+static int
+nft_rule_expr_tee_parse(struct nft_rule_expr *e, struct nlattr *attr)
+{
+	struct nft_expr_tee *tee = nft_expr_data(e);
+	struct nlattr *tb[NFTA_TEE_MAX + 1] = {};
+	int ret = 0;
+
+	if (mnl_attr_parse_nested(attr, nft_rule_expr_tee_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_TEE_OIF]) {
+		strcpy(tee->oif, mnl_attr_get_str(tb[NFTA_TEE_OIF]));
+		e->flags |= (1 << NFT_EXPR_TEE_OIF);
+	}
+	if (tb[NFTA_TEE_GW]) {
+		int type;
+
+		ret = nft_parse_data(&tee->data, tb[NFTA_TEE_GW], &type);
+		if (ret < 0)
+			return ret;
+
+		switch (type) {
+		case DATA_VALUE:
+			e->flags |= (1 << NFT_EXPR_TEE_GW);
+			break;
+		default:
+			return -1;
+		}
+	}
+
+	return ret;
+}
+
+static int
+nft_rule_expr_tee_json_parse(struct nft_rule_expr *e, json_t *root,
+			     struct nft_parse_err *err)
+{
+#ifdef JSON_PARSING
+	struct nft_expr_tee *tee = nft_expr_data(e);
+	int datareg_type;
+	const char *oif;
+
+	/* XXX parse oif */
+	oif = nft_jansson_parse_str(root, "oif", err);
+	if (oif != NULL)
+		nft_rule_expr_set_str(e, NFT_EXPR_TEE_OIF, oif);
+
+	datareg_type = nft_jansson_data_reg_parse(root, "gw",
+						  &tee->data, err);
+	if (datareg_type >= 0) {
+		switch (datareg_type) {
+		case DATA_VALUE:
+			e->flags |= (1 << NFT_EXPR_TEE_GW);
+			break;
+		default:
+			return -1;
+		}
+	}
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
+nft_rule_expr_tee_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
+			    struct nft_parse_err *err)
+{
+#ifdef XML_PARSING
+	struct nft_expr_tee *tee = nft_expr_data(e);
+	int datareg_type;
+	const char *oif;
+
+	/* XXX parse oif */
+	oif = nft_mxml_str_parse(tree, "oif", MXML_DESCEND_FIRST,
+				 NFT_XML_OPT, err);
+	if (oif != NULL)
+		nft_rule_expr_set_str(e, NFT_EXPR_TEE_OIF, oif);
+
+
+	datareg_type = nft_mxml_data_reg_parse(tree, "gw", &tee->data,
+					       NFT_XML_MAND, err);
+	if (datareg_type >= 0) {
+		switch (datareg_type) {
+		case DATA_VALUE:
+			e->flags |= (1 << NFT_EXPR_TEE_GW);
+			break;
+		default:
+			return -1;
+		}
+	}
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
+nft_rule_expr_tee_export(char *buf, size_t size, struct nft_rule_expr *e,
+			 int type)
+{
+	struct nft_expr_tee *tee = nft_expr_data(e);
+	NFT_BUF_INIT(b, buf, size);
+
+	if (e->flags & (1 << NFT_EXPR_TEE_GW))
+		nft_buf_reg(&b, type, &tee->data, DATA_VALUE, "gw");
+	if (e->flags & (1 << NFT_EXPR_TEE_OIF))
+		nft_buf_str(&b, type, tee->oif, "oif");
+
+	return nft_buf_done(&b);
+}
+
+static int
+nft_rule_expr_tee_snprintf_default(char *buf, size_t len,
+				   struct nft_rule_expr *e, uint32_t flags)
+{
+	int size = len, offset = 0, ret;
+	struct nft_expr_tee *tee = nft_expr_data(e);
+
+	if (e->flags & (1 << NFT_EXPR_TEE_GW)) {
+		ret = nft_data_reg_snprintf(buf + offset, len, &tee->data,
+					    NFT_OUTPUT_DEFAULT, flags,
+					    DATA_VALUE);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	}
+
+	if (e->flags & (1 << NFT_EXPR_TEE_OIF)) {
+		ret = snprintf(buf + offset, len, "oif %s", tee->oif);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
+}
+
+static int
+nft_rule_expr_tee_snprintf(char *buf, size_t len, uint32_t type,
+				 uint32_t flags, struct nft_rule_expr *e)
+{
+	switch (type) {
+	case NFT_OUTPUT_DEFAULT:
+		return nft_rule_expr_tee_snprintf_default(buf, len, e, flags);
+	case NFT_OUTPUT_XML:
+	case NFT_OUTPUT_JSON:
+		return nft_rule_expr_tee_export(buf, len, e, type);
+	default:
+		break;
+	}
+	return -1;
+}
+
+struct expr_ops expr_ops_tee = {
+	.name		= "tee",
+	.alloc_len	= sizeof(struct nft_expr_tee),
+	.max_attr	= NFTA_TEE_MAX,
+	.set		= nft_rule_expr_tee_set,
+	.get		= nft_rule_expr_tee_get,
+	.parse		= nft_rule_expr_tee_parse,
+	.build		= nft_rule_expr_tee_build,
+	.snprintf	= nft_rule_expr_tee_snprintf,
+	.xml_parse	= nft_rule_expr_tee_xml_parse,
+	.json_parse	= nft_rule_expr_tee_json_parse,
+};
+
+static void __init expr_tee_init(void)
+{
+	nft_expr_ops_register(&expr_ops_tee);
+}

