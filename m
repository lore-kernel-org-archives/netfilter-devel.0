Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30205218AA0;
	Wed, 24 Sep 2025 14:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758722844; cv=none; b=Iw3H/rkpu7/x6ozKv/E0+wL+G/bg/Wpl5oaqwHKPrh7ZufFvgeL1UXdTlQoYsxpN1Y2Jw9G6B7/VA+WxmOuf/B11zl3sGnGVGA7v8v2WmNg1VSmaYXMrh4N2PmptJwTg5vuCjpypAtzgis7d159r9Jsw3TTA6Kp7FDCI6+ypukM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758722844; c=relaxed/simple;
	bh=QNt3LJv5Iej0Mmfnuwt3+BErFbMXNkchOmwjoYgLwzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzmHqvo7f3S33s1sJR5roGIBj01i9ZQc2ehUs7RSCq+WnPaTsBy6cEdd3b8IP8+m7hqS3aOthTdJQS2ln6m5dIaqNE46pDgheOd+hii6E4pG3OgH5/c5FfPqNNt2Es9rSbIYlZjXVND0cr6ZHs1LMcm0013o0qh9M0Lc+JjdoKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id ADD576032B; Wed, 24 Sep 2025 16:07:21 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 4/6] netfilter: nft_set_pipapo_avx2: fix skip of expired entries
Date: Wed, 24 Sep 2025 16:06:52 +0200
Message-ID: <20250924140654.10210-5-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250924140654.10210-1-fw@strlen.de>
References: <20250924140654.10210-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KASAN reports following splat:
BUG: KASAN: slab-out-of-bounds in pipapo_get_avx2+0x941/0x25d0
Read of size 1 at addr ffff88814c561be0 by task nft/3944
Call Trace:
 pipapo_get_avx2+0x941/0x25d0
 nft_pipapo_insert+0x440/0x11b0
 nf_tables_newsetelem+0x220a/0x3a00
 ..

This bisects to commit 84c1da7b38d9 ("netfilter: nft_set_pipapo: use AVX2
algorithm for insertions too").

However, that change merely uncovers this bug.

When we find a match but that match has expired or timed out, the AVX2
implementation restarts the full match loop.

At that point, the pointer to the key data has already been changed and
points to the keys last field.
This will then result in out-of-bounds read once its incremented again
for the next field.

The restart logic in AVX2 is different compared to the plain C
implementation, but both should follow the same logic.

The C implementation just calls pipapo_refill() again do check the next
entry.  Do the same in the AVX2 implementation.

Note that with this change, due to implementation differences of
pipapo_refill vs. nft_pipapo_avx2_refill, the refill call will return
the same element again. Then, on the next call, it will move to the next
entry as expected.  This is because avx2_refill doesn't clear the bitmap
in the 'last' conditional.  This is harmless. Expired/timed out elements
are also not expected to be frequent.

selftest is added in a followup commit.

Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo_avx2.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index e72fd045d037..7ff90325c97f 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1179,7 +1179,6 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
 
 	nft_pipapo_avx2_prepare();
 
-next_match:
 	nft_pipapo_for_each_field(f, i, m) {
 		bool last = i == m->field_count - 1, first = !i;
 		int ret = 0;
@@ -1226,6 +1225,7 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
 
 #undef NFT_SET_PIPAPO_AVX2_LOOKUP
 
+next_match:
 		if (ret < 0) {
 			scratch->map_index = map_index;
 			kernel_fpu_end();
@@ -1238,8 +1238,11 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
 
 			e = f->mt[ret].e;
 			if (unlikely(__nft_set_elem_expired(&e->ext, tstamp) ||
-				     !nft_set_elem_active(&e->ext, genmask)))
+				     !nft_set_elem_active(&e->ext, genmask))) {
+				ret = pipapo_refill(res, f->bsize, f->rules,
+						    fill, f->mt, last);
 				goto next_match;
+			}
 
 			scratch->map_index = map_index;
 			kernel_fpu_end();
-- 
2.49.1

