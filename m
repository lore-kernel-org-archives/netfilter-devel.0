From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nftables 2/2] netlink: improve rule deletion per chain
Date: Mon, 25 Nov 2013 00:08:16 +0100
Message-ID: <1385334496-3544-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42658 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744Ab3KXXIZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Nov 2013 18:08:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With this patch, nft asks the kernel for deleting all rules in a chain.
This replaces the current behaviour that requires to dump all the rules,
then iterate over that list to delete one by one, which is prone to races
and slowier.

After this patch, the following two commands are equivalent:

 nft flush chain filter input
 nft delete rule filter input

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink.c b/src/netlink.c
index 15cba79..533634a 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -645,7 +645,7 @@ int netlink_list_chain(struct netlink_ctx *ctx, const struct handle *h,
 int netlink_flush_chain(struct netlink_ctx *ctx, const struct handle *h,
 			const struct location *loc)
 {
-	return netlink_flush_rules(ctx, h, loc);
+	return netlink_del_rule_batch(ctx, h, loc);
 }
 
 int netlink_add_table(struct netlink_ctx *ctx, const struct handle *h,
-- 
1.7.10.4

