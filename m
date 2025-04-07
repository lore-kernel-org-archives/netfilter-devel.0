Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB6F11CA0
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Apr 2025 17:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744047694; cv=none; b=k3tt1sapvfvw9kuIUzQXxL9Z3DWCO/8c9IsyjtNN4UmMf7PFejad9ASvfs7kL6AOkkw+ep5s8FWABDTvVCPgNIQEqX2prkF11fisjGC420H2Q/RzMWeOOsx28fNHLfMqOey3fc1Ws14h2xVPTQ+Hw8Sp60XYF0pqInhclVZHcK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744047694; c=relaxed/simple;
	bh=bJFYTPRVEASuxo2ghARmJsMV4444MAUsgwNtTgQeCpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdD/P1OFuXA9AhEKnbnKXgWtO7So5Je7Xfio1B71h/WyoXqobHdfXvNQi2uuSrpDOjepE191Wt/rtTZncjaDHPiYYyg0j3gHIaWaXFGjeYMDcPJarAZ7ygqjeVhothixvzdcNEfcJIajxWSE9r5Vx0FSlvn5KUB2oLznGdhVo/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1u1qTS-0008I1-7Y; Mon, 07 Apr 2025 19:41:30 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>,
	sontu mazumdar <sontu21@gmail.com>
Subject: [PATCH v3 nf 1/3] nft_set_pipapo: fix incorrect avx2 match of 5th field octet
Date: Mon,  7 Apr 2025 19:40:18 +0200
Message-ID: <20250407174048.21272-2-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250407174048.21272-1-fw@strlen.de>
References: <20250407174048.21272-1-fw@strlen.de>
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

Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
Reported-by: sontu mazumdar <sontu21@gmail.com>
Closes: https://lore.kernel.org/netfilter/CANgxkqwnMH7fXra+VUfODT-8+qFLgskq3set1cAzqqJaV4iEZg@mail.gmail.com/T/#t
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo_avx2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index b8d3c3213efe..c15db28c5ebc 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -994,8 +994,9 @@ static int nft_pipapo_avx2_lookup_8b_16(unsigned long *map, unsigned long *fill,
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

