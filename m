Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B41FEB64DA
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jul 2023 19:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjGTTaR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jul 2023 15:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjGTTaQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jul 2023 15:30:16 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29521737
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jul 2023 12:30:15 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qMZLq-0002Dk-Fn; Thu, 20 Jul 2023 21:30:14 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nft_set_rbtree: fix overlap expiration walk
Date:   Thu, 20 Jul 2023 21:30:05 +0200
Message-ID: <20230720193009.18289-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The lazy gc on insert that should remove timed-out entries
fails to release the other half of the interval, if any.

Can be reproduced with tests/shell/testcases/sets/0044interval_overlap_0
in nftables.git and kmemleak enabled kernel.

Second bug is the use of rbe_prev vs. prev pointer.
If rbe_prev() returns NULL after at least one iteration,
rbe_prev points to an rbtree element that is not an end
interval, hence it should not be removed.

Lastly, check the genmask of the end interval if
this is active in the current generation.

Fixes: c9e6978e2725 ("netfilter: nft_set_rbtree: Switch to node list walk for overlap detection")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_rbtree.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 5c05c9b990fb..8d73fffd2d09 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -217,29 +217,37 @@ static void *nft_rbtree_get(const struct net *net, const struct nft_set *set,
 
 static int nft_rbtree_gc_elem(const struct nft_set *__set,
 			      struct nft_rbtree *priv,
-			      struct nft_rbtree_elem *rbe)
+			      struct nft_rbtree_elem *rbe,
+			      u8 genmask)
 {
 	struct nft_set *set = (struct nft_set *)__set;
 	struct rb_node *prev = rb_prev(&rbe->node);
-	struct nft_rbtree_elem *rbe_prev = NULL;
+	struct nft_rbtree_elem *rbe_prev;
 	struct nft_set_gc_batch *gcb;
 
 	gcb = nft_set_gc_batch_check(set, NULL, GFP_ATOMIC);
 	if (!gcb)
 		return -ENOMEM;
 
-	/* search for expired end interval coming before this element. */
+	/* search for end interval coming before this element.
+	 * end intervals don't carry a timeout extension, they
+	 * are coupled with the interval start element.
+	 */
 	while (prev) {
 		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
-		if (nft_rbtree_interval_end(rbe_prev))
+		if (nft_rbtree_interval_end(rbe_prev) &&
+		    nft_set_elem_active(&rbe_prev->ext, genmask))
 			break;
 
 		prev = rb_prev(prev);
 	}
 
-	if (rbe_prev) {
+	if (prev) {
+		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
+
 		rb_erase(&rbe_prev->node, &priv->root);
 		atomic_dec(&set->nelems);
+		nft_set_gc_batch_add(gcb, rbe_prev);
 	}
 
 	rb_erase(&rbe->node, &priv->root);
@@ -321,7 +329,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 
 		/* perform garbage collection to avoid bogus overlap reports. */
 		if (nft_set_elem_expired(&rbe->ext)) {
-			err = nft_rbtree_gc_elem(set, priv, rbe);
+			err = nft_rbtree_gc_elem(set, priv, rbe, genmask);
 			if (err < 0)
 				return err;
 
-- 
2.41.0

