From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [xtables-arptables PATCH 2/4] nft: search builtin tables via
 nft_handle tables pointer
Date: Wed, 17 Jul 2013 00:30:43 +0200
Message-ID: <20130716223043.13253.17600.stgit@nftables>
References: <20130716222925.13253.93123.stgit@nftables>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:33355 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab3GVOb7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:31:59 -0400
Received: by mail-ea0-f179.google.com with SMTP id b15so3929332eae.10
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jul 2013 07:31:58 -0700 (PDT)
Received: from [127.0.1.1] ([37.77.121.31])
        by mx.google.com with ESMTPSA id bj46sm51148843eeb.13.2013.07.22.07.31.56
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 22 Jul 2013 07:31:57 -0700 (PDT)
In-Reply-To: <20130716222925.13253.93123.stgit@nftables>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 02c12f6..9a8986a 100644
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

