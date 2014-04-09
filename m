From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH v2 2/2] tests: Add support to check a json or xml testfile.
Date: Wed,  9 Apr 2014 17:03:45 +0200
Message-ID: <07f8313955cf76c674475c45a6003a9f4e92da97.1397048551.git.anarey@gmail.com>
References: <cover.1397048551.git.anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:63068 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933774AbaDIPED (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:04:03 -0400
Received: by mail-wg0-f43.google.com with SMTP id x13so2634358wgg.14
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Apr 2014 08:04:01 -0700 (PDT)
In-Reply-To: <cover.1397048551.git.anarey@gmail.com>
In-Reply-To: <cover.1397048551.git.anarey@gmail.com>
References: <cover.1397048551.git.anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add new command-line argument "-f <file>" to check a json or xml
testfile.

./nft-parsing-test -f <file>  Check this testfile.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
[Change in v2:]
Without changes.

 tests/nft-parsing-test.c | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index 59c75a6..952ffbf 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -240,6 +240,47 @@ static int execute_test(const char *dir_name)
 	return 0;
 }
 
+static int execute_test_file(const char *filename)
+{
+	char path[PATH_MAX];
+	int ret = 0;
+	struct nft_parse_err *err;
+
+	err = nft_parse_err_alloc();
+	if (err == NULL) {
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
+
+	snprintf(path, sizeof(path), "%s", filename);
+
+	int len = strlen(filename);
+	if (strcmp(&filename[len-4], ".xml") == 0) {
+		if ((ret = test_xml(path, err)) == 0) {
+			if (!update) {
+				printf("parsing and validating %s: ",
+				       path);
+				printf("\033[32mOK\e[0m\n");
+			}
+		}
+		exit(EXIT_FAILURE);
+	}
+	if (strcmp(&filename[len-5], ".json") == 0) {
+		if ((ret = test_json(path, err)) == 0) {
+			if (!update) {
+				printf("parsing and validating %s: ",
+				       path);
+				printf("\033[32mOK\e[0m\n");
+			}
+		}
+		exit(EXIT_FAILURE);
+	}
+
+	nft_parse_err_free(err);
+
+	return 0;
+}
+
 static void show_help(const char *name)
 {
 	printf(
@@ -248,6 +289,7 @@ static void show_help(const char *name)
 "Options:\n"
 "  -d/--dir <directory>		Check test files from <directory>.\n"
 "  -u/--update <directory>	Update test files from <directory>.\n"
+"  -f/--file <file>		Check test file <file>\n"
 "\n",
 	       name);
 }
@@ -260,6 +302,7 @@ int main(int argc, char *argv[])
 	static struct option long_options[] = {
 		{ "dir", required_argument, 0, 'd' },
 		{ "update", required_argument, 0, 'u' },
+		{ "file", required_argument, 0, 'f' },
 		{ 0 }
 	};
 
@@ -269,7 +312,7 @@ int main(int argc, char *argv[])
 	}
 
 	while (1) {
-		val = getopt_long(argc, argv, "d:u:", long_options,
+		val = getopt_long(argc, argv, "d:u:f:", long_options,
 				  &option_index);
 
 		if (val == -1)
@@ -283,6 +326,9 @@ int main(int argc, char *argv[])
 			update = true;
 			ret = execute_test(optarg);
 			break;
+		case 'f':
+			ret = execute_test_file(optarg);
+			break;
 		default:
 			show_help(argv[0]);
 			break;
-- 
1.9.0

