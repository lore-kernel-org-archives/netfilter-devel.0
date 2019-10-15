Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DEC0C10F14
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 11:42:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 196BD21848
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 11:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729013AbfJOLmR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 07:42:17 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:36580 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbfJOLmR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 07:42:17 -0400
Received: from localhost ([::1]:49670 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iKLDU-0000yo-Mk; Tue, 15 Oct 2019 13:42:16 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v4 2/8] nft-cache: Fetch only chains in nft_chain_list_get()
Date:   Tue, 15 Oct 2019 13:41:46 +0200
Message-Id: <20191015114152.25254-3-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191015114152.25254-1-phil@nwl.cc>
References: <20191015114152.25254-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The function is used to return the given table's chains, so fetching
chain cache is enough.

Add calls to nft_build_cache() in places where a rule cache is required.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c |  2 +-
 iptables/nft.c       | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 04f42e0f8ad35..22468d70fec57 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -393,7 +393,7 @@ struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
 	if (!t)
 		return NULL;
 
-	nft_build_cache(h);
+	__nft_build_cache(h, NFT_CL_CHAINS);
 
 	return h->cache->table[t->type].chains;
 }
diff --git a/iptables/nft.c b/iptables/nft.c
index 81de10d8a0892..94fabd78e527e 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1173,6 +1173,14 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 
 	nft_xt_builtin_init(h, table);
 
+	/* Since ebtables user-defined chain policies are implemented as last
+	 * rule in nftables, rule cache is required here to treat them right. */
+	if (h->family == NFPROTO_BRIDGE) {
+		c = nft_chain_find(h, table, chain);
+		if (c && !nft_chain_builtin(c))
+			nft_build_cache(h);
+	}
+
 	nft_fn = nft_rule_append;
 
 	r = nft_rule_new(h, chain, table, data);
@@ -1397,6 +1405,8 @@ int nft_rule_save(struct nft_handle *h, const char *table, unsigned int format)
 	struct nftnl_chain *c;
 	int ret = 0;
 
+	nft_build_cache(h);
+
 	list = nft_chain_list_get(h, table);
 	if (!list)
 		return 0;
@@ -1595,6 +1605,10 @@ static int __nft_chain_user_del(struct nftnl_chain *c, void *data)
 		fprintf(stdout, "Deleting chain `%s'\n",
 			nftnl_chain_get_str(c, NFTNL_CHAIN_NAME));
 
+	/* This triggers required policy rule deletion. */
+	if (h->family == NFPROTO_BRIDGE)
+		nft_build_cache(h);
+
 	/* XXX This triggers a fast lookup from the kernel. */
 	nftnl_chain_unset(c, NFTNL_CHAIN_HANDLE);
 	ret = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_DEL, c);
@@ -1876,6 +1890,8 @@ nft_rule_find(struct nft_handle *h, struct nftnl_chain *c, void *data, int rulen
 	struct nftnl_rule_iter *iter;
 	bool found = false;
 
+	nft_build_cache(h);
+
 	if (rulenum >= 0)
 		/* Delete by rule number case */
 		return nftnl_rule_lookup_byindex(c, rulenum);
@@ -2701,6 +2717,8 @@ int ebt_set_user_chain_policy(struct nft_handle *h, const char *table,
 	else
 		return 0;
 
+	nft_build_cache(h);
+
 	nftnl_chain_set_u32(c, NFTNL_CHAIN_POLICY, pval);
 	return 1;
 }
@@ -3038,6 +3056,8 @@ static int nft_is_chain_compatible(struct nftnl_chain *c, void *data)
 	enum nf_inet_hooks hook;
 	int prio;
 
+	nft_build_cache(h);
+
 	if (nftnl_rule_foreach(c, nft_is_rule_compatible, NULL))
 		return -1;
 
-- 
2.23.0

