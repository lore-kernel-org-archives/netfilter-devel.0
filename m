Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377AC31326B
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Feb 2026 21:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770067605; cv=none; b=Bav+hQDihbHmHBiZ4FUzZn6J4A+JTtj4WAeOFHdLow2iI//nYMwLocRAUXA8K3TnCvIb5r/87eCqJbkwMDVhq/hcyPTqxzu8SlfuzQ1HaT3aoB8tviV0kJ/h2VOFkN6WcMBDZfnMBlj4xizxmtdQ6ScQ/YU3/T7EoDW56192vSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770067605; c=relaxed/simple;
	bh=awgcyRbmsGfzYh/krhtWY+Fx7U4uICouupWHB1mIpJ0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nz2xVYul0vRyITPZW7aDdVl7jtRqHF155AsEB+Lfp6nemAROzN3kpsGS9BsGhFRUee3Hk0JvHZ0Lgvi5NGoFTXE7GWp8sTp+bi4dQt6cxxyHH8Mu24I9gCnawkZldmw3VswTucXfALmjpgSj1ItgoUeiu4DJ6XgtNhk2j8pGeAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Wipgt7E3; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Wipgt7E3"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 15E23605C1
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Feb 2026 22:26:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1770067595;
	bh=e3OAlFhGSueFMALVMrkka4dNUR+8S8IvAgtKo2Jqcvk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Wipgt7E3mV53PhrI+OyS0gOF5Ax2mVLa8lUijPpmfBSnRSZi4qAQt8Yg6waFvKRAS
	 g+SFuFLJPCq70XvJCKGMzSXPv+YFqh1iSP+r/1b6k/R+ZNtmO3o44xUr3wGQtWS19R
	 rfUf9pnQpeB+WwzJWpxSwVCCkA4//Ol0gt6advMvcj0vPiysnkNqIxRnDyUy1TRbf2
	 ljS2UwlUr9JVOEDaDuOP4Bye0YJ38qcnD1cQ0+qHd2kfORqxUDJMW7s3AG8gR9g4El
	 1INRUxKj4gHymAiESMvYNNSFv2plLDQgdVXbXb2SWM1caBrnEYDjfDlBJWfMHgvYLQ
	 Rd55DA5yT4l2w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 3/4] netfilter: nft_set_rbtree: validate element belonging to interval
Date: Mon,  2 Feb 2026 22:26:26 +0100
Message-ID: <20260202212627.946625-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202212627.946625-1-pablo@netfilter.org>
References: <20260202212627.946625-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The existing partial overlap detection does not check if the elements
belong to the interval, eg.

  add element inet x y { 1.1.1.1-2.2.2.2, 4.4.4.4-5.5.5.5 }
  add element inet x y { 1.1.1.1-5.5.5.5 } => this should fail: ENOENT

Similar situation occurs with deletions:

  add element inet x y { 1.1.1.1-2.2.2.2, 4.4.4.4-5.5.5.5}
  delete element inet x y { 1.1.1.1-5.5.5.5 } => this should fail: ENOENT

This currently works via mitigation by nft in userspace, which is
performing the overlap detection before sending the elements to the
kernel. This requires a previous netlink dump of the set content which
slows down incremental updates on interval sets, because a netlink set
content dump is needed.

This patch extends the existing overlap detection to track the most
recent start element that already exists. The pointer to the existing
start element is stored as a cookie (no pointer dereference is ever
possible). If the end element is added and it already exists, then
check that the existing end element is adjacent to the already existing
start element. Similar logic applies to element deactivation.

This patch also annotates the timestamp to identify if start cookie
comes from an older batch, in such case reset it. Otherwise, a failing
create element command leaves the start cookie in place, resulting in
bogus error reporting.

There is still a few more corner cases of overlap detection related to
the open interval that are addressed in follow up patches.

