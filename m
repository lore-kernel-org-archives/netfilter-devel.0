From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [RFC libnftables PATCH 1/2] src: add expr meta_target
Date: Thu, 28 Nov 2013 12:24:53 +0100
Message-ID: <20131128112453.8424.78042.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36080 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758097Ab3K1LZD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:25:03 -0500
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 4B43751ED76
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Nov 2013 11:25:01 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fM7nUKiTMLPS for <netfilter-devel@vger.kernel.org>;
	Thu, 28 Nov 2013 12:24:54 +0100 (CET)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id C3C4651ED7B
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Nov 2013 12:24:54 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds userspace support for the meta_target expression.

This expression indicates that the packet has to be set with a property,
currently one of mark, priority, nftrace or secmark.

Tests files will be provided in a separated patch.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 0 files changed

diff --git a/include/libnftables/expr.h b/include/libnftables/expr.h
index 54de186..0a9a334 100644
--- a/include/libnftables/expr.h
+++ b/include/libnftables/expr.h
@@ -53,6 +53,11 @@ enum {
 };
 
 enum {
+	NFT_EXPR_META_TARGET_KEY	= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_META_TARGET_VALUE,
+};
+
+enum {
 	NFT_EXPR_CMP_SREG	= NFT_RULE_EXPR_ATTR_BASE,
 	NFT_EXPR_CMP_OP,
 	NFT_EXPR_CMP_DATA,
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 4ec8187..1771791 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -485,6 +485,34 @@ enum nft_meta_attributes {
 #define NFTA_META_MAX		(__NFTA_META_MAX - 1)
 
 /**
+ * enum nft_meta_target_keys - nf_tables meta_target expression keys
+ *
+ * @NFT_META_TARGET_MARK: set packet mark (skb->mark)
+ * @NFT_META_TARGET_PRIORITY: set packet priority (skb->priority)
+ * @NFT_META_TARGET_NFTRACE: to set packet nftrace bit (skb->nf_trace)
+ * @NFT_META_TARGET_SECMARK: set packet secmark (skb->secmark)
+ */
+enum nft_meta_target_keys {
+	NFT_META_TARGET_MARK,
+	NFT_META_TARGET_PRIORITY,
+	NFT_META_TARGET_NFTRACE,
+	NFT_META_TARGET_SECMARK,
+};
+
+/**
+ * enum nft_meta_target_attributes - nf_tables meta_target expression netlink attributes
+ *
+ * @NFTA_META_TARGET_KEY: meta_target item to be set (NLA_U32: nft_meta_target_keys)
+ * @NFTA_META_TARGET_VALUE: value of the item to be set with (NLA_U32)
+ */
+enum nft_meta_target_attributes {
+	NFTA_META_TARGET_KEY,
+	NFTA_META_TARGET_VALUE,
+	__NFTA_META_TARGET_MAX
+};
+#define NFTA_META_TARGET_MAX		(__NFTA_META_TARGET_MAX - 1)
+
+/**
  * enum nft_ct_keys - nf_tables ct expression keys
  *
  * @NFT_CT_STATE: conntrack state (bitmask of enum ip_conntrack_info)
diff --git a/src/Makefile.am b/src/Makefile.am
index 83ab658..96f1174 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -29,6 +29,7 @@ libnftables_la_SOURCES = utils.c		\
 			 expr/immediate.c	\
 			 expr/match.c		\
 			 expr/meta.c		\
+			 expr/meta_target.c	\
 			 expr/nat.c		\
 			 expr/payload.c		\
 			 expr/reject.c		\
diff --git a/src/expr/meta_target.c b/src/expr/meta_target.c
new file mode 100644
index 0000000..fdfddca
--- /dev/null
+++ b/src/expr/meta_target.c
@@ -0,0 +1,266 @@
+/*
+ * (C) 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
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
+#include <libnftables/expr.h>
+#include <libnftables/rule.h>
+#include "expr_ops.h"
+
+#ifndef NFT_META_TARGET_MAX
+#define NFT_META_TARGET_MAX (NFT_META_TARGET_SECMARK + 1)
+#endif
+
+struct nft_expr_meta_target {
+	uint32_t			key;	/* enum nft_meta_target_keys */
+	uint32_t			value;
+};
+
+static int
+nft_rule_expr_meta_target_set(struct nft_rule_expr *e, uint16_t type,
+			      const void *data, uint32_t data_len)
+{
+	struct nft_expr_meta_target *meta_target = nft_expr_data(e);
+
+	switch (type) {
+	case NFT_EXPR_META_TARGET_KEY:
+		meta_target->key = *((uint32_t *)data);
+		break;
+	case NFT_EXPR_META_TARGET_VALUE:
+		meta_target->value = *((uint32_t *)data);
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static const void *
+nft_rule_expr_meta_target_get(const struct nft_rule_expr *e, uint16_t type,
+			      uint32_t *data_len)
+{
+	struct nft_expr_meta_target *meta_target = nft_expr_data(e);
+
+	switch (type) {
+	case NFT_EXPR_META_TARGET_KEY:
+		*data_len = sizeof(meta_target->key);
+		return &meta_target->key;
+	case NFT_EXPR_META_TARGET_VALUE:
+		*data_len = sizeof(meta_target->value);
+		return &meta_target->value;
+	}
+	return NULL;
+}
+
+static int nft_rule_expr_meta_target_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_META_TARGET_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NFTA_META_TARGET_KEY:
+	case NFTA_META_TARGET_VALUE:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
+	default:
+		return MNL_CB_ERROR;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static void
+nft_rule_expr_meta_target_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
+{
+	struct nft_expr_meta_target *meta_target = nft_expr_data(e);
+
+	if (e->flags & (1 << NFT_EXPR_META_TARGET_KEY))
+		mnl_attr_put_u32(nlh, NFTA_META_TARGET_KEY,
+				 htonl(meta_target->key));
+
+	if (e->flags & (1 << NFT_EXPR_META_TARGET_VALUE))
+		mnl_attr_put_u32(nlh, NFTA_META_TARGET_VALUE,
+				 htonl(meta_target->value));
+}
+
+static int
+nft_rule_expr_meta_target_parse(struct nft_rule_expr *e, struct nlattr *attr)
+{
+	uint32_t key, value;
+	struct nft_expr_meta_target *meta_target = nft_expr_data(e);
+	struct nlattr *tb[NFTA_META_TARGET_MAX+1] = {};
+
+	if (mnl_attr_parse_nested(attr, nft_rule_expr_meta_target_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_META_TARGET_KEY]) {
+		key = ntohl(mnl_attr_get_u32(tb[NFTA_META_TARGET_KEY]));
+		meta_target->key = key;
+		e->flags |= (1 << NFT_EXPR_META_TARGET_KEY);
+	}
+
+	if (tb[NFTA_META_TARGET_VALUE]) {
+		value = ntohl(mnl_attr_get_u32(tb[NFTA_META_TARGET_VALUE]));
+		meta_target->value = value;
+		e->flags |= (1 << NFT_EXPR_META_TARGET_VALUE);
+	}
+
+	return 0;
+}
+
+const char *meta_target_key2str_array[NFT_META_TARGET_MAX] = {
+	[NFT_META_TARGET_MARK]		= "mark",
+	[NFT_META_TARGET_PRIORITY]	= "priority",
+	[NFT_META_TARGET_NFTRACE]	= "nftrace",
+	[NFT_META_TARGET_SECMARK]	= "secmark",
+};
+
+static const char *meta_target_key2str(uint8_t key)
+{
+	if (key < NFT_META_TARGET_MAX)
+		return meta_target_key2str_array[key];
+
+	return "unknown";
+}
+
+static inline int str2meta_target_key(const char *str)
+{
+	int i;
+
+	for (i = 0; i < NFT_META_TARGET_MAX; i++) {
+		if (strcmp(str, meta_target_key2str_array[i]) == 0)
+			return i;
+	}
+
+	errno = EINVAL;
+	return -1;
+}
+
+static int nft_rule_expr_meta_target_json_parse(struct nft_rule_expr *e,
+						json_t *root)
+{
+#ifdef JSON_PARSING
+	const char *key_str;
+	int key;
+	uint32_t value;
+
+	key_str = nft_jansson_parse_str(root, "key");
+	if (key_str == NULL)
+		return -1;
+
+	key = str2meta_target_key(key_str);
+	if (key < 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_META_TARGET_KEY, key);
+
+	if (nft_jansson_str2num(root, "value", BASE_HEX, &value,
+				NFT_TYPE_U32) < 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_META_TARGET_VALUE, value);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+
+static int nft_rule_expr_meta_target_xml_parse(struct nft_rule_expr *e,
+					       mxml_node_t *tree)
+{
+#ifdef XML_PARSING
+	const char *key_str;
+	int key;
+	uint32_t value;
+
+	key_str = nft_mxml_str_parse(tree, "key", MXML_DESCEND_FIRST,
+				     NFT_XML_MAND);
+	if (key_str == NULL)
+		return -1;
+
+	key = str2meta_target_key(key_str);
+	if (key < 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_META_TARGET_KEY, key);
+
+	if (nft_mxml_num_parse(tree, "value", MXML_DESCEND_FIRST, BASE_HEX,
+			       &value, NFT_TYPE_U32, NFT_XML_MAND) != 0)
+		return -1;
+
+	nft_rule_expr_set_u32(e, NFT_EXPR_META_TARGET_VALUE, value);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
+nft_rule_expr_meta_target_snprintf(char *buf, size_t len, uint32_t type,
+			    uint32_t flags, struct nft_rule_expr *e)
+{
+	struct nft_expr_meta_target *meta_target = nft_expr_data(e);
+
+	switch (type) {
+	case NFT_OUTPUT_DEFAULT:
+		return snprintf(buf, len, "set %s to value 0x%.8x ",
+				meta_target_key2str(meta_target->key),
+				meta_target->value);
+	case NFT_OUTPUT_XML:
+		return snprintf(buf, len, "<key>%s</key><value>0x%.8x</value>",
+				meta_target_key2str(meta_target->key),
+				meta_target->value);
+	case NFT_OUTPUT_JSON:
+		return snprintf(buf, len, "\"key\":\"%s\","
+				"\"value\":\"0x%.8x\"",
+				meta_target_key2str(meta_target->key),
+				meta_target->value);
+	default:
+		break;
+	}
+	return -1;
+}
+
+struct expr_ops expr_ops_meta_target = {
+	.name		= "meta_target",
+	.alloc_len	= sizeof(struct nft_expr_meta_target),
+	.max_attr	= NFTA_META_TARGET_MAX,
+	.set		= nft_rule_expr_meta_target_set,
+	.get		= nft_rule_expr_meta_target_get,
+	.parse		= nft_rule_expr_meta_target_parse,
+	.build		= nft_rule_expr_meta_target_build,
+	.snprintf	= nft_rule_expr_meta_target_snprintf,
+	.xml_parse	= nft_rule_expr_meta_target_xml_parse,
+	.json_parse	= nft_rule_expr_meta_target_json_parse,
+};
+
+static void __init expr_meta_target_init(void)
+{
+	nft_expr_ops_register(&expr_ops_meta_target);
+}

