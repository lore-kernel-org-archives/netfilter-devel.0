From: Eric Leblond <eric@regit.org>
Subject: [PATCH 7/7] conf: error handling for too long line
Date: Mon, 18 Feb 2013 09:37:48 +0100
Message-ID: <1361176668-22661-8-git-send-email-eric@regit.org>
References: <1361176668-22661-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:48545 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab3BRIif (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2013 03:38:35 -0500
In-Reply-To: <1361176668-22661-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Line length in configuration file is limited to 255 due to the use
of a static buffer for line reading. Accepting too long line
without warning as it is currently done could result in some
unexplainable failure.

This patch adds error handling and reject configuration file if a
non comment line is longer than the maximum value.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/conffile.c |   15 +++++++++++++++
 src/ulogd.c    |   10 +++++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/src/conffile.c b/src/conffile.c
index 9a73406..b8e82a8 100644
--- a/src/conffile.c
+++ b/src/conffile.c
@@ -123,6 +123,7 @@ int config_parse_file(const char *section, struct config_keyset *kset)
 	unsigned int i;
 	char linebuf[LINE_LEN+1];
 	char *line = linebuf;
+	int linenum = 0;
 
 	pr_debug("%s: section='%s' file='%s'\n", __func__, section, fname);
 
@@ -135,9 +136,16 @@ int config_parse_file(const char *section, struct config_keyset *kset)
 		char wordbuf[LINE_LEN];
 		char *wordend;
 
+		linenum++;
 		if (*line == '#')
 			continue;
 
+		/* if line was fetch completely, string ends with '\n' */
+		if (! strchr(line, '\n')) {
+			ulogd_log(ULOGD_ERROR, "line %d too long.\n", linenum);
+			return -ERRTOOLONG;
+		}
+
 		if (!(wordend = get_word(line, " \t\n[]", (char *) wordbuf)))
 			continue;
 		pr_debug("word: \"%s\"\n", wordbuf);
@@ -159,10 +167,17 @@ int config_parse_file(const char *section, struct config_keyset *kset)
 		char wordbuf[LINE_LEN];
 		char *wordend;
 		
+		linenum++;
 		pr_debug("line read: %s\n", line);
 		if (*line == '#')
 			continue;
 
+		/* if line was fetch completely, string ends with '\n' */
+		if (! strchr(line, '\n')) {
+			ulogd_log(ULOGD_ERROR, "line %d too long.\n", linenum);
+			return -ERRTOOLONG;
+		}
+
 		if (!(wordend = get_word(line, " =\t\n", (char *) &wordbuf)))
 			continue;
 
diff --git a/src/ulogd.c b/src/ulogd.c
index 6c0df8a..4af4e9a 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -990,9 +990,13 @@ static int parse_conffile(const char *section, struct config_keyset *ce)
 				"section \"%s\" not found\n", section);
 			break;
 		case -ERRTOOLONG:
-			ulogd_log(ULOGD_ERROR,
-				"too long string value for key \"%s\"\n",
-				config_errce->key);
+			if (config_errce->key)
+				ulogd_log(ULOGD_ERROR,
+					  "too long string value for key \"%s\"\n",
+					  config_errce->key);
+			else
+				ulogd_log(ULOGD_ERROR,
+					  "too long string value\n");
 			break;
 	}
 	return 1;
-- 
1.7.10.4

