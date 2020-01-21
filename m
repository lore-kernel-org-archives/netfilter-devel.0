Return-Path: <SRS0=AyPt=3K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75CC2C33CAA
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jan 2020 23:18:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BAB824653
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jan 2020 23:18:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QxNN8III"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgAUXS2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Jan 2020 18:18:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25140 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727816AbgAUXS1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Jan 2020 18:18:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579648706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hL3Pt2JKELncJJImkECKXRdkZiEQIwff7PhOW+ihy20=;
        b=QxNN8III0z+piUzHsA2pGGjdz5nLiJdj8dGn6idiLNcqxmg2ne3BEt/AeIQrGlaspEfJF4
        iWIi8pkq8G4JMNyK9UrGsA9MhHT3ArtNYhzuy5CqMj30tkooy8y+CU0CfEYzjVpxbWPLVW
        71wwB3Uq7UlwY+fjEn6A7nDcoClgl9M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-NRmwo-PaMmOVRIm3QstKbQ-1; Tue, 21 Jan 2020 18:18:22 -0500
X-MC-Unique: NRmwo-PaMmOVRIm3QstKbQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87E5A801E6D;
        Tue, 21 Jan 2020 23:18:21 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-49.ams2.redhat.com [10.36.112.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9932A5C1BB;
        Tue, 21 Jan 2020 23:18:19 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf-next v4 7/9] nft_set_pipapo: Prepare for vectorised implementation: alignment
Date:   Wed, 22 Jan 2020 00:17:57 +0100
Message-Id: <50f81e18295eb7be009b12b2b56a5b83ee09cda2.1579647351.git.sbrivio@redhat.com>
In-Reply-To: <cover.1579647351.git.sbrivio@redhat.com>
References: <cover.1579647351.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SIMD vector extension sets require stricter alignment than native
instruction sets to operate efficiently (AVX, NEON) or for some
instructions to work at all (AltiVec).

Provide facilities to define arbitrary alignment for lookup tables
and scratch maps. By defining byte alignment with NFT_PIPAPO_ALIGN,
lt_aligned and scratch_aligned pointers become available.

Additional headroom is allocated, and pointers to the possibly
unaligned, originally allocated areas are kept so that they can
be freed.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
v4: No changes
v3: No changes
v2: No changes

 net/netfilter/nft_set_pipapo.c | 115 +++++++++++++++++++++++++++------
 1 file changed, 97 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipap=
o.c
index f0cb1e13af50..a9665d44e4f8 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -377,6 +377,22 @@
 #define NFT_PIPAPO_RULE0_MAX		((1UL << (NFT_PIPAPO_MAP_TOBITS - 1)) \
 					- (1UL << NFT_PIPAPO_MAP_NBITS))
