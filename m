Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24F4B6A8DF;
	Wed,  7 Feb 2024 23:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707349062; cv=none; b=bk5IMhdcZNXm2fprqax1wtGQCBOJkH3H3gRusxdtqMCH8iJf3TDk+dnm/drIg1mYuXSel/AJ5/4SQYN0LP+2Zyb6yRv0ozfBnsI4J79dXt8o35SDvqolD6qxDShQkSvnZVF/vr5EH+j81PRbynBhnUfLV4Tu7Eecb9NOx+fJbos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707349062; c=relaxed/simple;
	bh=BN3KH8tQmVO5UWj8WiIVnHa32YM4Ga9sMnm2wZGtUZA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L7b+lcZSNcNUoOk/HCHxfv8r/nLVWE3iVLvZWqQOmm6LdV07Feyv1W366BPAVE5ZFYbV5CrAVw75/qBC0MEShO59xG7H3EE0ZfVlQ/aeAiAKSeH7JzSR7moLI9w8WUjZ+s+llkvCV9CCocQm/zRrfuP7IrTzuNT7gBEjv/sraps=
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
Subject: [PATCH net 13/13] netfilter: nft_set_pipapo: remove scratch_aligned pointer
Date: Thu,  8 Feb 2024 00:37:26 +0100
Message-Id: <20240207233726.331592-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240207233726.331592-1-pablo@netfilter.org>
References: <20240207233726.331592-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

use ->scratch for both avx2 and the generic implementation.

After previous change the scratch->map member is always aligned properly
for AVX2, so we can just use scratch->map in AVX2 too.

The alignoff delta is stored in the scratchpad so we can reconstruct
the correct address to free the area again.

Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c      | 41 +++++------------------------
 net/netfilter/nft_set_pipapo.h      |  6 ++---
 net/netfilter/nft_set_pipapo_avx2.c |  2 +-
 3 files changed, 10 insertions(+), 39 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index dbcd925d5c95..f6cdfa2228b9 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1124,6 +1124,7 @@ static void pipapo_free_scratch(const struct nft_pipapo_match *m, unsigned int c
 		return;
 
 	mem = s;
+	mem -= s->align_off;
 	kfree(mem);
 }
 
