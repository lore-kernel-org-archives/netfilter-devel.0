From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: nft_rbtree: fix chain use underflow with intervals and map
Date: Thu,  6 Feb 2014 17:00:34 +0100
Message-ID: <1391702434-4103-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49214 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbaBFQC6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:02:58 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If you add a rule using intervals+map that introduces a loop, the
error path of the rbtree set decrements the chain refcount for each
side of the interval, leading to a chain use counter underflow.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_rbtree.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_rbtree.c b/net/netfilter/nft_rbtree.c
index ca0c1b2..b18e88b 100644
--- a/net/netfilter/nft_rbtree.c
+++ b/net/netfilter/nft_rbtree.c
@@ -69,8 +69,10 @@ static void nft_rbtree_elem_destroy(const struct nft_set *set,
 				    struct nft_rbtree_elem *rbe)
 {
 	nft_data_uninit(&rbe->key, NFT_DATA_VALUE);
-	if (set->flags & NFT_SET_MAP)
+	if (set->flags & NFT_SET_MAP &&
+	    !(rbe->flags & NFT_SET_ELEM_INTERVAL_END))
 		nft_data_uninit(rbe->data, set->dtype);
+
 	kfree(rbe);
 }
 
-- 
1.7.10.4

