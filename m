Return-Path: <SRS0=+Cxx=DA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 042FFC4727D
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Sep 2020 17:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1FF92065E
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Sep 2020 17:37:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgIWRhj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Sep 2020 13:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbgIWRhj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Sep 2020 13:37:39 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB06C0613CE
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2020 10:37:39 -0700 (PDT)
Received: from localhost ([::1]:54148 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kL8i1-0003r6-Ud; Wed, 23 Sep 2020 19:37:37 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 04/10] nft: Eliminate nft_chain_list_get()
Date:   Wed, 23 Sep 2020 19:48:43 +0200
Message-Id: <20200923174849.5773-5-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923174849.5773-1-phil@nwl.cc>
References: <20200923174849.5773-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since introduction of nft_cache_add_chain(), there is merely a single
user of nft_chain_list_get() left. Hence fold the function into its
caller.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 13 -------------
 iptables/nft-cache.h |  2 --
 iptables/nft.c       |  8 +++++---
 3 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index a22e693320451..109524c3fbc79 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -684,16 +684,3 @@ nft_set_list_get(struct nft_handle *h, const char *table, const char *set)
 
 	return h->cache->table[t->type].sets;
 }
-
-struct nftnl_chain_list *
-nft_chain_list_get(struct nft_handle *h, const char *table, const char *chain)
-{
-	const struct builtin_table *t;
-
-	t = nft_table_builtin_find(h, table);
-	if (!t)
-		return NULL;
-
-	return h->cache->table[t->type].chains;
-}
-
diff --git a/iptables/nft-cache.h b/iptables/nft-cache.h
index d97f8de255f02..52ad2d396199e 100644
--- a/iptables/nft-cache.h
+++ b/iptables/nft-cache.h
@@ -16,8 +16,6 @@ void nft_cache_build(struct nft_handle *h);
 int nft_cache_add_chain(struct nft_handle *h, const struct builtin_table *t,
 			struct nftnl_chain *c);
 
-struct nftnl_chain_list *
-nft_chain_list_get(struct nft_handle *h, const char *table, const char *chain);
 struct nftnl_set_list *
 nft_set_list_get(struct nft_handle *h, const char *table, const char *set);
 
diff --git a/iptables/nft.c b/iptables/nft.c
index 8e1a33ba69bf1..5967d36038953 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1837,13 +1837,15 @@ out:
 static struct nftnl_chain *
 nft_chain_find(struct nft_handle *h, const char *table, const char *chain)
 {
+	const struct builtin_table *t;
 	struct nftnl_chain_list *list;
 
-	list = nft_chain_list_get(h, table, chain);
-	if (list == NULL)
+	t = nft_table_builtin_find(h, table);
+	if (!t)
 		return NULL;
 
-	return nftnl_chain_list_lookup_byname(list, chain);
+	list = h->cache->table[t->type].chains;
+	return list ? nftnl_chain_list_lookup_byname(list, chain) : NULL;
 }
 
 bool nft_chain_exists(struct nft_handle *h,
-- 
2.28.0

