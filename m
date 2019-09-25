Return-Path: <SRS0=+tY6=XU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5796EC432C2
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33CC920673
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfIYV21 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:28:27 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45932 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbfIYV20 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 17:28:26 -0400
Received: from localhost ([::1]:59022 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iDEpl-0005KN-OE; Wed, 25 Sep 2019 23:28:25 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 19/24] xtables-restore: Carry curtable in struct nft_xt_restore_parse
Date:   Wed, 25 Sep 2019 23:26:00 +0200
Message-Id: <20190925212605.1005-20-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190925212605.1005-1-phil@nwl.cc>
References: <20190925212605.1005-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a requirement for outsourcing line parsing code into a dedicated
function.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.h      |  1 +
 iptables/xtables-restore.c | 21 ++++++++++-----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index f1efab80ff621..3be8bafed60e9 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -238,6 +238,7 @@ struct nft_xt_restore_parse {
 	const char	*tablename;
 	bool		commit;
 	bool		in_table;
+	const struct builtin_table *curtable;
 };
 
 struct nftnl_chain_list;
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 48999d1ec8a27..3bd8a8925c8bc 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -88,7 +88,6 @@ void xtables_restore_parse(struct nft_handle *h,
 			   struct nft_xt_restore_parse *p,
 			   struct nft_xt_restore_cb *cb)
 {
-	const struct builtin_table *curtable = NULL;
 	char buffer[10240];
 	const struct xtc_ops *ops = &xtc_ops;
 
@@ -139,8 +138,8 @@ void xtables_restore_parse(struct nft_handle *h,
 					"%s: line %u table name invalid\n",
 					xt_params->program_name, line);
 
-			curtable = nft_table_builtin_find(h, table);
-			if (!curtable)
+			p->curtable = nft_table_builtin_find(h, table);
+			if (!p->curtable)
 				xtables_error(PARAMETER_PROBLEM,
 					"%s: line %u table name '%s' invalid\n",
 					xt_params->program_name, line, table);
@@ -186,7 +185,7 @@ void xtables_restore_parse(struct nft_handle *h,
 					   "%s: line %u policy invalid\n",
 					   xt_params->program_name, line);
 
-			if (nft_chain_builtin_find(curtable, chain)) {
+			if (nft_chain_builtin_find(p->curtable, chain)) {
 				if (counters) {
 					char *ctrs;
 					ctrs = strtok(NULL, " \t\n");
@@ -198,7 +197,7 @@ void xtables_restore_parse(struct nft_handle *h,
 
 				}
 				if (cb->chain_set &&
-				    cb->chain_set(h, curtable->name,
+				    cb->chain_set(h, p->curtable->name,
 					          chain, policy, &count) < 0) {
 					xtables_error(OTHER_PROBLEM,
 						      "Can't set policy `%s'"
@@ -208,14 +207,14 @@ void xtables_restore_parse(struct nft_handle *h,
 				}
 				DEBUGP("Setting policy of chain %s to %s\n",
 				       chain, policy);
-			} else if (cb->chain_restore(h, chain, curtable->name) < 0 &&
+			} else if (cb->chain_restore(h, chain, p->curtable->name) < 0 &&
 				   errno != EEXIST) {
 				xtables_error(PARAMETER_PROBLEM,
 					      "cannot create chain "
 					      "'%s' (%s)\n", chain,
 					      strerror(errno));
 			} else if (h->family == NFPROTO_BRIDGE &&
-				   !ebt_set_user_chain_policy(h, curtable->name,
+				   !ebt_set_user_chain_policy(h, p->curtable->name,
 							      chain, policy)) {
 				xtables_error(OTHER_PROBLEM,
 					      "Can't set policy `%s'"
@@ -235,7 +234,7 @@ void xtables_restore_parse(struct nft_handle *h,
 
 			add_argv(xt_params->program_name, 0);
 			add_argv("-t", 0);
-			add_argv(curtable->name, 0);
+			add_argv(p->curtable->name, 0);
 
 			tokenize_rule_counters(&parsestart, &pcnt, &bcnt, line);
 			if (counters && pcnt && bcnt) {
@@ -247,7 +246,7 @@ void xtables_restore_parse(struct nft_handle *h,
 			add_param_to_argv(parsestart, line);
 
 			DEBUGP("calling do_command4(%u, argv, &%s, handle):\n",
-				newargc, curtable->name);
+				newargc, p->curtable->name);
 
 			for (a = 0; a < newargc; a++)
 				DEBUGP("argv[%u]: %s\n", a, newargv[a]);
@@ -270,8 +269,8 @@ void xtables_restore_parse(struct nft_handle *h,
 			free_argv();
 			fflush(stdout);
 		}
-		if (p->tablename && curtable &&
-		    (strcmp(p->tablename, curtable->name) != 0))
+		if (p->tablename && p->curtable &&
+		    (strcmp(p->tablename, p->curtable->name) != 0))
 			continue;
 		if (!ret) {
 			fprintf(stderr, "%s: line %u failed\n",
-- 
2.23.0

