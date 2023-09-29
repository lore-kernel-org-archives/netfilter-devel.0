Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A031E728C5
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Sep 2023 16:44:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbjI2QoO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Sep 2023 12:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbjI2QoN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2023 12:44:13 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C376BD6
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Sep 2023 09:44:10 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nf 1/2] netfilter: nft_set_rbtree: move sync GC from insert path to set->ops->commit
Date:   Fri, 29 Sep 2023 18:44:03 +0200
Message-Id: <20230929164404.172081-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

According to 2ee52ae94baa ("netfilter: nft_set_rbtree: skip sync GC for
new elements in this transaction"), new elements in this transaction
might expire before such transaction ends. Skip sync GC is needed for
such elements otherwise commit path might walk over an already released
object.

However, Florian found that while iterating the tree from the insert
path for sync GC, it is possible that stale references could still
happen for elements in the less-equal and great-than boundaries to
narrow down the tree descend to speed up overlap detection, this
triggers bogus overlap errors.

This patch skips expired elements in the overlap detection routine which
iterates on the reversed ordered list of elements that represent the
intervals. Since end elements provide no expiration extension, check for
the next non-end element in this interval, hence, skip both elements in
the iteration if the interval has expired.

Moreover, move GC sync to the set->ops->commit interface to collect
expired interval. The GC run needs to ignore the gc_interval because the
tree cannot store duplicated expired elements, otherwise bogus
mismatches might occur.

Fixes: f6c383b8c31a ("netfilter: nf_tables: adapt set backend to use GC transaction API")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Hi Florian,

I picked up on issue, this proposed as an alternative to:
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230928131247.3391-1-fw@strlen.de/

Note this ignores the specified gc_interval. For this to work, a copy of the
tree would need to be maintained, similar to what pipapo does.

This approach should clear the path to support for set element timeout
update/refresh.

I still spinning over this one and running test to see if I see any failure
with sets/0044_interval_overlap_{0,1}.

 net/netfilter/nft_set_rbtree.c | 57 +++++++++++++++++++++++++---------
 1 file changed, 43 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 487572dcd614..de6d812fc790 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -235,8 +235,7 @@ static void nft_rbtree_gc_remove(struct net *net, struct nft_set *set,
 
 static int nft_rbtree_gc_elem(const struct nft_set *__set,
 			      struct nft_rbtree *priv,
-			      struct nft_rbtree_elem *rbe,
-			      u8 genmask)
+			      struct nft_rbtree_elem *rbe)
 {
 	struct nft_set *set = (struct nft_set *)__set;
 	struct rb_node *prev = rb_prev(&rbe->node);
@@ -254,8 +253,7 @@ static int nft_rbtree_gc_elem(const struct nft_set *__set,
 	 */
 	while (prev) {
 		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
-		if (nft_rbtree_interval_end(rbe_prev) &&
-		    nft_set_elem_active(&rbe_prev->ext, genmask))
+		if (nft_rbtree_interval_end(rbe_prev))
 			break;
 
 		prev = rb_prev(prev);
@@ -289,6 +287,34 @@ static int nft_rbtree_gc_elem(const struct nft_set *__set,
 	return 0;
 }
 
+static void nft_rbtree_commit(const struct nft_set *set)
+{
+	struct nft_rbtree *priv = nft_set_priv(set);
+	struct rb_node *node, *next, *first;
+	struct nft_rbtree_elem *rbe;
+
+	if (!(set->flags & NFT_SET_TIMEOUT))
+		return;
+
+	/* ignore GC interval here, unless two copies of the tree are
+	 * maintained, it is not possible to postpone removal of expired
+	 * elements.
+	 */
+
+	first = rb_first(&priv->root);
+
+	for (node = first; node != NULL; node = next) {
+		next = rb_next(node);
+
+		rbe = rb_entry(node, struct nft_rbtree_elem, node);
+
+		if (!nft_set_elem_expired(&rbe->ext))
+			continue;
+
+		nft_rbtree_gc_elem(set, priv, rbe);
+	}
+}
+
 static bool nft_rbtree_update_first(const struct nft_set *set,
 				    struct nft_rbtree_elem *rbe,
 				    struct rb_node *first)
@@ -312,9 +338,8 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	struct nft_rbtree_elem *rbe, *rbe_le = NULL, *rbe_ge = NULL;
 	struct rb_node *node, *next, *parent, **p, *first = NULL;
 	struct nft_rbtree *priv = nft_set_priv(set);
-	u8 cur_genmask = nft_genmask_cur(net);
 	u8 genmask = nft_genmask_next(net);
-	int d, err;
+	int d;
 
 	/* Descend the tree to search for an existing element greater than the
 	 * key value to insert that is greater than the new element. This is the
@@ -358,16 +383,19 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		if (!nft_set_elem_active(&rbe->ext, genmask))
 			continue;
 
-		/* perform garbage collection to avoid bogus overlap reports
-		 * but skip new elements in this transaction.
+		/* skip expired intervals to avoid bogus overlap reports:
+		 * end element has no expiration, check next start element.
 		 */
-		if (nft_set_elem_expired(&rbe->ext) &&
-		    nft_set_elem_active(&rbe->ext, cur_genmask)) {
-			err = nft_rbtree_gc_elem(set, priv, rbe, genmask);
-			if (err < 0)
-				return err;
+		if (nft_rbtree_interval_end(rbe) && next) {
+			struct nft_rbtree_elem *rbe_next;
 
-			continue;
+			rbe_next = rb_entry(next, struct nft_rbtree_elem, node);
+
+			if (nft_set_elem_expired(&rbe_next->ext)) {
+				/* skip expired next start element. */
+				next = rb_next(next);
+				continue;
+			}
 		}
 
 		d = nft_rbtree_cmp(set, rbe, new);
@@ -755,5 +783,6 @@ const struct nft_set_type nft_set_rbtree_type = {
 		.lookup		= nft_rbtree_lookup,
 		.walk		= nft_rbtree_walk,
 		.get		= nft_rbtree_get,
+		.commit		= nft_rbtree_commit,
 	},
 };
-- 
2.30.2

