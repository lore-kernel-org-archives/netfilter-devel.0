Return-Path: <SRS0=Xvwf=23=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B218C33CA1
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 12:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 519AC2072E
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 12:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgAFMUi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 07:20:38 -0500
Received: from correo.us.es ([193.147.175.20]:43682 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbgAFMUi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 07:20:38 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 12E3FF2DF4
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2020 13:20:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C1A1ADA703
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2020 13:20:25 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B76BADA714; Mon,  6 Jan 2020 13:20:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5FE9CDA703;
        Mon,  6 Jan 2020 13:20:23 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 Jan 2020 13:20:23 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 42E2341E4800;
        Mon,  6 Jan 2020 13:20:23 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH 3/7] nft: calculate cache requirements from list of commands
Date:   Mon,  6 Jan 2020 13:20:14 +0100
Message-Id: <20200106122018.14090-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200106122018.14090-1-pablo@netfilter.org>
References: <20200106122018.14090-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch uses the new list of commands to calculate the cache
requirements, the rationale after this updates is the following:

 #1 Parsing, that builds the list of commands and it also calculates
    cache level requirements.
 #2 Cache building.
 #3 Translate commands to jobs
 #4 Translate jobs to netlink

This patch disables the pre-parsing code in xtables-restore.c to
calculate the cache.

After this patch, cache is calculated only once, there is no need
to cancel and refetch for an in-transit transaction.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft-cache.c       | 60 +++++++++++++++++--------------------
 iptables/nft-cache.h       |  1 +
 iptables/nft-cmd.c         | 74 ++++++++++++++++++++++++++++++++++++++++++++++
 iptables/nft-cmd.h         |  1 +
 iptables/nft.c             | 17 +++++++++--
 iptables/nft.h             |  2 +-
 iptables/xtables-restore.c |  3 --
 iptables/xtables-save.c    |  3 ++
 8 files changed, 122 insertions(+), 39 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 7345a27e2894..82d6b7c2393a 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -454,36 +454,31 @@ __nft_build_cache(struct nft_handle *h, enum nft_cache_level level,
 {
 	uint32_t genid_start, genid_stop;
 
-	if (level <= h->cache_level)
+	if (h->cache_init)
 		return;
+
+	h->cache_init = true;
 retry:
 	mnl_genid_get(h, &genid_start);
 
-	if (h->cache_level && genid_start != h->nft_genid)
-		flush_chain_cache(h, NULL);
-
 	switch (h->cache_level) {
-	case NFT_CL_NONE:
-		fetch_table_cache(h);
-		if (level == NFT_CL_TABLES)
-			break;
-		/* fall through */
 	case NFT_CL_TABLES:
-		fetch_chain_cache(h, t, chain);
-		if (level == NFT_CL_CHAINS)
-			break;
-		/* fall through */
+		fetch_table_cache(h);
+		break;
 	case NFT_CL_CHAINS:
-		fetch_set_cache(h, t, set);
-		if (level == NFT_CL_SETS)
-			break;
-		/* fall through */
+		fetch_table_cache(h);
+		fetch_chain_cache(h, t, chain);
+		break;
 	case NFT_CL_SETS:
-		fetch_rule_cache(h, t, chain);
-		if (level == NFT_CL_RULES)
-			break;
-		/* fall through */
+		fetch_table_cache(h);
+		fetch_chain_cache(h, t, chain);
+		fetch_set_cache(h, t, set);
+		break;
 	case NFT_CL_RULES:
+		fetch_table_cache(h);
+		fetch_chain_cache(h, t, chain);
+		fetch_set_cache(h, t, set);
+		fetch_rule_cache(h, t, chain);
 		break;
 	}
 
@@ -493,11 +488,6 @@ retry:
 		goto retry;
 	}
 
-	if (!t && !chain)
-		h->cache_level = level;
-	else if (h->cache_level < NFT_CL_TABLES)
-		h->cache_level = NFT_CL_TABLES;
-
 	h->nft_genid = genid_start;
 }
 
