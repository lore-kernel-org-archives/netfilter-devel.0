Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7577B27FB1F;
	Fri,  6 Feb 2026 15:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770391902; cv=none; b=UwNoNeSsJt6ebJDb6/QzCnTRqbSTu7zBzutMHNJn85Bfc9S3NIkSxIK+sNfLXk8ry8OBSmJodfclwgy4EMziWPlcvNmUKc9IYEmAWTMxK/niZm0Ur8RWk695j6yhMPrlcYcKzKJ6/SQhT5iFd+2odlZviWEoqf+la20FsFOlrUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770391902; c=relaxed/simple;
	bh=/DezHLdAkTTK/1F8bN3tBG5Ix3adh5T1ADtxJuNh8Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C78WfnTS8V2SM3jIRGV+ylukd3lVRMmVd9r/lLaBQlH7QTj0MUrShq8Vp7WuaQ8hYV6z9n34HW6d6rUA0gBoZpm0LB5wgK8Xa9lifl00czCSfZ5DXitSa7hMrBniYRy89mOuZZwe+jl+LaQc5FbwgWIP3gSq88mw7R69IWdMzr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 15D1B60915; Fri, 06 Feb 2026 16:31:41 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH v2 net-next 10/11] netfilter: nft_set_rbtree: validate element belonging to interval
Date: Fri,  6 Feb 2026 16:30:47 +0100
Message-ID: <20260206153048.17570-11-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260206153048.17570-1-fw@strlen.de>
References: <20260206153048.17570-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

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
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_rbtree.c | 147 ++++++++++++++++++++++++++++++++-
 1 file changed, 143 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 14b4256bb00d..a4fb5b517d9d 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -33,8 +33,10 @@ struct nft_rbtree {
 	rwlock_t		lock;
 	struct nft_array __rcu	*array;
 	struct nft_array	*array_next;
+	unsigned long		start_rbe_cookie;
 	unsigned long		last_gc;
 	struct list_head	expired;
+	u64			last_tstamp;
 };
 
 struct nft_rbtree_elem {
@@ -263,16 +265,85 @@ static struct nft_rbtree_elem *nft_rbtree_prev_active(struct nft_rbtree_elem *rb
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
@@ -378,12 +449,18 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
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
 
@@ -399,6 +476,11 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			return -ECANCELED;
 
 		*elem_priv = &rbe_le->priv;
+
+		/* - start and end element belong to the same interval. */
+		if (!nft_rbtree_insert_same_interval(net, priv, rbe_le))
+			return -ENOTEMPTY;
+
 		return -EEXIST;
 	}
 
@@ -543,8 +625,11 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 {
 	struct nft_rbtree_elem *rbe = nft_elem_priv_cast(elem->priv);
 	struct nft_rbtree *priv = nft_set_priv(set);
+	u64 tstamp = nft_net_tstamp(net);
 	int err;
 
+	nft_rbtree_maybe_reset_start_cookie(priv, tstamp);
+
 	if (nft_array_may_resize(set) < 0)
 		return -ENOMEM;
 
@@ -555,7 +640,7 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		cond_resched();
 
 		write_lock_bh(&priv->lock);
-		err = __nft_rbtree_insert(net, set, rbe, elem_priv);
+		err = __nft_rbtree_insert(net, set, rbe, elem_priv, tstamp);
 		write_unlock_bh(&priv->lock);
 	} while (err == -EAGAIN);
 
@@ -588,6 +673,48 @@ static void nft_rbtree_activate(const struct net *net,
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
@@ -602,12 +729,18 @@ nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
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
 
@@ -635,6 +768,12 @@ nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
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
2.52.0

