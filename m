From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables-nftables PATCH 2/5] nft: search builtin tables via nft_handle tables pointer
Date: Fri, 26 Jul 2013 13:05:16 +0200
Message-ID: <1374836719-27596-2-git-send-email-giuseppelng@gmail.com>
References: <1374836719-27596-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:57339 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790Ab3GZLF6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jul 2013 07:05:58 -0400
Received: by mail-wi0-f170.google.com with SMTP id ey16so735845wid.3
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2013 04:05:57 -0700 (PDT)
In-Reply-To: <1374836719-27596-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This finds built-in tables via tables pointer in nft_handle

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 5665148..0b45c93 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -288,20 +288,21 @@ nft_chain_builtin_add(struct nft_handle *h, struct builtin_table *table,
 }
 
 /* find if built-in table already exists */
-static struct builtin_table *nft_table_builtin_find(const char *table)
+static struct builtin_table
+*nft_table_builtin_find(struct nft_handle *h, const char *table)
 {
 	int i;
 	bool found = false;
 
 	for (i=0; i<TABLES_MAX; i++) {
-		if (strcmp(tables[i].name, table) != 0)
+		if (strcmp(h->tables[i].name, table) != 0)
 			continue;
 
 		found = true;
 		break;
 	}
 
-	return found ? &tables[i] : NULL;
+	return found ? &h->tables[i] : NULL;
 }
 
 /* find if built-in chain already exists */
@@ -349,7 +350,7 @@ nft_chain_builtin_init(struct nft_handle *h, const char *table,
 	int ret = 0;
 	struct builtin_table *t;
 
-	t = nft_table_builtin_find(table);
+	t = nft_table_builtin_find(h, table);
 	if (t == NULL) {
 		ret = -1;
 		goto out;
@@ -424,7 +425,7 @@ int nft_table_set_dormant(struct nft_handle *h, const char *table)
 	int ret = 0, i;
 	struct builtin_table *t;
 
-	t = nft_table_builtin_find(table);
+	t = nft_table_builtin_find(h, table);
 	if (t == NULL) {
 		ret = -1;
 		goto out;
@@ -485,7 +486,7 @@ __nft_chain_set(struct nft_handle *h, const char *table,
 	struct builtin_chain *_c;
 	int ret;
 
-	_t = nft_table_builtin_find(table);
+	_t = nft_table_builtin_find(h, table);
 	/* if this built-in table does not exists, create it */
 	if (_t != NULL)
 		nft_table_builtin_add(h, _t, false);
-- 
1.7.8.6

