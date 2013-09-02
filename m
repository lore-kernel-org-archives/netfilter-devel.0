From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH 4/6] ipset: Rework the "fake" argument parsing for ipset restore.
Date: Mon,  2 Sep 2013 08:35:55 +0200
Message-ID: <1378103757-14426-5-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
References: <1378103757-14426-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:56615 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab3IBGiZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Sep 2013 02:38:25 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id CD442A2D0F
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Sep 2013 07:38:24 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 3nu6Dn422bl9 for <netfilter-devel@vger.kernel.org>;
	Mon,  2 Sep 2013 07:38:05 +0100 (BST)
In-Reply-To: <1378103757-14426-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
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
 src/ipset.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/src/ipset.c b/src/ipset.c
index 4f308da..cff1e55 100644
--- a/src/ipset.c
+++ b/src/ipset.c
@@ -159,20 +159,36 @@ ipset_print_file(const char *fmt, ...)
 static void
 build_argv(char *buffer)
 {
-	char *ptr;
+	char *ptr, *tmp;
 	int i;
 
 	/* Reset */
-	for (i = 1; i < newargc; i++)
+	for (i = 1; i < newargc; i++) {
+		if(newargv[i])
+			free(newargv[i]);
 		newargv[i] = NULL;
+	}
 	newargc = 1;
 
 	ptr = strtok(buffer, " \t\r\n");
-	newargv[newargc++] = ptr;
+	newargv[newargc] = calloc(strlen(ptr) + 1, sizeof(*ptr));
+	ipset_strlcpy(newargv[newargc++], ptr, strlen(ptr) + 1);
 	while ((ptr = strtok(NULL, " \t\r\n")) != NULL) {
-		if ((newargc + 1) < (int)(sizeof(newargv)/sizeof(char *)))
-			newargv[newargc++] = ptr;
-		else {
+		if ((newargc + 1) < (int)(sizeof(newargv)/sizeof(char *))) {
+			tmp = newargv[newargc] = calloc(strlen(ptr) + 1, sizeof(*ptr));
+			if(*ptr == '"') {
+				ipset_strlcpy(tmp, ptr + 1, (strlen(ptr) + 1) * sizeof(*ptr));
+				ipset_strlcat(tmp, " ", (strlen(ptr) + 1) * sizeof(*ptr));
+				while((ptr = strtok(NULL, "\"")) != NULL) {
+					if(*ptr == '\n' || *ptr == '\r')
+						continue;
+					tmp = realloc(tmp, (strlen(tmp) + strlen(ptr) + 1) * sizeof(*ptr));
+					ipset_strlcat(tmp, ptr, (strlen(tmp) + strlen(ptr) + 1) * sizeof(*ptr));
+				}
+			} else
+				ipset_strlcpy(tmp, ptr, (strlen(ptr) + 1) * sizeof(*ptr));
+			newargv[newargc++] = tmp;
+		} else {
 			exit_error(PARAMETER_PROBLEM,
 				   "Line is too long to parse.");
 			return;
@@ -195,7 +211,8 @@ restore(char *argv0)
 
 	/* Initialize newargv/newargc */
 	newargc = 0;
-	newargv[newargc++] = argv0;
+	newargv[newargc] = calloc(strlen(argv0) + 1, sizeof(*argv0));
+	ipset_strlcpy(newargv[newargc++], argv0, strlen(argv0) + 1);
 	if (filename) {
 		fd = fopen(filename, "r");
 		if (!fd) {
@@ -232,6 +249,7 @@ restore(char *argv0)
 	if (ret < 0)
 		handle_error();
 
+	free(newargv[0]);
 	return ret;
 }
 
-- 
1.8.3.2

