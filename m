From: pablo@netfilter.org
Subject: [PATCH] iptables-restore: move code to add_param_to_argv, cleanup (fix gcc-4.7)
Date: Mon, 23 Jul 2012 12:38:23 +0200
Message-ID: <1343039903-7230-1-git-send-email-pablo@netfilter.org>
Cc: netfilter@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch seems to be a mere cleanup that moves the parameter parsing
code to add_param_to_argv.

But, in reality, it also fixes iptables whe compiled with gcc-4.7.

Moving param_buffer declaration out of the loop seems to resolve the
issue. gcc-4.7 seems to be generating bad code regarding param_buffer.

@@ -380,9 +380,9 @@
                        quote_open = 0;
                        escaped = 0;
                        param_len = 0;
+                       char param_buffer[1024];

                        for (curchar = parsestart; *curchar; curchar++) {
-                               char param_buffer[1024];

                                if (quote_open) {
                                        if (escaped) {

But I have hard time to apply this patch in such a way. Instead, I came
up with the idea of this cleanup, which does not harm after all (and fixes
the issue for us).

Sorry, I didn't have the time to further debug this issue, but it would be
worth to investigate what's going wrong and ping gcc people.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/ip6tables-restore.c |  133 +++++++++++++++++++++---------------------
 iptables/iptables-restore.c  |  133 +++++++++++++++++++++---------------------
 2 files changed, 130 insertions(+), 136 deletions(-)

diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index 3894d68..9a03dff 100644
--- a/iptables/ip6tables-restore.c
+++ b/iptables/ip6tables-restore.c
@@ -114,6 +114,70 @@ static void free_argv(void) {
 		free(newargv[i]);
 }
 
+static void add_param_to_argv(char *parsestart)
+{
+	int quote_open = 0, escaped = 0, param_len = 0;
+	char param_buffer[1024], *curchar;
+
+	/* After fighting with strtok enough, here's now
+	 * a 'real' parser. According to Rusty I'm now no
+	 * longer a real hacker, but I can live with that */
+
+	for (curchar = parsestart; *curchar; curchar++) {
+		if (quote_open) {
+			if (escaped) {
+				param_buffer[param_len++] = *curchar;
+				escaped = 0;
+				continue;
+			} else if (*curchar == '\\') {
+				escaped = 1;
+				continue;
+			} else if (*curchar == '"') {
+				quote_open = 0;
+				*curchar = ' ';
+			} else {
+				param_buffer[param_len++] = *curchar;
+				continue;
+			}
+		} else {
+			if (*curchar == '"') {
+				quote_open = 1;
+				continue;
+			}
+		}
+
+		if (*curchar == ' '
+		    || *curchar == '\t'
+		    || * curchar == '\n') {
+			if (!param_len) {
+				/* two spaces? */
+				continue;
+			}
+
+			param_buffer[param_len] = '\0';
+
+			/* check if table name specified */
+			if (!strncmp(param_buffer, "-t", 2)
+                            || !strncmp(param_buffer, "--table", 8)) {
+				xtables_error(PARAMETER_PROBLEM,
+				   "Line %u seems to have a "
+				   "-t table option.\n", line);
+				exit(1);
+			}
+
+			add_argv(param_buffer);
+			param_len = 0;
+		} else {
+			/* regular character, copy to buffer */
+			param_buffer[param_len++] = *curchar;
+
+			if (param_len >= sizeof(param_buffer))
+				xtables_error(PARAMETER_PROBLEM,
+				   "Parameter too long!");
+		}
+	}
+}
+
 int ip6tables_restore_main(int argc, char *argv[])
 {
 	struct xtc_handle *handle = NULL;
@@ -325,11 +389,6 @@ int ip6tables_restore_main(int argc, char *argv[])
 			char *bcnt = NULL;
 			char *parsestart;
 
-			/* the parser */
-			char *curchar;
-			int quote_open, escaped;
-			size_t param_len;
-
 			/* reset the newargv */
 			newargc = 0;
 
@@ -370,69 +429,7 @@ int ip6tables_restore_main(int argc, char *argv[])
 				add_argv((char *) bcnt);
 			}
 
-			/* After fighting with strtok enough, here's now
-			 * a 'real' parser. According to Rusty I'm now no
-			 * longer a real hacker, but I can live with that */
-
-			quote_open = 0;
-			escaped = 0;
-			param_len = 0;
-
-			for (curchar = parsestart; *curchar; curchar++) {
-				char param_buffer[1024];
-
-				if (quote_open) {
-					if (escaped) {
-						param_buffer[param_len++] = *curchar;
-						escaped = 0;
-						continue;
-					} else if (*curchar == '\\') {
-						escaped = 1;
-						continue;
-					} else if (*curchar == '"') {
-						quote_open = 0;
-						*curchar = ' ';
-					} else {
-						param_buffer[param_len++] = *curchar;
-						continue;
-					}
-				} else {
-					if (*curchar == '"') {
-						quote_open = 1;
-						continue;
-					}
-				}
-
-				if (*curchar == ' '
-				    || *curchar == '\t'
-				    || * curchar == '\n') {
-					if (!param_len) {
-						/* two spaces? */
-						continue;
-					}
-
-					param_buffer[param_len] = '\0';
-
-					/* check if table name specified */
-					if (!strncmp(param_buffer, "-t", 2)
-                                            || !strncmp(param_buffer, "--table", 8)) {
-						xtables_error(PARAMETER_PROBLEM,
-						   "Line %u seems to have a "
-						   "-t table option.\n", line);
-						exit(1);
-					}
-
-					add_argv(param_buffer);
-					param_len = 0;
-				} else {
-					/* regular character, copy to buffer */
-					param_buffer[param_len++] = *curchar;
-
-					if (param_len >= sizeof(param_buffer))
-						xtables_error(PARAMETER_PROBLEM,
-						   "Parameter too long!");
-				}
-			}
+			add_param_to_argv(parsestart);
 
 			DEBUGP("calling do_command6(%u, argv, &%s, handle):\n",
 				newargc, curtable);
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 034f960..c974cb3 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -113,6 +113,70 @@ static void free_argv(void) {
 		free(newargv[i]);
 }
 
+static void add_param_to_argv(char *parsestart)
+{
+	int quote_open = 0, escaped = 0, param_len = 0;
+	char param_buffer[1024], *curchar;
+
+	/* After fighting with strtok enough, here's now
+	 * a 'real' parser. According to Rusty I'm now no
+	 * longer a real hacker, but I can live with that */
+
+	for (curchar = parsestart; *curchar; curchar++) {
+		if (quote_open) {
+			if (escaped) {
+				param_buffer[param_len++] = *curchar;
+				escaped = 0;
+				continue;
+			} else if (*curchar == '\\') {
+				escaped = 1;
+				continue;
+			} else if (*curchar == '"') {
+				quote_open = 0;
+				*curchar = ' ';
+			} else {
+				param_buffer[param_len++] = *curchar;
+				continue;
+			}
+		} else {
+			if (*curchar == '"') {
+				quote_open = 1;
+				continue;
+			}
+		}
+
+		if (*curchar == ' '
+		    || *curchar == '\t'
+		    || * curchar == '\n') {
+			if (!param_len) {
+				/* two spaces? */
+				continue;
+			}
+
+			param_buffer[param_len] = '\0';
+
+			/* check if table name specified */
+			if (!strncmp(param_buffer, "-t", 2)
+			    || !strncmp(param_buffer, "--table", 8)) {
+				xtables_error(PARAMETER_PROBLEM,
+				   "Line %u seems to have a "
+				   "-t table option.\n", line);
+				exit(1);
+			}
+
+			add_argv(param_buffer);
+			param_len = 0;
+		} else {
+			/* regular character, copy to buffer */
+			param_buffer[param_len++] = *curchar;
+
+			if (param_len >= sizeof(param_buffer))
+				xtables_error(PARAMETER_PROBLEM,
+				   "Parameter too long!");
+		}
+	}
+}
+
 int
 iptables_restore_main(int argc, char *argv[])
 {
@@ -325,11 +389,6 @@ iptables_restore_main(int argc, char *argv[])
 			char *bcnt = NULL;
 			char *parsestart;
 
-			/* the parser */
-			char *curchar;
-			int quote_open, escaped;
-			size_t param_len;
-
 			/* reset the newargv */
 			newargc = 0;
 
@@ -370,69 +429,7 @@ iptables_restore_main(int argc, char *argv[])
 				add_argv((char *) bcnt);
 			}
 
-			/* After fighting with strtok enough, here's now
-			 * a 'real' parser. According to Rusty I'm now no
-			 * longer a real hacker, but I can live with that */
-
-			quote_open = 0;
-			escaped = 0;
-			param_len = 0;
-
-			for (curchar = parsestart; *curchar; curchar++) {
-				char param_buffer[1024];
-
-				if (quote_open) {
-					if (escaped) {
-						param_buffer[param_len++] = *curchar;
-						escaped = 0;
-						continue;
-					} else if (*curchar == '\\') {
-						escaped = 1;
-						continue;
-					} else if (*curchar == '"') {
-						quote_open = 0;
-						*curchar = ' ';
-					} else {
-						param_buffer[param_len++] = *curchar;
-						continue;
-					}
-				} else {
-					if (*curchar == '"') {
-						quote_open = 1;
-						continue;
-					}
-				}
-
-				if (*curchar == ' '
-				    || *curchar == '\t'
-				    || * curchar == '\n') {
-					if (!param_len) {
-						/* two spaces? */
-						continue;
-					}
-
-					param_buffer[param_len] = '\0';
-
-					/* check if table name specified */
-					if (!strncmp(param_buffer, "-t", 2)
-					    || !strncmp(param_buffer, "--table", 8)) {
-						xtables_error(PARAMETER_PROBLEM,
-						   "Line %u seems to have a "
-						   "-t table option.\n", line);
-						exit(1);
-					}
-
-					add_argv(param_buffer);
-					param_len = 0;
-				} else {
-					/* regular character, copy to buffer */
-					param_buffer[param_len++] = *curchar;
-
-					if (param_len >= sizeof(param_buffer))
-						xtables_error(PARAMETER_PROBLEM,
-						   "Parameter too long!");
-				}
-			}
+			add_param_to_argv(parsestart);
 
 			DEBUGP("calling do_command4(%u, argv, &%s, handle):\n",
 				newargc, curtable);
-- 
1.7.10.4

