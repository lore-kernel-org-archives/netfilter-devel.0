From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft next-3.14 PATCH] netlink: delete unused function calls
Date: Mon, 17 Feb 2014 11:10:57 +0100
Message-ID: <20140217101057.5762.64983.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36116 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752341AbaBQKLD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 05:11:03 -0500
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id B6BAD51EF29
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Feb 2014 10:10:59 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GNXs75YqbkdF for <netfilter-devel@vger.kernel.org>;
	Mon, 17 Feb 2014 11:10:59 +0100 (CET)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 7F2E751EF28
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Feb 2014 11:10:59 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These functions calls, and the related `struct nft_table *nlt' are unused.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/netlink.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 6e797dc..ea02972 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -703,7 +703,6 @@ int netlink_list_tables(struct netlink_ctx *ctx, const struct handle *h,
 			const struct location *loc)
 {
 	struct nft_table_list *table_cache;
-	struct nft_table *nlt;
 
 	table_cache = mnl_nft_table_dump(nf_sock, h->family);
 	if (table_cache == NULL)
@@ -711,9 +710,7 @@ int netlink_list_tables(struct netlink_ctx *ctx, const struct handle *h,
 					"Could not receive tables from kernel: %s",
 					strerror(errno));
 
-	nlt = alloc_nft_table(h);
 	nft_table_list_foreach(table_cache, list_table_cb, ctx);
-	nft_table_free(nlt);
 	nft_table_list_free(table_cache);
 	return 0;
 }

