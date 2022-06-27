Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB892C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jun 2022 16:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235468AbiF0Q7N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Jun 2022 12:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbiF0Q7M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Jun 2022 12:59:12 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EE967DEC6
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jun 2022 09:59:09 -0700 (PDT)
Date:   Mon, 27 Jun 2022 18:59:06 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] nft_set_rbtree: Switch to node list walk for overlap
 detection
Message-ID: <Yrnh2lqhvvzrT2ii@salvia>
References: <20220614010704.1416375-1-sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EXi8YAorsVoAmrqd"
Content-Disposition: inline
In-Reply-To: <20220614010704.1416375-1-sbrivio@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--EXi8YAorsVoAmrqd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Stefano,

On Tue, Jun 14, 2022 at 03:07:04AM +0200, Stefano Brivio wrote:
> ...instead of a tree descent, which became overly complicated in an
> attempt to cover cases where expired or inactive elements would
> affect comparisons with the new element being inserted.
>
> Further, it turned out that it's probably impossible to cover all
> those cases, as inactive nodes might entirely hide subtrees
> consisting of a complete interval plus a node that makes the current
> insertion not overlap.
>
> For the insertion operation itself, this essentially reverts back to
> the implementation before commit 7c84d41416d8
> ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion"),
> except that cases of complete overlap are already handled in the
> overlap detection phase itself, which slightly simplifies the loop to
> find the insertion point.
>
> Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
>  net/netfilter/nft_set_rbtree.c | 194 ++++++++++-----------------------
>  1 file changed, 58 insertions(+), 136 deletions(-)

When running tests this is increasing the time to detect overlaps in
my testbed, because of the linear list walk for each element.

So I have been looking at an alternative approach (see attached patch) to
address your comments. The idea is to move out the overlapping nodes
from the element in the tree, instead keep them in a list.

                        root
                        /  \
                     elem   elem -> update -> update
                            /  \
                         elem  elem

Each rbtree element in the tree .has pending_list which stores the
element that supersede the existing (inactive) element. There is also a
.list which is used to add the element to the .pending_list. Elements
in the tree might have a .pending_list with one or more elements.

The .deactivate path looks for the last (possibly) active element. The
.remove path depends on the element state: a) element is singleton (no
pending elements), then erase from tree, b) element has a pending
list, then replace the first element in the pending_list by this node,
and splice pending_list (there might be more elements), c) this
element is in the pending_list, the just remove it. This handles both
commit (walks through the list of transaction forward direction) and
abort path (walks through the list of transactions in backward
direction).

With this approach, there is no more 'gray' nodes in the tree, as you
describe in your problem statement.

This is increasing the size of the rbtree element, probably I can
just add a pointer to a new nft_rbtree_elem_update structure (not done
in this patch) and allocate it dynamically on updates, so this only
takes 8 extra bytes per rbtree element, not sure how complex that is.

I'm attaching the patch I've been testing here.

Let me know, thanks.

