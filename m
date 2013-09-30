From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 1/3] tests: fix error reporting
Date: Mon, 30 Sep 2013 17:05:52 +0200
Message-ID: <20130930150551.32124.23680.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:43571 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752788Ab3I3PF7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:05:59 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 6991251ED66
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2013 15:05:56 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0ipIL4f1mxdz for <netfilter-devel@vger.kernel.org>;
	Mon, 30 Sep 2013 17:05:56 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id F2D1251ED61
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2013 17:05:55 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The testbench was not reporting errors properly.

With this patch, "1" is returned to the shell if the test failed (instead of
returning "0" unconditionally). Textual reporting is also fixed.

In case of compilation without some parsing support, returning error (i.e 1)
is the expected behaviour.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 0 files changed

diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index ecde0e2..4e3b508 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -50,23 +50,23 @@ static void print_detail_error(char *a, char *b)
 		if (k < 0)
 			k = 0;
 
-		fprintf(stderr, "from file:     ");
+		printf("\nfrom file:     ");
 		for (i = k; i < from + 10; i++)
-			fprintf(stderr, "%c", a[i]);
+			printf("%c", a[i]);
 
-		fprintf(stderr, "\nfrom snprintf: ");
+		printf("\nfrom snprintf: ");
 		for (i = k; i < from + 10; i++)
-			fprintf(stderr, "%c", b[i]);
+			printf("%c", b[i]);
 
 		/* Don't look twice below this comment ;-) */
-		fprintf(stderr, "\n               ");
+		printf("\n               ");
 		for (i = k; i < from + 10; i++) {
 			if (i == from)
-				fprintf(stderr, "^");
+				printf("^");
 			else
-				fprintf(stderr, " ");
+				printf(" ");
 		}
-		fprintf(stderr, "\n");
+		printf("\n");
 	}
 }
 
@@ -144,8 +144,7 @@ static int compare_test(uint32_t type, void *input, const char *filename)
 	if (strncmp(orig, out, strlen(out)) == 0)
 		return 0;
 
-	printf("validating %s: ", filename);
-	printf("\033[31mFAILED\e[0m\n");
+	errno = EBADMSG;
 	print_detail_error(orig, out);
 	return -1;
 }
@@ -177,7 +176,7 @@ static int test_json(const char *filename)
 			if (nft_table_parse(t, NFT_TABLE_PARSE_JSON, json) == 0)
 				ret = compare_test(TEST_JSON_TABLE, t, filename);
 			else
-				goto failparsing;
+				ret = -1;
 
 			nft_table_free(t);
 		}
@@ -187,7 +186,7 @@ static int test_json(const char *filename)
 			if (nft_chain_parse(c, NFT_CHAIN_PARSE_JSON, json) == 0)
 				ret = compare_test(TEST_JSON_CHAIN, c, filename);
 			else
-				goto failparsing;
+				ret = -1;
 
 			nft_chain_free(c);
 		}
@@ -197,7 +196,7 @@ static int test_json(const char *filename)
 			if (nft_rule_parse(r, NFT_RULE_PARSE_JSON, json) == 0)
 				ret = compare_test(TEST_JSON_RULE, r, filename);
 			else
-				goto failparsing;
+				ret = -1;
 
 			nft_rule_free(r);
 		}
@@ -207,7 +206,7 @@ static int test_json(const char *filename)
 			if (nft_set_parse(s, NFT_SET_PARSE_JSON, json) == 0)
 				ret = compare_test(TEST_JSON_SET, s, filename);
 			else
-				goto failparsing;
+				ret = -1;
 
 			nft_set_free(s);
 			}
@@ -216,13 +215,6 @@ static int test_json(const char *filename)
 	free(json);
 	json_decref(root);
 	return ret;
-
-failparsing:
-	printf("parsing %s: ", filename);
-	printf("\033[31mFAILED\e[0m (%s)\n", strerror(errno));
-	free(json);
-	json_decref(root);
-	return -1;
 #else
 	errno = EOPNOTSUPP;
 	return -1;
