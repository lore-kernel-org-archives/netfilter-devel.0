From: Ana Rey <anarey@gmail.com>
Subject: [PATCH v3] libnftnl: tests: Use getopt_long to parse the command-line arguments.
Date: Fri,  4 Apr 2014 11:22:37 +0200
Message-ID: <fd05d518de09e0141f6e8f37f278c8a2c6d880fe.1396600857.git.anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:53053 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaDDJWs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Apr 2014 05:22:48 -0400
Received: by mail-wi0-f179.google.com with SMTP id z2so835783wiv.12
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Apr 2014 02:22:47 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use getopt_long to parse the command-line arguments and
prepare it to add new arguments in next patches.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
[Change in v2]
Delete some references to second command-line argument (-u). I'll add it in
other patch

[Changes in v3]
* Delete an empty line.
* Add a show_help functions to show the command line option.
* Use an easy and robust check of errors.
These advices were spotted by Pablo Neira.

 tests/nft-parsing-test.c | 57 +++++++++++++++++++++++++++++++++++++++++-------
 tests/test-script.sh     |  4 ++--
 2 files changed, 51 insertions(+), 10 deletions(-)

diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index 1786cb6..058187b 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -4,6 +4,7 @@
 #include <dirent.h>
 #include <limits.h>
 #include <errno.h>
+#include <getopt.h>
 
 #include <libmnl/libmnl.h> /*nlmsghdr*/
 #include <libnftnl/ruleset.h>
@@ -161,7 +162,7 @@ failparsing:
 	return -1;
 }
 
-int main(int argc, char *argv[])
+static int execute_test(const char *dir_name)
 {
 	DIR *d;
 	struct dirent *dent;
@@ -169,12 +170,7 @@ int main(int argc, char *argv[])
 	int ret = 0, exit_code = 0;
 	struct nft_parse_err *err;
 
-	if (argc != 2) {
-		fprintf(stderr, "Usage: %s <directory>\n", argv[0]);
-		exit(EXIT_FAILURE);
-	}
-
-	d = opendir(argv[1]);
+	d = opendir(dir_name);
 	if (d == NULL) {
 		perror("opendir");
 		exit(EXIT_FAILURE);
@@ -193,7 +189,7 @@ int main(int argc, char *argv[])
 		    strcmp(dent->d_name, "..") == 0)
 			continue;
 
-		snprintf(path, sizeof(path), "%s/%s", argv[1], dent->d_name);
+		snprintf(path, sizeof(path), "%s/%s", dir_name, dent->d_name);
 
 		if (strcmp(&dent->d_name[len-4], ".xml") == 0) {
 			if ((ret = test_xml(path, err)) == 0) {
@@ -219,3 +215,48 @@ int main(int argc, char *argv[])
 
 	return 0;
 }
+
+static void show_help(const char *name)
+{
+	printf(
+"Usage: %s [option]\n"
+"\n"
+"Options:\n"
+"  -d/--dir <directory>		Check test files from <directory>.\n"
+"\n",
+	       name);
+}
+
+int main(int argc, char *argv[])
+{
+	int val;
+	int ret = 0;
+	int option_index = 0;
+	static struct option long_options[] = {
+		{"dir", required_argument, 0, 'd'},
+		{0,0,0,0}
+	};
+
+	if (argc != 3) {
+		show_help(argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	while (1) {
+		val = getopt_long(argc, argv, "d:", long_options,
+				  &option_index);
+
+		if (val == -1)
+			break;
+
+		switch (val) {
+		case 'd':
+			ret = execute_test(optarg);
+			break;
+		default:
+			show_help(argv[0]);
+			break;
+		}
+	}
+	return ret;
+}
diff --git a/tests/test-script.sh b/tests/test-script.sh
index b766421..44725d8 100755
--- a/tests/test-script.sh
+++ b/tests/test-script.sh
@@ -18,5 +18,5 @@
 ./nft-rule-test
 ./nft-set-test
 ./nft-table-test
-./nft-parsing-test xmlfiles
-./nft-parsing-test jsonfiles
+./nft-parsing-test -d xmlfiles
+./nft-parsing-test -d jsonfiles
-- 
1.9.0

