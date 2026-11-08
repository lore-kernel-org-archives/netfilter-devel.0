Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.31
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794177219;
	b=HlQXKWKo7xKj4bbkb/IgociPahSO3NBWjNSnGmJcdni29r6EOYCPGP7+Vm5INbJ7EfWo
	 ZviQ/+Ab+/BPuPbmwuIcYCeo+GlMhMGBkjUrecp2bZIfGLtRvRs52psEVfNnxk4rJJOuV
	 5hOcFUBZ7FsyGRzUCjsqPiNv5mmEgYImzMTYL7RhET1KGWsCEMLKmMR4O/K6H39u8733R
	 izCtlDnKm/E7wYrWhRsjQZkCJjDMz4XRTUJWEYX0xUrD6MBsotWUDCuns3Bu8xjj5mwNx
	 +ue5zFSj/NB+R8zBPYIbg6DuWYMPiMV9iPw7uQc5A9jgFO/jndiB1GQal/6F+mF0ZUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794177219;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=GrC+wHrV5dmf0SHyOJfjK+gQBgqvvrv1Wzg8mhE73mM=;
	b=o60382rpTeSKxzF2Q82aHUBOYmJcP/kVG0L8lkTfp7+oWr5uKhp2Q7hTIrazqV6Frwkg
	 CY9aKFOpXRwA9kgEyKz5Fghe7flQAjBqnYPfvVZx53bv/WOuuYNclOVWQ4n3gkTP6Aoy5
	 ubZrLLA4fpZBQXaVE/1sDrEdGR9zhYYE6brl6PfeyfrAW4O3hgcX/WfzpAm6PIT7XXapZ
	 iY6C56kSf7+4mUrjImEe7rG1ZA4NiDyp3TQ5ouSrilcgW9KIz4mmOIOY2OrSIvi7YcTlF
	 YqIOkBANW8gfq13KoMfSqh8sYTws9HH9rES4dVAwj2e3+3x8EncL3orwil43M6iTxOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=proton.me;
	spf=pass smtp.mailfrom=proton.me;
	dkim=pass header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=36zm24ih4rgibjwib7rneizc7a.protonmail2 header.b=aK+NfRCh;
	arc=none smtp.remote-ip=79.135.106.31
