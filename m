Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8706ECE588
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 11:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9658021848
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 11:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbfJOLmo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 07:42:44 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:36610 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729163AbfJOLmo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 07:42:44 -0400
Received: from localhost ([::1]:49700 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iKLDv-000112-84; Tue, 15 Oct 2019 13:42:43 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v4 1/8] nft-cache: Introduce cache levels
Date:   Tue, 15 Oct 2019 13:41:45 +0200
Message-Id: <20191015114152.25254-2-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191015114152.25254-1-phil@nwl.cc>
References: <20191015114152.25254-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Replace the simple have_cache boolean by a cache level indicator
defining how complete the cache is. Since have_cache indicated full
cache (including rules), make code depending on it check for cache level
NFT_CL_RULES.

Core cache fetching routine __nft_build_cache() accepts a new level via
parameter and raises cache completeness to that level.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v3:
- Make sure cache stays consistent in __nft_build_cache() by extending
  cache only if kernel ruleset did not change since last call.
---
 iptables/nft-cache.c | 54 ++++++++++++++++++++++++++++++++------------
 iptables/nft.h       |  9 +++++++-
 2 files changed, 47 insertions(+), 16 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 5444419a5cc3b..04f42e0f8ad35 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -224,30 +224,52 @@ static int fetch_rule_cache(struct nft_handle *h)
 	return 0;
 }
 
-static void __nft_build_cache(struct nft_handle *h)
+static void __nft_build_cache(struct nft_handle *h, enum nft_cache_level level)
 {
 	uint32_t genid_start, genid_stop;
 
+	if (level <= h->cache_level)
+		return;
 retry:
 	mnl_genid_get(h, &genid_start);
-	fetch_table_cache(h);
-	fetch_chain_cache(h);
-	fetch_rule_cache(h);
-	h->have_cache = true;
-	mnl_genid_get(h, &genid_stop);
 
+	if (h->cache_level && genid_start != h->nft_genid)
+		flush_chain_cache(h, NULL);
+
+	switch (h->cache_level) {
+	case NFT_CL_NONE:
+		fetch_table_cache(h);
+		if (level == NFT_CL_TABLES)
+			break;
+		/* fall through */
+	case NFT_CL_TABLES:
+		fetch_chain_cache(h);
+		if (level == NFT_CL_CHAINS)
+			break;
+		/* fall through */
+	case NFT_CL_CHAINS:
+		fetch_rule_cache(h);
+		if (level == NFT_CL_RULES)
+			break;
+		/* fall through */
+	case NFT_CL_RULES:
+		break;
+	}
+
+	mnl_genid_get(h, &genid_stop);
 	if (genid_start != genid_stop) {
 		flush_chain_cache(h, NULL);
 		goto retry;
 	}
 
+	h->cache_level = level;
 	h->nft_genid = genid_start;
 }
 
 void nft_build_cache(struct nft_handle *h)
 {
-	if (!h->have_cache)
-		__nft_build_cache(h);
+	if (h->cache_level < NFT_CL_RULES)
+		__nft_build_cache(h, NFT_CL_RULES);
 }
 
 void nft_fake_cache(struct nft_handle *h)
@@ -263,7 +285,7 @@ void nft_fake_cache(struct nft_handle *h)
 
 		h->cache->table[type].chains = nftnl_chain_list_alloc();
 	}
-	h->have_cache = true;
+	h->cache_level = NFT_CL_RULES;
 	mnl_genid_get(h, &h->nft_genid);
 }
 
@@ -331,19 +353,22 @@ static int flush_cache(struct nft_handle *h, struct nft_cache *c,
 
 void flush_chain_cache(struct nft_handle *h, const char *tablename)
 {
-	if (!h->have_cache)
+	if (!h->cache_level)
 		return;
 
 	if (flush_cache(h, h->cache, tablename))
-		h->have_cache = false;
+		h->cache_level = NFT_CL_NONE;
 }
 
 void nft_rebuild_cache(struct nft_handle *h)
 {
-	if (h->have_cache)
+	enum nft_cache_level level = h->cache_level;
+
+	if (h->cache_level)
 		__nft_flush_cache(h);
 
-	__nft_build_cache(h);
+	h->cache_level = NFT_CL_NONE;
+	__nft_build_cache(h, level);
 }
 
 void nft_release_cache(struct nft_handle *h)
@@ -354,8 +379,7 @@ void nft_release_cache(struct nft_handle *h)
 
 struct nftnl_table_list *nftnl_table_list_get(struct nft_handle *h)
 {
-	if (!h->cache->tables)
-		fetch_table_cache(h);
+	__nft_build_cache(h, NFT_CL_TABLES);
 
 	return h->cache->tables;
 }
diff --git a/iptables/nft.h b/iptables/nft.h
index 451c266016d8d..9ae3122a1c515 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -27,6 +27,13 @@ struct builtin_table {
 	struct builtin_chain chains[NF_INET_NUMHOOKS];
 };
 
+enum nft_cache_level {
+	NFT_CL_NONE,
+	NFT_CL_TABLES,
+	NFT_CL_CHAINS,
+	NFT_CL_RULES
+};
+
 struct nft_cache {
 	struct nftnl_table_list		*tables;
 	struct {
@@ -53,7 +60,7 @@ struct nft_handle {
 	unsigned int		cache_index;
 	struct nft_cache	__cache[2];
 	struct nft_cache	*cache;
-	bool			have_cache;
+	enum nft_cache_level	cache_level;
 	bool			restore;
 	bool			noflush;
 	int8_t			config_done;
-- 
2.23.0

