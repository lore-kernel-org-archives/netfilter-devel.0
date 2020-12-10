Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E22C5C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Dec 2020 13:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCD7B23D39
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Dec 2020 13:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388970AbgLJNHx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Dec 2020 08:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388951AbgLJNHx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Dec 2020 08:07:53 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3437EC061793
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Dec 2020 05:07:13 -0800 (PST)
Received: from localhost ([::1]:41014 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1knLf5-0000hC-Ol; Thu, 10 Dec 2020 14:07:11 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 9/9] nft: Avoid pointless table/chain creation
Date:   Thu, 10 Dec 2020 14:06:36 +0100
Message-Id: <20201210130636.26379-10-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201210130636.26379-1-phil@nwl.cc>
References: <20201210130636.26379-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 iptables/nft.c          | 98 +++++++++++++++++++++++++++++++++--------
 iptables/nft.h          |  1 +
 iptables/xtables-save.c |  1 +
 3 files changed, 82 insertions(+), 18 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 4187e691d8926..bde4ca72d3fcc 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -688,7 +688,8 @@ nft_chain_builtin_alloc(const struct builtin_table *table,
 
 static void nft_chain_builtin_add(struct nft_handle *h,
 				  const struct builtin_table *table,
-				  const struct builtin_chain *chain)
+				  const struct builtin_chain *chain,
+				  bool fake)
 {
 	struct nftnl_chain *c;
 
@@ -696,7 +697,8 @@ static void nft_chain_builtin_add(struct nft_handle *h,
 	if (c == NULL)
 		return;
 
-	batch_chain_add(h, NFT_COMPAT_CHAIN_ADD, c);
+	if (!fake)
+		batch_chain_add(h, NFT_COMPAT_CHAIN_ADD, c);
 	nft_cache_add_chain(h, table, c);
 }
 
@@ -748,29 +750,57 @@ static void nft_chain_builtin_init(struct nft_handle *h,
 		if (nft_chain_find(h, table->name, table->chains[i].name))
 			continue;
 
-		nft_chain_builtin_add(h, table, &table->chains[i]);
+		nft_chain_builtin_add(h, table, &table->chains[i], false);
 	}
 }
 
-static int nft_xt_builtin_init(struct nft_handle *h, const char *table)
+static const struct builtin_table *
+nft_xt_builtin_table_init(struct nft_handle *h, const char *table)
 {
 	const struct builtin_table *t;
 
 	if (!h->cache_init)
-		return 0;
+		return NULL;
 
 	t = nft_table_builtin_find(h, table);
 	if (t == NULL)
-		return -1;
+		return NULL;
 
 	if (nft_table_builtin_add(h, t) < 0)
+		return NULL;
+
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
+
+	if (h->cache->table[t->type].base_chains[c->hook])
+		return 0;
 
+	nft_chain_builtin_add(h, t, c, false);
 	return 0;
 }
 
@@ -782,6 +812,40 @@ static bool nft_chain_builtin(struct nftnl_chain *c)
 	return nftnl_chain_get(c, NFTNL_CHAIN_HOOKNUM) != NULL;
 }
 
