From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 1/2] src: utils: add verdict2str
Date: Thu, 25 Jul 2013 22:20:33 +0200
Message-ID: <20130725202033.21531.41100.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:47078 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756969Ab3GYUUp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jul 2013 16:20:45 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 8805151EE9B
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2013 20:20:41 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6ml0h3kS1gt4 for <netfilter-devel@vger.kernel.org>;
	Thu, 25 Jul 2013 22:20:36 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 02ACC51EDBE
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2013 22:20:35 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add verdict2str() and str2verdict() helper functions and use in XML.

I've followed nft_verdict_init() in net/netfilter/nf_tables_api.c

While at it, I've fixed a small style issue in the data_reg JSON output and a
bug in the data_reg XML parser:
The parser walked the top level tree, instead of single <data_reg> node.
This patch fixes it. Introduced at: 51370f0 src: add support for XML parsing.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/data_reg.c |   54 ++++++++++++++++++++++-----------------------------
 src/internal.h      |    2 ++
 src/utils.c         |   49 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 74 insertions(+), 31 deletions(-)

diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index b290b96..85c441e 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -31,8 +31,8 @@ static int nft_data_reg_verdict_xml_parse(union nft_data_reg *reg, char *xml)
 {
 	mxml_node_t *tree = NULL;
 	mxml_node_t *node = NULL;
-	char *endptr;
-	long int tmp;
+	int verdict;
+	const char *verdict_str;
 
 	tree = mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
 	if (tree == NULL)
@@ -47,33 +47,30 @@ static int nft_data_reg_verdict_xml_parse(union nft_data_reg *reg, char *xml)
 	}
 
 	/* Get and validate <data_reg type="verdict" >*/
-	if (mxmlElementGetAttr(tree, "type") == NULL) {
+	if (mxmlElementGetAttr(node, "type") == NULL) {
 		mxmlDelete(tree);
 		return -1;
 	}
 
-	if (strcmp(mxmlElementGetAttr(tree, "type"), "verdict") != 0) {
+	if (strcmp(mxmlElementGetAttr(node, "type"), "verdict") != 0) {
 		mxmlDelete(tree);
 		return -1;
 	}
 
 	/* Get and set <verdict> */
-	node = mxmlFindElement(tree, tree, "verdict", NULL, NULL,
-			       MXML_DESCEND_FIRST);
-	if (node == NULL) {
+	verdict_str = nft_mxml_str_parse(tree, "verdict", MXML_DESCEND);
+	if (verdict_str == NULL) {
 		mxmlDelete(tree);
 		return -1;
 	}
 
-	errno = 0;
-	tmp = strtoll(node->child->value.opaque, &endptr, 10);
-	if (tmp > INT_MAX || tmp < INT_MIN || errno != 0
-						|| strlen(endptr) > 0) {
+	verdict = nft_str2verdict(verdict_str);
+	if (verdict < 0) {
 		mxmlDelete(tree);
 		return -1;
 	}
 
-	reg->verdict = tmp;
+	reg->verdict = (uint32_t)verdict;
 
 	mxmlDelete(tree);
 	return 0;
@@ -97,34 +94,27 @@ static int nft_data_reg_chain_xml_parse(union nft_data_reg *reg, char *xml)
 	}
 
 	/* Get and validate <data_reg type="chain" >*/
-	if (mxmlElementGetAttr(tree, "type") == NULL) {
+	if (mxmlElementGetAttr(node, "type") == NULL) {
 		mxmlDelete(tree);
 		return -1;
 	}
 
-	if (strcmp(mxmlElementGetAttr(tree, "type"), "chain") != 0) {
+	if (strcmp(mxmlElementGetAttr(node, "type"), "chain") != 0) {
 		mxmlDelete(tree);
 		return -1;
 	}
 
 	/* Get and set <chain> */
-	node = mxmlFindElement(tree, tree, "chain", NULL, NULL, MXML_DESCEND);
-	if (node == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (reg->chain)
+		free(reg->chain);
 
-	/* no max len value to validate? */
-	if (strlen(node->child->value.opaque) < 1) {
+	reg->chain = (char *)nft_mxml_str_parse(tree, "chain",
+						MXML_DESCEND);
+	if (reg->chain == NULL) {
 		mxmlDelete(tree);
 		return -1;
 	}
 
-	if (reg->chain)
-		free(reg->chain);
-
-	reg->chain = strdup(node->child->value.opaque);
-
 	mxmlDelete(tree);
 	return 0;
 }
@@ -346,13 +336,15 @@ int nft_data_reg_snprintf(char *buf, size_t size, union nft_data_reg *reg,
 		case NFT_RULE_O_XML:
 			return snprintf(buf, size,
 					"<data_reg type=\"verdict\">"
-						"<verdict>%d</verdict>"
-					"</data_reg>", reg->verdict);
+						"<verdict>%s</verdict>"
+					"</data_reg>",
+					nft_verdict2str(reg->verdict));
 		case NFT_RULE_O_JSON:
 			return snprintf(buf, size,
-					"\"data_reg\": { \"type\" : \"verdict\", "
-						"\"verdict\" : %d"
-					"}", reg->verdict);
+					"\"data_reg\": {"
+						"\"type\" : \"verdict\", "
+						"\"verdict\" : \"%s\""
+					"}", nft_verdict2str(reg->verdict));
 		default:
 			break;
 		}
diff --git a/src/internal.h b/src/internal.h
index fc78233..b846814 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -49,6 +49,8 @@ const char *nft_mxml_str_parse(mxml_node_t *tree, const char *node_name, uint32_
 const char *nft_family2str(uint32_t family);
 int nft_str2family(const char *family);
 int nft_strtoi(const char *string, int base, void *number, enum nft_type type);
+const char *nft_verdict2str(uint32_t verdict);
+int nft_str2verdict(const char *verdict);
 
 struct expr_ops;
 
diff --git a/src/utils.c b/src/utils.c
index 4a0bb9c..2cdf4bf 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -17,6 +17,9 @@
 #include <errno.h>
 #include <inttypes.h>
 
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+
 const char *nft_family2str(uint32_t family)
 {
 	switch (family) {
@@ -117,3 +120,49 @@ int nft_strtoi(const char *string, int base, void *out, enum nft_type type)
 
 	return 0;
 }
+
+const char *nft_verdict2str(uint32_t verdict)
+{
+	switch (verdict) {
+	case NF_ACCEPT:
+		return "accept";
+	case NF_DROP:
+		return "drop";
+	case NF_QUEUE:
+		return "queue";
+	case NFT_CONTINUE:
+		return "continue";
+	case NFT_BREAK:
+		return "break";
+	case NFT_RETURN:
+		return "return";
+	case NFT_JUMP:
+		return "jump";
+	case NFT_GOTO:
+		return "goto";
+	default:
+		return "unknown";
+	}
+}
+
+int nft_str2verdict(const char *verdict)
+{
+	if (strcmp(verdict, "accept") == 0)
+		return NF_ACCEPT;
+	else if (strcmp(verdict, "drop") == 0)
+		return NF_DROP;
+	else if (strcmp(verdict, "queue") == 0)
+		return NF_QUEUE;
+	else if (strcmp(verdict, "continue") == 0)
+		return NFT_CONTINUE;
+	else if (strcmp(verdict, "break") == 0)
+		return NFT_BREAK;
+	else if (strcmp(verdict, "return") == 0)
+		return NFT_RETURN;
+	else if (strcmp(verdict, "jump") == 0)
+		return NFT_JUMP;
+	else if (strcmp(verdict, "goto") == 0)
+		return NFT_GOTO;
+
+	return -1;
+}

