From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH v2 1/2] tests: New tools to uptade xml and json testfiles.
Date: Wed,  9 Apr 2014 17:03:44 +0200
Message-ID: <b6b20bce9ecf384db04e8d9582a49905bf0fa72c.1397048551.git.anarey@gmail.com>
References: <cover.1397048551.git.anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:60638 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933204AbaDIPEB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:04:01 -0400
Received: by mail-we0-f181.google.com with SMTP id q58so2614331wes.12
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Apr 2014 08:03:59 -0700 (PDT)
In-Reply-To: <cover.1397048551.git.anarey@gmail.com>
In-Reply-To: <cover.1397048551.git.anarey@gmail.com>
References: <cover.1397048551.git.anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

New tools to updata testfiles when the structure of xml or json files
are changed.

It adds a new command-line argument in nft-parsing-test.

With nft-parsing-test -u <directory>, you can update test files in
<directory> with a new structure of xml or json file.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
[Changes in v2:]
* Change from fwrite to fprintf functions to add the end of line in the
new files.


 tests/nft-parsing-test.c | 42 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 6 deletions(-)

diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index a35c064..59c75a6 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -18,6 +18,8 @@ enum {
 	TEST_JSON_RULESET,
 };
 
+static bool update = false;
+
 static void print_detail_error(char *a, char *b)
 {
 	int i;
@@ -80,8 +82,24 @@ static int compare_test(uint32_t type, struct nft_ruleset *rs,
 	rewind(fp);
 	fgets(orig, sizeof(orig), fp);
 
-	if (strncmp(orig, out, strlen(out)) == 0)
+	if (strncmp(orig, out, strlen(out)) == 0) {
+		if (update)
+			printf("%s: No changes to update\n", filename);
+		return 0;
+	}
+	if (update) {
+		FILE *fout;
+		printf("%s: Updating test file\n", filename);
+		fout = fopen(filename, "w");
+		if (fout == NULL) {
+			printf("unable to open file %s: %s\n", filename,
+			strerror(errno));
+			return -1;
+		}
+		fprintf(fout, "%s\n", out);
+		fclose(fout);
 		return 0;
+	}
 
 	printf("validating %s: ", filename);
 	printf("\033[31mFAILED\e[0m\n");
@@ -193,15 +211,21 @@ static int execute_test(const char *dir_name)
 
 		if (strcmp(&dent->d_name[len-4], ".xml") == 0) {
 			if ((ret = test_xml(path, err)) == 0) {
-				printf("parsing and validating %s: ", path);
-				printf("\033[32mOK\e[0m\n");
+				if (!update) {
+					printf("parsing and validating %s: ",
+					       path);
+					printf("\033[32mOK\e[0m\n");
+				}
 			}
 			exit_code += ret;
 		}
 		if (strcmp(&dent->d_name[len-5], ".json") == 0) {
 			if ((ret = test_json(path, err)) == 0) {
-				printf("parsing and validating %s: ", path);
-				printf("\033[32mOK\e[0m\n");
+				if (!update) {
+					printf("parsing and validating %s: ",
+					       path);
+					printf("\033[32mOK\e[0m\n");
+				}
 			}
 			exit_code += ret;
 		}
@@ -223,6 +247,7 @@ static void show_help(const char *name)
 "\n"
 "Options:\n"
 "  -d/--dir <directory>		Check test files from <directory>.\n"
+"  -u/--update <directory>	Update test files from <directory>.\n"
 "\n",
 	       name);
 }
@@ -234,6 +259,7 @@ int main(int argc, char *argv[])
 	int option_index = 0;
 	static struct option long_options[] = {
 		{ "dir", required_argument, 0, 'd' },
+		{ "update", required_argument, 0, 'u' },
 		{ 0 }
 	};
 
@@ -243,7 +269,7 @@ int main(int argc, char *argv[])
 	}
 
 	while (1) {
-		val = getopt_long(argc, argv, "d:", long_options,
+		val = getopt_long(argc, argv, "d:u:", long_options,
 				  &option_index);
 
 		if (val == -1)
@@ -253,6 +279,10 @@ int main(int argc, char *argv[])
 		case 'd':
 			ret = execute_test(optarg);
 			break;
+		case 'u':
+			update = true;
+			ret = execute_test(optarg);
+			break;
 		default:
 			show_help(argv[0]);
 			break;
-- 
1.9.0

