Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6331DC83006
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C44F206D7
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:10:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgD1MKu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 08:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726554AbgD1MKt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 08:10:49 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83FAC03C1A9
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 05:10:49 -0700 (PDT)
Received: from localhost ([::1]:38638 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jTP4a-000861-Lf; Tue, 28 Apr 2020 14:10:48 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 03/18] nft: cache: Init per table set list along with chain list
Date:   Tue, 28 Apr 2020 14:09:58 +0200
Message-Id: <20200428121013.24507-4-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200428121013.24507-1-phil@nwl.cc>
References: <20200428121013.24507-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This simplifies code a bit and also aligns set and chain lists handling
in cache.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 369692fe44fc7..e042bd83bebf5 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -113,6 +113,10 @@ static int fetch_table_cache(struct nft_handle *h)
 		h->cache->table[type].chains = nftnl_chain_list_alloc();
 		if (!h->cache->table[type].chains)
 			return 0;
+
+		h->cache->table[type].sets = nftnl_set_list_alloc();
+		if (!h->cache->table[type].sets)
+			return 0;
 	}
 
 	return 1;
@@ -254,21 +258,6 @@ static int fetch_set_cache(struct nft_handle *h,
 	char buf[16536];
 	int i, ret;
 
-	if (!t) {
-		for (i = 0; i < NFT_TABLE_MAX; i++) {
-			enum nft_table_type type = h->tables[i].type;
-
-			if (!h->tables[i].name)
-				continue;
-
-			h->cache->table[type].sets = nftnl_set_list_alloc();
-			if (!h->cache->table[type].sets)
-				return -1;
-		}
-	} else if (!h->cache->table[t->type].sets) {
-		h->cache->table[t->type].sets = nftnl_set_list_alloc();
-	}
-
 	if (t && set) {
 		struct nftnl_set *s = nftnl_set_alloc();
 
-- 
2.25.1

