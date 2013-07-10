From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 nfacct 5/29] bugfix: prevent 0-sized parameter being accepted
Date: Wed, 10 Jul 2013 19:25:03 +0100
Message-ID: <1373480727-11254-6-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:61883 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab3GJSZs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:25:48 -0400
Received: by mail-la0-f46.google.com with SMTP id eg20so6086845lab.19
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:25:47 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* add nfacct_matches function to prevent zero-sized string being accepted
as a command line parameter;

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 src/nfacct.c | 39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/src/nfacct.c b/src/nfacct.c
index 2ef93c3..1324da7 100644
--- a/src/nfacct.c
+++ b/src/nfacct.c
@@ -59,6 +59,21 @@ static void nfacct_perror(const char *msg)
 	}
 }
 
+/* Matches two strings, including partial matches */
+static int nfacct_matches(const char *cmd, const char *pattern)
+{
+	size_t len;
+
+	if (cmd == NULL || pattern == NULL)
+		return 0;
+
+	len = strlen(cmd);
+	if (len == 0 || len > strlen(pattern))
+		return 0;
+
+	return (strncmp(cmd, pattern, len) == 0);
+}
+
 int main(int argc, char *argv[])
 {
 	int cmd = NFACCT_CMD_NONE, ret = 0;
@@ -68,21 +83,21 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	if (strncmp(argv[1], "list", strlen(argv[1])) == 0)
+	if (nfacct_matches(argv[1], "list"))
 		cmd = NFACCT_CMD_LIST;
-	else if (strncmp(argv[1], "add", strlen(argv[1])) == 0)
+	else if (nfacct_matches(argv[1], "add"))
 		cmd = NFACCT_CMD_ADD;
-	else if (strncmp(argv[1], "delete", strlen(argv[1])) == 0)
+	else if (nfacct_matches(argv[1], "delete"))
 		cmd = NFACCT_CMD_DELETE;
-	else if (strncmp(argv[1], "get", strlen(argv[1])) == 0)
+	else if (nfacct_matches(argv[1], "get"))
 		cmd = NFACCT_CMD_GET;
-	else if (strncmp(argv[1], "flush", strlen(argv[1])) == 0)
+	else if (nfacct_matches(argv[1], "flush"))
 		cmd = NFACCT_CMD_FLUSH;
-	else if (strncmp(argv[1], "version", strlen(argv[1])) == 0)
+	else if (nfacct_matches(argv[1], "version"))
 		cmd = NFACCT_CMD_VERSION;
-	else if (strncmp(argv[1], "help", strlen(argv[1])) == 0)
+	else if (nfacct_matches(argv[1], "help"))
 		cmd = NFACCT_CMD_HELP;
-	else if (strncmp(argv[1], "restore", strlen(argv[1])) == 0)
+	else if (nfacct_matches(argv[1], "restore"))
 		cmd = NFACCT_CMD_RESTORE;
 	else {
 		fprintf(stderr, "nfacct v%s: Unknown command: %s\n",
@@ -167,9 +182,9 @@ static int nfacct_cmd_list(int argc, char *argv[])
 	int ret, i;
 
 	for (i=2; i<argc; i++) {
-		if (strncmp(argv[i], "reset", strlen(argv[i])) == 0) {
+		if (nfacct_matches(argv[i], "reset")) {
 			zeroctr = true;
-		} else if (strncmp(argv[i], "xml", strlen(argv[i])) == 0) {
+		} else if (nfacct_matches(argv[i], "xml")) {
 			xml = true;
 		} else {
 			nfacct_perror("unknown argument");
@@ -375,9 +390,9 @@ static int nfacct_cmd_get(int argc, char *argv[])
 		return -1;
 	}
 	for (i=3; i<argc; i++) {
-		if (strncmp(argv[i], "reset", strlen(argv[i])) == 0) {
+		if (nfacct_matches(argv[i], "reset")) {
 			zeroctr = true;
-		} else if (strncmp(argv[i], "xml", strlen(argv[i])) == 0) {
+		} else if (nfacct_matches(argv[i], "xml")) {
 			xml = true;
 		} else {
 			nfacct_perror("unknown argument");
-- 
1.8.3.1

