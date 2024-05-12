Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0A014F605;
	Sun, 12 May 2024 16:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715530496; cv=none; b=cXtreGHJC/G8qLmP8f3RZ3jS55JviXPNqkIk8gh8RmzsqX20Kq3DOEPqrOoQzYiplID8Qk1ztXx9KZY/KBJiLBfcM+qriQB2KHQw//43CG7+5QacY1JfCO2n8RCLdUoncLrpmP00VwCmuQNcQekAMTx2nCFsrMIivKyu9Ys4L5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715530496; c=relaxed/simple;
	bh=Xkm+O0jb6ShmoHvQHcCl19Y/Fs/pzdYrjMrLen/n9Uo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KJZyk+QuWFpmXPiGpda7j9/6+YN0XcTkvrcRpM143Quh/sf8Ks+EYZzRkkUlouvDfMz7w0GptrQ+WZG0ec2kF5WObdBOK4KXh+3omwCxR9dteocT9WvuP0nSE7oBWzRQNlfynXhrZH1M0O9K24sk8vPxL3hLTuHVEeXxXyuMxEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 14/17] netfilter: nft_set_pipapo: move cloning of match info to insert/removal path
Date: Sun, 12 May 2024 18:14:33 +0200
Message-Id: <20240512161436.168973-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240512161436.168973-1-pablo@netfilter.org>
References: <20240512161436.168973-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

This set type keeps two copies of the sets' content,
   priv->match (live version, used to match from packet path)
   priv->clone (work-in-progress version of the 'future' priv->match).

All additions and removals are done on priv->clone.  When transaction
completes, priv->clone becomes priv->match and a new clone is allocated
for use by next transaction.

Problem is that the cloning requires GFP_KERNEL allocations but we
cannot fail at either commit or abort time.

This patch defers the clone until we get an insertion or removal
request.  This allows us to handle OOM situations correctly.

This also allows to remove ->dirty in a followup change:

If ->clone exists, ->dirty is always true
If ->clone is NULL, ->dirty is always false, no elements were added
or removed (except catchall elements which are external to the specific
set backend).

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 70 ++++++++++++++++++++++++----------
 1 file changed, 49 insertions(+), 21 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 6657aa34f4d7..dd9696120ea4 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1259,6 +1259,29 @@ static bool nft_pipapo_transaction_mutex_held(const struct nft_set *set)
 #endif
 }
 
+static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old);
+
+/**
+ * pipapo_maybe_clone() - Build clone for pending data changes, if not existing
+ * @set:	nftables API set representation
+ *
+ * Return: newly created or existing clone, if any. NULL on allocation failure
+ */
+static struct nft_pipapo_match *pipapo_maybe_clone(const struct nft_set *set)
+{
+	struct nft_pipapo *priv = nft_set_priv(set);
+	struct nft_pipapo_match *m;
+
+	if (priv->clone)
+		return priv->clone;
+
+	m = rcu_dereference_protected(priv->match,
+				      nft_pipapo_transaction_mutex_held(set));
+	priv->clone = pipapo_clone(m);
+
+	return priv->clone;
+}
+
 /**
  * nft_pipapo_insert() - Validate and insert ranged elements
  * @net:	Network namespace
@@ -1275,8 +1298,8 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
 	union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
 	const u8 *start = (const u8 *)elem->key.val.data, *end;
+	struct nft_pipapo_match *m = pipapo_maybe_clone(set);
 	struct nft_pipapo *priv = nft_set_priv(set);
-	struct nft_pipapo_match *m = priv->clone;
 	u8 genmask = nft_genmask_next(net);
 	struct nft_pipapo_elem *e, *dup;
 	u64 tstamp = nft_net_tstamp(net);
@@ -1284,6 +1307,9 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	const u8 *start_p, *end_p;
 	int i, bsize_max, err = 0;
 
+	if (!m)
+		return -ENOMEM;
+
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END))
 		end = (const u8 *)nft_set_ext_key_end(ext)->data;
 	else
@@ -1789,7 +1815,10 @@ static void pipapo_reclaim_match(struct rcu_head *rcu)
 static void nft_pipapo_commit(struct nft_set *set)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
-	struct nft_pipapo_match *new_clone, *old;
+	struct nft_pipapo_match *old;
+
+	if (!priv->clone)
+		return;
 
 	if (time_after_eq(jiffies, priv->last_gc + nft_set_gc_interval(set)))
 		pipapo_gc(set, priv->clone);
@@ -1797,38 +1826,27 @@ static void nft_pipapo_commit(struct nft_set *set)
 	if (!priv->dirty)
 		return;
 
-	new_clone = pipapo_clone(priv->clone);
-	if (!new_clone)
-		return;
-
+	old = rcu_replace_pointer(priv->match, priv->clone,
+				  nft_pipapo_transaction_mutex_held(set));
+	priv->clone = NULL;
 	priv->dirty = false;
 
-	old = rcu_access_pointer(priv->match);
-	rcu_assign_pointer(priv->match, priv->clone);
 	if (old)
 		call_rcu(&old->rcu, pipapo_reclaim_match);
-
-	priv->clone = new_clone;
 }
 
 static void nft_pipapo_abort(const struct nft_set *set)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
-	struct nft_pipapo_match *new_clone, *m;
 
 	if (!priv->dirty)
 		return;
 
-	m = rcu_dereference_protected(priv->match, nft_pipapo_transaction_mutex_held(set));
-
-	new_clone = pipapo_clone(m);
-	if (!new_clone)
+	if (!priv->clone)
 		return;
-
 	priv->dirty = false;
-
 	pipapo_free_match(priv->clone);
-	priv->clone = new_clone;
+	priv->clone = NULL;
 }
 
 /**
@@ -1863,10 +1881,15 @@ static struct nft_elem_priv *
 nft_pipapo_deactivate(const struct net *net, const struct nft_set *set,
 		      const struct nft_set_elem *elem)
 {
-	const struct nft_pipapo *priv = nft_set_priv(set);
-	struct nft_pipapo_match *m = priv->clone;
+	struct nft_pipapo_match *m = pipapo_maybe_clone(set);
 	struct nft_pipapo_elem *e;
 
+	/* removal must occur on priv->clone, if we are low on memory
+	 * we have no choice and must fail the removal request.
+	 */
+	if (!m)
+		return NULL;
+
 	e = pipapo_get(net, set, m, (const u8 *)elem->key.val.data,
 		       nft_genmask_next(net), nft_net_tstamp(net), GFP_KERNEL);
 	if (IS_ERR(e))
@@ -2145,7 +2168,12 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
 
 	switch (iter->type) {
 	case NFT_ITER_UPDATE:
-		m = priv->clone;
+		m = pipapo_maybe_clone(set);
+		if (!m) {
+			iter->err = -ENOMEM;
+			return;
+		}
+
 		nft_pipapo_do_walk(ctx, set, m, iter);
 		break;
 	case NFT_ITER_READ:
-- 
2.30.2

