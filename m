Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFF41535D4;
	Sun, 12 May 2024 16:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715530495; cv=none; b=dYm6438v7xSS1/QO7lhnrFSh8TUT5RFkUqXm2O/1Eq+69iZYcW1VE+00vL4l9AwUU3zAvaKY2HdOlN+cqWbtbK7rGEAnq18zHXblzqrFEzw+WWALdFXivpLkAj0y4lNDLS9mlRdXeU75LL10eQJVY1zC727UM9N8xDBjMeFs4Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715530495; c=relaxed/simple;
	bh=tWIf/Upj3uqXzwGxFQLij2KrsaWB4w2LS8X+fPe+028=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BkPmgIApSIMz6V/0xgkG04F3sZrtJMiHzR1Mdx43iEhghGhAg5W9/GSEhpgbKHhKl8A5natwSgKEnc8zOFpaMDeL11/q/92WJnwYRaKiNuiq11ffq1Xp5/JfRGQlyWCwr/w9zEuuTnHdFXYjsZYbXy7ozOd+bEoi0wbgBCTUSAo=
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
Subject: [PATCH net-next 15/17] netfilter: nft_set_pipapo: remove dirty flag
Date: Sun, 12 May 2024 18:14:34 +0200
Message-Id: <20240512161436.168973-16-pablo@netfilter.org>
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

After previous change:
 ->clone exists: ->dirty is always true
 ->clone == NULL ->dirty is always false

So remove this flag.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 25 -------------------------
 net/netfilter/nft_set_pipapo.h |  2 --
 2 files changed, 27 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index dd9696120ea4..15a236bebb46 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1299,7 +1299,6 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
 	const u8 *start = (const u8 *)elem->key.val.data, *end;
 	struct nft_pipapo_match *m = pipapo_maybe_clone(set);
-	struct nft_pipapo *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_next(net);
 	struct nft_pipapo_elem *e, *dup;
 	u64 tstamp = nft_net_tstamp(net);
@@ -1370,8 +1369,6 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	}
 
 	/* Insert */
-	priv->dirty = true;
-
 	bsize_max = m->bsize_max;
 
 	nft_pipapo_for_each_field(f, i, m) {
@@ -1736,8 +1733,6 @@ static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
 		 * NFT_SET_ELEM_DEAD_BIT.
 		 */
 		if (__nft_set_elem_expired(&e->ext, tstamp)) {
-			priv->dirty = true;
-
 			gc = nft_trans_gc_queue_sync(gc, GFP_KERNEL);
 			if (!gc)
 				return;
@@ -1823,13 +1818,9 @@ static void nft_pipapo_commit(struct nft_set *set)
 	if (time_after_eq(jiffies, priv->last_gc + nft_set_gc_interval(set)))
 		pipapo_gc(set, priv->clone);
 
-	if (!priv->dirty)
-		return;
-
 	old = rcu_replace_pointer(priv->match, priv->clone,
 				  nft_pipapo_transaction_mutex_held(set));
 	priv->clone = NULL;
-	priv->dirty = false;
 
 	if (old)
 		call_rcu(&old->rcu, pipapo_reclaim_match);
@@ -1839,12 +1830,8 @@ static void nft_pipapo_abort(const struct nft_set *set)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
 
-	if (!priv->dirty)
-		return;
-
 	if (!priv->clone)
 		return;
-	priv->dirty = false;
 	pipapo_free_match(priv->clone);
 	priv->clone = NULL;
 }
@@ -2098,7 +2085,6 @@ static void nft_pipapo_remove(const struct net *net, const struct nft_set *set,
 			match_end += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
 
 			if (last && f->mt[rulemap[i].to].e == e) {
-				priv->dirty = true;
 				pipapo_drop(m, rulemap);
 				return;
 			}
@@ -2295,21 +2281,10 @@ static int nft_pipapo_init(const struct nft_set *set,
 		f->mt = NULL;
 	}
 
-	/* Create an initial clone of matching data for next insertion */
-	priv->clone = pipapo_clone(m);
-	if (!priv->clone) {
-		err = -ENOMEM;
-		goto out_free;
-	}
-
-	priv->dirty = false;
-
 	rcu_assign_pointer(priv->match, m);
 
 	return 0;
 
-out_free:
-	free_percpu(m->scratch);
 out_scratch:
 	kfree(m);
 
diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
index 24cd1ff73f98..0d2e40e10f7f 100644
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -155,14 +155,12 @@ struct nft_pipapo_match {
  * @match:	Currently in-use matching data
  * @clone:	Copy where pending insertions and deletions are kept
  * @width:	Total bytes to be matched for one packet, including padding
- * @dirty:	Working copy has pending insertions or deletions
  * @last_gc:	Timestamp of last garbage collection run, jiffies
  */
 struct nft_pipapo {
 	struct nft_pipapo_match __rcu *match;
 	struct nft_pipapo_match *clone;
 	int width;
-	bool dirty;
 	unsigned long last_gc;
 };
 
-- 
2.30.2

