Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87492C83000
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69ED4206D7
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgD1MKe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 08:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726682AbgD1MKe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 08:10:34 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7D2C03C1A9
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 05:10:33 -0700 (PDT)
Received: from localhost ([::1]:38620 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jTP4K-00084q-P8; Tue, 28 Apr 2020 14:10:32 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 11/18] nft: cache: Simplify rule and set fetchers
Date:   Tue, 28 Apr 2020 14:10:06 +0200
Message-Id: <20200428121013.24507-12-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200428121013.24507-1-phil@nwl.cc>
References: <20200428121013.24507-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since no incremental cache fetching happens anymore, code fetching rules
for chains or elements for sets may safely assume that whatever is in
cache also didn't get populated with rules or elements before.

Therefore no (optional) chain name needs to be passed on to
fetch_rule_cache() and fetch_set_cache() doesn't have to select for
which sets in a table to call set_fetch_elem_cb().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 6db261fbba4b3..e0c1387071330 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -295,11 +295,7 @@ static int fetch_set_cache(struct nft_handle *h,
 		return ret;
 	}
 
-	if (t && set) {
-		s = nftnl_set_list_lookup_byname(h->cache->table[t->type].sets,
-						 set);
-		set_fetch_elem_cb(s, h);
-	} else if (t) {
+	if (t) {
 		nftnl_set_list_foreach(h->cache->table[t->type].sets,
 				       set_fetch_elem_cb, h);
 	} else {
@@ -409,20 +405,14 @@ static int nft_rule_list_update(struct nftnl_chain *c, void *data)
 }
 
 static int fetch_rule_cache(struct nft_handle *h,
-			    const struct builtin_table *t, const char *chain)
+			    const struct builtin_table *t)
 {
 	int i;
 
 	if (t) {
-		struct nftnl_chain_list *list;
-		struct nftnl_chain *c;
-
-		list = h->cache->table[t->type].chains;
+		struct nftnl_chain_list *list =
+			h->cache->table[t->type].chains;
 
-		if (chain) {
-			c = nftnl_chain_list_lookup_byname(list, chain);
-			return nft_rule_list_update(c, h);
-		}
 		return nftnl_chain_list_foreach(list, nft_rule_list_update, h);
 	}
 
@@ -457,7 +447,7 @@ __nft_build_cache(struct nft_handle *h, enum nft_cache_level level,
 	if (h->cache_level >= NFT_CL_SETS)
 		fetch_set_cache(h, t, set);
 	if (h->cache_level >= NFT_CL_RULES)
-		fetch_rule_cache(h, t, chain);
+		fetch_rule_cache(h, t);
 }
 
 void nft_fake_cache(struct nft_handle *h)
-- 
2.25.1

