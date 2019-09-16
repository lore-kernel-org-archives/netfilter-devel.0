Return-Path: <SRS0=EuAs=XL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 821A4C49ED7
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 16:51:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C666206C2
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 16:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390267AbfIPQvK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Sep 2019 12:51:10 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:51214 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729084AbfIPQvJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Sep 2019 12:51:09 -0400
Received: from localhost ([::1]:36072 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1i9uDU-0003qk-6k; Mon, 16 Sep 2019 18:51:08 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 09/14] nft: Rename have_cache into have_chain_cache
Date:   Mon, 16 Sep 2019 18:49:55 +0200
Message-Id: <20190916165000.18217-10-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190916165000.18217-1-phil@nwl.cc>
References: <20190916165000.18217-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Prepare for optional rule cache by renaming the boolean.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 14 +++++++-------
 iptables/nft.h |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 820f3392dd495..1483664510518 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -891,11 +891,11 @@ static int flush_cache(struct nft_cache *c, const struct builtin_table *tables,
 
 static void flush_chain_cache(struct nft_handle *h, const char *tablename)
 {
-	if (!h->have_cache)
+	if (!h->have_chain_cache)
 		return;
 
 	if (flush_cache(h->cache, h->tables, tablename))
-		h->have_cache = false;
+		h->have_chain_cache = false;
 }
 
 void nft_fini(struct nft_handle *h)
@@ -1601,7 +1601,7 @@ retry:
 	mnl_genid_get(h, &genid_start);
 	fetch_chain_cache(h);
 	fetch_rule_cache(h);
-	h->have_cache = true;
+	h->have_chain_cache = true;
 	mnl_genid_get(h, &genid_stop);
 
 	if (genid_start != genid_stop) {
@@ -1614,7 +1614,7 @@ retry:
 
 void nft_build_cache(struct nft_handle *h)
 {
-	if (!h->have_cache)
+	if (!h->have_chain_cache)
 		__nft_build_cache(h);
 }
 
@@ -1622,7 +1622,7 @@ void nft_fake_cache(struct nft_handle *h)
 {
 	int i;
 
-	if (h->have_cache)
+	if (h->have_chain_cache)
 		return;
 
 	/* fetch tables so conditional table delete logic works */
@@ -1639,7 +1639,7 @@ void nft_fake_cache(struct nft_handle *h)
 		h->cache->table[type].chains = nftnl_chain_list_alloc();
 	}
 	mnl_genid_get(h, &h->nft_genid);
-	h->have_cache = true;
+	h->have_chain_cache = true;
 }
 
 static void __nft_flush_cache(struct nft_handle *h)
@@ -1654,7 +1654,7 @@ static void __nft_flush_cache(struct nft_handle *h)
 
 static void nft_rebuild_cache(struct nft_handle *h)
 {
-	if (h->have_cache)
+	if (h->have_chain_cache)
 		__nft_flush_cache(h);
 
 	__nft_build_cache(h);
diff --git a/iptables/nft.h b/iptables/nft.h
index d9eb30a2a2413..11b2d4e3be6ff 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -53,7 +53,7 @@ struct nft_handle {
 	unsigned int		cache_index;
 	struct nft_cache	__cache[2];
 	struct nft_cache	*cache;
-	bool			have_cache;
+	bool			have_chain_cache;
 	bool			restore;
 	bool			noflush;
 	int8_t			config_done;
-- 
2.23.0

