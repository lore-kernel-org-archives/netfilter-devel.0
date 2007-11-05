From: Peter Warasin <peter@endian.com>
Subject: [PATCH 2/3] iptables-edit: source out iptables-restore and iptables-save
 functionality to iptables-dump.c
Date: Mon, 05 Nov 2007 01:13:58 +0100
Message-ID: <472E6046.9020004@endian.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060807040805000309050802"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:49455 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbXKEAOE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Nov 2007 19:14:04 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by solaria.endian.it (Postfix) with ESMTP id BC97C598231
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Nov 2007 01:14:02 +0100 (CET)
Received: from solaria.endian.it ([127.0.0.1])
	by localhost (solaria.endian.it [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zWnTjFL7KBhi for <netfilter-devel@vger.kernel.org>;
	Mon,  5 Nov 2007 01:14:00 +0100 (CET)
Received: from [10.139.200.200] (host204-41-dynamic.56-82-r.retail.telecomitalia.it [82.56.41.204])
	by solaria.endian.it (Postfix) with ESMTP id C3FFC598321
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Nov 2007 01:13:58 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060807040805000309050802
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


-- 
:: e n d i a n
:: open source - open minds

:: peter warasin
:: http://www.endian.com   :: peter@endian.com

--------------060807040805000309050802
Content-Type: text/x-patch;
 name="iptables-edit-p2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-edit-p2.patch"

source out iptables-restore and iptables-save functionality to iptables-dump.c
which renames do_output() to create_dump(), extends it and introduces restore_dump()
in order to allow reuse.

Signed-off-by: Peter Warasin <peter@endian.com>
---
 Makefile                |    9 
 include/iptables-dump.h |   24 +
 iptables-dump.c         |  686 ++++++++++++++++++++++++++++++++++++++++++++++++
 iptables-restore.c      |  360 -------------------------
 iptables-save.c         |  312 ---------------------
 5 files changed, 725 insertions(+), 666 deletions(-)

Index: iptables-restore.c
===================================================================
--- iptables-restore.c.orig
+++ iptables-restore.c
@@ -8,13 +8,9 @@
  */
 
 #include <getopt.h>
-#include <sys/errno.h>
-#include <string.h>
 #include <stdio.h>
 #include <stdlib.h>
-#include "iptables.h"
-#include "xtables.h"
-#include "libiptc/libiptc.h"
+#include "iptables-dump.h"
 
 #ifdef DEBUG
 #define DEBUGP(x, args...) fprintf(stderr, x, ## args)
@@ -22,8 +18,6 @@
 #define DEBUGP(x, args...) 
 #endif
 
-static int binary = 0, counters = 0, verbose = 0, noflush = 0;
-
 /* Keeping track of external matches and targets.  */
 static struct option options[] = {
 	{ "binary", 0, 0, 'b' },
@@ -54,62 +48,6 @@
 	exit(1);
 }
 
-iptc_handle_t create_handle(const char *tablename, const char* modprobe )
-{
-	iptc_handle_t handle;
-
-	handle = iptc_init(tablename);
-
-	if (!handle) {
-		/* try to insmod the module if iptc_init failed */
-		load_xtables_ko(modprobe, 0);
-		handle = iptc_init(tablename);
-	}
-
-	if (!handle) {
-		exit_error(PARAMETER_PROBLEM, "%s: unable to initialize "
-			"table '%s'\n", program_name, tablename);
-		exit(1);
-	}
-	return handle;
-}
-
-static int parse_counters(char *string, struct ipt_counters *ctr)
-{
-	unsigned long long pcnt, bcnt;
-	int ret;
-
-	ret = sscanf(string, "[%llu:%llu]",
-		     (unsigned long long *)&pcnt,
-		     (unsigned long long *)&bcnt);
-	ctr->pcnt = pcnt;
-	ctr->bcnt = bcnt;
-	return ret == 2;
-}
-
-/* global new argv and argc */
-static char *newargv[255];
-static int newargc;
-
-/* function adding one argument to newargv, updating newargc 
- * returns true if argument added, false otherwise */
-static int add_argv(char *what) {
-	DEBUGP("add_argv: %s\n", what);
-	if (what && ((newargc + 1) < sizeof(newargv)/sizeof(char *))) {
-		newargv[newargc] = strdup(what);
-		newargc++;
-		return 1;
-	} else 
-		return 0;
-}
-
-static void free_argv(void) {
-	int i;
-
-	for (i = 0; i < newargc; i++)
-		free(newargv[i]);
-}
-
 #ifdef IPTABLES_MULTI
 int
 iptables_restore_main(int argc, char *argv[])
@@ -118,18 +56,14 @@
 main(int argc, char *argv[])
 #endif
 {
-	iptc_handle_t handle = NULL;
-	char buffer[10240];
+	int binary = 0, counters = 0, verbose = 0, noflush = 0, testing = 0;
 	int c;
-	char curtable[IPT_TABLE_MAXNAMELEN + 1];
-	FILE *in;
 	const char *modprobe = 0;
-	int in_table = 0, testing = 0;
+	const char *filename = 0;
 	const char *tablename = 0;
 
 	program_name = "iptables-restore";
 	program_version = IPTABLES_VERSION;
-	line = 0;
 
 	lib_dir = getenv("IPTABLES_LIB_DIR");
 	if (!lib_dir)
@@ -170,295 +104,11 @@
 	}
 	
 	if (optind == argc - 1) {
-		in = fopen(argv[optind], "r");
-		if (!in) {
-			fprintf(stderr, "Can't open %s: %s\n", argv[optind],
-				strerror(errno));
-			exit(1);
-		}
+		filename = argv[optind];
 	}
 	else if (optind < argc) {
 		fprintf(stderr, "Unknown arguments found on commandline\n");
 		exit(1);
 	}
-	else in = stdin;
-	
-	/* Grab standard input. */
-	while (fgets(buffer, sizeof(buffer), in)) {
-		int ret = 0;
-
-		line++;
-		if (buffer[0] == '\n')
-			continue;
-		else if (buffer[0] == '#') {
-			if (verbose)
-				fputs(buffer, stdout);
-			continue;
-		} else if ((strcmp(buffer, "COMMIT\n") == 0) && (in_table)) {
-			if (!testing) {
-				DEBUGP("Calling commit\n");
-				ret = iptc_commit(&handle);
-			} else {
-				DEBUGP("Not calling commit, testing\n");
-				ret = 1;
-			}
-			in_table = 0;
-		} else if ((buffer[0] == '*') && (!in_table)) {
-			/* New table */
-			char *table;
-
-			table = strtok(buffer+1, " \t\n");
-			DEBUGP("line %u, table '%s'\n", line, table);
-			if (!table) {
-				exit_error(PARAMETER_PROBLEM, 
-					"%s: line %u table name invalid\n",
-					program_name, line);
-				exit(1);
-			}
-			strncpy(curtable, table, IPT_TABLE_MAXNAMELEN);
-			curtable[IPT_TABLE_MAXNAMELEN] = '\0';
-
-			if (tablename && (strcmp(tablename, table) != 0))
-				continue;
-			if (handle)
-				iptc_free(&handle);
-
-			handle = create_handle(table, modprobe);
-			if (noflush == 0) {
-				DEBUGP("Cleaning all chains of table '%s'\n",
-					table);
-				for_each_chain(flush_entries, verbose, 1, 
-						&handle);
-	
-				DEBUGP("Deleting all user-defined chains "
-				       "of table '%s'\n", table);
-				for_each_chain(delete_chain, verbose, 0, 
-						&handle) ;
-			}
-
-			ret = 1;
-			in_table = 1;
-
-		} else if ((buffer[0] == ':') && (in_table)) {
-			/* New chain. */
-			char *policy, *chain;
-
-			chain = strtok(buffer+1, " \t\n");
-			DEBUGP("line %u, chain '%s'\n", line, chain);
-			if (!chain) {
-				exit_error(PARAMETER_PROBLEM,
-					   "%s: line %u chain name invalid\n",
-					   program_name, line);
-				exit(1);
-			}
-
-			if (iptc_builtin(chain, handle) <= 0) {
-				if (noflush && iptc_is_chain(chain, handle)) {
-					DEBUGP("Flushing existing user defined chain '%s'\n", chain);
-					if (!iptc_flush_entries(chain, &handle))
-						exit_error(PARAMETER_PROBLEM,
-							   "error flushing chain "
-							   "'%s':%s\n", chain,
-							   strerror(errno));
-				} else {
-					DEBUGP("Creating new chain '%s'\n", chain);
-					if (!iptc_create_chain(chain, &handle))
-						exit_error(PARAMETER_PROBLEM,
-							   "error creating chain "
-							   "'%s':%s\n", chain,
-							   strerror(errno));
-				}
-			}
-
-			policy = strtok(NULL, " \t\n");
-			DEBUGP("line %u, policy '%s'\n", line, policy);
-			if (!policy) {
-				exit_error(PARAMETER_PROBLEM,
-					   "%s: line %u policy invalid\n",
-					   program_name, line);
-				exit(1);
-			}
-
-			if (strcmp(policy, "-") != 0) {
-				struct ipt_counters count;
-
-				if (counters) {
-					char *ctrs;
-					ctrs = strtok(NULL, " \t\n");
-
-					if (!ctrs || !parse_counters(ctrs, &count))
-						exit_error(PARAMETER_PROBLEM,
-							   "invalid policy counters "
-							   "for chain '%s'\n", chain);
-
-				} else {
-					memset(&count, 0, 
-					       sizeof(struct ipt_counters));
-				}
-
-				DEBUGP("Setting policy of chain %s to %s\n",
-					chain, policy);
-
-				if (!iptc_set_policy(chain, policy, &count,
-						     &handle))
-					exit_error(OTHER_PROBLEM,
-						"Can't set policy `%s'"
-						" on `%s' line %u: %s\n",
-						chain, policy, line,
-						iptc_strerror(errno));
-			}
-
-			ret = 1;
-
-		} else if (in_table) {
-			int a;
-			char *ptr = buffer;
-			char *pcnt = NULL;
-			char *bcnt = NULL;
-			char *parsestart;
-
-			/* the parser */
-			char *curchar;
-			int quote_open;
-			int param_len;
-
-			/* reset the newargv */
-			newargc = 0;
-
-			if (buffer[0] == '[') {
-				/* we have counters in our input */
-				ptr = strchr(buffer, ']');
-				if (!ptr)
-					exit_error(PARAMETER_PROBLEM,
-						   "Bad line %u: need ]\n",
-						   line);
-
-				pcnt = strtok(buffer+1, ":");
-				if (!pcnt)
-					exit_error(PARAMETER_PROBLEM,
-						   "Bad line %u: need :\n",
-						   line);
-
-				bcnt = strtok(NULL, "]");
-				if (!bcnt)
-					exit_error(PARAMETER_PROBLEM,
-						   "Bad line %u: need ]\n",
-						   line);
-
-				/* start command parsing after counter */
-				parsestart = ptr + 1;
-			} else {
-				/* start command parsing at start of line */
-				parsestart = buffer;
-			}
-
-			add_argv(argv[0]);
-			add_argv("-t");
-			add_argv((char *) &curtable);
-			
-			if (counters && pcnt && bcnt) {
-				add_argv("--set-counters");
-				add_argv((char *) pcnt);
-				add_argv((char *) bcnt);
-			}
-
-			/* After fighting with strtok enough, here's now
-			 * a 'real' parser. According to Rusty I'm now no
-			 * longer a real hacker, but I can live with that */
-
-			quote_open = 0;
-			param_len = 0;
-			
-			for (curchar = parsestart; *curchar; curchar++) {
-				char param_buffer[1024];
-
-				if (*curchar == '"') {
-					/* quote_open cannot be true if there
-					 * was no previous character.  Thus, 
-					 * curchar-1 has to be within bounds */
-					if (quote_open && 
-					    *(curchar-1) != '\\') {
-						quote_open = 0;
-						*curchar = ' ';
-					} else if (!quote_open) {
-						quote_open = 1;
-						continue;
-					}
-				} 
-				if (*curchar == ' '
-				    || *curchar == '\t'
-				    || * curchar == '\n') {
-
-					if (quote_open) {
-						param_buffer[param_len++] = 
-								*curchar;
-						continue;
-					}
-
-					if (!param_len) {
-						/* two spaces? */
-						continue;
-					}
-
-					param_buffer[param_len] = '\0';
-
-					/* check if table name specified */
-					if (!strncmp(param_buffer, "-t", 3)
-                                            || !strncmp(param_buffer, "--table", 8)) {
-						exit_error(PARAMETER_PROBLEM, 
-						   "Line %u seems to have a "
-						   "-t table option.\n", line);
-						exit(1);
-					}
-
-					add_argv(param_buffer);
-					param_len = 0;
-				} else {
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
-					/* regular character, copy to buffer */
-					param_buffer[param_len++] = *curchar;
-
-					if (param_len >= sizeof(param_buffer))
-						exit_error(PARAMETER_PROBLEM, 
-						   "Parameter too long!");
-				}
-			}
-
-			DEBUGP("calling do_command(%u, argv, &%s, handle):\n",
-				newargc, curtable);
-
-			for (a = 0; a < newargc; a++)
-				DEBUGP("argv[%u]: %s\n", a, newargv[a]);
-
-			ret = do_command(newargc, newargv, 
-					 &newargv[2], &handle);
-
-			free_argv();
-		}
-		if (tablename && (strcmp(tablename, curtable) != 0))
-			continue;
-		if (!ret) {
-			fprintf(stderr, "%s: line %u failed\n",
-					program_name, line);
-			exit(1);
-		}
-	}
-	if (in_table) {
-		fprintf(stderr, "%s: COMMIT expected at line %u\n",
-				program_name, line + 1);
-		exit(1);
-	}
-
-	return 0;
+	return restore_dump(tablename, NULL, modprobe, filename, binary, counters, verbose, noflush, testing);
 }
Index: include/iptables-dump.h
===================================================================
--- /dev/null
+++ include/iptables-dump.h
@@ -0,0 +1,24 @@
+/* Code to save or restore the iptables state, in human readable-form. */
+/* (C) 1999 by Paul 'Rusty' Russell <rusty@rustcorp.com.au> and
+ * (C) 2000-2002 by Harald Welte <laforge@gnumonks.org>
+ *
+ * This code is distributed under the terms of GNU GPL v2
+ *
+ * $Id$
+ */
+
+#ifndef _IPTABLES_DUMP_H
+#define _IPTABLES_DUMP_H
+
+#include "iptables.h"
+
+extern const char *program_name;
+extern const char *program_version;
+
+int create_dump(const char *tablename, iptc_handle_t h, int binary, int counters);
+
+int restore_dump(const char *tablename, iptc_handle_t storehandle,
+		  const char *modprobe, const char *filename, int binary,
+		  int counters, int verbose, int noflush, int testing);
+
+#endif /*_IPTABLES_DUMP_H*/
Index: iptables-dump.c
===================================================================
--- /dev/null
+++ iptables-dump.c
@@ -0,0 +1,686 @@
+/* Code to dump and restore the iptables state.
+ * (C) 2000-2002 by Harald Welte <laforge@gnumonks.org>
+ * based on previous code from Rusty Russell <rusty@linuxcare.com.au>
+ *
+ * This code is distributed under the terms of GNU GPL v2
+ *
+ * $Id$
+ */
+
+#include <sys/errno.h>
+#include <stdio.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <dlfcn.h>
+#include <string.h>
+#include <time.h>
+#include <netdb.h>
+#include "iptables.h"
+#include "xtables.h"
+#include "libiptc/libiptc.h"
+#include "iptables-dump.h"
+
+#ifdef DEBUG
+#define DEBUGP(x, args...) fprintf(stderr, x, ## args)
+#else
+#define DEBUGP(x, args...) 
+#endif
+
+iptc_handle_t create_handle(const char *tablename, const char* modprobe )
+{
+	iptc_handle_t handle;
+
+	handle = iptc_init(tablename);
+
+	if (!handle) {
+		/* try to insmod the module if iptc_init failed */
+		load_xtables_ko(modprobe, 0);
+		handle = iptc_init(tablename);
+	}
+
+	if (!handle) {
+		exit_error(PARAMETER_PROBLEM, "%s: unable to initialize "
+			"table '%s'\n", program_name, tablename);
+		return NULL;
+	}
+	return handle;
+}
+
+static int parse_counters(char *string, struct ipt_counters *ctr)
+{
+	unsigned long long pcnt, bcnt;
+	int ret;
+
+	ret = sscanf(string, "[%llu:%llu]",
+		     (unsigned long long *)&pcnt,
+		     (unsigned long long *)&bcnt);
+	ctr->pcnt = pcnt;
+	ctr->bcnt = bcnt;
+	return ret == 2;
+}
+
+/* global new argv and argc */
+static char *newargv[255];
+static int newargc;
+
+/* function adding one argument to newargv, updating newargc 
+ * returns true if argument added, false otherwise */
+static int add_argv(char *what) {
+	DEBUGP("add_argv: %s\n", what);
+	if (what && ((newargc + 1) < sizeof(newargv)/sizeof(char *))) {
+		newargv[newargc] = strdup(what);
+		newargc++;
+		return 1;
+	} else 
+		return 0;
+}
+
+static void free_argv(void) {
+	int i;
+
+	for (i = 0; i < newargc; i++)
+		free(newargv[i]);
+}
+
+int restore_dump(const char *tablename, iptc_handle_t storehandle,
+		  const char *modprobe, const char *filename,
+		  int binary, int counters, int verbose, int noflush, int testing)
+{
+	char buffer[10240];
+	char curtable[IPT_TABLE_MAXNAMELEN + 1];
+	FILE *in;
+	int in_table = 0, line = 0;
+	iptc_handle_t handle = NULL;
+	static char *argv[255];
+
+	argv[0] = strdup(program_name);
+	if (filename != NULL) {
+		in = fopen(filename, "r");
+		if (!in) {
+			fprintf(stderr, "Can't open %s: %s\n", filename,
+				strerror(errno));
+			return 1;
+		}
+	}
+	else in = stdin;
+	
+	/* Grab standard input. */
+	while (fgets(buffer, sizeof(buffer), in)) {
+		int ret = 0;
+
+		line++;
+		if (buffer[0] == '\n')
+			continue;
+		else if (buffer[0] == '#') {
+			if (verbose)
+				fputs(buffer, stdout);
+			continue;
+		} else if ((strcmp(buffer, "COMMIT\n") == 0) && (in_table)) {
+			if (!testing) {
+				DEBUGP("Calling commit\n");
+				ret = iptc_commit(&handle);
+			} else {
+				DEBUGP("Not calling commit, testing\n");
+				ret = 1;
+			}
+			in_table = 0;
+		} else if ((buffer[0] == '*') && (!in_table)) {
+			/* New table */
+			char *table;
+
+			table = strtok(buffer+1, " \t\n");
+			DEBUGP("line %u, table '%s'\n", line, table);
+			if (!table) {
+				exit_error(PARAMETER_PROBLEM, 
+					"%s: line %u table name invalid\n",
+					program_name, line);
+				return 1;
+			}
+			strncpy(curtable, table, IPT_TABLE_MAXNAMELEN);
+			curtable[IPT_TABLE_MAXNAMELEN] = '\0';
+
+			if (tablename && (strcmp(tablename, table) != 0))
+				continue;
+			if (handle)
+				iptc_free(&handle);
+
+			if (storehandle)
+				handle = storehandle;
+			else
+				handle = create_handle(table, modprobe);
+
+			if (! handle)
+				return 1;
+
+			if (noflush == 0) {
+				DEBUGP("Cleaning all chains of table '%s'\n",
+					table);
+				for_each_chain(flush_entries, verbose, 1, 
+						&handle);
+	
+				DEBUGP("Deleting all user-defined chains "
+				       "of table '%s'\n", table);
+				for_each_chain(delete_chain, verbose, 0, 
+						&handle) ;
+			}
+
+			ret = 1;
+			in_table = 1;
+
+		} else if ((buffer[0] == ':') && (in_table)) {
+			/* New chain. */
+			char *policy, *chain;
+
+			chain = strtok(buffer+1, " \t\n");
+			DEBUGP("line %u, chain '%s'\n", line, chain);
+			if (!chain) {
+				exit_error(PARAMETER_PROBLEM,
+					   "%s: line %u chain name invalid\n",
+					   program_name, line);
+				return 1;
+			}
+
+			if (iptc_builtin(chain, handle) <= 0) {
+				if (noflush && iptc_is_chain(chain, handle)) {
+					DEBUGP("Flushing existing user defined chain '%s'\n", chain);
+					if (!iptc_flush_entries(chain, &handle))
+						exit_error(PARAMETER_PROBLEM,
+							   "error flushing chain "
+							   "'%s':%s\n", chain,
+							   strerror(errno));
+				} else {
+					DEBUGP("Creating new chain '%s'\n", chain);
+					if (!iptc_create_chain(chain, &handle))
+						exit_error(PARAMETER_PROBLEM,
+							   "error creating chain "
+							   "'%s':%s\n", chain,
+							   strerror(errno));
+				}
+			}
+
+			policy = strtok(NULL, " \t\n");
+			DEBUGP("line %u, policy '%s'\n", line, policy);
+			if (!policy) {
+				exit_error(PARAMETER_PROBLEM,
+					   "%s: line %u policy invalid\n",
+					   program_name, line);
+				return 1;
+			}
+
+			if (strcmp(policy, "-") != 0) {
+				struct ipt_counters count;
+
+				if (counters) {
+					char *ctrs;
+					ctrs = strtok(NULL, " \t\n");
+
+					if (!ctrs || !parse_counters(ctrs, &count))
+						exit_error(PARAMETER_PROBLEM,
+							   "invalid policy counters "
+							   "for chain '%s'\n", chain);
+
+				} else {
+					memset(&count, 0, 
+					       sizeof(struct ipt_counters));
+				}
+
+				DEBUGP("Setting policy of chain %s to %s\n",
+					chain, policy);
+
+				if (!iptc_set_policy(chain, policy, &count,
+						     &handle))
+					exit_error(OTHER_PROBLEM,
+						"Can't set policy `%s'"
+						" on `%s' line %u: %s\n",
+						chain, policy, line,
+						iptc_strerror(errno));
+			}
+
+			ret = 1;
+
+		} else if (in_table) {
+			int a;
+			char *ptr = buffer;
+			char *pcnt = NULL;
+			char *bcnt = NULL;
+			char *parsestart;
+
+			/* the parser */
+			char *curchar;
+			int quote_open;
+			int param_len;
+
+			/* reset the newargv */
+			newargc = 0;
+
+			if (buffer[0] == '[') {
+				/* we have counters in our input */
+				ptr = strchr(buffer, ']');
+				if (!ptr)
+					exit_error(PARAMETER_PROBLEM,
+						   "Bad line %u: need ]\n",
+						   line);
+
+				pcnt = strtok(buffer+1, ":");
+				if (!pcnt)
+					exit_error(PARAMETER_PROBLEM,
+						   "Bad line %u: need :\n",
+						   line);
+
+				bcnt = strtok(NULL, "]");
+				if (!bcnt)
+					exit_error(PARAMETER_PROBLEM,
+						   "Bad line %u: need ]\n",
+						   line);
+
+				/* start command parsing after counter */
+				parsestart = ptr + 1;
+			} else {
+				/* start command parsing at start of line */
+				parsestart = buffer;
+			}
+
+			add_argv(argv[0]);
+			add_argv("-t");
+			add_argv((char *) &curtable);
+			
+			if (counters && pcnt && bcnt) {
+				add_argv("--set-counters");
+				add_argv((char *) pcnt);
+				add_argv((char *) bcnt);
+			}
+
+			/* After fighting with strtok enough, here's now
+			 * a 'real' parser. According to Rusty I'm now no
+			 * longer a real hacker, but I can live with that */
+
+			quote_open = 0;
+			param_len = 0;
+			
+			for (curchar = parsestart; *curchar; curchar++) {
+				char param_buffer[1024];
+
+				if (*curchar == '"') {
+					/* quote_open cannot be true if there
+					 * was no previous character.  Thus, 
+					 * curchar-1 has to be within bounds */
+					if (quote_open && 
+					    *(curchar-1) != '\\') {
+						quote_open = 0;
+						*curchar = ' ';
+					} else if (!quote_open) {
+						quote_open = 1;
+						continue;
+					}
+				} 
+				if (*curchar == ' '
+				    || *curchar == '\t'
+				    || * curchar == '\n') {
+
+					if (quote_open) {
+						param_buffer[param_len++] = 
+								*curchar;
+						continue;
+					}
+
+					if (!param_len) {
+						/* two spaces? */
+						continue;
+					}
+
+					param_buffer[param_len] = '\0';
+
+					/* check if table name specified */
+					if (!strncmp(param_buffer, "-t", 3)
+                                            || !strncmp(param_buffer, "--table", 8)) {
+						exit_error(PARAMETER_PROBLEM, 
+						   "Line %u seems to have a "
+						   "-t table option.\n", line);
+						return 1;
+					}
+
+					add_argv(param_buffer);
+					param_len = 0;
+				} else {
+					/* Skip backslash that escapes quote: 
+					 * the standard input does not require
+					 * escaping. However, the output
+					 * generated by iptables-save
+					 * introduces bashlash to keep
+					 * consistent with iptables
+					 */
+					if (quote_open &&
+					    *curchar == '\\' &&
+					    *(curchar+1) == '"')
+						continue;
+
+					/* regular character, copy to buffer */
+					param_buffer[param_len++] = *curchar;
+
+					if (param_len >= sizeof(param_buffer))
+						exit_error(PARAMETER_PROBLEM, 
+						   "Parameter too long!");
+				}
+			}
+
+			DEBUGP("calling do_command(%u, argv, &%s, handle):\n",
+				newargc, curtable);
+
+			for (a = 0; a < newargc; a++)
+				DEBUGP("argv[%u]: %s\n", a, newargv[a]);
+
+			ret = do_command(newargc, newargv, 
+					 &newargv[2], &handle);
+
+			free_argv();
+		}
+		if (tablename && (strcmp(tablename, curtable) != 0))
+			continue;
+		if (!ret) {
+			fprintf(stderr, "%s: line %u failed\n",
+					program_name, line);
+			return 1;
+		}
+	}
+	if (in_table) {
+		fprintf(stderr, "%s: COMMIT expected at line %u\n",
+				program_name, line + 1);
+		return 1;
+	}
+
+	return 0;
+}
+
+#define IP_PARTS_NATIVE(n)			\
+(unsigned int)((n)>>24)&0xFF,			\
+(unsigned int)((n)>>16)&0xFF,			\
+(unsigned int)((n)>>8)&0xFF,			\
+(unsigned int)((n)&0xFF)
+
+#define IP_PARTS(n) IP_PARTS_NATIVE(ntohl(n))
+
+/* This assumes that mask is contiguous, and byte-bounded. */
+static void
+print_iface(char letter, const char *iface, const unsigned char *mask,
+	    int invert)
+{
+	unsigned int i;
+
+	if (mask[0] == 0)
+		return;
+
+	printf("-%c %s", letter, invert ? "! " : "");
+
+	for (i = 0; i < IFNAMSIZ; i++) {
+		if (mask[i] != 0) {
+			if (iface[i] != '\0')
+				printf("%c", iface[i]);
+		} else {
+			/* we can access iface[i-1] here, because 
+			 * a few lines above we make sure that mask[0] != 0 */
+			if (iface[i-1] != '\0')
+				printf("+");
+			break;
+		}
+	}
+
+	printf(" ");
+}
+
+/* These are hardcoded backups in iptables.c, so they are safe */
+struct pprot {
+	char *name;
+	u_int8_t num;
+};
+
+/* FIXME: why don't we use /etc/protocols ? */
+static const struct pprot chain_protos[] = {
+	{ "tcp", IPPROTO_TCP },
+	{ "udp", IPPROTO_UDP },
+	{ "icmp", IPPROTO_ICMP },
+	{ "esp", IPPROTO_ESP },
+	{ "ah", IPPROTO_AH },
+	{ "sctp", IPPROTO_SCTP },
+};
+
+static void print_proto(u_int16_t proto, int invert)
+{
+	if (proto) {
+		unsigned int i;
+		const char *invertstr = invert ? "! " : "";
+
+		struct protoent *pent = getprotobynumber(proto);
+		if (pent) {
+			printf("-p %s%s ", invertstr, pent->p_name);
+			return;
+		}
+
+		for (i = 0; i < sizeof(chain_protos)/sizeof(struct pprot); i++)
+			if (chain_protos[i].num == proto) {
+				printf("-p %s%s ",
+				       invertstr, chain_protos[i].name);
+				return;
+			}
+
+		printf("-p %s%u ", invertstr, proto);
+	}
+}
+
+#if 0
+static int non_zero(const void *ptr, size_t size)
+{
+	unsigned int i;
+
+	for (i = 0; i < size; i++)
+		if (((char *)ptr)[i])
+			return 0;
+
+	return 1;
+}
+#endif
+
+static int print_match(const struct ipt_entry_match *e,
+			const struct ipt_ip *ip)
+{
+	struct iptables_match *match
+		= find_match(e->u.user.name, TRY_LOAD, NULL);
+
+	if (match) {
+		printf("-m %s ", e->u.user.name);
+
+		/* some matches don't provide a save function */
+		if (match->save)
+			match->save(ip, e);
+	} else {
+		if (e->u.match_size) {
+			fprintf(stderr,
+				"Can't find library for match `%s'\n",
+				e->u.user.name);
+			exit(1);
+		}
+	}
+	return 0;
+}
+
+/* print a given ip including mask if neccessary */
+static void print_ip(char *prefix, u_int32_t ip, u_int32_t mask, int invert)
+{
+	if (!mask && !ip && !invert)
+		return;
+
+	printf("%s %s%u.%u.%u.%u",
+		prefix,
+		invert ? "! " : "",
+		IP_PARTS(ip));
+
+	if (mask != 0xffffffff) 
+		printf("/%u.%u.%u.%u ", IP_PARTS(mask));
+	else
+		printf(" ");
+}
+
+/* We want this to be readable, so only print out neccessary fields.
+ * Because that's the kind of world I want to live in.  */
+static void print_rule(const struct ipt_entry *e, 
+		iptc_handle_t *h, const char *chain, int counters)
+{
+	struct ipt_entry_target *t;
+	const char *target_name;
+
+	/* print counters */
+	if (counters)
+		printf("[%llu:%llu] ", (unsigned long long)e->counters.pcnt, (unsigned long long)e->counters.bcnt);
+
+	/* print chain name */
+	printf("-A %s ", chain);
+
+	/* Print IP part. */
+	print_ip("-s", e->ip.src.s_addr,e->ip.smsk.s_addr,
+			e->ip.invflags & IPT_INV_SRCIP);	
+
+	print_ip("-d", e->ip.dst.s_addr, e->ip.dmsk.s_addr,
+			e->ip.invflags & IPT_INV_DSTIP);
+
+	print_iface('i', e->ip.iniface, e->ip.iniface_mask,
+		    e->ip.invflags & IPT_INV_VIA_IN);
+
+	print_iface('o', e->ip.outiface, e->ip.outiface_mask,
+		    e->ip.invflags & IPT_INV_VIA_OUT);
+
+	print_proto(e->ip.proto, e->ip.invflags & IPT_INV_PROTO);
+
+	if (e->ip.flags & IPT_F_FRAG)
+		printf("%s-f ",
+		       e->ip.invflags & IPT_INV_FRAG ? "! " : "");
+
+	/* Print matchinfo part */
+	if (e->target_offset) {
+		IPT_MATCH_ITERATE(e, print_match, &e->ip);
+	}
+
+	/* Print target name */	
+	target_name = iptc_get_target(e, h);
+	if (target_name && (*target_name != '\0'))
+#ifdef IPT_F_GOTO
+		printf("-%c %s ", e->ip.flags & IPT_F_GOTO ? 'g' : 'j', target_name);
+#else
+		printf("-j %s ", target_name);
+#endif
+
+	/* Print targinfo part */
+	t = ipt_get_target((struct ipt_entry *)e);
+	if (t->u.user.name[0]) {
+		struct iptables_target *target
+			= find_target(t->u.user.name, TRY_LOAD);
+
+		if (!target) {
+			fprintf(stderr, "Can't find library for target `%s'\n",
+				t->u.user.name);
+			exit(1);
+		}
+
+		if (target->save)
+			target->save(&e->ip, t);
+		else {
+			/* If the target size is greater than ipt_entry_target
+			 * there is something to be saved, we just don't know
+			 * how to print it */
+			if (t->u.target_size != 
+			    sizeof(struct ipt_entry_target)) {
+				fprintf(stderr, "Target `%s' is missing "
+						"save function\n",
+					t->u.user.name);
+				exit(1);
+			}
+		}
+	}
+	printf("\n");
+}
+
+/* Debugging prototype. */
+static int for_each_table(int (*func)(const char *tablename, iptc_handle_t h, int binary, int counters), iptc_handle_t h, int binary, int counters)
+{
+        int ret = 1;
+	FILE *procfile = NULL;
+	char tablename[IPT_TABLE_MAXNAMELEN+1];
+
+	procfile = fopen("/proc/net/ip_tables_names", "r");
+	if (!procfile)
+		return 0;
+
+	while (fgets(tablename, sizeof(tablename), procfile)) {
+		if (tablename[strlen(tablename) - 1] != '\n')
+			exit_error(OTHER_PROBLEM, 
+				   "Badly formed tablename `%s'\n",
+				   tablename);
+		tablename[strlen(tablename) - 1] = '\0';
+		ret &= func(tablename, h, binary, counters);
+	}
+
+	return ret;
+}
+	
+
+int create_dump(const char *tablename, iptc_handle_t h, int binary, int counters)
+{
+	const char *chain = NULL;
+
+	if (!tablename)
+		return for_each_table(&create_dump, NULL, binary, counters);
+
+	if (h == NULL)
+		h = iptc_init(tablename);
+	if (!h)
+ 		exit_error(OTHER_PROBLEM, "Can't initialize: %s\n",
+			   iptc_strerror(errno));
+
+	if (!binary) {
+		time_t now = time(NULL);
+
+		printf("# Generated by iptables-save v%s on %s",
+		       IPTABLES_VERSION, ctime(&now));
+		printf("*%s\n", tablename);
+
+		/* Dump out chain names first, 
+		 * thereby preventing dependency conflicts */
+		for (chain = iptc_first_chain(&h);
+		     chain;
+		     chain = iptc_next_chain(&h)) {
+			
+			printf(":%s ", chain);
+			if (iptc_builtin(chain, h)) {
+				struct ipt_counters count;
+				printf("%s ",
+				       iptc_get_policy(chain, &count, &h));
+				printf("[%llu:%llu]\n", (unsigned long long)count.pcnt, (unsigned long long)count.bcnt);
+			} else {
+				printf("- [0:0]\n");
+			}
+		}
+				
+
+		for (chain = iptc_first_chain(&h);
+		     chain;
+		     chain = iptc_next_chain(&h)) {
+			const struct ipt_entry *e;
+
+			/* Dump out rules */
+			e = iptc_first_rule(chain, &h);
+			while(e) {
+				print_rule(e, &h, chain, counters);
+				e = iptc_next_rule(e, &h);
+			}
+		}
+
+		now = time(NULL);
+		printf("COMMIT\n");
+		printf("# Completed on %s", ctime(&now));
+	} else {
+		/* Binary, huh?  OK. */
+		exit_error(OTHER_PROBLEM, "Binary NYI\n");
+	}
+
+	iptc_free(&h);
+
+	return 1;
+}
Index: iptables-save.c
===================================================================
--- iptables-save.c.orig
+++ iptables-save.c
@@ -6,18 +6,9 @@
  *
  */
 #include <getopt.h>
-#include <sys/errno.h>
 #include <stdio.h>
-#include <fcntl.h>
 #include <stdlib.h>
-#include <string.h>
-#include <dlfcn.h>
-#include <time.h>
-#include <netdb.h>
-#include "libiptc/libiptc.h"
-#include "iptables.h"
-
-static int binary = 0, counters = 0;
+#include "iptables-dump.h"
 
 static struct option options[] = {
 	{ "binary", 0, 0, 'b' },
@@ -27,302 +18,6 @@
 	{ 0 }
 };
 
-#define IP_PARTS_NATIVE(n)			\
-(unsigned int)((n)>>24)&0xFF,			\
-(unsigned int)((n)>>16)&0xFF,			\
-(unsigned int)((n)>>8)&0xFF,			\
-(unsigned int)((n)&0xFF)
-
-#define IP_PARTS(n) IP_PARTS_NATIVE(ntohl(n))
-
-/* This assumes that mask is contiguous, and byte-bounded. */
-static void
-print_iface(char letter, const char *iface, const unsigned char *mask,
-	    int invert)
-{
-	unsigned int i;
-
-	if (mask[0] == 0)
-		return;
-
-	printf("-%c %s", letter, invert ? "! " : "");
-
-	for (i = 0; i < IFNAMSIZ; i++) {
-		if (mask[i] != 0) {
-			if (iface[i] != '\0')
-				printf("%c", iface[i]);
-		} else {
-			/* we can access iface[i-1] here, because 
-			 * a few lines above we make sure that mask[0] != 0 */
-			if (iface[i-1] != '\0')
-				printf("+");
-			break;
-		}
-	}
-
-	printf(" ");
-}
-
-/* These are hardcoded backups in iptables.c, so they are safe */
-struct pprot {
-	char *name;
-	u_int8_t num;
-};
-
-/* FIXME: why don't we use /etc/protocols ? */
-static const struct pprot chain_protos[] = {
-	{ "tcp", IPPROTO_TCP },
-	{ "udp", IPPROTO_UDP },
-	{ "icmp", IPPROTO_ICMP },
-	{ "esp", IPPROTO_ESP },
-	{ "ah", IPPROTO_AH },
-	{ "sctp", IPPROTO_SCTP },
-};
-
-static void print_proto(u_int16_t proto, int invert)
-{
-	if (proto) {
-		unsigned int i;
-		const char *invertstr = invert ? "! " : "";
-
-		struct protoent *pent = getprotobynumber(proto);
-		if (pent) {
-			printf("-p %s%s ", invertstr, pent->p_name);
-			return;
-		}
-
-		for (i = 0; i < sizeof(chain_protos)/sizeof(struct pprot); i++)
-			if (chain_protos[i].num == proto) {
-				printf("-p %s%s ",
-				       invertstr, chain_protos[i].name);
-				return;
-			}
-
-		printf("-p %s%u ", invertstr, proto);
-	}
-}
-
-#if 0
-static int non_zero(const void *ptr, size_t size)
-{
-	unsigned int i;
-
-	for (i = 0; i < size; i++)
-		if (((char *)ptr)[i])
-			return 0;
-
-	return 1;
-}
-#endif
-
-static int print_match(const struct ipt_entry_match *e,
-			const struct ipt_ip *ip)
-{
-	struct iptables_match *match
-		= find_match(e->u.user.name, TRY_LOAD, NULL);
-
-	if (match) {
-		printf("-m %s ", e->u.user.name);
-
-		/* some matches don't provide a save function */
-		if (match->save)
-			match->save(ip, e);
-	} else {
-		if (e->u.match_size) {
-			fprintf(stderr,
-				"Can't find library for match `%s'\n",
-				e->u.user.name);
-			exit(1);
-		}
-	}
-	return 0;
-}
-
-/* print a given ip including mask if neccessary */
-static void print_ip(char *prefix, u_int32_t ip, u_int32_t mask, int invert)
-{
-	if (!mask && !ip && !invert)
-		return;
-
-	printf("%s %s%u.%u.%u.%u",
-		prefix,
-		invert ? "! " : "",
-		IP_PARTS(ip));
-
-	if (mask != 0xffffffff) 
-		printf("/%u.%u.%u.%u ", IP_PARTS(mask));
-	else
-		printf(" ");
-}
-
-/* We want this to be readable, so only print out neccessary fields.
- * Because that's the kind of world I want to live in.  */
-static void print_rule(const struct ipt_entry *e, 
-		iptc_handle_t *h, const char *chain, int counters)
-{
-	struct ipt_entry_target *t;
-	const char *target_name;
-
-	/* print counters */
-	if (counters)
-		printf("[%llu:%llu] ", (unsigned long long)e->counters.pcnt, (unsigned long long)e->counters.bcnt);
-
-	/* print chain name */
-	printf("-A %s ", chain);
-
-	/* Print IP part. */
-	print_ip("-s", e->ip.src.s_addr,e->ip.smsk.s_addr,
-			e->ip.invflags & IPT_INV_SRCIP);	
-
-	print_ip("-d", e->ip.dst.s_addr, e->ip.dmsk.s_addr,
-			e->ip.invflags & IPT_INV_DSTIP);
-
-	print_iface('i', e->ip.iniface, e->ip.iniface_mask,
-		    e->ip.invflags & IPT_INV_VIA_IN);
-
-	print_iface('o', e->ip.outiface, e->ip.outiface_mask,
-		    e->ip.invflags & IPT_INV_VIA_OUT);
-
-	print_proto(e->ip.proto, e->ip.invflags & IPT_INV_PROTO);
-
-	if (e->ip.flags & IPT_F_FRAG)
-		printf("%s-f ",
-		       e->ip.invflags & IPT_INV_FRAG ? "! " : "");
-
-	/* Print matchinfo part */
-	if (e->target_offset) {
-		IPT_MATCH_ITERATE(e, print_match, &e->ip);
-	}
-
-	/* Print target name */	
-	target_name = iptc_get_target(e, h);
-	if (target_name && (*target_name != '\0'))
-#ifdef IPT_F_GOTO
-		printf("-%c %s ", e->ip.flags & IPT_F_GOTO ? 'g' : 'j', target_name);
-#else
-		printf("-j %s ", target_name);
-#endif
-
-	/* Print targinfo part */
-	t = ipt_get_target((struct ipt_entry *)e);
-	if (t->u.user.name[0]) {
-		struct iptables_target *target
-			= find_target(t->u.user.name, TRY_LOAD);
-
-		if (!target) {
-			fprintf(stderr, "Can't find library for target `%s'\n",
-				t->u.user.name);
-			exit(1);
-		}
-
-		if (target->save)
-			target->save(&e->ip, t);
-		else {
-			/* If the target size is greater than ipt_entry_target
-			 * there is something to be saved, we just don't know
-			 * how to print it */
-			if (t->u.target_size != 
-			    sizeof(struct ipt_entry_target)) {
-				fprintf(stderr, "Target `%s' is missing "
-						"save function\n",
-					t->u.user.name);
-				exit(1);
-			}
-		}
-	}
-	printf("\n");
-}
-
-/* Debugging prototype. */
-static int for_each_table(int (*func)(const char *tablename))
-{
-        int ret = 1;
-	FILE *procfile = NULL;
-	char tablename[IPT_TABLE_MAXNAMELEN+1];
-
-	procfile = fopen("/proc/net/ip_tables_names", "r");
-	if (!procfile)
-		exit_error(OTHER_PROBLEM,
-			   "Unable to open /proc/net/ip_tables_names: %s\n",
-			   strerror(errno));
-
-	while (fgets(tablename, sizeof(tablename), procfile)) {
-		if (tablename[strlen(tablename) - 1] != '\n')
-			exit_error(OTHER_PROBLEM, 
-				   "Badly formed tablename `%s'\n",
-				   tablename);
-		tablename[strlen(tablename) - 1] = '\0';
-		ret &= func(tablename);
-	}
-
-	return ret;
-}
-	
-
-static int do_output(const char *tablename)
-{
-	iptc_handle_t h;
-	const char *chain = NULL;
-
-	if (!tablename)
-		return for_each_table(&do_output);
-
-	h = iptc_init(tablename);
-	if (!h)
- 		exit_error(OTHER_PROBLEM, "Can't initialize: %s\n",
-			   iptc_strerror(errno));
-
-	if (!binary) {
-		time_t now = time(NULL);
-
-		printf("# Generated by iptables-save v%s on %s",
-		       IPTABLES_VERSION, ctime(&now));
-		printf("*%s\n", tablename);
-
-		/* Dump out chain names first, 
-		 * thereby preventing dependency conflicts */
-		for (chain = iptc_first_chain(&h);
-		     chain;
-		     chain = iptc_next_chain(&h)) {
-			
-			printf(":%s ", chain);
-			if (iptc_builtin(chain, h)) {
-				struct ipt_counters count;
-				printf("%s ",
-				       iptc_get_policy(chain, &count, &h));
-				printf("[%llu:%llu]\n", (unsigned long long)count.pcnt, (unsigned long long)count.bcnt);
-			} else {
-				printf("- [0:0]\n");
-			}
-		}
-				
-
-		for (chain = iptc_first_chain(&h);
-		     chain;
-		     chain = iptc_next_chain(&h)) {
-			const struct ipt_entry *e;
-
-			/* Dump out rules */
-			e = iptc_first_rule(chain, &h);
-			while(e) {
-				print_rule(e, &h, chain, counters);
-				e = iptc_next_rule(e, &h);
-			}
-		}
-
-		now = time(NULL);
-		printf("COMMIT\n");
-		printf("# Completed on %s", ctime(&now));
-	} else {
-		/* Binary, huh?  OK. */
-		exit_error(OTHER_PROBLEM, "Binary NYI\n");
-	}
-
-	iptc_free(&h);
-
-	return 1;
-}
-
 /* Format:
  * :Chain name POLICY packets bytes
  * rule
@@ -336,6 +31,7 @@
 #endif
 {
 	const char *tablename = NULL;
+	int binary = 0, counters = 0;
 	int c;
 
 	program_name = "iptables-save";
@@ -364,7 +60,7 @@
 			tablename = optarg;
 			break;
 		case 'd':
-			do_output(tablename);
+			create_dump(tablename, NULL, binary, counters);
 			exit(0);
 		}
 	}
@@ -374,5 +70,5 @@
 		exit(1);
 	}
 
-	return !do_output(tablename);
+	return create_dump(tablename, NULL, binary, counters);
 }
Index: Makefile
===================================================================
--- Makefile.orig
+++ Makefile
@@ -105,8 +105,11 @@
 iptables.o: iptables.c
 	$(CC) $(CFLAGS) -DIPT_LIB_DIR=\"$(IPT_LIBDIR)\" -c -o $@ $<
 
+iptables-dump.o: iptables-dump.c include/iptables-dump.h
+	$(CC) $(CFLAGS) -DIPT_LIB_DIR=\"$(IPT_LIBDIR)\" -c -o $@ $<
+
 ifeq ($(DO_MULTI), 1)
-iptables: iptables-multi.c iptables-save.c iptables-restore.c iptables-xml.c iptables-standalone.c iptables.o xtables.o $(STATIC_LIBS) libiptc/libiptc.a
+iptables: iptables-multi.c iptables-save.c iptables-restore.c iptables-xml.c iptables-standalone.c iptables.o xtables.o iptables-dump.o $(STATIC_LIBS) libiptc/libiptc.a
 	$(CC) $(CFLAGS) -DIPTABLES_MULTI -DIPT_LIB_DIR=\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(LDLIBS)
 else
 iptables: iptables-standalone.c iptables.o xtables.o $(STATIC_LIBS) libiptc/libiptc.a
@@ -117,7 +120,7 @@
 	@[ -d $(DESTDIR)$(BINDIR) ] || mkdir -p $(DESTDIR)$(BINDIR)
 	cp $< $@
 
-iptables-save: iptables-save.c iptables.o xtables.o $(STATIC_LIBS) libiptc/libiptc.a
+iptables-save: iptables-save.c iptables.o xtables.o iptables-dump.o $(STATIC_LIBS) libiptc/libiptc.a
 	$(CC) $(CFLAGS) -DIPT_LIB_DIR=\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(LDLIBS)
 
 ifeq ($(DO_MULTI), 1)
@@ -130,7 +133,7 @@
 	cp $< $@
 endif
 
-iptables-restore: iptables-restore.c iptables.o xtables.o $(STATIC_LIBS) libiptc/libiptc.a
+iptables-restore: iptables-restore.c iptables.o xtables.o iptables-dump.o $(STATIC_LIBS) libiptc/libiptc.a
 	$(CC) $(CFLAGS) -DIPT_LIB_DIR=\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(LDLIBS)
 
 ifeq ($(DO_MULTI), 1)

--------------060807040805000309050802
Content-Type: text/x-vcard; charset=utf-8;
 name="peter.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="peter.vcf"

begin:vcard
fn:Peter Warasin
n:;Peter Warasin
org:Endian GmbH/Srl
adr:;;Pillhof 47;Frangart/Frangarto;BZ;I-39010;Italien/Italia
email;internet:peter@endian.com
tel;work:+39 0471 631763
tel;fax:+39 0471 631764
x-mozilla-html:FALSE
url:http://www.endian.com
version:2.1
end:vcard


--------------060807040805000309050802--
