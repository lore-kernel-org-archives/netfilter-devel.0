From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/5 nf,kernel] netfilter: nft_rbtree: allow adjacent intervals with dynamic updates
Date: Tue, 19 Jan 2016 18:52:52 +0100
Message-ID: <1453225976-23749-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, ast@fiberby.dk
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56874 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932733AbcASRxX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jan 2016 12:53:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 54830231670
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2016 18:53:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 44D0DDA809
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2016 18:53:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 627B2DA809
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2016 18:53:13 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes dynamic element updates for intervals, since this is
always returning a bogus EEXIST when comparing the high and low ends of
adjacent intervals.

Moreover, when two intervals are adjacent, we have to check flags to
know where to insert the new nodes in the tree.

Assuming the following scenario:

 Existing element       [ 1.2.3.0, 1.2.4.0 )
                                   ^^^^^^^
                                      a

 New element            [ 1.2.4.0, 1.2.5.0 )
                         ^^^^^^^^
                             b

When comparing 'a' and 'b', 'a' got its end-of-interval flag set,
therefore they are different elements. This patch places 'b' on the left
branch so the lookup finds 'b' before 'a' so the existing lookup
function finds this in first place in case of exact matching (ie. for
the 1.2.4.0 case).

The opposite scenario, ie:

 Existing element       [ 1.2.3.0, 1.2.4.0 )
                          ^^^^^^^
                             a

 New element            [ 1.2.2.0, 1.2.3.0 )
                                   ^^^^^^^^
                                      b

will place 'b' on the right branch, so it is placed after 'a'.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
This approach is not very efficient since we can merge adjacent
segments. In case of maps, we would need to check if the data part can
actually be merged too. Anyway, we still have a central spinlock to
protect the rb-tree, we should probably explore an alternative
implementation.

This is attempt to resolve the existing issue in a minimalistic fashion,
we have to revisit this.

 net/netfilter/nft_rbtree.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_rbtree.c b/net/netfilter/nft_rbtree.c
index 1c30f41..063603d 100644
--- a/net/netfilter/nft_rbtree.c
+++ b/net/netfilter/nft_rbtree.c
@@ -29,6 +29,11 @@ struct nft_rbtree_elem {
 	struct nft_set_ext	ext;
 };
 
+static bool nft_rbtree_interval_end(const struct nft_rbtree_elem *rbe)
+{
+	return nft_set_ext_exists(&rbe->ext, NFT_SET_EXT_FLAGS) &&
+	       (*nft_set_ext_flags(&rbe->ext) & NFT_SET_ELEM_INTERVAL_END);
+}
 
 static bool nft_rbtree_lookup(const struct nft_set *set, const u32 *key,
 			      const struct nft_set_ext **ext)
@@ -56,9 +61,7 @@ found:
 				parent = parent->rb_left;
 				continue;
 			}
-			if (nft_set_ext_exists(&rbe->ext, NFT_SET_EXT_FLAGS) &&
-			    *nft_set_ext_flags(&rbe->ext) &
-			    NFT_SET_ELEM_INTERVAL_END)
+			if (nft_rbtree_interval_end(rbe))
 				goto out;
 			spin_unlock_bh(&nft_rbtree_lock);
 
@@ -98,9 +101,16 @@ static int __nft_rbtree_insert(const struct nft_set *set,
 		else if (d > 0)
 			p = &parent->rb_right;
 		else {
-			if (nft_set_elem_active(&rbe->ext, genmask))
-				return -EEXIST;
-			p = &parent->rb_left;
+			if (nft_set_elem_active(&rbe->ext, genmask)) {
+				if (!nft_rbtree_interval_end(rbe) &&
+				    nft_rbtree_interval_end(new))
+					p = &parent->rb_right;
+				else if (nft_rbtree_interval_end(rbe) &&
+					 !nft_rbtree_interval_end(new))
+					p = &parent->rb_left;
+				else
+					return -EEXIST;
+			}
 		}
 	}
 	rb_link_node(&new->node, parent, p);
-- 
2.1.4

