Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78562307AF6
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Aug 2025 16:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755274185; cv=none; b=LjLvaivQ3Hm1Rq9VclNzOeSttVzayC6EEP/RljEgyWmBcpvDusIy0y+AgkiKELxO1icI0yItw/RKuUCZkNzrTHL+GlYh9orFVlJoGf03Ko1ksY5OURPBQIL/9qBSoOaOvzSUwof3mOHJzONJ1nXcuNeyad0ytk+5elXN7mIGRSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755274185; c=relaxed/simple;
	bh=Lm8iCJheajHfnd/Ynv9uramId+0nyPYpeYOyjSehWZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2sAxQMoeUBbAQIyDiBlgWRkQv9LpK2bQs4iTDke3VnqpM3COzSDNyT6MSOWhMCP+0i0t17LlUVIRwgW/4iQyTnqFCCW9p4NxsdSgO6kDQ09x+Szorv56gp8pMSaToS4MUC89+3FNyPVGOowc8ahNwhw/rFBtJ2BQgMbTxacxwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=IDhLsH+g; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Bu2+bhDi; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="IDhLsH+g";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Bu2+bhDi"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1755274182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l9Sh6hq2+ZtfKzJBv1yt/n17mmoYedyOa5xryE/XzDI=;
	b=IDhLsH+gO1TOQtCFVAbxj0o5Wd+uVCEe+XIVI6IQ8J2HrWo366Zwz4llAjgPIswhIeWLsv
	9XKDerJ9WhdO+j2xhcF6LZQgrO5eFoGe5f2Pvu6htAZFprV0OBZy+aBiokYMITbVusE/9Q
	jUHNnmFkT/ZgBgNnjKnIxJPm7z3ymBgVhQbpsyvSIaVKdsJx4hq3CLYBSvstM5v2cOUsvN
	4bJq2Not1yApYTKtRPsLRIp0CZz0xEgXqQs/fsBAWFwSroAjHDiPMaV3EwPz4Ww//rfC3E
	YetuJiBbrbV4pKfl4d3SCQTkGwADiSCmuBYeLI107DGqfVL/HHn7ZcHRKUc+OQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1755274182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l9Sh6hq2+ZtfKzJBv1yt/n17mmoYedyOa5xryE/XzDI=;
	b=Bu2+bhDim3NitWEkeyoDY0AXaNN4mOfiVNhK0i4krgNOgBGGVrMMhTJDSb7BMOJ5xPFwHd
	1M0JnrDuMGVsMfCQ==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH nf-next v2 1/3] netfilter: nft_set_pipapo: Store real pointer, adjust later.
Date: Fri, 15 Aug 2025 18:09:35 +0200
Message-ID: <20250815160937.1192748-2-bigeasy@linutronix.de>
In-Reply-To: <20250815160937.1192748-1-bigeasy@linutronix.de>
References: <20250815160937.1192748-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The struct nft_pipapo_scratch is allocated, then aligned to the required
alignment and difference (in bytes) is then saved in align_off. The
aligned pointer is used later.
While this works, it gets complicated with all the extra checks if
all member before map are larger than the required alignment.

