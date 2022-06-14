Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 705D3C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jun 2022 01:07:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiFNBHM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Jun 2022 21:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233812AbiFNBHL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Jun 2022 21:07:11 -0400
Received: from maja (passt.top [88.198.0.164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2588430559
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jun 2022 18:07:09 -0700 (PDT)
Received: by maja (Postfix, from userid 1000)
        id 6D68F5A0267; Tue, 14 Jun 2022 03:07:04 +0200 (CEST)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] nft_set_rbtree: Switch to node list walk for overlap detection
Date:   Tue, 14 Jun 2022 03:07:04 +0200
Message-Id: <20220614010704.1416375-1-sbrivio@redhat.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

...instead of a tree descent, which became overly complicated in an
attempt to cover cases where expired or inactive elements would
affect comparisons with the new element being inserted.

Further, it turned out that it's probably impossible to cover all
those cases, as inactive nodes might entirely hide subtrees
consisting of a complete interval plus a node that makes the current
insertion not overlap.

For the insertion operation itself, this essentially reverts back to
the implementation before commit 7c84d41416d8
("netfilter: nft_set_rbtree: Detect partial overlaps on insertion"),
except that cases of complete overlap are already handled in the
overlap detection phase itself, which slightly simplifies the loop to
find the insertion point.

Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/netfilter/nft_set_rbtree.c | 194 ++++++++++-----------------------
 1 file changed, 58 insertions(+), 136 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 7325bee7d144..87a28d2dca77 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -38,10 +38,12 @@ static bool nft_rbtree_interval_start(const struct nft_rbtree_elem *rbe)
 	return !nft_rbtree_interval_end(rbe);
 }
 
-static bool nft_rbtree_equal(const struct nft_set *set, const void *this,
-			     const struct nft_rbtree_elem *interval)
+static int nft_rbtree_cmp(const struct nft_set *set,
+			  const struct nft_rbtree_elem *e1,
+			  const struct nft_rbtree_elem *e2)
 {
-	return memcmp(this, nft_set_ext_key(&interval->ext), set->klen) == 0;
+	return memcmp(nft_set_ext_key(&e1->ext), nft_set_ext_key(&e2->ext),
+		      set->klen);
 }
 
 static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set,
@@ -52,7 +54,6 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 	const struct nft_rbtree_elem *rbe, *interval = NULL;
 	u8 genmask = nft_genmask_cur(net);
 	const struct rb_node *parent;
-	const void *this;
 	int d;
 
 	parent = rcu_dereference_raw(priv->root.rb_node);
@@ -62,12 +63,11 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 
 		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
 
