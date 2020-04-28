Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C93CC83000
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6B1D206D6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgD1MLR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 08:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726554AbgD1MLR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 08:11:17 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4469BC03C1A9
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 05:11:17 -0700 (PDT)
Received: from localhost ([::1]:38668 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jTP52-00088I-3i; Tue, 28 Apr 2020 14:11:16 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 16/18] nft: cache: Fetch cache for specific chains
Date:   Tue, 28 Apr 2020 14:10:11 +0200
Message-Id: <20200428121013.24507-17-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200428121013.24507-1-phil@nwl.cc>
References: <20200428121013.24507-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Iterate over command list and collect chains to cache. Insert them into
a sorted list to pass to __nft_build_cache().

If a command is interested in all chains (e.g., --list), cmd->chain
remains unset. To record this case reliably, use a boolean
('all_chains'). Otherwise, it is hard to distinguish between first call
to nft_cache_level_set() and previous command with NULL cmd->chain
value.

When caching only specific chains, manually add builtin ones for the
given table as well - otherwise nft_xt_builtin_init() will act as if
they don't exist and possibly override non-default chain policies.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 82 +++++++++++++++++++++++++++++++++++++++-----
 iptables/nft.c       |  1 +
 iptables/nft.h       |  7 ++++
 3 files changed, 82 insertions(+), 8 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 904c9a8217dac..83af9a2f689e1 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -11,6 +11,7 @@
 
 #include <assert.h>
 #include <errno.h>
+#include <stdlib.h>
 #include <string.h>
 #include <xtables.h>
 
@@ -24,6 +25,24 @@
 #include "nft.h"
 #include "nft-cache.h"
 
