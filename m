Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51BCA3ACA42;
	Fri, 21 Aug 2026 15:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787326737; cv=none; b=fJpwOFTgNGIUqnAX2L/E71csy6BxddBmVulZxt33lqlomEB1UUR+9XW7HioRnDlhPSdW2G6cRWxWKeiOs+JZ3ns6MGgRnMxWRskLyMgb5l7QO0CAvp5MSEBfRQv5QftRibS+5TSmWfP6KMQJpUf9Rnay5JupfH+pFloIw55tUzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787326737; c=relaxed/simple;
	bh=JCimh7eYU4cmH8j/gaHlqZY8BJeoM7U+NWvchakG5BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2ze1Clr7ZaLSxPHczfqOiDJo/PNgLrbMw5CgE4vFVm85aNHIWLidPenEpbR6xd1DJVt1d3/OvDDACAUMEYoCCE5Wf1DRX9eufBtD9g2og0+BpYjuV/LLuOQmTVRVdDjhwKEpkZUk7IPWlft3E/yDDCvVFFF3fJCtZN1OZw2qaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=v8KKh1OE; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="v8KKh1OE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787326729;
	bh=1JCWuUwY8LhXSGLDTuKwfoIOUIlCsntLoe6BvaC1u3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v8KKh1OEYEHlubTfq/QmA0wlL5QdiT/9RYtja40cO2fW3txYpXkFitri9dbrHXA44
	 m5VHzD7CrQuZceoLbi/kORHOhFC4apG97bBtA0A1ZB63EvocSvTfYaOn5Rsw+U46L4
	 Bz/NCIaYCuRUpTseuSG2cJk64nKAFLxSTfnBYgihZJP0wdXmpwTzXLIqZr/rMrtTXY
	 FQDwIeCeKMcEJO/eMNSRjvKpq7fM98s/NOU3tDaXCGGkeDJ+2T+UefNlJ68twQ3zAs
	 qEcoPTn0ZR4fC3TyXzA2PFFewYKu7QPCTPqUj+TjM2fVykK9ZxZc8EF5K3WTfZ0GgE
	 u5m5XYXE/ihPQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8D3C260094;
	Fri, 21 Aug 2026 17:38:48 +0200 (CEST)
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
Subject: [PATCH net 04/10] netfilter: nft_set_pipapo_avx2: add missing vzeroupper
Date: Fri, 21 Aug 2026 17:38:27 +0200
Message-ID: <20260821153833.245589-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821153833.245589-1-pablo@netfilter.org>
References: <20260821153833.245589-1-pablo@netfilter.org>
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

