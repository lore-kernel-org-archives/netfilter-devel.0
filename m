Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF4B2222D7
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Jul 2025 17:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752080745; cv=none; b=b0ku1bJEmRC0D3DCCi+oUH9vrHSlbAXVIYF9PUYstM8wNqYjuCA68rDBoUmLA3jxKgnPxB2zSbBB2TVvPxO5HmXyGjslkPT5Lz+uD4iPPidIPBA7D5/Bc/3KVpDNV4JXJ6GHe7zEYHwHvTSsOriODgQ0bLoGBqv7/j1+rnOMiLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752080745; c=relaxed/simple;
	bh=/gM8fqghao6/V7aF2Hrgd3ljwAe7P+ykdXuy+oTx5OM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D36n26vncAbmxSJpFFf3J/TP6YFDT+tv0VAi0mWFvVA6y0hP0TD9Rv0s0ArYP08J3CEsa/u6hyLlaYT7g5ItZ/IcFUtwYBJBALrrOJKHc8iEhuFWE/lm/r+uAS6y+TCC22nA3fhSHqD3tz9vzHn0yjQq2m+cQVHtqhUDBqvweew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 02241607AC; Wed,  9 Jul 2025 19:05:40 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 3/5] netfilter: nft_set: remove indirection from update API call
Date: Wed,  9 Jul 2025 19:05:14 +0200
Message-ID: <20250709170521.11778-4-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250709170521.11778-1-fw@strlen.de>
References: <20250709170521.11778-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This stems from a time when sets and nft_dynset resided in different kernel
modules.  We can replace this with a direct call.

We could even remove both ->update and ->delete, given its only
supported by rhashtable, but on the off-chance we'll see runtime
add/delete for other types or a new set type keep that as-is for now.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: no changes.

 include/net/netfilter/nf_tables.h      | 4 ----
 include/net/netfilter/nf_tables_core.h | 3 +++
 net/netfilter/nft_dynset.c             | 9 ++++-----
 net/netfilter/nft_set_hash.c           | 4 +---
 net/netfilter/nft_set_pipapo_avx2.c    | 1 -
 5 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 2da886716adc..a4f254e8b3c9 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -464,10 +464,6 @@ struct nft_set_ops {
 						  const u32 *key);
 	const struct nft_set_ext *	(*update)(struct nft_set *set,
 						  const u32 *key,
-						  struct nft_elem_priv *
-							(*new)(struct nft_set *,
-							       const struct nft_expr *,
-							       struct nft_regs *),
 						  const struct nft_expr *expr,
 						  struct nft_regs *regs);
 	bool				(*delete)(const struct nft_set *set,
diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 6a52fb97b844..6c2f483d9828 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -188,4 +188,7 @@ void nft_objref_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		     const struct nft_pktinfo *pkt);
 void nft_objref_map_eval(const struct nft_expr *expr, struct nft_regs *regs,
 			 const struct nft_pktinfo *pkt);
+struct nft_elem_priv *nft_dynset_new(struct nft_set *set,
+				     const struct nft_expr *expr,
+				     struct nft_regs *regs);
 #endif /* _NET_NF_TABLES_CORE_H */
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index e24493d9e776..7807d8129664 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -44,9 +44,9 @@ static int nft_dynset_expr_setup(const struct nft_dynset *priv,
 	return 0;
 }
 
-static struct nft_elem_priv *nft_dynset_new(struct nft_set *set,
-					    const struct nft_expr *expr,
-					    struct nft_regs *regs)
+struct nft_elem_priv *nft_dynset_new(struct nft_set *set,
+				     const struct nft_expr *expr,
+				     struct nft_regs *regs)
 {
 	const struct nft_dynset *priv = nft_expr_priv(expr);
 	struct nft_set_ext *ext;
@@ -91,8 +91,7 @@ void nft_dynset_eval(const struct nft_expr *expr,
 		return;
 	}
 
-	ext = set->ops->update(set, &regs->data[priv->sreg_key], nft_dynset_new,
-			     expr, regs);
+	ext = set->ops->update(set, &regs->data[priv->sreg_key], expr, regs);
 	if (ext) {
 		if (priv->op == NFT_DYNSET_OP_UPDATE &&
 		    nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT) &&
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 9903c737c9f0..266d0c637225 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -123,8 +123,6 @@ nft_rhash_get(const struct net *net, const struct nft_set *set,
 
 static const struct nft_set_ext *
 nft_rhash_update(struct nft_set *set, const u32 *key,
-		 struct nft_elem_priv *(*new)(struct nft_set *, const struct nft_expr *,
-		 struct nft_regs *regs),
 		 const struct nft_expr *expr, struct nft_regs *regs)
 {
 	struct nft_rhash *priv = nft_set_priv(set);
@@ -141,7 +139,7 @@ nft_rhash_update(struct nft_set *set, const u32 *key,
 	if (he != NULL)
 		goto out;
 
-	elem_priv = new(set, expr, regs);
+	elem_priv = nft_dynset_new(set, expr, regs);
 	if (!elem_priv)
 		goto err1;
 
diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index 6c441e2dc8af..db5d367e43c4 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1137,7 +1137,6 @@ static inline void pipapo_resmap_init_avx2(const struct nft_pipapo_match *m, uns
  * @net:	Network namespace
  * @set:	nftables API set representation
  * @key:	nftables API element representation containing key data
- * @ext:	nftables API extension pointer, filled with matching reference
  *
  * For more details, see DOC: Theory of Operation in nft_set_pipapo.c.
  *
-- 
2.49.0

