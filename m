Return-Path: <SRS0=5odi=AW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B696C433E7
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E02E206F4
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgGKKTb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Jul 2020 06:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgGKKTa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Jul 2020 06:19:30 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94986C08C5DD
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Jul 2020 03:19:30 -0700 (PDT)
Received: from localhost ([::1]:59460 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1juCbQ-0007Gp-QH; Sat, 11 Jul 2020 12:19:29 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 13/18] nft: Implement nft_chain_foreach()
Date:   Sat, 11 Jul 2020 12:18:26 +0200
Message-Id: <20200711101831.29506-14-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200711101831.29506-1-phil@nwl.cc>
References: <20200711101831.29506-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is just a fancy wrapper around nftnl_chain_list_foreach() for now.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c    | 16 +++-------
 iptables/nft.c          | 69 ++++++++++++++++-------------------------
 iptables/nft.h          |  3 ++
 iptables/xtables-save.c |  7 +----
 4 files changed, 36 insertions(+), 59 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index f8bb2d09c6434..b897dffb696c1 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -471,21 +471,16 @@ static int fetch_rule_cache(struct nft_handle *h,
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
@@ -568,8 +563,7 @@ int flush_rule_cache(struct nft_handle *h, const char *table,
 	if (!t || !h->cache->table[t->type].chains)
 		return 0;
 
-	return nftnl_chain_list_foreach(h->cache->table[t->type].chains,
-					__flush_rule_cache, NULL);
+	return nft_chain_foreach(h, table, __flush_rule_cache, NULL);
 }
 
 static int __flush_chain_cache(struct nftnl_chain *c, void *data)
diff --git a/iptables/nft.c b/iptables/nft.c
index a5d026e6faa36..b2fa3abee6d4a 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1608,14 +1608,9 @@ int nft_rule_save(struct nft_handle *h, const char *table, unsigned int format)
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
@@ -1687,7 +1682,6 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 		.table = table,
 		.verbose = verbose,
 	};
-	struct nftnl_chain_list *list;
 	struct nftnl_chain *c = NULL;
 	int ret = 0;
 
@@ -1713,14 +1707,8 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
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
@@ -1843,18 +1831,13 @@ int nft_chain_user_del(struct nft_handle *h, const char *chain,
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
@@ -1866,7 +1849,7 @@ int nft_chain_user_del(struct nft_handle *h, const char *chain,
 		goto out;
 	}
 
-	ret = nftnl_chain_list_foreach(list, __nft_chain_user_del, &d);
+	ret = nft_chain_foreach(h, table, __nft_chain_user_del, &d);
 out:
 	/* the core expects 1 for success and 0 for error */
 	return ret == 0 ? 1 : 0;
@@ -2459,7 +2442,6 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 		.rulenum = rulenum,
 		.cb = ops->print_rule,
 	};
-	struct nftnl_chain_list *list;
 	struct nftnl_chain *c;
 
 	nft_xt_builtin_init(h, table);
@@ -2479,14 +2461,10 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
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
 
@@ -2497,6 +2475,23 @@ list_save(struct nft_handle *h, struct nftnl_rule *r,
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
@@ -2528,24 +2523,19 @@ int nft_rule_list_save(struct nft_handle *h, const char *chain,
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
 
@@ -2556,10 +2546,10 @@ int nft_rule_list_save(struct nft_handle *h, const char *chain,
 	}
 
 	/* Dump policies and custom chains first */
-	nftnl_chain_list_foreach(list, nft_rule_list_chain_save, &counters);
+	nft_chain_foreach(h, table, nft_rule_list_chain_save, &counters);
 
 	/* Now dump out rules in this table */
-	ret = nftnl_chain_list_foreach(list, nft_rule_list_cb, &d);
+	ret = nft_chain_foreach(h, table, nft_rule_list_cb, &d);
 	return ret == 0 ? 1 : 0;
 }
 
@@ -3421,7 +3411,6 @@ static int __nft_chain_zero_counters(struct nftnl_chain *c, void *data)
 int nft_chain_zero_counters(struct nft_handle *h, const char *chain,
 			    const char *table, bool verbose)
 {
-	struct nftnl_chain_list *list;
 	struct chain_zero_data d = {
 		.handle = h,
 		.verbose = verbose,
@@ -3429,12 +3418,8 @@ int nft_chain_zero_counters(struct nft_handle *h, const char *chain,
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
@@ -3444,7 +3429,7 @@ int nft_chain_zero_counters(struct nft_handle *h, const char *chain,
 		goto err;
 	}
 
-	ret = nftnl_chain_list_foreach(list, __nft_chain_zero_counters, &d);
+	ret = nft_chain_foreach(h, table, __nft_chain_zero_counters, &d);
 err:
 	/* the core expects 1 for success and 0 for error */
 	return ret == 0 ? 1 : 0;
diff --git a/iptables/nft.h b/iptables/nft.h
index 247255ac9e3c5..2fe58e7f06d3f 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -152,6 +152,9 @@ const struct builtin_chain *nft_chain_builtin_find(const struct builtin_table *t
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
2.27.0

