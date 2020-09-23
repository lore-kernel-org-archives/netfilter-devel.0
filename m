Return-Path: <SRS0=+Cxx=DA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43132C2D0A8
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Sep 2020 17:37:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE7DF2065E
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Sep 2020 17:37:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgIWRhB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Sep 2020 13:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgIWRhB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Sep 2020 13:37:01 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61855C0613CE
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2020 10:37:01 -0700 (PDT)
Received: from localhost ([::1]:54106 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kL8hP-0003p1-Tw; Wed, 23 Sep 2020 19:37:00 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 02/10] nft: Implement nft_chain_foreach()
Date:   Wed, 23 Sep 2020 19:48:41 +0200
Message-Id: <20200923174849.5773-3-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923174849.5773-1-phil@nwl.cc>
References: <20200923174849.5773-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is just a fancy wrapper around nftnl_chain_list_foreach() with the
added benefit of detecting invalid table names or uninitialized chain
lists. This in turn allows to drop the checks in flush_rule_cache() and
ignore the return code of nft_chain_foreach() as it fails only if the
dropped checks had failed, too.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Extend commit message.
- Drop pointless code from flush_rule_cache().
- Use nft_chain_foreach() in flush_cache() and nft_is_table_compatible()
  also.
---
 iptables/nft-cache.c    | 29 +++++----------
 iptables/nft.c          | 80 +++++++++++++++--------------------------
 iptables/nft.h          |  3 ++
 iptables/xtables-save.c |  7 +---
 4 files changed, 41 insertions(+), 78 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 32cfd6cf0989a..b94766a751db4 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -455,21 +455,16 @@ static int fetch_rule_cache(struct nft_handle *h,
 {
 	int i;
 
-	if (t) {
-		struct nftnl_chain_list *list =
-			h->cache->table[t->type].chains;
-
-		return nftnl_chain_list_foreach(list, nft_rule_list_update, h);
-	}
+	if (t)
+		return nft_chain_foreach(h, t->name, nft_rule_list_update, h);
 
 	for (i = 0; i < NFT_TABLE_MAX; i++) {
-		enum nft_table_type type = h->tables[i].type;
 
 		if (!h->tables[i].name)
 			continue;
 
-		if (nftnl_chain_list_foreach(h->cache->table[type].chains,
-					     nft_rule_list_update, h))
+		if (nft_chain_foreach(h, h->tables[i].name,
+				      nft_rule_list_update, h))
 			return -1;
 	}
 	return 0;
@@ -543,17 +538,11 @@ static int __flush_rule_cache(struct nftnl_chain *c, void *data)
 int flush_rule_cache(struct nft_handle *h, const char *table,
 		     struct nftnl_chain *c)
 {
-	const struct builtin_table *t;
-
 	if (c)
 		return __flush_rule_cache(c, NULL);
 
-	t = nft_table_builtin_find(h, table);
-	if (!t || !h->cache->table[t->type].chains)
-		return 0;
-
-	return nftnl_chain_list_foreach(h->cache->table[t->type].chains,
-					__flush_rule_cache, NULL);
+	nft_chain_foreach(h, table, __flush_rule_cache, NULL);
+	return 0;
 }
 
 static int __flush_chain_cache(struct nftnl_chain *c, void *data)
@@ -582,9 +571,9 @@ static int flush_cache(struct nft_handle *h, struct nft_cache *c,
 		table = nft_table_builtin_find(h, tablename);
 		if (!table)
 			return 0;
-		if (c->table[table->type].chains)
-			nftnl_chain_list_foreach(c->table[table->type].chains,
-						 __flush_chain_cache, NULL);
+
+		nft_chain_foreach(h, tablename, __flush_chain_cache, NULL);
+
 		if (c->table[table->type].sets)
 			nftnl_set_list_foreach(c->table[table->type].sets,
 					       __flush_set_cache, NULL);
diff --git a/iptables/nft.c b/iptables/nft.c
index 669e29d4cf88f..4f40be2e60252 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1589,14 +1589,9 @@ int nft_rule_save(struct nft_handle *h, const char *table, unsigned int format)
 		.h = h,
 		.format = format,
 	};
-	struct nftnl_chain_list *list;
 	int ret;
 
-	list = nft_chain_list_get(h, table, NULL);
-	if (!list)
-		return 0;
-
-	ret = nftnl_chain_list_foreach(list, nft_rule_save_cb, &d);
+	ret = nft_chain_foreach(h, table, nft_rule_save_cb, &d);
 
 	/* the core expects 1 for success and 0 for error */
 	return ret == 0 ? 1 : 0;
@@ -1668,7 +1663,6 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 		.table = table,
 		.verbose = verbose,
 	};
-	struct nftnl_chain_list *list;
 	struct nftnl_chain *c = NULL;
 	int ret = 0;
 
@@ -1694,14 +1688,8 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 		return 1;
 	}
 
