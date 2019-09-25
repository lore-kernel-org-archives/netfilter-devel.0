Return-Path: <SRS0=+tY6=XU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C253C432C2
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:27:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D49720673
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfIYV1d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:27:33 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45872 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbfIYV1c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 17:27:32 -0400
Received: from localhost ([::1]:58962 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iDEos-0005Gp-Mb; Wed, 25 Sep 2019 23:27:31 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 01/24] xtables_error() does not return
Date:   Wed, 25 Sep 2019 23:25:42 +0200
Message-Id: <20190925212605.1005-2-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190925212605.1005-1-phil@nwl.cc>
References: <20190925212605.1005-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It's a define which resolves into a callback which in turn is declared
with noreturn attribute. It will never return, therefore drop all
explicit exit() calls or other dead code immediately following it.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables-restore.c | 18 ++++++------------
 iptables/iptables-xml.c     | 22 +++++++---------------
 iptables/nft.c              |  8 ++------
 iptables/xshared.c          |  1 -
 iptables/xtables-restore.c  | 13 ++++---------
 5 files changed, 19 insertions(+), 43 deletions(-)

diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 430be18b3c300..6bc182bfae4a2 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -82,11 +82,10 @@ create_handle(struct iptables_restore_cb *cb, const char *tablename)
 		handle = cb->ops->init(tablename);
 	}
 
-	if (!handle) {
+	if (!handle)
 		xtables_error(PARAMETER_PROBLEM, "%s: unable to initialize "
 			"table '%s'\n", xt_params->program_name, tablename);
-		exit(1);
-	}
+
 	return handle;
 }
 
@@ -207,12 +206,11 @@ ip46tables_restore_main(struct iptables_restore_cb *cb, int argc, char *argv[])
 
 			table = strtok(buffer+1, " \t\n");
 			DEBUGP("line %u, table '%s'\n", line, table);
-			if (!table) {
+			if (!table)
 				xtables_error(PARAMETER_PROBLEM,
 					"%s: line %u table name invalid\n",
 					xt_params->program_name, line);
-				exit(1);
-			}
+
 			strncpy(curtable, table, XT_TABLE_MAXNAMELEN);
 			curtable[XT_TABLE_MAXNAMELEN] = '\0';
 
@@ -248,12 +246,10 @@ ip46tables_restore_main(struct iptables_restore_cb *cb, int argc, char *argv[])
 
 			chain = strtok(buffer+1, " \t\n");
 			DEBUGP("line %u, chain '%s'\n", line, chain);
-			if (!chain) {
+			if (!chain)
 				xtables_error(PARAMETER_PROBLEM,
 					   "%s: line %u chain name invalid\n",
 					   xt_params->program_name, line);
-				exit(1);
-			}
 
 			if (strlen(chain) >= XT_EXTENSION_MAXNAMELEN)
 				xtables_error(PARAMETER_PROBLEM,
@@ -281,12 +277,10 @@ ip46tables_restore_main(struct iptables_restore_cb *cb, int argc, char *argv[])
 
 			policy = strtok(NULL, " \t\n");
 			DEBUGP("line %u, policy '%s'\n", line, policy);
-			if (!policy) {
+			if (!policy)
 				xtables_error(PARAMETER_PROBLEM,
 					   "%s: line %u policy invalid\n",
 					   xt_params->program_name, line);
-				exit(1);
-			}
 
 			if (strcmp(policy, "-") != 0) {
 				struct xt_counters count = {};
diff --git a/iptables/iptables-xml.c b/iptables/iptables-xml.c
index 9d9ce6d4a13ee..36ad78450b1ef 100644
--- a/iptables/iptables-xml.c
+++ b/iptables/iptables-xml.c
@@ -208,12 +208,11 @@ needChain(char *chain)
 static void
 saveChain(char *chain, char *policy, struct xt_counters *ctr)
 {
-	if (nextChain >= maxChains) {
+	if (nextChain >= maxChains)
 		xtables_error(PARAMETER_PROBLEM,
 			   "%s: line %u chain name invalid\n",
 			   prog_name, line);
-		exit(1);
-	};
+
 	chains[nextChain].chain = strdup(chain);
 	chains[nextChain].policy = strdup(policy);
 	chains[nextChain].count = *ctr;
@@ -606,12 +605,11 @@ iptables_xml_main(int argc, char *argv[])
 
 			table = strtok(buffer + 1, " \t\n");
 			DEBUGP("line %u, table '%s'\n", line, table);
-			if (!table) {
+			if (!table)
 				xtables_error(PARAMETER_PROBLEM,
 					   "%s: line %u table name invalid\n",
 					   prog_name, line);
-				exit(1);
-			}
+
 			openTable(table);
 
 			ret = 1;
@@ -623,23 +621,19 @@ iptables_xml_main(int argc, char *argv[])
 
 			chain = strtok(buffer + 1, " \t\n");
 			DEBUGP("line %u, chain '%s'\n", line, chain);
-			if (!chain) {
+			if (!chain)
 				xtables_error(PARAMETER_PROBLEM,
 					   "%s: line %u chain name invalid\n",
 					   prog_name, line);
-				exit(1);
-			}
 
 			DEBUGP("Creating new chain '%s'\n", chain);
 
 			policy = strtok(NULL, " \t\n");
 			DEBUGP("line %u, policy '%s'\n", line, policy);
-			if (!policy) {
+			if (!policy)
 				xtables_error(PARAMETER_PROBLEM,
 					   "%s: line %u policy invalid\n",
 					   prog_name, line);
-				exit(1);
-			}
 
 			ctrs = strtok(NULL, " \t\n");
 			parse_counters(ctrs, &count);
@@ -735,13 +729,11 @@ iptables_xml_main(int argc, char *argv[])
 					     param_buffer[1] != '-' &&
 					     strchr(param_buffer, 't')) ||
 					    (!strncmp(param_buffer, "--t", 3) &&
-					     !strncmp(param_buffer, "--table", strlen(param_buffer)))) {
+					     !strncmp(param_buffer, "--table", strlen(param_buffer))))
 						xtables_error(PARAMETER_PROBLEM,
 							   "Line %u seems to have a "
 							   "-t table option.\n",
 							   line);
