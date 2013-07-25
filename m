From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] src: xml: consolidate common XML code via
	nft_mxml_num_parse
Date: Thu, 25 Jul 2013 18:46:35 +0200
Message-ID: <20130725164635.7561.69092.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:51698 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755970Ab3GYQqs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:46:48 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id E27EE51EEAA
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2013 16:46:43 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xqQa4Gm01nMy for <netfilter-devel@vger.kernel.org>;
	Thu, 25 Jul 2013 18:46:37 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id BBF6A51EEA9
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2013 18:46:37 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch moves common XML parsing code to nft_mxml_num_parse().
To handle this, the nft_strtol() helper fuction is included.

I've changed some MXML_DESCEND[_FIRST] flags to avoid match a nested node under
some circumstances, ie, matching two nodes with the same name that are descendant.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 0 files changed

diff --git a/src/chain.c b/src/chain.c
index 3fb1d03..ad50a04 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -575,18 +575,12 @@ static int nft_chain_xml_parse(struct nft_chain *c, char *xml)
 	c->flags |= (1 << NFT_CHAIN_ATTR_TABLE);
 
 	/* Get and set <prio> */
-	node = mxmlFindElement(tree, tree, "prio", NULL, NULL, MXML_DESCEND);
-	if (node == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
-	tmp = strtoll(node->child->value.opaque, &endptr, 10);
-	if (tmp > INT32_MAX || tmp < INT32_MIN || *endptr) {
+	if (nft_mxml_num_parse(tree, "prio", MXML_DESCEND, 10, &c->prio,
+			       NFT_TYPE_S32) != 0) {
 		mxmlDelete(tree);
 		return -1;
 	}
 
-	memcpy(&c->prio, &tmp, sizeof(c->prio));
 	c->flags |= (1 << NFT_CHAIN_ATTR_PRIO);
 
 	/* Ignore <use> (cannot be set)*/
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 84de249..f0a2eff 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -201,6 +201,12 @@ nft_rule_expr_bitwise_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 	bitwise->dreg = reg;
 	e->flags |= (1 << NFT_EXPR_BITWISE_DREG);
 
+	if (nft_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST,
+			       BASE_DEC, &bitwise->len, NFT_TYPE_U8) != 0)
+		return -1;
+
+	e->flags |= (1 << NFT_EXPR_BITWISE_LEN);
+
 	if (nft_mxml_data_reg_parse(tree, "mask",
 				    &bitwise->mask) != DATA_VALUE)
 		return -1;
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index e3b9a5e..a931ffa 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -187,8 +187,6 @@ nft_rule_expr_byteorder_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 #ifdef XML_PARSING
 	struct nft_expr_byteorder *byteorder = nft_expr_data(e);
 	mxml_node_t *node = NULL;
-	uint64_t tmp;
-	char *endptr = NULL;
 	int32_t reg;
 
 	reg = nft_mxml_reg_parse(tree, "sreg", MXML_DESCEND_FIRST);
@@ -218,26 +216,16 @@ nft_rule_expr_byteorder_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 
 	e->flags |= (1 << NFT_EXPR_BYTEORDER_OP);
 
-	node = mxmlFindElement(tree, tree, "len", NULL, NULL, MXML_DESCEND);
-	if (node == NULL)
-		goto err;
-
-	tmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (tmp > UINT8_MAX || tmp < 0 || *endptr)
+	if (nft_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_DEC,
+			       &byteorder->len, NFT_TYPE_U8) != 0)
 		goto err;
 
-	byteorder->len = tmp;
 	e->flags |= (1 << NFT_EXPR_BYTEORDER_LEN);
 
-	node = mxmlFindElement(tree, tree, "size", NULL, NULL, MXML_DESCEND);
-	if (node == NULL)
-		goto err;
-
-	tmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (tmp > UINT8_MAX || tmp < 0 || *endptr)
+	if (nft_mxml_num_parse(tree, "size", MXML_DESCEND_FIRST, BASE_DEC,
+			       &byteorder->size, NFT_TYPE_U8) != 0)
 		goto err;
 
