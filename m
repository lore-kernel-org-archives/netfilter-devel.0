Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAEA244667
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Jul 2025 18:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751395994; cv=none; b=VjBKk4mvw6pIMiH8/hTKcn4rXGsINncvcJOGp2uVQ6qxIQrb/y1p2V0etFAnlf/mb6Fm9iC/sARcDdfLi0FGGJS6JaHKDW4fM5mbJtU1ZnSzzQmS7t8MKFZG75K8tQAH3zAmwMO88UyN0LMxM7Giaj5j3CUTEAeHnTMWNNjnZZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751395994; c=relaxed/simple;
	bh=N7LsMsNJO3gWX2pmsR56YpqW6VzZwefNMdXT/TI0waQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDZRMvwYD9T7p1BjbBJwEnoY49LZiT/sUJhjXy/y25nZnWamsx49OSSVeeDiQVLyhh1wyRm1xULOyaslLahDhOKJOQy84nH4ZwWdABBlzFGdVnQFfwgcGvp8QD7UDbn1NLnvCHWD+KwodN75ktrnDDBsh8q/0xYaryslS8pYS0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B89BE6189B; Tue,  1 Jul 2025 20:53:10 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 4/5] netfilter: nft_set_pipapo: merge pipapo_get/lookup
Date: Tue,  1 Jul 2025 20:52:41 +0200
Message-ID: <20250701185245.31370-5-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250701185245.31370-1-fw@strlen.de>
References: <20250701185245.31370-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The matching algorithm has implemented thrice:
1. data path lookup, generic version
2. data path lookup, avx2 version
3. control plane lookup

Merge 1 and 3 by refactoring pipapo_get as a common helper, then make
nft_pipapo_lookup and nft_pipapo_get both call the common helper.

Aside from the code savings this has the benefit that we no longer allocate
temporary scratch maps for each control plane get and insertion operation.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c | 189 ++++++++++-----------------------
 1 file changed, 59 insertions(+), 130 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 36a4de11995b..ebd142d8d4d4 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -397,35 +397,37 @@ int pipapo_refill(unsigned long *map, unsigned int len, unsigned int rules,
 }
 
 /**
- * nft_pipapo_lookup() - Lookup function
- * @net:	Network namespace
- * @set:	nftables API set representation
- * @key:	nftables API element representation containing key data
- * @ext:	nftables API extension pointer, filled with matching reference
+ * pipapo_get() - Get matching element reference given key data
+ * @m:		storage containing the set elements
+ * @data:	Key data to be matched against existing elements
+ * @genmask:	If set, check that element is active in given genmask
+ * @tstamp:	timestamp to check for expired elements
  *
  * For more details, see DOC: Theory of Operation.
  *
- * Return: true on match, false otherwise.
+ * This is the main lookup function.  It matches key data either against
+ * the working match set or the uncomitted copy, depending on what the
+ * caller passed to us.
+ * nft_pipapo_get (lookup from userspace/control plane) and nft_pipapo_lookup
+ * (datapath lookup) pass the active copy.
+ * The insertion path will pass the uncomitted working copy.
+ *
+ * Return: pointer to &struct nft_pipapo_elem on match, NULL otherwise.
  */
