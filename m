Return-Path: <SRS0=aLv2=BJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21FA7C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jul 2020 13:57:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F315A20656
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jul 2020 13:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgG3N5M (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Jul 2020 09:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgG3N5L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Jul 2020 09:57:11 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18664C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2020 06:57:11 -0700 (PDT)
Received: from localhost ([::1]:51306 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1k193T-0003Mf-Ol; Thu, 30 Jul 2020 15:57:07 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] nft: Eliminate table list from cache
Date:   Thu, 30 Jul 2020 15:57:10 +0200
Message-Id: <20200730135710.23076-1-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The full list of tables in kernel is not relevant, only those used by
iptables-nft and for those, knowing if they exist or not is sufficient.
For holding that information, the already existing 'table' array in
nft_cache suits well.

Consequently, nft_table_find() merely checks if the new 'exists' boolean
is true or not and nft_for_each_table() iterates over the builtin_table
array in nft_handle, additionally checking the boolean in cache for
whether to skip the entry or not.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 73 +++++++++++---------------------------------
 iptables/nft-cache.h |  9 ------
 iptables/nft.c       | 55 +++++++++------------------------
 iptables/nft.h       |  2 +-
 4 files changed, 34 insertions(+), 105 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index bf1fb346f28fd..c6baf090ae85f 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -107,59 +107,30 @@ static void mnl_genid_get(struct nft_handle *h, uint32_t *genid)
 		      "Could not fetch rule set generation id: %s\n", nft_strerror(errno));
 }
 
-static struct nft_table *nft_table_alloc(void)
-{
-	struct nftnl_table *nftnl;
-	struct nft_table *table;
-
-	table = malloc(sizeof(struct nft_table));
-	if (!table)
-		return NULL;
-
-	nftnl = nftnl_table_alloc();
-	if (!nftnl) {
-		free(table);
-		return NULL;
-	}
-	table->nftnl = nftnl;
-
-	return table;
-}
-
-static void nft_table_free(struct nft_table *table)
+static int nftnl_table_list_cb(const struct nlmsghdr *nlh, void *data)
 {
-	nftnl_table_free(table->nftnl);
-	free(table);
-}
+	struct nftnl_table *nftnl = nftnl_table_alloc();
+	const struct builtin_table *t;
+	struct nft_handle *h = data;
+	const char *name;
 
-static void nft_table_list_free(struct list_head *table_list)
-{
-	struct nft_table *table, *next;
+	if (!nftnl)
+		return MNL_CB_OK;
 
-	list_for_each_entry_safe(table, next, table_list, list) {
-		list_del(&table->list);
-		nft_table_free(table);
-	}
-}
+	if (nftnl_table_nlmsg_parse(nlh, nftnl) < 0)
+		goto out;
 
-static int nftnl_table_list_cb(const struct nlmsghdr *nlh, void *data)
-{
-	struct list_head *list = data;
-	struct nft_table *t;
+	name = nftnl_table_get_str(nftnl, NFTNL_TABLE_NAME);
+	if (!name)
+		goto out;
 
-	t = nft_table_alloc();
+	t = nft_table_builtin_find(h, name);
 	if (!t)
-		goto err;
-
-	if (nftnl_table_nlmsg_parse(nlh, t->nftnl) < 0)
 		goto out;
 
-	list_add_tail(&t->list, list);
-
-	return MNL_CB_OK;
+	h->cache->table[t->type].exists = true;
 out:
-	nft_table_free(t);
-err:
+	nftnl_table_free(nftnl);
 	return MNL_CB_OK;
 }
 
@@ -169,13 +140,10 @@ static int fetch_table_cache(struct nft_handle *h)
 	char buf[16536];
 	int i, ret;
 
-	if (!list_empty(&h->cache->tables))
-		return 0;
-
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, h->family,
 					NLM_F_DUMP, h->seq);
 
-	ret = mnl_talk(h, nlh, nftnl_table_list_cb, &h->cache->tables);
+	ret = mnl_talk(h, nlh, nftnl_table_list_cb, h);
 	if (ret < 0 && errno == EINTR)
 		assert(nft_restart(h) >= 0);
 
@@ -635,9 +603,9 @@ static int flush_cache(struct nft_handle *h, struct nft_cache *c,
 			nftnl_set_list_free(c->table[i].sets);
 			c->table[i].sets = NULL;
 		}
+
+		c->table[i].exists = false;
 	}
-	if (!list_empty(&c->tables))
-		nft_table_list_free(&c->tables);
 
 	return 1;
 }
@@ -710,11 +678,6 @@ void nft_release_cache(struct nft_handle *h)
 	}
 }
 