-	byteorder->size = tmp;
 	e->flags |= (1 << NFT_EXPR_BYTEORDER_SIZE);
 
 	return 0;
diff --git a/src/expr/ct.c b/src/expr/ct.c
index f399219..a0323e1 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -183,10 +183,9 @@ static int nft_rule_expr_ct_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree
 #ifdef XML_PARSING
 	struct nft_expr_ct *ct = nft_expr_data(e);
 	mxml_node_t *node = NULL;
-	uint64_t tmp;
 	int32_t reg;
-	char *endptr;
 	int key;
+	uint8_t dir;
 
 	reg = nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST);
 	if (reg < 0)
@@ -206,18 +205,14 @@ static int nft_rule_expr_ct_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree
 	ct->key = key;
 	e->flags |= (1 << NFT_EXPR_CT_KEY);
 
-	node = mxmlFindElement(tree, tree, "dir", NULL, NULL, MXML_DESCEND);
-	if (node == NULL)
-		goto err;
-
-	tmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (tmp > UINT8_MAX || tmp < 0 || *endptr)
+	if (nft_mxml_num_parse(tree, "dir", MXML_DESCEND_FIRST, BASE_DEC, &dir,
+			       NFT_TYPE_U8) != 0)
 		goto err;
 
-	if (tmp != IP_CT_DIR_ORIGINAL && tmp != IP_CT_DIR_REPLY)
+	if (dir != IP_CT_DIR_ORIGINAL && dir != IP_CT_DIR_REPLY)
 		goto err;
 
-	ct->dir = tmp;
+	ct->dir = dir;
 	e->flags |= (1 << NFT_EXPR_CT_DIR);
 
 	return 0;
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 260ae59..87d06b2 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -134,9 +134,6 @@ static int nft_data_reg_value_xml_parse(union nft_data_reg *reg, char *xml)
 	mxml_node_t *tree = NULL;
 	mxml_node_t *node = NULL;
 	int i;
-	int64_t tmp;
-	uint64_t utmp;
-	char *endptr;
 	char node_name[6];
 
 	tree = mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
@@ -173,37 +170,22 @@ static int nft_data_reg_value_xml_parse(union nft_data_reg *reg, char *xml)
 	}
 
 	/* Get <len> */
