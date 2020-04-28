Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB841C83006
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAD7F206D6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgD1MKz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 08:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726554AbgD1MKz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 08:10:55 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D202C03C1A9
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 05:10:55 -0700 (PDT)
Received: from localhost ([::1]:38644 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jTP4f-00086R-V8; Tue, 28 Apr 2020 14:10:54 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 12/18] nft: cache: Improve fake cache integration
Date:   Tue, 28 Apr 2020 14:10:07 +0200
Message-Id: <20200428121013.24507-13-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200428121013.24507-1-phil@nwl.cc>
References: <20200428121013.24507-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With NFT_CL_FAKE being highest cache level while at the same time
__nft_build_cache() treating it equal to NFT_CL_TABLES, no special
handling for fake cache is required anymore.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c       | 16 +++-------------
 iptables/nft-cache.h       |  1 -
 iptables/xtables-restore.c |  2 +-
 3 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index e0c1387071330..2c6a170881eb3 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -442,6 +442,8 @@ __nft_build_cache(struct nft_handle *h, enum nft_cache_level level,
 
 	if (h->cache_level >= NFT_CL_TABLES)
 		fetch_table_cache(h);
+	if (h->cache_level == NFT_CL_FAKE)
+		return;
 	if (h->cache_level >= NFT_CL_CHAINS)
 		fetch_chain_cache(h, t, chain);
 	if (h->cache_level >= NFT_CL_SETS)
@@ -450,15 +452,6 @@ __nft_build_cache(struct nft_handle *h, enum nft_cache_level level,
 		fetch_rule_cache(h, t);
 }
 
-void nft_fake_cache(struct nft_handle *h)
-{
-	fetch_table_cache(h);
-
-	h->cache_level = NFT_CL_FAKE;
-	h->cache_init = true;
-	mnl_genid_get(h, &h->nft_genid);
-}
-
 static void __nft_flush_cache(struct nft_handle *h)
 {
 	if (!h->cache_index) {
@@ -570,10 +563,7 @@ void nft_rebuild_cache(struct nft_handle *h)
 		h->cache_init = false;
 	}
 
-	if (h->cache_level == NFT_CL_FAKE)
-		nft_fake_cache(h);
-	else
-		__nft_build_cache(h, h->cache_level, NULL, NULL, NULL);
+	__nft_build_cache(h, h->cache_level, NULL, NULL, NULL);
 }
 
 void nft_cache_build(struct nft_handle *h)
diff --git a/iptables/nft-cache.h b/iptables/nft-cache.h
index 8c63d8d566c19..01dd15e145fd4 100644
--- a/iptables/nft-cache.h
+++ b/iptables/nft-cache.h
@@ -4,7 +4,6 @@
 struct nft_handle;
 
 void nft_cache_level_set(struct nft_handle *h, int level);
-void nft_fake_cache(struct nft_handle *h);
 void nft_rebuild_cache(struct nft_handle *h);
 void nft_release_cache(struct nft_handle *h);
 void flush_chain_cache(struct nft_handle *h, const char *tablename);
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index a58c6a5bdca7a..ca01d17eba566 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -259,7 +259,7 @@ void xtables_restore_parse(struct nft_handle *h,
 	char buffer[10240] = {};
 
 	if (!h->noflush)
-		nft_fake_cache(h);
+		nft_cache_level_set(h, NFT_CL_FAKE);
 
 	line = 0;
 	while (fgets(buffer, sizeof(buffer), p->in)) {
-- 
2.25.1

