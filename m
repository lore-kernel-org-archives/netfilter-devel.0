Return-Path: <SRS0=FJFf=5X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DBDAC2BA2B
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Apr 2020 14:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F8BE2072A
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Apr 2020 14:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgDGOfL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Apr 2020 10:35:11 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:54954 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728306AbgDGOfL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Apr 2020 10:35:11 -0400
Received: from localhost ([::1]:39812 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jLpJl-0007fk-Vj; Tue, 07 Apr 2020 16:35:10 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/3] nft: cache: Eliminate init_chain_cache()
Date:   Tue,  7 Apr 2020 16:34:43 +0200
Message-Id: <20200407143445.26394-2-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200407143445.26394-1-phil@nwl.cc>
References: <20200407143445.26394-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The function is always called immediately after fetch_table_cache(), so
merge it into the latter.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index a0c76705c848e..369692fe44fc7 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -86,7 +86,7 @@ static int fetch_table_cache(struct nft_handle *h)
 	char buf[16536];
 	struct nlmsghdr *nlh;
 	struct nftnl_table_list *list;
-	int ret;
+	int i, ret;
 
 	if (h->cache->tables)
 		return 0;
@@ -104,13 +104,6 @@ static int fetch_table_cache(struct nft_handle *h)
 
 	h->cache->tables = list;
 
-	return 1;
-}
-
-static int init_chain_cache(struct nft_handle *h)
-{
-	int i;
-
 	for (i = 0; i < NFT_TABLE_MAX; i++) {
 		enum nft_table_type type = h->tables[i].type;
 
@@ -119,9 +112,10 @@ static int init_chain_cache(struct nft_handle *h)
 
 		h->cache->table[type].chains = nftnl_chain_list_alloc();
 		if (!h->cache->table[type].chains)
-			return -1;
+			return 0;
 	}
-	return 0;
+
+	return 1;
 }
 
 struct nftnl_chain_list_cb_data {
@@ -458,7 +452,6 @@ __nft_build_cache(struct nft_handle *h, enum nft_cache_level level,
 	switch (h->cache_level) {
 	case NFT_CL_NONE:
 		fetch_table_cache(h);
-		init_chain_cache(h);
 		if (level == NFT_CL_TABLES)
 			break;
 		/* fall through */
@@ -505,7 +498,6 @@ void nft_build_cache(struct nft_handle *h, struct nftnl_chain *c)
 void nft_fake_cache(struct nft_handle *h)
 {
 	fetch_table_cache(h);
-	init_chain_cache(h);
 
 	h->cache_level = NFT_CL_FAKE;
 	mnl_genid_get(h, &h->nft_genid);
-- 
2.25.1