-	node = mxmlFindElement(tree, tree, "len", NULL, NULL, MXML_DESCEND);
-	if (node == NULL) {
+	if (nft_mxml_num_parse(tree, "len", MXML_DESCEND, BASE_DEC, &reg->len,
+			       NFT_TYPE_S64) != 0) {
 		mxmlDelete(tree);
 		return -1;
 	}
 
-	tmp = strtoll(node->child->value.opaque, &endptr, 10);
-	if (tmp > INT64_MAX || tmp < 0 || *endptr) {
-		mxmlDelete(tree);
-		return -1;
-	}
-
-	reg->len = tmp;
-
 	/* Get and set <dataN> */
 	for (i = 0; i < div_round_up(reg->len, sizeof(uint32_t)); i++) {
 		sprintf(node_name, "data%d", i);
 
-		node = mxmlFindElement(tree, tree, node_name, NULL,
-				       NULL, MXML_DESCEND);
-		if (node == NULL) {
+		if (nft_mxml_num_parse(tree, node_name, MXML_DESCEND, BASE_HEX,
+				       &reg->val[i], NFT_TYPE_U32) != 0) {
 			mxmlDelete(tree);
 			return -1;
 		}
 
-		utmp = strtoull(node->child->value.opaque, &endptr, 16);
-		if (utmp == UINT64_MAX || utmp < 0 || *endptr) {
-			mxmlDelete(tree);
-			return -1;
-		}
-		reg->val[i] = utmp;
 	}
 
 	mxmlDelete(tree);
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 51e784e..9653bd2 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -199,8 +199,6 @@ nft_rule_expr_exthdr_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 #ifdef XML_PARSING
 	struct nft_expr_exthdr *exthdr = nft_expr_data(e);
 	mxml_node_t *node = NULL;
-	uint64_t tmp;
-	char *endptr;
 	int32_t reg;
 	int type;
 
@@ -225,28 +223,17 @@ nft_rule_expr_exthdr_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 	e->flags |= (1 << NFT_EXPR_EXTHDR_TYPE);
 
 	/* Get and set <offset> */
-	node = mxmlFindElement(tree, tree, "offset", NULL, NULL,
-			       MXML_DESCEND);
-	if (node == NULL)
-		return -1;
-
-	tmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (tmp > UINT_MAX || tmp < 0 || *endptr)
+	if (nft_mxml_num_parse(tree, "offset", MXML_DESCEND_FIRST, BASE_DEC,
+			       &exthdr->offset, NFT_TYPE_UINT) != 0)
 		return -1;
 
-	exthdr->offset = tmp;
 	e->flags |= (1 << NFT_EXPR_EXTHDR_OFFSET);
 
 	/* Get and set <len> */
-	node = mxmlFindElement(tree, tree, "len", NULL, NULL, MXML_DESCEND);
-	if (node == NULL)
-		return -1;
-
-	tmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (tmp > UINT_MAX || tmp < 0 || *endptr)
+	if (nft_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_DEC,
+			       &exthdr->len, NFT_TYPE_UINT) != 0)
 		return -1;
 
-	exthdr->len = tmp;
 	e->flags |= (1 << NFT_EXPR_EXTHDR_LEN);
 
 	return 0;
diff --git a/src/expr/limit.c b/src/expr/limit.c
index 2ecf7cb..27f880c 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -122,32 +122,17 @@ static int nft_rule_expr_limit_xml_parse(struct nft_rule_expr *e, mxml_node_t *t
 {
 #ifdef XML_PARSING
 	struct nft_expr_limit *limit = nft_expr_data(e);
-	mxml_node_t *node = NULL;
-	uint64_t tmp;
-	char *endptr;
 
-	node = mxmlFindElement(tree, tree, "rate", NULL, NULL,
-			       MXML_DESCEND_FIRST);
-	if (node == NULL)
+	if (nft_mxml_num_parse(tree, "rate", MXML_DESCEND_FIRST, BASE_DEC,
+			       &limit->rate, NFT_TYPE_U64) != 0)
 		goto err;
 
-	tmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (tmp > UINT64_MAX || tmp < 0 || *endptr)
-		goto err;
-
-	limit->rate = tmp;
 	e->flags |= (1 << NFT_EXPR_LIMIT_RATE);
 
-	node = mxmlFindElement(tree, tree, "depth", NULL, NULL,
-			       MXML_DESCEND);
-	if (node == NULL)
-		goto err;
-
-	tmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (tmp > UINT64_MAX || tmp < 0 || *endptr)
+	if (nft_mxml_num_parse(tree, "depth", MXML_DESCEND_FIRST, BASE_DEC,
+			       &limit->rate, NFT_TYPE_U64) != 0)
 		goto err;
 
-	limit->depth = tmp;
 	e->flags |= (1 << NFT_EXPR_LIMIT_DEPTH);
 
 	return 0;
diff --git a/src/expr/log.c b/src/expr/log.c
index 1ffd1d9..9ff2d32 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -157,56 +157,36 @@ static int nft_rule_expr_log_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 #ifdef XML_PARSING
 	struct nft_expr_log *log = nft_expr_data(e);
 	mxml_node_t *node = NULL;
-	uint64_t tmp;
-	char *endptr;
 
 	node = mxmlFindElement(tree, tree, "prefix", NULL, NULL,
 			       MXML_DESCEND_FIRST);
-	if (node == NULL)
-		goto err;
+	if (node == NULL) {
+		errno = EINVAL;
+		return -1;
+	}
 
 	log->prefix = strdup(node->child->value.opaque);
 	e->flags |= (1 << NFT_EXPR_LOG_PREFIX);
 
-	node = mxmlFindElement(tree, tree, "group", NULL, NULL, MXML_DESCEND);
-	if (node == NULL)
-		goto err;
-
-	tmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (tmp > UINT32_MAX || tmp < 0 || *endptr)
-		goto err;
+	if (nft_mxml_num_parse(tree, "group", MXML_DESCEND_FIRST, BASE_DEC,
+			       &log->group, NFT_TYPE_U32) != 0)
+		return -1;
 
-	log->group = tmp;
 	e->flags |= (1 << NFT_EXPR_LOG_GROUP);
 
-	node = mxmlFindElement(tree, tree, "snaplen", NULL, NULL,
-			       MXML_DESCEND);
-	if (node == NULL)
-		goto err;
-
-	tmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (tmp > UINT32_MAX || tmp < 0 || *endptr)
-		goto err;
+	if (nft_mxml_num_parse(tree, "snaplen", MXML_DESCEND_FIRST, BASE_DEC,
+			       &log->snaplen, NFT_TYPE_U32) != 0)
+		return -1;
 
-	log->snaplen = tmp;
 	e->flags |= (1 << NFT_EXPR_LOG_SNAPLEN);
 
-	node = mxmlFindElement(tree, tree, "qthreshold", NULL, NULL,
-			       MXML_DESCEND);
-	if (node == NULL)
-		goto err;
-
-	tmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (tmp > UINT32_MAX || tmp < 0 || *endptr)
-		goto err;
+	if (nft_mxml_num_parse(tree, "qthreshold", MXML_DESCEND_FIRST,
+			       BASE_DEC, &log->qthreshold, NFT_TYPE_U32) != 0)
+		return -1;
 
-	log->qthreshold = tmp;
 	e->flags |= (1 << NFT_EXPR_LOG_QTHRESHOLD);
 
 	return 0;
-err:
-	errno = EINVAL;
-	return -1;
 #else
 	errno = EOPNOTSUPP;
 	return -1;
diff --git a/src/internal.h b/src/internal.h
index dc7d0c3..4b9e373 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -10,15 +10,32 @@
 #endif
 
 #include "linux_list.h"
-
 #include <stdint.h>
 
+#define BASE_DEC 10
+#define BASE_HEX 16
+
+enum nft_type {
+	NFT_TYPE_NONE = 0,
+	NFT_TYPE_U8,
+	NFT_TYPE_S8,
+	NFT_TYPE_U16,
+	NFT_TYPE_S16,
+	NFT_TYPE_U32,
+	NFT_TYPE_S32,
+	NFT_TYPE_U64,
+	NFT_TYPE_S64,
+	NFT_TYPE_INT,
+	NFT_TYPE_UINT,
+};
+
 #ifdef XML_PARSING
 #include <mxml.h>
 struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t *node);
 int nft_mxml_reg_parse(mxml_node_t *tree, const char *reg_name, uint32_t flags);
 union nft_data_reg;
 int nft_mxml_data_reg_parse(mxml_node_t *tree, const char *node_name, union nft_data_reg *data_reg);
+int nft_mxml_num_parse(mxml_node_t *tree, const char *node_name, uint32_t mxml_flags, int base, void *number, enum nft_type type);
 #endif
 
 #define NFT_TABLE_XML_VERSION 0
@@ -32,6 +49,7 @@ int nft_mxml_data_reg_parse(mxml_node_t *tree, const char *node_name, union nft_
 
 const char *nft_family2str(uint32_t family);
 int nft_str2family(const char *family);
+int nft_strtol(const char *string, int base, void *number, enum nft_type type);
 
 struct expr_ops;
 
diff --git a/src/mxml.c b/src/mxml.c
index 07f29ac..a60fce5 100644
--- a/src/mxml.c
+++ b/src/mxml.c
@@ -11,6 +11,8 @@
  */
 #include "internal.h"
 #include "expr_ops.h"
+#include <stdint.h>
+#include <limits.h>
 
 #include <linux/netfilter/nf_tables.h>
 #include <libnftables/rule.h>
@@ -58,7 +60,6 @@ err:
 int nft_mxml_reg_parse(mxml_node_t *tree, const char *reg_name, uint32_t flags)
 {
 	mxml_node_t *node;
-	char *endptr;
 	uint64_t val;
 
 	node = mxmlFindElement(tree, tree, reg_name, NULL, NULL, flags);
@@ -67,8 +68,10 @@ int nft_mxml_reg_parse(mxml_node_t *tree, const char *reg_name, uint32_t flags)
 		goto err;
 	}
 
-	val = strtoull(node->child->value.opaque, &endptr, 10);
-	if (val > NFT_REG_MAX || val < 0 || *endptr) {
+	if (nft_strtol(node->child->value.opaque, 10, &val, NFT_TYPE_U64) != 0)
+		goto err;
+
+	if (val > NFT_REG_MAX) {
 		errno = ERANGE;
 		goto err;
 	}
@@ -130,4 +133,20 @@ int nft_mxml_data_reg_parse(mxml_node_t *tree, const char *node_name,
 err:
 	return -1;
 }
+
+int
+nft_mxml_num_parse(mxml_node_t *tree, const char *node_name,
+		   uint32_t mxml_flags, int base, void *number,
+		   enum nft_type type)
+{
+	mxml_node_t *node = NULL;
+
+	node = mxmlFindElement(tree, tree, node_name, NULL, NULL, mxml_flags);
+	if (node == NULL || node->child == NULL) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	return nft_strtol(node->child->value.opaque, base, number, type);
+}
 #endif
diff --git a/src/rule.c b/src/rule.c
index b1bf64b..2e55a3a 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -552,19 +552,12 @@ static int nft_rule_xml_parse(struct nft_rule *r, char *xml)
 	r->flags |= (1 << NFT_RULE_ATTR_HANDLE);
 
 	/* get and set <rule_flags> */
-	node = mxmlFindElement(tree, tree, "rule_flags", NULL, NULL,
-			       MXML_DESCEND_FIRST);
-	if (node == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
-	tmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
+	if (nft_mxml_num_parse(tree, "rule_flags", MXML_DESCEND_FIRST,
+			       BASE_DEC, &r->rule_flags, NFT_TYPE_U32) != 0) {
 		mxmlDelete(tree);
 		return -1;
 	}
 
-	r->rule_flags = (uint32_t)tmp;
 	r->flags |= (1 << NFT_RULE_ATTR_FLAGS);
 
 	/* <compat_proto> is optional */
diff --git a/src/table.c b/src/table.c
index b2ebaa3..8e67355 100644
--- a/src/table.c
+++ b/src/table.c
@@ -225,7 +225,6 @@ static int nft_table_xml_parse(struct nft_table *t, char *xml)
 	mxml_node_t *tree = NULL;
 	mxml_node_t *node = NULL;
 	char *endptr = NULL;
-	uint64_t tmp;
 	int64_t stmp;
 	int family;
 
@@ -281,20 +280,12 @@ static int nft_table_xml_parse(struct nft_table *t, char *xml)
 	t->flags |= (1 << NFT_TABLE_ATTR_FAMILY);
 
 	/* Get and set <table_flags> */
-	node = mxmlFindElement(tree, tree, "table_flags", NULL, NULL,
-			       MXML_DESCEND);
-	if (node == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
-
-	tmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (tmp > UINT32_MAX || *endptr || tmp < 0) {
+	if (nft_mxml_num_parse(tree, "table_flags", MXML_DESCEND, BASE_DEC,
+			       &t->table_flags, NFT_TYPE_U32) != 0) {
 		mxmlDelete(tree);
 		return -1;
 	}
 
-	t->table_flags = (uint32_t)tmp;
 	t->flags |= (1 << NFT_TABLE_ATTR_FLAGS);
 
 	mxmlDelete(tree);
diff --git a/src/utils.c b/src/utils.c
index be1b5d8..0e17636 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -14,6 +14,7 @@
 #include <limits.h>
 #include <stdint.h>
 #include <arpa/inet.h>
+#include <errno.h>
 
 const char *nft_family2str(uint32_t family)
 {
@@ -44,3 +45,117 @@ int nft_str2family(const char *family)
 
 	return -1;
 }
+
+int nft_strtol(const char *string, int base, void *number, enum nft_type type)
+{
+	int64_t stmp = 0;
+	uint64_t utmp = -1;
+	char *endptr;
+	int is_signed;
+
+	switch (type) {
+	case NFT_TYPE_U8:
+	case NFT_TYPE_U16:
+	case NFT_TYPE_U32:
+	case NFT_TYPE_U64:
+	case NFT_TYPE_UINT:
+		is_signed = 0;
+		break;
+	case NFT_TYPE_S8:
+	case NFT_TYPE_S16:
+	case NFT_TYPE_S32:
+	case NFT_TYPE_S64:
+	case NFT_TYPE_INT:
+		is_signed = 1;
+		break;
+	default:
+		goto einval;
+	}
+
+	if (is_signed == 1) {
+		stmp = strtoll(string, &endptr, base);
+	} else {
+		utmp = strtoull(string, &endptr, base);
+		if (utmp < 0)
+			goto einval;
+	}
+
+	if (*endptr)
+		goto einval;
+
+	/* check for each dest type overflow and send back the number*/
+	switch (type) {
+	case NFT_TYPE_U8:
+		if (utmp > UINT8_MAX)
+			goto erange;
+		uint8_t *retv_u8 = (uint8_t *)number;
+		*retv_u8 = (uint8_t)utmp;
+		break;
+	case NFT_TYPE_S8:
+		if (stmp > INT8_MAX || stmp < INT8_MIN)
+			goto erange;
+		int8_t *retv_s8 = (int8_t *)number;
+		*retv_s8 = (int8_t)stmp;
+		break;
+	case NFT_TYPE_U16:
+		if (utmp > UINT16_MAX)
+			goto erange;
+		uint16_t *retv_u16 = (uint16_t *)number;
+		*retv_u16 = (uint16_t)utmp;
+		break;
+	case NFT_TYPE_S16:
+		if (stmp > INT16_MAX || stmp < INT16_MIN)
+			goto erange;
+		int16_t *retv_s16 = (int16_t *)number;
+		*retv_s16 = (int16_t)stmp;
+		break;
+	case NFT_TYPE_U32:
+		if (utmp > UINT32_MAX)
+			goto erange;
+		uint32_t *retv_u32 = (uint32_t *)number;
+		*retv_u32 = (uint32_t)utmp;
+		break;
+	case NFT_TYPE_S32:
+		if (stmp > INT32_MAX || stmp < INT32_MIN)
+			goto erange;
+		int32_t *retv_s32 = (int32_t *)number;
+		*retv_s32 = (int32_t)stmp;
+		break;
+	case NFT_TYPE_U64:
+		/* note: UINT64_MAX > ULLONG_MAX */
+		if (utmp == ULLONG_MAX)
+			goto erange;
+		uint64_t *retv_u64 = (uint64_t *)number;
+		*retv_u64 = (uint64_t)utmp;
+		break;
+	case NFT_TYPE_S64:
+		/* note: INT64_MAX > LLONG_MAX */
+		if (stmp == LLONG_MAX || stmp == LLONG_MIN)
+			goto erange;
+		int64_t *retv_s64 = (int64_t *)number;
+		*retv_s64 = (int64_t)stmp;
+		break;
+	case NFT_TYPE_UINT:
+		if (utmp > UINT_MAX)
+			goto erange;
+		unsigned int *retv_ui = (unsigned int *)number;
+		*retv_ui = (unsigned int)utmp;
+		break;
+	case NFT_TYPE_INT:
+		if (stmp > INT_MAX || stmp < INT_MIN)
+			goto erange;
+		int *retv_si = (int *)number;
+		*retv_si = (int)stmp;
+		break;
+	default:
+		goto einval;
+	}
+
+	return 0;
+einval:
+	errno = EINVAL;
+	return -1;
+erange:
+	errno = ERANGE;
+	return -1;
+}

