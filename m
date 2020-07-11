Return-Path: <SRS0=5odi=AW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3C55C433E5
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:20:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB353206F4
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgGKKUI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Jul 2020 06:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgGKKUI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Jul 2020 06:20:08 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F53C08C5DD
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Jul 2020 03:20:08 -0700 (PDT)
Received: from localhost ([::1]:59510 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1juCc2-0007KJ-KU; Sat, 11 Jul 2020 12:20:06 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 18/18] nft: Avoid pointless table/chain creation
Date:   Sat, 11 Jul 2020 12:18:31 +0200
Message-Id: <20200711101831.29506-19-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200711101831.29506-1-phil@nwl.cc>
References: <20200711101831.29506-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Accept a chain name in nft_xt_builtin_init() to limit the base chain
creation to that specific chain only.

Introduce nft_xt_builtin_table_init() to create just the table for
situations where no builtin chains are needed but the command may still
succeed in an empty ruleset, particularly when creating a custom chain,
restoring base chains or adding a set for ebtables among match.

Introduce nft_xt_fake_builtin_chains(), a function to call after cache
has been populated to fill empty base chain slots. This keeps ruleset
listing output intact if some base chains do not exist (or even the
whole ruleset is completely empty).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c          | 90 ++++++++++++++++++++++++++++++++++-------
 iptables/nft.h          |  1 +
 iptables/xtables-save.c |  1 +
 3 files changed, 77 insertions(+), 15 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index a83856f16596e..6a84bf8ebb3ff 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -757,7 +757,8 @@ static void nft_chain_builtin_init(struct nft_handle *h,
 	}
 }
 
-static int nft_xt_builtin_init(struct nft_handle *h, const char *table)
+static const struct builtin_table *
+nft_xt_builtin_table_init(struct nft_handle *h, const char *table)
 {
 	const struct builtin_table *t;
 
@@ -765,25 +766,84 @@ static int nft_xt_builtin_init(struct nft_handle *h, const char *table)
 		return 0;
 
 	t = nft_table_builtin_find(h, table);
-	if (t == NULL)
-		return -1;
+	if (!t)
+		return NULL;
 
 	if (nft_table_initialized(h, t->type))
-		return 0;
+		return t;
 
 	if (nft_table_builtin_add(h, t) < 0)
+		return NULL;
+
+	h->cache->table[t->type].initialized = true;
+	return t;
+}
+
+static int nft_xt_builtin_init(struct nft_handle *h, const char *table,
+			       const char *chain)
+{
+	const struct builtin_table *t;
+	const struct builtin_chain *c;
+
+	if (!h->cache_init)
+		return 0;
+
+	t = nft_xt_builtin_table_init(h, table);
+	if (!t)
 		return -1;
 
 	if (h->cache_req.level < NFT_CL_CHAINS)
 		return 0;
 
-	nft_chain_builtin_init(h, t);
+	if (!chain) {
+		nft_chain_builtin_init(h, t);
+		return 0;
+	}
+
+	c = nft_chain_builtin_find(t, chain);
+	if (!c)
+		return -1;
 
-	h->cache->table[t->type].initialized = true;
+	if (h->cache->table[t->type].base_chains[c->hook])
+		return 0;
 
+	nft_chain_builtin_add(h, t, c);
 	return 0;
 }
 
