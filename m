From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/3] netlink: fix use after free in netlink_get_table()
Date: Wed, 25 Mar 2015 21:00:25 +0000
Message-ID: <1427317227-11313-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51964 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbbCYVAa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 17:00:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/netlink.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 24dda67..f957295 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -953,19 +953,19 @@ int netlink_get_table(struct netlink_ctx *ctx, const struct handle *h,
 
 	nlt = alloc_nft_table(h);
 	err = mnl_nft_table_get(nf_sock, nlt, 0);
-	nft_table_free(nlt);
-
 	if (err < 0) {
 		netlink_io_error(ctx, loc,
 				 "Could not receive table from kernel: %s",
 				 strerror(errno));
-		return err;
+		goto out;
 	}
 
 	ntable = netlink_delinearize_table(ctx, nlt);
 	table->flags = ntable->flags;
 	xfree(ntable);
-	return 0;
+out:
+	nft_table_free(nlt);
+	return err;
 }
 
 int netlink_list_table(struct netlink_ctx *ctx, const struct handle *h,
-- 
2.1.0