Instead of saving the aligned pointer, just save the returned pointer
and align the map pointer in nft_pipapo_lookup() before using it. The
alignment later on shouldn't be that expensive. With this change, the
align_off can be removed and the pointer can be passed to kfree() as is.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/netfilter/nft_set_pipapo.c      | 40 ++++++-----------------------
 net/netfilter/nft_set_pipapo.h      |  5 ++--
 net/netfilter/nft_set_pipapo_avx2.c |  8 +++---
 3 files changed, 14 insertions(+), 39 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 9a10251228fd5..364b9abcce13b 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -418,8 +418,8 @@ static struct nft_pipapo_elem *pipapo_get(const struct =
nft_pipapo_match *m,
 					  const u8 *data, u8 genmask,
 					  u64 tstamp)
 {
+	unsigned long *res_map, *fill_map, *map;
 	struct nft_pipapo_scratch *scratch;
-	unsigned long *res_map, *fill_map;
 	const struct nft_pipapo_field *f;
 	bool map_index;
 	int i;
@@ -432,8 +432,9 @@ static struct nft_pipapo_elem *pipapo_get(const struct =
nft_pipapo_match *m,
=20
 	map_index =3D scratch->map_index;
=20
-	res_map  =3D scratch->map + (map_index ? m->bsize_max : 0);
-	fill_map =3D scratch->map + (map_index ? 0 : m->bsize_max);
+	map =3D NFT_PIPAPO_LT_ALIGN(&scratch->__map[0]);
+	res_map  =3D map + (map_index ? m->bsize_max : 0);
+	fill_map =3D map + (map_index ? 0 : m->bsize_max);
=20
 	pipapo_resmap_init(m, res_map);
=20
@@ -1136,22 +1137,17 @@ static void pipapo_map(struct nft_pipapo_match *m,
 }
=20
 /**
- * pipapo_free_scratch() - Free per-CPU map at original (not aligned) addr=
ess
+ * pipapo_free_scratch() - Free per-CPU map at original address
  * @m:		Matching data
  * @cpu:	CPU number
  */
 static void pipapo_free_scratch(const struct nft_pipapo_match *m, unsigned=
 int cpu)
 {
 	struct nft_pipapo_scratch *s;
-	void *mem;
=20
 	s =3D *per_cpu_ptr(m->scratch, cpu);
-	if (!s)
-		return;
=20
-	mem =3D s;
-	mem -=3D s->align_off;
-	kvfree(mem);
+	kvfree(s);
 }
=20
 /**
@@ -1168,11 +1164,8 @@ static int pipapo_realloc_scratch(struct nft_pipapo_=
match *clone,
=20
 	for_each_possible_cpu(i) {
 		struct nft_pipapo_scratch *scratch;
-#ifdef NFT_PIPAPO_ALIGN
-		void *scratch_aligned;
-		u32 align_off;
-#endif
-		scratch =3D kvzalloc_node(struct_size(scratch, map, bsize_max * 2) +
+
+		scratch =3D kvzalloc_node(struct_size(scratch, __map, bsize_max * 2) +
 					NFT_PIPAPO_ALIGN_HEADROOM,
 					GFP_KERNEL_ACCOUNT, cpu_to_node(i));
 		if (!scratch) {
@@ -1187,23 +1180,6 @@ static int pipapo_realloc_scratch(struct nft_pipapo_=
match *clone,
 		}
=20
 		pipapo_free_scratch(clone, i);
-
-#ifdef NFT_PIPAPO_ALIGN
-		/* Align &scratch->map (not the struct itself): the extra
-		 * %NFT_PIPAPO_ALIGN_HEADROOM bytes passed to kzalloc_node()
-		 * above guarantee we can waste up to those bytes in order
-		 * to align the map field regardless of its offset within
-		 * the struct.
-		 */
-		BUILD_BUG_ON(offsetof(struct nft_pipapo_scratch, map) > NFT_PIPAPO_ALIGN=
_HEADROOM);
-
-		scratch_aligned =3D NFT_PIPAPO_LT_ALIGN(&scratch->map);
-		scratch_aligned -=3D offsetof(struct nft_pipapo_scratch, map);
-		align_off =3D scratch_aligned - (void *)scratch;
-
-		scratch =3D scratch_aligned;
-		scratch->align_off =3D align_off;
-#endif
 		*per_cpu_ptr(clone->scratch, i) =3D scratch;
 	}
=20
diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
index 4a2ff85ce1c43..3655aa41fa949 100644
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -126,12 +126,11 @@ struct nft_pipapo_field {
  * struct nft_pipapo_scratch - percpu data used for lookup and matching
  * @map_index:	Current working bitmap index, toggled between field matches
  * @align_off:	Offset to get the originally allocated address
- * @map:	store partial matching results during lookup
+ * @__map:	store partial matching results during lookup
  */
 struct nft_pipapo_scratch {
 	u8 map_index;
-	u32 align_off;
-	unsigned long map[];
+	unsigned long __map[];
 };
=20
 /**
diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pi=
papo_avx2.c
index 2f090e253caf7..ed1594c6aeeee 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1155,8 +1155,8 @@ nft_pipapo_avx2_lookup(const struct net *net, const s=
truct nft_set *set,
 	u8 genmask =3D nft_genmask_cur(net);
 	const struct nft_pipapo_match *m;
 	const struct nft_pipapo_field *f;
+	unsigned long *res, *fill, *map;
 	const u8 *rp =3D (const u8 *)key;
-	unsigned long *res, *fill;
 	bool map_index;
 	int i;
=20
@@ -1187,9 +1187,9 @@ nft_pipapo_avx2_lookup(const struct net *net, const s=
truct nft_set *set,
 	}
=20
 	map_index =3D scratch->map_index;
-
-	res  =3D scratch->map + (map_index ? m->bsize_max : 0);
-	fill =3D scratch->map + (map_index ? 0 : m->bsize_max);
+	map =3D NFT_PIPAPO_LT_ALIGN(&scratch->__map[0]);
+	res  =3D map + (map_index ? m->bsize_max : 0);
+	fill =3D map + (map_index ? 0 : m->bsize_max);
=20
 	pipapo_resmap_init_avx2(m, res);
=20
--=20
2.50.1