-		this = nft_set_ext_key(&rbe->ext);
-		d = memcmp(this, key, set->klen);
+		d = memcmp(nft_set_ext_key(&rbe->ext), key, set->klen);
 		if (d < 0) {
 			parent = rcu_dereference_raw(parent->rb_left);
 			if (interval &&
-			    nft_rbtree_equal(set, this, interval) &&
+			    !nft_rbtree_cmp(set, rbe, interval) &&
 			    nft_rbtree_interval_end(rbe) &&
 			    nft_rbtree_interval_start(interval))
 				continue;
@@ -219,150 +219,72 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			       struct nft_rbtree_elem *new,
 			       struct nft_set_ext **ext)
 {
-	bool overlap = false, dup_end_left = false, dup_end_right = false;
+	struct nft_rbtree_elem *rbe, *rbe_le = NULL, *rbe_ge = NULL;
 	struct nft_rbtree *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_next(net);
-	struct nft_rbtree_elem *rbe;
-	struct rb_node *parent, **p;
+	struct rb_node *node, *parent, **p;
 	int d;
 
-	/* Detect overlaps as we descend the tree. Set the flag in these cases:
-	 *
-	 * a1. _ _ __>|  ?_ _ __|  (insert end before existing end)
-	 * a2. _ _ ___|  ?_ _ _>|  (insert end after existing end)
-	 * a3. _ _ ___? >|_ _ __|  (insert start before existing end)
-	 *
-	 * and clear it later on, as we eventually reach the points indicated by
-	 * '?' above, in the cases described below. We'll always meet these
-	 * later, locally, due to tree ordering, and overlaps for the intervals
-	 * that are the closest together are always evaluated last.
-	 *
-	 * b1. _ _ __>|  !_ _ __|  (insert end before existing start)
-	 * b2. _ _ ___|  !_ _ _>|  (insert end after existing start)
-	 * b3. _ _ ___! >|_ _ __|  (insert start after existing end, as a leaf)
-	 *            '--' no nodes falling in this range
-	 * b4.          >|_ _   !  (insert start before existing start)
-	 *
-	 * Case a3. resolves to b3.:
-	 * - if the inserted start element is the leftmost, because the '0'
-	 *   element in the tree serves as end element
-	 * - otherwise, if an existing end is found immediately to the left. If
-	 *   there are existing nodes in between, we need to further descend the
-	 *   tree before we can conclude the new start isn't causing an overlap
-	 *
-	 * or to b4., which, preceded by a3., means we already traversed one or
-	 * more existing intervals entirely, from the right.
-	 *
-	 * For a new, rightmost pair of elements, we'll hit cases b3. and b2.,
-	 * in that order.
-	 *
-	 * The flag is also cleared in two special cases:
-	 *
-	 * b5. |__ _ _!|<_ _ _   (insert start right before existing end)
-	 * b6. |__ _ >|!__ _ _   (insert end right after existing start)
-	 *
-	 * which always happen as last step and imply that no further
-	 * overlapping is possible.
-	 *
-	 * Another special case comes from the fact that start elements matching
-	 * an already existing start element are allowed: insertion is not
-	 * performed but we return -EEXIST in that case, and the error will be
-	 * cleared by the caller if NLM_F_EXCL is not present in the request.
-	 * This way, request for insertion of an exact overlap isn't reported as
-	 * error to userspace if not desired.
-	 *
-	 * However, if the existing start matches a pre-existing start, but the
-	 * end element doesn't match the corresponding pre-existing end element,
-	 * we need to report a partial overlap. This is a local condition that
-	 * can be noticed without need for a tracking flag, by checking for a
-	 * local duplicated end for a corresponding start, from left and right,
-	 * separately.
+	/* Detect overlaps by going through the list of valid tree nodes: */
+	for (node = rb_first(&priv->root); node != NULL; node = rb_next(node)) {
+		rbe = rb_entry(node, struct nft_rbtree_elem, node);
+
+		if (!nft_set_elem_active(&rbe->ext, genmask) ||
+		    nft_set_elem_expired(&rbe->ext))
+			continue;
+
+		d = nft_rbtree_cmp(set, rbe, new);
+
+		if (d <= 0 && (!rbe_le || nft_rbtree_cmp(set, rbe, rbe_le) > 0))
+			rbe_le = rbe;
+
+		if (d >= 0 && (!rbe_ge || nft_rbtree_cmp(set, rbe, rbe_ge) < 0))
+			rbe_ge = rbe;
+	}
+
+	/* - new start element matching existing start element, or end element
+	 *   matching end element: full overlap reported as -EEXIST, cleared by
+	 *   caller if NLM_F_EXCL is not given
+	 */
+	rbe = rbe_le;
+	if (rbe && !nft_rbtree_cmp(set, new, rbe) &&
+	    nft_rbtree_interval_start(rbe) == nft_rbtree_interval_start(new)) {
+		*ext = &rbe->ext;
+		return -EEXIST;
+	}
+
+	/* - new start element with existing closest, less or equal key value
+	 *   being a start element: partial overlap, reported as -ENOTEMPTY
 	 */
+	if (rbe_le &&
+	    nft_rbtree_interval_start(rbe_le) && nft_rbtree_interval_start(new))
+		return -ENOTEMPTY;
+
+	/* - new end element with existing closest, greater or equal key value
+	 *   being an end element: partial overlap, reported as -ENOTEMPTY
+	 */
+	if (rbe_ge &&
+	    nft_rbtree_interval_end(rbe_ge) && nft_rbtree_interval_end(new))
+		return -ENOTEMPTY;
 
+	/* Accepted element: pick insertion point depending on key value */
 	parent = NULL;
 	p = &priv->root.rb_node;
 	while (*p != NULL) {
 		parent = *p;
 		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
-		d = memcmp(nft_set_ext_key(&rbe->ext),
-			   nft_set_ext_key(&new->ext),
-			   set->klen);
-		if (d < 0) {
-			p = &parent->rb_left;
+		d = nft_rbtree_cmp(set, rbe, new);
 
-			if (nft_rbtree_interval_start(new)) {
-				if (nft_rbtree_interval_end(rbe) &&
-				    nft_set_elem_active(&rbe->ext, genmask) &&
-				    !nft_set_elem_expired(&rbe->ext) && !*p)
-					overlap = false;
-			} else {
-				if (dup_end_left && !*p)
-					return -ENOTEMPTY;
-
-				overlap = nft_rbtree_interval_end(rbe) &&
-					  nft_set_elem_active(&rbe->ext,
-							      genmask) &&
-					  !nft_set_elem_expired(&rbe->ext);
-
-				if (overlap) {
-					dup_end_right = true;
-					continue;
-				}
-			}
-		} else if (d > 0) {
+		if (d < 0)
+			p = &parent->rb_left;
+		else if (d > 0)
+			p = &parent->rb_right;
+		else if (nft_rbtree_interval_end(rbe))
+			p = &parent->rb_left;
+		else
 			p = &parent->rb_right;
-
-			if (nft_rbtree_interval_end(new)) {
-				if (dup_end_right && !*p)
-					return -ENOTEMPTY;
-
-				overlap = nft_rbtree_interval_end(rbe) &&
-					  nft_set_elem_active(&rbe->ext,
-							      genmask) &&
-					  !nft_set_elem_expired(&rbe->ext);
-
-				if (overlap) {
-					dup_end_left = true;
-					continue;
-				}
-			} else if (nft_set_elem_active(&rbe->ext, genmask) &&
-				   !nft_set_elem_expired(&rbe->ext)) {
-				overlap = nft_rbtree_interval_end(rbe);
-			}
-		} else {
-			if (nft_rbtree_interval_end(rbe) &&
-			    nft_rbtree_interval_start(new)) {
-				p = &parent->rb_left;
-
-				if (nft_set_elem_active(&rbe->ext, genmask) &&
-				    !nft_set_elem_expired(&rbe->ext))
-					overlap = false;
-			} else if (nft_rbtree_interval_start(rbe) &&
-				   nft_rbtree_interval_end(new)) {
-				p = &parent->rb_right;
-
-				if (nft_set_elem_active(&rbe->ext, genmask) &&
-				    !nft_set_elem_expired(&rbe->ext))
-					overlap = false;
-			} else if (nft_set_elem_active(&rbe->ext, genmask) &&
-				   !nft_set_elem_expired(&rbe->ext)) {
-				*ext = &rbe->ext;
-				return -EEXIST;
-			} else {
-				overlap = false;
-				if (nft_rbtree_interval_end(rbe))
-					p = &parent->rb_left;
-				else
-					p = &parent->rb_right;
-			}
-		}
-
-		dup_end_left = dup_end_right = false;
 	}
 
-	if (overlap)
-		return -ENOTEMPTY;
-
 	rb_link_node_rcu(&new->node, parent, p);
 	rb_insert_color(&new->node, &priv->root);
 	return 0;
-- 
2.35.1