=20
+/* Definitions for vectorised implementations */
+#ifdef NFT_PIPAPO_ALIGN
+#define NFT_PIPAPO_ALIGN_HEADROOM					\
+	(NFT_PIPAPO_ALIGN - ARCH_KMALLOC_MINALIGN)
+#define NFT_PIPAPO_LT_ALIGN(lt)		(PTR_ALIGN((lt), NFT_PIPAPO_ALIGN))
+#define NFT_PIPAPO_LT_ASSIGN(field, x)					\
+	do {								\
+		(field)->lt_aligned =3D NFT_PIPAPO_LT_ALIGN(x);		\
+		(field)->lt =3D (x);					\
+	} while (0)
+#else
+#define NFT_PIPAPO_ALIGN_HEADROOM	0
+#define NFT_PIPAPO_LT_ALIGN(lt)		(lt)
+#define NFT_PIPAPO_LT_ASSIGN(field, x)	((field)->lt =3D (x))
+#endif /* NFT_PIPAPO_ALIGN */
+
 #define nft_pipapo_for_each_field(field, index, match)		\
 	for ((field) =3D (match)->f, (index) =3D 0;			\
 	     (index) < (match)->field_count;			\
@@ -410,12 +426,16 @@ union nft_pipapo_map_bucket {
  * @rules:	Number of inserted rules
  * @bsize:	Size of each bucket in lookup table, in longs
  * @lt:		Lookup table: 'groups' rows of NFT_PIPAPO_BUCKETS buckets
+ * @lt_aligned:	Version of @lt aligned to NFT_PIPAPO_ALIGN bytes
  * @mt:		Mapping table: one bucket per rule
  */
 struct nft_pipapo_field {
 	int groups;
 	unsigned long rules;
 	size_t bsize;
+#ifdef NFT_PIPAPO_ALIGN
+	unsigned long *lt_aligned;
+#endif
 	unsigned long *lt;
 	union nft_pipapo_map_bucket *mt;
 };
@@ -424,12 +444,16 @@ struct nft_pipapo_field {
  * struct nft_pipapo_match - Data used for lookup and matching
  * @field_count		Amount of fields in set
  * @scratch:		Preallocated per-CPU maps for partial matching results
+ * @scratch_aligned:	Version of @scratch aligned to NFT_PIPAPO_ALIGN byt=
es
  * @bsize_max:		Maximum lookup table bucket size of all fields, in longs
  * @rcu			Matching data is swapped on commits
  * @f:			Fields, with lookup and mapping tables
  */
 struct nft_pipapo_match {
 	int field_count;
+#ifdef NFT_PIPAPO_ALIGN
+	unsigned long * __percpu *scratch_aligned;
+#endif
 	unsigned long * __percpu *scratch;
 	size_t bsize_max;
 	struct rcu_head rcu;
@@ -668,8 +692,8 @@ static struct nft_pipapo_elem *pipapo_get(const struc=
t net *net,
 	memset(res_map, 0xff, m->bsize_max * sizeof(*res_map));
=20
 	nft_pipapo_for_each_field(f, i, m) {
+		unsigned long *lt =3D NFT_PIPAPO_LT_ALIGN(f->lt);
 		bool last =3D i =3D=3D m->field_count - 1;
-		unsigned long *lt =3D f->lt;
 		int b, group;
=20
 		/* For each 4-bit group: select lookup table bucket depending on
@@ -763,6 +787,10 @@ static int pipapo_resize(struct nft_pipapo_field *f,=
 int old_rules, int rules)
 	int group, bucket;
=20
 	new_bucket_size =3D DIV_ROUND_UP(rules, BITS_PER_LONG);
+#ifdef NFT_PIPAPO_ALIGN
+	new_bucket_size =3D roundup(new_bucket_size,
+				  NFT_PIPAPO_ALIGN / sizeof(*new_lt));
+#endif
=20
 	if (new_bucket_size =3D=3D f->bsize)
 		goto mt;
@@ -773,12 +801,14 @@ static int pipapo_resize(struct nft_pipapo_field *f=
, int old_rules, int rules)
 		copy =3D new_bucket_size;
=20
 	new_lt =3D kvzalloc(f->groups * NFT_PIPAPO_BUCKETS * new_bucket_size *
-			  sizeof(*new_lt), GFP_KERNEL);
+			  sizeof(*new_lt) + NFT_PIPAPO_ALIGN_HEADROOM,
+			  GFP_KERNEL);
 	if (!new_lt)
 		return -ENOMEM;
=20
-	new_p =3D new_lt;
-	old_p =3D old_lt;
+	new_p =3D NFT_PIPAPO_LT_ALIGN(new_lt);
+	old_p =3D NFT_PIPAPO_LT_ALIGN(old_lt);
+
 	for (group =3D 0; group < f->groups; group++) {
 		for (bucket =3D 0; bucket < NFT_PIPAPO_BUCKETS; bucket++) {
 			memcpy(new_p, old_p, copy * sizeof(*new_p));
@@ -807,7 +837,7 @@ static int pipapo_resize(struct nft_pipapo_field *f, =
int old_rules, int rules)
=20
 	if (new_lt) {
 		f->bsize =3D new_bucket_size;
-		f->lt =3D new_lt;
+		NFT_PIPAPO_LT_ASSIGN(f, new_lt);
 		kvfree(old_lt);
 	}
=20
@@ -829,7 +859,8 @@ static void pipapo_bucket_set(struct nft_pipapo_field=
 *f, int rule, int group,
 {
 	unsigned long *pos;
=20
-	pos =3D f->lt + f->bsize * NFT_PIPAPO_BUCKETS * group;
+	pos =3D NFT_PIPAPO_LT_ALIGN(f->lt);
+	pos +=3D f->bsize * NFT_PIPAPO_BUCKETS * group;
 	pos +=3D f->bsize * v;
=20
 	__set_bit(rule, pos);
@@ -1053,8 +1084,12 @@ static int pipapo_realloc_scratch(struct nft_pipap=
o_match *clone,
=20
 	for_each_possible_cpu(i) {
 		unsigned long *scratch;
+#ifdef NFT_PIPAPO_ALIGN
+		unsigned long *scratch_aligned;
+#endif
=20
-		scratch =3D kzalloc_node(bsize_max * sizeof(*scratch) * 2,
+		scratch =3D kzalloc_node(bsize_max * sizeof(*scratch) * 2 +
+				       NFT_PIPAPO_ALIGN_HEADROOM,
 				       GFP_KERNEL, cpu_to_node(i));
 		if (!scratch) {
 			/* On failure, there's no need to undo previous
@@ -1070,6 +1105,11 @@ static int pipapo_realloc_scratch(struct nft_pipap=
o_match *clone,
 		kfree(*per_cpu_ptr(clone->scratch, i));
=20
 		*per_cpu_ptr(clone->scratch, i) =3D scratch;
+
+#ifdef NFT_PIPAPO_ALIGN
+		scratch_aligned =3D NFT_PIPAPO_LT_ALIGN(scratch);
+		*per_cpu_ptr(clone->scratch_aligned, i) =3D scratch_aligned;
+#endif
 	}
=20
 	return 0;
@@ -1200,21 +1240,33 @@ static struct nft_pipapo_match *pipapo_clone(stru=
ct nft_pipapo_match *old)
 	if (!new->scratch)
 		goto out_scratch;
=20
+#ifdef NFT_PIPAPO_ALIGN
+	new->scratch_aligned =3D alloc_percpu(*new->scratch_aligned);
+	if (!new->scratch_aligned)
+		goto out_scratch;
+#endif
+
 	rcu_head_init(&new->rcu);
=20
 	src =3D old->f;
 	dst =3D new->f;
=20
 	for (i =3D 0; i < old->field_count; i++) {
+		unsigned long *new_lt;
+
 		memcpy(dst, src, offsetof(struct nft_pipapo_field, lt));
=20
-		dst->lt =3D kvzalloc(src->groups * NFT_PIPAPO_BUCKETS *
-				   src->bsize * sizeof(*dst->lt),
-				   GFP_KERNEL);
-		if (!dst->lt)
+		new_lt =3D kvzalloc(src->groups * NFT_PIPAPO_BUCKETS *
+				  src->bsize * sizeof(*dst->lt) +
+				  NFT_PIPAPO_ALIGN_HEADROOM,
+				  GFP_KERNEL);
+		if (!new_lt)
 			goto out_lt;
=20
-		memcpy(dst->lt, src->lt,
+		NFT_PIPAPO_LT_ASSIGN(dst, new_lt);
+
+		memcpy(NFT_PIPAPO_LT_ALIGN(new_lt),
+		       NFT_PIPAPO_LT_ALIGN(src->lt),
 		       src->bsize * sizeof(*dst->lt) *
 		       src->groups * NFT_PIPAPO_BUCKETS);
=20
@@ -1237,8 +1289,11 @@ static struct nft_pipapo_match *pipapo_clone(struc=
t nft_pipapo_match *old)
 		kvfree(dst->lt);
 		dst--;
 	}
-	free_percpu(new->scratch);
+#ifdef NFT_PIPAPO_ALIGN
+	free_percpu(new->scratch_aligned);
+#endif
 out_scratch:
+	free_percpu(new->scratch);
 	kfree(new);
=20
 	return ERR_PTR(-ENOMEM);
@@ -1394,7 +1449,8 @@ static void pipapo_drop(struct nft_pipapo_match *m,
 			unsigned long *pos;
 			int b;
=20
-			pos =3D f->lt + g * NFT_PIPAPO_BUCKETS * f->bsize;
+			pos =3D NFT_PIPAPO_LT_ALIGN(f->lt) + g *
+			      NFT_PIPAPO_BUCKETS * f->bsize;
=20
 			for (b =3D 0; b < NFT_PIPAPO_BUCKETS; b++) {
 				bitmap_cut(pos, pos, rulemap[i].to,
@@ -1498,6 +1554,9 @@ static void pipapo_reclaim_match(struct rcu_head *r=
cu)
 	for_each_possible_cpu(i)
 		kfree(*per_cpu_ptr(m->scratch, i));
=20
+#ifdef NFT_PIPAPO_ALIGN
+	free_percpu(m->scratch_aligned);
+#endif
 	free_percpu(m->scratch);
=20
 	pipapo_free_fields(m);
@@ -1701,7 +1760,8 @@ static int pipapo_get_boundaries(struct nft_pipapo_=
field *f, int first_rule,
 		for (b =3D 0; b < NFT_PIPAPO_BUCKETS; b++) {
 			unsigned long *pos;
=20
-			pos =3D f->lt + (g * NFT_PIPAPO_BUCKETS + b) * f->bsize;
+			pos =3D NFT_PIPAPO_LT_ALIGN(f->lt) +
+			      (g * NFT_PIPAPO_BUCKETS + b) * f->bsize;
 			if (test_bit(first_rule, pos) && x0 =3D=3D -1)
 				x0 =3D b;
 			if (test_bit(first_rule + rule_count - 1, pos))
@@ -1975,11 +2035,21 @@ static int nft_pipapo_init(const struct nft_set *=
set,
 	m->scratch =3D alloc_percpu(unsigned long *);
 	if (!m->scratch) {
 		err =3D -ENOMEM;
-		goto out_free;
+		goto out_scratch;
 	}
 	for_each_possible_cpu(i)
 		*per_cpu_ptr(m->scratch, i) =3D NULL;
=20
+#ifdef NFT_PIPAPO_ALIGN
+	m->scratch_aligned =3D alloc_percpu(unsigned long *);
+	if (!m->scratch_aligned) {
+		err =3D -ENOMEM;
+		goto out_free;
+	}
+	for_each_possible_cpu(i)
+		*per_cpu_ptr(m->scratch_aligned, i) =3D NULL;
+#endif
+
 	rcu_head_init(&m->rcu);
=20
 	nft_pipapo_for_each_field(f, i, m) {
@@ -1990,7 +2060,7 @@ static int nft_pipapo_init(const struct nft_set *se=
t,
=20
 		f->bsize =3D 0;
 		f->rules =3D 0;
-		f->lt =3D NULL;
+		NFT_PIPAPO_LT_ASSIGN(f, NULL);
 		f->mt =3D NULL;
 	}
=20
@@ -2008,7 +2078,11 @@ static int nft_pipapo_init(const struct nft_set *s=
et,
 	return 0;
=20
 out_free:
+#ifdef NFT_PIPAPO_ALIGN
+	free_percpu(m->scratch_aligned);
+#endif
 	free_percpu(m->scratch);
+out_scratch:
 	kfree(m);
=20
 	return err;
@@ -2043,16 +2117,21 @@ static void nft_pipapo_destroy(const struct nft_s=
et *set)
 			nft_set_elem_destroy(set, e, true);
 		}
=20
+#ifdef NFT_PIPAPO_ALIGN
+		free_percpu(m->scratch_aligned);
+#endif
 		for_each_possible_cpu(cpu)
 			kfree(*per_cpu_ptr(m->scratch, cpu));
 		free_percpu(m->scratch);
-
 		pipapo_free_fields(m);
 		kfree(m);
 		priv->match =3D NULL;
 	}
=20
 	if (priv->clone) {
+#ifdef NFT_PIPAPO_ALIGN
+		free_percpu(priv->clone->scratch_aligned);
+#endif
 		for_each_possible_cpu(cpu)
 			kfree(*per_cpu_ptr(priv->clone->scratch, cpu));
 		free_percpu(priv->clone->scratch);
--=20
2.24.1