-	list = nft_chain_list_get(h, table, chain);
-	if (list == NULL) {
-		ret = 1;
-		goto err;
-	}
+	ret = nft_chain_foreach(h, table, nft_rule_flush_cb, &d);
 
-	ret = nftnl_chain_list_foreach(list, nft_rule_flush_cb, &d);
-err:
 	/* the core expects 1 for success and 0 for error */
 	return ret == 0 ? 1 : 0;
 }
@@ -1824,18 +1812,13 @@ int nft_chain_user_del(struct nft_handle *h, const char *chain,
 		.handle = h,
 		.verbose = verbose,
 	};
-	struct nftnl_chain_list *list;
 	struct nftnl_chain *c;
 	int ret = 0;
 
 	nft_fn = nft_chain_user_del;
 
-	list = nft_chain_list_get(h, table, chain);
-	if (list == NULL)
-		return 0;
-
 	if (chain) {
-		c = nftnl_chain_list_lookup_byname(list, chain);
+		c = nft_chain_find(h, table, chain);
 		if (!c) {
 			errno = ENOENT;
 			return 0;
@@ -1847,7 +1830,7 @@ int nft_chain_user_del(struct nft_handle *h, const char *chain,
 		goto out;
 	}
 
-	ret = nftnl_chain_list_foreach(list, __nft_chain_user_del, &d);
+	ret = nft_chain_foreach(h, table, __nft_chain_user_del, &d);
 out:
 	/* the core expects 1 for success and 0 for error */
 	return ret == 0 ? 1 : 0;
@@ -2377,7 +2360,6 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 		.rulenum = rulenum,
 		.cb = ops->print_rule,
 	};
-	struct nftnl_chain_list *list;
 	struct nftnl_chain *c;
 
 	nft_xt_builtin_init(h, table);
@@ -2397,14 +2379,10 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 		return 1;
 	}
 
-	list = nft_chain_list_get(h, table, chain);
-	if (!list)
-		return 0;
-
 	if (ops->print_table_header)
 		ops->print_table_header(table);
 
-	nftnl_chain_list_foreach(list, nft_rule_list_cb, &d);
+	nft_chain_foreach(h, table, nft_rule_list_cb, &d);
 	return 1;
 }
 
@@ -2415,6 +2393,23 @@ list_save(struct nft_handle *h, struct nftnl_rule *r,
 	nft_rule_print_save(h, r, NFT_RULE_APPEND, format);
 }
 
