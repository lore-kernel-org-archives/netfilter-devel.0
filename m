Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59674C10F14
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 11:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FF8121848
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 11:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbfJOLmN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 07:42:13 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:36574 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbfJOLmM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 07:42:12 -0400
Received: from localhost ([::1]:49664 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iKLDP-0000xm-Bq; Tue, 15 Oct 2019 13:42:11 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v4 5/8] nft-cache: Support partial rule cache per chain
Date:   Tue, 15 Oct 2019 13:41:49 +0200
Message-Id: <20191015114152.25254-6-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191015114152.25254-1-phil@nwl.cc>
References: <20191015114152.25254-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Accept an additional chain name pointer in __nft_build_cache() and pass
it along to fetch only that specific chain and its rules.

Enhance nft_build_cache() to take an optional nftnl_chain pointer to
fetch rules for.

Enhance nft_chain_list_get() to take an optional chain name. If cache
level doesn't include chains already, it will fetch only the specified
chain from kernel (if existing) and add that to table's chain list which
is returned. This keeps operations for all chains of a table or a
specific one within the same code path in nft.c.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c       | 76 ++++++++++++++++++++++++++++----------
 iptables/nft-cache.h       |  6 +--
 iptables/nft.c             | 35 +++++++++---------
 iptables/xtables-restore.c |  4 +-
 iptables/xtables-save.c    |  2 +-
 5 files changed, 79 insertions(+), 44 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 822d6f20cf51c..64dcda578a163 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -153,7 +153,8 @@ err:
 }
 
 static int fetch_chain_cache(struct nft_handle *h,
-			     const struct builtin_table *t)
+			     const struct builtin_table *t,
+			     const char *chain)
 {
 	struct nftnl_chain_list_cb_data d = {
 		.h = h,
@@ -183,8 +184,24 @@ static int fetch_chain_cache(struct nft_handle *h,
 			return -1;
 	}
 
-	nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, h->family,
-					NLM_F_DUMP, h->seq);
+	if (t && chain) {
+		struct nftnl_chain *c = nftnl_chain_alloc();
+
+		if (!c)
+			return -1;
+
+		nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN,
+						  h->family, NLM_F_ACK,
+						  h->seq);
+		nftnl_chain_set_str(c, NFTNL_CHAIN_TABLE, t->name);
+		nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, chain);
+		nftnl_chain_nlmsg_build_payload(nlh, c);
+		nftnl_chain_free(c);
+	} else {
+		nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN,
+						  h->family, NLM_F_DUMP,
+						  h->seq);
+	}
 
 	ret = mnl_talk(h, nlh, nftnl_chain_list_cb, &d);
 	if (ret < 0 && errno == EINTR)
@@ -247,13 +264,23 @@ static int nft_rule_list_update(struct nftnl_chain *c, void *data)
 	return 0;
 }
 
-static int fetch_rule_cache(struct nft_handle *h, const struct builtin_table *t)
+static int fetch_rule_cache(struct nft_handle *h,
+			    const struct builtin_table *t, const char *chain)
 {
 	int i;
 
-	if (t)
-		return nftnl_chain_list_foreach(h->cache->table[t->type].chains,
-						nft_rule_list_update, h);
+	if (t) {
+		struct nftnl_chain_list *list;
+		struct nftnl_chain *c;
+
+		list = h->cache->table[t->type].chains;
+
+		if (chain) {
+			c = nftnl_chain_list_lookup_byname(list, chain);
+			return nft_rule_list_update(c, h);
+		}
+		return nftnl_chain_list_foreach(list, nft_rule_list_update, h);
+	}
 
 	for (i = 0; i < NFT_TABLE_MAX; i++) {
 		enum nft_table_type type = h->tables[i].type;
@@ -268,8 +295,9 @@ static int fetch_rule_cache(struct nft_handle *h, const struct builtin_table *t)
 	return 0;
 }
 
-static void __nft_build_cache(struct nft_handle *h, enum nft_cache_level level,
-			      const struct builtin_table *t)
+static void
+__nft_build_cache(struct nft_handle *h, enum nft_cache_level level,
+		  const struct builtin_table *t, const char *chain)
 {
 	uint32_t genid_start, genid_stop;
 
@@ -288,12 +316,12 @@ retry:
 			break;
 		/* fall through */
 	case NFT_CL_TABLES:
-		fetch_chain_cache(h, t);
+		fetch_chain_cache(h, t, chain);
 		if (level == NFT_CL_CHAINS)
 			break;
 		/* fall through */
 	case NFT_CL_CHAINS:
-		fetch_rule_cache(h, t);
+		fetch_rule_cache(h, t, chain);
 		if (level == NFT_CL_RULES)
 			break;
 		/* fall through */
@@ -307,7 +335,7 @@ retry:
 		goto retry;
 	}
 
-	if (!t)
+	if (!t && !chain)
 		h->cache_level = level;
 	else if (h->cache_level < NFT_CL_TABLES)
 		h->cache_level = NFT_CL_TABLES;
@@ -315,10 +343,18 @@ retry:
 	h->nft_genid = genid_start;
 }
 
