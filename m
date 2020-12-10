Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D254C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Dec 2020 13:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7C9023D39
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Dec 2020 13:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389077AbgLJNHe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Dec 2020 08:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729355AbgLJNHe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Dec 2020 08:07:34 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CFEC0617A6
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Dec 2020 05:06:46 -0800 (PST)
Received: from localhost ([::1]:40984 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1knLef-0000ga-7x; Thu, 10 Dec 2020 14:06:45 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 6/9] nft: Introduce a dedicated base chain array
Date:   Thu, 10 Dec 2020 14:06:33 +0100
Message-Id: <20201210130636.26379-7-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201210130636.26379-1-phil@nwl.cc>
References: <20201210130636.26379-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Preparing for sorted chain output, introduce a per-table array holding
base chains indexed by nf_inet_hooks value. Since the latter is ordered
correctly, iterating over the array will return base chains in expected
order.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 34 +++++++++++++++++++++++++++++++++-
 iptables/nft.c       | 12 +++++++++++-
 iptables/nft.h       |  1 +
 3 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index f62e5100cd67b..bd19b6dfc4d8a 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -208,7 +208,24 @@ int nft_cache_add_chain(struct nft_handle *h, const struct builtin_table *t,
 	const char *cname = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
 	struct nft_chain *nc = nft_chain_alloc(c);
 
-	list_add_tail(&nc->head, &h->cache->table[t->type].chains->list);
+	if (nftnl_chain_is_set(c, NFTNL_CHAIN_HOOKNUM)) {
+		uint32_t hooknum = nftnl_chain_get_u32(c, NFTNL_CHAIN_HOOKNUM);
+
+		if (hooknum >= NF_INET_NUMHOOKS) {
+			nft_chain_free(nc);
+			return -EINVAL;
+		}
+
+		if (h->cache->table[t->type].base_chains[hooknum]) {
+			nft_chain_free(nc);
+			return -EEXIST;
+		}
+
+		h->cache->table[t->type].base_chains[hooknum] = nc;
+	} else {
+		list_add_tail(&nc->head,
+			      &h->cache->table[t->type].chains->list);
+	}
 	hlist_add_head(&nc->hnode, chain_name_hlist(h, t, cname));
 	return 0;
 }
@@ -609,6 +626,19 @@ static int __flush_set_cache(struct nftnl_set *s, void *data)
 	return 0;
 }
 
+static void flush_base_chain_cache(struct nft_chain **base_chains)
+{
+	int i;
+
+	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
+		if (!base_chains[i])
+			continue;
+		hlist_del(&base_chains[i]->hnode);
+		nft_chain_free(base_chains[i]);
+		base_chains[i] = NULL;
+	}
+}
+
 static int flush_cache(struct nft_handle *h, struct nft_cache *c,
 		       const char *tablename)
 {
@@ -620,6 +650,7 @@ static int flush_cache(struct nft_handle *h, struct nft_cache *c,
 		if (!table)
 			return 0;
 
+		flush_base_chain_cache(c->table[table->type].base_chains);
 		nft_chain_foreach(h, tablename, __flush_chain_cache, NULL);
 
 		if (c->table[table->type].sets)
@@ -632,6 +663,7 @@ static int flush_cache(struct nft_handle *h, struct nft_cache *c,
 		if (h->tables[i].name == NULL)
 			continue;
 
+		flush_base_chain_cache(c->table[i].base_chains);
 		if (c->table[i].chains) {
 			nft_chain_list_free(c->table[i].chains);
 			c->table[i].chains = NULL;
diff --git a/iptables/nft.c b/iptables/nft.c
index 1b7400050c0ed..4187e691d8926 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2396,12 +2396,22 @@ int nft_chain_foreach(struct nft_handle *h, const char *table,
 	const struct builtin_table *t;
 	struct nft_chain_list *list;
 	struct nft_chain *c, *c_bak;
-	int ret;
+	int i, ret;
 
 	t = nft_table_builtin_find(h, table);
 	if (!t)
 		return -1;
 
+	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
+		c = h->cache->table[t->type].base_chains[i];
+		if (!c)
+			continue;
+
+		ret = cb(c, data);
+		if (ret < 0)
+			return ret;
+	}
+
 	list = h->cache->table[t->type].chains;
 	if (!list)
 		return -1;
diff --git a/iptables/nft.h b/iptables/nft.h
index ac227b4c6c581..1a2506eea7b6c 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -40,6 +40,7 @@ enum nft_cache_level {
 
 struct nft_cache {
 	struct {
+		struct nft_chain	*base_chains[NF_INET_NUMHOOKS];
 		struct nft_chain_list	*chains;
 		struct nftnl_set_list	*sets;
 		bool			exists;
-- 
2.28.0

