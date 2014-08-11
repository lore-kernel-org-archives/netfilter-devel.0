From: Yanchuan Nian <ycnian@gmail.com>
Subject: [nft PATCH] Remove unused function netlink_get_table
Date: Mon, 11 Aug 2014 10:37:14 +0800
Message-ID: <1407724634-21515-1-git-send-email-ycnian@gmail.com>
Cc: netfilter-devel@vger.kernel.org, Yanchuan Nian <ycnian@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:62006 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaHKCeP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 10 Aug 2014 22:34:15 -0400
Received: by mail-pd0-f177.google.com with SMTP id p10so9804884pdj.8
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Aug 2014 19:34:14 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netlink_get_table is defined but not used anywhere. Just remove it.

Signed-off-by: Yanchuan Nian <ycnian@gmail.com>
---
 include/netlink.h |  2 --
 src/netlink.c     | 18 ------------------
 2 files changed, 20 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index af5dcd9..29cd45c 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -107,8 +107,6 @@ extern int netlink_delete_table(struct netlink_ctx *ctx, const struct handle *h,
 				const struct location *loc);
 extern int netlink_list_tables(struct netlink_ctx *ctx, const struct handle *h,
 			       const struct location *loc);
-extern int netlink_get_table(struct netlink_ctx *ctx, const struct handle *h,
-			     const struct location *loc);
 extern int netlink_list_table(struct netlink_ctx *ctx, const struct handle *h,
 			      const struct location *loc);
 extern int netlink_flush_table(struct netlink_ctx *ctx, const struct handle *h,
diff --git a/src/netlink.c b/src/netlink.c
index dc7a7c4..5ada2fd 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -936,24 +936,6 @@ int netlink_list_tables(struct netlink_ctx *ctx, const struct handle *h,
 	return 0;
 }
 
-int netlink_get_table(struct netlink_ctx *ctx, const struct handle *h,
-		      const struct location *loc)
-{
-	struct nft_table *nlt;
-	int err;
-
-	nlt = alloc_nft_table(h);
-	err = mnl_nft_table_get(nf_sock, nlt, 0);
-	nft_table_free(nlt);
-
-	if (err < 0)
-		return netlink_io_error(ctx, loc,
-					"Could not receive table from kernel: %s",
-					strerror(errno));
-	return err;
-}
-
-
 int netlink_list_table(struct netlink_ctx *ctx, const struct handle *h,
 		       const struct location *loc)
 {
-- 
1.9.3

