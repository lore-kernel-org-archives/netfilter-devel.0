From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] ip{6}tables-restore: fix breakage due to new locking approach
Date: Mon,  8 Jul 2013 19:44:21 +0200
Message-ID: <1373305461-17223-1-git-send-email-pablo@netfilter.org>
Cc: Phil Oester <kernel@linuxace.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53361 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab3GHRoi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Jul 2013 13:44:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since (93587a0 ip[6]tables: Add locking to prevent concurrent instances),
ip{6}tables-restore does not work anymore:

iptables-restore < x
Another app is currently holding the xtables lock. Perhaps you want to use the -w option?

do_command{6}(...) is called from ip{6}tables-restore for every iptables
command contained in the rule-set file. Thus, hitting the lock error
after the second command.

Fix it by bypassing the locking in the ip{6}tables-restore path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/ip6tables.h             |    2 +-
 include/iptables.h              |    2 +-
 iptables/ip6tables-restore.c    |    2 +-
 iptables/ip6tables-standalone.c |    2 +-
 iptables/ip6tables.c            |   10 ++++++++--
 iptables/iptables-restore.c     |    2 +-
 iptables/iptables-standalone.c  |    2 +-
 iptables/iptables.c             |   10 ++++++++--
 8 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/include/ip6tables.h b/include/ip6tables.h
index 37d2e0a..5f1c5b6 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -8,7 +8,7 @@
 
 /* Your shared library should call one of these. */
 extern int do_command6(int argc, char *argv[], char **table,
-		       struct xtc_handle **handle);
+		       struct xtc_handle **handle, bool restore);
 
 extern int for_each_chain6(int (*fn)(const xt_chainlabel, int, struct xtc_handle *), int verbose, int builtinstoo, struct xtc_handle *handle);
 extern int flush_entries6(const xt_chainlabel chain, int verbose, struct xtc_handle *handle);
diff --git a/include/iptables.h b/include/iptables.h
index c42613c..ac9dc0e 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -8,7 +8,7 @@
 
 /* Your shared library should call one of these. */
 extern int do_command4(int argc, char *argv[], char **table,
-		      struct xtc_handle **handle);
+		      struct xtc_handle **handle, bool restore);
 extern int delete_chain4(const xt_chainlabel chain, int verbose,
 			struct xtc_handle *handle);
 extern int flush_entries4(const xt_chainlabel chain, int verbose, 
diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index 0e8252f..b8b9e0d 100644
--- a/iptables/ip6tables-restore.c
+++ b/iptables/ip6tables-restore.c
@@ -438,7 +438,7 @@ int ip6tables_restore_main(int argc, char *argv[])
 				DEBUGP("argv[%u]: %s\n", a, newargv[a]);
 
 			ret = do_command6(newargc, newargv,
-					 &newargv[2], &handle);
+					 &newargv[2], &handle, true);
 
 			free_argv();
 			fflush(stdout);
diff --git a/iptables/ip6tables-standalone.c b/iptables/ip6tables-standalone.c
index 21b5811..656e08d 100644
--- a/iptables/ip6tables-standalone.c
+++ b/iptables/ip6tables-standalone.c
@@ -58,7 +58,7 @@ ip6tables_main(int argc, char *argv[])
 	init_extensions6();
 #endif
 
-	ret = do_command6(argc, argv, &table, &handle);
+	ret = do_command6(argc, argv, &table, &handle, false);
 	if (ret) {
 		ret = ip6tc_commit(handle);
 		ip6tc_free(handle);
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index eededee..1fb33f6 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1286,7 +1286,8 @@ static void command_match(struct iptables_command_state *cs)
 					     m->extra_opts, &m->option_offset);
 }
 
-int do_command6(int argc, char *argv[], char **table, struct xtc_handle **handle)
+int do_command6(int argc, char *argv[], char **table,
+		struct xtc_handle **handle, bool restore)
 {
 	struct iptables_command_state cs;
 	struct ip6t_entry *e = NULL;
@@ -1577,6 +1578,11 @@ int do_command6(int argc, char *argv[], char **table, struct xtc_handle **handle
 			break;
 
 		case 'w':
+			if (restore) {
+				xtables_error(PARAMETER_PROBLEM,
+					      "You cannot use `-w' from "
+					      "ip6tables-restore");
+			}
 			wait = true;
 			break;
 
@@ -1732,7 +1738,7 @@ int do_command6(int argc, char *argv[], char **table, struct xtc_handle **handle
 			   chain, XT_EXTENSION_MAXNAMELEN);
 
 	/* Attempt to acquire the xtables lock */
-	if (!xtables_lock(wait)) {
+	if (!restore && !xtables_lock(wait)) {
 		fprintf(stderr, "Another app is currently holding the xtables lock. "
 			"Perhaps you want to use the -w option?\n");
 		xtables_free_opts(1);
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 0822513..8c942ff 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -438,7 +438,7 @@ iptables_restore_main(int argc, char *argv[])
 				DEBUGP("argv[%u]: %s\n", a, newargv[a]);
 
 			ret = do_command4(newargc, newargv,
-					 &newargv[2], &handle);
+					 &newargv[2], &handle, true);
 
 			free_argv();
 			fflush(stdout);
diff --git a/iptables/iptables-standalone.c b/iptables/iptables-standalone.c
index 683a44a..4da1d7f 100644
--- a/iptables/iptables-standalone.c
+++ b/iptables/iptables-standalone.c
@@ -58,7 +58,7 @@ iptables_main(int argc, char *argv[])
 	init_extensions4();
 #endif
 
-	ret = do_command4(argc, argv, &table, &handle);
+	ret = do_command4(argc, argv, &table, &handle, false);
 	if (ret) {
 		ret = iptc_commit(handle);
 		iptc_free(handle);
diff --git a/iptables/iptables.c b/iptables/iptables.c
index f857beb..fe18e1c 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -1282,7 +1282,8 @@ static void command_match(struct iptables_command_state *cs)
 		xtables_error(OTHER_PROBLEM, "can't alloc memory!");
 }
 
-int do_command4(int argc, char *argv[], char **table, struct xtc_handle **handle)
+int do_command4(int argc, char *argv[], char **table,
+		struct xtc_handle **handle, bool restore)
 {
 	struct iptables_command_state cs;
 	struct ipt_entry *e = NULL;
@@ -1571,6 +1572,11 @@ int do_command4(int argc, char *argv[], char **table, struct xtc_handle **handle
 			break;
 
 		case 'w':
+			if (restore) {
+				xtables_error(PARAMETER_PROBLEM,
+					      "You cannot use `-w' from "
+					      "iptables-restore");
+			}
 			wait = true;
 			break;
 
@@ -1729,7 +1735,7 @@ int do_command4(int argc, char *argv[], char **table, struct xtc_handle **handle
 			   chain, XT_EXTENSION_MAXNAMELEN);
 
 	/* Attempt to acquire the xtables lock */
-	if (!xtables_lock(wait)) {
+	if (!restore && !xtables_lock(wait)) {
 		fprintf(stderr, "Another app is currently holding the xtables lock. "
 			"Perhaps you want to use the -w option?\n");
 		xtables_free_opts(1);
-- 
1.7.10.4

