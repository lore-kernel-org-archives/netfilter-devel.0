From: Max Kellermann <max@duempel.org>
Subject: [iptables PATCH trunk7285 5/7] unescape parameters
Date: Sun, 27 Jan 2008 19:25:03 +0100
Message-ID: <20080127182503.15959.95515.stgit@woodpecker.roonstrasse.net>
References: <20080127182421.15959.52088.stgit@woodpecker.roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:56486 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752092AbYA0SjO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Jan 2008 13:39:14 -0500
In-Reply-To: <20080127182421.15959.52088.stgit@woodpecker.roonstrasse.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---

 ip6tables-restore.c |   60 ++++++++++++++++++++++++++++++---------------------
 iptables-restore.c  |   49 ++++++++++++++++++------------------------
 2 files changed, 56 insertions(+), 53 deletions(-)


diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index ea05b87..f9d97ef 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -311,8 +311,9 @@ int main(int argc, char *argv[])
 			char *parsestart;
 
 			/* the parser */
-			char *param_start, *curchar;
-			int quote_open;
+			char *curchar;
+			int quote_open, escaped;
+			size_t param_len;
 
 			/* reset the newargv */
 			newargc = 0;
@@ -359,41 +360,45 @@ int main(int argc, char *argv[])
 			 * longer a real hacker, but I can live with that */
 
 			quote_open = 0;
-			param_start = parsestart;
+			escaped = 0;
+			param_len = 0;
 
 			for (curchar = parsestart; *curchar; curchar++) {
-				if (*curchar == '"') {
-					/* quote_open cannot be true if there
-					 * was no previous character.  Thus, 
-					 * curchar-1 has to be within bounds */
-					if (quote_open && 
-					    *(curchar-1) != '\\') {
+				char param_buffer[1024];
+
+				if (escaped) {
+					param_buffer[param_len++] = *curchar;
+					escaped = 0;
+					continue;
+				}
+
+				if (quote_open) {
+					if (*curchar == '\\') {
+						escaped = 1;
+						continue;
+					} else if (*curchar == '"') {
 						quote_open = 0;
 						*curchar = ' ';
 					} else {
+						param_buffer[param_len++] = *curchar;
+						continue;
+					}
+				} else {
+					if (*curchar == '"') {
 						quote_open = 1;
-						param_start++;
+						continue;
 					}
-				} 
+				}
+
 				if (*curchar == ' '
 				    || *curchar == '\t'
 				    || * curchar == '\n') {
-					char param_buffer[1024];
-					int param_len = curchar-param_start;
-
-					if (quote_open)
-						continue;
-
 					if (!param_len) {
 						/* two spaces? */
-						param_start++;
 						continue;
 					}
-					
-					/* end of one parameter */
-					strncpy(param_buffer, param_start,
-						param_len);
-					*(param_buffer+param_len) = '\0';
+
+					param_buffer[param_len] = '\0';
 
 					/* check if table name specified */
 					if (!strncmp(param_buffer, "-t", 3)
@@ -405,9 +410,14 @@ int main(int argc, char *argv[])
 					}
 
 					add_argv(param_buffer);
-					param_start += param_len + 1;
+					param_len = 0;
 				} else {
-					/* regular character, skip */
+					/* regular character, copy to buffer */
+					param_buffer[param_len++] = *curchar;
+
+					if (param_len >= sizeof(param_buffer))
+						exit_error(PARAMETER_PROBLEM, 
+						   "Parameter too long!");
 				}
 			}
 
diff --git a/iptables-restore.c b/iptables-restore.c
index 30746ff..d0d3bd7 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -319,7 +319,7 @@ main(int argc, char *argv[])
 
 			/* the parser */
 			char *curchar;
-			int quote_open;
+			int quote_open, escaped;
 			size_t param_len;
 
 			/* reset the newargv */
@@ -367,34 +367,39 @@ main(int argc, char *argv[])
 			 * longer a real hacker, but I can live with that */
 
 			quote_open = 0;
+			escaped = 0;
 			param_len = 0;
 
 			for (curchar = parsestart; *curchar; curchar++) {
 				char param_buffer[1024];
 
-				if (*curchar == '"') {
-					/* quote_open cannot be true if there
-					 * was no previous character.  Thus, 
-					 * curchar-1 has to be within bounds */
-					if (quote_open && 
-					    *(curchar-1) != '\\') {
+				if (escaped) {
+					param_buffer[param_len++] = *curchar;
+					escaped = 0;
+					continue;
+				}
+
+				if (quote_open) {
+					if (*curchar == '\\') {
+						escaped = 1;
+						continue;
+					} else if (*curchar == '"') {
 						quote_open = 0;
 						*curchar = ' ';
-					} else if (!quote_open) {
+					} else {
+						param_buffer[param_len++] = *curchar;
+						continue;
+					}
+				} else {
+					if (*curchar == '"') {
 						quote_open = 1;
 						continue;
 					}
-				} 
+				}
+
 				if (*curchar == ' '
 				    || *curchar == '\t'
 				    || * curchar == '\n') {
-
-					if (quote_open) {
-						param_buffer[param_len++] = 
-								*curchar;
-						continue;
-					}
-
 					if (!param_len) {
 						/* two spaces? */
 						continue;
@@ -414,18 +419,6 @@ main(int argc, char *argv[])
 					add_argv(param_buffer);
 					param_len = 0;
 				} else {
-					/* Skip backslash that escapes quote: 
-					 * the standard input does not require
-					 * escaping. However, the output
-					 * generated by iptables-save
-					 * introduces bashlash to keep
-					 * consistent with iptables
-					 */
-					if (quote_open &&
-					    *curchar == '\\' &&
-					    *(curchar+1) == '"')
-						continue;
-
 					/* regular character, copy to buffer */
 					param_buffer[param_len++] = *curchar;
 


