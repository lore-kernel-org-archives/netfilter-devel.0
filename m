Return-Path: <SRS0=hj4T=4T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C59C3F2CD
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Mar 2020 17:54:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 899572173E
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Mar 2020 17:54:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgCBRyO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 12:54:14 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:53324 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgCBRyO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 12:54:14 -0500
Received: from localhost ([::1]:38182 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1j8pGe-0007Il-G5; Mon, 02 Mar 2020 18:54:12 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/4] nft: cache: Simplify chain list allocation
Date:   Mon,  2 Mar 2020 18:53:57 +0100
Message-Id: <20200302175358.27796-4-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200302175358.27796-1-phil@nwl.cc>
References: <20200302175358.27796-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Allocate chain lists right after fetching table cache, regardless of
whether partial cache is fetched or not. Chain list pointers reside in
struct nft_cache's table array and hence are present irrespective of
actual tables in kernel. Given the small number of tables, there wasn't
much overhead avoided by the conditional in fetch_chain_cache().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 46 ++++++++++++++++++--------------------------
 1 file changed, 19 insertions(+), 27 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index e1b1e89c9e0d3..0429fb32f2ed0 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -107,6 +107,23 @@ static int fetch_table_cache(struct nft_handle *h)
 	return 1;
 }
 
+static int init_chain_cache(struct nft_handle *h)
+{
+	int i;
+
+	for (i = 0; i < NFT_TABLE_MAX; i++) {
+		enum nft_table_type type = h->tables[i].type;
+
+		if (!h->tables[i].name)
+			continue;
+
+		h->cache->table[type].chains = nftnl_chain_list_alloc();
+		if (!h->cache->table[type].chains)
+			return -1;
+	}
+	return 0;
+}
+
 struct nftnl_chain_list_cb_data {
 	struct nft_handle *h;
 	const struct builtin_table *t;
@@ -316,26 +333,6 @@ static int fetch_chain_cache(struct nft_handle *h,
 	struct nlmsghdr *nlh;
 	int i, ret;
 
-	if (!t) {
-		for (i = 0; i < NFT_TABLE_MAX; i++) {
-			enum nft_table_type type = h->tables[i].type;
-
-			if (!h->tables[i].name)
-				continue;
-
-			if (h->cache->table[type].chains)
-				continue;
-
-			h->cache->table[type].chains = nftnl_chain_list_alloc();
-			if (!h->cache->table[type].chains)
-				return -1;
-		}
-	} else if (!h->cache->table[t->type].chains) {
-		h->cache->table[t->type].chains = nftnl_chain_list_alloc();
-		if (!h->cache->table[t->type].chains)
-			return -1;
-	}
-
 	if (t && chain) {
 		struct nftnl_chain *c = nftnl_chain_alloc();
 
@@ -465,6 +462,7 @@ retry:
 	switch (h->cache_level) {
 	case NFT_CL_NONE:
 		fetch_table_cache(h);
+		init_chain_cache(h);
 		if (level == NFT_CL_TABLES)
 			break;
 		/* fall through */
@@ -521,14 +519,8 @@ void nft_fake_cache(struct nft_handle *h)
 	int i;
 
 	fetch_table_cache(h);
-	for (i = 0; i < NFT_TABLE_MAX; i++) {
-		enum nft_table_type type = h->tables[i].type;
+	init_chain_cache(h);
 
-		if (!h->tables[i].name)
-			continue;
-
-		h->cache->table[type].chains = nftnl_chain_list_alloc();
-	}
 	h->cache_level = NFT_CL_FAKE;
 	mnl_genid_get(h, &h->nft_genid);
 }
-- 
2.25.1

