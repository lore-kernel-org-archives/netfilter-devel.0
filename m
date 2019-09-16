Return-Path: <SRS0=EuAs=XL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA86C49ED7
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 16:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E661206C2
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 16:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390260AbfIPQvE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Sep 2019 12:51:04 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:51208 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729084AbfIPQvE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Sep 2019 12:51:04 -0400
Received: from localhost ([::1]:36066 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1i9uDO-0003qN-MX; Mon, 16 Sep 2019 18:51:02 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 11/14] nft: Allow to fetch only a specific chain from kernel
Date:   Mon, 16 Sep 2019 18:49:57 +0200
Message-Id: <20190916165000.18217-12-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190916165000.18217-1-phil@nwl.cc>
References: <20190916165000.18217-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend nft_chain_list_get() to accept an optional chain name callers are
interested in. If chain cache is not present yet, add a suitable payload
to NFT_MSG_GETCHAIN request to retrieve only that single chain. The
table's chain list will then contain only that chain.

Chain cache is considered present (i.e., have_chain_cache set to true)
only if fetch_chain_cache() was called without a specific chain name.
Therefore a full cache update could happen after fetching a specific
chain which means cache update preparation has to drop each table's
chain list to avoid duplicates.

With fetch_chain_cache() potentially ignoring all but a single table,
make fetch_rule_cache() aware of potentially uninitialized chain lists.
Rules are simply not fetched for those then.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c             | 64 +++++++++++++++++++++++++++-----------
 iptables/nft.h             |  3 +-
 iptables/xtables-restore.c |  2 +-
 iptables/xtables-save.c    |  2 +-
 4 files changed, 50 insertions(+), 21 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 82c892ad96f34..46c7be372a10f 100644
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
 
@@ -1425,7 +1425,7 @@ static int fetch_table_cache(struct nft_handle *h)
 	return 1;
 }
 
-static int fetch_chain_cache(struct nft_handle *h)
+static int fetch_chain_cache(struct nft_handle *h, const char *table, const char *chain)
 {
 	char buf[16536];
 	struct nlmsghdr *nlh;
@@ -1439,13 +1439,37 @@ static int fetch_chain_cache(struct nft_handle *h)
 		if (!h->tables[i].name)
 			continue;
 
+		/* When not fetching a single chain, kernel returns all chains
+		 * of the given family which may belong to other tables than
+		 * the expected one. Hence skip chain list initialization only
+		 * if both chain and table are specified. */
+		if (chain && table && strcmp(table, h->tables[i].name))
+			continue;
+
+		if (h->cache->table[type].chains)
+			nftnl_chain_list_free(h->cache->table[type].chains);
+
 		h->cache->table[type].chains = nftnl_chain_list_alloc();
 		if (!h->cache->table[type].chains)
 			return -1;
 	}
 
-	nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, h->family,
-					NLM_F_DUMP, h->seq);
+	if (table && chain) {
+		struct nftnl_chain *c;
+
+		nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, h->family,
+						NLM_F_ACK, h->seq);
+		c = nftnl_chain_alloc();
+		if (!c)
+			return -1;
+		nftnl_chain_set_str(c, NFTNL_CHAIN_TABLE, table);
+		nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, chain);
+		nftnl_chain_nlmsg_build_payload(nlh, c);
+		nftnl_chain_free(c);
+	} else {
+		nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, h->family,
+						NLM_F_DUMP, h->seq);
+	}
 
 	ret = mnl_talk(h, nlh, nftnl_chain_list_cb, h);
 	if (ret < 0 && errno == EINTR)
@@ -1596,6 +1620,9 @@ static int fetch_rule_cache(struct nft_handle *h)
 		if (!h->tables[i].name)
 			continue;
 
+		if (!h->cache->table[type].chains)
+			continue;
+
 		if (nftnl_chain_list_foreach(h->cache->table[type].chains,
 					     nft_rule_list_update, h))
 			return -1;
