From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [xtables-arptables PATCH v2 2/5] nft: search builtin tables via
 nft_handle tables pointer
Date: Tue, 23 Jul 2013 18:12:29 +0200
Message-ID: <20130723161226.10040.34058.stgit@localhost>
References: <20130723161017.10040.6256.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:32967 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933511Ab3GWQMt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:12:49 -0400
Received: by mail-wg0-f50.google.com with SMTP id m15so1887753wgh.29
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jul 2013 09:12:47 -0700 (PDT)
Received: from [127.0.0.1] (adsl-ull-226-41.46-151.net24.it. [151.46.41.226])
        by mx.google.com with ESMTPSA id r8sm6982483wiz.5.2013.07.23.09.12.45
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Tue, 23 Jul 2013 09:12:47 -0700 (PDT)
In-Reply-To: <20130723161017.10040.6256.stgit@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index f6dccff..07ca0f1 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -288,20 +288,21 @@ nft_chain_builtin_add(struct nft_handle *h, struct builtin_table *table,
 }
 
 /* find if built-in table already exists */
-static struct builtin_table *nft_table_builtin_find(const char *table)
+static struct builtin_table *
+nft_table_builtin_find(struct nft_handle *h, const char *table)
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

