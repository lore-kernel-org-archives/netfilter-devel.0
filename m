From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH 2/4] netlink: suppress useless variable
Date: Thu,  3 Oct 2013 01:08:06 +0200
Message-ID: <1380755288-17587-3-git-send-email-eric@regit.org>
References: <1380755288-17587-1-git-send-email-eric@regit.org>
Cc: eric@regit.org, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:50359 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab3JBXIj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Oct 2013 19:08:39 -0400
In-Reply-To: <1380755288-17587-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/netlink.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index b1e44ad..6f3002b 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -441,7 +441,6 @@ static int netlink_flush_rules(struct netlink_ctx *ctx, const struct handle *h,
 			       const struct location *loc)
 {
 	struct nft_rule_list *rule_cache;
-	struct nft_rule *nlr;
 
 	rule_cache = mnl_nft_rule_dump(nf_sock, h->family);
 	if (rule_cache == NULL)
@@ -450,9 +449,7 @@ static int netlink_flush_rules(struct netlink_ctx *ctx, const struct handle *h,
 					strerror(errno));
 
 	mnl_batch_begin();
-	nlr = alloc_nft_rule(h);
 	nft_rule_list_foreach(rule_cache, flush_rule_cb, ctx);
-	nft_rule_free(nlr);
 	nft_rule_list_free(rule_cache);
 	mnl_batch_end();
 	return 0;
-- 
1.8.4.rc3