@@ -1609,7 +1636,7 @@ static void __nft_build_cache(struct nft_handle *h)
 
 retry:
 	mnl_genid_get(h, &genid_start);
-	fetch_chain_cache(h);
+	fetch_chain_cache(h, NULL, NULL);
 	fetch_rule_cache(h);
 	h->have_chain_cache = true;
 	h->have_rule_cache = true;
@@ -1690,7 +1717,7 @@ static void nft_release_cache(struct nft_handle *h)
 }
 
 struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
-					    const char *table)
+					    const char *table, const char *chain)
 {
 	const struct builtin_table *t;
 
@@ -1699,8 +1726,9 @@ struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
 		return NULL;
 
 	if (!h->have_chain_cache) {
-		fetch_chain_cache(h);
-		h->have_chain_cache = true;
+		fetch_chain_cache(h, table, chain);
+		if (!chain)
+			h->have_chain_cache = true;
 	}
 
 	return h->cache->table[t->type].chains;
@@ -1782,7 +1810,7 @@ int nft_rule_save(struct nft_handle *h, const char *table, unsigned int format)
 	struct nftnl_chain *c;
 	int ret = 0;
 
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, NULL);
 	if (!list)
 		return 0;
 
@@ -1845,7 +1873,7 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 
 	nft_fn = nft_rule_flush;
 
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, chain);
 	if (list == NULL) {
 		ret = 1;
 		goto err;
@@ -1910,7 +1938,7 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
 
 	ret = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c);
 
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, NULL);
 	if (list)
 		nftnl_chain_list_add(c, list);
 
@@ -1950,7 +1978,7 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
 
 	ret = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c);
 
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, chain);
 	if (list)
 		nftnl_chain_list_add(c, list);
 
@@ -2005,7 +2033,7 @@ int nft_chain_user_del(struct nft_handle *h, const char *chain,
 
 	nft_fn = nft_chain_user_del;
 
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, chain);
 	if (list == NULL)
 		return 0;
 
@@ -2037,7 +2065,7 @@ nft_chain_find(struct nft_handle *h, const char *table, const char *chain)
 {
 	struct nftnl_chain_list *list;
 
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, chain);
 	if (list == NULL)
 		return NULL;
 
@@ -2584,7 +2612,7 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 		return 0;
 	}
 
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, chain);
 	if (!list)
 		return 0;
 
@@ -2687,7 +2715,7 @@ int nft_rule_list_save(struct nft_handle *h, const char *chain,
 		return 0;
 	}
 
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, chain);
 	if (!list)
 		return 0;
 
@@ -3371,7 +3399,7 @@ int nft_chain_zero_counters(struct nft_handle *h, const char *chain,
 	struct nftnl_chain *c;
 	int ret = 0;
 
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, chain);
 	if (list == NULL)
 		goto err;
 
@@ -3479,7 +3507,7 @@ bool nft_is_table_compatible(struct nft_handle *h, const char *tablename)
 {
 	struct nftnl_chain_list *clist;
 
-	clist = nft_chain_list_get(h, tablename);
+	clist = nft_chain_list_get(h, tablename, NULL);
 	if (clist == NULL)
 		return false;
 
diff --git a/iptables/nft.h b/iptables/nft.h
index 718acdbf0c55d..4b1c191effbd6 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -98,7 +98,8 @@ struct nftnl_chain;
 
 int nft_chain_set(struct nft_handle *h, const char *table, const char *chain, const char *policy, const struct xt_counters *counters);
 struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
-					    const char *table);
+					    const char *table,
+					    const char *chain);
 int nft_chain_save(struct nft_handle *h, struct nftnl_chain_list *list);
 int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *table);
 int nft_chain_user_del(struct nft_handle *h, const char *chain, const char *table, bool verbose);
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index d1486afedc480..835a21be7324f 100644
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

