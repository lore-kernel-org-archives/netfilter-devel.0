Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870FA12BE8C
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Apr 2024 12:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714046972; cv=none; b=k53XyV3YX8zv5E7Clnra6cCV2DF1+1x/uXI6LggFmLNxAbwt/bvEG3XBaumIsSsKJGTCi4dRIfETFbo/iGj+JzmxL3qMcW4rHH3ri0beXgriKIlcxGsmNIYMzHYl+IS9cuttWKCAA/Ych73gw0mEyeLEyI3eG3sd8IhXuABKNrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714046972; c=relaxed/simple;
	bh=2dS1643nBrwl88lr0C0EDKpfe9s0a00uim2W4c/rYBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RClGcd65hNnEtd/W4+0THfoZxL0slVo6fwchbSo8uZrCkclbDluapDgjxNeabchBmopBO0mcqV3i9P0gbaZml1k72x30JNVneoAabDmq5ikMO0DXDpxGT6AVXF3LcNvJIK5orgZuGuu+Z9m3cwTs7dj969j8OQo4jrvhkcoHD+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rzxus-0007qo-8y; Thu, 25 Apr 2024 14:09:30 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 8/8] netfilter: nft_set_pipapo: remove dirty flag
Date: Thu, 25 Apr 2024 14:06:47 +0200
Message-ID: <20240425120651.16326-9-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240425120651.16326-1-fw@strlen.de>
References: <20240425120651.16326-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After previous change:
 ->clone exists: ->dirty is always true
 ->clone == NULL ->dirty is always false

So remove this flag.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/netfilter/nft_set_pipapo.c | 25 -------------------------
 net/netfilter/nft_set_pipapo.h |  2 --
 2 files changed, 27 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 2b1c91e56ca1..be5c554ca4d3 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1302,7 +1302,6 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
 	const u8 *start = (const u8 *)elem->key.val.data, *end;
 	struct nft_pipapo_match *m = pipapo_maybe_clone(set);
-	struct nft_pipapo *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_next(net);
 	struct nft_pipapo_elem *e, *dup;
 	u64 tstamp = nft_net_tstamp(net);
@@ -1373,8 +1372,6 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	}
 
 	/* Insert */
-	priv->dirty = true;
-
 	bsize_max = m->bsize_max;
 
 	nft_pipapo_for_each_field(f, i, m) {
@@ -1739,8 +1736,6 @@ static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
 		 * NFT_SET_ELEM_DEAD_BIT.
 		 */
 		if (__nft_set_elem_expired(&e->ext, tstamp)) {
-			priv->dirty = true;
-
 			gc = nft_trans_gc_queue_sync(gc, GFP_KERNEL);
 			if (!gc)
 				return;
@@ -1826,13 +1821,9 @@ static void nft_pipapo_commit(struct nft_set *set)
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
@@ -1842,12 +1833,8 @@ static void nft_pipapo_abort(const struct nft_set *set)
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
@@ -2101,7 +2088,6 @@ static void nft_pipapo_remove(const struct net *net, const struct nft_set *set,
 			match_end += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
 
 			if (last && f->mt[rulemap[i].to].e == e) {
-				priv->dirty = true;
 				pipapo_drop(m, rulemap);
 				return;
 			}
@@ -2298,21 +2284,10 @@ static int nft_pipapo_init(const struct nft_set *set,
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
2.43.2

