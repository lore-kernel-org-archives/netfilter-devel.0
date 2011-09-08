From: Hiroshi KIHIRA <hiro@dump-Storage.net>
Subject: [PATCH RFC] iptables-restore: new option to change the commit timing
Date: Thu, 08 Sep 2011 22:28:52 +0900
Message-ID: <4E68C314.3070709@dump-Storage.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vs-saku1.dump-storage.net ([49.212.16.99]:56036 "EHLO
	VS-SAKU1.dump-Storage.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932789Ab1IHNjL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Sep 2011 09:39:11 -0400
Received: from [10.17.2.1] (p1065-ipbf1804marunouchi.tokyo.ocn.ne.jp [122.16.120.65])
	by VS-SAKU1.dump-Storage.net (Postfix) with ESMTPS id 5A3EC63A68
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Sep 2011 22:28:50 +0900 (JST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I propose to add a new command line option to iptables-restore.
The following patch introduces a new command line option which changes
the timing of the action of table commitment.

In the situation that some tables are restored, each of tables are
applied into the kernel space when the COMMIT statement was read from
the input. If there was a syntax error in rules, iptables-restore
will end without doing any modification to the table. However the
table that was already committed into kernel space does not reverted.
It causes a inconsistency between the tables. (e.g., some marked
packets are dropped at filter table, but do not marked any packet at
mangle table)

If the new command line option in this patch is used, tables that are
modified in the user space do not applied into the kernel space at the
timing of COMMIT statement. All handles are committed into the kernel
space after reading the input.

thanks,
Hiroshi KIHIRA


Signed-off-by: Hiroshi KIHIRA <hiro@dump-Storage.net>
---
 iptables/iptables-restore.c |  108 ++++++++++++++++++++++++++++++++++--------
 1 files changed, 87 insertions(+), 21 deletions(-)

diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index d0bd79a..9df66e6 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -28,6 +28,7 @@ static int binary = 0, counters = 0, verbose = 0, noflush = 0;
 static const struct option options[] = {
 	{.name = "binary",   .has_arg = false, .val = 'b'},
 	{.name = "counters", .has_arg = false, .val = 'c'},
+	{.name = "delay",    .has_arg = false, .val = 'd'},
 	{.name = "verbose",  .has_arg = false, .val = 'v'},
 	{.name = "test",     .has_arg = false, .val = 't'},
 	{.name = "help",     .has_arg = false, .val = 'h'},
@@ -37,15 +38,24 @@ static const struct option options[] = {
 	{NULL},
 };

+/* Table handle list */
+struct table_list {
+	char name[IPT_TABLE_MAXNAMELEN + 1];
+	struct iptc_handle *handle;
+	int committed;
+	struct table_list *next;
+};
+
 static void print_usage(const char *name, const char *version) __attribute__((noreturn));

 #define prog_name iptables_globals.program_name

 static void print_usage(const char *name, const char *version)
 {
-	fprintf(stderr, "Usage: %s [-b] [-c] [-v] [-t] [-h]\n"
+	fprintf(stderr, "Usage: %s [-b] [-c] [-d] [-v] [-t] [-h]\n"
 			"	   [ --binary ]\n"
 			"	   [ --counters ]\n"
+			"	   [ --delay ]\n"
 			"	   [ --verbose ]\n"
 			"	   [ --test ]\n"
 			"	   [ --help ]\n"
@@ -116,15 +126,20 @@ static void free_argv(void) {
 int
 iptables_restore_main(int argc, char *argv[])
 {
-	struct iptc_handle *handle = NULL;
+	struct table_list tablelist;
+	struct table_list *list_cur = NULL;
+	struct table_list *list_head = NULL;
 	char buffer[10240];
 	int c;
 	char curtable[IPT_TABLE_MAXNAMELEN + 1];
 	FILE *in;
-	int in_table = 0, testing = 0;
+	int in_table = 0, testing = 0, delaycommit = 0;
 	const char *tablename = NULL;

 	line = 0;
+	memset(&tablelist, 0, sizeof(struct table_list));
+	list_cur = &tablelist;
+	list_head = &tablelist;

 	iptables_globals.program_name = "iptables-restore";
 	c = xtables_init_all(&iptables_globals, NFPROTO_IPV4);
@@ -139,7 +154,7 @@ iptables_restore_main(int argc, char *argv[])
 	init_extensions4();
 #endif

-	while ((c = getopt_long(argc, argv, "bcvthnM:T:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "bcdvthnM:T:", options, NULL)) != -1) {
 		switch (c) {
 			case 'b':
 				binary = 1;
@@ -147,6 +162,9 @@ iptables_restore_main(int argc, char *argv[])
 			case 'c':
 				counters = 1;
 				break;
+			case 'd':
+				delaycommit = 1;
+				break;
 			case 'v':
 				verbose = 1;
 				break;
@@ -195,13 +213,25 @@ iptables_restore_main(int argc, char *argv[])
 				fputs(buffer, stdout);
 			continue;
 		} else if ((strcmp(buffer, "COMMIT\n") == 0) && (in_table)) {
-			if (!testing) {
-				DEBUGP("Calling commit\n");
-				ret = iptc_commit(handle);
-				iptc_free(handle);
-				handle = NULL;
+			if (!delaycommit) {
+				if (!testing) {
+					DEBUGP("Calling commit\n");
+					ret = iptc_commit(list_cur->handle);
+					iptc_free(list_cur->handle);
+					list_cur->handle = NULL;
+				} else {
+					DEBUGP("Not calling commit, testing\n");
+					ret = 1;
+				}
 			} else {
-				DEBUGP("Not calling commit, testing\n");
+				/* Delay commit, Set flag only */
+				if (!testing) {
+					DEBUGP("Set Commit flag\n");
+					list_cur->committed = 1;
+				} else {
+					DEBUGP("Set Commit flag, Testing\n");
+					list_cur->committed = 1;
+				}
 				ret = 1;
 			}
 			in_table = 0;
@@ -222,20 +252,31 @@ iptables_restore_main(int argc, char *argv[])

 			if (tablename && (strcmp(tablename, table) != 0))
 				continue;
-			if (handle)
-				iptc_free(handle);
+			if (delaycommit && list_cur->handle) {
+				list_cur->next = malloc(sizeof(struct table_list));
+				if (list_cur->next == NULL) {
+					xtables_error(OTHER_PROBLEM, "malloc failed.\n");
+					exit(1);
+				}
+				memset(list_cur->next, 0, sizeof(struct table_list));
+				list_cur = list_cur->next;
+			}
+			strncpy(list_cur->name, table, IPT_TABLE_MAXNAMELEN);
+			list_cur->name[IPT_TABLE_MAXNAMELEN] = '\0';
+			if (list_cur->handle)
+				iptc_free(list_cur->handle);

-			handle = create_handle(table);
+			list_cur->handle = create_handle(table);
 			if (noflush == 0) {
 				DEBUGP("Cleaning all chains of table '%s'\n",
 					table);
 				for_each_chain4(flush_entries4, verbose, 1,
-						handle);
+						list_cur->handle);

 				DEBUGP("Deleting all user-defined chains "
 				       "of table '%s'\n", table);
 				for_each_chain4(delete_chain4, verbose, 0,
-						handle);
+						list_cur->handle);
 			}

 			ret = 1;
@@ -260,17 +301,17 @@ iptables_restore_main(int argc, char *argv[])
 					   "(%u chars max)",
 					   chain, XT_EXTENSION_MAXNAMELEN - 1);

-			if (iptc_builtin(chain, handle) <= 0) {
-				if (noflush && iptc_is_chain(chain, handle)) {
+			if (iptc_builtin(chain, list_cur->handle) <= 0) {
+				if (noflush && iptc_is_chain(chain, list_cur->handle)) {
 					DEBUGP("Flushing existing user defined chain '%s'\n", chain);
-					if (!iptc_flush_entries(chain, handle))
+					if (!iptc_flush_entries(chain, list_cur->handle))
 						xtables_error(PARAMETER_PROBLEM,
 							   "error flushing chain "
 							   "'%s':%s\n", chain,
 							   strerror(errno));
 				} else {
 					DEBUGP("Creating new chain '%s'\n", chain);
-					if (!iptc_create_chain(chain, handle))
+					if (!iptc_create_chain(chain, list_cur->handle))
 						xtables_error(PARAMETER_PROBLEM,
 							   "error creating chain "
 							   "'%s':%s\n", chain,
@@ -308,7 +349,7 @@ iptables_restore_main(int argc, char *argv[])
 					chain, policy);

 				if (!iptc_set_policy(chain, policy, &count,
-						     handle))
+						     list_cur->handle))
 					xtables_error(OTHER_PROBLEM,
 						"Can't set policy `%s'"
 						" on `%s' line %u: %s\n",
@@ -441,7 +482,7 @@ iptables_restore_main(int argc, char *argv[])
 				DEBUGP("argv[%u]: %s\n", a, newargv[a]);

 			ret = do_command4(newargc, newargv,
-					 &newargv[2], &handle);
+					 &newargv[2], &list_cur->handle);

 			free_argv();
 			fflush(stdout);
@@ -459,6 +500,31 @@ iptables_restore_main(int argc, char *argv[])
 				prog_name, line + 1);
 		exit(1);
 	}
+	if (delaycommit) {
+		if (!testing) {
+			/* Call commit */
+			list_cur = list_head;
+			while(list_cur) {
+				DEBUGP("calling commit(%s)\n", list_cur->name);
+				if (iptc_commit(list_cur->handle)) {
+					iptc_free(list_cur->handle);
+					list_cur->handle = NULL;
+				} else {
+					fprintf(stderr, "%s: COMMIT failed: %s",
+					        prog_name, list_cur->name);
+					exit(1);
+				}
+				list_cur = list_cur->next;
+			}
+		}
+		
+		list_cur = list_head = list_head->next;
+		while(list_cur) {
+			list_head = list_head->next;
+			free(list_cur);
+			list_cur = list_head;
+		}
+	}

 	fclose(in);
 	return 0;
-- 
1.7.6

