Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD63AC83000
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:11:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87504206D6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:11:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgD1MLj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 08:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726554AbgD1MLj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 08:11:39 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECAFCC03C1A9
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 05:11:38 -0700 (PDT)
Received: from localhost ([::1]:38692 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jTP5N-00089i-Ny; Tue, 28 Apr 2020 14:11:37 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 14/18] nft-cache: Fetch cache per table
Date:   Tue, 28 Apr 2020 14:10:09 +0200
Message-Id: <20200428121013.24507-15-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200428121013.24507-1-phil@nwl.cc>
References: <20200428121013.24507-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Restore per-table operation of cache routines as initially implemented
in commit e2883c5531e6e ("nft-cache: Support partial cache per table").

As before, this doesn't limit fetching of tables (their number is
supposed to be low) but instead limits fetching of sets, chains and
rules to the specified table.

For this to behave correctly when restoring without flushing over
multiple tables, cache must be freed fully after each commit - otherwise
the previous table's cache level is reused for the current one. The
exception being fake cache, used for flushing restore: NFT_CL_FAKE is
set just once at program startup, so it must stay set otherwise
consecutive tables cause pointless cache fetching.

The sole use-case requiring a multi-table cache, iptables-save, is
indicated by req->table being NULL. Therefore, req->table assignment is
a bit sloppy: All calls to nft_cache_level_set() are assumed to set the
same table value, no collision detection happens.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c       | 33 ++++++++++++++--------
 iptables/nft-cache.h       |  4 ++-
 iptables/nft-cmd.c         | 57 +++++++++++++++++++-------------------
 iptables/nft.h             |  1 +
 iptables/xtables-restore.c |  2 +-
 iptables/xtables-save.c    |  2 +-
 6 files changed, 56 insertions(+), 43 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 305f2c12307f7..5cbe7b80d084d 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -24,14 +24,18 @@
 #include "nft.h"
 #include "nft-cache.h"
 
-void nft_cache_level_set(struct nft_handle *h, int level)
+void nft_cache_level_set(struct nft_handle *h, int level,
+			 const struct nft_cmd *cmd)
 {
 	struct nft_cache_req *req = &h->cache_req;
 
-	if (level <= req->level)
+	if (level > req->level)
+		req->level = level;
+
+	if (!cmd)
 		return;
 
-	req->level = level;
+	req->table = cmd->table;
 }
 
 static int genid_cb(const struct nlmsghdr *nlh, void *data)
@@ -435,10 +439,14 @@ static void
 __nft_build_cache(struct nft_handle *h)
 {
 	struct nft_cache_req *req = &h->cache_req;
+	const struct builtin_table *t = NULL;
 
 	if (h->cache_init)
 		return;
 
+	if (req->table)
+		t = nft_table_builtin_find(h, req->table);
+
 	h->cache_init = true;
 	mnl_genid_get(h, &h->nft_genid);
 
@@ -447,11 +455,11 @@ __nft_build_cache(struct nft_handle *h)
 	if (req->level == NFT_CL_FAKE)
 		return;
 	if (req->level >= NFT_CL_CHAINS)
-		fetch_chain_cache(h, NULL, NULL);
+		fetch_chain_cache(h, t, NULL);
 	if (req->level >= NFT_CL_SETS)
-		fetch_set_cache(h, NULL, NULL);
+		fetch_set_cache(h, t, NULL);
 	if (req->level >= NFT_CL_RULES)
-		fetch_rule_cache(h, NULL);
+		fetch_rule_cache(h, t);
 }
 
 static void __nft_flush_cache(struct nft_handle *h)
@@ -575,14 +583,17 @@ void nft_cache_build(struct nft_handle *h)
 
 void nft_release_cache(struct nft_handle *h)
 {
-	if (!h->cache_index)
-		return;
+	struct nft_cache_req *req = &h->cache_req;
 
+	while (h->cache_index)
+		flush_cache(h, &h->__cache[h->cache_index--], NULL);
 	flush_cache(h, &h->__cache[0], NULL);
-	memcpy(&h->__cache[0], &h->__cache[1], sizeof(h->__cache[0]));
-	memset(&h->__cache[1], 0, sizeof(h->__cache[1]));
-	h->cache_index = 0;
 	h->cache = &h->__cache[0];
+	h->cache_init = false;
+
+	if (req->level != NFT_CL_FAKE)
+		req->level = NFT_CL_TABLES;
+	req->table = NULL;
 }
 
 struct nftnl_table_list *nftnl_table_list_get(struct nft_handle *h)
diff --git a/iptables/nft-cache.h b/iptables/nft-cache.h
index 01dd15e145fd4..f429118041be4 100644
--- a/iptables/nft-cache.h
+++ b/iptables/nft-cache.h
@@ -2,8 +2,10 @@
 #define _NFT_CACHE_H_
 
 struct nft_handle;
