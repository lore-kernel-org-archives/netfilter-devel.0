Return-Path: <SRS0=5AJI=YR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 367FEC47E49
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 16:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFF4A21929
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 16:38:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503492AbfJXQiA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Oct 2019 12:38:00 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:58942 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503426AbfJXQiA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Oct 2019 12:38:00 -0400
Received: from localhost ([::1]:43800 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iNg7Z-0005Eh-Ri; Thu, 24 Oct 2019 18:37:58 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 3/7] xtables-restore: Introduce line parsing function
Date:   Thu, 24 Oct 2019 18:37:08 +0200
Message-Id: <20191024163712.22405-4-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191024163712.22405-1-phil@nwl.cc>
References: <20191024163712.22405-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Move the loop code parsing a distinct line of input into a dedicated
function as a preparation for changing input sources. Since loop code
either calls continue or exit() directly, there is no need for a return
code to indicate failure.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Despite the diff's size, this is actually a small change: Pass
--ignore-space-change to git to see how few changes there actually are
besides the necessary indenting level change.
---
 iptables/xtables-restore.c | 347 +++++++++++++++++++------------------
 1 file changed, 177 insertions(+), 170 deletions(-)

diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index a9cb4ea55ab8f..d21e9730805a8 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -74,199 +74,206 @@ struct nft_xt_restore_state {
 	bool in_table;
 };
 
