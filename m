From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: fix rule flushing atomically
Date: Fri,  6 Dec 2013 13:01:09 +0100
Message-ID: <1386331269-4179-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44433 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757704Ab3LFMBR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:01:17 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft is currently retrieving the list of rule from the kernel, then
deleting each rule one by one. This is slow and not safe. Fix it
by sending a deletion command in a batch without specifying the
chain.

This change requires the kernel fix entitled:
netfilter: nf_tables: fix missing rules flushing per table

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c |   35 +----------------------------------
 1 file changed, 1 insertion(+), 34 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 533634a..cab8cf4 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -422,43 +422,10 @@ static int netlink_list_rules(struct netlink_ctx *ctx, const struct handle *h,
 	return 0;
 }
 
-static int flush_rule_cb(struct nft_rule *nlr, void *arg)
-{
-	struct netlink_ctx *ctx = arg;
-	const struct handle *h = ctx->data;
-	int err;
-
-	if ((h->table &&
-	    strcmp(nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_TABLE), h->table) != 0) ||
-	    (h->chain &&
-	     strcmp(nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_CHAIN), h->chain) != 0))
-		return 0;
-
-	netlink_dump_rule(nlr);
-	err = mnl_nft_rule_batch_del(nlr, 0, ctx->seqnum);
-	if (err < 0) {
-		netlink_io_error(ctx, NULL, "Could not delete rule: %s",
-				 strerror(errno));
-		return err;
-	}
-	return 0;
-}
-
 static int netlink_flush_rules(struct netlink_ctx *ctx, const struct handle *h,
 			       const struct location *loc)
 {
-	struct nft_rule_list *rule_cache;
-
-	rule_cache = mnl_nft_rule_dump(nf_sock, h->family);
-	if (rule_cache == NULL)
-		return netlink_io_error(ctx, loc,
-					"Could not receive rules from kernel: %s",
-					strerror(errno));
-
-	ctx->data = h;
-	nft_rule_list_foreach(rule_cache, flush_rule_cb, ctx);
-	nft_rule_list_free(rule_cache);
-	return 0;
+	return netlink_del_rule_batch(ctx, h, loc);
 }
 
 void netlink_dump_chain(struct nft_chain *nlc)
-- 
1.7.10.4