Received: from mail-10631.protonmail.ch (mail-10631.protonmail.ch [79.135.106.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE7A606D80A
	for <netfilter-devel@vger.kernel.org>; Sun,  8 Nov 2026 22:33:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0CE7A606D80A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=36zm24ih4rgibjwib7rneizc7a.protonmail2 header.b=aK+NfRCh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=36zm24ih4rgibjwib7rneizc7a.protonmail2; t=1794177216;
	x=1794436416; bh=GrC+wHrV5dmf0SHyOJfjK+gQBgqvvrv1Wzg8mhE73mM=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=aK+NfRCh2QXmAOgtaauThxR/S3AqUEnocqIOLH68V/Ox8bG4tqxGg1q7UkB2PcVQr
	 fO4EVyQFbIPRiD4Fa4p2PAC9CD9DCiAipWxtGcKi5v/RDMQmSGg0BfdDI8KNq7JHbM
	 uBl4oF39Sial6pD/D+TZrQ1Or1k0zYswS/eyjtiP4MwFDQyMtrNh7Kz/tkHjNkuqds
	 NWP/W0FIEtGMkP/ScOwy3fazNdhm4DKSRNlDmk8zhZQcURyMgaS6/RrmJlhmNh7njy
	 bOajRBtxovG0EHFTBNEBe4rC3SXNuncsiTGz2pZWVtuL3XO4i7GOrVLJW/sr+lLO69
	 mdxWoo6KgeMCA==
Date: Sun, 08 Nov 2026 22:33:34 +0000
To: "pablo@netfilter.org" <pablo@netfilter.org>, "fw@strlen.de" <fw@strlen.de>, "kadlec@netfilter.org" <kadlec@netfilter.org>
From: Noah Weinberger <NoahWeinberger2003@proton.me>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] netfilter: nft_set_pipapo_avx2: bound refill rule index
Message-ID: <n-wGTEki9QhyjhZx6mYuQx66pEJbEb-SwE54uwnU8PDoLx22Q5jGi3XoGoIIJ0I0gFGLCXwRMQxgqAv2pFM_6_-xrTic9rxdI8E6h2NtxOs=@proton.me>
Feedback-ID: 186545857:user:proton
X-Pm-Message-ID: e9fe673ee6292c243aeaad3ab970230b9ccbd93f
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,

The AVX2 refill helper lost the rule-index bound that its scalar twin
has: nft_pipapo_avx2_refill() computes i from the bitmap and
dereferences mt[i] (the caller then dereferences f->mt[ret].e) without
any 'i >=3D rules' check - the function does not even receive the rule
count. The scalar pipapo_refill() checks exactly this, and that guard
exists because this class of bug was once exploitable in pipapo.

The map invariant (every set bit < f->rules) currently holds across the
insert/remove/clone/adjust paths as far as static review can establish,
so there is no reachable out-of-bounds access today - this is a
defense-in-depth backstop for a set type reachable from unprivileged
user namespaces. The patch passes the rule count down and mirrors the
scalar guard (mechanical change; the 10 call sites are macro-expanded).

Affected version/commit: mainline fa4ad798f6f681031775266044ba1b0cf3c670bd =
(v7.4-rc1, 2026-11-07), net/netfilter/nft_set_pipapo_avx2.c:153-185 (refill=
), contrast nft_set_pipapo.c:372-396 (scalar twin).
The guard divergence is longstanding; the scalar guard was added after a hi=
storical pipapo CVE.

This was found during an assisted (AI-supported) static source review of
mainline fa4ad798f6f681031775266044ba1b0cf3c670bd (v7.4-rc1, 2026-11-07); e=
very code path cited below was re-verified by the
reporter against that tree. The patch below has NOT been compiled and has
NOT been runtime tested, and no reproducer was produced - the triggering
conditions are described above instead. Please treat this as a report for
verification rather than a battle-tested fix.

Reported-by: Noah Weinberger <noahweinberger2003@proton.me>
---
diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pi=
papo_avx2.c
index 21f5be6..9488c03 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -152,7 +152,8 @@ static void nft_pipapo_avx2_fill(unsigned long *data, i=
nt start, int len)
  */
 static int nft_pipapo_avx2_refill(int offset, unsigned long *map,
 =09=09=09=09  unsigned long *dst,
-=09=09=09=09  union nft_pipapo_map_bucket *mt, bool last)
+=09=09=09=09  union nft_pipapo_map_bucket *mt, int rules,
+=09=09=09=09  bool last)
 {
 =09int ret =3D -1;
=20
@@ -161,6 +162,11 @@ static int nft_pipapo_avx2_refill(int offset, unsigned=
 long *map,
 =09=09while (map[(x)]) {=09=09=09=09=09\
 =09=09=09int r =3D __builtin_ctzl(map[(x)]);=09=09\
 =09=09=09int i =3D (offset + (x)) * BITS_PER_LONG + r;=09\
+=09\
+=09=09=09if (unlikely(i >=3D rules)) {=09\
+=09=09=09=09map[(x)] =3D 0;=09\
+=09=09=09=09return -1;=09\
+=09=09=09}=09\
 =09=09=09=09=09=09=09=09=09\
 =09=09=09if (last)=09=09=09=09=09\
 =09=09=09=09return i;=09=09=09=09\
@@ -242,7 +248,8 @@ static int nft_pipapo_avx2_lookup_4b_2(unsigned long *m=
ap, unsigned long *fill,
 =09=09NFT_PIPAPO_AVX2_NOMATCH_GOTO(4, nomatch);
 =09=09NFT_PIPAPO_AVX2_STORE(map[i_ul], 4);
=20
-=09=09b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
+=09=09b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt,
+=09=09=09       f->rules, last);
 =09=09if (last)
 =09=09=09ret =3D b;
 =09=09else if (unlikely(ret =3D=3D -1))
@@ -318,7 +325,8 @@ static int nft_pipapo_avx2_lookup_4b_4(unsigned long *m=
ap, unsigned long *fill,
 =09=09NFT_PIPAPO_AVX2_NOMATCH_GOTO(7, nomatch);
 =09=09NFT_PIPAPO_AVX2_STORE(map[i_ul], 7);
=20
-=09=09b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
+=09=09b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt,
+=09=09=09       f->rules, last);
 =09=09if (last)
 =09=09=09ret =3D b;
 =09=09else if (unlikely(ret =3D=3D -1))
@@ -412,7 +420,8 @@ static int nft_pipapo_avx2_lookup_4b_8(unsigned long *m=
ap, unsigned long *fill,
 =09=09NFT_PIPAPO_AVX2_NOMATCH_GOTO(1, nomatch);
 =09=09NFT_PIPAPO_AVX2_STORE(map[i_ul], 1);
=20
-=09=09b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
+=09=09b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt,
+=09=09=09       f->rules, last);
 =09=09if (last)
 =09=09=09ret =3D b;
 =09=09else if (unlikely(ret =3D=3D -1))
@@ -502,7 +511,8 @@ static int nft_pipapo_avx2_lookup_4b_12(unsigned long *=
map, unsigned long *fill,
 =09=09NFT_PIPAPO_AVX2_NOMATCH_GOTO(8, nomatch);
 =09=09NFT_PIPAPO_AVX2_STORE(map[i_ul], 8);
=20
-=09=09b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
+=09=09b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt,
+=09=09=09       f->rules, last);
 =09=09if (last)
 =09=09=09ret =3D b;
 =09=09else if (unlikely(ret =3D=3D -1))
@@ -637,7 +647,8 @@ static int nft_pipapo_avx2_lookup_4b_32(unsigned long *=
map, unsigned long *fill,
 =09=09NFT_PIPAPO_AVX2_NOMATCH_GOTO(5, nomatch);
 =09=09NFT_PIPAPO_AVX2_STORE(map[i_ul], 5);
=20
-=09=09b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
+=09=09b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt,
+=09=09=09       f->rules, last);
 =09=09if (last)
 =09=09=09ret =3D b;
 =09=09else if (unlikely(ret =3D=3D -1))
@@ -694,7 +705,8 @@ static int nft_pipapo_avx2_lookup_8b_1(unsigned long *m=
ap, unsigned long *fill,
 =09=09NFT_PIPAPO_AVX2_NOMATCH_GOTO(2, nomatch);
 =09=09NFT_PIPAPO_AVX2_STORE(map[i_ul], 2);
=20
-=09=09b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
+=09=09b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt,
+=09=09=09       f->rules, last);
 =09=09if (last)
 =09=09=09ret =3D b;
 =09=09else if (unlikely(ret =3D=3D -1))
@@ -758,7 +770,8 @@ static int nft_pipapo_avx2_lookup_8b_2(unsigned long *m=
ap, unsigned long *fill,
 =09=09NFT_PIPAPO_AVX2_NOMATCH_GOTO(4, nomatch);
 =09=09NFT_PIPAPO_AVX2_STORE(map[i_ul], 4);
=20
-=09=09b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
+=09=09b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt,
+=09=09=09       f->rules, last);
 =09=09if (last)
 =09=09=09ret =3D b;
 =09=09else if (unlikely(ret =3D=3D -1))
@@ -832,7 +845,8 @@ static int nft_pipapo_avx2_lookup_8b_4(unsigned long *m=
ap, unsigned long *fill,
 =09=09NFT_PIPAPO_AVX2_NOMATCH_GOTO(0, nomatch);
 =09=09NFT_PIPAPO_AVX2_STORE(map[i_ul], 0);
=20
-=09=09b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
+=09=09b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt,
+=09=09=09       f->rules, last);
 =09=09if (last)
 =09=09=09ret =3D b;
 =09=09else if (unlikely(ret =3D=3D -1))
@@ -917,7 +931,8 @@ static int nft_pipapo_avx2_lookup_8b_6(unsigned long *m=
ap, unsigned long *fill,
 =09=09NFT_PIPAPO_AVX2_NOMATCH_GOTO(4, nomatch);
 =09=09NFT_PIPAPO_AVX2_STORE(map[i_ul], 4);
=20
-=09=09b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
+=09=09b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt,
+=09=09=09       f->rules, last);
 =09=09if (last)
 =09=09=09ret =3D b;
 =09=09else if (unlikely(ret =3D=3D -1))
@@ -1010,7 +1025,8 @@ static int nft_pipapo_avx2_lookup_8b_16(unsigned long=
 *map, unsigned long *fill,
 =09=09NFT_PIPAPO_AVX2_NOMATCH_GOTO(6, nomatch);
 =09=09NFT_PIPAPO_AVX2_STORE(map[i_ul], 6);
=20
-=09=09b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
+=09=09b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt,
+=09=09=09       f->rules, last);
 =09=09if (last)
 =09=09=09ret =3D b;
 =09=09else if (unlikely(ret =3D=3D -1))