-void nft_build_cache(struct nft_handle *h)
+void nft_build_cache(struct nft_handle *h, struct nftnl_chain *c)
 {
-	if (h->cache_level < NFT_CL_RULES)
-		__nft_build_cache(h, NFT_CL_RULES, NULL);
+	const struct builtin_table *t;
+	const char *table, *chain;
+
+	if (!c)
+		return __nft_build_cache(h, NFT_CL_RULES, NULL, NULL);
+
+	table = nftnl_chain_get_str(c, NFTNL_CHAIN_TABLE);
+	chain = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
+	t = nft_table_builtin_find(h, table);
+	__nft_build_cache(h, NFT_CL_RULES, t, chain);
 }
 
 void nft_fake_cache(struct nft_handle *h)
@@ -417,7 +453,7 @@ void nft_rebuild_cache(struct nft_handle *h)
 		__nft_flush_cache(h);
 
 	h->cache_level = NFT_CL_NONE;
-	__nft_build_cache(h, level, NULL);
+	__nft_build_cache(h, level, NULL, NULL);
 }
 
 void nft_release_cache(struct nft_handle *h)
@@ -428,13 +464,13 @@ void nft_release_cache(struct nft_handle *h)
 
 struct nftnl_table_list *nftnl_table_list_get(struct nft_handle *h)
 {
-	__nft_build_cache(h, NFT_CL_TABLES, NULL);
+	__nft_build_cache(h, NFT_CL_TABLES, NULL, NULL);
 
 	return h->cache->tables;
 }
 
-struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
-					    const char *table)
+struct nftnl_chain_list *
+nft_chain_list_get(struct nft_handle *h, const char *table, const char *chain)
 {
 	const struct builtin_table *t;
 
@@ -442,7 +478,7 @@ struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
 	if (!t)
 		return NULL;
 
-	__nft_build_cache(h, NFT_CL_CHAINS, t);
+	__nft_build_cache(h, NFT_CL_CHAINS, t, chain);
 
 	return h->cache->table[t->type].chains;
 }
diff --git a/iptables/nft-cache.h b/iptables/nft-cache.h
index 423c6516de9bb..793a85f453ffc 100644
--- a/iptables/nft-cache.h
+++ b/iptables/nft-cache.h
@@ -4,14 +4,14 @@
 struct nft_handle;
 
 void nft_fake_cache(struct nft_handle *h);
-void nft_build_cache(struct nft_handle *h);
+void nft_build_cache(struct nft_handle *h, struct nftnl_chain *c);
 void nft_rebuild_cache(struct nft_handle *h);
 void nft_release_cache(struct nft_handle *h);
 void flush_chain_cache(struct nft_handle *h, const char *tablename);
 void flush_rule_cache(struct nftnl_chain *c);
 
-struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
-					    const char *table);
+struct nftnl_chain_list *
+nft_chain_list_get(struct nft_handle *h, const char *table, const char *chain);
 struct nftnl_table_list *nftnl_table_list_get(struct nft_handle *h);
 
 #endif /* _NFT_CACHE_H_ */
diff --git a/iptables/nft.c b/iptables/nft.c
index 94fabd78e527e..775582aab7955 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -709,7 +709,7 @@ nft_chain_builtin_find(const struct builtin_table *t, const char *chain)
 static void nft_chain_builtin_init(struct nft_handle *h,
 				   const struct builtin_table *table)
 {
-	struct nftnl_chain_list *list = nft_chain_list_get(h, table->name);
+	struct nftnl_chain_list *list = nft_chain_list_get(h, table->name, NULL);
 	struct nftnl_chain *c;
 	int i;
 
@@ -1178,7 +1178,7 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 	if (h->family == NFPROTO_BRIDGE) {
 		c = nft_chain_find(h, table, chain);
 		if (c && !nft_chain_builtin(c))
-			nft_build_cache(h);
+			nft_build_cache(h, c);
 	}
 
 	nft_fn = nft_rule_append;
@@ -1405,9 +1405,7 @@ int nft_rule_save(struct nft_handle *h, const char *table, unsigned int format)
 	struct nftnl_chain *c;
 	int ret = 0;
 
-	nft_build_cache(h);
-
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, NULL);
 	if (!list)
 		return 0;
 
@@ -1417,6 +1415,7 @@ int nft_rule_save(struct nft_handle *h, const char *table, unsigned int format)
 
 	c = nftnl_chain_list_iter_next(iter);
 	while (c) {
+		nft_build_cache(h, c);
 		ret = nft_chain_save_rules(h, c, format);
 		if (ret != 0)
 			break;
@@ -1468,7 +1467,7 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 
 	nft_fn = nft_rule_flush;
 
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, chain);
 	if (list == NULL) {
 		ret = 1;
 		goto err;
@@ -1533,7 +1532,7 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
 
 	ret = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c);
 
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, chain);
 	if (list)
 		nftnl_chain_list_add(c, list);
 
