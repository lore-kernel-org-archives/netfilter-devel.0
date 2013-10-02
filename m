From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH 4/4] netlink: fix nft flush operation
Date: Thu,  3 Oct 2013 01:08:08 +0200
Message-ID: <1380755288-17587-5-git-send-email-eric@regit.org>
References: <1380755288-17587-1-git-send-email-eric@regit.org>
Cc: eric@regit.org, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:50366 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab3JBXIm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Oct 2013 19:08:42 -0400
In-Reply-To: <1380755288-17587-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft_netlink function is already calling mnl_batch_end and
mnl_batch_begin so it is not necessary to do it in the
netlink_flush_rules function. Doing this result in a invalid
netlink message which is discarded by the kernel.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/netlink.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index f75cef7..a62c357 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -456,10 +456,8 @@ static int netlink_flush_rules(struct netlink_ctx *ctx, const struct handle *h,
 					strerror(errno));
 
 	ctx->data = h;
-	mnl_batch_begin();
 	nft_rule_list_foreach(rule_cache, flush_rule_cb, ctx);
 	nft_rule_list_free(rule_cache);
-	mnl_batch_end();
 	return 0;
 }
 
-- 
1.8.4.rc3

