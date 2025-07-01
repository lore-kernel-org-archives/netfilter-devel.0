Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E4F242D79
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Jul 2025 22:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751407993; cv=none; b=VXHQlRAd45AnRS3/r/+5Vv/jiIc09kX/EgSbfGjPeAJMAheIKqrLdZ5PuPJE/DTl7m/pUhYcpZXlU8+z7B8BSfl2EyaCyP0QwZGFx/RVAmnAPBitCD4LGWDa4FTeJaaH5JbzT0GpxsX+qTmZdDiwFdEIgNDBYrN3+Szjb7TBBAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751407993; c=relaxed/simple;
	bh=NIsN6aKWQSnBisv5bIdOzRPfZg3pCp0UGdu8LcxME90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMWZfotSe4IBzmdpT3ZzQn7BJZtEFm/NAZ6YzcTHO4M6G1CqTwg1pF4gW8UilMJJtSD/edvybqXg0IRtNnfTh6hgw+78sXOrW4pCh8KNgwaf7gumBAD9Ktnv3Z+6pnQXpDoWIim2AQ+5G0l9hJia6gjVI10pfgXULiXKMeqLnBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=eTcWGHAE; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=QzuBHrOR; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="eTcWGHAE";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="QzuBHrOR"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1751407989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vKOLbZxC5rV0bYBXeMqzV72zaVPWG+da/fg8Nkdo7Kw=;
	b=eTcWGHAEyENV7GaotZeUz0pBbO4tnAOMKatkmawJqzjBJYtaH9FENSsZiE16RyuSe40ytw
	CmGVx0CGtlH6kNWSoQWR+YD4ddcyIEF2sQw39BZxsnd6XlhwKiqSPAG7euMSidRTq4RR/K
	6wE1yXr8W7sRrzebQs3qnFCqDm0S6rZ55RUwsThbQ12BoABHhE/uIeekVaeGUxSbXirDjw
	Lnnisvin9JiCwcq9U/0QXZT/Y7dRxblzseKPyOULLvAXVqMPW/7jaXM8Z8wKdoIrGA40de
	m5fGlObW5Vdf26c6CqLavV29UWpfR3YLspUgtfdMd6ZAj9lMGEHZlK++ggHQ4g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1751407989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vKOLbZxC5rV0bYBXeMqzV72zaVPWG+da/fg8Nkdo7Kw=;
	b=QzuBHrORkObGsfDfSE7ETcaxnL9AqIJM85t3PsMxKLatqBmobzUX9ftRygnSTIQ4VQW+Wl
	gC6lA9xfk0I3jgCg==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH nf-next 1/3] netfilter: nft_set_pipapo: Store real pointer, adjust later.
Date: Wed,  2 Jul 2025 00:13:02 +0200
Message-ID: <20250701221304.3846333-2-bigeasy@linutronix.de>
In-Reply-To: <20250701221304.3846333-1-bigeasy@linutronix.de>
References: <20250701221304.3846333-1-bigeasy@linutronix.de>
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
index c5855069bdaba..8b71a4630aa86 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -411,8 +411,8 @@ bool nft_pipapo_lookup(const struct net *net, const str=
uct nft_set *set,
 		       const u32 *key, const struct nft_set_ext **ext)
 {
 	struct nft_pipapo *priv =3D nft_set_priv(set);
+	unsigned long *res_map, *fill_map, *map;
 	struct nft_pipapo_scratch *scratch;
-	unsigned long *res_map, *fill_map;
 	u8 genmask =3D nft_genmask_cur(net);
 	const struct nft_pipapo_match *m;
 	const struct nft_pipapo_field *f;
@@ -431,8 +431,9 @@ bool nft_pipapo_lookup(const struct net *net, const str=
uct nft_set *set,
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
@@ -1204,22 +1205,17 @@ static void pipapo_map(struct nft_pipapo_match *m,
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
-	kfree(mem);
+	kfree(s);
 }
=20
 /**
@@ -1236,11 +1232,8 @@ static int pipapo_realloc_scratch(struct nft_pipapo_=
match *clone,
=20
 	for_each_possible_cpu(i) {
 		struct nft_pipapo_scratch *scratch;
-#ifdef NFT_PIPAPO_ALIGN
-		void *scratch_aligned;
-		u32 align_off;
-#endif
-		scratch =3D kzalloc_node(struct_size(scratch, map,
+
+		scratch =3D kzalloc_node(struct_size(scratch, __map,
 						   bsize_max * 2) +
 				       NFT_PIPAPO_ALIGN_HEADROOM,
 				       GFP_KERNEL_ACCOUNT, cpu_to_node(i));
@@ -1256,23 +1249,6 @@ static int pipapo_realloc_scratch(struct nft_pipapo_=
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
index be7c16c79f711..83acfa0c62b91 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1154,8 +1154,8 @@ bool nft_pipapo_avx2_lookup(const struct net *net, co=
nst struct nft_set *set,
 	u8 genmask =3D nft_genmask_cur(net);
 	const struct nft_pipapo_match *m;
 	const struct nft_pipapo_field *f;
+	unsigned long *res, *fill, *map;
 	const u8 *rp =3D (const u8 *)key;
-	unsigned long *res, *fill;
 	bool map_index;
 	int i, ret =3D 0;
=20
@@ -1186,9 +1186,9 @@ bool nft_pipapo_avx2_lookup(const struct net *net, co=
nst struct nft_set *set,
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
2.50.0

