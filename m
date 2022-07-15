Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D84FC43334
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Jul 2022 11:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiGOLN6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Jul 2022 07:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiGOLN6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Jul 2022 07:13:58 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B960B17E1C
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Jul 2022 04:13:55 -0700 (PDT)
Date:   Fri, 15 Jul 2022 13:13:52 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] nft_set_rbtree: Switch to node list walk for overlap
 detection
Message-ID: <YtFL8OWnViZGma3g@salvia>
References: <20220614010704.1416375-1-sbrivio@redhat.com>
 <Yrnh2lqhvvzrT2ii@salvia>
 <20220702015510.08ee9401@elisabeth>
 <YsQmS4+qdFz8s+sN@salvia>
 <20220706231242.492ba5d1@elisabeth>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BOOY55Jooa0HKftT"
Content-Disposition: inline
In-Reply-To: <20220706231242.492ba5d1@elisabeth>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--BOOY55Jooa0HKftT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Wed, Jul 06, 2022 at 11:12:42PM +0200, Stefano Brivio wrote:
> On Tue, 5 Jul 2022 13:53:47 +0200
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
[...]
> This simplifies the handling of those cases, we wouldn't need all those
> clauses anymore, but I really think that the existing problem comes from
> the fact we can *not* descend the tree just by selecting key values.

Thanks for explaining.

The traversal rbtree via rb_first() and rb_next() is like an ordered
linear list walk, maybe it is possible to reduce the number of
elements to find an overlap?

I'm attaching an incremental patch on top of yours, idea is:

1) find the closest element whose key is less than the new element
   by descending the tree. This provides the first node to walk.

2) annotate closest active element that is less than the new element,
   walking over the ordered list.

3) annotate closest active element that is more than the new element,
   Stop walking the ordered list.

4) if new element is an exact match, then EEXIST.

5) if new element is end and closest less than element is end, or
   if new element is start and closest less than element is start, or
   if new element is end and closest more than element is end,
   Then ENOTEMPTY.

Inactive/expired elements are skipped while walking the ordered linear
list as usual.

With this incremental patch, I don't observe longer time to load
interval sets.

--BOOY55Jooa0HKftT
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

commit 796b1f40a42b505d0e614fd2fbb6dad9f4e3c2c5
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Fri Jul 15 10:38:31 2022 +0200

    x

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 87a28d2dca77..176173f770fd 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -220,13 +220,37 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			       struct nft_set_ext **ext)
 {
 	struct nft_rbtree_elem *rbe, *rbe_le = NULL, *rbe_ge = NULL;
+	struct rb_node *node, *parent, **p, *first = NULL;
 	struct nft_rbtree *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_next(net);
-	struct rb_node *node, *parent, **p;
 	int d;
 
+	parent = NULL;
+	p = &priv->root.rb_node;
+	while (*p != NULL) {
+		parent = *p;
+		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
+		d = nft_rbtree_cmp(set, rbe, new);
+
+		if (d < 0)
+			p = &parent->rb_left;
+		else if (d > 0) {
+			first = &rbe->node;
+			p = &parent->rb_right;
+		} else {
+			first = &rbe->node;
+			if (nft_rbtree_interval_end(rbe))
+				p = &parent->rb_left;
+			else
+				p = &parent->rb_right;
+		}
+	}
+
+	if (!first)
+		first = rb_first(&priv->root);
+
 	/* Detect overlaps by going through the list of valid tree nodes: */
-	for (node = rb_first(&priv->root); node != NULL; node = rb_next(node)) {
+	for (node = first; node != NULL; node = rb_next(node)) {
 		rbe = rb_entry(node, struct nft_rbtree_elem, node);
 
 		if (!nft_set_elem_active(&rbe->ext, genmask) ||
@@ -235,9 +259,13 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 
 		d = nft_rbtree_cmp(set, rbe, new);
 
-		if (d <= 0 && (!rbe_le || nft_rbtree_cmp(set, rbe, rbe_le) > 0))
+		/* annotate element coming before new element. */
+		if (d < 0 && (!rbe_le || nft_rbtree_cmp(set, rbe, rbe_le) > 0)) {
 			rbe_le = rbe;
+			break;
+		}
 
+		/* annotate existing element coming after new element. */
 		if (d >= 0 && (!rbe_ge || nft_rbtree_cmp(set, rbe, rbe_ge) < 0))
 			rbe_ge = rbe;
 	}
@@ -246,7 +274,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	 *   matching end element: full overlap reported as -EEXIST, cleared by
 	 *   caller if NLM_F_EXCL is not given
 	 */
-	rbe = rbe_le;
+	rbe = rbe_ge;
 	if (rbe && !nft_rbtree_cmp(set, new, rbe) &&
 	    nft_rbtree_interval_start(rbe) == nft_rbtree_interval_start(new)) {
 		*ext = &rbe->ext;
@@ -257,7 +285,14 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	 *   being a start element: partial overlap, reported as -ENOTEMPTY
 	 */
 	if (rbe_le &&
-	    nft_rbtree_interval_start(rbe_le) && nft_rbtree_interval_start(new))
+	    nft_rbtree_interval_end(rbe_le) && nft_rbtree_interval_end(new))
+		return -ENOTEMPTY;
+
+	/* - new start element before existing closest, less or equal key value
+	 *   element: partial overlap, reported as -ENOTEMPTY
+	 */
+	if (rbe_ge &&
+	    nft_rbtree_interval_start(rbe_ge) && nft_rbtree_interval_start(new))
 		return -ENOTEMPTY;
 
 	/* - new end element with existing closest, greater or equal key value

--BOOY55Jooa0HKftT--
