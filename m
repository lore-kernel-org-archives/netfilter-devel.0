Return-Path: <SRS0=+tY6=XU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C680FC432C2
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9854A2054F
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfIYV00 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:26:26 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45800 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726146AbfIYV00 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 17:26:26 -0400
Received: from localhost ([::1]:58890 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iDEnp-0005Cc-0Q; Wed, 25 Sep 2019 23:26:25 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 11/24] nft: Support nft_chain_list_get() per chain
Date:   Wed, 25 Sep 2019 23:25:52 +0200
Message-Id: <20190925212605.1005-12-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190925212605.1005-1-phil@nwl.cc>
References: <20190925212605.1005-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Accept an optional chain name to specifically search for. In most cases,
the full list is not interesting, so make use of kernel's ability to
return only a specific chain.

To avoid duplicate chains in tables' chain lists, add the chain to cache
only if it doesn't exist already in the list. Despite the overhead this
causes, it is still better this way than introducing a routine which
bypasses the cache entirely: Many iptables commands support operating on
either a single or on all chains of a table. This code layout reflects
that by accepting a possibly NULL chain name pointer.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c             | 40 +++++++++++++++++++++++---------------
 iptables/nft.h             |  3 ++-
 iptables/xtables-restore.c |  2 +-
 iptables/xtables-save.c    |  2 +-
 4 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index f116b940b41fd..904068a6404a6 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -750,7 +750,7 @@ nft_chain_builtin_find(const struct builtin_table *t, const char *chain)
 static void nft_chain_builtin_init(struct nft_handle *h,
 				   const struct builtin_table *table)
 {
-	struct nftnl_chain_list *list = nft_chain_list_get(h, table->name);
+	struct nftnl_chain_list *list = nft_chain_list_get(h, table->name, NULL);
 	struct nftnl_chain *c;
 	int i;
 
@@ -1361,9 +1361,10 @@ static int nftnl_chain_list_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nftnl_chain_list_cb_data *d = data;
 	const struct builtin_table *t = d->t;
+	struct nftnl_chain_list *list;
 	struct nft_handle *h = d->h;
+	const char *tname, *cname;
 	struct nftnl_chain *c;
-	const char *tname;
 
 	c = nftnl_chain_alloc();
 	if (c == NULL)
@@ -1382,7 +1383,13 @@ static int nftnl_chain_list_cb(const struct nlmsghdr *nlh, void *data)
 	if (!t)
 		goto out;
 
-	nftnl_chain_list_add_tail(c, h->cache->table[t->type].chains);
+	list = h->cache->table[t->type].chains;
+	cname = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
+
+	if (nftnl_chain_list_lookup_byname(list, cname))
+		goto out;
+
+	nftnl_chain_list_add_tail(c, list);
 
 	return MNL_CB_OK;
 out:
@@ -1712,7 +1719,8 @@ static void nft_release_cache(struct nft_handle *h)
 }
 
 struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
-					    const char *table)
+					    const char *table,
+					    const char *chain)
 {
 	const struct builtin_table *t;
 
@@ -1720,8 +1728,8 @@ struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
 	if (!t)
 		return NULL;
 
-	if (!h->have_cache && !h->cache->table[t->type].chains)
-		fetch_chain_cache(h, t, NULL);
+	if (!h->have_cache)
+		fetch_chain_cache(h, t, chain);
 
 	return h->cache->table[t->type].chains;
 }
@@ -1802,7 +1810,7 @@ int nft_rule_save(struct nft_handle *h, const char *table, unsigned int format)
 	struct nftnl_chain *c;
 	int ret = 0;
 
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, NULL);
 	if (!list)
 		return 0;
 
@@ -1864,7 +1872,7 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 
 	nft_fn = nft_rule_flush;
 
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, chain);
 	if (list == NULL) {
 		ret = 1;
 		goto err;
@@ -1929,7 +1937,7 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
 
 	ret = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c);
 
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, NULL);
 	if (list)
 		nftnl_chain_list_add(c, list);
 
@@ -1969,7 +1977,7 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
 
 	ret = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c);
 
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, NULL);
 	if (list)
 		nftnl_chain_list_add(c, list);
 
@@ -2028,7 +2036,7 @@ int nft_chain_user_del(struct nft_handle *h, const char *chain,
 
 	nft_fn = nft_chain_user_del;
 
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, chain);
 	if (list == NULL)
 		return 0;
 
@@ -2056,7 +2064,7 @@ nft_chain_find(struct nft_handle *h, const char *table, const char *chain)
 {
 	struct nftnl_chain_list *list;
 
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, chain);
 	if (list == NULL)
 		return NULL;
 
@@ -2602,7 +2610,7 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 	if (!nft_is_table_compatible(h, table))
 		xtables_error(OTHER_PROBLEM, "table `%s' is incompatible, use 'nft' tool.\n", table);
 
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, chain);
 	if (!list)
 		return 0;
 
@@ -2703,7 +2711,7 @@ int nft_rule_list_save(struct nft_handle *h, const char *chain,
 	if (!nft_is_table_compatible(h, table))
 		xtables_error(OTHER_PROBLEM, "table `%s' is incompatible, use 'nft' tool.\n", table);
 
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, chain);
 	if (!list)
 		return 0;
 
@@ -3387,7 +3395,7 @@ int nft_chain_zero_counters(struct nft_handle *h, const char *chain,
 	struct nftnl_chain *c;
 	int ret = 0;
 
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, chain);
 	if (list == NULL)
 		goto err;
 
@@ -3495,7 +3503,7 @@ bool nft_is_table_compatible(struct nft_handle *h, const char *tablename)
 {
 	struct nftnl_chain_list *clist;
 
-	clist = nft_chain_list_get(h, tablename);
+	clist = nft_chain_list_get(h, tablename, NULL);
 	if (clist == NULL)
 		return false;
 
diff --git a/iptables/nft.h b/iptables/nft.h
index bcac8e228c787..ae9b1a88ae175 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -96,7 +96,8 @@ struct nftnl_chain;
 
 int nft_chain_set(struct nft_handle *h, const char *table, const char *chain, const char *policy, const struct xt_counters *counters);
 struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
-					    const char *table);
+					    const char *table,
+					    const char *chain);
 int nft_chain_save(struct nft_handle *h, struct nftnl_chain_list *list);
 int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *table);
 int nft_chain_user_del(struct nft_handle *h, const char *chain, const char *table, bool verbose);
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 7f28a05c68619..c04d7292e0045 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -62,7 +62,7 @@ static struct nftnl_chain_list *get_chain_list(struct nft_handle *h,
 {
 	struct nftnl_chain_list *chain_list;
 
-	chain_list = nft_chain_list_get(h, table);
+	chain_list = nft_chain_list_get(h, table, NULL);
 	if (chain_list == NULL)
 		xtables_error(OTHER_PROBLEM, "cannot retrieve chain list\n");
 
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 77b13f7ffbcdd..503ae401737c5 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -82,7 +82,7 @@ __do_output(struct nft_handle *h, const char *tablename, void *data)
 		return 0;
 	}
 
-	chain_list = nft_chain_list_get(h, tablename);
+	chain_list = nft_chain_list_get(h, tablename, NULL);
 	if (!chain_list)
 		return 0;
 
-- 
2.23.0

