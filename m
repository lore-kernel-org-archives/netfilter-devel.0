From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] expr: add new nft_tee expression
Date: Fri, 19 Jun 2015 12:22:38 +0200
Message-ID: <1434709358-29261-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36052 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbbFSKR0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2015 06:17:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Arturo Borrero <arturo.borrero.glez@gmail.com>

This patch gives support in libnftnl to the new nft_tee expression.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/libnftnl/expr.h             |    5 +
 include/linux/netfilter/nf_tables.h |   14 +++
 src/Makefile.am                     |    1 +
 src/expr/tee.c                      |  234 +++++++++++++++++++++++++++++++++++
 src/expr_ops.c                      |    2 +
 5 files changed, 256 insertions(+)
 create mode 100644 src/expr/tee.c

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 94ff125..39c2f0e 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -174,6 +174,11 @@ enum {
 	NFT_EXPR_REDIR_FLAGS,
 };
 
+enum {
+	NFT_EXPR_TEE_SREG_GW		= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_TEE_OIFNAME,
+};
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index fa05fbe..22af138 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -950,6 +950,20 @@ enum nft_redir_attributes {
 #define NFTA_REDIR_MAX		(__NFTA_REDIR_MAX - 1)
 
 /**
+ * enum nft_tee_attributes - nf_tables tee expression netlink attributes
+ *
+ * @NFTA_TEE_SREG_GW: source register of gateway address (NLA_NESTED: nft_data_attributes)
+ * @NFTA_TEE_OIFNAME: output interface name (NLA_STRING)
+ */
+enum nft_tee_attributes {
+	NFTA_TEE_UNSPEC,
+	NFTA_TEE_SREG_GW,
+	NFTA_TEE_OIFNAME,
+	__NFTA_TEE_MAX
+};
+#define NFTA_TEE_MAX		(__NFTA_TEE_MAX - 1)
+
+/**
  * enum nft_gen_attributes - nf_tables ruleset generation attributes
  *
  * @NFTA_GEN_ID: Ruleset generation ID (NLA_U32)
diff --git a/src/Makefile.am b/src/Makefile.am
index dd87240..7c3a25e 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -41,4 +41,5 @@ libnftnl_la_SOURCES = utils.c		\
 		      expr/target.c	\
 		      expr/masq.c	\
 		      expr/redir.c	\
+		      expr/tee.c	\
 		      libnftnl.map
diff --git a/src/expr/tee.c b/src/expr/tee.c
new file mode 100644
index 0000000..16d7d92
--- /dev/null
+++ b/src/expr/tee.c
@@ -0,0 +1,234 @@
+/*
+ * (C) 2015 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
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
+#ifndef IFNAMSIZ
+#define IFNAMSIZ	16
+#endif
+
+struct nft_expr_tee {
+	enum nft_registers	sreg_gw;
+	char			oifname[IFNAMSIZ];
+};
+
+static int nft_rule_expr_tee_set(struct nft_rule_expr *e, uint16_t type,
+				 const void *data, uint32_t data_len)
+{
+	struct nft_expr_tee *tee = nft_expr_data(e);
+
+	switch (type) {
+	case NFT_EXPR_TEE_SREG_GW:
+		tee->sreg_gw = *((uint32_t *)data);
+		break;
+	case NFT_EXPR_TEE_OIFNAME:
+		strncpy(tee->oifname, data, IFNAMSIZ);
+		tee->oifname[IFNAMSIZ - 1] = '\0';
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static const void *nft_rule_expr_tee_get(const struct nft_rule_expr *e,
+					 uint16_t type, uint32_t *data_len)
+{
+	struct nft_expr_tee *tee = nft_expr_data(e);
+
+	switch (type) {
+	case NFT_EXPR_TEE_SREG_GW:
+		*data_len = sizeof(tee->sreg_gw);
+		return &tee->sreg_gw;
+	case NFT_EXPR_TEE_OIFNAME:
+		*data_len = strlen(tee->oifname) + 1;
+		return tee->oifname;
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
+	case NFTA_TEE_SREG_GW:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
+	case NFTA_TEE_OIFNAME:
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static void nft_rule_expr_tee_build(struct nlmsghdr *nlh,
+				    struct nft_rule_expr *e)
+{
+	struct nft_expr_tee *tee = nft_expr_data(e);
+
+	if (e->flags & (1 << NFT_EXPR_TEE_SREG_GW))
+		mnl_attr_put_u32(nlh, NFTA_TEE_SREG_GW, htonl(tee->sreg_gw));
+	if (e->flags & (1 << NFT_EXPR_TEE_OIFNAME))
+		mnl_attr_put_strz(nlh, NFTA_TEE_OIFNAME, tee->oifname);
+}
+
+static int nft_rule_expr_tee_parse(struct nft_rule_expr *e, struct nlattr *attr)
+{
+	struct nft_expr_tee *tee = nft_expr_data(e);
+	struct nlattr *tb[NFTA_TEE_MAX + 1] = {};
+	int ret = 0;
+
+	if (mnl_attr_parse_nested(attr, nft_rule_expr_tee_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_TEE_OIFNAME]) {
+		strncpy(tee->oifname, mnl_attr_get_str(tb[NFTA_TEE_OIFNAME]),
+			sizeof(tee->oifname));
+		tee->oifname[IFNAMSIZ - 1] = '\0';
+		e->flags |= (1 << NFT_EXPR_TEE_OIFNAME);
+	}
+	if (tb[NFTA_TEE_SREG_GW]) {
+		tee->sreg_gw = ntohl(mnl_attr_get_u32(tb[NFTA_TEE_SREG_GW]));
+		e->flags |= (1 << NFT_EXPR_TEE_SREG_GW);
+	}
+
+	return ret;
+}
+
+static int nft_rule_expr_tee_json_parse(struct nft_rule_expr *e, json_t *root,
+					struct nft_parse_err *err)
+{
+#ifdef JSON_PARSING
+	struct nft_expr_tee *tee = nft_expr_data(e);
+	int datareg_type;
+	const char *oifname;
+
+	oifname = nft_jansson_parse_str(root, "oifname", err);
+	if (oifname != NULL)
+		nft_rule_expr_set_str(e, NFT_EXPR_TEE_OIFNAME, oifname);
+
+	ret = nft_jansson_parse_val(root, "sreg_gw", NFT_TYPE_U32, &sreg_gw, err);
+	if (ret >= 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_TEE_SREG_GW, sreg_gw);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int nft_rule_expr_tee_xml_parse(struct nft_rule_expr *e,
+				       mxml_node_t *tree,
+				       struct nft_parse_err *err)
+{
+#ifdef XML_PARSING
+	struct nft_expr_tee *tee = nft_expr_data(e);
+	const char *oifname;
+	uint32_t sreg_gw;
+
+	oifname = nft_mxml_str_parse(tree, "oifname", MXML_DESCEND_FIRST,
+				     NFT_XML_OPT, err);
+	if (oifname != NULL)
+		nft_rule_expr_set_str(e, NFT_EXPR_TEE_OIFNAME, oifname);
+
+	if (nft_mxml_reg_parse(tree, "sreg_gw", &sreg_gw, MXML_DESCEND_FIRST,
+			       NFT_XML_OPT, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_TEE_SREG_GW, sreg_gw);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int nft_rule_expr_tee_export(char *buf, size_t size,
+				    struct nft_rule_expr *e, int type)
+{
+	struct nft_expr_tee *tee = nft_expr_data(e);
+	NFT_BUF_INIT(b, buf, size);
+
+	if (e->flags & (1 << NFT_EXPR_TEE_SREG_GW))
+		nft_buf_u32(&b, type, tee->sreg_gw, "sreg_gw");
+	if (e->flags & (1 << NFT_EXPR_TEE_OIFNAME))
+		nft_buf_str(&b, type, tee->oifname, "oifname");
+
+	return nft_buf_done(&b);
+}
+
+static int nft_rule_expr_tee_snprintf_default(char *buf, size_t len,
+					      struct nft_rule_expr *e,
+					      uint32_t flags)
+{
+	int size = len, offset = 0, ret;
+	struct nft_expr_tee *tee = nft_expr_data(e);
+
+	if (e->flags & (1 << NFT_EXPR_TEE_SREG_GW)) {
+		ret = snprintf(buf + offset, len, "sreg_gw %u", tee->sreg_gw);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (e->flags & (1 << NFT_EXPR_TEE_OIFNAME)) {
+		ret = snprintf(buf + offset, len, "oifname %s", tee->oifname);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
+}
+
+static int nft_rule_expr_tee_snprintf(char *buf, size_t len, uint32_t type,
+				      uint32_t flags, struct nft_rule_expr *e)
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
diff --git a/src/expr_ops.c b/src/expr_ops.c
index 2de5805..3fea180 100644
--- a/src/expr_ops.c
+++ b/src/expr_ops.c
@@ -23,6 +23,7 @@ extern struct expr_ops expr_ops_redir;
 extern struct expr_ops expr_ops_reject;
 extern struct expr_ops expr_ops_queue;
 extern struct expr_ops expr_ops_target;
+extern struct expr_ops expr_ops_tee;
 extern struct expr_ops expr_ops_dynset;
 
 static struct expr_ops *expr_ops[] = {
@@ -45,6 +46,7 @@ static struct expr_ops *expr_ops[] = {
 	&expr_ops_reject,
 	&expr_ops_queue,
 	&expr_ops_target,
+	&expr_ops_tee,
 	&expr_ops_dynset,
 	NULL,
 };
-- 
1.7.10.4

