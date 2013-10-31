From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 3/6] test: use constants for coloured strings
Date: Thu, 31 Oct 2013 13:36:29 +0100
Message-ID: <20131031123628.32572.32677.stgit@nfdev.cica.es>
References: <20131031123618.32572.24929.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:57598 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753445Ab3JaMgh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Oct 2013 08:36:37 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 4CDF151EDC3
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2013 12:36:36 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J7cxCFG+PIPW for <netfilter-devel@vger.kernel.org>;
	Thu, 31 Oct 2013 13:36:31 +0100 (CET)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 58ED151EDBA
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2013 13:36:31 +0100 (CET)
In-Reply-To: <20131031123618.32572.24929.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use constants for coloured strings, which have a ugly format.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/nft-parsing-test.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index 5eaaa1e..5333dbd 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -33,6 +33,9 @@ enum {
 	TEST_JSON_RULESET,
 };
 
+#define FAILED_STR "\033[31mFAILED\e[0m"
+#define OK_STR "\033[32mOK\e[0m"
+
 #if defined(XML_PARSING) || defined(JSON_PARSING)
 static void print_detail_error(char *a, char *b)
 {
@@ -160,8 +163,7 @@ static int compare_test(uint32_t type, void *input, const char *filename)
 	if (strncmp(orig, out, strlen(out)) == 0)
 		return 0;
 
-	printf("validating %s: ", filename);
-	printf("\033[31mFAILED\e[0m\n");
+	printf("parsing and validating %s: %s\n", filename, FAILED_STR);
 	print_detail_error(orig, out);
 	return -1;
 }
@@ -245,8 +247,7 @@ static int test_json(const char *filename)
 	return ret;
 
 failparsing:
-	printf("parsing %s: ", filename);
-	printf("\033[31mFAILED\e[0m (%s)\n", strerror(errno));
+	printf("parsing %s: %s (%s)\n", filename, FAILED_STR, strerror(errno));
 	free(json);
 	json_decref(root);
 	return -1;
@@ -340,8 +341,8 @@ static int test_xml(const char *filename)
 
 failparsing:
 	mxmlDelete(tree);
-	printf("parsing %s: ", filename);
-	printf("\033[31mFAILED\e[0m (%s)\n", strerror(errno));
+	printf("parsing and validating %s: %s (%s)\n", filename, FAILED_STR,
+	       strerror(errno));
 	return -1;
 #else
 	errno = EOPNOTSUPP;
@@ -379,14 +380,14 @@ int main(int argc, char *argv[])
 		if (strcmp(&dent->d_name[len-4], ".xml") == 0) {
 			if ((ret = test_xml(path)) == 0) {
 				printf("parsing and validating %s: ", path);
-				printf("\033[32mOK\e[0m\n");
+				printf("%s\n", OK_STR);
 			}
 			exit_code += ret;
 		}
 		if (strcmp(&dent->d_name[len-5], ".json") == 0) {
 			if ((ret = test_json(path)) == 0) {
 				printf("parsing and validating %s: ", path);
-				printf("\033[32mOK\e[0m\n");
+				printf("%s\n", OK_STR);
 			}
 			exit_code += ret;
 		}

