Return-Path: <SRS0=Dam8=46=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D324BC2BB1D
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Mar 2020 17:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9665206CD
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Mar 2020 17:42:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgCMRmR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Mar 2020 13:42:17 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:52494 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbgCMRmR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Mar 2020 13:42:17 -0400
Received: from localhost ([::1]:37352 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jCoK7-0007BG-FY; Fri, 13 Mar 2020 18:42:15 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] nft: cache: Fix iptables-save segfault under stress
Date:   Fri, 13 Mar 2020 18:42:06 +0100
Message-Id: <20200313174206.32636-1-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If kernel ruleset is constantly changing, code called by
nft_is_table_compatible() may crash: For each item in table's chain
list, nft_is_chain_compatible() is called. This in turn calls
nft_build_cache() to fetch chain's rules. Though if kernel genid has changed
meanwhile, cache is flushed and rebuilt from scratch, thereby freeing
table's chain list - the foreach loop in nft_is_table_compatible() then
operates on freed memory.

A simple reproducer (may need a few calls):

| RULESET='*filter
| :INPUT ACCEPT [10517:1483527]
| :FORWARD ACCEPT [0:0]
| :OUTPUT ACCEPT [1714:105671]
| COMMIT
| '
|
| for ((i = 0; i < 100; i++)); do
|         iptables-nft-restore <<< "$RULESET" &
| done &
| iptables-nft-save

To fix the problem, basically revert commit ab1cd3b510fa5 ("nft: ensure
cache consistency") so that __nft_build_cache() no longer flushes the
cache. Instead just record kernel's genid when fetching for the first
time. If kernel rule set changes until the changes are committed, the
commit simply fails and local cache is being rebuilt.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Pablo,

This is a similar situation as with commit c550c81fd373e ("nft: cache:
Fix nft_release_cache() under stress"): Your caching rewrite avoids this
problem as well, but kills some of my performance improvements. I'm
currently working on restoring them with your approach but that's not a
quick "fix". Can we go with this patch until I'm done?

Cheers, Phil
---
 iptables/nft-cache.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index e3c9655739187..a0c76705c848e 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -449,15 +449,11 @@ __nft_build_cache(struct nft_handle *h, enum nft_cache_level level,
 		  const struct builtin_table *t, const char *set,
 		  const char *chain)
 {
-	uint32_t genid_start, genid_stop;
-
 	if (level <= h->cache_level)
 		return;
-retry:
-	mnl_genid_get(h, &genid_start);
 
-	if (h->cache_level && genid_start != h->nft_genid)
-		flush_chain_cache(h, NULL);
+	if (!h->nft_genid)
+		mnl_genid_get(h, &h->nft_genid);
 
 	switch (h->cache_level) {
 	case NFT_CL_NONE:
@@ -486,18 +482,10 @@ retry:
 		break;
 	}
 
-	mnl_genid_get(h, &genid_stop);
-	if (genid_start != genid_stop) {
-		flush_chain_cache(h, NULL);
-		goto retry;
-	}
-
 	if (!t && !chain)
 		h->cache_level = level;
 	else if (h->cache_level < NFT_CL_TABLES)
 		h->cache_level = NFT_CL_TABLES;
-
-	h->nft_genid = genid_start;
 }
 
 void nft_build_cache(struct nft_handle *h, struct nftnl_chain *c)
-- 
2.25.1

