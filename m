Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333AB2EE27D;
	Mon,  1 Sep 2025 08:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756714140; cv=none; b=olObOFZrR+pkWliO2/MoZVDWzCd7ZWeRsteExF9XPE8FfpgKDc5C7Q3Z47I7ujjWgSsSSjr459sjHFGXYHsSMl1EiQhWMRvGrMGpB/5Gmwlx+m5YtlQxaSG+6t48W3oaywS0+R599ndeUChKakrZTfIiHGfqpWwsOYQgsdUTC/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756714140; c=relaxed/simple;
	bh=Q3VaKiotQGDo/pIQb0rVDWMuvG+xUoxm2RwrBUAL1Xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvI2+WiSUd6HViLxhG98wj7BqZM5CR1c2VPyP7hPjrCyWh8Z/OS9WZ+qGpIAaF2BKN/JBlLoY0wV5eXOZ1gqy9c6TJ8cUSUbUfWPw8k5XYNxHcrkenK2uMo4LOkATiyA1KQJcv9wGNijbnFEsliTVqbT2gIubprexRsj8GD5AR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2B49360819; Mon,  1 Sep 2025 10:08:56 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 2/8] netfilter: nft_payload: Use csum_replace4() instead of opencoding
Date: Mon,  1 Sep 2025 10:08:36 +0200
Message-ID: <20250901080843.1468-3-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250901080843.1468-1-fw@strlen.de>
References: <20250901080843.1468-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christophe Leroy <christophe.leroy@csgroup.eu>

Open coded calculation can be avoided and replaced by the
equivalent csum_replace4() in nft_csum_replace().

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_payload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 7dfc5343dae4..059b28ffad0e 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -684,7 +684,7 @@ static const struct nft_expr_ops nft_payload_inner_ops = {
 
 static inline void nft_csum_replace(__sum16 *sum, __wsum fsum, __wsum tsum)
 {
-	*sum = csum_fold(csum_add(csum_sub(~csum_unfold(*sum), fsum), tsum));
+	csum_replace4(sum, (__force __be32)fsum, (__force __be32)tsum);
 	if (*sum == 0)
 		*sum = CSUM_MANGLED_0;
 }
-- 
2.49.1

