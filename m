Return-Path: <SRS0=bnKo=YB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF81C4360C
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Oct 2019 16:15:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF3FC206C2
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Oct 2019 16:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbfJHQPp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Oct 2019 12:15:45 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:48526 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbfJHQPp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Oct 2019 12:15:45 -0400
Received: from localhost ([::1]:33384 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iHs9I-0004Xx-33; Tue, 08 Oct 2019 18:15:44 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 01/11] nft: Pass nft_handle to flush_cache()
Date:   Tue,  8 Oct 2019 18:14:37 +0200
Message-Id: <20191008161447.6595-2-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191008161447.6595-1-phil@nwl.cc>
References: <20191008161447.6595-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This allows to call nft_table_builtin_find() and hence removes the only
real user of __nft_table_builtin_find(). Consequently remove the latter
by integrating it into its sole caller.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index a2f36b7ee90d2..bdc9fbc37f110 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -703,31 +703,25 @@ static void nft_chain_builtin_add(struct nft_handle *h,
 	nftnl_chain_list_add_tail(c, h->cache->table[table->type].chains);
 }
 
-static const struct builtin_table *
-__nft_table_builtin_find(const struct builtin_table *tables, const char *table)
+/* find if built-in table already exists */
+const struct builtin_table *
+nft_table_builtin_find(struct nft_handle *h, const char *table)
 {
 	int i;
 	bool found = false;
 
 	for (i = 0; i < NFT_TABLE_MAX; i++) {
-		if (tables[i].name == NULL)
+		if (h->tables[i].name == NULL)
 			continue;
 
-		if (strcmp(tables[i].name, table) != 0)
+		if (strcmp(h->tables[i].name, table) != 0)
 			continue;
 
 		found = true;
 		break;
 	}
 
-	return found ? &tables[i] : NULL;
-}
-
-/* find if built-in table already exists */
-const struct builtin_table *
-nft_table_builtin_find(struct nft_handle *h, const char *table)
-{
-	return __nft_table_builtin_find(h->tables, table);
+	return found ? &h->tables[i] : NULL;
 }
 
 /* find if built-in chain already exists */
@@ -857,14 +851,14 @@ static int __flush_chain_cache(struct nftnl_chain *c, void *data)
 	return 0;
 }
 
-static int flush_cache(struct nft_cache *c, const struct builtin_table *tables,
+static int flush_cache(struct nft_handle *h, struct nft_cache *c,
 		       const char *tablename)
 {
 	const struct builtin_table *table;
 	int i;
 
 	if (tablename) {
-		table = __nft_table_builtin_find(tables, tablename);
+		table = nft_table_builtin_find(h, tablename);
 		if (!table || !c->table[table->type].chains)
 			return 0;
 		nftnl_chain_list_foreach(c->table[table->type].chains,
@@ -873,7 +867,7 @@ static int flush_cache(struct nft_cache *c, const struct builtin_table *tables,
 	}
 
 	for (i = 0; i < NFT_TABLE_MAX; i++) {
-		if (tables[i].name == NULL)
+		if (h->tables[i].name == NULL)
 			continue;
 
 		if (!c->table[i].chains)
@@ -893,7 +887,7 @@ static void flush_chain_cache(struct nft_handle *h, const char *tablename)
 	if (!h->have_cache)
 		return;
 
-	if (flush_cache(h->cache, h->tables, tablename))
+	if (flush_cache(h, h->cache, tablename))
 		h->have_cache = false;
 }
 
@@ -1655,7 +1649,7 @@ static void nft_rebuild_cache(struct nft_handle *h)
 static void nft_release_cache(struct nft_handle *h)
 {
 	if (h->cache_index)
-		flush_cache(&h->__cache[0], h->tables, NULL);
+		flush_cache(h, &h->__cache[0], NULL);
 }
 
 struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
-- 
2.23.0