@@ -529,6 +519,7 @@ void nft_fake_cache(struct nft_handle *h)
 		h->cache->table[type].chains = nftnl_chain_list_alloc();
 	}
 	h->cache_level = NFT_CL_RULES;
+	h->cache_init = true;
 	mnl_genid_get(h, &h->nft_genid);
 }
 
@@ -627,22 +618,25 @@ static int flush_cache(struct nft_handle *h, struct nft_cache *c,
 
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
+	__nft_build_cache(h, h->cache_level, NULL, NULL, NULL);
+}
 
-	h->cache_level = NFT_CL_NONE;
-	__nft_build_cache(h, level, NULL, NULL, NULL);
+void nft_cache_build(struct nft_handle *h)
+{
+	__nft_build_cache(h, h->cache_level, NULL, NULL, NULL);
 }
 
 void nft_release_cache(struct nft_handle *h)
diff --git a/iptables/nft-cache.h b/iptables/nft-cache.h
index ed498835676e..8e957c155641 100644
--- a/iptables/nft-cache.h
+++ b/iptables/nft-cache.h
@@ -10,6 +10,7 @@ void nft_release_cache(struct nft_handle *h);
 void flush_chain_cache(struct nft_handle *h, const char *tablename);
 int flush_rule_cache(struct nft_handle *h, const char *table,
 		     struct nftnl_chain *c);
+void nft_cache_build(struct nft_handle *h);
 
 struct nftnl_chain_list *
 nft_chain_list_get(struct nft_handle *h, const char *table, const char *chain);
diff --git a/iptables/nft-cmd.c b/iptables/nft-cmd.c
index dd6672ee8015..2149aa906612 100644
--- a/iptables/nft-cmd.c
+++ b/iptables/nft-cmd.c
@@ -59,12 +59,41 @@ void nft_cmd_free(struct nft_cmd *cmd)
 	free(cmd);
 }
 
