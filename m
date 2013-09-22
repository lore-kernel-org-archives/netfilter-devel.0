From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH 5/7] ipset: Rework the "fake" argument parsing for ipset restore.
Date: Sun, 22 Sep 2013 20:56:34 +0200
Message-ID: <1379876196-46929-5-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
References: <1379876196-46929-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:55780 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab3IVS6r (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Sep 2013 14:58:47 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 14AA0A31F0
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Sep 2013 19:58:47 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id KapkPZhkCmr3 for <netfilter-devel@vger.kernel.org>;
	Sun, 22 Sep 2013 19:58:12 +0100 (BST)
In-Reply-To: <1379876196-46929-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
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
 src/ipset.c | 52 +++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 43 insertions(+), 9 deletions(-)

diff --git a/src/ipset.c b/src/ipset.c
index 4f308da..12809c8 100644
--- a/src/ipset.c
+++ b/src/ipset.c
@@ -159,25 +159,57 @@ ipset_print_file(const char *fmt, ...)
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
+		case '"':
+			quoted = !quoted;
+			if (*(tmp+1))
+				continue;
+			break;
+		case ' ':
+		case '\r':
+		case '\n':
+		case '\t':
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
+		if (!*arg)
+			continue;
+		newargv[newargc] = calloc(strlen(arg) + 1, sizeof(*arg));
+		ipset_strlcpy(newargv[newargc++], arg, strlen(arg) + 1);
+		memset(arg, 0, strlen(arg) + 1);
+		i = 0;
 	}
+	free(arg);
 }
 
 /* Main parser function, workhorse */
@@ -195,7 +227,8 @@ restore(char *argv0)
 
 	/* Initialize newargv/newargc */
 	newargc = 0;
-	newargv[newargc++] = argv0;
+	newargv[newargc] = calloc(strlen(argv0) + 1, sizeof(*argv0));
+	ipset_strlcpy(newargv[newargc++], argv0, strlen(argv0) + 1);
 	if (filename) {
 		fd = fopen(filename, "r");
 		if (!fd) {
@@ -232,6 +265,7 @@ restore(char *argv0)
 	if (ret < 0)
 		handle_error();
 
+	free(newargv[0]);
 	return ret;
 }
 
-- 
1.8.3.2

