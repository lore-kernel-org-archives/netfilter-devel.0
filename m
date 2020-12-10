Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F2F6C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Dec 2020 13:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD65A23D39
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Dec 2020 13:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388926AbgLJNHs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Dec 2020 08:07:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388780AbgLJNHs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Dec 2020 08:07:48 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12D9C0617B0
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Dec 2020 05:07:02 -0800 (PST)
Received: from localhost ([::1]:41002 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1knLev-0000gs-2d; Thu, 10 Dec 2020 14:07:01 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 5/9] nft: Introduce struct nft_chain
Date:   Thu, 10 Dec 2020 14:06:32 +0100
Message-Id: <20201210130636.26379-6-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201210130636.26379-1-phil@nwl.cc>
References: <20201210130636.26379-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Preparing for ordered output of user-defined chains, introduce a local
datatype wrapping nftnl_chain. In order to maintain the chain name hash
table, introduce nft_chain_list as well and use it instead of
nftnl_chain_list.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/Makefile.am |   2 +-
 iptables/nft-cache.c |  61 +++++++++++++++++------
 iptables/nft-cache.h |   5 +-
 iptables/nft-chain.c |  59 ++++++++++++++++++++++
 iptables/nft-chain.h |  29 +++++++++++
 iptables/nft.c       | 115 ++++++++++++++++++++++++++-----------------
 iptables/nft.h       |   7 +--
 7 files changed, 212 insertions(+), 66 deletions(-)
 create mode 100644 iptables/nft-chain.c
 create mode 100644 iptables/nft-chain.h

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 4bf5742c9dc95..f789521042f87 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -38,7 +38,7 @@ xtables_nft_multi_SOURCES += xtables-save.c xtables-restore.c \
 				nft-shared.c nft-ipv4.c nft-ipv6.c nft-arp.c \
 				xtables-monitor.c nft-cache.c \
 				xtables-arp-standalone.c xtables-arp.c \
-				nft-bridge.c nft-cmd.c \
+				nft-bridge.c nft-cmd.c nft-chain.c \
 				xtables-eb-standalone.c xtables-eb.c \
 				xtables-eb-translate.c \
 				xtables-translate.c
diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 929fa0fa152c1..f62e5100cd67b 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -24,6 +24,7 @@
 
 #include "nft.h"
 #include "nft-cache.h"
+#include "nft-chain.h"
 
 static void cache_chain_list_insert(struct list_head *list, const char *name)
 {
@@ -153,9 +154,7 @@ static int fetch_table_cache(struct nft_handle *h)
 		if (!h->tables[i].name)
 			continue;
 
-		h->cache->table[type].chains = nftnl_chain_list_alloc();
-		if (!h->cache->table[type].chains)
-			return 0;
+		h->cache->table[type].chains = nft_chain_list_alloc();
 
 		h->cache->table[type].sets = nftnl_set_list_alloc();
 		if (!h->cache->table[type].sets)
@@ -165,24 +164,52 @@ static int fetch_table_cache(struct nft_handle *h)
 	return 1;
 }
 
-struct nftnl_chain *
+static uint32_t djb_hash(const char *key)
+{
+	uint32_t i, hash = 5381;
+
+	for (i = 0; i < strlen(key); i++)
+		hash = ((hash << 5) + hash) + key[i];
+
+	return hash;
+}
+
+static struct hlist_head *chain_name_hlist(struct nft_handle *h,
+					   const struct builtin_table *t,
+					   const char *chain)
+{
+	int key = djb_hash(chain) % CHAIN_NAME_HSIZE;
+
+	return &h->cache->table[t->type].chains->names[key];
+}
+
+struct nft_chain *
 nft_chain_find(struct nft_handle *h, const char *table, const char *chain)
 {
 	const struct builtin_table *t;
-	struct nftnl_chain_list *list;
+	struct hlist_node *node;
+	struct nft_chain *c;
 
 	t = nft_table_builtin_find(h, table);
 	if (!t)
 		return NULL;
 
-	list = h->cache->table[t->type].chains;
-	return list ? nftnl_chain_list_lookup_byname(list, chain) : NULL;
+	hlist_for_each_entry(c, node, chain_name_hlist(h, t, chain), hnode) {
+		if (!strcmp(nftnl_chain_get_str(c->nftnl, NFTNL_CHAIN_NAME),
+			    chain))
+			return c;
+	}
+	return NULL;
 }
 
 int nft_cache_add_chain(struct nft_handle *h, const struct builtin_table *t,
 			struct nftnl_chain *c)
 {
-	nftnl_chain_list_add_tail(c, h->cache->table[t->type].chains);
+	const char *cname = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
+	struct nft_chain *nc = nft_chain_alloc(c);
+
+	list_add_tail(&nc->head, &h->cache->table[t->type].chains->list);
+	hlist_add_head(&nc->hnode, chain_name_hlist(h, t, cname));
 	return 0;
 }
 
