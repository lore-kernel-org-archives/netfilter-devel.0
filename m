From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH 3/4] netlink: only flush asked table/chain
Date: Thu,  3 Oct 2013 01:08:07 +0200
Message-ID: <1380755288-17587-4-git-send-email-eric@regit.org>
References: <1380755288-17587-1-git-send-email-eric@regit.org>
Cc: eric@regit.org, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:50362 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab3JBXIk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Oct 2013 19:08:40 -0400
In-Reply-To: <1380755288-17587-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The flush operation was not limiting the flush to the table or
chain specified on command line. The result was that all the rules
for a given family are flush independantly of the flush command.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/netlink.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/src/netlink.c b/src/netlink.c
index 6f3002b..f75cef7 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -425,8 +425,15 @@ static int netlink_list_rules(struct netlink_ctx *ctx, const struct handle *h,
 static int flush_rule_cb(struct nft_rule *nlr, void *arg)
 {
 	struct netlink_ctx *ctx = arg;
+	const struct handle *h = ctx->data;
 	int err;
 
+	if ((h->table &&
+	    strcmp(nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_TABLE), h->table) != 0) ||
+	    (h->chain &&
+	     strcmp(nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_CHAIN), h->chain) != 0))
+		return 0;
+
 	netlink_dump_rule(nlr);
 	err = mnl_nft_rule_batch_del(nlr, 0, ctx->seqnum);
 	if (err < 0) {
@@ -448,6 +455,7 @@ static int netlink_flush_rules(struct netlink_ctx *ctx, const struct handle *h,
 					"Could not receive rules from kernel: %s",
 					strerror(errno));
 
+	ctx->data = h;
 	mnl_batch_begin();
 	nft_rule_list_foreach(rule_cache, flush_rule_cb, ctx);
 	nft_rule_list_free(rule_cache);
-- 
1.8.4.rc3

