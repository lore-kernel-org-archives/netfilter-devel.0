Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A72D7C83000
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85453206D6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgD1ML2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 08:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726654AbgD1ML2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 08:11:28 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED82C03C1A9
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 05:11:27 -0700 (PDT)
Received: from localhost ([::1]:38680 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jTP5C-000890-N9; Tue, 28 Apr 2020 14:11:26 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 07/18] nft: calculate cache requirements from list of commands
Date:   Tue, 28 Apr 2020 14:10:02 +0200
Message-Id: <20200428121013.24507-8-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200428121013.24507-1-phil@nwl.cc>
References: <20200428121013.24507-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch uses the new list of commands to calculate the cache
requirements, the rationale after this updates is the following:

 #1 Parsing, that builds the list of commands and it also calculates
    cache level requirements.
 #2 Cache building.
 #3 Translate commands to jobs
 #4 Translate jobs to netlink

This patch removes the pre-parsing code in xtables-restore.c to
calculate the cache.

After this patch, cache is calculated only once, there is no need
to cancel and refetch for an in-transit transaction.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Rebased and resolved conflicts.
- Adjust for dropped init_chain_cache().
- Adjust for nft_rebuild_cache() respecting fake cache.
- Use if-clauses in __nft_build_cache() instead of switch() as that
  better fits the staged caching.
- Set cache_level to NFT_CL_TABLES in nft_cmd_table_flush(), not
  NFT_CL_CHAINS: When flushing the whole table, chain list is not
  relevant.
- Move nft_cache_level_set() into nft-cache.c as it belongs there, make
  it public and have xtables_save_main() call it instead of manipulating
  h->cache_level directly.
- Actually drop input buffering in xtables-restore.c, it is not needed
  anymore.
---
 iptables/nft-cache.c       | 68 +++++++++++++----------------
 iptables/nft-cache.h       |  2 +
 iptables/nft-cmd.c         | 66 +++++++++++++++++++++++++++++
 iptables/nft-cmd.h         |  1 +
 iptables/nft.c             | 17 +++++++-
 iptables/nft.h             |  2 +-
 iptables/xtables-restore.c | 87 +-------------------------------------
 iptables/xtables-save.c    |  3 ++
 8 files changed, 119 insertions(+), 127 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 51b371c51c3f4..38e353bd7231f 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -24,6 +24,14 @@
 #include "nft.h"
 #include "nft-cache.h"
 
+void nft_cache_level_set(struct nft_handle *h, int level)
+{
+	if (level <= h->cache_level)
+		return;
+
+	h->cache_level = level;
+}
+
 static int genid_cb(const struct nlmsghdr *nlh, void *data)
 {
 	uint32_t *genid = data;
@@ -436,42 +444,20 @@ __nft_build_cache(struct nft_handle *h, enum nft_cache_level level,
 		  const struct builtin_table *t, const char *set,
 		  const char *chain)
 {
-	if (level <= h->cache_level)
+	if (h->cache_init)
 		return;
 
-	if (!h->nft_genid)
-		mnl_genid_get(h, &h->nft_genid);
+	h->cache_init = true;
+	mnl_genid_get(h, &h->nft_genid);
 
-	switch (h->cache_level) {
-	case NFT_CL_NONE:
+	if (h->cache_level >= NFT_CL_TABLES)
 		fetch_table_cache(h);
-		if (level == NFT_CL_TABLES)
-			break;
-		/* fall through */
-	case NFT_CL_TABLES:
+	if (h->cache_level >= NFT_CL_CHAINS)
 		fetch_chain_cache(h, t, chain);
-		if (level == NFT_CL_CHAINS)
-			break;
-		/* fall through */
-	case NFT_CL_CHAINS:
+	if (h->cache_level >= NFT_CL_SETS)
 		fetch_set_cache(h, t, set);
-		if (level == NFT_CL_SETS)
-			break;
-		/* fall through */
-	case NFT_CL_SETS:
+	if (h->cache_level >= NFT_CL_RULES)
 		fetch_rule_cache(h, t, chain);
-		if (level == NFT_CL_RULES)
-			break;
-		/* fall through */
-	case NFT_CL_RULES:
-	case NFT_CL_FAKE:
-		break;
-	}
-
-	if (!t && !chain)
-		h->cache_level = level;
-	else if (h->cache_level < NFT_CL_TABLES)
-		h->cache_level = NFT_CL_TABLES;
 }
 
 void nft_build_cache(struct nft_handle *h, struct nftnl_chain *c)
@@ -493,6 +479,7 @@ void nft_fake_cache(struct nft_handle *h)
 	fetch_table_cache(h);
 
 	h->cache_level = NFT_CL_FAKE;
+	h->cache_init = true;
 	mnl_genid_get(h, &h->nft_genid);
 }
 
