Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB61C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Sep 2021 16:06:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A41DA6109E
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Sep 2021 16:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbhIVQIN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Sep 2021 12:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbhIVQIN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Sep 2021 12:08:13 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9DD2C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Sep 2021 09:06:42 -0700 (PDT)
Received: from localhost ([::1]:59546 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mT4lc-0006PA-Jj; Wed, 22 Sep 2021 18:06:40 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/4] nft-chain: Introduce base_slot field
Date:   Wed, 22 Sep 2021 18:06:31 +0200
Message-Id: <20210922160632.15635-4-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210922160632.15635-1-phil@nwl.cc>
References: <20210922160632.15635-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For builtin chains, record the base_chains array slot they are assigned
to. This simplifies removing that reference if they are being deleted
later.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c |  5 +++--
 iptables/nft-chain.h |  1 +
 iptables/nft.c       | 28 +---------------------------
 3 files changed, 5 insertions(+), 29 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index b7f10ab923bc0..43ac291ec84b2 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -226,10 +226,11 @@ nft_cache_add_base_chain(struct nft_handle *h, const struct builtin_table *t,
 	    strcmp(type, bc->type))
 		return -EINVAL;
 
-	if (h->cache->table[t->type].base_chains[hooknum])
+	nc->base_slot = &h->cache->table[t->type].base_chains[hooknum];
+	if (*nc->base_slot)
 		return -EEXIST;
 
-	h->cache->table[t->type].base_chains[hooknum] = nc;
+	*nc->base_slot = nc;
 	return 0;
 }
 
diff --git a/iptables/nft-chain.h b/iptables/nft-chain.h
index 137f4b7f90085..9adf173857420 100644
--- a/iptables/nft-chain.h
+++ b/iptables/nft-chain.h
@@ -9,6 +9,7 @@ struct nft_handle;
 struct nft_chain {
 	struct list_head	head;
 	struct hlist_node	hnode;
+	struct nft_chain	**base_slot;
 	struct nftnl_chain	*nftnl;
 };
 
diff --git a/iptables/nft.c b/iptables/nft.c
index 17e735aa694af..381061473047f 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1838,8 +1838,6 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
 
 struct chain_del_data {
 	struct nft_handle	*handle;
-	struct nft_cache	*cache;
-	enum nft_table_type	type;
 	bool			verbose;
 };
 
@@ -1860,10 +1858,7 @@ static int __nft_chain_del(struct nft_chain *nc, void *data)
 		return -1;
 
 	if (nft_chain_builtin(c)) {
-		uint32_t num = nftnl_chain_get_u32(c, NFTNL_CHAIN_HOOKNUM);
-
-		if (nc == d->cache->table[d->type].base_chains[num])
-			d->cache->table[d->type].base_chains[num] = NULL;
+		*nc->base_slot = NULL;
 	}
 
 	/* nftnl_chain is freed when deleting the batch object */
@@ -1877,7 +1872,6 @@ static int __nft_chain_del(struct nft_chain *nc, void *data)
 int nft_chain_del(struct nft_handle *h, const char *chain,
 		       const char *table, bool verbose)
 {
-	const struct builtin_table *t;
 	struct chain_del_data d = {
 		.handle = h,
 		.verbose = verbose,
@@ -1894,32 +1888,12 @@ int nft_chain_del(struct nft_handle *h, const char *chain,
 			return 0;
 		}
 
-		if (nft_chain_builtin(c->nftnl)) {
-			t = nft_table_builtin_find(h, table);
-			if (!t) {
-				errno = EINVAL;
-				return 0;
-			}
-
-			d.type = t->type;
-			d.cache = h->cache;
-		}
-
 		ret = __nft_chain_del(c, &d);
 		if (ret == -2)
 			errno = EINVAL;
 		goto out;
 	}
 
-	t = nft_table_builtin_find(h, table);
-	if (!t) {
-		errno = EINVAL;
-		return 0;
-	}
-
-	d.type = t->type;
-	d.cache = h->cache;
-
 	if (verbose)
 		nft_cache_sort_chains(h, table);
 
-- 
2.33.0

