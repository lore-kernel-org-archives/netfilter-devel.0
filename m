Return-Path: <SRS0=+tY6=XU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8214DC432C2
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B1312054F
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:26:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfIYV0s (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:26:48 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45824 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbfIYV0s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 17:26:48 -0400
Received: from localhost ([::1]:58914 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iDEoB-0005E1-94; Wed, 25 Sep 2019 23:26:47 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 08/24] nft: Fetch only chains in nft_chain_list_get()
Date:   Wed, 25 Sep 2019 23:25:49 +0200
Message-Id: <20190925212605.1005-9-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190925212605.1005-1-phil@nwl.cc>
References: <20190925212605.1005-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The function is used to return the given table's chains, so fetching
chain cache is enough.

This requires a bunch of manual rule cache updates in different places.
To still support the fake cache logic from xtables-restore, make
fetch_rule_cache() do nothing in case have_cache is set.

Accidental double rule cache updates for the same chain need to be
prevented. This is complicated by the fact that chain's rule list is
managed by libnftnl. Hence the same logic as used for table list, namely
checking list pointer value, can't be used. Instead, simply fetch rules
only if the given chain's rule list is empty. If it isn't, rules have
been fetched before; if it is, a second rule fetch won't hurt.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 7c974af8b4141..729b88d990f9f 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1264,6 +1264,7 @@ err:
 
 static struct nftnl_chain *
 nft_chain_find(struct nft_handle *h, const char *table, const char *chain);
+static int fetch_rule_cache(struct nft_handle *h, struct nftnl_chain *c);
 
 int
 nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
@@ -1275,6 +1276,14 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 
 	nft_xt_builtin_init(h, table);
 
+	/* Since ebtables user-defined chain policies are implemented as last
+	 * rule in nftables, rule cache is required here to treat them right. */
+	if (h->family == NFPROTO_BRIDGE) {
+		c = nft_chain_find(h, table, chain);
+		if (c && !nft_chain_builtin(c))
+			fetch_rule_cache(h, c);
+	}
+
 	nft_fn = nft_rule_append;
 
 	r = nft_rule_new(h, chain, table, data);
@@ -1550,6 +1559,9 @@ static int nft_rule_list_update(struct nftnl_chain *c, void *data)
 	struct nftnl_rule *rule;
 	int ret;
 
+	if (nftnl_rule_lookup_byindex(c, 0))
+		return 0;
+
 	rule = nftnl_rule_alloc();
 	if (!rule)
 		return -1;
@@ -1579,6 +1591,9 @@ static int fetch_rule_cache(struct nft_handle *h, struct nftnl_chain *c)
 {
 	int i;
 
+	if (h->have_cache)
+		return 0;
+
 	if (c)
 		return nft_rule_list_update(c, h);
 
@@ -1670,7 +1685,8 @@ struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
 	if (!t)
 		return NULL;
 
-	nft_build_cache(h);
+	if (!h->have_cache && !h->cache->table[t->type].chains)
+		fetch_chain_cache(h);
 
 	return h->cache->table[t->type].chains;
 }
@@ -1761,6 +1777,7 @@ int nft_rule_save(struct nft_handle *h, const char *table, unsigned int format)
 
 	c = nftnl_chain_list_iter_next(iter);
 	while (c) {
+		fetch_rule_cache(h, c);
 		ret = nft_chain_save_rules(h, c, format);
 		if (ret != 0)
 			break;
@@ -1949,6 +1966,10 @@ static int __nft_chain_user_del(struct nftnl_chain *c, void *data)
 		fprintf(stdout, "Deleting chain `%s'\n",
 			nftnl_chain_get_str(c, NFTNL_CHAIN_NAME));
 
+	/* This triggers required policy rule deletion. */
+	if (h->family == NFPROTO_BRIDGE)
+		fetch_rule_cache(h, c);
+
 	/* XXX This triggers a fast lookup from the kernel. */
 	nftnl_chain_unset(c, NFTNL_CHAIN_HANDLE);
 	ret = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_DEL, c);
@@ -2238,6 +2259,8 @@ nft_rule_find(struct nft_handle *h, struct nftnl_chain *c, void *data, int rulen
 	struct nftnl_rule_iter *iter;
 	bool found = false;
 
+	fetch_rule_cache(h, c);
+
 	if (rulenum >= 0)
 		/* Delete by rule number case */
 		return nftnl_rule_lookup_byindex(c, rulenum);
@@ -3063,6 +3086,8 @@ int ebt_set_user_chain_policy(struct nft_handle *h, const char *table,
 	else
 		return 0;
 
+	fetch_rule_cache(h, c);
+
 	nftnl_chain_set_u32(c, NFTNL_CHAIN_POLICY, pval);
 	return 1;
 }
@@ -3402,6 +3427,8 @@ static int nft_is_chain_compatible(struct nftnl_chain *c, void *data)
 	enum nf_inet_hooks hook;
 	int prio;
 
+	fetch_rule_cache(h, c);
+
 	if (nftnl_rule_foreach(c, nft_is_rule_compatible, NULL))
 		return -1;
 
-- 
2.23.0

