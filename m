From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 1/6] test: return EXIT_FAILURE if some error was
	found
Date: Thu, 31 Oct 2013 13:36:18 +0100
Message-ID: <20131031123618.32572.24929.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:57587 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752435Ab3JaMg2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Oct 2013 08:36:28 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id F27DA51EDC3
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2013 12:36:25 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2pqYBQPX7xU7 for <netfilter-devel@vger.kernel.org>;
	Thu, 31 Oct 2013 13:36:21 +0100 (CET)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id EB5A751EDBA
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2013 13:36:20 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Before this patch, 0 was returned unconditionally.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/nft-parsing-test.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index 866c985..70028a0 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -234,7 +234,7 @@ static int test_json(const char *filename)
 			if (nft_ruleset_parse(rs, NFT_RULESET_PARSE_JSON, json) == 0)
 				ret = compare_test(TEST_JSON_RULESET, rs, filename);
 			else
-				ret = -1;
+				goto failparsing;
 
 			nft_ruleset_free(rs);
 			}
@@ -329,7 +329,7 @@ static int test_xml(const char *filename)
 				ret = compare_test(TEST_XML_RULESET, rs,
 						   filename);
 			else
-				ret = -1;
+				goto failparsing;
 
 			nft_ruleset_free(rs);
 		}
@@ -352,6 +352,7 @@ int main(int argc, char *argv[])
 	DIR *d;
 	struct dirent *dent;
 	char path[PATH_MAX];
+	int ret = 0, exit_code = 0;
 
 	if (argc != 2) {
 		fprintf(stderr, "Usage: %s <directory>\n", argv[0]);
@@ -374,19 +375,25 @@ int main(int argc, char *argv[])
 		snprintf(path, sizeof(path), "%s/%s", argv[1], dent->d_name);
 
 		if (strcmp(&dent->d_name[len-4], ".xml") == 0) {
-			if (test_xml(path) == 0) {
+			if ((ret = test_xml(path)) == 0) {
 				printf("parsing and validating %s: ", path);
 				printf("\033[32mOK\e[0m\n");
 			}
+			exit_code += ret;
 		}
 		if (strcmp(&dent->d_name[len-5], ".json") == 0) {
-			if (test_json(path) == 0) {
+			if ((ret = test_json(path)) == 0) {
 				printf("parsing and validating %s: ", path);
 				printf("\033[32mOK\e[0m\n");
 			}
+			exit_code += ret;
 		}
 	}
 
 	closedir(d);
+
+	if (exit_code != 0)
+		exit(EXIT_FAILURE);
+
 	return 0;
 }

