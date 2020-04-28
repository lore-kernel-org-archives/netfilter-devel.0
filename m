Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37286C83000
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:11:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CF9B206D6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgD1MLX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 08:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726554AbgD1MLW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 08:11:22 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922ADC03C1A9
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 05:11:22 -0700 (PDT)
Received: from localhost ([::1]:38674 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jTP57-00088f-Dg; Tue, 28 Apr 2020 14:11:21 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 09/18] nft: remove cache build calls
Date:   Tue, 28 Apr 2020 14:10:04 +0200
Message-Id: <20200428121013.24507-10-phil@nwl.cc>
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

The cache requirements are now calculated once from the parsing phase.
There is no need to call __nft_build_cache() from several spots in the
codepath anymore.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Drop now unused nft_build_cache() function.
---
 iptables/nft-cache.c | 20 --------------------
 iptables/nft-cache.h |  1 -
 iptables/nft.c       | 21 ---------------------
 3 files changed, 42 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 38e353bd7231f..6db261fbba4b3 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -460,20 +460,6 @@ __nft_build_cache(struct nft_handle *h, enum nft_cache_level level,
 		fetch_rule_cache(h, t, chain);
 }
 
-void nft_build_cache(struct nft_handle *h, struct nftnl_chain *c)
-{
-	const struct builtin_table *t;
-	const char *table, *chain;
-
-	if (!c)
-		return __nft_build_cache(h, NFT_CL_RULES, NULL, NULL, NULL);
-
-	table = nftnl_chain_get_str(c, NFTNL_CHAIN_TABLE);
-	chain = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
-	t = nft_table_builtin_find(h, table);
-	__nft_build_cache(h, NFT_CL_RULES, t, NULL, chain);
-}
-
 void nft_fake_cache(struct nft_handle *h)
 {
 	fetch_table_cache(h);
@@ -619,8 +605,6 @@ void nft_release_cache(struct nft_handle *h)
 
 struct nftnl_table_list *nftnl_table_list_get(struct nft_handle *h)
 {
-	__nft_build_cache(h, NFT_CL_TABLES, NULL, NULL, NULL);
-
 	return h->cache->tables;
 }
 
@@ -633,8 +617,6 @@ nft_set_list_get(struct nft_handle *h, const char *table, const char *set)
 	if (!t)
 		return NULL;
 
-	__nft_build_cache(h, NFT_CL_RULES, t, set, NULL);
-
 	return h->cache->table[t->type].sets;
 }
 
@@ -647,8 +629,6 @@ nft_chain_list_get(struct nft_handle *h, const char *table, const char *chain)
 	if (!t)
 		return NULL;
 
-	__nft_build_cache(h, NFT_CL_CHAINS, t, NULL, chain);
-
 	return h->cache->table[t->type].chains;
 }
 
diff --git a/iptables/nft-cache.h b/iptables/nft-cache.h
index cf28808e22c72..8c63d8d566c19 100644
--- a/iptables/nft-cache.h
+++ b/iptables/nft-cache.h
@@ -5,7 +5,6 @@ struct nft_handle;
 
 void nft_cache_level_set(struct nft_handle *h, int level);
 void nft_fake_cache(struct nft_handle *h);
-void nft_build_cache(struct nft_handle *h, struct nftnl_chain *c);
 void nft_rebuild_cache(struct nft_handle *h);
 void nft_release_cache(struct nft_handle *h);
 void flush_chain_cache(struct nft_handle *h, const char *tablename);
diff --git a/iptables/nft.c b/iptables/nft.c
index 9771bcc9add02..f9e53316ab7cf 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1367,14 +1367,6 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 
 	nft_xt_builtin_init(h, table);
 
-	/* Since ebtables user-defined chain policies are implemented as last
-	 * rule in nftables, rule cache is required here to treat them right. */
-	if (h->family == NFPROTO_BRIDGE) {
-		c = nft_chain_find(h, table, chain);
-		if (c && !nft_chain_builtin(c))
-			nft_build_cache(h, c);
-	}
-
 	nft_fn = nft_rule_append;
 
 	if (ref) {
@@ -1599,7 +1591,6 @@ int nft_rule_save(struct nft_handle *h, const char *table, unsigned int format)
 
 	c = nftnl_chain_list_iter_next(iter);
 	while (c) {
-		nft_build_cache(h, c);
 		ret = nft_chain_save_rules(h, c, format);
 		if (ret != 0)
 			break;
@@ -1807,10 +1798,6 @@ static int __nft_chain_user_del(struct nftnl_chain *c, void *data)
 		fprintf(stdout, "Deleting chain `%s'\n",
 			nftnl_chain_get_str(c, NFTNL_CHAIN_NAME));
 
-	/* This triggers required policy rule deletion. */
-	if (h->family == NFPROTO_BRIDGE)
-		nft_build_cache(h, c);
-
 	/* XXX This triggers a fast lookup from the kernel. */
 	nftnl_chain_unset(c, NFTNL_CHAIN_HANDLE);
 	ret = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_DEL, c);
@@ -2093,8 +2080,6 @@ nft_rule_find(struct nft_handle *h, struct nftnl_chain *c,
 	struct nftnl_rule_iter *iter;
 	bool found = false;
 
-	nft_build_cache(h, c);
-
 	if (rulenum >= 0)
 		/* Delete by rule number case */
 		return nftnl_rule_lookup_byindex(c, rulenum);
@@ -2979,8 +2964,6 @@ int ebt_set_user_chain_policy(struct nft_handle *h, const char *table,
 	else
 		return 0;
 
-	nft_build_cache(h, c);
-
 	nftnl_chain_set_u32(c, NFTNL_CHAIN_POLICY, pval);
 	return 1;
 }
@@ -3333,8 +3316,6 @@ static int __nft_chain_zero_counters(struct nftnl_chain *c, void *data)
 			return -1;
 	}
 
-	nft_build_cache(h, c);
-
 	iter = nftnl_rule_iter_create(c);
 	if (iter == NULL)
 		return -1;
@@ -3471,8 +3452,6 @@ static int nft_is_chain_compatible(struct nftnl_chain *c, void *data)
 	enum nf_inet_hooks hook;
 	int prio;
 
-	nft_build_cache(h, c);
-
 	if (nftnl_rule_foreach(c, nft_is_rule_compatible, NULL))
 		return -1;
 
-- 
2.25.1

