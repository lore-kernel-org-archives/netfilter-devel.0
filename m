From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 6/6] tests: update tests with nft_*_parse_file()
Date: Tue, 07 Jan 2014 12:47:42 +0100
Message-ID: <20140107114742.12841.61774.stgit@nfdev.cica.es>
References: <20140107114518.12841.35778.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:46628 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750857AbaAGLrv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jan 2014 06:47:51 -0500
In-Reply-To: <20140107114518.12841.35778.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Lets do testing with nft_*_parse_file() functions.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/nft-parsing-test.c |  102 +++++++++++++++++++++++++++-------------------
 1 file changed, 59 insertions(+), 43 deletions(-)

diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index 558c849..4702fd3 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -73,7 +73,8 @@ static void print_detail_error(char *a, char *b)
 	}
 }
 
-static int compare_test(uint32_t type, void *input, const char *filename)
+static int compare_test(uint32_t type, void *input, const char *filename,
+			FILE *fp)
 {
 	struct nft_table *t = NULL;
 	struct nft_chain *c = NULL;
@@ -82,7 +83,6 @@ static int compare_test(uint32_t type, void *input, const char *filename)
 	struct nft_ruleset *rs = NULL;
 	char orig[4096];
 	char out[4096];
-	FILE *fp;
 
 	switch (type) {
 	case TEST_XML_TABLE:
@@ -148,14 +148,8 @@ static int compare_test(uint32_t type, void *input, const char *filename)
 		return -1;
 	}
 
-	fp = fopen(filename, "r");
-	if (fp == NULL) {
-		perror("open");
-		exit(EXIT_FAILURE);
-	}
-
+	rewind(fp);
 	fgets(orig, sizeof(orig), fp);
-	fclose(fp);
 
 	if (strncmp(orig, out, strlen(out)) == 0)
 		return 0;
@@ -178,19 +172,26 @@ static int test_json(const char *filename, struct nft_parse_err *err)
 	struct nft_ruleset *rs;
 	json_t *root;
 	json_error_t error;
-	char *json;
+	FILE *fp;
+
+	fp = fopen(filename, "r");
+	if (fp == NULL) {
+		printf("unable to open file %s: %s\n", filename,
+		       strerror(errno));
+		return -1;
+	}
 
 	root = json_load_file(filename, 0, &error);
 	if (!root)
 		return -1;
 
-	json = json_dumps(root, JSON_INDENT(0));
-
 	if (json_object_get(root, "table") != NULL) {
 		t = nft_table_alloc();
 		if (t != NULL) {
-			if (nft_table_parse(t, NFT_PARSE_JSON, json, err) == 0)
-				ret = compare_test(TEST_JSON_TABLE, t, filename);
+			if (nft_table_parse_file(t, NFT_PARSE_JSON,
+						 fp, err) == 0)
+				ret = compare_test(TEST_JSON_TABLE, t,
+						   filename, fp);
 			else
 				goto failparsing;
 
@@ -199,8 +200,10 @@ static int test_json(const char *filename, struct nft_parse_err *err)
 	} else if (json_object_get(root, "chain") != NULL) {
 		c = nft_chain_alloc();
 		if (c != NULL) {
-			if (nft_chain_parse(c, NFT_PARSE_JSON, json, err) == 0)
-				ret = compare_test(TEST_JSON_CHAIN, c, filename);
+			if (nft_chain_parse_file(c, NFT_PARSE_JSON,
+						 fp, err) == 0)
+				ret = compare_test(TEST_JSON_CHAIN, c,
+						   filename, fp);
 			else
 				goto failparsing;
 
@@ -209,8 +212,10 @@ static int test_json(const char *filename, struct nft_parse_err *err)
 	} else if (json_object_get(root, "rule") != NULL) {
 		r = nft_rule_alloc();
 		if (r != NULL) {
-			if (nft_rule_parse(r, NFT_PARSE_JSON, json, err) == 0)
-				ret = compare_test(TEST_JSON_RULE, r, filename);
+			if (nft_rule_parse_file(r, NFT_PARSE_JSON,
+						fp, err) == 0)
+				ret = compare_test(TEST_JSON_RULE, r,
+						   filename, fp);
 			else
 				goto failparsing;
 
@@ -219,8 +224,10 @@ static int test_json(const char *filename, struct nft_parse_err *err)
 	} else if (json_object_get(root, "set") != NULL) {
 		s = nft_set_alloc();
 		if (s != NULL) {
-			if (nft_set_parse(s, NFT_PARSE_JSON, json, err) == 0)
-				ret = compare_test(TEST_JSON_SET, s, filename);
+			if (nft_set_parse_file(s, NFT_PARSE_JSON,
+					       fp, err) == 0)
+				ret = compare_test(TEST_JSON_SET, s,
+						   filename, fp);
 			else
 				goto failparsing;
 
@@ -229,8 +236,10 @@ static int test_json(const char *filename, struct nft_parse_err *err)
 	} else if (json_object_get(root, "nftables") != NULL) {
 		rs = nft_ruleset_alloc();
 		if (rs != NULL) {
-			if (nft_ruleset_parse(rs, NFT_PARSE_JSON, json, err) == 0)
-				ret = compare_test(TEST_JSON_RULESET, rs, filename);
+			if (nft_ruleset_parse_file(rs, NFT_PARSE_JSON,
+						   fp, err) == 0)
+				ret = compare_test(TEST_JSON_RULESET, rs,
+						   filename, fp);
 			else
 				goto failparsing;
 
@@ -238,14 +247,14 @@ static int test_json(const char *filename, struct nft_parse_err *err)
 			}
 	}
 
-	free(json);
+	fclose(fp);
 	json_decref(root);
 	return ret;
 
 failparsing:
+	fclose(fp);
 	printf("parsing %s: ", filename);
 	printf("\033[31mFAILED\e[0m (%s)\n", strerror(errno));
-	free(json);
 	json_decref(root);
 	return -1;
 #else
@@ -265,11 +274,15 @@ static int test_xml(const char *filename, struct nft_parse_err *err)
 	struct nft_ruleset *rs;
 	FILE *fp;
 	mxml_node_t *tree;
-	char *xml;
 
 	fp = fopen(filename, "r");
+	if (fp == NULL) {
+		printf("unable to open file %s: %s\n", filename,
+		       strerror(errno));
+		return -1;
+	}
+
 	tree = mxmlLoadFile(NULL, fp, MXML_NO_CALLBACK);
-	fclose(fp);
 
 	if (tree == NULL) {
 		printf("unable to build XML tree from file "
@@ -277,19 +290,16 @@ static int test_xml(const char *filename, struct nft_parse_err *err)
 		return -1;
 	}
 
-	xml = mxmlSaveAllocString(tree, MXML_NO_CALLBACK);
-	if (xml == NULL) {
-		printf("unable to alloc string from XML tree from %s "
-		       "\033[31mFAILED\e[0m\n", filename);
-		return -1;
-	}
+	rewind(fp);
 
 	/* Check what parsing should be done */
 	if (strcmp(tree->value.opaque, "table") == 0) {
 		t = nft_table_alloc();
 		if (t != NULL) {
-			if (nft_table_parse(t, NFT_PARSE_XML, xml, err) == 0)
-				ret = compare_test(TEST_XML_TABLE, t, filename);
+			if (nft_table_parse_file(t, NFT_PARSE_XML,
+						 fp, err) == 0)
+				ret = compare_test(TEST_XML_TABLE, t,
+						   filename, fp);
 			else
 				goto failparsing;
 
@@ -298,8 +308,10 @@ static int test_xml(const char *filename, struct nft_parse_err *err)
 	} else if (strcmp(tree->value.opaque, "chain") == 0) {
 		c = nft_chain_alloc();
 		if (c != NULL) {
-			if (nft_chain_parse(c, NFT_PARSE_XML, xml, err) == 0)
-				ret = compare_test(TEST_XML_CHAIN, c, filename);
+			if (nft_chain_parse_file(c, NFT_PARSE_XML,
+						 fp, err) == 0)
+				ret = compare_test(TEST_XML_CHAIN, c,
+						   filename, fp);
 			else
 				goto failparsing;
 
@@ -308,8 +320,10 @@ static int test_xml(const char *filename, struct nft_parse_err *err)
 	} else if (strcmp(tree->value.opaque, "rule") == 0) {
 		r = nft_rule_alloc();
 		if (r != NULL) {
-			if (nft_rule_parse(r, NFT_PARSE_XML, xml, err) == 0)
-				ret = compare_test(TEST_XML_RULE, r, filename);
+			if (nft_rule_parse_file(r, NFT_PARSE_XML,
+						fp, err) == 0)
+				ret = compare_test(TEST_XML_RULE, r,
+						   filename, fp);
 			else
 				goto failparsing;
 
@@ -318,8 +332,10 @@ static int test_xml(const char *filename, struct nft_parse_err *err)
 	} else if (strcmp(tree->value.opaque, "set") == 0) {
 		s = nft_set_alloc();
 		if (s != NULL) {
-			if (nft_set_parse(s, NFT_PARSE_XML, xml, err) == 0)
-				ret = compare_test(TEST_XML_SET, s, filename);
+			if (nft_set_parse_file(s, NFT_PARSE_XML,
+					       fp, err) == 0)
+				ret = compare_test(TEST_XML_SET, s,
+						   filename, fp);
 			else
 				goto failparsing;
 
@@ -328,10 +344,10 @@ static int test_xml(const char *filename, struct nft_parse_err *err)
 	} else if (strcmp(tree->value.opaque, "nftables") == 0) {
 		rs = nft_ruleset_alloc();
 		if (rs != NULL) {
-			if (nft_ruleset_parse(rs, NFT_PARSE_XML,
-					      xml, err) == 0)
+			if (nft_ruleset_parse_file(rs, NFT_PARSE_XML,
+						   fp, err) == 0)
 				ret = compare_test(TEST_XML_RULESET, rs,
-						   filename);
+						   filename, fp);
 			else
 				goto failparsing;
 