@@ -434,8 +461,9 @@ static int nftnl_rule_list_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-static int nft_rule_list_update(struct nftnl_chain *c, void *data)
+static int nft_rule_list_update(struct nft_chain *nc, void *data)
 {
+	struct nftnl_chain *c = nc->nftnl;
 	struct nft_handle *h = data;
 	char buf[16536];
 	struct nlmsghdr *nlh;
@@ -550,13 +578,13 @@ static int ____flush_rule_cache(struct nftnl_rule *r, void *data)
 	return 0;
 }
 
-static int __flush_rule_cache(struct nftnl_chain *c, void *data)
+static int __flush_rule_cache(struct nft_chain *c, void *data)
 {
-	return nftnl_rule_foreach(c, ____flush_rule_cache, NULL);
+	return nftnl_rule_foreach(c->nftnl, ____flush_rule_cache, NULL);
 }
 
 int flush_rule_cache(struct nft_handle *h, const char *table,
-		     struct nftnl_chain *c)
+		     struct nft_chain *c)
 {
 	if (c)
 		return __flush_rule_cache(c, NULL);
@@ -565,10 +593,10 @@ int flush_rule_cache(struct nft_handle *h, const char *table,
 	return 0;
 }
 
-static int __flush_chain_cache(struct nftnl_chain *c, void *data)
+static int __flush_chain_cache(struct nft_chain *c, void *data)
 {
-	nftnl_chain_list_del(c);
-	nftnl_chain_free(c);
+	nft_chain_list_del(c);
+	nft_chain_free(c);
 
 	return 0;
 }
@@ -605,9 +633,10 @@ static int flush_cache(struct nft_handle *h, struct nft_cache *c,
 			continue;
 
 		if (c->table[i].chains) {
-			nftnl_chain_list_free(c->table[i].chains);
+			nft_chain_list_free(c->table[i].chains);
 			c->table[i].chains = NULL;
 		}
+
 		if (c->table[i].sets) {
 			nftnl_set_list_free(c->table[i].sets);
 			c->table[i].sets = NULL;
diff --git a/iptables/nft-cache.h b/iptables/nft-cache.h
index 085594c26457b..20d96beede876 100644
--- a/iptables/nft-cache.h
+++ b/iptables/nft-cache.h
@@ -2,6 +2,7 @@
 #define _NFT_CACHE_H_
 
 struct nft_handle;
+struct nft_chain;
 struct nft_cmd;
 struct builtin_table;
 
@@ -11,12 +12,12 @@ void nft_rebuild_cache(struct nft_handle *h);
 void nft_release_cache(struct nft_handle *h);
 void flush_chain_cache(struct nft_handle *h, const char *tablename);
 int flush_rule_cache(struct nft_handle *h, const char *table,
-		     struct nftnl_chain *c);
+		     struct nft_chain *c);
 void nft_cache_build(struct nft_handle *h);
 int nft_cache_add_chain(struct nft_handle *h, const struct builtin_table *t,
 			struct nftnl_chain *c);
 
-struct nftnl_chain *
+struct nft_chain *
 nft_chain_find(struct nft_handle *h, const char *table, const char *chain);
 
 struct nftnl_set_list *
diff --git a/iptables/nft-chain.c b/iptables/nft-chain.c
new file mode 100644
index 0000000000000..e954170fa7312
--- /dev/null
+++ b/iptables/nft-chain.c
@@ -0,0 +1,59 @@
+/*
+ * Copyright (c) 2020  Red Hat GmbH.  Author: Phil Sutter <phil@nwl.cc>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <stdlib.h>
+#include <xtables.h>
+
+#include "nft-chain.h"
+
+struct nft_chain *nft_chain_alloc(struct nftnl_chain *nftnl)
+{
+	struct nft_chain *c = xtables_malloc(sizeof(*c));
+
+	INIT_LIST_HEAD(&c->head);
+	c->nftnl = nftnl;
+
+	return c;
+}
+
+void nft_chain_free(struct nft_chain *c)
+{
+	if (c->nftnl)
+		nftnl_chain_free(c->nftnl);
+	free(c);
+}
+
+struct nft_chain_list *nft_chain_list_alloc(void)
+{
+	struct nft_chain_list *list = xtables_malloc(sizeof(*list));
+	int i;
+
+	INIT_LIST_HEAD(&list->list);
+	for (i = 0; i < CHAIN_NAME_HSIZE; i++)
+		INIT_HLIST_HEAD(&list->names[i]);
+
+	return list;
+}
+
+void nft_chain_list_del(struct nft_chain *c)
+{
+	list_del(&c->head);
+	hlist_del(&c->hnode);
+}
+
+void nft_chain_list_free(struct nft_chain_list *list)
+{
+	struct nft_chain *c, *c2;
+
+	list_for_each_entry_safe(c, c2, &list->list, head) {
+		nft_chain_list_del(c);
+		nft_chain_free(c);
+	}
+	free(list);
+}
diff --git a/iptables/nft-chain.h b/iptables/nft-chain.h
new file mode 100644
index 0000000000000..137f4b7f90085
--- /dev/null
+++ b/iptables/nft-chain.h
@@ -0,0 +1,29 @@
+#ifndef _NFT_CHAIN_H_
+#define _NFT_CHAIN_H_
+
+#include <libnftnl/chain.h>
+#include <libiptc/linux_list.h>
+
+struct nft_handle;
+
+struct nft_chain {
+	struct list_head	head;
+	struct hlist_node	hnode;
+	struct nftnl_chain	*nftnl;
+};
+
+#define CHAIN_NAME_HSIZE	512
+
+struct nft_chain_list {
+	struct list_head	list;
+	struct hlist_head	names[CHAIN_NAME_HSIZE];
+};
+
+struct nft_chain *nft_chain_alloc(struct nftnl_chain *nftnl);
+void nft_chain_free(struct nft_chain *c);
+
+struct nft_chain_list *nft_chain_list_alloc(void);
+void nft_chain_list_free(struct nft_chain_list *list);
+void nft_chain_list_del(struct nft_chain *c);
+
+#endif /* _NFT_CHAIN_H_ */
diff --git a/iptables/nft.c b/iptables/nft.c
index 9b40b3c3b9631..1b7400050c0ed 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1388,7 +1388,7 @@ int
 nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 		struct nftnl_rule *r, struct nftnl_rule *ref, bool verbose)
 {
-	struct nftnl_chain *c;
+	struct nft_chain *c;
 	int type;
 
 	nft_xt_builtin_init(h, table);
@@ -1418,7 +1418,7 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 			errno = ENOENT;
 			return 0;
 		}
-		nftnl_chain_rule_add_tail(r, c);
+		nftnl_chain_rule_add_tail(r, c->nftnl);
 	}
 
 	return 1;
