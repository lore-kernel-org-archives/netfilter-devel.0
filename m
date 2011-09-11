From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 9/9] ip6tables-restore: make code look alike with iptables-restore
Date: Sun, 11 Sep 2011 17:35:58 +0200
Message-ID: <1315755359-7012-10-git-send-email-jengelh@medozas.de>
References: <1315755359-7012-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:51859 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843Ab1IKPgM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Sep 2011 11:36:12 -0400
In-Reply-To: <1315755359-7012-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 iptables/ip6tables-restore.c |   34 +++++++++++++++-------------------
 iptables/iptables-restore.c  |   29 +++++++++++++++--------------
 2 files changed, 30 insertions(+), 33 deletions(-)

diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index 073e42b..92bdc30 100644
--- a/iptables/ip6tables-restore.c
+++ b/iptables/ip6tables-restore.c
@@ -123,6 +123,7 @@ int ip6tables_restore_main(int argc, char *argv[])
 	FILE *in;
 	int in_table = 0, testing = 0;
 	const char *tablename = NULL;
+	const struct xtc_ops *ops = &ip6tc_ops;
 
 	line = 0;
 
@@ -197,8 +198,8 @@ int ip6tables_restore_main(int argc, char *argv[])
 		} else if ((strcmp(buffer, "COMMIT\n") == 0) && (in_table)) {
 			if (!testing) {
 				DEBUGP("Calling commit\n");
-				ret = ip6tc_commit(handle);
-				ip6tc_free(handle);
+				ret = ops->commit(handle);
+				ops->free(handle);
 				handle = NULL;
 			} else {
 				DEBUGP("Not calling commit, testing\n");
@@ -214,8 +215,7 @@ int ip6tables_restore_main(int argc, char *argv[])
 			if (!table) {
 				xtables_error(PARAMETER_PROBLEM,
 					"%s: line %u table name invalid\n",
-					ip6tables_globals.program_name,
-					line);
+					xt_params->program_name, line);
 				exit(1);
 			}
 			strncpy(curtable, table, XT_TABLE_MAXNAMELEN);
@@ -224,7 +224,7 @@ int ip6tables_restore_main(int argc, char *argv[])
 			if (tablename != NULL && strcmp(tablename, table) != 0)
 				continue;
 			if (handle)
-				ip6tc_free(handle);
+				ops->free(handle);
 
 			handle = create_handle(table);
 			if (noflush == 0) {
@@ -251,8 +251,7 @@ int ip6tables_restore_main(int argc, char *argv[])
 			if (!chain) {
 				xtables_error(PARAMETER_PROBLEM,
 					   "%s: line %u chain name invalid\n",
-					   ip6tables_globals.program_name,
-					   line);
+					   xt_params->program_name, line);
 				exit(1);
 			}
 
@@ -262,17 +261,17 @@ int ip6tables_restore_main(int argc, char *argv[])
 					   "(%u chars max)",
 					   chain, XT_EXTENSION_MAXNAMELEN - 1);
 
