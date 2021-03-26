Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4633C433DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Mar 2021 14:37:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BA4A61A18
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Mar 2021 14:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhCZOgr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Mar 2021 10:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbhCZOg0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Mar 2021 10:36:26 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE85AC0613AA
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Mar 2021 07:36:25 -0700 (PDT)
Received: from localhost ([::1]:50728 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lPnZY-0000CQ-7J; Fri, 26 Mar 2021 15:36:24 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] nft: cache: Sort chains on demand only
Date:   Fri, 26 Mar 2021 15:36:15 +0100
Message-Id: <20210326143615.7996-1-phil@nwl.cc>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Mandatory sorted insert of chains into cache significantly slows down
restoring of large rulesets. Since the sorted list of user-defined
chains is needed for listing and verbose output only, introduce
nft_cache_sort_chains() and call it where needed.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c    | 71 +++++++++++++++++++++++++++++++++--------
 iptables/nft-cache.h    |  1 +
 iptables/nft.c          | 12 +++++++
 iptables/nft.h          |  1 +
 iptables/xtables-save.c |  1 +
 5 files changed, 73 insertions(+), 13 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 6b6e6da40a826..8fbf9727826d8 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -223,24 +223,67 @@ int nft_cache_add_chain(struct nft_handle *h, const struct builtin_table *t,
 
 		h->cache->table[t->type].base_chains[hooknum] = nc;
 	} else {
-		struct nft_chain_list *clist = h->cache->table[t->type].chains;
-		struct list_head *pos = &clist->list;
-		struct nft_chain *cur;
-		const char *n;
-
-		list_for_each_entry(cur, &clist->list, head) {
-			n = nftnl_chain_get_str(cur->nftnl, NFTNL_CHAIN_NAME);
-			if (strcmp(cname, n) <= 0) {
-				pos = &cur->head;
-				break;
-			}
-		}
-		list_add_tail(&nc->head, pos);
+		list_add_tail(&nc->head,
+			      &h->cache->table[t->type].chains->list);
 	}
 	hlist_add_head(&nc->hnode, chain_name_hlist(h, t, cname));
 	return 0;
 }
 