@@ -1540,8 +1540,9 @@ static const char *policy_name[NF_ACCEPT+1] = {
 	[NF_ACCEPT] = "ACCEPT",
 };
 
-int nft_chain_save(struct nftnl_chain *c, void *data)
+int nft_chain_save(struct nft_chain *nc, void *data)
 {
+	struct nftnl_chain *c = nc->nftnl;
 	struct nft_handle *h = data;
 	const char *policy = NULL;
 
@@ -1564,13 +1565,13 @@ struct nft_rule_save_data {
 	unsigned int format;
 };
 
-static int nft_rule_save_cb(struct nftnl_chain *c, void *data)
+static int nft_rule_save_cb(struct nft_chain *c, void *data)
 {
 	struct nft_rule_save_data *d = data;
 	struct nftnl_rule_iter *iter;
 	struct nftnl_rule *r;
 
-	iter = nftnl_rule_iter_create(c);
+	iter = nftnl_rule_iter_create(c->nftnl);
 	if (iter == NULL)
 		return 1;
 
@@ -1645,9 +1646,9 @@ struct nft_rule_flush_data {
 	bool verbose;
 };
 
-static int nft_rule_flush_cb(struct nftnl_chain *c, void *data)
+static int nft_rule_flush_cb(struct nft_chain *c, void *data)
 {
-	const char *chain = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
+	const char *chain = nftnl_chain_get_str(c->nftnl, NFTNL_CHAIN_NAME);
 	struct nft_rule_flush_data *d = data;
 
 	batch_chain_flush(d->h, d->table, chain);
@@ -1664,7 +1665,7 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 		.table = table,
 		.verbose = verbose,
 	};
-	struct nftnl_chain *c = NULL;
+	struct nft_chain *c = NULL;
 	int ret = 0;
 
 	nft_fn = nft_rule_flush;
@@ -1733,12 +1734,13 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
 	const struct builtin_table *t;
 	struct obj_update *obj;
 	struct nftnl_chain *c;
+	struct nft_chain *nc;
 	bool created = false;
 
 	nft_xt_builtin_init(h, table);
 
-	c = nft_chain_find(h, table, chain);
-	if (!c) {
+	nc = nft_chain_find(h, table, chain);
+	if (!nc) {
 		c = nftnl_chain_alloc();
 		if (!c)
 			return 0;
@@ -1750,6 +1752,8 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
 		t = nft_table_builtin_find(h, table);
 		nft_cache_add_chain(h, t, c);
 	} else {
+		c = nc->nftnl;
+
 		/* If the chain should vanish meanwhile, kernel genid changes
 		 * and the transaction is refreshed enabling the chain add
 		 * object. With the handle still set, kernel interprets it as a
@@ -1781,9 +1785,10 @@ struct chain_user_del_data {
 	int			builtin_err;
 };
 
-static int __nft_chain_user_del(struct nftnl_chain *c, void *data)
+static int __nft_chain_user_del(struct nft_chain *nc, void *data)
 {
 	struct chain_user_del_data *d = data;
+	struct nftnl_chain *c = nc->nftnl;
 	struct nft_handle *h = d->handle;
 
 	/* don't delete built-in chain */
@@ -1794,12 +1799,17 @@ static int __nft_chain_user_del(struct nftnl_chain *c, void *data)
 		fprintf(stdout, "Deleting chain `%s'\n",
 			nftnl_chain_get_str(c, NFTNL_CHAIN_NAME));
 
+
 	/* XXX This triggers a fast lookup from the kernel. */
 	nftnl_chain_unset(c, NFTNL_CHAIN_HANDLE);
 	if (!batch_chain_add(h, NFT_COMPAT_CHAIN_USER_DEL, c))
 		return -1;
 
-	nftnl_chain_list_del(c);
+	/* nftnl_chain is freed when deleting the batch object */
+	nc->nftnl = NULL;
+
+	nft_chain_list_del(nc);
+	nft_chain_free(nc);
 	return 0;
 }
 
@@ -1810,7 +1820,7 @@ int nft_chain_user_del(struct nft_handle *h, const char *chain,
 		.handle = h,
 		.verbose = verbose,
 	};
-	struct nftnl_chain *c;
+	struct nft_chain *c;
 	int ret = 0;
 
 	nft_fn = nft_chain_user_del;
@@ -1853,6 +1863,7 @@ int nft_chain_user_rename(struct nft_handle *h,const char *chain,
 			  const char *table, const char *newname)
 {
 	struct nftnl_chain *c;
+	struct nft_chain *nc;
 	uint64_t handle;
 
 	nft_fn = nft_chain_user_rename;
@@ -1863,12 +1874,12 @@ int nft_chain_user_rename(struct nft_handle *h,const char *chain,
 	}
 
 	/* Find the old chain to be renamed */
-	c = nft_chain_find(h, table, chain);
-	if (c == NULL) {
+	nc = nft_chain_find(h, table, chain);
+	if (nc == NULL) {
 		errno = ENOENT;
 		return 0;
 	}
-	handle = nftnl_chain_get_u64(c, NFTNL_CHAIN_HANDLE);
+	handle = nftnl_chain_get_u64(nc->nftnl, NFTNL_CHAIN_HANDLE);
 
 	/* Now prepare the new name for the chain */
 	c = nftnl_chain_alloc();
@@ -2017,9 +2028,10 @@ out:
 }
 
 static struct nftnl_rule *
-nft_rule_find(struct nft_handle *h, struct nftnl_chain *c,
+nft_rule_find(struct nft_handle *h, struct nft_chain *nc,
 	      struct nftnl_rule *rule, int rulenum)
 {
+	struct nftnl_chain *c = nc->nftnl;
 	struct nftnl_rule *r;
 	struct nftnl_rule_iter *iter;
 	bool found = false;
@@ -2048,8 +2060,8 @@ nft_rule_find(struct nft_handle *h, struct nftnl_chain *c,
 int nft_rule_check(struct nft_handle *h, const char *chain,
 		   const char *table, struct nftnl_rule *rule, bool verbose)
 {
-	struct nftnl_chain *c;
 	struct nftnl_rule *r;
+	struct nft_chain *c;
 
 	nft_fn = nft_rule_check;
 
@@ -2074,8 +2086,8 @@ int nft_rule_delete(struct nft_handle *h, const char *chain,
 		    const char *table, struct nftnl_rule *rule, bool verbose)
 {
 	int ret = 0;
-	struct nftnl_chain *c;
 	struct nftnl_rule *r;
+	struct nft_chain *c;
 
 	nft_fn = nft_rule_delete;
 
@@ -2135,7 +2147,7 @@ int nft_rule_insert(struct nft_handle *h, const char *chain,
 		    bool verbose)
 {
 	struct nftnl_rule *r = NULL;
-	struct nftnl_chain *c;
+	struct nft_chain *c;
 
 	nft_xt_builtin_init(h, table);
 
@@ -2170,7 +2182,7 @@ int nft_rule_insert(struct nft_handle *h, const char *chain,
 	if (r)
 		nftnl_chain_rule_insert_at(new_rule, r);
 	else
-		nftnl_chain_rule_add(new_rule, c);
+		nftnl_chain_rule_add(new_rule, c->nftnl);
 
 	return 1;
 err:
@@ -2181,8 +2193,8 @@ int nft_rule_delete_num(struct nft_handle *h, const char *chain,
 			const char *table, int rulenum, bool verbose)
 {
 	int ret = 0;
-	struct nftnl_chain *c;
 	struct nftnl_rule *r;
+	struct nft_chain *c;
 
 	nft_fn = nft_rule_delete_num;
 
@@ -2209,8 +2221,8 @@ int nft_rule_replace(struct nft_handle *h, const char *chain,
 		     int rulenum, bool verbose)
 {
 	int ret = 0;
-	struct nftnl_chain *c;
 	struct nftnl_rule *r;
+	struct nft_chain *c;
 
 	nft_fn = nft_rule_replace;
 
@@ -2289,8 +2301,9 @@ static int nft_rule_count(struct nft_handle *h, struct nftnl_chain *c)
 }
 
 static void __nft_print_header(struct nft_handle *h,
-			       struct nftnl_chain *c, unsigned int format)
+			       struct nft_chain *nc, unsigned int format)
 {
+	struct nftnl_chain *c = nc->nftnl;
 	const char *chain_name = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
 	bool basechain = !!nftnl_chain_get(c, NFTNL_CHAIN_HOOKNUM);
 	uint32_t refs = nftnl_chain_get_u32(c, NFTNL_CHAIN_USE);
@@ -2318,7 +2331,7 @@ struct nft_rule_list_cb_data {
 		   unsigned int num, unsigned int format);
 };
 
-static int nft_rule_list_cb(struct nftnl_chain *c, void *data)
+static int nft_rule_list_cb(struct nft_chain *c, void *data)
 {
 	struct nft_rule_list_cb_data *d = data;
 
@@ -2330,7 +2343,7 @@ static int nft_rule_list_cb(struct nftnl_chain *c, void *data)
 		__nft_print_header(d->h, c, d->format);
 	}
 
-	return __nft_rule_list(d->h, c, d->rulenum, d->format, d->cb);
+	return __nft_rule_list(d->h, c->nftnl, d->rulenum, d->format, d->cb);
 }
 
 int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
@@ -2343,7 +2356,7 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 		.rulenum = rulenum,
 		.cb = ops->print_rule,
 	};
-	struct nftnl_chain *c;
+	struct nft_chain *c;
 
 	nft_xt_builtin_init(h, table);
 	nft_assert_table_compatible(h, table, chain);
@@ -2377,24 +2390,33 @@ list_save(struct nft_handle *h, struct nftnl_rule *r,
 }
 
 int nft_chain_foreach(struct nft_handle *h, const char *table,
-		      int (*cb)(struct nftnl_chain *c, void *data),
+		      int (*cb)(struct nft_chain *c, void *data),
 		      void *data)
 {
 	const struct builtin_table *t;
+	struct nft_chain_list *list;
+	struct nft_chain *c, *c_bak;
+	int ret;
 
 	t = nft_table_builtin_find(h, table);
 	if (!t)
 		return -1;
 
-	if (!h->cache->table[t->type].chains)
+	list = h->cache->table[t->type].chains;
+	if (!list)
 		return -1;
 
-	return nftnl_chain_list_foreach(h->cache->table[t->type].chains,
-					cb, data);
+	list_for_each_entry_safe(c, c_bak, &list->list, head) {
+		ret = cb(c, data);
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
 }
 
-static int nft_rule_list_chain_save(struct nftnl_chain *c, void *data)
+static int nft_rule_list_chain_save(struct nft_chain *nc, void *data)
 {
+	struct nftnl_chain *c = nc->nftnl;
 	const char *chain_name = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
 	uint32_t policy = nftnl_chain_get_u32(c, NFTNL_CHAIN_POLICY);
 	int *counters = data;
@@ -2424,7 +2446,7 @@ int nft_rule_list_save(struct nft_handle *h, const char *chain,
 		.save_fmt = true,
 		.cb = list_save,
 	};
-	struct nftnl_chain *c;
+	struct nft_chain *c;
 	int ret = 0;
 
 	nft_xt_builtin_init(h, table);
@@ -2459,7 +2481,7 @@ int nft_rule_zero_counters(struct nft_handle *h, const char *chain,
 {
 	struct iptables_command_state cs = {};
 	struct nftnl_rule *r, *new_rule;
-	struct nftnl_chain *c;
+	struct nft_chain *c;
 	int ret = 0;
 
 	nft_fn = nft_rule_delete;
@@ -2601,7 +2623,7 @@ static void batch_obj_del(struct nft_handle *h, struct obj_update *o)
 static void nft_refresh_transaction(struct nft_handle *h)
 {
 	const char *tablename, *chainname;
-	const struct nftnl_chain *c;
+	const struct nft_chain *c;
 	struct obj_update *n, *tmp;
 	bool exists;
 
@@ -2898,7 +2920,7 @@ err_free_rule:
 int ebt_set_user_chain_policy(struct nft_handle *h, const char *table,
 			      const char *chain, const char *policy)
 {
-	struct nftnl_chain *c = nft_chain_find(h, table, chain);
+	struct nft_chain *c = nft_chain_find(h, table, chain);
 	int pval;
 
 	if (!c)
@@ -2913,14 +2935,15 @@ int ebt_set_user_chain_policy(struct nft_handle *h, const char *table,
 	else
 		return 0;
 
-	nftnl_chain_set_u32(c, NFTNL_CHAIN_POLICY, pval);
+	nftnl_chain_set_u32(c->nftnl, NFTNL_CHAIN_POLICY, pval);
 	return 1;
 }
 
 static void nft_bridge_commit_prepare(struct nft_handle *h)
 {
 	const struct builtin_table *t;
-	struct nftnl_chain_list *list;
+	struct nft_chain_list *list;
+	struct nft_chain *c;
 	int i;
 
 	for (i = 0; i < NFT_TABLE_MAX; i++) {
@@ -2933,7 +2956,9 @@ static void nft_bridge_commit_prepare(struct nft_handle *h)
 		if (!list)
 			continue;
 
-		nftnl_chain_list_foreach(list, ebt_add_policy_rule, h);
+		list_for_each_entry(c, &list->list, head) {
+			ebt_add_policy_rule(c->nftnl, h);
+		}
 	}
 }
 
@@ -3241,8 +3266,9 @@ struct chain_zero_data {
 	bool			verbose;
 };
 
-static int __nft_chain_zero_counters(struct nftnl_chain *c, void *data)
+static int __nft_chain_zero_counters(struct nft_chain *nc, void *data)
 {
+	struct nftnl_chain *c = nc->nftnl;
 	struct chain_zero_data *d = data;
 	struct nft_handle *h = d->handle;
 	struct nftnl_rule_iter *iter;
@@ -3250,7 +3276,7 @@ static int __nft_chain_zero_counters(struct nftnl_chain *c, void *data)
 
 	if (d->verbose)
 		fprintf(stdout, "Zeroing chain `%s'\n",
-			nftnl_chain_get_str(c, NFTNL_CHAIN_NAME));
+		        nftnl_chain_get_str(c, NFTNL_CHAIN_NAME));
 
 	if (nftnl_chain_is_set(c, NFTNL_CHAIN_HOOKNUM)) {
 		/* zero base chain counters. */
@@ -3319,7 +3345,7 @@ int nft_chain_zero_counters(struct nft_handle *h, const char *chain,
 		.handle = h,
 		.verbose = verbose,
 	};
-	struct nftnl_chain *c;
+	struct nft_chain *c;
 	int ret = 0;
 
 	if (chain) {
@@ -3383,8 +3409,9 @@ static int nft_is_rule_compatible(struct nftnl_rule *rule, void *data)
 	return nftnl_expr_foreach(rule, nft_is_expr_compatible, NULL);
 }
 
-static int nft_is_chain_compatible(struct nftnl_chain *c, void *data)
+static int nft_is_chain_compatible(struct nft_chain *nc, void *data)
 {
+	struct nftnl_chain *c = nc->nftnl;
 	const struct builtin_table *table;
 	const struct builtin_chain *chain;
 	const char *tname, *cname, *type;
@@ -3423,7 +3450,7 @@ bool nft_is_table_compatible(struct nft_handle *h,
 			     const char *table, const char *chain)
 {
 	if (chain) {
-		struct nftnl_chain *c = nft_chain_find(h, table, chain);
+		struct nft_chain *c = nft_chain_find(h, table, chain);
 
 		return c && !nft_is_chain_compatible(c, h);
 	}
diff --git a/iptables/nft.h b/iptables/nft.h
index 949d9d077f23b..ac227b4c6c581 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -4,6 +4,7 @@
 #include "xshared.h"
 #include "nft-shared.h"
 #include "nft-cache.h"
+#include "nft-chain.h"
 #include "nft-cmd.h"
 #include <libiptc/linux_list.h>
 
@@ -39,7 +40,7 @@ enum nft_cache_level {
 
 struct nft_cache {
 	struct {
-		struct nftnl_chain_list *chains;
+		struct nft_chain_list	*chains;
 		struct nftnl_set_list	*sets;
 		bool			exists;
 	} table[NFT_TABLE_MAX];
@@ -141,7 +142,7 @@ const struct builtin_table *nft_table_builtin_find(struct nft_handle *h, const c
 struct nftnl_chain;
 
 int nft_chain_set(struct nft_handle *h, const char *table, const char *chain, const char *policy, const struct xt_counters *counters);
-int nft_chain_save(struct nftnl_chain *c, void *data);
+int nft_chain_save(struct nft_chain *c, void *data);
 int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *table);
 int nft_chain_user_del(struct nft_handle *h, const char *chain, const char *table, bool verbose);
 int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table);
@@ -152,7 +153,7 @@ bool nft_chain_exists(struct nft_handle *h, const char *table, const char *chain
 void nft_bridge_chain_postprocess(struct nft_handle *h,
 				  struct nftnl_chain *c);
 int nft_chain_foreach(struct nft_handle *h, const char *table,
-		      int (*cb)(struct nftnl_chain *c, void *data),
+		      int (*cb)(struct nft_chain *c, void *data),
 		      void *data);
 
 
-- 
2.28.0

