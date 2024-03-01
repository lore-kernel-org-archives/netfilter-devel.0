Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 859AAC135
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2024 00:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709253989; cv=none; b=U1rBIrD7rs7gvMAzhKIhS7cRS9UxNzxqmzhSxdRYMhIyM+bLWiIOqicRdxHkX3i0gpb/RiVA9Abv18QV7L5epJiDYUWThA70keIPAT2SjuCPVdGgRCMf0xemAxQNk76U6Yu9jKJXyo/zN9WyO/ApEdKVnQMeXpi7NMw81Pnm37w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709253989; c=relaxed/simple;
	bh=gZpgL/aBm4bAND9Geq7IUuGejDIm2+bAlMhjHYaPCGc=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g+HkxZz8IE0YlLhiXVNwb8fUN8QRHc9cM/vLyRsZSX/aqd7qBe7gxfxRkFRhhN99nBBav4VfI32hxaY0GAslNU1JnMhhhim6lD+hva2E1J3rvGMREgt7xp5qJjtgOjx5ea3QrHAIrmGKLjiQN1VFAVj83MsxST9t1wgxHnEgpXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf 2/2] netfilter: nf_tables: reject constant set with timeout
Date: Fri,  1 Mar 2024 01:46:09 +0100
Message-Id: <20240301004609.10237-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240301004609.10237-1-pablo@netfilter.org>
References: <20240301004609.10237-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This set combination is weird: it allows for elements to be
added/deleted, but once bound to the rule it cannot be updated anymore.
Eventually, all elements expire, leading to an empty set which cannot
be updated anymore. Reject this flags combination.

Fixes: 761da2935d6e ("netfilter: nf_tables: add set timeout API support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 70f90e7d108c..9e04fbb2065d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5004,6 +5004,9 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 		if ((flags & NFT_SET_ANONYMOUS) &&
 		    (flags & (NFT_SET_TIMEOUT | NFT_SET_EVAL)))
 			return -EOPNOTSUPP;
+		if ((flags & (NFT_SET_CONSTANT | NFT_SET_TIMEOUT)) ==
+			     (NFT_SET_CONSTANT | NFT_SET_TIMEOUT))
+			return -EOPNOTSUPP;
 	}
 
 	desc.dtype = 0;
-- 
2.30.2