@@ -245,12 +237,16 @@ static int test_xml(const char *filename)
 	tree = mxmlLoadFile(NULL, fp, MXML_NO_CALLBACK);
 	fclose(fp);
 
-	if (tree == NULL)
+	if (tree == NULL) {
+		printf("Unable to build XML tree.");
 		return -1;
+	}
 
 	xml = mxmlSaveAllocString(tree, MXML_NO_CALLBACK);
-	if (xml == NULL)
+	if (xml == NULL) {
+		printf("Unable to save alloc string from XML tree.");
 		return -1;
+	}
 
 	/* Check what parsing should be done */
 	if (strcmp(tree->value.opaque, "table") == 0) {
@@ -259,7 +255,7 @@ static int test_xml(const char *filename)
 			if (nft_table_parse(t, NFT_TABLE_PARSE_XML, xml) == 0)
 				ret = compare_test(TEST_XML_TABLE, t, filename);
 			else
-				goto failparsing;
+				ret = -1;
 
 			nft_table_free(t);
 		}
@@ -269,7 +265,7 @@ static int test_xml(const char *filename)
 			if (nft_chain_parse(c, NFT_CHAIN_PARSE_XML, xml) == 0)
 				ret = compare_test(TEST_XML_CHAIN, c, filename);
 			else
-				goto failparsing;
+				ret = -1;
 
 			nft_chain_free(c);
 		}
@@ -279,7 +275,7 @@ static int test_xml(const char *filename)
 			if (nft_rule_parse(r, NFT_RULE_PARSE_XML, xml) == 0)
 				ret = compare_test(TEST_XML_RULE, r, filename);
 			else
-				goto failparsing;
+				ret = -1;
 
 			nft_rule_free(r);
 		}
@@ -289,18 +285,14 @@ static int test_xml(const char *filename)
 			if (nft_set_parse(s, NFT_SET_PARSE_XML, xml) == 0)
 				ret = compare_test(TEST_XML_SET, s, filename);
 			else
-				goto failparsing;
+				ret = -1;
 
 			nft_set_free(s);
 		}
 	}
 
+	free(xml);
 	return ret;
-
-failparsing:
-	printf("parsing %s: ", filename);
-	printf("\033[31mFAILED\e[0m (%s)\n", strerror(errno));
-	return -1;
 #else
 	errno = EOPNOTSUPP;
 	return -1;
@@ -309,6 +301,7 @@ failparsing:
 
 int main(int argc, char *argv[])
 {
+	int exit_code = 0, ret;
 	DIR *d;
 	struct dirent *dent;
 	char path[PATH_MAX];
@@ -334,19 +327,35 @@ int main(int argc, char *argv[])
 		snprintf(path, sizeof(path), "%s/%s", argv[1], dent->d_name);
 
 		if (strcmp(&dent->d_name[len-4], ".xml") == 0) {
-			if (test_xml(path) == 0) {
-				printf("parsing and validating %s: ", path);
+
+			printf("parsing and validating %s: ", path);
+
+			if ((ret = test_xml(path)) == 0)
 				printf("\033[32mOK\e[0m\n");
-			}
+			else
+				printf("\033[31mFAILED\e[0m (%s)\n",
+				       strerror(errno));
+
+			exit_code += ret;
 		}
 		if (strcmp(&dent->d_name[len-5], ".json") == 0) {
-			if (test_json(path) == 0) {
-				printf("parsing and validating %s: ", path);
+
+			printf("parsing and validating %s: ", path);
+
+			if ((ret = test_json(path)) == 0)
 				printf("\033[32mOK\e[0m\n");
-			}
+			else
+				printf("\033[31mFAILED\e[0m (%s)\n",
+				       strerror(errno));
+
+			exit_code += ret;
 		}
 	}
 
 	closedir(d);
-	return 0;
+
+	if (exit_code == 0)
+		exit(EXIT_SUCCESS);
+	else
+		exit(EXIT_FAILURE);
 }

