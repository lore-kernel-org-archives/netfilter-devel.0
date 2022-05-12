Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7BFEC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 May 2022 18:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357706AbiELSe1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 May 2022 14:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357607AbiELSe0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 May 2022 14:34:26 -0400
X-Greylist: delayed 597 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 12 May 2022 11:34:24 PDT
Received: from maja (passt.top [88.198.0.164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C1566AFE
        for <netfilter-devel@vger.kernel.org>; Thu, 12 May 2022 11:34:23 -0700 (PDT)
Received: by maja (Postfix, from userid 1000)
        id E28F25A0796; Thu, 12 May 2022 20:34:21 +0200 (CEST)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] nft_set_rbtree: Move clauses for expired nodes, last active node as leaf
Date:   Thu, 12 May 2022 20:34:21 +0200
Message-Id: <20220512183421.712556-1-sbrivio@redhat.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In the overlap detection performed as part of the insertion operation,
we have to skip nodes that are not active in the current generation or
expired. This was done by adding several conditions in overlap decision
clauses, which made it hard to check for correctness, and debug the
actual issue this patch is fixing.

Consolidate these conditions into a single clause, so that we can
proceed with debugging and fixing the following issue.

Case b3. described in comments covers the insertion of a start
element after an existing end, as a leaf. If all the descendants of
a given element are inactive, functionally, for the purposes of
overlap detection, we still have to treat this as a leaf, but we don't.

If, in the same transaction, we remove a start element to the right,
remove an end element to the left, and add a start element to the right
of an existing, active end element, we don't hit case b3. For example:

- existing intervals: 1-2, 3-5, 6-7
- transaction: delete 3-5, insert 4-5

node traversal might happen as follows:
- 2 (active end)
- 5 (inactive end)
- 3 (inactive start)

when we add 4 as start element, we should simply consider 2 as
preceding end, and consider it as a leaf, because interval 3-5 has been
deleted. If we don't, we'll report an overlap because we forgot about
this.

Add an additional flag which is set as we find an active end, and reset
it if we find an active start (to the left). If we finish the traversal
with this flag set, it means we need to functionally consider the
previous active end as a leaf, and allow insertion instead of reporting
overlap.

Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/netfilter/nft_set_rbtree.c | 92 ++++++++++++++++++++--------------
 1 file changed, 54 insertions(+), 38 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 7325bee7d144..dc2184bbe722 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -222,6 +222,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	bool overlap = false, dup_end_left = false, dup_end_right = false;
 	struct nft_rbtree *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_next(net);
+	bool last_left_node_is_end = false;
 	struct nft_rbtree_elem *rbe;
 	struct rb_node *parent, **p;
 	int d;
@@ -287,80 +288,95 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		d = memcmp(nft_set_ext_key(&rbe->ext),
 			   nft_set_ext_key(&new->ext),
 			   set->klen);
-		if (d < 0) {
+
+		if (d < 0)
 			p = &parent->rb_left;
+		else if (d > 0)
+			p = &parent->rb_right;
+		else if (nft_rbtree_interval_end(rbe))
+			p = &parent->rb_left;
+		else
+			p = &parent->rb_right;
 
+		/* There might be inactive elements in the tree: ignore them by
+		 * traversing them without affecting flags.
+		 *
+		 * We need to reset the dup_end_left and dup_end_right flags,
+		 * though, because those only apply to adjacent nodes.
+		 */
+		if (!nft_set_elem_active(&rbe->ext, genmask) ||
+		    nft_set_elem_expired(&rbe->ext)) {
+			dup_end_left = dup_end_right = false;
+			continue;
+		}
+
+		if (d < 0) {
 			if (nft_rbtree_interval_start(new)) {
-				if (nft_rbtree_interval_end(rbe) &&
-				    nft_set_elem_active(&rbe->ext, genmask) &&
-				    !nft_set_elem_expired(&rbe->ext) && !*p)
-					overlap = false;
+				/* See case b3. described above.
+				 *
+				 * If this is not a leaf, but all nodes below
+				 * this one are inactive, except for a leaf, we
+				 * still have to consider it a leaf for the
+				 * purposes of overlap detection.
+				 *
+				 * Set last_left_node_is_end if this is not a
+				 * leaf and an active end element, and reset it
+				 * if we find an active start element to the
+				 * left.
+				 *
+				 * If we end the traversal with this flag set,
+				 * this node is a leaf for the purposes of case
+				 * b3., and no overlap will be reported.
+				 */
+				if (nft_rbtree_interval_end(rbe)) {
+					if (!*p)
+						overlap = false;
+					else
+						last_left_node_is_end = true;
+				} else {
+					last_left_node_is_end = false;
+				}
 			} else {
+
 				if (dup_end_left && !*p)
 					return -ENOTEMPTY;
 
-				overlap = nft_rbtree_interval_end(rbe) &&
-					  nft_set_elem_active(&rbe->ext,
-							      genmask) &&
-					  !nft_set_elem_expired(&rbe->ext);
-
+				overlap = nft_rbtree_interval_end(rbe);
 				if (overlap) {
 					dup_end_right = true;
 					continue;
 				}
 			}
 		} else if (d > 0) {
-			p = &parent->rb_right;
-
 			if (nft_rbtree_interval_end(new)) {
 				if (dup_end_right && !*p)
 					return -ENOTEMPTY;
 
-				overlap = nft_rbtree_interval_end(rbe) &&
-					  nft_set_elem_active(&rbe->ext,
-							      genmask) &&
-					  !nft_set_elem_expired(&rbe->ext);
-
+				overlap = nft_rbtree_interval_end(rbe);
 				if (overlap) {
 					dup_end_left = true;
 					continue;
 				}
-			} else if (nft_set_elem_active(&rbe->ext, genmask) &&
-				   !nft_set_elem_expired(&rbe->ext)) {
+			} else {
 				overlap = nft_rbtree_interval_end(rbe);
 			}
 		} else {
 			if (nft_rbtree_interval_end(rbe) &&
 			    nft_rbtree_interval_start(new)) {
-				p = &parent->rb_left;
-
-				if (nft_set_elem_active(&rbe->ext, genmask) &&
-				    !nft_set_elem_expired(&rbe->ext))
-					overlap = false;
+				overlap = false;
 			} else if (nft_rbtree_interval_start(rbe) &&
 				   nft_rbtree_interval_end(new)) {
-				p = &parent->rb_right;
-
-				if (nft_set_elem_active(&rbe->ext, genmask) &&
-				    !nft_set_elem_expired(&rbe->ext))
-					overlap = false;
-			} else if (nft_set_elem_active(&rbe->ext, genmask) &&
-				   !nft_set_elem_expired(&rbe->ext)) {
+				overlap = false;
+			} else {
 				*ext = &rbe->ext;
 				return -EEXIST;
-			} else {
-				overlap = false;
-				if (nft_rbtree_interval_end(rbe))
-					p = &parent->rb_left;
-				else
-					p = &parent->rb_right;
 			}
 		}
 
 		dup_end_left = dup_end_right = false;
 	}
 
-	if (overlap)
+	if (overlap && !last_left_node_is_end)
 		return -ENOTEMPTY;
 
 	rb_link_node_rcu(&new->node, parent, p);
-- 
2.35.1

