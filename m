Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 452FFCD4F57
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Sep 2023 11:15:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjIVLPw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Sep 2023 07:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233574AbjIVLPv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Sep 2023 07:15:51 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01606194
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Sep 2023 04:15:44 -0700 (PDT)
Received: from [78.30.34.192] (port=51156 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qje8K-00ElsB-HF; Fri, 22 Sep 2023 13:15:43 +0200
Date:   Fri, 22 Sep 2023 13:15:39 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [RFC nf] netfilter: nf_tables: nft_set_rbtree: invalidate
 greater range element on removal
Message-ID: <ZQ13W2Ih8e2CvzeV@calendula>
References: <20230921135212.31288-1-fw@strlen.de>
 <ZQ1ohTAB/u2XZRpV@calendula>
 <20230922102742.GE17533@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5NG4vy397WY02ysq"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230922102742.GE17533@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--5NG4vy397WY02ysq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Sep 22, 2023 at 12:27:42PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Main agenda here is to not just fix the spurious failure but to
> > > get rid of the async gc worker.
> > 
> > I would like to move this sync GC collection from insert() path, it is
> > sloppy and zapping entries that we hold references to as in this case.
> > I would like to move to use the .commit phase just like pipapo.
> 
> I can experiment with this next week.
>
> I already have a patch that converts async to sync gc similar to
> pipapo but it currently keeps the limited on-demand cycle too.

I am attaching a patch I tried, it moves GC sync from insert path it
to .commit step as an alternative to:

commit 2ee52ae94baabf7ee09cf2a8d854b990dac5d0e4
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Mon Sep 4 02:14:36 2023 +0200

    netfilter: nft_set_rbtree: skip sync GC for new elements in this transaction

Moreover, Stefano reported that having redundant nodes with same key
is a problem because rotations might hide entire subtrees.

> > The only solution I can see right now is to maintain two copies of the
> > rbtree, just like pipapo, then use the .commit phase, I started
> > sketching this updates.
> 
> I would like to avoid this, see below.
> 
> > Meanwhile setting rbe_ge and rbe_le to NULL if the element that is
> > referenced is removed makes sense to me.
> 
> Great, I will submit this patch formally with a slightly updated
> commit message.

Thanks.

> > The current GC sync inlined in insert() is also making it hard to
> > support for timeout refresh (element update command) without
> > reintroducing the _BUSY bit, which is something I would like to skip.
> 
> Ugh, yes, no busy bit please.

Agreed.

> > Then, there is another possibility that is to provide a hint to
> > userspace to use pipapo instead rbtree, via _GENMSG, but there is a
> > need to update pipapo to allow for singleton sets (with no
> > concatenation), which requires a oneliner in the kernel.
> >
> > The rbtree set backend is the corner that holds more technical debt
> > IMO.
> 
> I'm all in favor of getting rid of rbtree where possible.
> So we can keep it in-tree with 'acceptable' shortcomings (= no crashes)
> but userspace would no longer use it.

OK, still it would prevent from adding timeout refresh support, that
is a new command we have to deal with (element update) and we would
need to make sure GC sync cycle embbeded into _insert() does not zap
an element that has been updated. Things get a lot easier with GC sync
from .commit() step.

--5NG4vy397WY02ysq
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0001-netfilter-nft_set_rbtree-remove-sync-GC-from-insert-.patch"

From 1b757e2f678b127dc7c951f8d7987eb3219107f9 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 4 Sep 2023 00:03:22 +0200
Subject: [PATCH] netfilter: nft_set_rbtree: remove sync GC from insert path

New elements in this transaction might expire before such transaction
ends. Skip sync GC for such elements otherwise commit path might walk
over an already released object.

Skip expired elements in the overlap detection routine which iterates on
the reversed ordered list of elements that represent the intervals.
Since end elements provide no expiration extension, check for the next
non-end element in this interval, hence, skip both elements in the
iteration if the interval has expired. Finally, let async GC collect
such expired interval.

Fixes: f6c383b8c31a ("netfilter: nf_tables: adapt set backend to use GC transaction API")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 88 +++++-----------------------------
 1 file changed, 13 insertions(+), 75 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index c6435e709231..ff0cdc3ab7d8 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -221,74 +221,6 @@ static void *nft_rbtree_get(const struct net *net, const struct nft_set *set,
 	return rbe;
 }
 
-static void nft_rbtree_gc_remove(struct net *net, struct nft_set *set,
-				 struct nft_rbtree *priv,
-				 struct nft_rbtree_elem *rbe)
-{
-	struct nft_set_elem elem = {
-		.priv	= rbe,
-	};
-
-	nft_setelem_data_deactivate(net, set, &elem);
-	rb_erase(&rbe->node, &priv->root);
-}
-
-static int nft_rbtree_gc_elem(const struct nft_set *__set,
-			      struct nft_rbtree *priv,
-			      struct nft_rbtree_elem *rbe,
-			      u8 genmask)
-{
-	struct nft_set *set = (struct nft_set *)__set;
-	struct rb_node *prev = rb_prev(&rbe->node);
-	struct net *net = read_pnet(&set->net);
-	struct nft_rbtree_elem *rbe_prev;
-	struct nft_trans_gc *gc;
-
-	gc = nft_trans_gc_alloc(set, 0, GFP_ATOMIC);
-	if (!gc)
-		return -ENOMEM;
-
-	/* search for end interval coming before this element.
-	 * end intervals don't carry a timeout extension, they
-	 * are coupled with the interval start element.
-	 */
-	while (prev) {
-		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
-		if (nft_rbtree_interval_end(rbe_prev) &&
-		    nft_set_elem_active(&rbe_prev->ext, genmask))
-			break;
-
-		prev = rb_prev(prev);
-	}
-
-	if (prev) {
-		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
-		nft_rbtree_gc_remove(net, set, priv, rbe_prev);
-
-		/* There is always room in this trans gc for this element,
-		 * memory allocation never actually happens, hence, the warning
-		 * splat in such case. No need to set NFT_SET_ELEM_DEAD_BIT,
-		 * this is synchronous gc which never fails.
-		 */
-		gc = nft_trans_gc_queue_sync(gc, GFP_ATOMIC);
-		if (WARN_ON_ONCE(!gc))
-			return -ENOMEM;
-
-		nft_trans_gc_elem_add(gc, rbe_prev);
-	}
-
-	nft_rbtree_gc_remove(net, set, priv, rbe);
-	gc = nft_trans_gc_queue_sync(gc, GFP_ATOMIC);
-	if (WARN_ON_ONCE(!gc))
-		return -ENOMEM;
-
-	nft_trans_gc_elem_add(gc, rbe);
-
-	nft_trans_gc_queue_sync_done(gc);
-
-	return 0;
-}
-
 static bool nft_rbtree_update_first(const struct nft_set *set,
 				    struct nft_rbtree_elem *rbe,
 				    struct rb_node *first)
@@ -313,7 +245,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	struct rb_node *node, *next, *parent, **p, *first = NULL;
 	struct nft_rbtree *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_next(net);
-	int d, err;
+	int d;
 
 	/* Descend the tree to search for an existing element greater than the
 	 * key value to insert that is greater than the new element. This is the
@@ -357,13 +289,19 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		if (!nft_set_elem_active(&rbe->ext, genmask))
 			continue;
 
-		/* perform garbage collection to avoid bogus overlap reports. */
-		if (nft_set_elem_expired(&rbe->ext)) {
-			err = nft_rbtree_gc_elem(set, priv, rbe, genmask);
-			if (err < 0)
-				return err;
+		/* skip expired intervals to avoid bogus overlap reports:
+		 * end element has no expiration, check next start element.
+		 */
+		if (nft_rbtree_interval_end(rbe) && next) {
+			struct nft_rbtree_elem *rbe_next;
+
+			rbe_next = rb_entry(next, struct nft_rbtree_elem, node);
 
-			continue;
+			if (nft_set_elem_expired(&rbe_next->ext)) {
+				/* skip expired next start element. */
+				next = rb_next(next);
+				continue;
+			}
 		}
 
 		d = nft_rbtree_cmp(set, rbe, new);
-- 
2.30.2


--5NG4vy397WY02ysq--