+struct nft_cmd;
 
-void nft_cache_level_set(struct nft_handle *h, int level);
+void nft_cache_level_set(struct nft_handle *h, int level,
+			 const struct nft_cmd *cmd);
 void nft_rebuild_cache(struct nft_handle *h);
 void nft_release_cache(struct nft_handle *h);
 void flush_chain_cache(struct nft_handle *h, const char *tablename);
diff --git a/iptables/nft-cmd.c b/iptables/nft-cmd.c
index be9fbbf5a19bd..64889f5eb6196 100644
--- a/iptables/nft-cmd.c
+++ b/iptables/nft-cmd.c
@@ -63,12 +63,11 @@ void nft_cmd_free(struct nft_cmd *cmd)
 	free(cmd);
 }
 
-static void nft_cmd_rule_bridge(struct nft_handle *h, const char *chain,
-				const char *table)
+static void nft_cmd_rule_bridge(struct nft_handle *h, const struct nft_cmd *cmd)
 {
 	const struct builtin_table *t;
 
-	t = nft_table_builtin_find(h, table);
+	t = nft_table_builtin_find(h, cmd->table);
 	if (!t)
 		return;
 
@@ -76,10 +75,10 @@ static void nft_cmd_rule_bridge(struct nft_handle *h, const char *chain,
 	 * rule in nftables, rule cache is required here to treat them right.
 	 */
 	if (h->family == NFPROTO_BRIDGE &&
-	    !nft_chain_builtin_find(t, chain))
-		nft_cache_level_set(h, NFT_CL_RULES);
+	    !nft_chain_builtin_find(t, cmd->chain))
+		nft_cache_level_set(h, NFT_CL_RULES, cmd);
 	else
-		nft_cache_level_set(h, NFT_CL_CHAINS);
+		nft_cache_level_set(h, NFT_CL_CHAINS, cmd);
 }
 
 int nft_cmd_rule_append(struct nft_handle *h, const char *chain,
@@ -88,13 +87,13 @@ int nft_cmd_rule_append(struct nft_handle *h, const char *chain,
 {
 	struct nft_cmd *cmd;
 
-	nft_cmd_rule_bridge(h, chain, table);
-
 	cmd = nft_cmd_new(h, NFT_COMPAT_RULE_APPEND, table, chain, state, -1,
 			  verbose);
 	if (!cmd)
 		return 0;
 
+	nft_cmd_rule_bridge(h, cmd);
+
 	return 1;
 }
 
@@ -104,17 +103,17 @@ int nft_cmd_rule_insert(struct nft_handle *h, const char *chain,
 {
 	struct nft_cmd *cmd;
 
-	nft_cmd_rule_bridge(h, chain, table);
-
 	cmd = nft_cmd_new(h, NFT_COMPAT_RULE_INSERT, table, chain, state,
 			  rulenum, verbose);
 	if (!cmd)
 		return 0;
 
+	nft_cmd_rule_bridge(h, cmd);
+
 	if (cmd->rulenum > 0)
-		nft_cache_level_set(h, NFT_CL_RULES);
+		nft_cache_level_set(h, NFT_CL_RULES, cmd);
 	else
-		nft_cache_level_set(h, NFT_CL_CHAINS);
+		nft_cache_level_set(h, NFT_CL_CHAINS, cmd);
 
 	return 1;
 }
@@ -130,7 +129,7 @@ int nft_cmd_rule_delete(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
-	nft_cache_level_set(h, NFT_CL_RULES);
+	nft_cache_level_set(h, NFT_CL_RULES, cmd);
 
 	return 1;
 }
@@ -145,7 +144,7 @@ int nft_cmd_rule_delete_num(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
-	nft_cache_level_set(h, NFT_CL_RULES);
+	nft_cache_level_set(h, NFT_CL_RULES, cmd);
 
 	return 1;
 }
@@ -160,7 +159,7 @@ int nft_cmd_rule_flush(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
-	nft_cache_level_set(h, NFT_CL_CHAINS);
+	nft_cache_level_set(h, NFT_CL_CHAINS, cmd);
 
 	return 1;
 }
@@ -175,7 +174,7 @@ int nft_cmd_chain_zero_counters(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
-	nft_cache_level_set(h, NFT_CL_CHAINS);
+	nft_cache_level_set(h, NFT_CL_CHAINS, cmd);
 
 	return 1;
 }
@@ -190,7 +189,7 @@ int nft_cmd_chain_user_add(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
-	nft_cache_level_set(h, NFT_CL_CHAINS);
+	nft_cache_level_set(h, NFT_CL_CHAINS, cmd);
 
 	return 1;
 }
@@ -209,9 +208,9 @@ int nft_cmd_chain_user_del(struct nft_handle *h, const char *chain,
 	 * rule cache.
 	 */
 	if (h->family == NFPROTO_BRIDGE)
-		nft_cache_level_set(h, NFT_CL_RULES);
+		nft_cache_level_set(h, NFT_CL_RULES, cmd);
 	else
-		nft_cache_level_set(h, NFT_CL_CHAINS);
+		nft_cache_level_set(h, NFT_CL_CHAINS, cmd);
 
 	return 1;
 }
@@ -228,7 +227,7 @@ int nft_cmd_chain_user_rename(struct nft_handle *h,const char *chain,
 
 	cmd->rename = strdup(newname);
 
-	nft_cache_level_set(h, NFT_CL_CHAINS);
+	nft_cache_level_set(h, NFT_CL_CHAINS, cmd);
 
 	return 1;
 }
@@ -245,7 +244,7 @@ int nft_cmd_rule_list(struct nft_handle *h, const char *chain,
 
 	cmd->format = format;
 
-	nft_cache_level_set(h, NFT_CL_RULES);
+	nft_cache_level_set(h, NFT_CL_RULES, cmd);
 
 	return 1;
 }
@@ -261,7 +260,7 @@ int nft_cmd_rule_replace(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
-	nft_cache_level_set(h, NFT_CL_RULES);
+	nft_cache_level_set(h, NFT_CL_RULES, cmd);
 
 	return 1;
 }
@@ -276,7 +275,7 @@ int nft_cmd_rule_check(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
-	nft_cache_level_set(h, NFT_CL_RULES);
+	nft_cache_level_set(h, NFT_CL_RULES, cmd);
 
 	return 1;
 }
@@ -296,7 +295,7 @@ int nft_cmd_chain_set(struct nft_handle *h, const char *table,
 	if (counters)
 		cmd->counters = *counters;
 
-	nft_cache_level_set(h, NFT_CL_CHAINS);
+	nft_cache_level_set(h, NFT_CL_CHAINS, cmd);
 
 	return 1;
 }
@@ -310,7 +309,7 @@ int nft_cmd_table_flush(struct nft_handle *h, const char *table)
 	if (!cmd)
 		return 0;
 
-	nft_cache_level_set(h, NFT_CL_TABLES);
+	nft_cache_level_set(h, NFT_CL_TABLES, cmd);
 
 	return 1;
 }
@@ -325,7 +324,7 @@ int nft_cmd_chain_restore(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
-	nft_cache_level_set(h, NFT_CL_CHAINS);
+	nft_cache_level_set(h, NFT_CL_CHAINS, cmd);
 
 	return 1;
 }
@@ -340,7 +339,7 @@ int nft_cmd_rule_zero_counters(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
-	nft_cache_level_set(h, NFT_CL_RULES);
+	nft_cache_level_set(h, NFT_CL_RULES, cmd);
 
 	return 1;
 }
@@ -357,7 +356,7 @@ int nft_cmd_rule_list_save(struct nft_handle *h, const char *chain,
 
 	cmd->counters_save = counters;
 
-	nft_cache_level_set(h, NFT_CL_RULES);
+	nft_cache_level_set(h, NFT_CL_RULES, cmd);
 
 	return 1;
 }
@@ -374,7 +373,7 @@ int ebt_cmd_user_chain_policy(struct nft_handle *h, const char *table,
 
 	cmd->policy = strdup(policy);
 
-	nft_cache_level_set(h, NFT_CL_RULES);
+	nft_cache_level_set(h, NFT_CL_RULES, cmd);
 
 	return 1;
 }
diff --git a/iptables/nft.h b/iptables/nft.h
index c6aece7d1dac8..50bcc0dfebecf 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -73,6 +73,7 @@ enum obj_update_type {
 
 struct nft_cache_req {
 	enum nft_cache_level	level;
+	const char		*table;
 };
 
 struct nft_handle {
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index ca01d17eba566..44eaf8ab6c483 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -259,7 +259,7 @@ void xtables_restore_parse(struct nft_handle *h,
 	char buffer[10240] = {};
 
 	if (!h->noflush)
-		nft_cache_level_set(h, NFT_CL_FAKE);
+		nft_cache_level_set(h, NFT_CL_FAKE, NULL);
 
 	line = 0;
 	while (fgets(buffer, sizeof(buffer), p->in)) {
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index f927aa6e9e404..0ce66e5d15cee 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -239,7 +239,7 @@ xtables_save_main(int family, int argc, char *argv[],
 		exit(EXIT_FAILURE);
 	}
 
-	nft_cache_level_set(&h, NFT_CL_RULES);
+	nft_cache_level_set(&h, NFT_CL_RULES, NULL);
 	nft_cache_build(&h);
 
 	ret = do_output(&h, tablename, &d);
-- 
2.25.1

