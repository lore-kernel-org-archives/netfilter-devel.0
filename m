From: Ana Rey <anarey@gmail.com>
Subject: [PATCH v2] libnftnl: tests: Use getopt_long to parse the command-line arguments.
Date: Thu,  3 Apr 2014 14:40:13 +0200
Message-ID: <3e44e7f0295e9f77d935a6587a24ccba4de20b57.1396528105.git.anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:61825 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbaDCMlS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2014 08:41:18 -0400
Received: by mail-wg0-f49.google.com with SMTP id a1so1809065wgh.20
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Apr 2014 05:41:16 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use getopt_long to parse the command-line arguments and prepare it to
add new arguments in next patches.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
[Change in v2]

Delete some references to second command-line argument (-u). I'll add it in
other patch.


 tests/nft-parsing-test.c | 52 +++++++++++++++++++++++++++++++++++++++++-------
 tests/test-script.sh     |  4 ++--
 2 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index 1786cb6..808ecfb 100644
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
@@ -169,12 +170,8 @@ int main(int argc, char *argv[])
 	int ret = 0, exit_code = 0;
 	struct nft_parse_err *err;
 
-	if (argc != 2) {
-		fprintf(stderr, "Usage: %s <directory>\n", argv[0]);
-		exit(EXIT_FAILURE);
-	}
+	d = opendir(dir_name);
 
-	d = opendir(argv[1]);
 	if (d == NULL) {
 		perror("opendir");
 		exit(EXIT_FAILURE);
@@ -193,7 +190,7 @@ int main(int argc, char *argv[])
 		    strcmp(dent->d_name, "..") == 0)
 			continue;
 
-		snprintf(path, sizeof(path), "%s/%s", argv[1], dent->d_name);
+		snprintf(path, sizeof(path), "%s/%s", dir_name, dent->d_name);
 
 		if (strcmp(&dent->d_name[len-4], ".xml") == 0) {
 			if ((ret = test_xml(path, err)) == 0) {
@@ -219,3 +216,44 @@ int main(int argc, char *argv[])
 
 	return 0;
 }
+
+int main(int argc, char *argv[])
+{
+
+	int c;
+	int ret = 0;
+
+	if (argc < 2) {
+		fprintf(stderr, "Usage: %s -d <directory>\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	while (1) {
+		int option_index = 0;
+		static struct option long_options[] = {
+			{"dir", required_argument, 0, 'd'},
+			{0,0,0,0}
+		};
+		c = getopt_long(argc, argv, "d:", long_options, &option_index);
+
+		if (c == -1)
+			break;
+
+		switch (c) {
+		case 'd':
+			ret = execute_test(optarg);
+			break;
+		default:
+			break;
+		}
+	}
+
+	if (optind < argc) {
+		printf("non-option ARGV-elements: ");
+		while (optind < argc)
+			printf("%s ", argv[optind++]);
+	printf("\nUsage: -d <directory>\n");
+	}
+
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

