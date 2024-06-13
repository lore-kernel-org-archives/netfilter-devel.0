Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64DD143C60;
	Thu, 13 Jun 2024 11:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279064; cv=none; b=D4XCqMvJPJQJFbq0zJjS44WBi0Na5CAN/JnzZwQVys7H9WuyupjU80t8F0zIHZCbSgTmlwOLuY56H4UpKmqziCVz2Xo1Pyb3ZY/9L868+7ZSpAXOhxpQHxu2lRivOjenUSaBQtChsox0WBuLzjnR1Wl6LH3yqWPSymwN0tYKOGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279064; c=relaxed/simple;
	bh=+3ZdcMMaTOoQASnX7Zy0aPksLwVE/4vUbhtUvdrLGik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwJeKep9dcL61izmZARXEXySn0fDPJU/lnXHn2XANDUoIGcaFjEDyX9Jy5cGJMZmCBIFytEO7Nb8FfZET9dKqcaItyqvOhJ4l6lfAsBA0sPdvHhM8W80gaRzohTOYIQBpP+uunzz1AwSthVLDjk6xfN4dIdeFIR0Pxf4uudTxsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gAE4fO17; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gAE4fO17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2DEC32786;
	Thu, 13 Jun 2024 11:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279064;
	bh=+3ZdcMMaTOoQASnX7Zy0aPksLwVE/4vUbhtUvdrLGik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gAE4fO17iG5M2mlWdU7XAsHJgwcf+Y8vbiBtcOPmcFvoEfc+busFsWL/JuGdlxDic
	 +2ccbKd7kdY9/ezmfNms/1G73IFyo4sVa/AHJQIngd+bi4R2C9LJej1S2SoEGJuCvE
	 lbsd3iSwB0tXozB1h5EGscdKba+BkyimR867pUm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 164/213] netfilter: nft_set_rbtree: Switch to node list walk for overlap detection
Date: Thu, 13 Jun 2024 13:33:32 +0200
Message-ID: <20240613113234.312205246@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit c9e6978e2725a7d4b6cd23b2facd3f11422c0643 upstream.

...instead of a tree descent, which became overly complicated in an
attempt to cover cases where expired or inactive elements would affect
comparisons with the new element being inserted.

Further, it turned out that it's probably impossible to cover all those
cases, as inactive nodes might entirely hide subtrees consisting of a
complete interval plus a node that makes the current insertion not
overlap.

To speed up the overlap check, descent the tree to find a greater
element that is closer to the key value to insert. Then walk down the
node list for overlap detection. Starting the overlap check from
rb_first() unconditionally is slow, it takes 10 times longer due to the
full linear traversal of the list.

Moreover, perform garbage collection of expired elements when walking
down the node list to avoid bogus overlap reports.