-						exit(1);
-					}
 
 					add_argv(param_buffer, quoted);
 					if (newargc >= 2
diff --git a/iptables/nft.c b/iptables/nft.c
index 8047a51f00493..90bb0c63c025a 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2517,10 +2517,8 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 
 	ops = nft_family_ops_lookup(h->family);
 
-	if (!nft_is_table_compatible(h, table)) {
+	if (!nft_is_table_compatible(h, table))
 		xtables_error(OTHER_PROBLEM, "table `%s' is incompatible, use 'nft' tool.\n", table);
-		return 0;
-	}
 
 	list = nft_chain_list_get(h, table);
 	if (!list)
@@ -2620,10 +2618,8 @@ int nft_rule_list_save(struct nft_handle *h, const char *chain,
 
 	nft_xt_builtin_init(h, table);
 
-	if (!nft_is_table_compatible(h, table)) {
+	if (!nft_is_table_compatible(h, table))
 		xtables_error(OTHER_PROBLEM, "table `%s' is incompatible, use 'nft' tool.\n", table);
-		return 0;
-	}
 
 	list = nft_chain_list_get(h, table);
 	if (!list)
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 36a2ec5f193d3..5e6cd4ae7c908 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -181,7 +181,6 @@ int command_default(struct iptables_command_state *cs,
 		xtables_error(PARAMETER_PROBLEM, "unknown option "
 			      "\"%s\"", cs->argv[optind-1]);
 	xtables_error(PARAMETER_PROBLEM, "Unknown arg \"%s\"", optarg);
-	return 0;
 }
 
 static mainfunc_t subcmd_get(const char *cmd, const struct subcommand *cb)
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index f930f5ba2d167..27e65b971727e 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -131,12 +131,11 @@ void xtables_restore_parse(struct nft_handle *h,
 
 			table = strtok(buffer+1, " \t\n");
 			DEBUGP("line %u, table '%s'\n", line, table);
-			if (!table) {
+			if (!table)
 				xtables_error(PARAMETER_PROBLEM,
 					"%s: line %u table name invalid\n",
 					xt_params->program_name, line);
-				exit(1);
-			}
+
 			curtable = nft_table_builtin_find(h, table);
 			if (!curtable)
 				xtables_error(PARAMETER_PROBLEM,
@@ -168,12 +167,10 @@ void xtables_restore_parse(struct nft_handle *h,
 
 			chain = strtok(buffer+1, " \t\n");
 			DEBUGP("line %u, chain '%s'\n", line, chain);
-			if (!chain) {
+			if (!chain)
 				xtables_error(PARAMETER_PROBLEM,
 					   "%s: line %u chain name invalid\n",
 					   xt_params->program_name, line);
-				exit(1);
-			}
 
 			if (strlen(chain) >= XT_EXTENSION_MAXNAMELEN)
 				xtables_error(PARAMETER_PROBLEM,
@@ -183,12 +180,10 @@ void xtables_restore_parse(struct nft_handle *h,
 
 			policy = strtok(NULL, " \t\n");
 			DEBUGP("line %u, policy '%s'\n", line, policy);
-			if (!policy) {
+			if (!policy)
 				xtables_error(PARAMETER_PROBLEM,
 					   "%s: line %u policy invalid\n",
 					   xt_params->program_name, line);
-				exit(1);
-			}
 
 			if (nft_chain_builtin_find(curtable, chain)) {
 				if (counters) {
-- 
2.23.0

