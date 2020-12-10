Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 036A2C4361B
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Dec 2020 13:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B83B923D39
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Dec 2020 13:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389072AbgLJNHL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Dec 2020 08:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388970AbgLJNHL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Dec 2020 08:07:11 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF486C061793
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Dec 2020 05:06:30 -0800 (PST)
Received: from localhost ([::1]:40966 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1knLeP-0000gF-Bm; Thu, 10 Dec 2020 14:06:29 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 2/9] nft: cache: Introduce nft_cache_add_chain()
Date:   Thu, 10 Dec 2020 14:06:29 +0100
Message-Id: <20201210130636.26379-3-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201210130636.26379-1-phil@nwl.cc>
References: <20201210130636.26379-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a convenience function for adding a chain to cache, for now just
a simple wrapper around nftnl_chain_list_add_tail().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 12 +++++++++---
 iptables/nft-cache.h |  3 +++
 iptables/nft.c       | 16 +++++++---------
 3 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 32cfd6cf0989a..afa655d73bc63 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -165,6 +165,13 @@ static int fetch_table_cache(struct nft_handle *h)
 	return 1;
 }
 
+int nft_cache_add_chain(struct nft_handle *h, const struct builtin_table *t,
+			struct nftnl_chain *c)
+{
+	nftnl_chain_list_add_tail(c, h->cache->table[t->type].chains);
+	return 0;
+}
+
 struct nftnl_chain_list_cb_data {
 	struct nft_handle *h;
 	const struct builtin_table *t;
@@ -174,7 +181,6 @@ static int nftnl_chain_list_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nftnl_chain_list_cb_data *d = data;
 	const struct builtin_table *t = d->t;
-	struct nftnl_chain_list *list;
 	struct nft_handle *h = d->h;
 	struct nftnl_chain *c;
 	const char *tname;
@@ -196,8 +202,8 @@ static int nftnl_chain_list_cb(const struct nlmsghdr *nlh, void *data)
 		goto out;
 	}
 
-	list = h->cache->table[t->type].chains;
-	nftnl_chain_list_add_tail(c, list);
+	if (nft_cache_add_chain(h, t, c))
+		goto out;
 
 	return MNL_CB_OK;
 out:
diff --git a/iptables/nft-cache.h b/iptables/nft-cache.h
index 76f9fbb6c8ccc..d97f8de255f02 100644
--- a/iptables/nft-cache.h
+++ b/iptables/nft-cache.h
@@ -3,6 +3,7 @@
 
 struct nft_handle;
 struct nft_cmd;
+struct builtin_table;
 
 void nft_cache_level_set(struct nft_handle *h, int level,
 			 const struct nft_cmd *cmd);
@@ -12,6 +13,8 @@ void flush_chain_cache(struct nft_handle *h, const char *tablename);
 int flush_rule_cache(struct nft_handle *h, const char *table,
 		     struct nftnl_chain *c);
 void nft_cache_build(struct nft_handle *h);
+int nft_cache_add_chain(struct nft_handle *h, const struct builtin_table *t,
+			struct nftnl_chain *c);
 
 struct nftnl_chain_list *
 nft_chain_list_get(struct nft_handle *h, const char *table, const char *chain);
diff --git a/iptables/nft.c b/iptables/nft.c
index 24e49db4ab919..d1f6d417785b6 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -697,7 +697,7 @@ static void nft_chain_builtin_add(struct nft_handle *h,
 		return;
 
 	batch_chain_add(h, NFT_COMPAT_CHAIN_ADD, c);
-	nftnl_chain_list_add_tail(c, h->cache->table[table->type].chains);
+	nft_cache_add_chain(h, table, c);
 }
 
 /* find if built-in table already exists */
@@ -1712,7 +1712,7 @@ err:
 
 int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *table)
 {
-	struct nftnl_chain_list *list;
+	const struct builtin_table *t;
 	struct nftnl_chain *c;
 
 	nft_fn = nft_chain_user_add;
@@ -1736,9 +1736,8 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
 	if (!batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c))
 		return 0;
 
-	list = nft_chain_list_get(h, table, chain);
-	if (list)
-		nftnl_chain_list_add(c, list);
+	t = nft_table_builtin_find(h, table);
+	nft_cache_add_chain(h, t, c);
 
 	/* the core expects 1 for success and 0 for error */
 	return 1;
@@ -1746,7 +1745,7 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
 
 int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table)
 {
-	struct nftnl_chain_list *list;
+	const struct builtin_table *t;
 	struct obj_update *obj;
 	struct nftnl_chain *c;
 	bool created = false;
@@ -1763,9 +1762,8 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
 		nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, chain);
 		created = true;
 
-		list = nft_chain_list_get(h, table, chain);
-		if (list)
-			nftnl_chain_list_add(c, list);
+		t = nft_table_builtin_find(h, table);
+		nft_cache_add_chain(h, t, c);
 	} else {
 		/* If the chain should vanish meanwhile, kernel genid changes
 		 * and the transaction is refreshed enabling the chain add
-- 
2.28.0