This is address an early design mistake where an interval is expressed
as two elements, using the NFT_SET_ELEM_INTERVAL_END flag, instead of
the more recent NFTA_SET_ELEM_KEY_END attribute that pipapo already
uses.

Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: Annotate timestamp to reset start_rbe_cookie tracking between batches.

 net/netfilter/nft_set_rbtree.c | 147 ++++++++++++++++++++++++++++++++-
 1 file changed, 143 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 0581184cacf9..65319a2ed898 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -33,7 +33,9 @@ struct nft_rbtree {
 	rwlock_t		lock;
 	struct nft_array __rcu	*array;
 	struct nft_array	*array_next;
+	unsigned long		start_rbe_cookie;
 	unsigned long		last_gc;
+	u64			last_tstamp;
 };
 
 struct nft_rbtree_elem {
@@ -278,16 +280,85 @@ static struct nft_rbtree_elem *nft_rbtree_prev_active(struct nft_rbtree_elem *rb
 	return rb_entry(node, struct nft_rbtree_elem, node);
 }
 
+static struct nft_rbtree_elem *
+__nft_rbtree_next_active(struct rb_node *node, u8 genmask)
+{
+	struct nft_rbtree_elem *next_rbe;
+
+	while (node) {
+		next_rbe = rb_entry(node, struct nft_rbtree_elem, node);
+		if (!nft_set_elem_active(&next_rbe->ext, genmask)) {
+			node = rb_next(node);
+			continue;
+		}
+
+		return next_rbe;
+	}
+
+	return NULL;
+}
+
+static struct nft_rbtree_elem *
+nft_rbtree_next_active(struct nft_rbtree_elem *rbe, u8 genmask)
+{
+	return __nft_rbtree_next_active(rb_next(&rbe->node), genmask);
+}
+
+static void nft_rbtree_maybe_reset_start_cookie(struct nft_rbtree *priv,
+						u64 tstamp)
+{
+	if (priv->last_tstamp != tstamp) {
+		priv->start_rbe_cookie = 0;
+		priv->last_tstamp = tstamp;
+	}
+}
+
+static void nft_rbtree_set_start_cookie(struct nft_rbtree *priv,
+					const struct nft_rbtree_elem *rbe)
+{
+	priv->start_rbe_cookie = (unsigned long)rbe;
+}
+
+static bool nft_rbtree_cmp_start_cookie(struct nft_rbtree *priv,
+					const struct nft_rbtree_elem *rbe)
+{
+	return priv->start_rbe_cookie == (unsigned long)rbe;
+}
+
+static bool nft_rbtree_insert_same_interval(const struct net *net,
+					    struct nft_rbtree *priv,
+					    struct nft_rbtree_elem *rbe)
+{
+	u8 genmask = nft_genmask_next(net);
+	struct nft_rbtree_elem *next_rbe;
+
+	if (!priv->start_rbe_cookie)
+		return true;
+
+	next_rbe = nft_rbtree_next_active(rbe, genmask);
+	if (next_rbe) {
+		/* Closest start element differs from last element added. */
+		if (nft_rbtree_interval_start(next_rbe) &&
+		    nft_rbtree_cmp_start_cookie(priv, next_rbe)) {
+			priv->start_rbe_cookie = 0;
+			return true;
+		}
+	}
+
+	priv->start_rbe_cookie = 0;
+
+	return false;
+}
+
 static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			       struct nft_rbtree_elem *new,
-			       struct nft_elem_priv **elem_priv)
+			       struct nft_elem_priv **elem_priv, u64 tstamp)
 {
 	struct nft_rbtree_elem *rbe, *rbe_le = NULL, *rbe_ge = NULL, *rbe_prev;
 	struct rb_node *node, *next, *parent, **p, *first = NULL;
 	struct nft_rbtree *priv = nft_set_priv(set);
 	u8 cur_genmask = nft_genmask_cur(net);
 	u8 genmask = nft_genmask_next(net);
-	u64 tstamp = nft_net_tstamp(net);
 	int d;
 
 	/* Descend the tree to search for an existing element greater than the
@@ -393,12 +464,18 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		}
 	}
 
+	if (nft_rbtree_interval_null(set, new))
+		priv->start_rbe_cookie = 0;
+	else if (nft_rbtree_interval_start(new) && priv->start_rbe_cookie)
+		priv->start_rbe_cookie = 0;
+
 	/* - new start element matching existing start element: full overlap
 	 *   reported as -EEXIST, cleared by caller if NLM_F_EXCL is not given.
 	 */
 	if (rbe_ge && !nft_rbtree_cmp(set, new, rbe_ge) &&
 	    nft_rbtree_interval_start(rbe_ge) == nft_rbtree_interval_start(new)) {
 		*elem_priv = &rbe_ge->priv;
+		nft_rbtree_set_start_cookie(priv, rbe_ge);
 		return -EEXIST;
 	}
 
@@ -414,6 +491,11 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			return -ECANCELED;
 
 		*elem_priv = &rbe_le->priv;
+
+		/* - start and end element belong to the same interval. */
+		if (!nft_rbtree_insert_same_interval(net, priv, rbe_le))
+			return -ENOTEMPTY;
+
 		return -EEXIST;
 	}
 