+static void nft_cache_level_set(struct nft_handle *h, int level)
+{
+	if (level <= h->cache_level)
+		return;
+
+	h->cache_level = level;
+}
+
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
@@ -79,11 +108,18 @@ int nft_cmd_rule_insert(struct nft_handle *h, const char *chain,
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
 
@@ -98,6 +134,8 @@ int nft_cmd_rule_delete(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
+	nft_cache_level_set(h, NFT_CL_RULES);
+
 	return 1;
 }
 
@@ -111,6 +149,8 @@ int nft_cmd_rule_delete_num(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
+	nft_cache_level_set(h, NFT_CL_RULES);
+
 	return 1;
 }
 
@@ -124,6 +164,8 @@ int nft_cmd_rule_flush(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
+	nft_cache_level_set(h, NFT_CL_CHAINS);
+
 	return 1;
 }
 
@@ -137,6 +179,8 @@ int nft_cmd_chain_zero_counters(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
+	nft_cache_level_set(h, NFT_CL_CHAINS);
+
 	return 1;
 }
 
@@ -150,6 +194,8 @@ int nft_cmd_chain_user_add(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
+	nft_cache_level_set(h, NFT_CL_CHAINS);
+
 	return 1;
 }
 
@@ -163,6 +209,14 @@ int nft_cmd_chain_user_del(struct nft_handle *h, const char *chain,
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
 
@@ -178,6 +232,8 @@ int nft_cmd_chain_user_rename(struct nft_handle *h,const char *chain,
 
 	cmd->rename = strdup(newname);
 
+	nft_cache_level_set(h, NFT_CL_CHAINS);
+
 	return 1;
 }
 
@@ -193,6 +249,8 @@ int nft_cmd_rule_list(struct nft_handle *h, const char *chain,
 
 	cmd->format = format;
 
+	nft_cache_level_set(h, NFT_CL_RULES);
+
 	return 1;
 }
 
@@ -207,6 +265,8 @@ int nft_cmd_rule_replace(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
+	nft_cache_level_set(h, NFT_CL_RULES);
+
 	return 1;
 }
 
@@ -220,6 +280,8 @@ int nft_cmd_rule_check(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
+	nft_cache_level_set(h, NFT_CL_RULES);
+
 	return 1;
 }
 
@@ -238,6 +300,8 @@ int nft_cmd_chain_set(struct nft_handle *h, const char *table,
 	if (counters)
 		cmd->counters = *counters;
 
+	nft_cache_level_set(h, NFT_CL_CHAINS);
+
 	return 1;
 }
 
@@ -250,6 +314,8 @@ int nft_cmd_table_flush(struct nft_handle *h, const char *table)
 	if (!cmd)
 		return 0;
 
+	nft_cache_level_set(h, NFT_CL_CHAINS);
+
 	return 1;
 }
 
@@ -263,6 +329,8 @@ int nft_cmd_chain_restore(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
+	nft_cache_level_set(h, NFT_CL_CHAINS);
+
 	return 1;
 }
 
@@ -276,6 +344,8 @@ int nft_cmd_rule_zero_counters(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
+	nft_cache_level_set(h, NFT_CL_RULES);
+
 	return 1;
 }
 
@@ -291,6 +361,8 @@ int nft_cmd_rule_list_save(struct nft_handle *h, const char *chain,
 
 	cmd->counters_save = counters;
 
+	nft_cache_level_set(h, NFT_CL_RULES);
+
 	return 1;
 }
 
@@ -306,6 +378,8 @@ int ebt_cmd_user_chain_policy(struct nft_handle *h, const char *table,
 
 	cmd->policy = strdup(policy);
 
+	nft_cache_level_set(h, NFT_CL_RULES);
+
 	return 1;
 }
 
diff --git a/iptables/nft-cmd.h b/iptables/nft-cmd.h
index 3b928af3893c..6419dba7fe20 100644
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
index 0c450b26c06e..1ff2e93c3a3e 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -947,6 +947,7 @@ static struct nftnl_set *add_anon_set(struct nft_handle *h, const char *table,
 {
 	static uint32_t set_id = 0;
 	struct nftnl_set *s;
+	struct nft_cmd *cmd;
 
 	s = nftnl_set_alloc();
 	if (!s)
@@ -962,7 +963,14 @@ static struct nftnl_set *add_anon_set(struct nft_handle *h, const char *table,
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
@@ -2964,6 +2972,8 @@ static int nft_prepare(struct nft_handle *h)
 	struct nft_cmd *cmd, *next;
 	int ret = 1;
 
+	nft_cache_build(h);
+
 	list_for_each_entry_safe(cmd, next, &h->cmd_list, head) {
 		switch (cmd->command) {
 		case NFT_COMPAT_TABLE_FLUSH:
@@ -3044,9 +3054,12 @@ static int nft_prepare(struct nft_handle *h)
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
index e98fe4db07f7..a9c133934b9e 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -30,7 +30,6 @@ struct builtin_table {
 };
 
 enum nft_cache_level {
-	NFT_CL_NONE,
 	NFT_CL_TABLES,
 	NFT_CL_CHAINS,
 	NFT_CL_SETS,
@@ -94,6 +93,7 @@ struct nft_handle {
 	bool			noflush;
 	int8_t			config_done;
 	struct list_head	cmd_list;
+	bool			cache_init;
 
 	/* meta data, for error reporting */
 	struct {
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index cc5a9056a715..868223c8fa77 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -319,9 +319,6 @@ void xtables_restore_parse(struct nft_handle *h,
 			ptr += blen;
 			buffer[0] = '\0';
 		}
-
-		if (do_cache)
-			nft_build_cache(h, NULL);
 	}
 
 	line = 0;
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 3a52f8c3d820..ff7234cca41f 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -253,6 +253,9 @@ xtables_save_main(int family, int argc, char *argv[],
 	if (!h.ops)
 		xtables_error(PARAMETER_PROBLEM, "Unknown family");
 
+	h.cache_level = NFT_CL_RULES;
+	nft_cache_build(&h);
+
 	ret = do_output(&h, tablename, &d);
 	nft_fini(&h);
 	if (dump)
-- 
2.11.0

