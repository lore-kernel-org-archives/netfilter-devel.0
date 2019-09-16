Return-Path: <SRS0=EuAs=XL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB5EC49ED7
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 16:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7280214D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 16:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390201AbfIPQuK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Sep 2019 12:50:10 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:51148 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390198AbfIPQuK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Sep 2019 12:50:10 -0400
Received: from localhost ([::1]:36006 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1i9uCW-0003mc-Ns; Mon, 16 Sep 2019 18:50:08 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 12/14] nft: Support fetching rules for a single chain only
Date:   Mon, 16 Sep 2019 18:49:58 +0200
Message-Id: <20190916165000.18217-13-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190916165000.18217-1-phil@nwl.cc>
References: <20190916165000.18217-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Just like with single chain fetching, pass optional table and chain
names to nft_build_rule_cache() to restrict its effect onto those.

This effectively makes iptables-nft ignore other tables and other chains
of the same table even if rule cache is needed for an operation
affecting a single chain only.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c          | 52 ++++++++++++++++++++++++++++-------------
 iptables/nft.h          |  6 +++--
 iptables/xtables-save.c |  2 +-
 3 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 46c7be372a10f..294cb306700d0 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1283,7 +1283,7 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 	if (h->family == NFPROTO_BRIDGE) {
 		c = nft_chain_find(h, table, chain);
 		if (c && !nft_chain_builtin(c))
-			nft_build_rule_cache(h);
+			nft_build_rule_cache(h, table, chain);
 	}
 
 	nft_fn = nft_rule_append;
@@ -1610,7 +1610,7 @@ static int nft_rule_list_update(struct nftnl_chain *c, void *data)
 	return 0;
 }
 
-static int fetch_rule_cache(struct nft_handle *h)
+static int fetch_rule_cache(struct nft_handle *h, const char *table, const char *chain)
 {
 	int i;
 
@@ -1623,9 +1623,25 @@ static int fetch_rule_cache(struct nft_handle *h)
 		if (!h->cache->table[type].chains)
 			continue;
 
+		if (table && strcmp(h->tables[i].name, table))
+			continue;
+
+		if (chain) {
+			struct nftnl_chain_list *clist;
+			struct nftnl_chain *c;
+
+			clist = h->cache->table[type].chains;
+			c = nftnl_chain_list_lookup_byname(clist, chain);
+
+			return c ? nft_rule_list_update(c, h) : -1;
+		}
+
 		if (nftnl_chain_list_foreach(h->cache->table[type].chains,
 					     nft_rule_list_update, h))
 			return -1;
+
+		if (table)
+			break;
 	}
 	return 0;
 }
@@ -1637,7 +1653,7 @@ static void __nft_build_cache(struct nft_handle *h)
 retry:
 	mnl_genid_get(h, &genid_start);
 	fetch_chain_cache(h, NULL, NULL);
-	fetch_rule_cache(h);
+	fetch_rule_cache(h, NULL, NULL);
 	h->have_chain_cache = true;
 	h->have_rule_cache = true;
 	mnl_genid_get(h, &genid_stop);
@@ -1656,11 +1672,13 @@ void nft_build_cache(struct nft_handle *h)
 		__nft_build_cache(h);
 }
 
-void nft_build_rule_cache(struct nft_handle *h)
+void nft_build_rule_cache(struct nft_handle *h,
+			  const char *table, const char *chain)
 {
 	if (!h->have_rule_cache) {
-		fetch_rule_cache(h);
-		h->have_rule_cache = true;
+		fetch_rule_cache(h, table, chain);
+		if (!table && !chain)
+			h->have_rule_cache = true;
 	}
 }
 
@@ -1814,7 +1832,7 @@ int nft_rule_save(struct nft_handle *h, const char *table, unsigned int format)
 	if (!list)
 		return 0;
 
-	nft_build_rule_cache(h);
+	nft_build_rule_cache(h, table, NULL);
 
 	iter = nftnl_chain_list_iter_create(list);
 	if (!iter)