@@ -593,26 +580,29 @@ static int flush_cache(struct nft_handle *h, struct nft_cache *c,
 
 void flush_chain_cache(struct nft_handle *h, const char *tablename)
 {
-	if (!h->cache_level)
+	if (!h->cache_init)
 		return;
 
 	if (flush_cache(h, h->cache, tablename))
-		h->cache_level = NFT_CL_NONE;
+		h->cache_init = false;
 }
 
 void nft_rebuild_cache(struct nft_handle *h)
 {
-	enum nft_cache_level level = h->cache_level;
-
-	if (h->cache_level)
+	if (h->cache_init) {
 		__nft_flush_cache(h);
+		h->cache_init = false;
+	}
 
-	if (h->cache_level == NFT_CL_FAKE) {
+	if (h->cache_level == NFT_CL_FAKE)
 		nft_fake_cache(h);
-	} else {
-		h->cache_level = NFT_CL_NONE;
-		__nft_build_cache(h, level, NULL, NULL, NULL);
-	}
+	else
+		__nft_build_cache(h, h->cache_level, NULL, NULL, NULL);
+}
+
+void nft_cache_build(struct nft_handle *h)
+{
+	__nft_build_cache(h, h->cache_level, NULL, NULL, NULL);
 }
 
 void nft_release_cache(struct nft_handle *h)
diff --git a/iptables/nft-cache.h b/iptables/nft-cache.h
index ed498835676e2..cf28808e22c72 100644
--- a/iptables/nft-cache.h
+++ b/iptables/nft-cache.h
@@ -3,6 +3,7 @@
 
 struct nft_handle;
 
+void nft_cache_level_set(struct nft_handle *h, int level);
 void nft_fake_cache(struct nft_handle *h);
 void nft_build_cache(struct nft_handle *h, struct nftnl_chain *c);
 void nft_rebuild_cache(struct nft_handle *h);
@@ -10,6 +11,7 @@ void nft_release_cache(struct nft_handle *h);
 void flush_chain_cache(struct nft_handle *h, const char *tablename);
 int flush_rule_cache(struct nft_handle *h, const char *table,
 		     struct nftnl_chain *c);
+void nft_cache_build(struct nft_handle *h);
 
 struct nftnl_chain_list *
 nft_chain_list_get(struct nft_handle *h, const char *table, const char *chain);
diff --git a/iptables/nft-cmd.c b/iptables/nft-cmd.c
index 1d9834c0f94d7..be9fbbf5a19bd 100644
--- a/iptables/nft-cmd.c
+++ b/iptables/nft-cmd.c
@@ -63,12 +63,33 @@ void nft_cmd_free(struct nft_cmd *cmd)
 	free(cmd);
 }
 