+int nft_chain_foreach(struct nft_handle *h, const char *table,
+		      int (*cb)(struct nftnl_chain *c, void *data),
+		      void *data)
+{
+	const struct builtin_table *t;
+
+	t = nft_table_builtin_find(h, table);
+	if (!t)
+		return -1;
+
+	if (!h->cache->table[t->type].chains)
+		return -1;
+
+	return nftnl_chain_list_foreach(h->cache->table[t->type].chains,
+					cb, data);
+}
+
 static int nft_rule_list_chain_save(struct nftnl_chain *c, void *data)
 {
 	const char *chain_name = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
@@ -2446,24 +2441,19 @@ int nft_rule_list_save(struct nft_handle *h, const char *chain,
 		.save_fmt = true,
 		.cb = list_save,
 	};
-	struct nftnl_chain_list *list;
 	struct nftnl_chain *c;
 	int ret = 0;
 
 	nft_xt_builtin_init(h, table);
 	nft_assert_table_compatible(h, table, chain);
 
-	list = nft_chain_list_get(h, table, chain);
-	if (!list)
-		return 0;
-
 	if (counters < 0)
 		d.format = FMT_C_COUNTS;
 	else if (counters == 0)
 		d.format = FMT_NOCOUNTS;
 
 	if (chain) {
-		c = nftnl_chain_list_lookup_byname(list, chain);
+		c = nft_chain_find(h, table, chain);
 		if (!c)
 			return 0;
 
@@ -2474,10 +2464,10 @@ int nft_rule_list_save(struct nft_handle *h, const char *chain,
 	}
 
 	/* Dump policies and custom chains first */
-	nftnl_chain_list_foreach(list, nft_rule_list_chain_save, &counters);
+	nft_chain_foreach(h, table, nft_rule_list_chain_save, &counters);
 
 	/* Now dump out rules in this table */
-	ret = nftnl_chain_list_foreach(list, nft_rule_list_cb, &d);
+	ret = nft_chain_foreach(h, table, nft_rule_list_cb, &d);
 	return ret == 0 ? 1 : 0;
 }
 
@@ -3339,7 +3329,6 @@ static int __nft_chain_zero_counters(struct nftnl_chain *c, void *data)
 int nft_chain_zero_counters(struct nft_handle *h, const char *chain,
 			    const char *table, bool verbose)
 {
-	struct nftnl_chain_list *list;
 	struct chain_zero_data d = {
 		.handle = h,
 		.verbose = verbose,
@@ -3347,12 +3336,8 @@ int nft_chain_zero_counters(struct nft_handle *h, const char *chain,
 	struct nftnl_chain *c;
 	int ret = 0;
 
-	list = nft_chain_list_get(h, table, chain);
-	if (list == NULL)
-		goto err;
-
 	if (chain) {
-		c = nftnl_chain_list_lookup_byname(list, chain);
+		c = nft_chain_find(h, table, chain);
 		if (!c) {
 			errno = ENOENT;
 			return 0;
@@ -3362,7 +3347,7 @@ int nft_chain_zero_counters(struct nft_handle *h, const char *chain,
 		goto err;
 	}
 
-	ret = nftnl_chain_list_foreach(list, __nft_chain_zero_counters, &d);
+	ret = nft_chain_foreach(h, table, __nft_chain_zero_counters, &d);
 err:
 	/* the core expects 1 for success and 0 for error */
 	return ret == 0 ? 1 : 0;
@@ -3451,22 +3436,13 @@ static int nft_is_chain_compatible(struct nftnl_chain *c, void *data)
 bool nft_is_table_compatible(struct nft_handle *h,
 			     const char *table, const char *chain)
 {
-	struct nftnl_chain_list *clist;
-
 	if (chain) {
 		struct nftnl_chain *c = nft_chain_find(h, table, chain);
 
 		return c && !nft_is_chain_compatible(c, h);
 	}
 
-	clist = nft_chain_list_get(h, table, chain);
-	if (clist == NULL)
-		return false;
-
-	if (nftnl_chain_list_foreach(clist, nft_is_chain_compatible, h))
-		return false;
-
-	return true;
+	return !nft_chain_foreach(h, table, nft_is_chain_compatible, h);
 }
 
 void nft_assert_table_compatible(struct nft_handle *h,
diff --git a/iptables/nft.h b/iptables/nft.h
index 128e09beb805e..949d9d077f23b 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -151,6 +151,9 @@ const struct builtin_chain *nft_chain_builtin_find(const struct builtin_table *t
 bool nft_chain_exists(struct nft_handle *h, const char *table, const char *chain);
 void nft_bridge_chain_postprocess(struct nft_handle *h,
 				  struct nftnl_chain *c);
+int nft_chain_foreach(struct nft_handle *h, const char *table,
+		      int (*cb)(struct nftnl_chain *c, void *data),
+		      void *data);
 
 
 /*
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 92b0c911c5f1c..bf00b0324cc4f 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -68,7 +68,6 @@ struct do_output_data {
 static int
 __do_output(struct nft_handle *h, const char *tablename, void *data)
 {
-	struct nftnl_chain_list *chain_list;
 	struct do_output_data *d = data;
 	time_t now;
 
@@ -81,10 +80,6 @@ __do_output(struct nft_handle *h, const char *tablename, void *data)
 		return 0;
 	}
 
-	chain_list = nft_chain_list_get(h, tablename, NULL);
-	if (!chain_list)
-		return 0;
-
 	now = time(NULL);
 	printf("# Generated by %s v%s on %s", prog_name,
 	       prog_vers, ctime(&now));
@@ -92,7 +87,7 @@ __do_output(struct nft_handle *h, const char *tablename, void *data)
 	printf("*%s\n", tablename);
 	/* Dump out chain names first,
 	 * thereby preventing dependency conflicts */
-	nftnl_chain_list_foreach(chain_list, nft_chain_save, h);
+	nft_chain_foreach(h, tablename, nft_chain_save, h);
 	nft_rule_save(h, tablename, d->format);
 	if (d->commit)
 		printf("COMMIT\n");
-- 
2.28.0