@@ -2039,7 +2057,7 @@ int nft_chain_user_del(struct nft_handle *h, const char *chain,
 
 	/* This triggers required policy rule deletion. */
 	if (h->family == NFPROTO_BRIDGE)
-		nft_build_rule_cache(h);
+		nft_build_rule_cache(h, table, chain);
 
 	if (chain) {
 		c = nftnl_chain_list_lookup_byname(list, chain);
@@ -2302,7 +2320,8 @@ nft_rule_find(struct nft_handle *h, struct nftnl_chain *c, void *data, int rulen
 	struct nftnl_rule_iter *iter;
 	bool found = false;
 
-	nft_build_rule_cache(h);
+	nft_build_rule_cache(h, nftnl_chain_get_str(c, NFTNL_CHAIN_TABLE),
+			     nftnl_chain_get_str(c, NFTNL_CHAIN_NAME));
 
 	if (rulenum >= 0)
 		/* Delete by rule number case */
@@ -2607,7 +2626,7 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 
 	ops = nft_family_ops_lookup(h->family);
 
-	if (!nft_is_table_compatible(h, table)) {
+	if (!nft_is_table_compatible(h, table, chain)) {
 		xtables_error(OTHER_PROBLEM, "table `%s' is incompatible, use 'nft' tool.\n", table);
 		return 0;
 	}
@@ -2710,7 +2729,7 @@ int nft_rule_list_save(struct nft_handle *h, const char *chain,
 
 	nft_xt_builtin_init(h, table);
 
-	if (!nft_is_table_compatible(h, table)) {
+	if (!nft_is_table_compatible(h, table, chain)) {
 		xtables_error(OTHER_PROBLEM, "table `%s' is incompatible, use 'nft' tool.\n", table);
 		return 0;
 	}
@@ -3124,7 +3143,7 @@ int ebt_set_user_chain_policy(struct nft_handle *h, const char *table,
 	if (!c)
 		return 0;
 
-	nft_build_rule_cache(h);
+	nft_build_rule_cache(h, table, chain);
 
 	if (!strcmp(policy, "DROP"))
 		pval = NF_DROP;
@@ -3403,7 +3422,7 @@ int nft_chain_zero_counters(struct nft_handle *h, const char *chain,
 	if (list == NULL)
 		goto err;
 
-	nft_build_rule_cache(h);
+	nft_build_rule_cache(h, table, chain);
 
 	if (chain) {
 		c = nftnl_chain_list_lookup_byname(list, chain);
@@ -3503,15 +3522,16 @@ static int nft_is_chain_compatible(struct nftnl_chain *c, void *data)
 	return 0;
 }
 
-bool nft_is_table_compatible(struct nft_handle *h, const char *tablename)
+bool nft_is_table_compatible(struct nft_handle *h,
+			     const char *tablename, const char *chainname)
 {
 	struct nftnl_chain_list *clist;
 
-	clist = nft_chain_list_get(h, tablename, NULL);
+	clist = nft_chain_list_get(h, tablename, chainname);
 	if (clist == NULL)
 		return false;
 
-	nft_build_rule_cache(h);
+	nft_build_rule_cache(h, tablename, chainname);
 
 	if (nftnl_chain_list_foreach(clist, nft_is_chain_compatible, h))
 		return false;
diff --git a/iptables/nft.h b/iptables/nft.h
index 4b1c191effbd6..e6bfdf34103b1 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -75,7 +75,8 @@ int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
 int nft_init(struct nft_handle *h, const struct builtin_table *t);
 void nft_fini(struct nft_handle *h);
 void nft_build_cache(struct nft_handle *h);
-void nft_build_rule_cache(struct nft_handle *h);
+void nft_build_rule_cache(struct nft_handle *h,
+			  const char *table, const char *chain);
 void nft_fake_cache(struct nft_handle *h);
 
 /*
@@ -202,7 +203,8 @@ int nft_arp_rule_insert(struct nft_handle *h, const char *chain,
 
 void nft_rule_to_arpt_entry(struct nftnl_rule *r, struct arpt_entry *fw);
 
-bool nft_is_table_compatible(struct nft_handle *h, const char *name);
+bool nft_is_table_compatible(struct nft_handle *h,
+			     const char *table, const char *chain);
 
 int ebt_set_user_chain_policy(struct nft_handle *h, const char *table,
 			      const char *chain, const char *policy);
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 503ae401737c5..000104d3b51ae 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -76,7 +76,7 @@ __do_output(struct nft_handle *h, const char *tablename, void *data)
 	if (!nft_table_builtin_find(h, tablename))
 		return 0;
 
-	if (!nft_is_table_compatible(h, tablename)) {
+	if (!nft_is_table_compatible(h, tablename, NULL)) {
 		printf("# Table `%s' is incompatible, use 'nft' tool.\n",
 		       tablename);
 		return 0;
-- 
2.23.0

