Return-Path: <SRS0=hj4T=4T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53E1BC3F2CD
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Mar 2020 17:54:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AFD82173E
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Mar 2020 17:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbgCBRyT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 12:54:19 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:53330 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727126AbgCBRyS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 12:54:18 -0500
Received: from localhost ([::1]:38188 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1j8pGj-0007J8-Q2; Mon, 02 Mar 2020 18:54:17 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/4] nft: cache: Make nft_rebuild_cache() respect fake cache
Date:   Mon,  2 Mar 2020 18:53:56 +0100
Message-Id: <20200302175358.27796-3-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200302175358.27796-1-phil@nwl.cc>
References: <20200302175358.27796-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If transaction needed a refresh in nft_action(), restore with flush
would fetch a full cache instead of merely refreshing table list
contained in "fake" cache.

To fix this, nft_rebuild_cache() must distinguish between fake cache and
full rule cache. Therefore introduce NFT_CL_FAKE to be distinguished
from NFT_CL_RULES.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 11 ++++++++---
 iptables/nft.h       |  3 ++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 6f21f2283e0fb..e1b1e89c9e0d3 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -484,6 +484,7 @@ retry:
 			break;
 		/* fall through */
 	case NFT_CL_RULES:
+	case NFT_CL_FAKE:
 		break;
 	}
 
@@ -528,7 +529,7 @@ void nft_fake_cache(struct nft_handle *h)
 
 		h->cache->table[type].chains = nftnl_chain_list_alloc();
 	}
-	h->cache_level = NFT_CL_RULES;
+	h->cache_level = NFT_CL_FAKE;
 	mnl_genid_get(h, &h->nft_genid);
 }
 
@@ -641,8 +642,12 @@ void nft_rebuild_cache(struct nft_handle *h)
 	if (h->cache_level)
 		__nft_flush_cache(h);
 
-	h->cache_level = NFT_CL_NONE;
-	__nft_build_cache(h, level, NULL, NULL, NULL);
+	if (h->cache_level == NFT_CL_FAKE) {
+		nft_fake_cache(h);
+	} else {
+		h->cache_level = NFT_CL_NONE;
+		__nft_build_cache(h, level, NULL, NULL, NULL);
+	}
 }
 
 void nft_release_cache(struct nft_handle *h)
diff --git a/iptables/nft.h b/iptables/nft.h
index 5cf260a6d2cd3..2094b01455194 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -32,7 +32,8 @@ enum nft_cache_level {
 	NFT_CL_TABLES,
 	NFT_CL_CHAINS,
 	NFT_CL_SETS,
-	NFT_CL_RULES
+	NFT_CL_RULES,
+	NFT_CL_FAKE	/* must be last entry */
 };
 
 struct nft_cache {
-- 
2.25.1