+static void cache_chain_list_insert(struct list_head *list, const char *name)
+{
+	struct cache_chain *pos = NULL, *new;
+
+	list_for_each_entry(pos, list, head) {
+		int cmp = strcmp(pos->name, name);
+
+		if (!cmp)
+			return;
+		if (cmp > 0)
+			break;
+	}
+
+	new = xtables_malloc(sizeof(*new));
+	new->name = name;
+	list_add_tail(&new->head, pos ? &pos->head : list);
+}
+
 void nft_cache_level_set(struct nft_handle *h, int level,
 			 const struct nft_cmd *cmd)
 {
@@ -32,10 +51,21 @@ void nft_cache_level_set(struct nft_handle *h, int level,
 	if (level > req->level)
 		req->level = level;
 
-	if (!cmd)
+	if (!cmd || !cmd->table || req->all_chains)
 		return;
 
 	req->table = cmd->table;
+
+	if (!cmd->chain) {
+		req->all_chains = true;
+		return;
+	}
+
+	cache_chain_list_insert(&req->chain_list, cmd->chain);
+	if (cmd->rename)
+		cache_chain_list_insert(&req->chain_list, cmd->rename);
+	if (cmd->jumpto)
+		cache_chain_list_insert(&req->chain_list, cmd->jumpto);
 }
 
 static int genid_cb(const struct nlmsghdr *nlh, void *data)
@@ -344,12 +374,13 @@ static int __fetch_chain_cache(struct nft_handle *h,
 
 static int fetch_chain_cache(struct nft_handle *h,
 			     const struct builtin_table *t,
-			     const char *chain)
+			     struct list_head *chains)
 {
+	struct cache_chain *cc;
 	struct nftnl_chain *c;
-	int ret;
+	int rc, ret = 0;
 
-	if (!chain)
+	if (!chains)
 		return __fetch_chain_cache(h, t, NULL);
 
 	assert(t);
@@ -359,8 +390,13 @@ static int fetch_chain_cache(struct nft_handle *h,
 		return -1;
 
 	nftnl_chain_set_str(c, NFTNL_CHAIN_TABLE, t->name);
-	nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, chain);
-	ret = __fetch_chain_cache(h, t, c);
+
+	list_for_each_entry(cc, chains, head) {
+		nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, cc->name);
+		rc = __fetch_chain_cache(h, t, c);
+		if (rc)
+			ret = rc;
+	}
 
 	nftnl_chain_free(c);
 	return ret;
@@ -450,12 +486,16 @@ __nft_build_cache(struct nft_handle *h)
 {
 	struct nft_cache_req *req = &h->cache_req;
 	const struct builtin_table *t = NULL;
+	struct list_head *chains = NULL;
 
 	if (h->cache_init)
 		return;
 
-	if (req->table)
+	if (req->table) {
 		t = nft_table_builtin_find(h, req->table);
+		if (!req->all_chains)
+			chains = &req->chain_list;
+	}
 
 	h->cache_init = true;
 	mnl_genid_get(h, &h->nft_genid);
@@ -465,7 +505,7 @@ __nft_build_cache(struct nft_handle *h)
 	if (req->level == NFT_CL_FAKE)
 		return;
 	if (req->level >= NFT_CL_CHAINS)
-		fetch_chain_cache(h, t, NULL);
+		fetch_chain_cache(h, t, chains);
 	if (req->level >= NFT_CL_SETS)
 		fetch_set_cache(h, t, NULL);
 	if (req->level >= NFT_CL_RULES)
@@ -588,12 +628,32 @@ void nft_rebuild_cache(struct nft_handle *h)
 
 void nft_cache_build(struct nft_handle *h)
 {
+	struct nft_cache_req *req = &h->cache_req;
+	const struct builtin_table *t = NULL;
+	int i;
+
+	if (req->table)
+		t = nft_table_builtin_find(h, req->table);
+
+	/* fetch builtin chains as well (if existing) so nft_xt_builtin_init()
+	 * doesn't override policies by accident */
+	if (t && !req->all_chains) {
+		for (i = 0; i < NF_INET_NUMHOOKS; i++) {
+			const char *cname = t->chains[i].name;
+
+			if (!cname)
+				break;
+			cache_chain_list_insert(&req->chain_list, cname);
+		}
+	}
+
 	__nft_build_cache(h);
 }
 
 void nft_release_cache(struct nft_handle *h)
 {
 	struct nft_cache_req *req = &h->cache_req;
+	struct cache_chain *cc, *cc_tmp;
 
 	while (h->cache_index)
 		flush_cache(h, &h->__cache[h->cache_index--], NULL);
@@ -604,6 +664,12 @@ void nft_release_cache(struct nft_handle *h)
 	if (req->level != NFT_CL_FAKE)
 		req->level = NFT_CL_TABLES;
 	req->table = NULL;
+
+	req->all_chains = false;
+	list_for_each_entry_safe(cc, cc_tmp, &req->chain_list, head) {
+		list_del(&cc->head);
+		free(cc);
+	}
 }
 
 struct nftnl_table_list *nftnl_table_list_get(struct nft_handle *h)
diff --git a/iptables/nft.c b/iptables/nft.c
index f9e53316ab7cf..5b255477f27f7 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -805,6 +805,7 @@ int nft_init(struct nft_handle *h, int family, const struct builtin_table *t)
 	INIT_LIST_HEAD(&h->obj_list);
 	INIT_LIST_HEAD(&h->err_list);
 	INIT_LIST_HEAD(&h->cmd_list);
+	INIT_LIST_HEAD(&h->cache_req.chain_list);
 
 	return 0;
 }
diff --git a/iptables/nft.h b/iptables/nft.h
index 50bcc0dfebecf..045393da7c179 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -71,9 +71,16 @@ enum obj_update_type {
 	NFT_COMPAT_TABLE_NEW,
 };
 
+struct cache_chain {
+	struct list_head head;
+	const char *name;
+};
+
 struct nft_cache_req {
 	enum nft_cache_level	level;
 	const char		*table;
+	bool			all_chains;
+	struct list_head	chain_list;
 };
 
 struct nft_handle {
-- 
2.25.1

