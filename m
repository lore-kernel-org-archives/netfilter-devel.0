Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A301FECCD
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Nov 2025 14:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764341144; cv=none; b=GhAfTxTMN+SkmZ1jlfAiyOFXqYDdeBAgzr3Ty88SKosv7nC+snX7vkUXH+nTFQEJZvCJD4cXrRhY9jKQcN/41V795yWLNYXRKI0gro8r2VDFwij/RBAsOMP8578IuAKgpjfgquC7sEXulm/FXjOKO5Deydicjg4Q7DgKr1EooBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764341144; c=relaxed/simple;
	bh=Jp3Jm33onTe9AG59iDE+TH2eSyvwmnhzqXN1dPHOhhM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I580bG/hEblcd6fmTk1H/8l88+rVjIFxmc2L3pabvZWzecLyrnbXfFVEJrSfaWW6yHOCWseQ384lJ/NRVLwxGZnR4irJb4Moq7f16T9gxREwqxJ6P/WAK9jZzC+UJwg2CMFOxY/xH7lQV3Q6JtWz/hnVPiCQ1fbpjmkm8afwqUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FHQO9uUx; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FHQO9uUx"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-37b99da107cso20133071fa.1
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Nov 2025 06:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764341141; x=1764945941; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3JGVH7zD6IUXKcDO05aWtq1IjztVoli5vmuNX4ffLNM=;
        b=FHQO9uUxdwwbIX/c3TKuimHM92dY7Ho1k1rLlZ9tV7DA2XfTKg4IjN4cdWL7IPfC5D
         vyv4vg5lGFvoQY0OPjvkyfy0L7ZJGDr2y71SM2C/ul4PKOn9/VfktFpRXdkr1DV4kzPo
         sG6FuOiTSWPLaocVIiYoVoimPpTXnFjwRheeUWZxDLtMkqcGaIqxGNbagNRSBAA+T2BX
         AkuAVt26XQkWitFHo5G1D6slUG2aU+totxuBAvHUgvjB71A5bwt1XZ6auy6nEhEFTt5p
         gIcsToNCX3YiFRwLau+TNeNukqp8yhWzy+NJmYoCbucsjfUkPlwqlbmAwBiaYM/DdQgV
         /IaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764341141; x=1764945941;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3JGVH7zD6IUXKcDO05aWtq1IjztVoli5vmuNX4ffLNM=;
        b=MZ2Tb1fBGulc1SMgK+zm2e0k6Ulb7ed2mO0mqPcTenjWkAkj3rMLkS46vrmRCC8Pqv
         mMts1UDrNfzrB+ITkbHVwEi1zgQtUfz7vOtcDkNz1f0V0w3WyTJnE3v7NNYYnQX3yt8E
         Uc4G0b4pT/mjtzt8cF1Mygwktl4geVpGse2PlKBxZpTKh1MZzIqC1c+z9qhRb7u4jsc4
         lCE78YrYAmhomsTplQo56QdyZceBd9zW2etwNFc3lqVuM61/2LzrsbLeMG3GPXfsnltI
         VtTBxpgc327I5nqZZUJD8hjqfeyAGKfwxYdRzpWdYBruBEgeRBVWb1lWT2XWC0bGQ3iS
         sbZw==
X-Forwarded-Encrypted: i=1; AJvYcCX3p4xVpy7X1EUbbAnmWd+JJwmO753o4WevsM4oUOL4WSEzg96igR3l+FsoDJ+BYt/UY1NqX431GKk+WlSrFY4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzzh5kO7MoocK6IHfjf9AJBiEGWianMhDeuq+xPAQGlZMs3sa2P
	alflhCgVmFrYJW8pUQcaPccah0Elm3RrMwdtU7L0VOYJ+4rYkemAGs46
X-Gm-Gg: ASbGncuPxhX1X+36OV3SryRxkL+ZBKhXP5Lqgqt4fnChcT/futMN6FZIWk22LY1azvO
	+w9u0TYxqcMl9Uvj+/NF9nvs+f6Pt1f2cYVtfaFaT6RVcO755beNJ6+z+0/jEUeCDsjH5ZFo0PK
	nSSiFXAOCLKil/ptNinONGrKXezIX/HFuMcqZkkDiq9iM7NaBFHMyuEf1A9zDNAtNfKtOdGwmVD
	vLeLLCexODK4QiS27NJzFlAXMaFDweXkIRAOOH82D34PbfvdaCbogkxgVHs8MSFeKh5yFrlh3es
	VKoEXvPXnkkEWuV9552sbH/H/vTgizF5w4npAjYmuNeWgEdSuZ/YJp7iPg/hck+DDatRCsr+9z0
	shO+xEP8aFwEwFnEX1V+FNtV7shvMrgj4aU5aY0YfDvGX+xQSn5nbtPwfSXH5TwHCijfro99Cq9
	wzcKEyqt+3NZHO8VxxTHVIy5+3E48JNQkS9jGdjfWQLzI61SiW8h/7/ZR4
X-Google-Smtp-Source: AGHT+IEm5IaVO7wmybZv7QW7bl7mwKey0D/dKylfXtY1FFko7sJl7sRwAoyEmYtOGGNiwAeW/2AwzA==
X-Received: by 2002:a05:6512:10cd:b0:595:80d2:cfdf with SMTP id 2adb3069b0e04-596a3e98385mr10392102e87.6.1764341140318;
        Fri, 28 Nov 2025 06:45:40 -0800 (PST)
Received: from cherrypc.astracloud.ru (109-252-18-135.nat.spd-mgts.ru. [109.252.18.135])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-596bfa48a9fsm1272154e87.67.2025.11.28.06.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 06:45:39 -0800 (PST)
From: Nazar Kalashnikov <sivartiwe@gmail.com>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nazar Kalashnikov <sivartiwe@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Yi Chen <yiche@redhat.com>,
	Stefano Brivio <sbrivio@redhat.com>
