Return-Path: <SRS0=Xvwf=23=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A96EAC33C9B
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 12:20:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 899062072E
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 12:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgAFMUi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 07:20:38 -0500
Received: from correo.us.es ([193.147.175.20]:43686 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbgAFMUh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 07:20:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 26B86F2DF6
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2020 13:20:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 18EA9DA703
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2020 13:20:35 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6B2F2DA721; Mon,  6 Jan 2020 13:20:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 61235DA702;
        Mon,  6 Jan 2020 13:20:24 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 Jan 2020 13:20:24 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4519F41E4800;
        Mon,  6 Jan 2020 13:20:24 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH 5/7] nft: remove cache build calls
Date:   Mon,  6 Jan 2020 13:20:16 +0100
Message-Id: <20200106122018.14090-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200106122018.14090-1-pablo@netfilter.org>
References: <20200106122018.14090-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The cache requirements are now calculated once from the parsing phase.
There is no need to call __nft_build_cache() from several spots in the
codepath anymore.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft-cache.c |  6 ------
 iptables/nft.c       | 21 ---------------------
 2 files changed, 27 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 82d6b7c2393a..1fb65892d898 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -647,8 +647,6 @@ void nft_release_cache(struct nft_handle *h)
 
 struct nftnl_table_list *nftnl_table_list_get(struct nft_handle *h)
 {
-	__nft_build_cache(h, NFT_CL_TABLES, NULL, NULL, NULL);
-
 	return h->cache->tables;
 }
 
@@ -661,8 +659,6 @@ nft_set_list_get(struct nft_handle *h, const char *table, const char *set)
 	if (!t)
 		return NULL;
 
-	__nft_build_cache(h, NFT_CL_RULES, t, set, NULL);
-
 	return h->cache->table[t->type].sets;
 }
 
@@ -675,8 +671,6 @@ nft_chain_list_get(struct nft_handle *h, const char *table, const char *chain)
 	if (!t)
 		return NULL;
 
-	__nft_build_cache(h, NFT_CL_CHAINS, t, NULL, chain);
-
 	return h->cache->table[t->type].chains;
 }
 
diff --git a/iptables/nft.c b/iptables/nft.c
index a1e38cbafcbe..e65ee028c979 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1342,14 +1342,6 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 
 	nft_xt_builtin_init(h, table);
 
-	/* Since ebtables user-defined chain policies are implemented as last
-	 * rule in nftables, rule cache is required here to treat them right. */
-	if (h->family == NFPROTO_BRIDGE) {
-		c = nft_chain_find(h, table, chain);
-		if (c && !nft_chain_builtin(c))
-			nft_build_cache(h, c);
-	}
-
 	nft_fn = nft_rule_append;
 
 	if (ref) {
@@ -1574,7 +1566,6 @@ int nft_rule_save(struct nft_handle *h, const char *table, unsigned int format)
 
 	c = nftnl_chain_list_iter_next(iter);
 	while (c) {
-		nft_build_cache(h, c);
 		ret = nft_chain_save_rules(h, c, format);
 		if (ret != 0)
 			break;
@@ -1782,10 +1773,6 @@ static int __nft_chain_user_del(struct nftnl_chain *c, void *data)
 		fprintf(stdout, "Deleting chain `%s'\n",
 			nftnl_chain_get_str(c, NFTNL_CHAIN_NAME));
 
-	/* This triggers required policy rule deletion. */
-	if (h->family == NFPROTO_BRIDGE)
-		nft_build_cache(h, c);
-
 	/* XXX This triggers a fast lookup from the kernel. */
 	nftnl_chain_unset(c, NFTNL_CHAIN_HANDLE);
 	ret = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_DEL, c);
@@ -2068,8 +2055,6 @@ nft_rule_find(struct nft_handle *h, struct nftnl_chain *c,
 	struct nftnl_rule_iter *iter;
 	bool found = false;
 
-	nft_build_cache(h, c);
-
 	if (rulenum >= 0)
 		/* Delete by rule number case */
 		return nftnl_rule_lookup_byindex(c, rulenum);
@@ -2955,8 +2940,6 @@ int ebt_set_user_chain_policy(struct nft_handle *h, const char *table,
 	else
 		return 0;
 
-	nft_build_cache(h, c);
-
 	nftnl_chain_set_u32(c, NFTNL_CHAIN_POLICY, pval);
 	return 1;
 }
@@ -3317,8 +3300,6 @@ static int __nft_chain_zero_counters(struct nftnl_chain *c, void *data)
 			return -1;
 	}
 
-	nft_build_cache(h, c);
-
 	iter = nftnl_rule_iter_create(c);
 	if (iter == NULL)
 		return -1;
@@ -3455,8 +3436,6 @@ static int nft_is_chain_compatible(struct nftnl_chain *c, void *data)
 	enum nf_inet_hooks hook;
 	int prio;
 
-	nft_build_cache(h, c);
-
 	if (nftnl_rule_foreach(c, nft_is_rule_compatible, NULL))
 		return -1;
 
-- 
2.11.0

