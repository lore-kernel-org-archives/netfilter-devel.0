From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] src: consolidate XMl parsing of data_reg via
	nft_mxml_data_reg_parse
Date: Fri, 05 Jul 2013 16:28:06 +0200
Message-ID: <20130705142805.8352.24639.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:52132 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752356Ab3GEO2Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jul 2013 10:28:16 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 8AF7251ECE9
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Jul 2013 14:28:13 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HOyEjZKqVWQP for <netfilter-devel@vger.kernel.org>;
	Fri,  5 Jul 2013 16:28:07 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id E8A4B51ED32
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Jul 2013 16:28:07 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Move common code for XML parsing of data_reg to the new nft_mxml_data_reg_parse function.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/bitwise.c   |   36 ++++++-----------------------------
 src/expr/cmp.c       |   17 +++-------------
 src/expr/immediate.c |   45 ++++++++++++-------------------------------
 src/internal.h       |    2 ++
 src/mxml.c           |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 75 insertions(+), 77 deletions(-)

diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 6b534b4..3836ab4 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -202,10 +202,7 @@ nft_rule_expr_bitwise_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 {
 #ifdef XML_PARSING
 	struct nft_expr_bitwise *bitwise = (struct nft_expr_bitwise *)e->data;
-	mxml_node_t *node = NULL;
-	mxml_node_t *save = NULL;
 	int32_t reg;
-	union nft_data_reg data_regtmp;
 
 	reg = nft_mxml_reg_parse(tree, "sreg", MXML_DESCEND_FIRST);
 	if (reg < 0)
@@ -221,39 +218,18 @@ nft_rule_expr_bitwise_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 	bitwise->dreg = reg;
 	e->flags |= (1 << NFT_EXPR_BITWISE_DREG);
 
-	/* Get and set <mask> */
-	node = mxmlFindElement(tree, tree, "mask", NULL, NULL,
-			       MXML_DESCEND);
-	if (node == NULL)
+	if (nft_mxml_data_reg_parse(tree, "mask",
+				    &bitwise->mask) != DATA_VALUE) {
 		return -1;
+	}
 
-	/* hack for mxmSaveAllocString to print just the current node */
-	save = node->next;
-	node->next = NULL;
-	if (nft_data_reg_xml_parse(&data_regtmp,
-			mxmlSaveAllocString(node, MXML_NO_CALLBACK)) < 0)
-		return -1;
-	node->next = save;
-
-	memcpy(&bitwise->mask.val, data_regtmp.val, data_regtmp.len);
-	bitwise->mask.len = data_regtmp.len;
 	e->flags |= (1 << NFT_EXPR_BITWISE_MASK);
 
-	/* Get and set <xor> */
-	node = mxmlFindElement(tree, tree, "xor", NULL, NULL,
-			       MXML_DESCEND);
-	if (node == NULL)
-		return -1;
-
-	/* hack for mxmSaveAllocString to print just the current node */
-	save = node->next;
-	node->next = NULL;
-	if (nft_data_reg_xml_parse(&data_regtmp,
-			mxmlSaveAllocString(node, MXML_NO_CALLBACK)) < 0)
+	if (nft_mxml_data_reg_parse(tree, "xor",
+				    &bitwise->xor) != DATA_VALUE) {
 		return -1;
+	}
 
-	memcpy(&bitwise->xor.val, data_regtmp.val, data_regtmp.len);
-	bitwise->xor.len = data_regtmp.len;
 	e->flags |= (1 << NFT_EXPR_BITWISE_XOR);
 
 	/* Additional validation: mask and xor must use the same number of
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index f3a363a..2e284fe 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -173,8 +173,6 @@ static int nft_rule_expr_cmp_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 #ifdef XML_PARSING
 	struct nft_expr_cmp *cmp = (struct nft_expr_cmp *)e->data;
 	mxml_node_t *node = NULL;
-	mxml_node_t *save = NULL;
-	union nft_data_reg data_regtmp;
 	int32_t reg;
 
 	reg = nft_mxml_reg_parse(tree, "sreg", MXML_DESCEND_FIRST);
@@ -207,22 +205,13 @@ static int nft_rule_expr_cmp_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 	}
 
 	/* Get and set <cmpdata>. Is not mandatory */
-	node = mxmlFindElement(tree, tree, "cmpdata", NULL, NULL,
-			       MXML_DESCEND);
+	node = mxmlFindElement(tree, tree, "cmpdata", NULL, NULL, MXML_DESCEND);
 	if (node != NULL) {
-		/* hack for mxmSaveAllocString to print just the current node */
-		save = node->next;
-		node->next = NULL;
-
-		if (nft_data_reg_xml_parse(&data_regtmp,
-			mxmlSaveAllocString(node, MXML_NO_CALLBACK)) < 0) {
+		if (nft_mxml_data_reg_parse(tree, "cmpdata",
+					    &cmp->data) != DATA_VALUE) {
 			return -1;
 		}
 
-		node->next = save;
-
-		memcpy(&cmp->data.val, data_regtmp.val, data_regtmp.len);
-		cmp->data.len = data_regtmp.len;
 		e->flags |= (1 << NFT_EXPR_CMP_DATA);
 	}
 
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 8f57649..36fffce 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -200,9 +200,7 @@ nft_rule_expr_immediate_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 {
 #ifdef XML_PARSING
 	struct nft_expr_immediate *imm = (struct nft_expr_immediate *)e->data;
-	mxml_node_t *node = NULL;
-	mxml_node_t *save = NULL;
-	union nft_data_reg data_regtmp;
+	int data_reg_type;
 	int32_t reg;
 
 	reg = nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST);
@@ -213,42 +211,23 @@ nft_rule_expr_immediate_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 	e->flags |= (1 << NFT_EXPR_IMM_DREG);
 
 	/* Get and set <immdata>. Is mandatory */
-	node = mxmlFindElement(tree, tree, "immdata", NULL, NULL,
-			       MXML_DESCEND);
-	if (node == NULL)
-		return -1;
-
-	/* hack for mxmSaveAllocString to print just the current node */
-	save = node->next;
-	node->next = NULL;
-
-	if (nft_data_reg_xml_parse(&data_regtmp,
-			mxmlSaveAllocString(node, MXML_NO_CALLBACK)) < 0)
-		return -1;
-	node->next = save;
+	data_reg_type = nft_mxml_data_reg_parse(tree, "immdata", &imm->data);
 
-	/* data_reg type switch */
-	node = mxmlFindElement(tree, tree, "data_reg", NULL, NULL,
-			       MXML_DESCEND);
-	if (node == NULL)
+	if (data_reg_type < 0)
 		return -1;
 
-	if (mxmlElementGetAttr(node, "type") == NULL)
-		return -1;
-
-	if (strcmp(mxmlElementGetAttr(node, "type"), "value") == 0) {
-		memcpy(&imm->data.val, data_regtmp.val, data_regtmp.len);
-		imm->data.len = data_regtmp.len;
+	switch (data_reg_type) {
+	case DATA_VALUE:
 		e->flags |= (1 << NFT_EXPR_IMM_DATA);
-	} else if (strcmp(mxmlElementGetAttr(node, "type"), "verdict") == 0) {
-		imm->data.verdict = data_regtmp.verdict;
+		break;
+	case DATA_VERDICT:
 		e->flags |= (1 << NFT_EXPR_IMM_VERDICT);
-	} else if (strcmp(mxmlElementGetAttr(node, "type"), "chain") == 0) {
-		if (imm->data.chain)
-			free(imm->data.chain);
-
-		imm->data.chain = strdup(data_regtmp.chain);
+		break;
+	case DATA_CHAIN:
 		e->flags |= (1 << NFT_EXPR_IMM_CHAIN);
+		break;
+	default:
+		return -1;
 	}
 
 	return 0;
diff --git a/src/internal.h b/src/internal.h
index ee09661..e2c2882 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -17,6 +17,8 @@
 #include <mxml.h>
 struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t *node);
 int nft_mxml_reg_parse(mxml_node_t *tree, const char *reg_name, uint32_t flags);
+union nft_data_reg;
+int nft_mxml_data_reg_parse(mxml_node_t *tree, const char *node_name, union nft_data_reg *data_reg);
 #endif
 
 #define NFT_TABLE_XML_VERSION 0
diff --git a/src/mxml.c b/src/mxml.c
index 9aef645..b694ad0 100644
--- a/src/mxml.c
+++ b/src/mxml.c
@@ -76,4 +76,56 @@ int nft_mxml_reg_parse(mxml_node_t *tree, const char *reg_name, uint32_t flags)
 err:
 	return -1;
 }
+
+int nft_mxml_data_reg_parse(mxml_node_t *tree, const char *node_name,
+			    union nft_data_reg *data_reg)
+{
+	mxml_node_t *node;
+	const char *type;
+	char *tmpstr = NULL;
+	int ret;
+
+	node = mxmlFindElement(tree, tree, node_name, NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node == NULL || node->child == NULL) {
+		errno = EINVAL;
+		goto err;
+	}
+
+	tmpstr = mxmlSaveAllocString(node, MXML_NO_CALLBACK);
+	if (tmpstr == NULL) {
+		errno = ENOMEM;
+		goto err;
+	}
+
+	ret = nft_data_reg_xml_parse(data_reg, tmpstr);
+	free(tmpstr);
+
+	if (ret < 0) {
+		errno = EINVAL;
+		goto err;
+	}
+
+	node = mxmlFindElement(node, node, "data_reg", NULL, NULL,
+			       MXML_DESCEND);
+	if (node == NULL || node->child == NULL) {
+		errno = EINVAL;
+		goto err;
+	}
+
+	if (mxmlElementGetAttr(node, "type") == NULL) {
+		errno = EINVAL;
+		goto err;
+	}
+
+	type = mxmlElementGetAttr(node, "type");
+	if (strcmp(type, "value") == 0)
+		return DATA_VALUE;
+	if (strcmp(type, "verdict") == 0)
+		return DATA_VERDICT;
+	if (strcmp(type, "chain") == 0)
+		return DATA_CHAIN;
+err:
+	return -1;
+}
 #endif

