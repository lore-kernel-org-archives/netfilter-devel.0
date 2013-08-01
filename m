From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] table: add nft_table_list_del function
Date: Thu, 01 Aug 2013 14:45:46 +0200
Message-ID: <20130801124546.13382.18859.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:43000 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754785Ab3HAMp5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Aug 2013 08:45:57 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 6848A51ED36
	for <netfilter-devel@vger.kernel.org>; Thu,  1 Aug 2013 12:45:55 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nXuT1hKatU64 for <netfilter-devel@vger.kernel.org>;
	Thu,  1 Aug 2013 14:45:50 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 4AC7A51ED32
	for <netfilter-devel@vger.kernel.org>; Thu,  1 Aug 2013 14:45:48 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the function nft_table_list_del(), that allows to delete
elements from a struct nft_table_list.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 0 files changed

diff --git a/include/libnftables/table.h b/include/libnftables/table.h
index 24ca374..a2882c2 100644
--- a/include/libnftables/table.h
+++ b/include/libnftables/table.h
@@ -59,6 +59,7 @@ int nft_table_list_foreach(struct nft_table_list *table_list, int (*cb)(struct n
 
 void nft_table_list_add(struct nft_table *r, struct nft_table_list *list);
 void nft_table_list_add_tail(struct nft_table *r, struct nft_table_list *list);
+void nft_table_list_del(struct nft_table *t);
 
 struct nft_table_list_iter;
 
diff --git a/src/libnftables.map b/src/libnftables.map
index 614c705..012184e 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -21,6 +21,7 @@ global:
   nft_table_list_foreach;
   nft_table_list_add;
   nft_table_list_add_tail;
+  nft_table_list_del;
   nft_table_list_iter_create;
   nft_table_list_iter_next;
   nft_table_list_iter_destroy;
diff --git a/src/table.c b/src/table.c
index 1d17d3b..30ca0c0 100644
--- a/src/table.c
+++ b/src/table.c
@@ -486,6 +486,12 @@ void nft_table_list_add_tail(struct nft_table *r, struct nft_table_list *list)
 }
 EXPORT_SYMBOL(nft_table_list_add_tail);
 
+void nft_table_list_del(struct nft_table *t)
+{
+	list_del(&t->head);
+}
+EXPORT_SYMBOL(nft_table_list_del);
+
 int nft_table_list_foreach(struct nft_table_list *table_list,
 			   int (*cb)(struct nft_table *t, void *data),
 			   void *data)

