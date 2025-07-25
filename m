Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D742EF9D1;
	Fri, 25 Jul 2025 17:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753463068; cv=none; b=aOhUWnda5114sN4kvaoC03w2Re7LFA2miyfwEs2wHt49g1Ibk0SZI2Xahf0T6oi8aR8v4jpmboN0ZQ7TE1K70OchW/r69KvFxUQ1teLlXQkV3JebL4Ivko9ZqTK+jfvS6soYFZ2yHl+uN1TY1GXGay1Mh1h+atK+Ge63GDQB8+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753463068; c=relaxed/simple;
	bh=ope3wbhitJuMtXyI7B9SNdvmVXiaw9/5Ms1w5aQajD0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ieFh/H6JPamo5fwTMI1SEJmmwIPzsHPhxQMBM2C6fyunFEiZzA7riL+qgqbtJE/2R5loNaETKvk7ohlleWFbuHi++3mSbkYRDK2XvQvC2ysZ46TMgWyw0/ewI2b2F4hisSkAPl4sv7BLqb1RYmQnivJgzyRkInks17Iaq2Uz22I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oi4Ge1bI; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AZjJKhLV; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oi4Ge1bI";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AZjJKhLV"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0658160272; Fri, 25 Jul 2025 19:04:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463065;
	bh=UVPqJMwGmQeJCCZbukd+XC0BsV2dH1nDq9dhww8vek8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oi4Ge1bI4+MPSp4Zuk4j0wJCv0wUrNUXm5J+Cw0CD6UaB6KhUtk1PpBOVuNNM+Ig4
	 dS1ibY7z6Vji9KgyrDYrvmoFyT4OhqYLTYEQ+IEhZc6dExfYvYOhpdNAx+jC20wwmn
	 LE2seps1HnJijNyr/Y4srfGc1LX83I4LQpkg+JKZg2Wjg7Xcs+p6frrNw8t+NI4ubp
	 5vuuOg6Q2weBH6oyv+nsnvM//MKXh/P5TM2L9zpXj4DUd8Sz8PG4yAIOjD7ndTds93
	 v3ENZiN1K+Agvc7zO6khnAF7MCJ0aiX/8Xc/2dyYK7Po9cDZk0LsBcJGBgrUgFVn3x
	 IcuQvTQqofu9w==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A9ED260272;
	Fri, 25 Jul 2025 19:04:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463055;
	bh=UVPqJMwGmQeJCCZbukd+XC0BsV2dH1nDq9dhww8vek8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZjJKhLVIwgHLX5I39W6wQcrirDr1qoBwNG3v8e+febXjx0AUfExtmx6DClYHAogd
	 i3t+JK+cESa6CydzchvegRqW+QKcoSFa4XRK2Ct9b0o8Tsba6fRQnS+Ptrnd9DYkte
	 VkQ8OnAKwzoHDkIZGAYi8DgCwcRqgc0djBDW7quXFm/BYAmyfiuYKDj2be74bVZgWg
	 1hryXFcdTAXHwZ13iedYUKaxegkoWoLlWi/nNuMQz3yFFMKrmpPvXNfvm9GMmp5v6X
	 yDeyeAsbogxN4NWjaOzZ3ARAl486ZqZJzia3BBVTHnc68MZaPf74Te4jf3LqJ/Y60i
	 iphd+7HWQMfvw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 15/19] netfilter: nft_set_pipapo: merge pipapo_get/lookup
Date: Fri, 25 Jul 2025 19:03:36 +0200
Message-Id: <20250725170340.21327-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250725170340.21327-1-pablo@netfilter.org>
References: <20250725170340.21327-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

The matching algorithm has implemented thrice:
1. data path lookup, generic version
2. data path lookup, avx2 version
3. control plane lookup

Merge 1 and 3 by refactoring pipapo_get as a common helper, then make
nft_pipapo_lookup and nft_pipapo_get both call the common helper.

Aside from the code savings this has the benefit that we no longer allocate
temporary scratch maps for each control plane get and insertion operation.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 188 ++++++++++-----------------------
 1 file changed, 58 insertions(+), 130 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 36a4de11995b..28e67c4d7132 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -397,35 +397,36 @@ int pipapo_refill(unsigned long *map, unsigned int len, unsigned int rules,
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
+ * This is the main lookup function.  It matches key data against either
+ * the working match set or the uncommitted copy, depending on what the
+ * caller passed to us.
+ * nft_pipapo_get (lookup from userspace/control plane) and nft_pipapo_lookup
+ * (datapath lookup) pass the active copy.
+ * The insertion path will pass the uncommitted working copy.
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
+	if (unlikely(!raw_cpu_ptr(m->scratch)))
 		goto out;
 
 	scratch = *raw_cpu_ptr(m->scratch);
@@ -445,12 +446,12 @@ nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
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
@@ -470,11 +471,11 @@ nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
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
@@ -484,8 +485,7 @@ nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
 			 */
 			scratch->map_index = map_index;
 			local_bh_enable();
-
-			return ext;
+			return e;
 		}
 
 		/* Swap bitmap indices: res_map is the initial bitmap for the
@@ -495,7 +495,7 @@ nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
 		map_index = !map_index;
 		swap(res_map, fill_map);
 
-		rp += NFT_PIPAPO_GROUPS_PADDING(f);
+		data += NFT_PIPAPO_GROUPS_PADDING(f);
 	}
 
 out:
@@ -504,99 +504,29 @@ nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
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
@@ -605,6 +535,11 @@ static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
  * @set:	nftables API set representation
  * @elem:	nftables API element representation containing key data
  * @flags:	Unused
+ *
+ * This function is called from the control plane path under
+ * RCU read lock.
+ *
+ * Return: set element private pointer or ERR_PTR(-ENOENT).
  */
 static struct nft_elem_priv *
 nft_pipapo_get(const struct net *net, const struct nft_set *set,
@@ -615,10 +550,9 @@ nft_pipapo_get(const struct net *net, const struct nft_set *set,
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
@@ -1344,8 +1278,8 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	else
 		end = start;
 
-	dup = pipapo_get(m, start, genmask, tstamp, GFP_KERNEL);
-	if (!IS_ERR(dup)) {
+	dup = pipapo_get(m, start, genmask, tstamp);
+	if (dup) {
 		/* Check if we already have the same exact entry */
 		const struct nft_data *dup_key, *dup_end;
 
@@ -1364,15 +1298,9 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
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
@@ -1914,8 +1842,8 @@ nft_pipapo_deactivate(const struct net *net, const struct nft_set *set,
 		return NULL;
 
 	e = pipapo_get(m, (const u8 *)elem->key.val.data,
-		       nft_genmask_next(net), nft_net_tstamp(net), GFP_KERNEL);
-	if (IS_ERR(e))
+		       nft_genmask_next(net), nft_net_tstamp(net));
+	if (!e)
 		return NULL;
 
 	nft_set_elem_change_active(net, set, &e->ext);
-- 
2.30.2

