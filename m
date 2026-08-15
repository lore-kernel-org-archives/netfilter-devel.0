Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3E139A7F0;
	Sat, 15 Aug 2026 20:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786827538; cv=none; b=gEi8te8BB9iI35CO9Kov/GBlr+l+ZaQ+b+R+RJD7RWlKEBZwY0B5EIi4tvSbBY+rwNwd0WnWKk5G5ChUDiQkzWDfkJCkjYNXdes4gdU7zQKWCBALs0AFPJox01K40UGf+vEC8c6BvTqdJpnFcmcU64G3FWgb15teKyQYraTXqho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786827538; c=relaxed/simple;
	bh=daENMNWzFwnv/SLyg/LYZ2VdNdrGuELhVjAey20m5cE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AhYvViVphIBMvxqJAQQOMWXRJpfRavIMn8k7XL6KxVT2OKj0Q9F2GwOohNVOELtStn2vdBLJjlbHc7gTz2OV7xaN4wWosfItpzR2LK2eDwoAROPPs/xrtV7yresue21dLF/Vjx85afr0lOyVDU92UdRUHZskb2wEYt4GR8Pncxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DsWFY2RN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DsWFY2RN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A920B1F00A3E;
	Sat, 15 Aug 2026 20:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786827537;
	bh=Mli7QknwTOhcn8hn340G0Jnmp+/Q9en83EQ+szYFyZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DsWFY2RNQPLVepwFnlzgBVrVP6iOxX4bgYlYgNC4hZXEDd5qZBdOZtC59jFoWev+H
	 3ihoSLKj7XFAYqyhreN/kWK98aYnf4mQ447IpXPGRkWY8L8kOjIPKUFqw1No9DXAed
	 j5UfPNq3UIm3mW5uH/slW9dglQbjHq5VUVAxy3m7iBczhc6zjt5pLMQUpMaB46Rvvx
	 Q/0qT4WEhNStFGF4Ib3xE9rG0RvtxftGIHJ7cGh6+w83hlgVy8j4/t6GwEV0LR9NpF
	 /azdfhfpeHwSN0CMjWRcevqrBkZ2zeOj5yucqQpAVuBZjcvXT5mtLDiTo7QlXz4Suj
	 wcmabiP2TYjKQ==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Taehee Yoo <ap420073@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org,
	Stefano Brivio <sbrivio@redhat.com>
Subject: [PATCH 6/6] netfilter: nft_set_pipapo_avx2: add missing vzeroupper
Date: Sat, 15 Aug 2026 13:57:50 -0700
Message-ID: <20260815205750.169336-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260815205750.169336-1-ebiggers@kernel.org>
References: <20260815205750.169336-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since pipapo_get_avx2() uses YMM registers, execute vzeroupper before
returning from it.  This is needed to avoid degrading the performance of
any later SSE code that may happen to be executed.

Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
Cc: stable@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Cc: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
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
2.55.0