-struct list_head *nft_table_list_get(struct nft_handle *h)
-{
-	return &h->cache->tables;
-}
-
 struct nftnl_set_list *
 nft_set_list_get(struct nft_handle *h, const char *table, const char *set)
 {
diff --git a/iptables/nft-cache.h b/iptables/nft-cache.h
index aeab4bdef904d..76f9fbb6c8ccc 100644
--- a/iptables/nft-cache.h
+++ b/iptables/nft-cache.h
@@ -1,8 +1,6 @@
 #ifndef _NFT_CACHE_H_
 #define _NFT_CACHE_H_
 
-#include <libiptc/linux_list.h>
-
 struct nft_handle;
 struct nft_cmd;
 
@@ -19,12 +17,5 @@ struct nftnl_chain_list *
 nft_chain_list_get(struct nft_handle *h, const char *table, const char *chain);
 struct nftnl_set_list *
 nft_set_list_get(struct nft_handle *h, const char *table, const char *set);
-struct list_head *nft_table_list_get(struct nft_handle *h);
-
-struct nft_table {
-	struct list_head        list;
-	struct nftnl_table      *nftnl;
-};
-
 
 #endif /* _NFT_CACHE_H_ */
diff --git a/iptables/nft.c b/iptables/nft.c
index 634d02fed25b1..76fd7edd11177 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -842,8 +842,6 @@ int nft_init(struct nft_handle *h, int family, const struct builtin_table *t)
 	INIT_LIST_HEAD(&h->obj_list);
 	INIT_LIST_HEAD(&h->err_list);
 	INIT_LIST_HEAD(&h->cmd_list);
-	INIT_LIST_HEAD(&h->__cache[0].tables);
-	INIT_LIST_HEAD(&h->__cache[1].tables);
 	INIT_LIST_HEAD(&h->cache_req.chain_list);
 
 	return 0;
@@ -1943,39 +1941,26 @@ int nft_chain_user_rename(struct nft_handle *h,const char *chain,
 
 bool nft_table_find(struct nft_handle *h, const char *tablename)
 {
-	struct list_head *list;
-	struct nft_table *t;
-	bool ret = false;
-
-	list = nft_table_list_get(h);
-
-	list_for_each_entry(t, list, list) {
-		const char *this_tablename =
-			nftnl_table_get(t->nftnl, NFTNL_TABLE_NAME);
-
-		if (strcmp(tablename, this_tablename) == 0) {
-			ret = true;
-			break;
-		}
-	}
+	const struct builtin_table *t;
 
-	return ret;
+	t = nft_table_builtin_find(h, tablename);
+	return t ? h->cache->table[t->type].exists : false;
 }
 
 int nft_for_each_table(struct nft_handle *h,
 		       int (*func)(struct nft_handle *h, const char *tablename, void *data),
 		       void *data)
 {
-	struct list_head *list;
-	struct nft_table *t;
+	int i;
 
-	list = nft_table_list_get(h);
+	for (i = 0; i < NFT_TABLE_MAX; i++) {
+		if (h->tables[i].name == NULL)
+			continue;
 
-	list_for_each_entry(t, list, list) {
-		const char *tablename =
-			nftnl_table_get(t->nftnl, NFTNL_TABLE_NAME);
+		if (!h->cache->table[h->tables[i].type].exists)
+			continue;
 
-		func(h, tablename, data);
+		func(h, h->tables[i].name, data);
 	}
 
 	return 0;
@@ -2013,26 +1998,16 @@ static int __nft_table_flush(struct nft_handle *h, const char *table, bool exist
 
 int nft_table_flush(struct nft_handle *h, const char *table)
 {
-	struct list_head *list;
-	struct nft_table *t;
-	bool exists = false;
+	const struct builtin_table *t;
 	int ret = 0;
 
 	nft_fn = nft_table_flush;
 
-	list = nft_table_list_get(h);
-
-	list_for_each_entry(t, list, list) {
-		const char *table_name =
-			nftnl_table_get_str(t->nftnl, NFTNL_TABLE_NAME);
-
-		if (strcmp(table_name, table) == 0) {
-			exists = true;
-			break;
-		}
-	}
+	t = nft_table_builtin_find(h, table);
+	if (!t)
+		return 0;
 
-	ret = __nft_table_flush(h, table, exists);
+	ret = __nft_table_flush(h, table, h->cache->table[t->type].exists);
 
 	/* the core expects 1 for success and 0 for error */
 	return ret == 0 ? 1 : 0;
diff --git a/iptables/nft.h b/iptables/nft.h
index b2175958bfcd6..f38f5812be771 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -38,11 +38,11 @@ enum nft_cache_level {
 };
 
 struct nft_cache {
-	struct list_head		tables;
 	struct {
 		struct nftnl_chain_list *chains;
 		struct nftnl_set_list	*sets;
 		bool			initialized;
+		bool			exists;
 	} table[NFT_TABLE_MAX];
 };
 
-- 
2.27.0

