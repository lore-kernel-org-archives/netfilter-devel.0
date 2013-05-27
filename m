From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] data_reg: fix XML operations
Date: Mon, 27 May 2013 19:16:54 +0200
Message-ID: <20130527171654.4585.61260.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:38957 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754379Ab3E0RQ6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 May 2013 13:16:58 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id EA91251ECAB
	for <netfilter-devel@vger.kernel.org>; Mon, 27 May 2013 17:16:56 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n6BhpSyGthD6 for <netfilter-devel@vger.kernel.org>;
	Mon, 27 May 2013 19:16:56 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id BEFE251EC06
	for <netfilter-devel@vger.kernel.org>; Mon, 27 May 2013 19:16:56 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Several fixes:

 * Conditional XML code for snprintf_xml.
 I don't think that not having XML support breaks XML printing.

 * Add generic interface for parsing: nft_data_reg_parse().
 Simply missing in previous patches.

 * Fix conditional code in XML parsing functions.
 All the XML parsing chunk was conditional but the main function. I think is better to
 do the conditional compilation by function, returning -1 and setting errno = EOPNOTSUPP.

 * Delete trailing space in snprintf_xml " >"

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/bitwise.c   |    4 ++--
 src/expr/cmp.c       |    2 +-
 src/expr/data_reg.c  |   42 +++++++++++++++++++++++++++++++-----------
 src/expr/data_reg.h  |    8 +++++++-
 src/expr/immediate.c |    2 +-
 5 files changed, 42 insertions(+), 16 deletions(-)

diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 9ebe3dc..1c7198b 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -265,7 +265,7 @@ nft_rule_expr_bitwise_xml_parse(struct nft_rule_expr *e, char *xml)
 	/* hack for mxmSaveAllocString to print just the current node */
 	save = node->next;
 	node->next = NULL;
