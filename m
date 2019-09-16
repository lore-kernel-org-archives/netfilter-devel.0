Return-Path: <SRS0=EuAs=XL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52295C49ED7
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 16:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F8A6214D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 16:50:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390265AbfIPQux (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Sep 2019 12:50:53 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:51196 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729084AbfIPQuw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Sep 2019 12:50:52 -0400
Received: from localhost ([::1]:36054 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1i9uDD-0003pS-IV; Mon, 16 Sep 2019 18:50:51 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 10/14] nft: Fetch rule cache only if needed
Date:   Mon, 16 Sep 2019 18:49:56 +0200
Message-Id: <20190916165000.18217-11-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190916165000.18217-1-phil@nwl.cc>
References: <20190916165000.18217-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduce boolean have_rule_cache to indicate whether rules have been
fetched or not. Introduce nft_build_rule_cache() to trigger explicit
rule cache population.

In a ruleset with many rules, this largely improves performance of
commands which don't need to access the rules themselves. E.g.,
appending a rule to a large chain is now two magnitudes faster than
before and even one magnitude faster than legacy iptables.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 46 +++++++++++++++++++++++++++++++++++++++++++---
 iptables/nft.h |  2 ++
 2 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 1483664510518..82c892ad96f34 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -894,8 +894,10 @@ static void flush_chain_cache(struct nft_handle *h, const char *tablename)
 	if (!h->have_chain_cache)
 		return;
 
-	if (flush_cache(h->cache, h->tables, tablename))
+	if (flush_cache(h->cache, h->tables, tablename)) {
 		h->have_chain_cache = false;
+		h->have_rule_cache = false;
+	}
 }
 
 void nft_fini(struct nft_handle *h)
@@ -1276,6 +1278,14 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 
 	nft_xt_builtin_init(h, table);
 
+	/* Since ebtables user-defined chain policies are implemented as last
+	 * rule in nftables, rule cache is required here to treat them right. */
+	if (h->family == NFPROTO_BRIDGE) {
+		c = nft_chain_find(h, table, chain);
+		if (c && !nft_chain_builtin(c))
+			nft_build_rule_cache(h);
+	}
+
 	nft_fn = nft_rule_append;
 
 	r = nft_rule_new(h, chain, table, data);
@@ -1602,6 +1612,7 @@ retry:
 	fetch_chain_cache(h);
 	fetch_rule_cache(h);
 	h->have_chain_cache = true;
+	h->have_rule_cache = true;
 	mnl_genid_get(h, &genid_stop);
 
 	if (genid_start != genid_stop) {
@@ -1618,11 +1629,19 @@ void nft_build_cache(struct nft_handle *h)
 		__nft_build_cache(h);
 }
 
+void nft_build_rule_cache(struct nft_handle *h)
+{
+	if (!h->have_rule_cache) {
+		fetch_rule_cache(h);
+		h->have_rule_cache = true;
+	}
+}
+
 void nft_fake_cache(struct nft_handle *h)
 {
 	int i;
 
-	if (h->have_chain_cache)
+	if (h->have_chain_cache && h->have_rule_cache)
 		return;
 
 	/* fetch tables so conditional table delete logic works */
@@ -1636,10 +1655,14 @@ void nft_fake_cache(struct nft_handle *h)
 		    h->cache->table[type].chains)
 			continue;
 
+		if (h->cache->table[type].chains)
+			continue;
+
 		h->cache->table[type].chains = nftnl_chain_list_alloc();
 	}
 	mnl_genid_get(h, &h->nft_genid);
 	h->have_chain_cache = true;
+	h->have_rule_cache = true;
 }
 
 static void __nft_flush_cache(struct nft_handle *h)
@@ -1675,7 +1698,10 @@ struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
 	if (!t)
 		return NULL;
 
-	nft_build_cache(h);
+	if (!h->have_chain_cache) {
+		fetch_chain_cache(h);
+		h->have_chain_cache = true;
+	}
 
 	return h->cache->table[t->type].chains;
 }
@@ -1760,6 +1786,8 @@ int nft_rule_save(struct nft_handle *h, const char *table, unsigned int format)
 	if (!list)
 		return 0;
 
+	nft_build_rule_cache(h);
+
 	iter = nftnl_chain_list_iter_create(list);
 	if (!iter)
 		return 0;
@@ -1981,6 +2009,10 @@ int nft_chain_user_del(struct nft_handle *h, const char *chain,
 	if (list == NULL)
 		return 0;
 
+	/* This triggers required policy rule deletion. */
+	if (h->family == NFPROTO_BRIDGE)
+		nft_build_rule_cache(h);
+
 	if (chain) {
 		c = nftnl_chain_list_lookup_byname(list, chain);
 		if (!c) {
@@ -2242,6 +2274,8 @@ nft_rule_find(struct nft_handle *h, struct nftnl_chain *c, void *data, int rulen
 	struct nftnl_rule_iter *iter;
 	bool found = false;
 
+	nft_build_rule_cache(h);
+
 	if (rulenum >= 0)
 		/* Delete by rule number case */
 		return nftnl_rule_lookup_byindex(c, rulenum);
@@ -3062,6 +3096,8 @@ int ebt_set_user_chain_policy(struct nft_handle *h, const char *table,
 	if (!c)
 		return 0;
 
+	nft_build_rule_cache(h);
+
 	if (!strcmp(policy, "DROP"))
 		pval = NF_DROP;
 	else if (!strcmp(policy, "ACCEPT"))
@@ -3339,6 +3375,8 @@ int nft_chain_zero_counters(struct nft_handle *h, const char *chain,
 	if (list == NULL)
 		goto err;
 
+	nft_build_rule_cache(h);
+
 	if (chain) {
 		c = nftnl_chain_list_lookup_byname(list, chain);
 		if (!c) {
@@ -3445,6 +3483,8 @@ bool nft_is_table_compatible(struct nft_handle *h, const char *tablename)
 	if (clist == NULL)
 		return false;
 
+	nft_build_rule_cache(h);
+
 	if (nftnl_chain_list_foreach(clist, nft_is_chain_compatible, h))
 		return false;
 
diff --git a/iptables/nft.h b/iptables/nft.h
index 11b2d4e3be6ff..718acdbf0c55d 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -54,6 +54,7 @@ struct nft_handle {
 	struct nft_cache	__cache[2];
 	struct nft_cache	*cache;
 	bool			have_chain_cache;
+	bool			have_rule_cache;
 	bool			restore;
 	bool			noflush;
 	int8_t			config_done;
@@ -74,6 +75,7 @@ int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
 int nft_init(struct nft_handle *h, const struct builtin_table *t);
 void nft_fini(struct nft_handle *h);
 void nft_build_cache(struct nft_handle *h);
+void nft_build_rule_cache(struct nft_handle *h);
 void nft_fake_cache(struct nft_handle *h);
 
 /*
-- 
2.23.0

