Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B66AEC38147
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Jan 2023 15:06:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjARPGZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Jan 2023 10:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbjARPGV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2023 10:06:21 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 39BDD10EF
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2023 07:06:19 -0800 (PST)
Date:   Wed, 18 Jan 2023 16:06:15 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH 1/2 nf,v3] netfilter: nft_set_rbtree: Switch to node list
 walk for overlap detection
Message-ID: <Y8gK55+c0qBSuD89@salvia>
References: <20230118111415.208127-1-pablo@netfilter.org>
 <20230118140944.6dad71a7@elisabeth>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="D28UpRcK2i/H9ogJ"
Content-Disposition: inline
In-Reply-To: <20230118140944.6dad71a7@elisabeth>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--D28UpRcK2i/H9ogJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Wed, Jan 18, 2023 at 02:09:44PM +0100, Stefano Brivio wrote:
> On Wed, 18 Jan 2023 12:14:14 +0100
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > ...instead of a tree descent, which became overly complicated in an
> > attempt to cover cases where expired or inactive elements would affect
> > comparisons with the new element being inserted.
> > 
> > Further, it turned out that it's probably impossible to cover all those
> > cases, as inactive nodes might entirely hide subtrees consisting of a
> > complete interval plus a node that makes the current insertion not
> > overlap.
> > 
> > To speed up the overlap check, descent the tree to find a greater
> > element that is closer to the key value to insert. Then walk down the
> > node list for overlap detection. Starting the overlap check from
> > rb_first() unconditionally is slow, it takes 10 times longer due to the
> > full linear traversal of the list.
> > 
> > Moreover, perform garbage collection of expired elements when walking
> > down the node list to avoid bogus overlap reports.
> 
> ...I'm quite convinced it's fine to perform the garbage collection
> *after* we found the first element by descending the tree -- in the
> worst case we include "too many" elements in the tree walk, but never
> too little.

Thanks for reviewing.

I'm testing an extra chunk on top of this patch (see attachment) to
reduce the number of visited nodes when walking the list.

It re-adds nft_rbtree_update_first() with the "right logic" this
time, basically:

+static bool nft_rbtree_update_first(const struct nft_set *set,
+                                   struct nft_rbtree_elem *rbe,
+                                   struct rb_node *first)
+{
+       struct nft_rbtree_elem *first_elem;
+
+       first_elem = rb_entry(first, struct nft_rbtree_elem, node);
+       /* this element is closest to where the new element is to be inserted:
+        * update the first element for the node list path
+        */
+       if (nft_rbtree_cmp(set, rbe, first_elem) < 0)
+               return true;
+
+       return false;
+}
 static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
                               struct nft_rbtree_elem *new,
                               struct nft_set_ext **ext)
@@ -272,7 +288,10 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
                if (d < 0) {
                        p = &parent->rb_left;
                } else if (d > 0) {
-                       first = &rbe->node;
+                       if (!first ||
+                           nft_rbtree_update_first(set, rbe, first))
+                               first = &rbe->node;
+
                        p = &parent->rb_right;
                } else {
                        if (nft_rbtree_interval_end(rbe))


When updating the first node in the list walk, only update first if:

        node < first

this means 'node' is closest where we want to add the element, to
reduce the number of visited nodes in list walk.

In summary:

1) Descend the tree to check if node > new.
2) If no first: first = node else if node < first: first = node

because the tree is reverse order, node lesser than 'first' means node
is closer to where we want to start the list walk.

I observe less visited nodes in the list walk, still time to reload a
large set is similar. I suspect it is the comparison in
nft_rbtree_update_first() is the reason (with this chunk, this performs
less comparisons in the list walk but now we have to compare nodes when
descending the tree to find the first node).

[...]
> > -	 *
> > -	 * However, if the existing start matches a pre-existing start, but the
> > -	 * end element doesn't match the corresponding pre-existing end element,
> > -	 * we need to report a partial overlap. This is a local condition that
> > -	 * can be noticed without need for a tracking flag, by checking for a
> > -	 * local duplicated end for a corresponding start, from left and right,
> > -	 * separately.
> > +	/* Descent the tree to search for an existing element greater than the
> 
> s/Descent/Descend/

I'll fix this nit, thanks.

--D28UpRcK2i/H9ogJ
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 852e8302ad58..297fedc6dec3 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -247,6 +247,22 @@ static int nft_rbtree_gc_elem(const struct nft_set *__set,
 	return 0;
 }
 
+static bool nft_rbtree_update_first(const struct nft_set *set,
+				    struct nft_rbtree_elem *rbe,
+				    struct rb_node *first)
+{
+	struct nft_rbtree_elem *first_elem;
+
+	first_elem = rb_entry(first, struct nft_rbtree_elem, node);
+	/* this element is closest to where the new element is to be inserted:
+	 * update the first element for the node list path
+	 */
+	if (nft_rbtree_cmp(set, rbe, first_elem) < 0)
+		return true;
+
+	return false;
+}
+
 static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			       struct nft_rbtree_elem *new,
 			       struct nft_set_ext **ext)
@@ -272,7 +288,10 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		if (d < 0) {
 			p = &parent->rb_left;
 		} else if (d > 0) {
-			first = &rbe->node;
+			if (!first ||
+			    nft_rbtree_update_first(set, rbe, first))
+				first = &rbe->node;
+
 			p = &parent->rb_right;
 		} else {
 			if (nft_rbtree_interval_end(rbe))

--D28UpRcK2i/H9ogJ--
