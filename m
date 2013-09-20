From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH v2 5/7] ipset: Rework the "fake" argument parsing for ipset restore.
Date: Fri, 20 Sep 2013 10:30:23 +0200
Message-ID: <1379665825-42563-6-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
References: <1379665825-42563-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:45088 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab3ITIcF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Sep 2013 04:32:05 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 5AF45A3416
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2013 09:32:04 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id i0n_JquvDOga for <netfilter-devel@vger.kernel.org>;
	Fri, 20 Sep 2013 09:31:42 +0100 (BST)
In-Reply-To: <1379665825-42563-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

This reworks the argument parsing functionality of ipset to handle
quote-delimited lines in such a way that they are considered to be a
single argument.

This commit is necessary for ipset to successfully restore sets that
have comments.

Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
---
 src/ipset.c | 54 +++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 45 insertions(+), 9 deletions(-)

diff --git a/src/ipset.c b/src/ipset.c
index 4f308da..fe73f96 100644
--- a/src/ipset.c
+++ b/src/ipset.c
@@ -159,25 +159,59 @@ ipset_print_file(const char *fmt, ...)
 static void
 build_argv(char *buffer)
 {
-	char *ptr;
+	char *tmp, *arg;
 	int i;
+	bool quoted = false;
 
 	/* Reset */
-	for (i = 1; i < newargc; i++)
+	for (i = 1; i < newargc; i++) {
+		if (newargv[i])
+			free(newargv[i]);
 		newargv[i] = NULL;
+	}
 	newargc = 1;
 
-	ptr = strtok(buffer, " \t\r\n");
-	newargv[newargc++] = ptr;
-	while ((ptr = strtok(NULL, " \t\r\n")) != NULL) {
-		if ((newargc + 1) < (int)(sizeof(newargv)/sizeof(char *)))
-			newargv[newargc++] = ptr;
-		else {
+	arg = calloc(strlen(buffer) + 1, sizeof(*buffer));
+	for (tmp = buffer, i = 0; *tmp; tmp++) {
+		if ((newargc + 1) == (int)(sizeof(newargv)/sizeof(char *))) {
 			exit_error(PARAMETER_PROBLEM,
 				   "Line is too long to parse.");
 			return;
 		}
+		switch (*tmp) {
+		case '\\':
+			arg[i++] = *++tmp;
+			if (*(tmp+1))
+				continue;
+			break;
+		case '"':
+			quoted = !quoted;
+			if (*(tmp+1))
+				continue;
+			break;
+		case ' ':
+		case '\r':
+		case '\n':
+			if (!quoted)
+				break;
+			arg[i++] = *tmp;
+			continue;
+		default:
+			arg[i++] = *tmp;
+			if (*(tmp+1))
+				continue;
+			break;
+		}
+		if (!*(tmp+1) && quoted) {
+			exit_error(PARAMETER_PROBLEM, "missing close quote");
+			return;
+		}
+		newargv[newargc] = calloc(strlen(arg) + 1, sizeof(*arg));
+		ipset_strlcpy(newargv[newargc++], arg, strlen(arg) + 1);
+		memset(arg, 0, strlen(arg) + 1);
+		i = 0;
 	}
+	free(arg);
 }
 
 /* Main parser function, workhorse */
@@ -195,7 +229,8 @@ restore(char *argv0)
 
 	/* Initialize newargv/newargc */
 	newargc = 0;
-	newargv[newargc++] = argv0;
+	newargv[newargc] = calloc(strlen(argv0) + 1, sizeof(*argv0));
+	ipset_strlcpy(newargv[newargc++], argv0, strlen(argv0) + 1);
 	if (filename) {
 		fd = fopen(filename, "r");
 		if (!fd) {
@@ -232,6 +267,7 @@ restore(char *argv0)
 	if (ret < 0)
 		handle_error();
 
+	free(newargv[0]);
 	return ret;
 }
 
-- 
1.8.3.2

