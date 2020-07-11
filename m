Return-Path: <SRS0=5odi=AW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4865C433E1
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C192206F4
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgGKKSm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Jul 2020 06:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgGKKSm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Jul 2020 06:18:42 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13057C08C5DD
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Jul 2020 03:18:42 -0700 (PDT)
Received: from localhost ([::1]:59406 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1juCae-0007Cu-2h; Sat, 11 Jul 2020 12:18:40 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 14/18] nft: cache: Introduce nft_cache_add_chain()
Date:   Sat, 11 Jul 2020 12:18:27 +0200
Message-Id: <20200711101831.29506-15-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200711101831.29506-1-phil@nwl.cc>
References: <20200711101831.29506-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a convenience function for adding a chain to cache, for now just
a simple wrapper around nftnl_chain_list_add_tail().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 12 +++++++++---
 iptables/nft-cache.h |  3 +++
 iptables/nft.c       | 14 ++++++--------
 3 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index b897dffb696c1..26771df63bcc2 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -181,6 +181,13 @@ static int fetch_table_cache(struct nft_handle *h)
 	return ret;
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
@@ -190,7 +197,6 @@ static int nftnl_chain_list_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nftnl_chain_list_cb_data *d = data;
 	const struct builtin_table *t = d->t;
-	struct nftnl_chain_list *list;
 	struct nft_handle *h = d->h;
 	struct nftnl_chain *c;
 	const char *tname;
@@ -212,8 +218,8 @@ static int nftnl_chain_list_cb(const struct nlmsghdr *nlh, void *data)
 		goto out;
 	}
 
-	list = h->cache->table[t->type].chains;
-	nftnl_chain_list_add_tail(c, list);
+	if (nft_cache_add_chain(h, t, c))
+		goto out;
 
 	return MNL_CB_OK;
 out:
diff --git a/iptables/nft-cache.h b/iptables/nft-cache.h
index f429118041be4..d47f7ab6095d9 100644
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
index b2fa3abee6d4a..be1275f3357a2 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1715,7 +1715,7 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 
 int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *table)
 {
-	struct nftnl_chain_list *list;
+	const struct builtin_table *t;
 	struct nftnl_chain *c;
 	int ret;
 
@@ -1739,9 +1739,8 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
 
 	ret = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c);
 
-	list = nft_chain_list_get(h, table, chain);
-	if (list)
-		nftnl_chain_list_add(c, list);
+	t = nft_table_builtin_find(h, table);
+	nft_cache_add_chain(h, t, c);
 
 	/* the core expects 1 for success and 0 for error */
 	return ret == 0 ? 1 : 0;
@@ -1749,7 +1748,7 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
 
 int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table)
 {
-	struct nftnl_chain_list *list;
+	const struct builtin_table *t;
 	struct nftnl_chain *c;
 	bool created = false;
 	int ret;
@@ -1781,9 +1780,8 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
 
 	ret = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c);
 
-	list = nft_chain_list_get(h, table, chain);
-	if (list)
-		nftnl_chain_list_add(c, list);
+	t = nft_table_builtin_find(h, table);
+	nft_cache_add_chain(h, t, c);
 
 	/* the core expects 1 for success and 0 for error */
 	return ret == 0 ? 1 : 0;
-- 
2.27.0