@@ -1143,6 +1144,7 @@ static int pipapo_realloc_scratch(struct nft_pipapo_match *clone,
 		struct nft_pipapo_scratch *scratch;
 #ifdef NFT_PIPAPO_ALIGN
 		void *scratch_aligned;
+		u32 align_off;
 #endif
 		scratch = kzalloc_node(struct_size(scratch, map,
 						   bsize_max * 2) +
@@ -1161,8 +1163,6 @@ static int pipapo_realloc_scratch(struct nft_pipapo_match *clone,
 
 		pipapo_free_scratch(clone, i);
 
-		*per_cpu_ptr(clone->scratch, i) = scratch;
-
 #ifdef NFT_PIPAPO_ALIGN
 		/* Align &scratch->map (not the struct itself): the extra
 		 * %NFT_PIPAPO_ALIGN_HEADROOM bytes passed to kzalloc_node()
@@ -1174,8 +1174,12 @@ static int pipapo_realloc_scratch(struct nft_pipapo_match *clone,
 
 		scratch_aligned = NFT_PIPAPO_LT_ALIGN(&scratch->map);
 		scratch_aligned -= offsetof(struct nft_pipapo_scratch, map);
-		*per_cpu_ptr(clone->scratch_aligned, i) = scratch_aligned;
+		align_off = scratch_aligned - (void *)scratch;
+
+		scratch = scratch_aligned;
+		scratch->align_off = align_off;
 #endif
+		*per_cpu_ptr(clone->scratch, i) = scratch;
 	}
 
 	return 0;
@@ -1330,11 +1334,6 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 	if (!new->scratch)
 		goto out_scratch;
 
-#ifdef NFT_PIPAPO_ALIGN
-	new->scratch_aligned = alloc_percpu(*new->scratch_aligned);
-	if (!new->scratch_aligned)
-		goto out_scratch;
-#endif
 	for_each_possible_cpu(i)
 		*per_cpu_ptr(new->scratch, i) = NULL;
 
@@ -1387,9 +1386,6 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 out_scratch_realloc:
 	for_each_possible_cpu(i)
 		pipapo_free_scratch(new, i);
-#ifdef NFT_PIPAPO_ALIGN
-	free_percpu(new->scratch_aligned);
-#endif
 out_scratch:
 	free_percpu(new->scratch);
 	kfree(new);
@@ -1672,11 +1668,7 @@ static void pipapo_free_match(struct nft_pipapo_match *m)
 	for_each_possible_cpu(i)
 		pipapo_free_scratch(m, i);
 
-#ifdef NFT_PIPAPO_ALIGN
-	free_percpu(m->scratch_aligned);
-#endif
 	free_percpu(m->scratch);
-
 	pipapo_free_fields(m);
 
 	kfree(m);
@@ -2170,16 +2162,6 @@ static int nft_pipapo_init(const struct nft_set *set,
 	for_each_possible_cpu(i)
 		*per_cpu_ptr(m->scratch, i) = NULL;
 
-#ifdef NFT_PIPAPO_ALIGN
-	m->scratch_aligned = alloc_percpu(struct nft_pipapo_scratch *);
-	if (!m->scratch_aligned) {
-		err = -ENOMEM;
-		goto out_free;
-	}
-	for_each_possible_cpu(i)
-		*per_cpu_ptr(m->scratch_aligned, i) = NULL;
-#endif
-
 	rcu_head_init(&m->rcu);
 
 	nft_pipapo_for_each_field(f, i, m) {
@@ -2210,9 +2192,6 @@ static int nft_pipapo_init(const struct nft_set *set,
 	return 0;
 
 out_free:
-#ifdef NFT_PIPAPO_ALIGN
-	free_percpu(m->scratch_aligned);
-#endif
 	free_percpu(m->scratch);
 out_scratch:
 	kfree(m);
@@ -2266,9 +2245,6 @@ static void nft_pipapo_destroy(const struct nft_ctx *ctx,
 
 		nft_set_pipapo_match_destroy(ctx, set, m);
 
-#ifdef NFT_PIPAPO_ALIGN
-		free_percpu(m->scratch_aligned);
-#endif
 		for_each_possible_cpu(cpu)
 			pipapo_free_scratch(m, cpu);
 		free_percpu(m->scratch);
@@ -2283,9 +2259,6 @@ static void nft_pipapo_destroy(const struct nft_ctx *ctx,
 		if (priv->dirty)
 			nft_set_pipapo_match_destroy(ctx, set, m);
 
-#ifdef NFT_PIPAPO_ALIGN
-		free_percpu(priv->clone->scratch_aligned);
-#endif
 		for_each_possible_cpu(cpu)
 			pipapo_free_scratch(priv->clone, cpu);
 		free_percpu(priv->clone->scratch);
diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
index 144b186c4caf..e5f67c5cf30a 100644
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -133,10 +133,12 @@ struct nft_pipapo_field {
 /**
  * struct nft_pipapo_scratch - percpu data used for lookup and matching
  * @map_index	Current working bitmap index, toggled between field matches
+ * @align_off	Offset to get the originally allocated address
  * @map		store partial matching results during lookup
  */
 struct nft_pipapo_scratch {
 	u8 map_index;
+	u32 align_off;
 	unsigned long map[];
 };
 
@@ -144,16 +146,12 @@ struct nft_pipapo_scratch {
  * struct nft_pipapo_match - Data used for lookup and matching
  * @field_count		Amount of fields in set
  * @scratch:		Preallocated per-CPU maps for partial matching results
- * @scratch_aligned:	Version of @scratch aligned to NFT_PIPAPO_ALIGN bytes
  * @bsize_max:		Maximum lookup table bucket size of all fields, in longs
  * @rcu			Matching data is swapped on commits
  * @f:			Fields, with lookup and mapping tables
  */
 struct nft_pipapo_match {
 	int field_count;
-#ifdef NFT_PIPAPO_ALIGN
-	struct nft_pipapo_scratch * __percpu *scratch_aligned;
-#endif
 	struct nft_pipapo_scratch * __percpu *scratch;
 	size_t bsize_max;
 	struct rcu_head rcu;
diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index 78213c73af2e..90e275bb3e5d 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1139,7 +1139,7 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 	 */
 	kernel_fpu_begin_mask(0);
 
-	scratch = *raw_cpu_ptr(m->scratch_aligned);
+	scratch = *raw_cpu_ptr(m->scratch);
 	if (unlikely(!scratch)) {
 		kernel_fpu_end();
 		return false;
-- 
2.30.2

