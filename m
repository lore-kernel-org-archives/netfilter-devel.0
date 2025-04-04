Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF98C2E62B3
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Apr 2025 06:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743747742; cv=none; b=KBlFEzCt/dZQbeTh84Czz5+HqE82bJpnaD49SppgrGqh2GgjKRuv3ZbsI2z5X0QP9U3zhZM6a5vuj4XqaWtgGDQx7yz0RRYKgY2mPY9LPpmRHkTIxO3GC3vGUn+YsvfscVDZ2UR+k44LDrTimD6r2j+2rW3RDcnVFH0busbvicQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743747742; c=relaxed/simple;
	bh=oVlFTn2EQd3L8+0VSElXwPi11rAAH4ckS16K1VBli2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHOCPioTPj0VbQCsewBYzfJQ3ysHbBOQoKmGcwNHNdZ+5HiIyZQoQ2HmIl3gXL4Jq+phsi++x+SmVA9lLSNFf8KZ0aSK0RcuiFRpq5MW1PYycpTLdZvU/fP9uee1xWgUvnfTWHmSpS4kANeyo76RD+5nspJ2mDPckOItHhJ7GZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1u0aRT-0005uo-UE; Fri, 04 Apr 2025 08:22:15 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sontu21@gmail.com,
	sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 2/3] nft_set_pipapo: fix incorrect avx2 match of 5th field octet
Date: Fri,  4 Apr 2025 08:20:53 +0200
Message-ID: <20250404062105.4285-3-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250404062105.4285-1-fw@strlen.de>
References: <20250404062105.4285-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Given a set element like:

	icmpv6 . dead:beef:00ff::1

The value of 'ff' is irrelevant, any address will be matched
as long as the other octets are the same.

This is because of too-early register clobbering:
ymm7 is reloaded with new packet data (pkt[9])  but it still holds data
of an earlier load that wasn't processed yet.

The existing tests in nft_concat_range.sh selftests do exercise this code
path, but do not trigger incorrect matching due to the network prefix
limitation.

Cc: Stefano Brivio <sbrivio@redhat.com>
Reported-by: sontu mazumdar <sontu21@gmail.com>
Closes: https://marc.info/?l=netfilter&m=174369594208899&w=2
Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo_avx2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index 8ce7154b678a..87cb0183cd79 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1120,8 +1120,9 @@ static int nft_pipapo_avx2_lookup_8b_16(unsigned long *map, unsigned long *fill,
 		NFT_PIPAPO_AVX2_BUCKET_LOAD8(5, lt,  8,  pkt[8], bsize);
 
 		NFT_PIPAPO_AVX2_AND(6, 2, 3);
+		NFT_PIPAPO_AVX2_AND(3, 4, 7);
 		NFT_PIPAPO_AVX2_BUCKET_LOAD8(7, lt,  9,  pkt[9], bsize);
-		NFT_PIPAPO_AVX2_AND(0, 4, 5);
+		NFT_PIPAPO_AVX2_AND(0, 3, 5);
 		NFT_PIPAPO_AVX2_BUCKET_LOAD8(1, lt, 10, pkt[10], bsize);
 		NFT_PIPAPO_AVX2_AND(2, 6, 7);
 		NFT_PIPAPO_AVX2_BUCKET_LOAD8(3, lt, 11, pkt[11], bsize);
-- 
2.49.0

