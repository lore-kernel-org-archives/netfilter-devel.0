Return-Path: <SRS0=6IYx=TT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB8CEC072AD
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 May 2019 17:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD67820449
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 May 2019 17:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbfESRsd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 May 2019 13:48:33 -0400
Received: from mail.us.es ([193.147.175.20]:42152 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727539AbfESRsd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 May 2019 13:48:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5A8B5C4145
        for <netfilter-devel@vger.kernel.org>; Sun, 19 May 2019 13:51:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 48D10DA701
        for <netfilter-devel@vger.kernel.org>; Sun, 19 May 2019 13:51:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3EACADA708; Sun, 19 May 2019 13:51:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4060ADA701;
        Sun, 19 May 2019 13:51:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 19 May 2019 13:51:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 12E704265A32;
        Sun, 19 May 2019 13:51:26 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, fw@strlen.de
Subject: [PATCH iptables 3/4] nft: add flush_cache()
Date:   Sun, 19 May 2019 13:51:20 +0200
Message-Id: <20190519115121.32490-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190519115121.32490-1-pablo@netfilter.org>
References: <20190519115121.32490-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This new function takes a struct nft_cache as parameter.

This patch also introduces __nft_table_builtin_find() which is required
to look up for built-in tables without the nft_handle structure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft.c | 41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index c5ddde5f0064..14141bb7dbcf 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -688,25 +688,31 @@ static void nft_chain_builtin_add(struct nft_handle *h,
 	nftnl_chain_list_add_tail(c, h->cache->table[table->type].chains);
 }
 
-/* find if built-in table already exists */
-const struct builtin_table *
-nft_table_builtin_find(struct nft_handle *h, const char *table)
+static const struct builtin_table *
+__nft_table_builtin_find(const struct builtin_table *tables, const char *table)
 {
 	int i;
 	bool found = false;
 
 	for (i = 0; i < NFT_TABLE_MAX; i++) {
-		if (h->tables[i].name == NULL)
+		if (tables[i].name == NULL)
 			continue;
 
-		if (strcmp(h->tables[i].name, table) != 0)
+		if (strcmp(tables[i].name, table) != 0)
 			continue;
 
 		found = true;
 		break;
 	}
 
-	return found ? &h->tables[i] : NULL;
+	return found ? &tables[i] : NULL;
+}
+
+/* find if built-in table already exists */
+const struct builtin_table *
+nft_table_builtin_find(struct nft_handle *h, const char *table)
+{
+	return __nft_table_builtin_find(h->tables, table);
 }
 
 /* find if built-in chain already exists */
@@ -836,30 +842,37 @@ static int __flush_chain_cache(struct nftnl_chain *c, void *data)
 	return 0;
 }
 
-static void flush_chain_cache(struct nft_handle *h, const char *tablename)
+static void flush_cache(struct nft_cache *c,
+			const struct builtin_table *tables,
+			const char *tablename)
 {
 	const struct builtin_table *table;
 	int i;
 
 	if (tablename) {
-		table = nft_table_builtin_find(h, tablename);
-		if (!table || !h->cache->table[table->type].chains)
+		table = __nft_table_builtin_find(tables, tablename);
+		if (!table || !c->table[table->type].chains)
 			return;
-		nftnl_chain_list_foreach(h->cache->table[table->type].chains,
+		nftnl_chain_list_foreach(c->table[table->type].chains,
 					 __flush_chain_cache, NULL);
 		return;
 	}
 
 	for (i = 0; i < NFT_TABLE_MAX; i++) {
-		if (h->tables[i].name == NULL)
+		if (tables[i].name == NULL)
 			continue;
 
-		if (!h->cache->table[i].chains)
+		if (!c->table[i].chains)
 			continue;
 
-		nftnl_chain_list_free(h->cache->table[i].chains);
-		h->cache->table[i].chains = NULL;
+		nftnl_chain_list_free(c->table[i].chains);
+		c->table[i].chains = NULL;
 	}
+}
+
+static void flush_chain_cache(struct nft_handle *h, const char *tablename)
+{
+	flush_cache(h->cache, h->tables, tablename);
 	h->have_cache = false;
 }
 
-- 
2.11.0

