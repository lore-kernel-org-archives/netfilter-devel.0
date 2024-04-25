Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC1384E13
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Apr 2024 12:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714046969; cv=none; b=UH4aBwpGSyx4ppQFtGmTSZUZ7RA+ayTvt2dZE39VpeZIFxPHQO77tFbZ7d8G1jm4McCjWC7nRNGVPgbGtsvxCQ3prNja64mMCugf95caKFLxMBYxLlbEp6soEKbXV2/ZEnaiIi+dTbxGr9m85dsNrU5bijpyGkBw7ex1VIVV4a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714046969; c=relaxed/simple;
	bh=jfp4CMFD5+GM8LtlYVc157NH88XOzLzUlA5lpCvw2Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WL51eNvIbwv6SsIfgHOsUZVIkcTM8OR0XtbmtUFz82oG65Qx1i/s9FWAFQ0Irwc8Y+HA04BYsVofnhkclth+jXQ7mgCzQhY44eFOYZfIpmi1Ilo26pblPAq6KljHz7K1ouVMhkqWDO+WMRNtsMO+IOjU3d5yg7Bjo9YyfVhpnAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rzxuo-0007qW-5N; Thu, 25 Apr 2024 14:09:26 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 7/8] netfilter: nft_set_pipapo: move cloning of match info to insert/removal path
Date: Thu, 25 Apr 2024 14:06:46 +0200
Message-ID: <20240425120651.16326-8-fw@strlen.de>
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
---
 net/netfilter/nft_set_pipapo.c | 73 ++++++++++++++++++++++++----------
 1 file changed, 52 insertions(+), 21 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 9c8da9a0861d..2b1c91e56ca1 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -615,6 +615,9 @@ nft_pipapo_get(const struct net *net, const struct nft_set *set,
 	struct nft_pipapo_match *m = priv->clone;
 	struct nft_pipapo_elem *e;
 
+	if (!m)
+		m = rcu_dereference(priv->match);
+
 	e = pipapo_get(net, set, m, (const u8 *)elem->key.val.data,
 		       nft_genmask_cur(net), get_jiffies_64(),
 		       GFP_ATOMIC);
@@ -1259,6 +1262,29 @@ static bool nft_pipapo_transaction_mutex_held(const struct nft_set *set)
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
@@ -1275,8 +1301,8 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
 	union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
 	const u8 *start = (const u8 *)elem->key.val.data, *end;
+	struct nft_pipapo_match *m = pipapo_maybe_clone(set);
 	struct nft_pipapo *priv = nft_set_priv(set);
-	struct nft_pipapo_match *m = priv->clone;
 	u8 genmask = nft_genmask_next(net);
 	struct nft_pipapo_elem *e, *dup;
 	u64 tstamp = nft_net_tstamp(net);
@@ -1284,6 +1310,9 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	const u8 *start_p, *end_p;
 	int i, bsize_max, err = 0;
 
+	if (!m)
+		return -ENOMEM;
+
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END))
 		end = (const u8 *)nft_set_ext_key_end(ext)->data;
 	else
@@ -1789,7 +1818,10 @@ static void pipapo_reclaim_match(struct rcu_head *rcu)
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
@@ -1797,38 +1829,27 @@ static void nft_pipapo_commit(struct nft_set *set)
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
@@ -1863,10 +1884,15 @@ static struct nft_elem_priv *
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
@@ -2145,7 +2171,12 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
 
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
2.43.2