-void xtables_restore_parse(struct nft_handle *h,
-			   const struct nft_xt_restore_parse *p)
+static void xtables_restore_parse_line(struct nft_handle *h,
+				       const struct nft_xt_restore_parse *p,
+				       struct nft_xt_restore_state *state,
+				       char *buffer)
 {
 	const struct nft_xt_restore_cb *cb = p->cb;
-	struct nft_xt_restore_state state = {};
-	char buffer[10240];
-
-	line = 0;
+	int ret = 0;
+
+	if (buffer[0] == '\n')
+		return;
+	else if (buffer[0] == '#') {
+		if (verbose)
+			fputs(buffer, stdout);
+		return;
+	} else if ((strcmp(buffer, "COMMIT\n") == 0) && state->in_table) {
+		if (!p->testing) {
+			/* Commit per table, although we support
+			 * global commit at once, stick by now to
+			 * the existing behaviour.
+			 */
+			DEBUGP("Calling commit\n");
+			if (cb->commit)
+				ret = cb->commit(h);
+		} else {
+			DEBUGP("Not calling commit, testing\n");
+			if (cb->abort)
+				ret = cb->abort(h);
+		}
+		state->in_table = false;
+
+	} else if ((buffer[0] == '*') && (!state->in_table || !p->commit)) {
+		/* New table */
+		char *table;
+
+		table = strtok(buffer+1, " \t\n");
+		DEBUGP("line %u, table '%s'\n", line, table);
+		if (!table)
+			xtables_error(PARAMETER_PROBLEM,
+				"%s: line %u table name invalid\n",
+				xt_params->program_name, line);
+
+		state->curtable = nft_table_builtin_find(h, table);
+		if (!state->curtable)
+			xtables_error(PARAMETER_PROBLEM,
+				"%s: line %u table name '%s' invalid\n",
+				xt_params->program_name, line, table);
+
+		if (p->tablename && (strcmp(p->tablename, table) != 0))
+			return;
+
+		if (h->noflush == 0) {
+			DEBUGP("Cleaning all chains of table '%s'\n",
+				table);
+			if (cb->table_flush)
+				cb->table_flush(h, table);
+		}
 
-	if (!h->noflush)
-		nft_fake_cache(h);
-	else
-		nft_build_cache(h, NULL);
+		ret = 1;
+		state->in_table = true;
+
+		if (cb->table_new)
+			cb->table_new(h, table);
+
+	} else if ((buffer[0] == ':') && state->in_table) {
+		/* New chain. */
+		char *policy, *chain = NULL;
+		struct xt_counters count = {};
+
+		chain = strtok(buffer+1, " \t\n");
+		DEBUGP("line %u, chain '%s'\n", line, chain);
+		if (!chain)
+			xtables_error(PARAMETER_PROBLEM,
+				   "%s: line %u chain name invalid\n",
+				   xt_params->program_name, line);
+
+		if (strlen(chain) >= XT_EXTENSION_MAXNAMELEN)
+			xtables_error(PARAMETER_PROBLEM,
+				   "Invalid chain name `%s' "
+				   "(%u chars max)",
+				   chain, XT_EXTENSION_MAXNAMELEN - 1);
+
+		policy = strtok(NULL, " \t\n");
+		DEBUGP("line %u, policy '%s'\n", line, policy);
+		if (!policy)
+			xtables_error(PARAMETER_PROBLEM,
+				   "%s: line %u policy invalid\n",
+				   xt_params->program_name, line);
+
+		if (nft_chain_builtin_find(state->curtable, chain)) {
+			if (counters) {
+				char *ctrs;
+				ctrs = strtok(NULL, " \t\n");
+
+				if (!ctrs || !parse_counters(ctrs, &count))
+					xtables_error(PARAMETER_PROBLEM,
+						   "invalid policy counters "
+						   "for chain '%s'\n", chain);
 
-	/* Grab standard input. */
-	while (fgets(buffer, sizeof(buffer), p->in)) {
-		int ret = 0;
-
-		line++;
-		h->error.lineno = line;
-
-		if (buffer[0] == '\n')
-			continue;
-		else if (buffer[0] == '#') {
-			if (verbose)
-				fputs(buffer, stdout);
-			continue;
-		} else if ((strcmp(buffer, "COMMIT\n") == 0) && state.in_table) {
-			if (!p->testing) {
-				/* Commit per table, although we support
-				 * global commit at once, stick by now to
-				 * the existing behaviour.
-				 */
-				DEBUGP("Calling commit\n");
-				if (cb->commit)
-					ret = cb->commit(h);
-			} else {
-				DEBUGP("Not calling commit, testing\n");
-				if (cb->abort)
-					ret = cb->abort(h);
-			}
-			state.in_table = false;
-
-		} else if ((buffer[0] == '*') && (!state.in_table || !p->commit)) {
-			/* New table */
-			char *table;
-
-			table = strtok(buffer+1, " \t\n");
-			DEBUGP("line %u, table '%s'\n", line, table);
-			if (!table)
-				xtables_error(PARAMETER_PROBLEM,
-					"%s: line %u table name invalid\n",
-					xt_params->program_name, line);
-
-			state.curtable = nft_table_builtin_find(h, table);
-			if (!state.curtable)
-				xtables_error(PARAMETER_PROBLEM,
-					"%s: line %u table name '%s' invalid\n",
-					xt_params->program_name, line, table);
-
-			if (p->tablename && (strcmp(p->tablename, table) != 0))
-				continue;
-
-			if (h->noflush == 0) {
-				DEBUGP("Cleaning all chains of table '%s'\n",
-					table);
-				if (cb->table_flush)
-					cb->table_flush(h, table);
 			}
-
-			ret = 1;
-			state.in_table = true;
-
-			if (cb->table_new)
-				cb->table_new(h, table);
-
-		} else if ((buffer[0] == ':') && state.in_table) {
-			/* New chain. */
-			char *policy, *chain = NULL;
-			struct xt_counters count = {};
-
-			chain = strtok(buffer+1, " \t\n");
-			DEBUGP("line %u, chain '%s'\n", line, chain);
-			if (!chain)
-				xtables_error(PARAMETER_PROBLEM,
-					   "%s: line %u chain name invalid\n",
-					   xt_params->program_name, line);
-
-			if (strlen(chain) >= XT_EXTENSION_MAXNAMELEN)
-				xtables_error(PARAMETER_PROBLEM,
-					   "Invalid chain name `%s' "
-					   "(%u chars max)",
-					   chain, XT_EXTENSION_MAXNAMELEN - 1);
-
-			policy = strtok(NULL, " \t\n");
-			DEBUGP("line %u, policy '%s'\n", line, policy);
-			if (!policy)
-				xtables_error(PARAMETER_PROBLEM,
-					   "%s: line %u policy invalid\n",
-					   xt_params->program_name, line);
-
-			if (nft_chain_builtin_find(state.curtable, chain)) {
-				if (counters) {
-					char *ctrs;
-					ctrs = strtok(NULL, " \t\n");
-
-					if (!ctrs || !parse_counters(ctrs, &count))
-						xtables_error(PARAMETER_PROBLEM,
-							   "invalid policy counters "
-							   "for chain '%s'\n", chain);
-
-				}
-				if (cb->chain_set &&
-				    cb->chain_set(h, state.curtable->name,
-					          chain, policy, &count) < 0) {
-					xtables_error(OTHER_PROBLEM,
-						      "Can't set policy `%s'"
-						      " on `%s' line %u: %s\n",
-						      policy, chain, line,
-						      strerror(errno));
-				}
-				DEBUGP("Setting policy of chain %s to %s\n",
-				       chain, policy);
-			} else if (cb->chain_restore(h, chain, state.curtable->name) < 0 &&
-				   errno != EEXIST) {
-				xtables_error(PARAMETER_PROBLEM,
-					      "cannot create chain "
-					      "'%s' (%s)\n", chain,
-					      strerror(errno));
-			} else if (h->family == NFPROTO_BRIDGE &&
-				   !ebt_set_user_chain_policy(h, state.curtable->name,
-							      chain, policy)) {
+			if (cb->chain_set &&
+			    cb->chain_set(h, state->curtable->name,
+					  chain, policy, &count) < 0) {
 				xtables_error(OTHER_PROBLEM,
 					      "Can't set policy `%s'"
 					      " on `%s' line %u: %s\n",
 					      policy, chain, line,
 					      strerror(errno));
 			}
-			ret = 1;
-		} else if (state.in_table) {
-			char *pcnt = NULL;
-			char *bcnt = NULL;
-			char *parsestart = buffer;
-
-			add_argv(&state.av_store, xt_params->program_name, 0);
-			add_argv(&state.av_store, "-t", 0);
-			add_argv(&state.av_store, state.curtable->name, 0);
-
-			tokenize_rule_counters(&parsestart, &pcnt, &bcnt, line);
-			if (counters && pcnt && bcnt) {
-				add_argv(&state.av_store, "--set-counters", 0);
-				add_argv(&state.av_store, pcnt, 0);
-				add_argv(&state.av_store, bcnt, 0);
-			}
+			DEBUGP("Setting policy of chain %s to %s\n",
+			       chain, policy);
+		} else if (cb->chain_restore(h, chain, state->curtable->name) < 0 &&
+			   errno != EEXIST) {
+			xtables_error(PARAMETER_PROBLEM,
+				      "cannot create chain "
+				      "'%s' (%s)\n", chain,
+				      strerror(errno));
+		} else if (h->family == NFPROTO_BRIDGE &&
+			   !ebt_set_user_chain_policy(h, state->curtable->name,
+						      chain, policy)) {
+			xtables_error(OTHER_PROBLEM,
+				      "Can't set policy `%s'"
+				      " on `%s' line %u: %s\n",
+				      policy, chain, line,
+				      strerror(errno));
+		}
+		ret = 1;
+	} else if (state->in_table) {
+		char *pcnt = NULL;
+		char *bcnt = NULL;
+		char *parsestart = buffer;
+
+		add_argv(&state->av_store, xt_params->program_name, 0);
+		add_argv(&state->av_store, "-t", 0);
+		add_argv(&state->av_store, state->curtable->name, 0);
+
+		tokenize_rule_counters(&parsestart, &pcnt, &bcnt, line);
+		if (counters && pcnt && bcnt) {
+			add_argv(&state->av_store, "--set-counters", 0);
+			add_argv(&state->av_store, pcnt, 0);
+			add_argv(&state->av_store, bcnt, 0);
+		}
+
+		add_param_to_argv(&state->av_store, parsestart, line);
 
-			add_param_to_argv(&state.av_store, parsestart, line);
+		DEBUGP("calling do_command4(%u, argv, &%s, handle):\n",
+		       state->av_store.argc, state->curtable->name);
+		debug_print_argv(&state->av_store);
 
-			DEBUGP("calling do_command4(%u, argv, &%s, handle):\n",
-			       state.av_store.argc, state.curtable->name);
-			debug_print_argv(&state.av_store);
+		ret = cb->do_command(h, state->av_store.argc,
+				     state->av_store.argv,
+				     &state->av_store.argv[2], true);
+		if (ret < 0) {
+			if (cb->abort)
+				ret = cb->abort(h);
+			else
+				ret = 0;
 
-			ret = cb->do_command(h, state.av_store.argc, state.av_store.argv,
-					    &state.av_store.argv[2], true);
 			if (ret < 0) {
-				if (cb->abort)
-					ret = cb->abort(h);
-				else
-					ret = 0;
-
-				if (ret < 0) {
-					fprintf(stderr, "failed to abort "
-							"commit operation\n");
-				}
-				exit(1);
+				fprintf(stderr, "failed to abort "
+						"commit operation\n");
 			}
-
-			free_argv(&state.av_store);
-			fflush(stdout);
-		}
-		if (p->tablename && state.curtable &&
-		    (strcmp(p->tablename, state.curtable->name) != 0))
-			continue;
-		if (!ret) {
-			fprintf(stderr, "%s: line %u failed\n",
-					xt_params->program_name, line);
 			exit(1);
 		}
+
+		free_argv(&state->av_store);
+		fflush(stdout);
+	}
+	if (p->tablename && state->curtable &&
+	    (strcmp(p->tablename, state->curtable->name) != 0))
+		return;
+	if (!ret) {
+		fprintf(stderr, "%s: line %u failed\n",
+				xt_params->program_name, line);
+		exit(1);
+	}
+}
+
+void xtables_restore_parse(struct nft_handle *h,
+			   const struct nft_xt_restore_parse *p)
+{
+	struct nft_xt_restore_state state = {};
+	char buffer[10240];
+
+	line = 0;
+
+	if (!h->noflush)
+		nft_fake_cache(h);
+	else
+		nft_build_cache(h, NULL);
+
+	/* Grab standard input. */
+	while (fgets(buffer, sizeof(buffer), p->in)) {
+		h->error.lineno = ++line;
+		xtables_restore_parse_line(h, p, &state, buffer);
 	}
 	if (state.in_table && p->commit) {
 		fprintf(stderr, "%s: COMMIT expected at line %u\n",
 				xt_params->program_name, line + 1);
 		exit(1);
-	} else if (state.in_table && cb->commit && !cb->commit(h)) {
+	} else if (state.in_table && p->cb->commit && !p->cb->commit(h)) {
 		xtables_error(OTHER_PROBLEM, "%s: final implicit COMMIT failed",
 			      xt_params->program_name);
 	}
-- 
2.23.0