+static int __nft_xt_builtin_chain_fake(struct nft_handle *h,
+				       const char *table, void *data)
+{
+	const struct builtin_table *t;
+	struct nftnl_chain **bcp, *c;
+	int i;
+
+	t = nft_table_builtin_find(h, table);
+	if (!t)
+		return -1;
+
+	bcp = h->cache->table[t->type].base_chains;
+	for (i = 0; i < NF_INET_NUMHOOKS && t->chains[i].name; i++) {
+		if (bcp[t->chains[i].hook])
+			continue;
+
+		c = nft_chain_builtin_alloc(t, &t->chains[i], NF_ACCEPT);
+		if (!c)
+			return -1;
+
+		bcp[t->chains[i].hook] = c;
+	}
+	return 0;
+}
+
+int nft_xt_fake_builtin_chains(struct nft_handle *h, const char *table)
+{
+	if (!table)
+		return nft_for_each_table(h, __nft_xt_builtin_chain_fake, NULL);
+
+	return __nft_xt_builtin_chain_fake(h, table, NULL);
+}
+
 static bool nft_chain_builtin(struct nftnl_chain *c)
 {
 	/* Check if this chain has hook number, in that case is built-in.
@@ -884,7 +944,7 @@ static struct nftnl_chain *nft_chain_new(struct nft_handle *h,
 	}
 
 	/* if this built-in table does not exists, create it */
-	nft_xt_builtin_init(h, table);
+	nft_xt_builtin_init(h, table, chain);
 
 	_c = nft_chain_builtin_find(_t, chain);
 	if (_c != NULL) {
@@ -1402,7 +1462,7 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 	struct nftnl_chain *c;
 	int type;
 
-	nft_xt_builtin_init(h, table);
+	nft_xt_builtin_init(h, table, chain);
 
 	nft_fn = nft_rule_append;
 
@@ -1681,7 +1741,7 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 	nft_fn = nft_rule_flush;
 
 	if (chain || verbose)
-		nft_xt_builtin_init(h, table);
+		nft_xt_builtin_init(h, table, chain);
 	else if (!nft_table_find(h, table))
 		return 1;
 
@@ -1714,7 +1774,7 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
 
 	nft_fn = nft_chain_user_add;
 
-	nft_xt_builtin_init(h, table);
+	nft_xt_builtin_table_init(h, table);
 
 	if (nft_chain_exists(h, table, chain)) {
 		errno = EEXIST;
@@ -1746,7 +1806,7 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
 	bool created = false;
 	int ret;
 
-	nft_xt_builtin_init(h, table);
+	nft_xt_builtin_table_init(h, table);
 
 	c = nft_chain_find(h, table, chain);
 	if (c) {
@@ -2240,7 +2300,7 @@ int nft_rule_insert(struct nft_handle *h, const char *chain,
 	struct nftnl_rule *r = NULL;
 	struct nftnl_chain *c;
 
-	nft_xt_builtin_init(h, table);
+	nft_xt_builtin_init(h, table, chain);
 
 	nft_fn = nft_rule_insert;
 
@@ -2448,7 +2508,7 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 	};
 	struct nftnl_chain *c;
 
-	nft_xt_builtin_init(h, table);
+	nft_xt_fake_builtin_chains(h, table);
 	nft_assert_table_compatible(h, table, chain);
 
 	if (chain) {
@@ -2542,7 +2602,7 @@ int nft_rule_list_save(struct nft_handle *h, const char *chain,
 	struct nftnl_chain *c;
 	int ret = 0;
 
-	nft_xt_builtin_init(h, table);
+	nft_xt_fake_builtin_chains(h, table);
 	nft_assert_table_compatible(h, table, chain);
 
 	if (counters < 0)
@@ -3146,7 +3206,7 @@ static int nft_prepare(struct nft_handle *h)
 							cmd->chain, cmd->policy);
 			break;
 		case NFT_COMPAT_SET_ADD:
-			nft_xt_builtin_init(h, cmd->table);
+			nft_xt_builtin_table_init(h, cmd->table);
 			batch_set_add(h, NFT_COMPAT_SET_ADD, cmd->obj.set);
 			ret = 1;
 			break;
diff --git a/iptables/nft.h b/iptables/nft.h
index 23eebe31e7aa0..7df640338c121 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -136,6 +136,7 @@ bool nft_table_find(struct nft_handle *h, const char *tablename);
 int nft_table_purge_chains(struct nft_handle *h, const char *table, struct nftnl_chain_list *list);
 int nft_table_flush(struct nft_handle *h, const char *table);
 const struct builtin_table *nft_table_builtin_find(struct nft_handle *h, const char *table);
+int nft_xt_fake_builtin_chains(struct nft_handle *h, const char *table);
 
 /*
  * Operations with chains.
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index bf00b0324cc4f..d91aa9c354d26 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -236,6 +236,7 @@ xtables_save_main(int family, int argc, char *argv[],
 
 	nft_cache_level_set(&h, NFT_CL_RULES, NULL);
 	nft_cache_build(&h);
+	nft_xt_fake_builtin_chains(&h, tablename);
 
 	ret = do_output(&h, tablename, &d);
 	nft_fini(&h);
-- 
2.27.0

