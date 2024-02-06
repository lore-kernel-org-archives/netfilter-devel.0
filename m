Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FC312EBE1
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Feb 2024 12:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707222586; cv=none; b=RxsfHBe8COFQyyRfiiWOOhrPgqODD5RjlGYXVOgt6HPYDpq7vOImlGyQaHmRBOVbwWRQ2yy2AKkkf/xuPHgCP3GRQS24xYALgnk3ZPm+upB4OVDHWgv157smyOPNx2SBBKPZM4S5QXVddRsbdvwoLV94jU2i4WSL/cSmCkp3WI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707222586; c=relaxed/simple;
	bh=/aTbAKRNm5zYa7EVh61B/960weLyy/WUrem/UUgMehk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9+Gn294oHPCVoztp/FmJ8OfB9oJQ5vtFQ73mni6OgGm49w2zkjN6o0/9VHV9Nyt4OVNDjEKel+VMKQDQzovbfKIOFjbBW52vWBf76xFxV8UtW2tBq+UG4ZG49usQmI8VK5k+EvECp9b8g57auqqh/AbMYwn4qNF0A4bTcg4lVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rXKa7-0002Ap-1u; Tue, 06 Feb 2024 13:29:43 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 3/3] netfilter: nft_set_pipapo: remove scratch_aligned pointer
Date: Tue,  6 Feb 2024 13:23:08 +0100
Message-ID: <20240206122531.21972-4-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240206122531.21972-1-fw@strlen.de>
References: <20240206122531.21972-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

use ->scratch for both avx2 and the generic implementation.

After previous change the scratch->map member is always aligned properly
for AVX2, so we can just use scratch->map in AVX2 too.

The alignoff delta is stored in the scratchpad so we can reconstruct
the correct address to free the area again.

Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c      | 41 +++++------------------------
 net/netfilter/nft_set_pipapo.h      |  6 ++---
 net/netfilter/nft_set_pipapo_avx2.c |  2 +-
 3 files changed, 10 insertions(+), 39 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 3d308e31b048..7ec284fd5093 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1118,6 +1118,7 @@ static void pipapo_free_scratch(const struct nft_pipapo_match *m, unsigned int c
 		return;
 
 	mem = s;
+	mem -= s->align_off;
 	kfree(mem);
 }
 
@@ -1137,6 +1138,7 @@ static int pipapo_realloc_scratch(struct nft_pipapo_match *clone,
 		struct nft_pipapo_scratch *scratch;
 #ifdef NFT_PIPAPO_ALIGN
 		void *scratch_aligned;
+		u32 align_off;
 #endif
 		scratch = kzalloc_node(struct_size(scratch, map,
 						   bsize_max * 2) +
@@ -1155,14 +1157,16 @@ static int pipapo_realloc_scratch(struct nft_pipapo_match *clone,
 
 		pipapo_free_scratch(clone, i);
 
-		*per_cpu_ptr(clone->scratch, i) = scratch;
-
 #ifdef NFT_PIPAPO_ALIGN
 		scratch_aligned = NFT_PIPAPO_LT_ALIGN(&scratch->map);
 		/* Need to align ->map start, not start of structure itself */
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
@@ -1316,11 +1320,6 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 	if (!new->scratch)
 		goto out_scratch;
 
-#ifdef NFT_PIPAPO_ALIGN
-	new->scratch_aligned = alloc_percpu(*new->scratch_aligned);
-	if (!new->scratch_aligned)
-		goto out_scratch;
-#endif
 	for_each_possible_cpu(i)
 		*per_cpu_ptr(new->scratch, i) = NULL;
 
@@ -1373,9 +1372,6 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 out_scratch_realloc:
 	for_each_possible_cpu(i)
 		pipapo_free_scratch(new, i);
-#ifdef NFT_PIPAPO_ALIGN
-	free_percpu(new->scratch_aligned);
-#endif
 out_scratch:
 	free_percpu(new->scratch);
 	kfree(new);
@@ -1657,11 +1653,7 @@ static void pipapo_free_match(struct nft_pipapo_match *m)
 	for_each_possible_cpu(i)
 		pipapo_free_scratch(m, i);
 
-#ifdef NFT_PIPAPO_ALIGN
-	free_percpu(m->scratch_aligned);
-#endif
 	free_percpu(m->scratch);
-
 	pipapo_free_fields(m);
 
 	kfree(m);
@@ -2155,16 +2147,6 @@ static int nft_pipapo_init(const struct nft_set *set,
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
@@ -2195,9 +2177,6 @@ static int nft_pipapo_init(const struct nft_set *set,
 	return 0;
 
 out_free:
-#ifdef NFT_PIPAPO_ALIGN
-	free_percpu(m->scratch_aligned);
-#endif
 	free_percpu(m->scratch);
 out_scratch:
 	kfree(m);
@@ -2251,9 +2230,6 @@ static void nft_pipapo_destroy(const struct nft_ctx *ctx,
 
 		nft_set_pipapo_match_destroy(ctx, set, m);
 
-#ifdef NFT_PIPAPO_ALIGN
-		free_percpu(m->scratch_aligned);
-#endif
 		for_each_possible_cpu(cpu)
 			pipapo_free_scratch(m, cpu);
 		free_percpu(m->scratch);
@@ -2268,9 +2244,6 @@ static void nft_pipapo_destroy(const struct nft_ctx *ctx,
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
index 8cad7b2e759d..107cffa8200c 100644
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
2.43.0

