Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAB0BC46467
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Jan 2023 23:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbjANXK5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 14 Jan 2023 18:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbjANXK4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 Jan 2023 18:10:56 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 48AAD5242
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Jan 2023 15:10:56 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, sbrivio@redhat.com
Subject: [PATCH nf 2/2] netfilter: nft_set_rbtree: skip elements in transaction from garbage collection
Date:   Sun, 15 Jan 2023 00:10:47 +0100
Message-Id: <20230114231047.948785-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230114231047.948785-1-pablo@netfilter.org>
References: <20230114231047.948785-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Skip interference with an ongoing transaction, do not perform garbage
collection on inactive elements. Reset annotated previous end interval
if the expired element is marked as busy (control plane removed the
element right before expiration).

Fixes: 8d8540c4f5e0 ("netfilter: nft_set_rbtree: add timeout support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 9b31c0cfb361..545f73a17dfd 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -564,23 +564,37 @@ static void nft_rbtree_gc(struct work_struct *work)
 	struct nft_rbtree *priv;
 	struct rb_node *node;
 	struct nft_set *set;
+	struct net *net;
+	u8 genmask;
 
 	priv = container_of(work, struct nft_rbtree, gc_work.work);
 	set  = nft_set_container_of(priv);
+	net  = read_pnet(&set->net);
+	genmask = nft_genmask_cur(net);
 
 	write_lock_bh(&priv->lock);
 	write_seqcount_begin(&priv->count);
 	for (node = rb_first(&priv->root); node != NULL; node = rb_next(node)) {
 		rbe = rb_entry(node, struct nft_rbtree_elem, node);
 
+		if (!nft_set_elem_active(&rbe->ext, genmask))
+			continue;
+
+		/* elements are reversed in the rbtree for historical reasons,
+		 * from highest to lowest value, that is why end element is
+		 * always visited before the start element.
+		 */
 		if (nft_rbtree_interval_end(rbe)) {
 			rbe_end = rbe;
 			continue;
 		}
 		if (!nft_set_elem_expired(&rbe->ext))
 			continue;
-		if (nft_set_elem_mark_busy(&rbe->ext))
+
+		if (nft_set_elem_mark_busy(&rbe->ext)) {
+			rbe_end = NULL;
 			continue;
+		}
 
 		if (rbe_prev) {
 			rb_erase(&rbe_prev->node, &priv->root);
-- 
2.30.2