-	if (nft_data_reg_xml_parse(&data_regtmp,
+	if (nft_data_reg_parse(&data_regtmp, NFT_DATA_REG_PARSE_XML,
 			mxmlSaveAllocString(node, MXML_NO_CALLBACK)) < 0) {
 		mxmlDelete(tree);
 		return -1;
@@ -287,7 +287,7 @@ nft_rule_expr_bitwise_xml_parse(struct nft_rule_expr *e, char *xml)
 	/* hack for mxmSaveAllocString to print just the current node */
 	save = node->next;
 	node->next = NULL;
-	if (nft_data_reg_xml_parse(&data_regtmp,
+	if (nft_data_reg_parse(&data_regtmp, NFT_DATA_REG_PARSE_XML,
 			mxmlSaveAllocString(node, MXML_NO_CALLBACK)) < 0) {
 		mxmlDelete(tree);
 		return -1;
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 673f3e0..bf285d5 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -237,7 +237,7 @@ static int nft_rule_expr_cmp_xml_parse(struct nft_rule_expr *e, char *xml)
 		save = node->next;
 		node->next = NULL;
 
-		if (nft_data_reg_xml_parse(&data_regtmp,
+		if (nft_data_reg_parse(&data_regtmp, NFT_DATA_REG_PARSE_XML,
 			mxmlSaveAllocString(node, MXML_NO_CALLBACK)) < 0) {
 			mxmlDelete(tree);
 			return -1;
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index c0a048c..11e4de8 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -25,9 +25,9 @@
 #include "data_reg.h"
 #include "internal.h"
 
-#ifdef XML_PARSING
 static int nft_data_reg_verdict_xml_parse(union nft_data_reg *reg, char *xml)
 {
+#ifdef XML_PARSING
 	mxml_node_t *tree = NULL;
 	mxml_node_t *node = NULL;
 	char *endptr;
@@ -76,12 +76,15 @@ static int nft_data_reg_verdict_xml_parse(union nft_data_reg *reg, char *xml)
 
 	mxmlDelete(tree);
 	return 0;
+#else
 	errno = EOPNOTSUPP;
 	return -1;
+#endif
 }
 
 static int nft_data_reg_chain_xml_parse(union nft_data_reg *reg, char *xml)
 {
+#ifdef XML_PARSING
 	mxml_node_t *tree = NULL;
 	mxml_node_t *node = NULL;
 
@@ -128,10 +131,15 @@ static int nft_data_reg_chain_xml_parse(union nft_data_reg *reg, char *xml)
 
 	mxmlDelete(tree);
 	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
 }
 
 static int nft_data_reg_value_xml_parse(union nft_data_reg *reg, char *xml)
 {
+#ifdef XML_PARSING
 	mxml_node_t *tree = NULL;
 	mxml_node_t *node = NULL;
 	int i, len;
@@ -211,12 +219,13 @@ static int nft_data_reg_value_xml_parse(union nft_data_reg *reg, char *xml)
 
 	mxmlDelete(tree);
 	return 0;
+#else
 	errno = EOPNOTSUPP;
 	return -1;
-}
 #endif
+}
 
-int nft_data_reg_xml_parse(union nft_data_reg *reg, char *xml)
+static int nft_data_reg_xml_parse(union nft_data_reg *reg, char *xml)
 {
 #ifdef XML_PARSING
 	mxml_node_t *node = NULL;
@@ -258,16 +267,31 @@ int nft_data_reg_xml_parse(union nft_data_reg *reg, char *xml)
 #endif
 }
 
+int nft_data_reg_parse(union nft_data_reg *reg,
+		       enum nft_data_reg_parse_type type, char *data) {
+	int ret;
+
+	switch (type) {
+	case NFT_DATA_REG_PARSE_XML:
+		ret = nft_data_reg_xml_parse(reg, data);
+		break;
+	default:
+		errno = EOPNOTSUPP;
+		ret = -1;
+	}
+
+	return ret;
+}
+
 static
 int nft_data_reg_value_snprintf_xml(char *buf, size_t size,
 				    union nft_data_reg *reg, uint32_t flags)
 {
-#ifdef XML_PARSING
 	int len = size, offset = 0, ret, i, j;
 	uint8_t *tmp;
 	int data_len = reg->len/sizeof(uint32_t);
 
-	ret = snprintf(buf, len, "<data_reg type=\"value\" >");
+	ret = snprintf(buf, len, "<data_reg type=\"value\">");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	ret = snprintf(buf+offset, len, "<len>%d</len>", data_len);
@@ -292,10 +316,6 @@ int nft_data_reg_value_snprintf_xml(char *buf, size_t size,
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
 }
 
 static int
@@ -331,7 +351,7 @@ int nft_data_reg_snprintf(char *buf, size_t size, union nft_data_reg *reg,
 		switch(output_format) {
 		case NFT_RULE_O_XML:
 			return snprintf(buf, size,
-					"<data_reg type=\"verdict\" >"
+					"<data_reg type=\"verdict\">"
 						"<verdict>%d</verdict>"
 					"</data_reg>", reg->verdict);
 		case NFT_RULE_O_DEFAULT:
@@ -343,7 +363,7 @@ int nft_data_reg_snprintf(char *buf, size_t size, union nft_data_reg *reg,
 		switch(output_format) {
 		case NFT_RULE_O_XML:
 			return snprintf(buf, size,
-					"<data_reg type=\"chain\" >"
+					"<data_reg type=\"chain\">"
 						"<chain>%s</chain>"
 					"</data_reg>", reg->chain);
 		case NFT_RULE_O_DEFAULT:
diff --git a/src/expr/data_reg.h b/src/expr/data_reg.h
index 1552c1e..dcb3d9f 100644
--- a/src/expr/data_reg.h
+++ b/src/expr/data_reg.h
@@ -18,9 +18,15 @@ union nft_data_reg {
 	};
 };
 
+enum nft_data_reg_parse_type {
+	NFT_DATA_REG_PARSE_NONE		= 0,
+	NFT_DATA_REG_PARSE_XML,
+	NFT_DATA_REG_PARSE_MAX,
+};
+
 int nft_data_reg_snprintf(char *buf, size_t size, union nft_data_reg *reg,
                         uint32_t output_format, uint32_t flags, int reg_type);
-int nft_data_reg_xml_parse(union nft_data_reg *reg, char *xml);
+int nft_data_reg_parse(union nft_data_reg *reg, enum nft_data_reg_parse_type type, char *data);
 int nft_parse_data(union nft_data_reg *data, struct nlattr *attr, int *type);
 
 #endif
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 7cfb4bf..f10a785 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -251,7 +251,7 @@ nft_rule_expr_immediate_xml_parse(struct nft_rule_expr *e, char *xml)
 	save = node->next;
 	node->next = NULL;
 
-	if (nft_data_reg_xml_parse(&data_regtmp,
+	if (nft_data_reg_parse(&data_regtmp, NFT_DATA_REG_PARSE_XML,
 			mxmlSaveAllocString(node, MXML_NO_CALLBACK)) < 0) {
 		mxmlDelete(tree);
 		return -1;