-const struct nft_set_ext *
-nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
-		  const u32 *key)
+static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
+					  const u8 *data, u8 genmask,
+					  u64 tstamp)
 {
-	struct nft_pipapo *priv = nft_set_priv(set);
 	struct nft_pipapo_scratch *scratch;
 	unsigned long *res_map, *fill_map;
-	u8 genmask = nft_genmask_cur(net);
-	const struct nft_pipapo_match *m;
 	const struct nft_pipapo_field *f;
-	const u8 *rp = (const u8 *)key;
 	bool map_index;
 	int i;
 
 	local_bh_disable();
 
-	m = rcu_dereference(priv->match);
-
-	if (unlikely(!m || !*raw_cpu_ptr(m->scratch)))
+	/* XXX: fix this, prealloc and remove this check */
+	if (unlikely(!raw_cpu_ptr(m->scratch)))
 		goto out;
 
 	scratch = *raw_cpu_ptr(m->scratch);
@@ -445,12 +447,12 @@ nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
 		 * packet bytes value, then AND bucket value
 		 */
 		if (likely(f->bb == 8))
-			pipapo_and_field_buckets_8bit(f, res_map, rp);
+			pipapo_and_field_buckets_8bit(f, res_map, data);
 		else
-			pipapo_and_field_buckets_4bit(f, res_map, rp);
+			pipapo_and_field_buckets_4bit(f, res_map, data);
 		NFT_PIPAPO_GROUP_BITS_ARE_8_OR_4;
 
-		rp += f->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f);
+		data += f->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f);
 
 		/* Now populate the bitmap for the next field, unless this is
 		 * the last field, in which case return the matched 'ext'
@@ -470,11 +472,11 @@ nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
 		}
 
 		if (last) {
-			const struct nft_set_ext *ext;
+			struct nft_pipapo_elem *e;
 
-			ext = &f->mt[b].e->ext;
-			if (unlikely(nft_set_elem_expired(ext) ||
-				     !nft_set_elem_active(ext, genmask)))
+			e = f->mt[b].e;
+			if (unlikely(__nft_set_elem_expired(&e->ext, tstamp) ||
+				     !nft_set_elem_active(&e->ext, genmask)))
 				goto next_match;
 
 			/* Last field: we're just returning the key without
@@ -484,8 +486,7 @@ nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
 			 */
 			scratch->map_index = map_index;
 			local_bh_enable();
-
-			return ext;
+			return e;
 		}
 
 		/* Swap bitmap indices: res_map is the initial bitmap for the
@@ -495,7 +496,7 @@ nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
 		map_index = !map_index;
 		swap(res_map, fill_map);
 
-		rp += NFT_PIPAPO_GROUPS_PADDING(f);
+		data += NFT_PIPAPO_GROUPS_PADDING(f);
 	}
 
 out:
@@ -504,99 +505,29 @@ nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
 }
 
 /**
- * pipapo_get() - Get matching element reference given key data
- * @m:		storage containing active/existing elements
- * @data:	Key data to be matched against existing elements
- * @genmask:	If set, check that element is active in given genmask
- * @tstamp:	timestamp to check for expired elements
- * @gfp:	the type of memory to allocate (see kmalloc).
+ * nft_pipapo_lookup() - Dataplane fronted for main lookup function
+ * @net:	Network namespace
+ * @set:	nftables API set representation
+ * @key:	pointer to nft registers containing key data
  *
- * This is essentially the same as the lookup function, except that it matches
- * key data against the uncommitted copy and doesn't use preallocated maps for
- * bitmap results.
+ * This function is called from the data path.  It will search for
+ * an element matching the given key in the current active copy.
  *
- * Return: pointer to &struct nft_pipapo_elem on match, error pointer otherwise.
+ * Return: ntables API extension pointer or NULL if no match.
  */
-static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
-					  const u8 *data, u8 genmask,
-					  u64 tstamp, gfp_t gfp)
+const struct nft_set_ext *
+nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
+		  const u32 *key)
 {
-	struct nft_pipapo_elem *ret = ERR_PTR(-ENOENT);
-	unsigned long *res_map, *fill_map = NULL;
-	const struct nft_pipapo_field *f;
-	int i;
-
-	if (m->bsize_max == 0)
-		return ret;
-
-	res_map = kmalloc_array(m->bsize_max, sizeof(*res_map), gfp);
-	if (!res_map) {
-		ret = ERR_PTR(-ENOMEM);
-		goto out;
-	}
-
-	fill_map = kcalloc(m->bsize_max, sizeof(*res_map), gfp);
-	if (!fill_map) {
-		ret = ERR_PTR(-ENOMEM);
-		goto out;
-	}
-
-	pipapo_resmap_init(m, res_map);
-
-	nft_pipapo_for_each_field(f, i, m) {
-		bool last = i == m->field_count - 1;
-		int b;
-
-		/* For each bit group: select lookup table bucket depending on
-		 * packet bytes value, then AND bucket value
-		 */
-		if (f->bb == 8)
-			pipapo_and_field_buckets_8bit(f, res_map, data);
-		else if (f->bb == 4)
-			pipapo_and_field_buckets_4bit(f, res_map, data);
-		else
-			BUG();
-
-		data += f->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f);
-
-		/* Now populate the bitmap for the next field, unless this is
-		 * the last field, in which case return the matched 'ext'
-		 * pointer if any.
-		 *
-		 * Now res_map contains the matching bitmap, and fill_map is the
-		 * bitmap for the next field.
-		 */
-next_match:
-		b = pipapo_refill(res_map, f->bsize, f->rules, fill_map, f->mt,
-				  last);
-		if (b < 0)
-			goto out;
-
-		if (last) {
-			if (__nft_set_elem_expired(&f->mt[b].e->ext, tstamp))
-				goto next_match;
-			if ((genmask &&
-			     !nft_set_elem_active(&f->mt[b].e->ext, genmask)))
-				goto next_match;
-
-			ret = f->mt[b].e;
-			goto out;
-		}
-
-		data += NFT_PIPAPO_GROUPS_PADDING(f);
+	struct nft_pipapo *priv = nft_set_priv(set);
+	u8 genmask = nft_genmask_cur(net);
+	const struct nft_pipapo_match *m;
+	const struct nft_pipapo_elem *e;
 
-		/* Swap bitmap indices: fill_map will be the initial bitmap for
-		 * the next field (i.e. the new res_map), and res_map is
-		 * guaranteed to be all-zeroes at this point, ready to be filled
-		 * according to the next mapping table.
-		 */
-		swap(res_map, fill_map);
-	}
+	m = rcu_dereference(priv->match);
+	e = pipapo_get(m, (const u8 *)key, genmask, get_jiffies_64());
 