+static void __nft_chain_list_sort(struct list_head *list,
+				  int (*cmp)(struct nft_chain *a,
+					     struct nft_chain *b))
+{
+	struct nft_chain *pivot, *cur, *sav;
+	LIST_HEAD(sublist);
+
+	if (list_empty(list))
+		return;
+
+	/* grab first item as pivot (dividing) value */
+	pivot = list_entry(list->next, struct nft_chain, head);
+	list_del(&pivot->head);
+
+	/* move any smaller value into sublist */
+	list_for_each_entry_safe(cur, sav, list, head) {
+		if (cmp(pivot, cur) > 0) {
+			list_del(&cur->head);
+			list_add_tail(&cur->head, &sublist);
+		}
+	}
+	/* conquer divided */
+	__nft_chain_list_sort(&sublist, cmp);
+	__nft_chain_list_sort(list, cmp);
+
+	/* merge divided and pivot again */
+	list_add_tail(&pivot->head, &sublist);
+	list_splice(&sublist, list);
+}
+
+static int nft_chain_cmp_byname(struct nft_chain *a, struct nft_chain *b)
+{
+	const char *aname = nftnl_chain_get_str(a->nftnl, NFTNL_CHAIN_NAME);
+	const char *bname = nftnl_chain_get_str(b->nftnl, NFTNL_CHAIN_NAME);
+
+	return strcmp(aname, bname);
+}
+
+int nft_cache_sort_chains(struct nft_handle *h, const char *table)
+{
+	const struct builtin_table *t = nft_table_builtin_find(h, table);
+
+	if (!t)
+		return -1;
+
+	if (h->cache->table[t->type].sorted)
+		return 0;
+
+	__nft_chain_list_sort(&h->cache->table[t->type].chains->list,
+			      nft_chain_cmp_byname);
+	h->cache->table[t->type].sorted = true;
+	return 0;
+}
+
 struct nftnl_chain_list_cb_data {
 	struct nft_handle *h;
 	const struct builtin_table *t;
@@ -663,6 +706,7 @@ static int flush_cache(struct nft_handle *h, struct nft_cache *c,
 
 		flush_base_chain_cache(c->table[table->type].base_chains);
 		nft_chain_foreach(h, tablename, __flush_chain_cache, NULL);
+		c->table[table->type].sorted = false;
 
 		if (c->table[table->type].sets)
 			nftnl_set_list_foreach(c->table[table->type].sets,
@@ -678,6 +722,7 @@ static int flush_cache(struct nft_handle *h, struct nft_cache *c,
 		if (c->table[i].chains) {
 			nft_chain_list_free(c->table[i].chains);
 			c->table[i].chains = NULL;
+			c->table[i].sorted = false;
 		}
 
 		if (c->table[i].sets) {
diff --git a/iptables/nft-cache.h b/iptables/nft-cache.h
index 20d96beede876..58a015265056c 100644
--- a/iptables/nft-cache.h
+++ b/iptables/nft-cache.h
@@ -16,6 +16,7 @@ int flush_rule_cache(struct nft_handle *h, const char *table,
 void nft_cache_build(struct nft_handle *h);
 int nft_cache_add_chain(struct nft_handle *h, const struct builtin_table *t,
 			struct nftnl_chain *c);
+int nft_cache_sort_chains(struct nft_handle *h, const char *table);
 
 struct nft_chain *
 nft_chain_find(struct nft_handle *h, const char *table, const char *chain);
diff --git a/iptables/nft.c b/iptables/nft.c
index bde4ca72d3fcc..8b14daeaed610 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1754,6 +1754,8 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 		return 1;
 	}
 
+	nft_cache_sort_chains(h, table);
+
 	ret = nft_chain_foreach(h, table, nft_rule_flush_cb, &d);
 
 	/* the core expects 1 for success and 0 for error */
@@ -1900,6 +1902,9 @@ int nft_chain_user_del(struct nft_handle *h, const char *chain,
 		goto out;
 	}
 
+	if (verbose)
+		nft_cache_sort_chains(h, table);
+
 	ret = nft_chain_foreach(h, table, __nft_chain_user_del, &d);
 out:
 	/* the core expects 1 for success and 0 for error */
@@ -2437,6 +2442,8 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 		return 1;
 	}
 
+	nft_cache_sort_chains(h, table);
+
 	if (ops->print_table_header)
 		ops->print_table_header(table);
 
@@ -2540,6 +2547,8 @@ int nft_rule_list_save(struct nft_handle *h, const char *chain,
 		return nft_rule_list_cb(c, &d);
 	}
 
+	nft_cache_sort_chains(h, table);
+
 	/* Dump policies and custom chains first */
 	nft_chain_foreach(h, table, nft_rule_list_chain_save, &counters);
 
@@ -3431,6 +3440,9 @@ int nft_chain_zero_counters(struct nft_handle *h, const char *chain,
 		goto err;
 	}
 
+	if (verbose)
+		nft_cache_sort_chains(h, table);
+
 	ret = nft_chain_foreach(h, table, __nft_chain_zero_counters, &d);
 err:
 	/* the core expects 1 for success and 0 for error */
diff --git a/iptables/nft.h b/iptables/nft.h
index 0910f82a2773c..4ac7e0099d567 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -44,6 +44,7 @@ struct nft_cache {
 		struct nft_chain_list	*chains;
 		struct nftnl_set_list	*sets;
 		bool			exists;
+		bool			sorted;
 	} table[NFT_TABLE_MAX];
 };
 
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index d7901c650ea70..cfce0472f3ee8 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -87,6 +87,7 @@ __do_output(struct nft_handle *h, const char *tablename, void *data)
 	printf("*%s\n", tablename);
 	/* Dump out chain names first,
 	 * thereby preventing dependency conflicts */
+	nft_cache_sort_chains(h, tablename);
 	nft_chain_foreach(h, tablename, nft_chain_save, h);
 	nft_rule_save(h, tablename, d->format);
 	if (d->commit)
-- 
2.31.0

