Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C836FE2A
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2024 08:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712133777; cv=none; b=cMFFMbYr7ulw0XDekHJ4WAjjFccBnI8t5F7EvqNfMg2FwKbvFQ5/nXbxbdq1tVWnz1NbhmQflY9OrkBK1E+aDCl9X+FYCMsF/A7N+ACEfwHzcWmn2NykPeLB2YVBy08oqrsBm8LA2/0XZHqwvSEDVR5/a6C/b56UjNsaEQ/5fgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712133777; c=relaxed/simple;
	bh=P7q5Y+lMgAhdGfVwBKH9cVCuvdxoL/RuvHCWpdH/tag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AH5XxpwPnd/kl6GEtcSdBFBhaihxlYVlS+6YFGsu9j7uNSZvjTPCIYRzBdaUlFBWt1hwqUdnH27PoUl64JxxS+f9kbykgEdRDdl90IbBiV9ZnRUmM8xFWxBXzwGH0fpUZOEcdc6Di0qZSp5DoEtsGlxn+7ux2Eo/8yPHh5t+4QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rrwCt-0005zv-7s; Wed, 03 Apr 2024 10:42:55 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 9/9] netfilter: nft_set_pipapo: remove dirty flag
Date: Wed,  3 Apr 2024 10:41:09 +0200
Message-ID: <20240403084113.18823-10-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240403084113.18823-1-fw@strlen.de>
References: <20240403084113.18823-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Its not needed anymore, after previous changes priv->clone != NULL
during commit means priv->match needs to be updated with the clone.

On abort, priv->clone needs to be discarded, it doesn't contain
anything new anymore.

Note that its now possible to resurrect
ebd032fa8818 ("netfilter: nf_tables: do not remove elements if set backend implements .abort")
to speed up the abort path, removal from pipapo sets is slow.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c | 25 -------------------------
 net/netfilter/nft_set_pipapo.h |  2 --
 2 files changed, 27 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index eef6a978561f..bb9a03426696 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1296,7 +1296,6 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
 	const u8 *start = (const u8 *)elem->key.val.data, *end;
 	struct nft_pipapo_match *m = pipapo_maybe_clone(set);
-	struct nft_pipapo *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_next(net);
 	struct nft_pipapo_elem *e, *dup;
 	u64 tstamp = nft_net_tstamp(net);
@@ -1367,8 +1366,6 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	}
 
 	/* Insert */
-	priv->dirty = true;
-
 	bsize_max = m->bsize_max;
 
 	nft_pipapo_for_each_field(f, i, m) {
@@ -1733,8 +1730,6 @@ static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
 		 * NFT_SET_ELEM_DEAD_BIT.
 		 */
 		if (__nft_set_elem_expired(&e->ext, tstamp)) {
-			priv->dirty = true;
-
 			gc = nft_trans_gc_queue_sync(gc, GFP_KERNEL);
 			if (!gc)
 				return;
@@ -1820,13 +1815,9 @@ static void nft_pipapo_commit(struct nft_set *set)
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
@@ -1836,12 +1827,8 @@ static void nft_pipapo_abort(const struct nft_set *set)
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
@@ -2094,7 +2081,6 @@ static void nft_pipapo_remove(const struct net *net, const struct nft_set *set,
 		}
 
 		if (i == m->field_count) {
-			priv->dirty = true;
 			pipapo_drop(m, rulemap);
 			return;
 		}
@@ -2299,21 +2285,10 @@ static int nft_pipapo_init(const struct nft_set *set,
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