For the insertion operation itself, this essentially reverts back to the
implementation before commit 7c84d41416d8 ("netfilter: nft_set_rbtree:
Detect partial overlaps on insertion"), except that cases of complete
overlap are already handled in the overlap detection phase itself, which
slightly simplifies the loop to find the insertion point.

Based on initial patch from Stefano Brivio, including text from the
original patch description too.

Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_rbtree.c |  223 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 198 insertions(+), 25 deletions(-)

--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -41,10 +41,12 @@ static bool nft_rbtree_interval_start(co
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
@@ -55,7 +57,6 @@ static bool __nft_rbtree_lookup(const st
 	const struct nft_rbtree_elem *rbe, *interval = NULL;
 	u8 genmask = nft_genmask_cur(net);
 	const struct rb_node *parent;
-	const void *this;
 	int d;
 
 	parent = rcu_dereference_raw(priv->root.rb_node);
@@ -65,12 +66,11 @@ static bool __nft_rbtree_lookup(const st
 
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
@@ -217,43 +217,216 @@ static void *nft_rbtree_get(const struct
 	return rbe;
 }
 
+static int nft_rbtree_gc_elem(const struct nft_set *__set,
+			      struct nft_rbtree *priv,
+			      struct nft_rbtree_elem *rbe)
+{
+	struct nft_set *set = (struct nft_set *)__set;
+	struct rb_node *prev = rb_prev(&rbe->node);
+	struct nft_rbtree_elem *rbe_prev;
+	struct nft_set_gc_batch *gcb;
+
+	gcb = nft_set_gc_batch_check(set, NULL, GFP_ATOMIC);
+	if (!gcb)
+		return -ENOMEM;
+
+	/* search for expired end interval coming before this element. */
+	do {
+		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
+		if (nft_rbtree_interval_end(rbe_prev))
+			break;
+
+		prev = rb_prev(prev);
+	} while (prev != NULL);
+
+	rb_erase(&rbe_prev->node, &priv->root);
+	rb_erase(&rbe->node, &priv->root);
+	atomic_sub(2, &set->nelems);
+
+	nft_set_gc_batch_add(gcb, rbe);
+	nft_set_gc_batch_complete(gcb);
+
+	return 0;
+}
+
+static bool nft_rbtree_update_first(const struct nft_set *set,
+				    struct nft_rbtree_elem *rbe,
+				    struct rb_node *first)
+{
+	struct nft_rbtree_elem *first_elem;
+
+	first_elem = rb_entry(first, struct nft_rbtree_elem, node);
+	/* this element is closest to where the new element is to be inserted:
+	 * update the first element for the node list path.
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
 {
+	struct nft_rbtree_elem *rbe, *rbe_le = NULL, *rbe_ge = NULL;
+	struct rb_node *node, *parent, **p, *first = NULL;
 	struct nft_rbtree *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_next(net);
-	struct nft_rbtree_elem *rbe;
-	struct rb_node *parent, **p;
-	int d;
+	int d, err;
 
+	/* Descend the tree to search for an existing element greater than the
+	 * key value to insert that is greater than the new element. This is the
+	 * first element to walk the ordered elements to find possible overlap.
+	 */
 	parent = NULL;
 	p = &priv->root.rb_node;
 	while (*p != NULL) {
 		parent = *p;
 		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
-		d = memcmp(nft_set_ext_key(&rbe->ext),
-			   nft_set_ext_key(&new->ext),
-			   set->klen);
-		if (d < 0)
+		d = nft_rbtree_cmp(set, rbe, new);
+
+		if (d < 0) {
 			p = &parent->rb_left;
-		else if (d > 0)
+		} else if (d > 0) {
+			if (!first ||
+			    nft_rbtree_update_first(set, rbe, first))
+				first = &rbe->node;
+
 			p = &parent->rb_right;
-		else {
-			if (nft_rbtree_interval_end(rbe) &&
-			    nft_rbtree_interval_start(new)) {
+		} else {
+			if (nft_rbtree_interval_end(rbe))
 				p = &parent->rb_left;
-			} else if (nft_rbtree_interval_start(rbe) &&
-				   nft_rbtree_interval_end(new)) {
+			else
 				p = &parent->rb_right;
-			} else if (nft_set_elem_active(&rbe->ext, genmask)) {
-				*ext = &rbe->ext;
-				return -EEXIST;
-			} else {
-				p = &parent->rb_left;
+		}
+	}
+
+	if (!first)
+		first = rb_first(&priv->root);
+
+	/* Detect overlap by going through the list of valid tree nodes.
+	 * Values stored in the tree are in reversed order, starting from
+	 * highest to lowest value.
+	 */
+	for (node = first; node != NULL; node = rb_next(node)) {
+		rbe = rb_entry(node, struct nft_rbtree_elem, node);
+
+		if (!nft_set_elem_active(&rbe->ext, genmask))
+			continue;
+
+		/* perform garbage collection to avoid bogus overlap reports. */
+		if (nft_set_elem_expired(&rbe->ext)) {
+			err = nft_rbtree_gc_elem(set, priv, rbe);
+			if (err < 0)
+				return err;
+
+			continue;
+		}
+
+		d = nft_rbtree_cmp(set, rbe, new);
+		if (d == 0) {
+			/* Matching end element: no need to look for an
+			 * overlapping greater or equal element.
+			 */
+			if (nft_rbtree_interval_end(rbe)) {
+				rbe_le = rbe;
+				break;
+			}
+
+			/* first element that is greater or equal to key value. */
+			if (!rbe_ge) {
+				rbe_ge = rbe;
+				continue;
+			}
+
+			/* this is a closer more or equal element, update it. */
+			if (nft_rbtree_cmp(set, rbe_ge, new) != 0) {
+				rbe_ge = rbe;
+				continue;
 			}
+
+			/* element is equal to key value, make sure flags are
+			 * the same, an existing more or equal start element
+			 * must not be replaced by more or equal end element.
+			 */
+			if ((nft_rbtree_interval_start(new) &&
+			     nft_rbtree_interval_start(rbe_ge)) ||
+			    (nft_rbtree_interval_end(new) &&
+			     nft_rbtree_interval_end(rbe_ge))) {
+				rbe_ge = rbe;
+				continue;
+			}
+		} else if (d > 0) {
+			/* annotate element greater than the new element. */
+			rbe_ge = rbe;
+			continue;
+		} else if (d < 0) {
+			/* annotate element less than the new element. */
+			rbe_le = rbe;
+			break;
 		}
 	}
+
+	/* - new start element matching existing start element: full overlap
+	 *   reported as -EEXIST, cleared by caller if NLM_F_EXCL is not given.
+	 */
+	if (rbe_ge && !nft_rbtree_cmp(set, new, rbe_ge) &&
+	    nft_rbtree_interval_start(rbe_ge) == nft_rbtree_interval_start(new)) {
+		*ext = &rbe_ge->ext;
+		return -EEXIST;
+	}
+
+	/* - new end element matching existing end element: full overlap
+	 *   reported as -EEXIST, cleared by caller if NLM_F_EXCL is not given.
+	 */
+	if (rbe_le && !nft_rbtree_cmp(set, new, rbe_le) &&
+	    nft_rbtree_interval_end(rbe_le) == nft_rbtree_interval_end(new)) {
+		*ext = &rbe_le->ext;
+		return -EEXIST;
+	}
+
+	/* - new start element with existing closest, less or equal key value
+	 *   being a start element: partial overlap, reported as -ENOTEMPTY.
+	 *   Anonymous sets allow for two consecutive start element since they
+	 *   are constant, skip them to avoid bogus overlap reports.
+	 */
+	if (!nft_set_is_anonymous(set) && rbe_le &&
+	    nft_rbtree_interval_start(rbe_le) && nft_rbtree_interval_start(new))
+		return -ENOTEMPTY;
+
+	/* - new end element with existing closest, less or equal key value
+	 *   being a end element: partial overlap, reported as -ENOTEMPTY.
+	 */
+	if (rbe_le &&
+	    nft_rbtree_interval_end(rbe_le) && nft_rbtree_interval_end(new))
+		return -ENOTEMPTY;
+
+	/* - new end element with existing closest, greater or equal key value
+	 *   being an end element: partial overlap, reported as -ENOTEMPTY
+	 */
+	if (rbe_ge &&
+	    nft_rbtree_interval_end(rbe_ge) && nft_rbtree_interval_end(new))
+		return -ENOTEMPTY;
+
+	/* Accepted element: pick insertion point depending on key value */
+	parent = NULL;
+	p = &priv->root.rb_node;
+	while (*p != NULL) {
+		parent = *p;
+		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
+		d = nft_rbtree_cmp(set, rbe, new);
+
+		if (d < 0)
+			p = &parent->rb_left;
+		else if (d > 0)
+			p = &parent->rb_right;
+		else if (nft_rbtree_interval_end(rbe))
+			p = &parent->rb_left;
+		else
+			p = &parent->rb_right;
+	}
+
 	rb_link_node_rcu(&new->node, parent, p);
 	rb_insert_color(&new->node, &priv->root);
 	return 0;


