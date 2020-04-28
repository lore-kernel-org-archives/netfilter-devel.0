Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D41A3C83000
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:11:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B652A206D6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgD1MLo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 08:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726554AbgD1MLo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 08:11:44 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFD8C03C1A9
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 05:11:44 -0700 (PDT)
Received: from localhost ([::1]:38698 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jTP5T-0008A5-2B; Tue, 28 Apr 2020 14:11:43 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 13/18] nft: cache: Introduce struct nft_cache_req
Date:   Tue, 28 Apr 2020 14:10:08 +0200
Message-Id: <20200428121013.24507-14-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200428121013.24507-1-phil@nwl.cc>
References: <20200428121013.24507-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This embedded struct collects cache requirement info gathered from parsed
nft_cmds and is interpreted by __nft_build_cache().

While being at it, remove unused parameters passed to the latter
function, nft_handle pointer is sufficient.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 32 +++++++++++++++++---------------
 iptables/nft.h       |  6 +++++-
 2 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 2c6a170881eb3..305f2c12307f7 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -26,10 +26,12 @@
 
 void nft_cache_level_set(struct nft_handle *h, int level)
 {
-	if (level <= h->cache_level)
+	struct nft_cache_req *req = &h->cache_req;
+
+	if (level <= req->level)
 		return;
 
-	h->cache_level = level;
+	req->level = level;
 }
 
 static int genid_cb(const struct nlmsghdr *nlh, void *data)
@@ -430,26 +432,26 @@ static int fetch_rule_cache(struct nft_handle *h,
 }
 
 static void
-__nft_build_cache(struct nft_handle *h, enum nft_cache_level level,
-		  const struct builtin_table *t, const char *set,
-		  const char *chain)
+__nft_build_cache(struct nft_handle *h)
 {
+	struct nft_cache_req *req = &h->cache_req;
+
 	if (h->cache_init)
 		return;
 
 	h->cache_init = true;
 	mnl_genid_get(h, &h->nft_genid);
 
-	if (h->cache_level >= NFT_CL_TABLES)
+	if (req->level >= NFT_CL_TABLES)
 		fetch_table_cache(h);
-	if (h->cache_level == NFT_CL_FAKE)
+	if (req->level == NFT_CL_FAKE)
 		return;
-	if (h->cache_level >= NFT_CL_CHAINS)
-		fetch_chain_cache(h, t, chain);
-	if (h->cache_level >= NFT_CL_SETS)
-		fetch_set_cache(h, t, set);
-	if (h->cache_level >= NFT_CL_RULES)
-		fetch_rule_cache(h, t);
+	if (req->level >= NFT_CL_CHAINS)
+		fetch_chain_cache(h, NULL, NULL);
+	if (req->level >= NFT_CL_SETS)
+		fetch_set_cache(h, NULL, NULL);
+	if (req->level >= NFT_CL_RULES)
+		fetch_rule_cache(h, NULL);
 }
 
 static void __nft_flush_cache(struct nft_handle *h)
@@ -563,12 +565,12 @@ void nft_rebuild_cache(struct nft_handle *h)
 		h->cache_init = false;
 	}
 
-	__nft_build_cache(h, h->cache_level, NULL, NULL, NULL);
+	__nft_build_cache(h);
 }
 
 void nft_cache_build(struct nft_handle *h)
 {
-	__nft_build_cache(h, h->cache_level, NULL, NULL, NULL);
+	__nft_build_cache(h);
 }
 
 void nft_release_cache(struct nft_handle *h)
diff --git a/iptables/nft.h b/iptables/nft.h
index 89c3620e7b7d7..c6aece7d1dac8 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -71,6 +71,10 @@ enum obj_update_type {
 	NFT_COMPAT_TABLE_NEW,
 };
 
+struct nft_cache_req {
+	enum nft_cache_level	level;
+};
+
 struct nft_handle {
 	int			family;
 	struct mnl_socket	*nl;
@@ -89,7 +93,7 @@ struct nft_handle {
 	unsigned int		cache_index;
 	struct nft_cache	__cache[2];
 	struct nft_cache	*cache;
-	enum nft_cache_level	cache_level;
+	struct nft_cache_req	cache_req;
 	bool			restore;
 	bool			noflush;
 	int8_t			config_done;
-- 
2.25.1