+static int __nft_xt_fake_builtin_chains(struct nft_handle *h,
+				        const char *table, void *data)
+{
+	const char *chain = data ? *(const char **)data : NULL;
+	const struct builtin_table *t;
+	struct nft_chain **bcp;
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
+		if (chain && strcmp(chain, t->chains[i].name))
+			continue;
+
+		nft_chain_builtin_add(h, t, &t->chains[i], true);
+	}
+	return 0;
+}
+
+int nft_xt_fake_builtin_chains(struct nft_handle *h,
+			       const char *table, const char *chain)
+{
+	if (table)
+		return __nft_xt_fake_builtin_chains(h, table, &chain);
+
+	return nft_for_each_table(h, __nft_xt_fake_builtin_chains, &chain);
+}
+
 int nft_restart(struct nft_handle *h)
 {
 	mnl_socket_close(h->nl);
@@ -874,7 +938,7 @@ static struct nftnl_chain *nft_chain_new(struct nft_handle *h,
 	}
 
 	/* if this built-in table does not exists, create it */
-	nft_xt_builtin_init(h, table);
+	nft_xt_builtin_init(h, table, chain);
 
 	_c = nft_chain_builtin_find(_t, chain);
 	if (_c != NULL) {
@@ -1391,7 +1455,7 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 	struct nft_chain *c;
 	int type;
 
-	nft_xt_builtin_init(h, table);
+	nft_xt_builtin_init(h, table, chain);
 
 	nft_fn = nft_rule_append;
 
@@ -1671,7 +1735,7 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 	nft_fn = nft_rule_flush;
 
 	if (chain || verbose)
-		nft_xt_builtin_init(h, table);
+		nft_xt_builtin_init(h, table, chain);
 	else if (!nft_table_find(h, table))
 		return 1;
 
@@ -1703,7 +1767,7 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
 
 	nft_fn = nft_chain_user_add;
 
-	nft_xt_builtin_init(h, table);
+	t = nft_xt_builtin_table_init(h, table);
 
 	if (nft_chain_exists(h, table, chain)) {
 		errno = EEXIST;
@@ -1722,7 +1786,6 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
 	if (!batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c))
 		return 0;
 
-	t = nft_table_builtin_find(h, table);
 	nft_cache_add_chain(h, t, c);
 
 	/* the core expects 1 for success and 0 for error */
@@ -1737,7 +1800,7 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
 	struct nft_chain *nc;
 	bool created = false;
 
-	nft_xt_builtin_init(h, table);
+	t = nft_xt_builtin_table_init(h, table);
 
 	nc = nft_chain_find(h, table, chain);
 	if (!nc) {
@@ -1749,7 +1812,6 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
 		nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, chain);
 		created = true;
 
-		t = nft_table_builtin_find(h, table);
 		nft_cache_add_chain(h, t, c);
 	} else {
 		c = nc->nftnl;
@@ -2149,7 +2211,7 @@ int nft_rule_insert(struct nft_handle *h, const char *chain,
 	struct nftnl_rule *r = NULL;
 	struct nft_chain *c;
 
-	nft_xt_builtin_init(h, table);
+	nft_xt_builtin_init(h, table, chain);
 
 	nft_fn = nft_rule_insert;
 
@@ -2358,7 +2420,7 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 	};
 	struct nft_chain *c;
 
-	nft_xt_builtin_init(h, table);
+	nft_xt_fake_builtin_chains(h, table, chain);
 	nft_assert_table_compatible(h, table, chain);
 
 	if (chain) {
@@ -2459,7 +2521,7 @@ int nft_rule_list_save(struct nft_handle *h, const char *chain,
 	struct nft_chain *c;
 	int ret = 0;
 
-	nft_xt_builtin_init(h, table);
+	nft_xt_fake_builtin_chains(h, table, chain);
 	nft_assert_table_compatible(h, table, chain);
 
 	if (counters < 0)
@@ -3069,7 +3131,7 @@ static int nft_prepare(struct nft_handle *h)
 							cmd->chain, cmd->policy);
 			break;
 		case NFT_COMPAT_SET_ADD:
-			nft_xt_builtin_init(h, cmd->table);
+			nft_xt_builtin_table_init(h, cmd->table);
 			batch_set_add(h, NFT_COMPAT_SET_ADD, cmd->obj.set);
 			ret = 1;
 			break;
diff --git a/iptables/nft.h b/iptables/nft.h
index 1a2506eea7b6c..0910f82a2773c 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -136,6 +136,7 @@ bool nft_table_find(struct nft_handle *h, const char *tablename);
 int nft_table_purge_chains(struct nft_handle *h, const char *table, struct nftnl_chain_list *list);
 int nft_table_flush(struct nft_handle *h, const char *table);
 const struct builtin_table *nft_table_builtin_find(struct nft_handle *h, const char *table);
+int nft_xt_fake_builtin_chains(struct nft_handle *h, const char *table, const char *chain);
 
 /*
  * Operations with chains.
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index bf00b0324cc4f..d7901c650ea70 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -236,6 +236,7 @@ xtables_save_main(int family, int argc, char *argv[],
 
 	nft_cache_level_set(&h, NFT_CL_RULES, NULL);
 	nft_cache_build(&h);
+	nft_xt_fake_builtin_chains(&h, tablename, NULL);
 
 	ret = do_output(&h, tablename, &d);
 	nft_fini(&h);
-- 
2.28.0