-			if (ip6tc_builtin(chain, handle) <= 0) {
-				if (noflush && ip6tc_is_chain(chain, handle)) {
+			if (ops->builtin(chain, handle) <= 0) {
+				if (noflush && ops->is_chain(chain, handle)) {
 					DEBUGP("Flushing existing user defined chain '%s'\n", chain);
-					if (!ip6tc_flush_entries(chain, handle))
+					if (!ops->flush_entries(chain, handle))
 						xtables_error(PARAMETER_PROBLEM,
 							   "error flushing chain "
 							   "'%s':%s\n", chain,
 							   strerror(errno));
 				} else {
 					DEBUGP("Creating new chain '%s'\n", chain);
-					if (!ip6tc_create_chain(chain, handle))
+					if (!ops->create_chain(chain, handle))
 						xtables_error(PARAMETER_PROBLEM,
 							   "error creating chain "
 							   "'%s':%s\n", chain,
@@ -285,8 +284,7 @@ int ip6tables_restore_main(int argc, char *argv[])
 			if (!policy) {
 				xtables_error(PARAMETER_PROBLEM,
 					   "%s: line %u policy invalid\n",
-					   ip6tables_globals.program_name,
-					   line);
+					   xt_params->program_name, line);
 				exit(1);
 			}
 
@@ -309,13 +307,13 @@ int ip6tables_restore_main(int argc, char *argv[])
 				DEBUGP("Setting policy of chain %s to %s\n",
 					chain, policy);
 
-				if (!ip6tc_set_policy(chain, policy, &count,
+				if (!ops->set_policy(chain, policy, &count,
 						     handle))
 					xtables_error(OTHER_PROBLEM,
 						"Can't set policy `%s'"
 						" on `%s' line %u: %s\n",
 						policy, chain, line,
-						ip6tc_strerror(errno));
+						ops->strerror(errno));
 			}
 
 			ret = 1;
@@ -452,15 +450,13 @@ int ip6tables_restore_main(int argc, char *argv[])
 			continue;
 		if (!ret) {
 			fprintf(stderr, "%s: line %u failed\n",
-					ip6tables_globals.program_name,
-					line);
+					xt_params->program_name, line);
 			exit(1);
 		}
 	}
 	if (in_table) {
 		fprintf(stderr, "%s: COMMIT expected at line %u\n",
-				ip6tables_globals.program_name,
-				line + 1);
+				xt_params->program_name, line + 1);
 		exit(1);
 	}
 
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 001da73..6b1c792 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -123,6 +123,7 @@ iptables_restore_main(int argc, char *argv[])
 	FILE *in;
 	int in_table = 0, testing = 0;
 	const char *tablename = NULL;
+	const struct xtc_ops *ops = &iptc_ops;
 
 	line = 0;
 
@@ -197,8 +198,8 @@ iptables_restore_main(int argc, char *argv[])
 		} else if ((strcmp(buffer, "COMMIT\n") == 0) && (in_table)) {
 			if (!testing) {
 				DEBUGP("Calling commit\n");
-				ret = iptc_commit(handle);
-				iptc_free(handle);
+				ret = ops->commit(handle);
+				ops->free(handle);
 				handle = NULL;
 			} else {
 				DEBUGP("Not calling commit, testing\n");
@@ -214,7 +215,7 @@ iptables_restore_main(int argc, char *argv[])
 			if (!table) {
 				xtables_error(PARAMETER_PROBLEM,
 					"%s: line %u table name invalid\n",
-					prog_name, line);
+					xt_params->program_name, line);
 				exit(1);
 			}
 			strncpy(curtable, table, XT_TABLE_MAXNAMELEN);
@@ -223,7 +224,7 @@ iptables_restore_main(int argc, char *argv[])
 			if (tablename && (strcmp(tablename, table) != 0))
 				continue;
 			if (handle)
-				iptc_free(handle);
+				ops->free(handle);
 
 			handle = create_handle(table);
 			if (noflush == 0) {
@@ -250,7 +251,7 @@ iptables_restore_main(int argc, char *argv[])
 			if (!chain) {
 				xtables_error(PARAMETER_PROBLEM,
 					   "%s: line %u chain name invalid\n",
-					   prog_name, line);
+					   xt_params->program_name, line);
 				exit(1);
 			}
 
@@ -260,17 +261,17 @@ iptables_restore_main(int argc, char *argv[])
 					   "(%u chars max)",
 					   chain, XT_EXTENSION_MAXNAMELEN - 1);
 
-			if (iptc_builtin(chain, handle) <= 0) {
-				if (noflush && iptc_is_chain(chain, handle)) {
+			if (ops->builtin(chain, handle) <= 0) {
+				if (noflush && ops->is_chain(chain, handle)) {
 					DEBUGP("Flushing existing user defined chain '%s'\n", chain);
-					if (!iptc_flush_entries(chain, handle))
+					if (!ops->flush_entries(chain, handle))
 						xtables_error(PARAMETER_PROBLEM,
 							   "error flushing chain "
 							   "'%s':%s\n", chain,
 							   strerror(errno));
 				} else {
 					DEBUGP("Creating new chain '%s'\n", chain);
-					if (!iptc_create_chain(chain, handle))
+					if (!ops->create_chain(chain, handle))
 						xtables_error(PARAMETER_PROBLEM,
 							   "error creating chain "
 							   "'%s':%s\n", chain,
@@ -283,7 +284,7 @@ iptables_restore_main(int argc, char *argv[])
 			if (!policy) {
 				xtables_error(PARAMETER_PROBLEM,
 					   "%s: line %u policy invalid\n",
-					   prog_name, line);
+					   xt_params->program_name, line);
 				exit(1);
 			}
 
@@ -306,13 +307,13 @@ iptables_restore_main(int argc, char *argv[])
 				DEBUGP("Setting policy of chain %s to %s\n",
 					chain, policy);
 
-				if (!iptc_set_policy(chain, policy, &count,
+				if (!ops->set_policy(chain, policy, &count,
 						     handle))
 					xtables_error(OTHER_PROBLEM,
 						"Can't set policy `%s'"
 						" on `%s' line %u: %s\n",
 						policy, chain, line,
-						iptc_strerror(errno));
+						ops->strerror(errno));
 			}
 
 			ret = 1;
@@ -449,13 +450,13 @@ iptables_restore_main(int argc, char *argv[])
 			continue;
 		if (!ret) {
 			fprintf(stderr, "%s: line %u failed\n",
-					prog_name, line);
+					xt_params->program_name, line);
 			exit(1);
 		}
 	}
 	if (in_table) {
 		fprintf(stderr, "%s: COMMIT expected at line %u\n",
-				prog_name, line + 1);
+				xt_params->program_name, line + 1);
 		exit(1);
 	}
 
-- 
1.7.3.4