Subject: [PATCH 5.10] netfilter: nf_set_pipapo: fix initial map fill
Date: Fri, 28 Nov 2025 17:46:01 +0300
Message-ID: <20251128144602.55408-1-sivartiwe@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 791a615b7ad2258c560f91852be54b0480837c93 ]

The initial buffer has to be inited to all-ones, but it must restrict
it to the size of the first field, not the total field size.

After each round in the map search step, the result and the fill map
are swapped, so if we have a set where f->bsize of the first element
is smaller than m->bsize_max, those one-bits are leaked into future
rounds result map.

This makes pipapo find an incorrect matching results for sets where
first field size is not the largest.

Followup patch adds a test case to nft_concat_range.sh selftest script.

Thanks to Stefano Brivio for pointing out that we need to zero out
the remainder explicitly, only correcting memset() argument isn't enough.

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Reported-by: Yi Chen <yiche@redhat.com>
Cc: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Nazar Kalashnikov <sivartiwe@gmail.com>
---
Backport fix for CVE-2024-57947
 net/netfilter/nft_set_pipapo.c      |  4 ++--
 net/netfilter/nft_set_pipapo.h      | 21 +++++++++++++++++++++
 net/netfilter/nft_set_pipapo_avx2.c | 10 ++++++----
 3 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index ce617f6a215f..6813ff660b72 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -432,7 +432,7 @@ bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
 	res_map  = scratch->map + (map_index ? m->bsize_max : 0);
 	fill_map = scratch->map + (map_index ? 0 : m->bsize_max);
 
-	memset(res_map, 0xff, m->bsize_max * sizeof(*res_map));
+	pipapo_resmap_init(m, res_map);
 
 	nft_pipapo_for_each_field(f, i, m) {
 		bool last = i == m->field_count - 1;
@@ -536,7 +536,7 @@ static struct nft_pipapo_elem *pipapo_get(const struct net *net,
 		goto out;
 	}
 
-	memset(res_map, 0xff, m->bsize_max * sizeof(*res_map));
+	pipapo_resmap_init(m, res_map);
 
 	nft_pipapo_for_each_field(f, i, m) {
 		bool last = i == m->field_count - 1;
diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
index 2e709ae01924..8f8f58af4e34 100644
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -287,4 +287,25 @@ static u64 pipapo_estimate_size(const struct nft_set_desc *desc)
 	return size;
 }
 
+/**
+ * pipapo_resmap_init() - Initialise result map before first use
+ * @m:		Matching data, including mapping table
+ * @res_map:	Result map
+ *
+ * Initialize all bits covered by the first field to one, so that after
+ * the first step, only the matching bits of the first bit group remain.
+ *
+ * If other fields have a large bitmap, set remainder of res_map to 0.
+ */
+static inline void pipapo_resmap_init(const struct nft_pipapo_match *m, unsigned long *res_map)
+{
+	const struct nft_pipapo_field *f = m->f;
+	int i;
+
+	for (i = 0; i < f->bsize; i++)
+		res_map[i] = ULONG_MAX;
+
+	for (i = f->bsize; i < m->bsize_max; i++)
+		res_map[i] = 0ul;
+}
 #endif /* _NFT_SET_PIPAPO_H */
diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index 0a23d297084d..81e6d12ab4cd 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1028,6 +1028,7 @@ static int nft_pipapo_avx2_lookup_8b_16(unsigned long *map, unsigned long *fill,
 
 /**
  * nft_pipapo_avx2_lookup_slow() - Fallback function for uncommon field sizes
+ * @mdata:	Matching data, including mapping table
  * @map:	Previous match result, used as initial bitmap
  * @fill:	Destination bitmap to be filled with current match result
  * @f:		Field, containing lookup and mapping tables
@@ -1043,7 +1044,8 @@ static int nft_pipapo_avx2_lookup_8b_16(unsigned long *map, unsigned long *fill,
  * Return: -1 on no match, rule index of match if @last, otherwise first long
  * word index to be checked next (i.e. first filled word).
  */
-static int nft_pipapo_avx2_lookup_slow(unsigned long *map, unsigned long *fill,
+static int nft_pipapo_avx2_lookup_slow(const struct nft_pipapo_match *mdata,
+					unsigned long *map, unsigned long *fill,
 					struct nft_pipapo_field *f, int offset,
 					const u8 *pkt, bool first, bool last)
 {
@@ -1053,7 +1055,7 @@ static int nft_pipapo_avx2_lookup_slow(unsigned long *map, unsigned long *fill,
 	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
 
 	if (first)
-		memset(map, 0xff, bsize * sizeof(*map));
+		pipapo_resmap_init(mdata, map);
 
 	for (i = offset; i < bsize; i++) {
 		if (f->bb == 8)
@@ -1181,7 +1183,7 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 			} else if (f->groups == 16) {
 				NFT_SET_PIPAPO_AVX2_LOOKUP(8, 16);
 			} else {
-				ret = nft_pipapo_avx2_lookup_slow(res, fill, f,
+				ret = nft_pipapo_avx2_lookup_slow(m, res, fill, f,
 								  ret, rp,
 								  first, last);
 			}
@@ -1197,7 +1199,7 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 			} else if (f->groups == 32) {
 				NFT_SET_PIPAPO_AVX2_LOOKUP(4, 32);
 			} else {
-				ret = nft_pipapo_avx2_lookup_slow(res, fill, f,
+				ret = nft_pipapo_avx2_lookup_slow(m, res, fill, f,
 								  ret, rp,
 								  first, last);
 			}
-- 
2.43.0

