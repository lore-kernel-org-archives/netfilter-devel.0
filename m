Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6FF2DF156;
	Thu, 27 Aug 2026 14:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787840272; cv=none; b=LhsovJ7yzz9fB9xHE1w7hyLmwVybHl56gDjQYw/hu57ZlAu91bXT3V+UIKomWb0kaIkMsani80Lk0ori41ztmXRut4JTbTs28sB8VU7M7kgLjDe9KaqjPOdBQQFR/JRn6rZ3fszdkLGPbj3Pj8S/rcOR7fsRFYSvlXoH2ypAbBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787840272; c=relaxed/simple;
	bh=JCimh7eYU4cmH8j/gaHlqZY8BJeoM7U+NWvchakG5BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7DL6Ulc9NHGZ98+GZ+R/d/VN/gx+AUSQGgj8VJoX/fy6z5hKSzPUieb8cDDLGdvgq2bZ/W+Dp1DDyo2mj1kg9fYj2z7+n+dVmq2Qy4zXM8FEQ1v/WnUrDpjOBMSSCfRP4CzzZy0p6WIuKVMb5s+edPCkkeaYlK3lksrpD01PXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Ks87WIQb; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Ks87WIQb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787840264;
	bh=1JCWuUwY8LhXSGLDTuKwfoIOUIlCsntLoe6BvaC1u3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ks87WIQbetRr+WS+cWxtoK+k+9uOZrhXLDZNGUgZJY0yS5uwZcfy/E7iUF1zhIvKM
	 fw2jzayfeI4r9+sL6ZtW1Ru+P2ml/9hwNHEP5THo2Q4tTvge5Z3mHUkNx/eIqbDBEl
	 vmTPzhIZXv5w4nj1rcAzlVdQyoNh+VsF7ps851YralRQKe07YfI7FKWgrwIUXtbREL
	 dOMS3IxZfD1dVlSfVKdAyVNkE18LQLh8zv2bixEl/ncQ9WHPL8HHBGeWl4+cf+5eWG
	 ftoz5+kQGiFQfdY3NRyLSevIxA3gN7eBoUrm4PxbmXot2/uPAQ/ksl9EETR54OQ1zv
	 LVCwwBMuIgCZA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B850360085;
	Thu, 27 Aug 2026 16:17:43 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 4/9] netfilter: nft_set_pipapo_avx2: add missing vzeroupper
Date: Thu, 27 Aug 2026 16:17:28 +0200
Message-ID: <20260827141733.423453-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260827141733.423453-1-pablo@netfilter.org>
References: <20260827141733.423453-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@kernel.org>

Since pipapo_get_avx2() uses YMM registers, execute vzeroupper before
returning from it.  This is needed to avoid degrading the performance of
any later SSE code that may happen to be executed.

Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo_avx2.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index b3f105520a85..21f5be68c703 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1134,6 +1134,7 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
 	struct nft_pipapo_scratch *scratch;
 	const struct nft_pipapo_field *f;
 	unsigned long *res, *fill, *map;
+	struct nft_pipapo_elem *e;
 	bool map_index;
 	int ret = 0;
 	int i;
@@ -1207,14 +1208,11 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
 next_match:
 		if (ret < 0) {
 			scratch->map_index = map_index;
-			kernel_fpu_end();
-			__local_unlock_nested_bh(&scratch->bh_lock);
-			return NULL;
+			e = NULL;
+			goto out;
 		}
 
 		if (last) {
-			struct nft_pipapo_elem *e;
-
 			e = f->mt[ret].e;
 			if (unlikely(__nft_set_elem_expired(&e->ext, tstamp) ||
 				     !nft_set_elem_active(&e->ext, genmask))) {
@@ -1224,9 +1222,7 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
 			}
 
 			scratch->map_index = map_index;
-			kernel_fpu_end();
-			__local_unlock_nested_bh(&scratch->bh_lock);
-			return e;
+			goto out;
 		}
 
 		map_index = !map_index;
@@ -1234,9 +1230,12 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
 		data += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
 	}
 
+	e = NULL;
+out:
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 	__local_unlock_nested_bh(&scratch->bh_lock);
-	return NULL;
+	return e;
 }
 
 /**
-- 
2.47.3

