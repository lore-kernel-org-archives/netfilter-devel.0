Return-Path: <SRS0=+Cxx=DA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D448EC2D0A8
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Sep 2020 17:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8602F2065E
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Sep 2020 17:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgIWRhe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Sep 2020 13:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbgIWRhe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Sep 2020 13:37:34 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16304C0613CE
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2020 10:37:34 -0700 (PDT)
Received: from localhost ([::1]:54142 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kL8hw-0003qo-M2; Wed, 23 Sep 2020 19:37:32 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 05/10] nft: cache: Move nft_chain_find() over
Date:   Wed, 23 Sep 2020 19:48:44 +0200
Message-Id: <20200923174849.5773-6-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923174849.5773-1-phil@nwl.cc>
References: <20200923174849.5773-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It is basically just a cache lookup, hence fits better in here.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 14 ++++++++++++++
 iptables/nft-cache.h |  3 +++
 iptables/nft.c       | 17 -----------------
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 109524c3fbc79..929fa0fa152c1 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -165,6 +165,20 @@ static int fetch_table_cache(struct nft_handle *h)
 	return 1;
 }
 
+struct nftnl_chain *
+nft_chain_find(struct nft_handle *h, const char *table, const char *chain)
+{
+	const struct builtin_table *t;
+	struct nftnl_chain_list *list;
+
+	t = nft_table_builtin_find(h, table);
+	if (!t)
+		return NULL;
+
+	list = h->cache->table[t->type].chains;
+	return list ? nftnl_chain_list_lookup_byname(list, chain) : NULL;
+}
+
 int nft_cache_add_chain(struct nft_handle *h, const struct builtin_table *t,
 			struct nftnl_chain *c)
 {
diff --git a/iptables/nft-cache.h b/iptables/nft-cache.h
index 52ad2d396199e..085594c26457b 100644
--- a/iptables/nft-cache.h
+++ b/iptables/nft-cache.h
@@ -16,6 +16,9 @@ void nft_cache_build(struct nft_handle *h);
 int nft_cache_add_chain(struct nft_handle *h, const struct builtin_table *t,
 			struct nftnl_chain *c);
 
+struct nftnl_chain *
+nft_chain_find(struct nft_handle *h, const char *table, const char *chain);
+
 struct nftnl_set_list *
 nft_set_list_get(struct nft_handle *h, const char *table, const char *set);
 
diff --git a/iptables/nft.c b/iptables/nft.c
index 5967d36038953..4d6a41fabfaa6 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -736,9 +736,6 @@ nft_chain_builtin_find(const struct builtin_table *t, const char *chain)
 	return found ? &t->chains[i] : NULL;
 }
 
-static struct nftnl_chain *
-nft_chain_find(struct nft_handle *h, const char *table, const char *chain);
-
 static void nft_chain_builtin_init(struct nft_handle *h,
 				   const struct builtin_table *table)
 {
@@ -1834,20 +1831,6 @@ out:
 	return ret == 0 ? 1 : 0;
 }
 
-static struct nftnl_chain *
-nft_chain_find(struct nft_handle *h, const char *table, const char *chain)
-{
-	const struct builtin_table *t;
-	struct nftnl_chain_list *list;
-
-	t = nft_table_builtin_find(h, table);
-	if (!t)
-		return NULL;
-
-	list = h->cache->table[t->type].chains;
-	return list ? nftnl_chain_list_lookup_byname(list, chain) : NULL;
-}
-
 bool nft_chain_exists(struct nft_handle *h,
 		      const char *table, const char *chain)
 {
-- 
2.28.0