-out:
-	kfree(fill_map);
-	kfree(res_map);
-	return ret;
+	return e ? &e->ext : NULL;
 }
 
 /**
@@ -605,6 +536,11 @@ static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
  * @set:	nftables API set representation
  * @elem:	nftables API element representation containing key data
  * @flags:	Unused
+ *
+ * This function is called from the control plane path under
+ * RCU read lock.
+ *
+ * Return: set element private pointer; ERR_PTR if no match.
  */
 static struct nft_elem_priv *
 nft_pipapo_get(const struct net *net, const struct nft_set *set,
@@ -615,10 +551,9 @@ nft_pipapo_get(const struct net *net, const struct nft_set *set,
 	struct nft_pipapo_elem *e;
 
 	e = pipapo_get(m, (const u8 *)elem->key.val.data,
-		       nft_genmask_cur(net), get_jiffies_64(),
-		       GFP_ATOMIC);
-	if (IS_ERR(e))
-		return ERR_CAST(e);
+		       nft_genmask_cur(net), get_jiffies_64());
+	if (!e)
+		return ERR_PTR(-ENOENT);
 
 	return &e->priv;
 }
@@ -1344,8 +1279,8 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	else
 		end = start;
 
-	dup = pipapo_get(m, start, genmask, tstamp, GFP_KERNEL);
-	if (!IS_ERR(dup)) {
+	dup = pipapo_get(m, start, genmask, tstamp);
+	if (dup) {
 		/* Check if we already have the same exact entry */
 		const struct nft_data *dup_key, *dup_end;
 
@@ -1364,15 +1299,9 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 		return -ENOTEMPTY;
 	}
 
-	if (PTR_ERR(dup) == -ENOENT) {
-		/* Look for partially overlapping entries */
-		dup = pipapo_get(m, end, nft_genmask_next(net), tstamp,
-				 GFP_KERNEL);
-	}
-
-	if (PTR_ERR(dup) != -ENOENT) {
-		if (IS_ERR(dup))
-			return PTR_ERR(dup);
+	/* Look for partially overlapping entries */
+	dup = pipapo_get(m, end, nft_genmask_next(net), tstamp);
+	if (dup) {
 		*elem_priv = &dup->priv;
 		return -ENOTEMPTY;
 	}
@@ -1914,8 +1843,8 @@ nft_pipapo_deactivate(const struct net *net, const struct nft_set *set,
 		return NULL;
 
 	e = pipapo_get(m, (const u8 *)elem->key.val.data,
-		       nft_genmask_next(net), nft_net_tstamp(net), GFP_KERNEL);
-	if (IS_ERR(e))
+		       nft_genmask_next(net), nft_net_tstamp(net));
+	if (!e)
 		return NULL;
 
 	nft_set_elem_change_active(net, set, &e->ext);
-- 
2.49.0