@@ -558,8 +640,11 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 {
 	struct nft_rbtree_elem *rbe = nft_elem_priv_cast(elem->priv);
 	struct nft_rbtree *priv = nft_set_priv(set);
+	u64 tstamp = nft_net_tstamp(net);
 	int err;
 
+	nft_rbtree_maybe_reset_start_cookie(priv, tstamp);
+
 	if (nft_array_may_resize(set) < 0)
 		return -ENOMEM;
 
@@ -570,7 +655,7 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		cond_resched();
 
 		write_lock_bh(&priv->lock);
-		err = __nft_rbtree_insert(net, set, rbe, elem_priv);
+		err = __nft_rbtree_insert(net, set, rbe, elem_priv, tstamp);
 		write_unlock_bh(&priv->lock);
 	} while (err == -EAGAIN);
 
@@ -603,6 +688,48 @@ static void nft_rbtree_activate(const struct net *net,
 	nft_clear(net, &rbe->ext);
 }
 
+static struct nft_rbtree_elem *
+nft_rbtree_next_inactive(struct nft_rbtree_elem *rbe, u8 genmask)
+{
+	struct nft_rbtree_elem *next_rbe;
+	struct rb_node *node;
+
+	node = rb_next(&rbe->node);
+	if (node) {
+		next_rbe = rb_entry(node, struct nft_rbtree_elem, node);
+		if (nft_rbtree_interval_start(next_rbe) &&
+		    !nft_set_elem_active(&next_rbe->ext, genmask))
+			return next_rbe;
+	}
+
+	return NULL;
+}
+
+static bool nft_rbtree_deactivate_same_interval(const struct net *net,
+						struct nft_rbtree *priv,
+						struct nft_rbtree_elem *rbe)
+{
+	u8 genmask = nft_genmask_next(net);
+	struct nft_rbtree_elem *next_rbe;
+
+	if (!priv->start_rbe_cookie)
+		return true;
+
+	next_rbe = nft_rbtree_next_inactive(rbe, genmask);
+	if (next_rbe) {
+		/* Closest start element differs from last element added. */
+		if (nft_rbtree_interval_start(next_rbe) &&
+		    nft_rbtree_cmp_start_cookie(priv, next_rbe)) {
+			priv->start_rbe_cookie = 0;
+			return true;
+		}
+	}
+
+	priv->start_rbe_cookie = 0;
+
+	return false;
+}
+
 static void nft_rbtree_flush(const struct net *net,
 			     const struct nft_set *set,
 			     struct nft_elem_priv *elem_priv)
@@ -617,12 +744,18 @@ nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
 		      const struct nft_set_elem *elem)
 {
 	struct nft_rbtree_elem *rbe, *this = nft_elem_priv_cast(elem->priv);
-	const struct nft_rbtree *priv = nft_set_priv(set);
+	struct nft_rbtree *priv = nft_set_priv(set);
 	const struct rb_node *parent = priv->root.rb_node;
 	u8 genmask = nft_genmask_next(net);
 	u64 tstamp = nft_net_tstamp(net);
 	int d;
 
+	nft_rbtree_maybe_reset_start_cookie(priv, tstamp);
+
+	if (nft_rbtree_interval_start(this) ||
+	    nft_rbtree_interval_null(set, this))
+		priv->start_rbe_cookie = 0;
+
 	if (nft_array_may_resize(set) < 0)
 		return NULL;
 
@@ -650,6 +783,12 @@ nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
 				parent = parent->rb_left;
 				continue;
 			}
+
+			if (nft_rbtree_interval_start(rbe))
+				nft_rbtree_set_start_cookie(priv, rbe);
+			else if (!nft_rbtree_deactivate_same_interval(net, priv, rbe))
+				return NULL;
+
 			nft_rbtree_flush(net, set, &rbe->priv);
 			return &rbe->priv;
 		}
-- 
2.47.3