--EXi8YAorsVoAmrqd
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="rbtree.patch"

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 7325bee7d144..14d15efbe545 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -24,9 +24,36 @@ struct nft_rbtree {
 
 struct nft_rbtree_elem {
 	struct rb_node		node;
+	struct list_head	pending_list;
+	struct list_head	list;
 	struct nft_set_ext	ext;
 };
 
+static struct nft_rbtree_elem *nft_rbtree_elem_leaf(const struct nft_rbtree_elem *rbe, u8 genmask)
+{
+	struct nft_rbtree_elem *elem;
+
+	if (unlikely(!list_empty(&rbe->pending_list))) {
+		elem = list_last_entry(&rbe->pending_list, struct nft_rbtree_elem, list);
+		return elem;
+	}
+
+	return (struct nft_rbtree_elem *)rbe;
+}
+
+static bool __nft_rbtree_elem_active(const struct nft_rbtree_elem *rbe, u8 genmask)
+{
+	return nft_set_elem_active(&rbe->ext, genmask) &&
+	       !nft_set_elem_expired(&rbe->ext);
+}
+
+static bool nft_rbtree_elem_active(const struct nft_rbtree_elem *rbe, u8 genmask)
+{
+	struct nft_rbtree_elem *elem = nft_rbtree_elem_leaf(rbe, genmask);
+
+	return __nft_rbtree_elem_active(elem, genmask);
+}
+
 static bool nft_rbtree_interval_end(const struct nft_rbtree_elem *rbe)
 {
 	return nft_set_ext_exists(&rbe->ext, NFT_SET_EXT_FLAGS) &&
@@ -75,12 +102,7 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 		} else if (d > 0)
 			parent = rcu_dereference_raw(parent->rb_right);
 		else {
-			if (!nft_set_elem_active(&rbe->ext, genmask)) {
-				parent = rcu_dereference_raw(parent->rb_left);
-				continue;
-			}
-
-			if (nft_set_elem_expired(&rbe->ext))
+			if (!nft_rbtree_elem_active(rbe, genmask))
 				return false;
 
 			if (nft_rbtree_interval_end(rbe)) {
@@ -97,8 +119,7 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 	}
 
 	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
-	    nft_set_elem_active(&interval->ext, genmask) &&
-	    !nft_set_elem_expired(&interval->ext) &&
+	    nft_rbtree_elem_active(interval, genmask) &&
 	    nft_rbtree_interval_start(interval)) {
 		*ext = &interval->ext;
 		return true;
@@ -155,12 +176,7 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
 			if (flags & NFT_SET_ELEM_INTERVAL_END)
 				interval = rbe;
 		} else {
-			if (!nft_set_elem_active(&rbe->ext, genmask)) {
-				parent = rcu_dereference_raw(parent->rb_left);
-				continue;
-			}
-
-			if (nft_set_elem_expired(&rbe->ext))
+			if (!nft_rbtree_elem_active(rbe, genmask))
 				return false;
 
 			if (!nft_set_ext_exists(&rbe->ext, NFT_SET_EXT_FLAGS) ||
@@ -178,8 +194,7 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
 	}
 
 	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
-	    nft_set_elem_active(&interval->ext, genmask) &&
-	    !nft_set_elem_expired(&interval->ext) &&
+	    nft_rbtree_elem_active(interval, genmask) &&
 	    ((!nft_rbtree_interval_end(interval) &&
 	      !(flags & NFT_SET_ELEM_INTERVAL_END)) ||
 	     (nft_rbtree_interval_end(interval) &&
@@ -215,6 +230,22 @@ static void *nft_rbtree_get(const struct net *net, const struct nft_set *set,
 	return rbe;
 }
 
+static int nft_rbtree_insert_pending(struct nft_rbtree_elem *rbe,
+				     struct nft_rbtree_elem *new, u8 genmask)
+{
+	struct nft_rbtree_elem *elem;
+
+	if (unlikely(!list_empty(&rbe->pending_list))) {
+		elem = list_last_entry(&rbe->pending_list, struct nft_rbtree_elem, list);
+		if (nft_set_elem_active(&elem->ext, genmask))
+			return -EEXIST;
+	}
+
+	list_add_tail(&new->list, &rbe->pending_list);
+
+	return 0;
+}
+
 static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			       struct nft_rbtree_elem *new,
 			       struct nft_set_ext **ext)
@@ -226,6 +257,9 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	struct rb_node *parent, **p;
 	int d;
 
+	INIT_LIST_HEAD(&new->pending_list);
+	INIT_LIST_HEAD(&new->list);
+
 	/* Detect overlaps as we descend the tree. Set the flag in these cases:
 	 *
 	 * a1. _ _ __>|  ?_ _ __|  (insert end before existing end)
@@ -292,17 +326,14 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 
 			if (nft_rbtree_interval_start(new)) {
 				if (nft_rbtree_interval_end(rbe) &&
-				    nft_set_elem_active(&rbe->ext, genmask) &&
-				    !nft_set_elem_expired(&rbe->ext) && !*p)
+				    nft_rbtree_elem_active(rbe, genmask) && !*p)
 					overlap = false;
 			} else {
 				if (dup_end_left && !*p)
 					return -ENOTEMPTY;
 
 				overlap = nft_rbtree_interval_end(rbe) &&
-					  nft_set_elem_active(&rbe->ext,
-							      genmask) &&
-					  !nft_set_elem_expired(&rbe->ext);
+					  nft_rbtree_elem_active(rbe, genmask);
 
 				if (overlap) {
 					dup_end_right = true;
@@ -317,16 +348,13 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 					return -ENOTEMPTY;
 
 				overlap = nft_rbtree_interval_end(rbe) &&
-					  nft_set_elem_active(&rbe->ext,
-							      genmask) &&
-					  !nft_set_elem_expired(&rbe->ext);
+					  nft_rbtree_elem_active(rbe, genmask);
 
 				if (overlap) {
 					dup_end_left = true;
 					continue;
 				}
-			} else if (nft_set_elem_active(&rbe->ext, genmask) &&
-				   !nft_set_elem_expired(&rbe->ext)) {
+			} else if (nft_rbtree_elem_active(rbe, genmask)) {
 				overlap = nft_rbtree_interval_end(rbe);
 			}
 		} else {
@@ -334,26 +362,19 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			    nft_rbtree_interval_start(new)) {
 				p = &parent->rb_left;
 
-				if (nft_set_elem_active(&rbe->ext, genmask) &&
-				    !nft_set_elem_expired(&rbe->ext))
+				if (nft_rbtree_elem_active(rbe, genmask))
 					overlap = false;
 			} else if (nft_rbtree_interval_start(rbe) &&
 				   nft_rbtree_interval_end(new)) {
 				p = &parent->rb_right;
 
-				if (nft_set_elem_active(&rbe->ext, genmask) &&
-				    !nft_set_elem_expired(&rbe->ext))
+				if (nft_rbtree_elem_active(rbe, genmask))
 					overlap = false;
-			} else if (nft_set_elem_active(&rbe->ext, genmask) &&
-				   !nft_set_elem_expired(&rbe->ext)) {
+			} else if (nft_rbtree_elem_active(rbe, genmask)) {
 				*ext = &rbe->ext;
 				return -EEXIST;
 			} else {
-				overlap = false;
-				if (nft_rbtree_interval_end(rbe))
-					p = &parent->rb_left;
-				else
-					p = &parent->rb_right;
+				return nft_rbtree_insert_pending(rbe, new, genmask);
 			}
 		}
 
@@ -365,6 +386,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 
 	rb_link_node_rcu(&new->node, parent, p);
 	rb_insert_color(&new->node, &priv->root);
+
 	return 0;
 }
 
@@ -389,12 +411,21 @@ static void nft_rbtree_remove(const struct net *net,
 			      const struct nft_set *set,
 			      const struct nft_set_elem *elem)
 {
+	struct nft_rbtree_elem *rbe = elem->priv, *new;
 	struct nft_rbtree *priv = nft_set_priv(set);
-	struct nft_rbtree_elem *rbe = elem->priv;
 
 	write_lock_bh(&priv->lock);
 	write_seqcount_begin(&priv->count);
-	rb_erase(&rbe->node, &priv->root);
+	if (!list_empty(&rbe->list)) {
+		list_del(&rbe->list);
+	} else if (!list_empty(&rbe->pending_list)) {
+		new = list_first_entry(&rbe->pending_list, struct nft_rbtree_elem, list);
+		list_del_init(&new->list);
+		list_splice(&rbe->pending_list, &new->pending_list);
+		rb_replace_node(&rbe->node, &new->node, &priv->root);
+	} else {
+		rb_erase(&rbe->node, &priv->root);
+	}
 	write_seqcount_end(&priv->count);
 	write_unlock_bh(&priv->lock);
 }
@@ -426,9 +457,9 @@ static void *nft_rbtree_deactivate(const struct net *net,
 				   const struct nft_set *set,
 				   const struct nft_set_elem *elem)
 {
+	struct nft_rbtree_elem *rbe, *this = elem->priv, *leaf;
 	const struct nft_rbtree *priv = nft_set_priv(set);
 	const struct rb_node *parent = priv->root.rb_node;
-	struct nft_rbtree_elem *rbe, *this = elem->priv;
 	u8 genmask = nft_genmask_next(net);
 	int d;
 
@@ -450,12 +481,14 @@ static void *nft_rbtree_deactivate(const struct net *net,
 				   nft_rbtree_interval_end(this)) {
 				parent = parent->rb_right;
 				continue;
-			} else if (!nft_set_elem_active(&rbe->ext, genmask)) {
-				parent = parent->rb_left;
-				continue;
+			} else if (!nft_rbtree_elem_active(rbe, genmask)) {
+				break;
 			}
-			nft_rbtree_flush(net, set, rbe);
-			return rbe;
+			leaf = nft_rbtree_elem_leaf(rbe, genmask);
+			if (!nft_rbtree_flush(net, set, leaf))
+				break;
+
+			return leaf;
 		}
 	}
 	return NULL;
@@ -466,7 +499,7 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 			    struct nft_set_iter *iter)
 {
 	struct nft_rbtree *priv = nft_set_priv(set);
-	struct nft_rbtree_elem *rbe;
+	struct nft_rbtree_elem *rbe, *leaf;
 	struct nft_set_elem elem;
 	struct rb_node *node;
 
@@ -476,12 +509,12 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 
 		if (iter->count < iter->skip)
 			goto cont;
-		if (nft_set_elem_expired(&rbe->ext))
-			goto cont;
-		if (!nft_set_elem_active(&rbe->ext, iter->genmask))
+
+		leaf = nft_rbtree_elem_leaf(rbe, iter->genmask);
+		if (!__nft_rbtree_elem_active(leaf, iter->genmask))
 			goto cont;
 
-		elem.priv = rbe;
+		elem.priv = leaf;
 
 		iter->err = iter->fn(ctx, set, iter, &elem);
 		if (iter->err < 0) {

--EXi8YAorsVoAmrqd--