+static void nft_cmd_rule_bridge(struct nft_handle *h, const char *chain,
+				const char *table)
+{
+	const struct builtin_table *t;
+
+	t = nft_table_builtin_find(h, table);
+	if (!t)
+		return;
+
+	/* Since ebtables user-defined chain policies are implemented as last
+	 * rule in nftables, rule cache is required here to treat them right.
+	 */
+	if (h->family == NFPROTO_BRIDGE &&
+	    !nft_chain_builtin_find(t, chain))
+		nft_cache_level_set(h, NFT_CL_RULES);
+	else
+		nft_cache_level_set(h, NFT_CL_CHAINS);
+}
+
 int nft_cmd_rule_append(struct nft_handle *h, const char *chain,
 			const char *table, struct iptables_command_state *state,
 			void *ref, bool verbose)
 {
 	struct nft_cmd *cmd;
 
+	nft_cmd_rule_bridge(h, chain, table);
+
 	cmd = nft_cmd_new(h, NFT_COMPAT_RULE_APPEND, table, chain, state, -1,
 			  verbose);
 	if (!cmd)
@@ -83,11 +104,18 @@ int nft_cmd_rule_insert(struct nft_handle *h, const char *chain,
 {
 	struct nft_cmd *cmd;
 
+	nft_cmd_rule_bridge(h, chain, table);
+
 	cmd = nft_cmd_new(h, NFT_COMPAT_RULE_INSERT, table, chain, state,
 			  rulenum, verbose);
 	if (!cmd)
 		return 0;
 
+	if (cmd->rulenum > 0)
+		nft_cache_level_set(h, NFT_CL_RULES);
+	else
+		nft_cache_level_set(h, NFT_CL_CHAINS);
+
 	return 1;
 }
 
@@ -102,6 +130,8 @@ int nft_cmd_rule_delete(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
+	nft_cache_level_set(h, NFT_CL_RULES);
+
 	return 1;
 }
 
@@ -115,6 +145,8 @@ int nft_cmd_rule_delete_num(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
+	nft_cache_level_set(h, NFT_CL_RULES);
+
 	return 1;
 }
 
@@ -128,6 +160,8 @@ int nft_cmd_rule_flush(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
+	nft_cache_level_set(h, NFT_CL_CHAINS);
+
 	return 1;
 }
 
@@ -141,6 +175,8 @@ int nft_cmd_chain_zero_counters(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
+	nft_cache_level_set(h, NFT_CL_CHAINS);
+
 	return 1;
 }
 
@@ -154,6 +190,8 @@ int nft_cmd_chain_user_add(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
+	nft_cache_level_set(h, NFT_CL_CHAINS);
+
 	return 1;
 }
 
@@ -167,6 +205,14 @@ int nft_cmd_chain_user_del(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
+	/* This triggers nft_bridge_chain_postprocess() when fetching the
+	 * rule cache.
+	 */
+	if (h->family == NFPROTO_BRIDGE)
+		nft_cache_level_set(h, NFT_CL_RULES);
+	else
+		nft_cache_level_set(h, NFT_CL_CHAINS);
+
 	return 1;
 }
 
@@ -182,6 +228,8 @@ int nft_cmd_chain_user_rename(struct nft_handle *h,const char *chain,
 
 	cmd->rename = strdup(newname);
 
+	nft_cache_level_set(h, NFT_CL_CHAINS);
+
 	return 1;
 }
 
@@ -197,6 +245,8 @@ int nft_cmd_rule_list(struct nft_handle *h, const char *chain,
 
 	cmd->format = format;
 
+	nft_cache_level_set(h, NFT_CL_RULES);
+
 	return 1;
 }
 
@@ -211,6 +261,8 @@ int nft_cmd_rule_replace(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
+	nft_cache_level_set(h, NFT_CL_RULES);
+
 	return 1;
 }
 
@@ -224,6 +276,8 @@ int nft_cmd_rule_check(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
+	nft_cache_level_set(h, NFT_CL_RULES);
+
 	return 1;
 }
 
@@ -242,6 +296,8 @@ int nft_cmd_chain_set(struct nft_handle *h, const char *table,
 	if (counters)
 		cmd->counters = *counters;
 
+	nft_cache_level_set(h, NFT_CL_CHAINS);
+
 	return 1;
 }
 
@@ -254,6 +310,8 @@ int nft_cmd_table_flush(struct nft_handle *h, const char *table)
 	if (!cmd)
 		return 0;
 
+	nft_cache_level_set(h, NFT_CL_TABLES);
+
 	return 1;
 }
 
@@ -267,6 +325,8 @@ int nft_cmd_chain_restore(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
+	nft_cache_level_set(h, NFT_CL_CHAINS);
+
 	return 1;
 }
 
@@ -280,6 +340,8 @@ int nft_cmd_rule_zero_counters(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
+	nft_cache_level_set(h, NFT_CL_RULES);
+
 	return 1;
 }
 
@@ -295,6 +357,8 @@ int nft_cmd_rule_list_save(struct nft_handle *h, const char *chain,
 
 	cmd->counters_save = counters;
 
+	nft_cache_level_set(h, NFT_CL_RULES);
+
 	return 1;
 }
 
@@ -310,6 +374,8 @@ int ebt_cmd_user_chain_policy(struct nft_handle *h, const char *table,
 
 	cmd->policy = strdup(policy);
 
+	nft_cache_level_set(h, NFT_CL_RULES);
+
 	return 1;
 }
 
diff --git a/iptables/nft-cmd.h b/iptables/nft-cmd.h
index 33ee766ae823f..0e1776ce088bf 100644
--- a/iptables/nft-cmd.h
+++ b/iptables/nft-cmd.h
@@ -18,6 +18,7 @@ struct nft_cmd {
 	unsigned int			format;
 	struct {
 		struct nftnl_rule	*rule;
+		struct nftnl_set	*set;
 	} obj;
 	const char			*policy;
 	struct xt_counters		counters;
diff --git a/iptables/nft.c b/iptables/nft.c
index bbbf7c6166ac6..f069396a05190 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -954,6 +954,7 @@ static struct nftnl_set *add_anon_set(struct nft_handle *h, const char *table,
 {
 	static uint32_t set_id = 0;
 	struct nftnl_set *s;
+	struct nft_cmd *cmd;
 
 	s = nftnl_set_alloc();
 	if (!s)
@@ -969,7 +970,14 @@ static struct nftnl_set *add_anon_set(struct nft_handle *h, const char *table,
 	nftnl_set_set_u32(s, NFTNL_SET_KEY_LEN, key_len);
 	nftnl_set_set_u32(s, NFTNL_SET_DESC_SIZE, size);
 
-	return batch_set_add(h, NFT_COMPAT_SET_ADD, s) ? s : NULL;
+	cmd = nft_cmd_new(h, NFT_COMPAT_SET_ADD, table, NULL, NULL, -1, false);
+	if (!cmd) {
+		nftnl_set_free(s);
+		return NULL;
+	}
+	cmd->obj.set = s;
+
+	return s;
 }
 
 static struct nftnl_expr *
@@ -2996,6 +3004,8 @@ static int nft_prepare(struct nft_handle *h)
 	struct nft_cmd *cmd, *next;
 	int ret = 1;
 
+	nft_cache_build(h);
+
 	list_for_each_entry_safe(cmd, next, &h->cmd_list, head) {
 		switch (cmd->command) {
 		case NFT_COMPAT_TABLE_FLUSH:
@@ -3081,9 +3091,12 @@ static int nft_prepare(struct nft_handle *h)
 			nft_xt_builtin_init(h, cmd->table);
 			ret = 1;
 			break;
+		case NFT_COMPAT_SET_ADD:
+			batch_set_add(h, NFT_COMPAT_SET_ADD, cmd->obj.set);
+			ret = 1;
+			break;
 		case NFT_COMPAT_TABLE_ADD:
 		case NFT_COMPAT_CHAIN_ADD:
-		case NFT_COMPAT_SET_ADD:
 			assert(0);
 			break;
 		}
diff --git a/iptables/nft.h b/iptables/nft.h
index 7ddc3a8bbb042..d61a40979d5bc 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -30,7 +30,6 @@ struct builtin_table {
 };
 
 enum nft_cache_level {
-	NFT_CL_NONE,
 	NFT_CL_TABLES,
 	NFT_CL_CHAINS,
 	NFT_CL_SETS,
@@ -95,6 +94,7 @@ struct nft_handle {
 	bool			noflush;
 	int8_t			config_done;
 	struct list_head	cmd_list;
+	bool			cache_init;
 
 	/* meta data, for error reporting */
 	struct {
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index c00ccb558784c..a58c6a5bdca7a 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -252,99 +252,16 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 	}
 }
 
-/* Return true if given iptables-restore line will require a full cache.
- * Typically these are commands referring to an existing rule
- * (either by number or content) or commands listing the ruleset. */
-static bool cmd_needs_full_cache(char *cmd)
-{
-	char c, chain[32];
-	int rulenum, mcount;
-
-	mcount = sscanf(cmd, "-%c %31s %d", &c, chain, &rulenum);
-
-	if (mcount == 3)
-		return true;
-	if (mcount < 1)
-		return false;
-
-	switch (c) {
-	case 'D':
-	case 'C':
-	case 'S':
-	case 'L':
-	case 'Z':
-		return true;
-	}
-
-	return false;
-}
-
-#define PREBUFSIZ	65536
-
 void xtables_restore_parse(struct nft_handle *h,
 			   const struct nft_xt_restore_parse *p)
 {
 	struct nft_xt_restore_state state = {};
-	char preload_buffer[PREBUFSIZ] = {}, buffer[10240] = {}, *ptr;
+	char buffer[10240] = {};
 
-	if (!h->noflush) {
+	if (!h->noflush)
 		nft_fake_cache(h);
-	} else {
-		ssize_t pblen = sizeof(preload_buffer);
-		bool do_cache = false;
-
-		ptr = preload_buffer;
-		while (fgets(buffer, sizeof(buffer), p->in)) {
-			size_t blen = strlen(buffer);
-
-			/* Drop trailing newline; xtables_restore_parse_line()
-			 * uses strtok() which replaces them by nul-characters,
-			 * causing unpredictable string delimiting in
-			 * preload_buffer.
-			 * Unless this is an empty line which would fold into a
-			 * spurious EoB indicator (double nul-char). */
-			if (buffer[blen - 1] == '\n' && blen > 1)
-				buffer[blen - 1] = '\0';
-			else
-				blen++;
-
-			pblen -= blen;
-			if (pblen <= 0) {
-				/* buffer exhausted */
-				do_cache = true;
-				break;
-			}
-
-			if (cmd_needs_full_cache(buffer)) {
-				do_cache = true;
-				break;
-			}
-
-			/* copy string including terminating nul-char */
-			memcpy(ptr, buffer, blen);
-			ptr += blen;
-			buffer[0] = '\0';
-		}
-
-		if (do_cache)
-			nft_build_cache(h, NULL);
-	}
 
 	line = 0;
-	ptr = preload_buffer;
-	while (*ptr) {
-		size_t len = strlen(ptr);
-
-		h->error.lineno = ++line;
-		DEBUGP("%s: buffered line %d: '%s'\n", __func__, line, ptr);
-		xtables_restore_parse_line(h, p, &state, ptr);
-		ptr += len + 1;
-	}
-	if (*buffer) {
-		h->error.lineno = ++line;
-		DEBUGP("%s: overrun line %d: '%s'\n", __func__, line, buffer);
-		xtables_restore_parse_line(h, p, &state, buffer);
-	}
 	while (fgets(buffer, sizeof(buffer), p->in)) {
 		h->error.lineno = ++line;
 		DEBUGP("%s: input line %d: '%s'\n", __func__, line, buffer);
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 28f7490275ce5..f927aa6e9e404 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -239,6 +239,9 @@ xtables_save_main(int family, int argc, char *argv[],
 		exit(EXIT_FAILURE);
 	}
 
+	nft_cache_level_set(&h, NFT_CL_RULES);
+	nft_cache_build(&h);
+
 	ret = do_output(&h, tablename, &d);
 	nft_fini(&h);
 	if (dump)
-- 
2.25.1

