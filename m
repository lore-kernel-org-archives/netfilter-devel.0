Return-Path: <SRS0=5odi=AW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCAA8C433E0
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B60E6206F4
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgGKKTw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Jul 2020 06:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgGKKTw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Jul 2020 06:19:52 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385B6C08C5DD
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Jul 2020 03:19:52 -0700 (PDT)
Received: from localhost ([::1]:59484 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1juCbm-0007I0-OM; Sat, 11 Jul 2020 12:19:50 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 15/18] nft: Introduce a dedicated base chain array
Date:   Sat, 11 Jul 2020 12:18:28 +0200
Message-Id: <20200711101831.29506-16-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200711101831.29506-1-phil@nwl.cc>
References: <20200711101831.29506-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Preparing for sorted chain output, introduce a per-table array holding
base chains indexed by nf_inet_hooks value. Since the latter is ordered
correctly, iterating over the array will return base chains in expected
order.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 27 ++++++++++++++++++++++++++-
 iptables/nft.c       | 38 ++++++++++++++++++++++++++++----------
 iptables/nft.h       |  1 +
 3 files changed, 55 insertions(+), 11 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 26771df63bcc2..5853bdce82f88 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -184,6 +184,19 @@ static int fetch_table_cache(struct nft_handle *h)
 int nft_cache_add_chain(struct nft_handle *h, const struct builtin_table *t,
 			struct nftnl_chain *c)
 {
+	if (nftnl_chain_is_set(c, NFTNL_CHAIN_HOOKNUM)) {
+		uint32_t hooknum = nftnl_chain_get_u32(c, NFTNL_CHAIN_HOOKNUM);
+
+		if (hooknum >= NF_INET_NUMHOOKS)
+			return -EINVAL;
+
+		if (h->cache->table[t->type].base_chains[hooknum])
+			return -EEXIST;
+
+		h->cache->table[t->type].base_chains[hooknum] = c;
+		return 0;
+	}
+
 	nftnl_chain_list_add_tail(c, h->cache->table[t->type].chains);
 	return 0;
 }
@@ -592,12 +605,18 @@ static int flush_cache(struct nft_handle *h, struct nft_cache *c,
 		       const char *tablename)
 {
 	const struct builtin_table *table;
-	int i;
+	int i, j;
 
 	if (tablename) {
 		table = nft_table_builtin_find(h, tablename);
 		if (!table)
 			return 0;
+		for (i = 0; i < NF_INET_NUMHOOKS; i++) {
+			if (!c->table[table->type].base_chains[i])
+				continue;
+			nftnl_chain_free(c->table[table->type].base_chains[i]);
+			c->table[table->type].base_chains[i] = NULL;
+		}
 		if (c->table[table->type].chains)
 			nftnl_chain_list_foreach(c->table[table->type].chains,
 						 __flush_chain_cache, NULL);
@@ -611,6 +630,12 @@ static int flush_cache(struct nft_handle *h, struct nft_cache *c,
 		if (h->tables[i].name == NULL)
 			continue;
 
+		for (j = 0; j < NF_INET_NUMHOOKS; j++) {
+			if (!c->table[i].base_chains[j])
+				continue;
+			nftnl_chain_free(c->table[i].base_chains[j]);
+			c->table[i].base_chains[j] = NULL;
+		}
 		if (c->table[i].chains) {
 			nftnl_chain_list_free(c->table[i].chains);
 			c->table[i].chains = NULL;
diff --git a/iptables/nft.c b/iptables/nft.c
index be1275f3357a2..a83856f16596e 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -701,7 +701,7 @@ static void nft_chain_builtin_add(struct nft_handle *h,
 		return;
 
 	batch_chain_add(h, NFT_COMPAT_CHAIN_ADD, c);
-	nftnl_chain_list_add_tail(c, h->cache->table[table->type].chains);
+	h->cache->table[table->type].base_chains[chain->hook] = c;
 }
 
 /* find if built-in table already exists */
@@ -745,19 +745,12 @@ nft_chain_builtin_find(const struct builtin_table *t, const char *chain)
 static void nft_chain_builtin_init(struct nft_handle *h,
 				   const struct builtin_table *table)
 {
-	struct nftnl_chain_list *list;
-	struct nftnl_chain *c;
+	struct nftnl_chain **bcp = h->cache->table[table->type].base_chains;
 	int i;
 
 	/* Initialize built-in chains if they don't exist yet */
 	for (i=0; i < NF_INET_NUMHOOKS && table->chains[i].name != NULL; i++) {
-		list = nft_chain_list_get(h, table->name,
-					  table->chains[i].name);
-		if (!list)
-			continue;
-
-		c = nftnl_chain_list_lookup_byname(list, table->chains[i].name);
-		if (c != NULL)
+		if (bcp[table->chains[i].hook])
 			continue;
 
 		nft_chain_builtin_add(h, table, &table->chains[i]);
@@ -1857,6 +1850,19 @@ static struct nftnl_chain *
 nft_chain_find(struct nft_handle *h, const char *table, const char *chain)
 {
 	struct nftnl_chain_list *list;
+	const struct builtin_table *t;
+	int i;
+
+	t = nft_table_builtin_find(h, table);
+	if (!t)
+		return NULL;
+
+	for (i = 0; i < NF_INET_NUMHOOKS && t->chains[i].name; i++) {
+		if (strcmp(chain, t->chains[i].name))
+			continue;
+
+		return h->cache->table[t->type].base_chains[t->chains[i].hook];
+	}
 
 	list = nft_chain_list_get(h, table, chain);
 	if (list == NULL)
@@ -2478,11 +2484,23 @@ int nft_chain_foreach(struct nft_handle *h, const char *table,
 		      void *data)
 {
 	const struct builtin_table *t;
+	struct nftnl_chain *c;
+	int i, ret;
 
 	t = nft_table_builtin_find(h, table);
 	if (!t)
 		return -1;
 
+	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
+		c = h->cache->table[t->type].base_chains[i];
+		if (!c) /* FIXME */
+			continue;
+
+		ret = cb(c, data);
+		if (ret < 0)
+			return ret;
+	}
+
 	if (!h->cache->table[t->type].chains)
 		return -1;
 
diff --git a/iptables/nft.h b/iptables/nft.h
index 2fe58e7f06d3f..23eebe31e7aa0 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -40,6 +40,7 @@ enum nft_cache_level {
 struct nft_cache {
 	struct nftnl_table_list		*tables;
 	struct {
+		struct nftnl_chain	*base_chains[NF_INET_NUMHOOKS];
 		struct nftnl_chain_list *chains;
 		struct nftnl_set_list	*sets;
 		bool			initialized;
-- 
2.27.0