@@ -1573,7 +1572,7 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
 
 	ret = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c);
 
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, chain);
 	if (list)
 		nftnl_chain_list_add(c, list);
 
@@ -1607,7 +1606,7 @@ static int __nft_chain_user_del(struct nftnl_chain *c, void *data)
 
 	/* This triggers required policy rule deletion. */
 	if (h->family == NFPROTO_BRIDGE)
-		nft_build_cache(h);
+		nft_build_cache(h, c);
 
 	/* XXX This triggers a fast lookup from the kernel. */
 	nftnl_chain_unset(c, NFTNL_CHAIN_HANDLE);
@@ -1632,7 +1631,7 @@ int nft_chain_user_del(struct nft_handle *h, const char *chain,
 
 	nft_fn = nft_chain_user_del;
 
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, chain);
 	if (list == NULL)
 		return 0;
 
@@ -1660,7 +1659,7 @@ nft_chain_find(struct nft_handle *h, const char *table, const char *chain)
 {
 	struct nftnl_chain_list *list;
 
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, chain);
 	if (list == NULL)
 		return NULL;
 
@@ -1890,7 +1889,7 @@ nft_rule_find(struct nft_handle *h, struct nftnl_chain *c, void *data, int rulen
 	struct nftnl_rule_iter *iter;
 	bool found = false;
 
-	nft_build_cache(h);
+	nft_build_cache(h, c);
 
 	if (rulenum >= 0)
 		/* Delete by rule number case */
@@ -2198,7 +2197,7 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 	if (!nft_is_table_compatible(h, table))
 		xtables_error(OTHER_PROBLEM, "table `%s' is incompatible, use 'nft' tool.\n", table);
 
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, chain);
 	if (!list)
 		return 0;
 
@@ -2299,7 +2298,7 @@ int nft_rule_list_save(struct nft_handle *h, const char *chain,
 	if (!nft_is_table_compatible(h, table))
 		xtables_error(OTHER_PROBLEM, "table `%s' is incompatible, use 'nft' tool.\n", table);
 
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, chain);
 	if (!list)
 		return 0;
 
@@ -2717,7 +2716,7 @@ int ebt_set_user_chain_policy(struct nft_handle *h, const char *table,
 	else
 		return 0;
 
-	nft_build_cache(h);
+	nft_build_cache(h, c);
 
 	nftnl_chain_set_u32(c, NFTNL_CHAIN_POLICY, pval);
 	return 1;
@@ -2983,7 +2982,7 @@ int nft_chain_zero_counters(struct nft_handle *h, const char *chain,
 	struct nftnl_chain *c;
 	int ret = 0;
 
-	list = nft_chain_list_get(h, table);
+	list = nft_chain_list_get(h, table, chain);
 	if (list == NULL)
 		goto err;
 
@@ -3056,7 +3055,7 @@ static int nft_is_chain_compatible(struct nftnl_chain *c, void *data)
 	enum nf_inet_hooks hook;
 	int prio;
 
-	nft_build_cache(h);
+	nft_build_cache(h, c);
 
 	if (nftnl_rule_foreach(c, nft_is_rule_compatible, NULL))
 		return -1;
@@ -3089,7 +3088,7 @@ bool nft_is_table_compatible(struct nft_handle *h, const char *tablename)
 {
 	struct nftnl_chain_list *clist;
 
-	clist = nft_chain_list_get(h, tablename);
+	clist = nft_chain_list_get(h, tablename, NULL);
 	if (clist == NULL)
 		return false;
 
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 7641955d1ce53..4f6d324bdafe9 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -63,7 +63,7 @@ static struct nftnl_chain_list *get_chain_list(struct nft_handle *h,
 {
 	struct nftnl_chain_list *chain_list;
 
-	chain_list = nft_chain_list_get(h, table);
+	chain_list = nft_chain_list_get(h, table, NULL);
 	if (chain_list == NULL)
 		xtables_error(OTHER_PROBLEM, "cannot retrieve chain list\n");
 
@@ -100,7 +100,7 @@ void xtables_restore_parse(struct nft_handle *h,
 	if (!h->noflush)
 		nft_fake_cache(h);
 	else
-		nft_build_cache(h);
+		nft_build_cache(h, NULL);
 
 	/* Grab standard input. */
 	while (fgets(buffer, sizeof(buffer), p->in)) {
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 3741888f9af44..e234425ded293 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -83,7 +83,7 @@ __do_output(struct nft_handle *h, const char *tablename, void *data)
 		return 0;
 	}
 
-	chain_list = nft_chain_list_get(h, tablename);
+	chain_list = nft_chain_list_get(h, tablename, NULL);
 	if (!chain_list)
 		return 0;
 
-- 
2.23.0

