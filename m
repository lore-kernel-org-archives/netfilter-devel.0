Return-Path: <SRS0=5AJI=YR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59413CA9EAF
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 16:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D2BF205C9
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 16:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503481AbfJXQhi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Oct 2019 12:37:38 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:58918 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503479AbfJXQhh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Oct 2019 12:37:37 -0400
Received: from localhost ([::1]:43776 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iNg7E-0005DF-JQ; Thu, 24 Oct 2019 18:37:36 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 2/7] xtables-restore: Introduce struct nft_xt_restore_state
Date:   Thu, 24 Oct 2019 18:37:07 +0200
Message-Id: <20191024163712.22405-3-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191024163712.22405-1-phil@nwl.cc>
References: <20191024163712.22405-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This data structure holds parser state information. A follow-up patch
will extract line parsing code into a separate function which will need
a place to persistently store this info in between calls.

While being at it, make 'in_table' variable boolean and drop some extra
braces in conditionals checking its value.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-restore.c | 66 ++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 31 deletions(-)

diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 341579bd8d1c3..a9cb4ea55ab8f 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -68,14 +68,18 @@ static const struct nft_xt_restore_cb restore_cb = {
 	.chain_restore  = nft_chain_restore,
 };
 
+struct nft_xt_restore_state {
+	const struct builtin_table *curtable;
+	struct argv_store av_store;
+	bool in_table;
+};
+
 void xtables_restore_parse(struct nft_handle *h,
 			   const struct nft_xt_restore_parse *p)
 {
-	const struct builtin_table *curtable = NULL;
 	const struct nft_xt_restore_cb *cb = p->cb;
-	struct argv_store av_store = {};
+	struct nft_xt_restore_state state = {};
 	char buffer[10240];
-	int in_table = 0;
 
 	line = 0;
 
@@ -97,7 +101,7 @@ void xtables_restore_parse(struct nft_handle *h,
 			if (verbose)
 				fputs(buffer, stdout);
 			continue;
-		} else if ((strcmp(buffer, "COMMIT\n") == 0) && (in_table)) {
+		} else if ((strcmp(buffer, "COMMIT\n") == 0) && state.in_table) {
 			if (!p->testing) {
 				/* Commit per table, although we support
 				 * global commit at once, stick by now to
@@ -111,9 +115,9 @@ void xtables_restore_parse(struct nft_handle *h,
 				if (cb->abort)
 					ret = cb->abort(h);
 			}
-			in_table = 0;
+			state.in_table = false;
 
-		} else if ((buffer[0] == '*') && (!in_table || !p->commit)) {
+		} else if ((buffer[0] == '*') && (!state.in_table || !p->commit)) {
 			/* New table */
 			char *table;
 
@@ -124,8 +128,8 @@ void xtables_restore_parse(struct nft_handle *h,
 					"%s: line %u table name invalid\n",
 					xt_params->program_name, line);
 
-			curtable = nft_table_builtin_find(h, table);
-			if (!curtable)
+			state.curtable = nft_table_builtin_find(h, table);
+			if (!state.curtable)
 				xtables_error(PARAMETER_PROBLEM,
 					"%s: line %u table name '%s' invalid\n",
 					xt_params->program_name, line, table);
@@ -141,12 +145,12 @@ void xtables_restore_parse(struct nft_handle *h,
 			}
 
 			ret = 1;
-			in_table = 1;
+			state.in_table = true;
 
 			if (cb->table_new)
 				cb->table_new(h, table);
 
-		} else if ((buffer[0] == ':') && (in_table)) {
+		} else if ((buffer[0] == ':') && state.in_table) {
 			/* New chain. */
 			char *policy, *chain = NULL;
 			struct xt_counters count = {};
@@ -171,7 +175,7 @@ void xtables_restore_parse(struct nft_handle *h,
 					   "%s: line %u policy invalid\n",
 					   xt_params->program_name, line);
 
-			if (nft_chain_builtin_find(curtable, chain)) {
+			if (nft_chain_builtin_find(state.curtable, chain)) {
 				if (counters) {
 					char *ctrs;
 					ctrs = strtok(NULL, " \t\n");
@@ -183,7 +187,7 @@ void xtables_restore_parse(struct nft_handle *h,
 
 				}
 				if (cb->chain_set &&
-				    cb->chain_set(h, curtable->name,
+				    cb->chain_set(h, state.curtable->name,
 					          chain, policy, &count) < 0) {
 					xtables_error(OTHER_PROBLEM,
 						      "Can't set policy `%s'"
@@ -193,14 +197,14 @@ void xtables_restore_parse(struct nft_handle *h,
 				}
 				DEBUGP("Setting policy of chain %s to %s\n",
 				       chain, policy);
-			} else if (cb->chain_restore(h, chain, curtable->name) < 0 &&
+			} else if (cb->chain_restore(h, chain, state.curtable->name) < 0 &&
 				   errno != EEXIST) {
 				xtables_error(PARAMETER_PROBLEM,
 					      "cannot create chain "
 					      "'%s' (%s)\n", chain,
 					      strerror(errno));
 			} else if (h->family == NFPROTO_BRIDGE &&
-				   !ebt_set_user_chain_policy(h, curtable->name,
+				   !ebt_set_user_chain_policy(h, state.curtable->name,
 							      chain, policy)) {
 				xtables_error(OTHER_PROBLEM,
 					      "Can't set policy `%s'"
@@ -209,30 +213,30 @@ void xtables_restore_parse(struct nft_handle *h,
 					      strerror(errno));
 			}
 			ret = 1;
-		} else if (in_table) {
+		} else if (state.in_table) {
 			char *pcnt = NULL;
 			char *bcnt = NULL;
 			char *parsestart = buffer;
 
-			add_argv(&av_store, xt_params->program_name, 0);
-			add_argv(&av_store, "-t", 0);
-			add_argv(&av_store, curtable->name, 0);
+			add_argv(&state.av_store, xt_params->program_name, 0);
+			add_argv(&state.av_store, "-t", 0);
+			add_argv(&state.av_store, state.curtable->name, 0);
 
 			tokenize_rule_counters(&parsestart, &pcnt, &bcnt, line);
 			if (counters && pcnt && bcnt) {
-				add_argv(&av_store, "--set-counters", 0);
-				add_argv(&av_store, pcnt, 0);
-				add_argv(&av_store, bcnt, 0);
+				add_argv(&state.av_store, "--set-counters", 0);
+				add_argv(&state.av_store, pcnt, 0);
+				add_argv(&state.av_store, bcnt, 0);
 			}
 
-			add_param_to_argv(&av_store, parsestart, line);
+			add_param_to_argv(&state.av_store, parsestart, line);
 
 			DEBUGP("calling do_command4(%u, argv, &%s, handle):\n",
-			       av_store.argc, curtable->name);
-			debug_print_argv(&av_store);
+			       state.av_store.argc, state.curtable->name);
+			debug_print_argv(&state.av_store);
 
-			ret = cb->do_command(h, av_store.argc, av_store.argv,
-					    &av_store.argv[2], true);
+			ret = cb->do_command(h, state.av_store.argc, state.av_store.argv,
+					    &state.av_store.argv[2], true);
 			if (ret < 0) {
 				if (cb->abort)
 					ret = cb->abort(h);
@@ -246,11 +250,11 @@ void xtables_restore_parse(struct nft_handle *h,
 				exit(1);
 			}
 
-			free_argv(&av_store);
+			free_argv(&state.av_store);
 			fflush(stdout);
 		}
-		if (p->tablename && curtable &&
-		    (strcmp(p->tablename, curtable->name) != 0))
+		if (p->tablename && state.curtable &&
+		    (strcmp(p->tablename, state.curtable->name) != 0))
 			continue;
 		if (!ret) {
 			fprintf(stderr, "%s: line %u failed\n",
@@ -258,11 +262,11 @@ void xtables_restore_parse(struct nft_handle *h,
 			exit(1);
 		}
 	}
-	if (in_table && p->commit) {
+	if (state.in_table && p->commit) {
 		fprintf(stderr, "%s: COMMIT expected at line %u\n",
 				xt_params->program_name, line + 1);
 		exit(1);
-	} else if (in_table && cb->commit && !cb->commit(h)) {
+	} else if (state.in_table && cb->commit && !cb->commit(h)) {
 		xtables_error(OTHER_PROBLEM, "%s: final implicit COMMIT failed",
 			      xt_params->program_name);
 	}
-- 
2.23.0

