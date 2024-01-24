Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B33812FF86;
	Wed, 24 Jan 2024 19:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706123578; cv=none; b=U/nSSZn08+sYyDybssK0pmjANUO3krcOY7Go8WsL44tjrOhX5vlA4bmmOwjltw5bGVamtyZmweEwP4VLQX6JV6qlFuGuRMJFU0x4PiVNeUu0KaQjwXxfugrwtNKPRW+0ch/qijeww6Xp8lCMpjK4Qv9zKAOKfL6YCY/JKKCNhyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706123578; c=relaxed/simple;
	bh=q90eiDpNR7uw27jH2PMKt2VlFOUOFLn+A0N0UFQBn0g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TkBC8kKMaBqJF4wGi+24b+BsJUbvEWbzG1pry3BtVDnLk9annDYJ9KmasyiBEs0+nG3s3b7xEFgweXoIcNfavSZ2jEm55ETXjCyZpAgHeuFPQlz9kvwl+rkbSMugjdRvItmpBvjcEE5CKDsNe48S1tEtrwG3ujNnZwZQAh5/0vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 3/6] netfilter: nft_limit: reject configurations that cause integer overflow
Date: Wed, 24 Jan 2024 20:12:45 +0100
Message-Id: <20240124191248.75463-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240124191248.75463-1-pablo@netfilter.org>
References: <20240124191248.75463-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Reject bogus configs where internal token counter wraps around.
This only occurs with very very large requests, such as 17gbyte/s.

Its better to reject this rather than having incorrect ratelimit.

Fixes: d2168e849ebf ("netfilter: nft_limit: add per-byte limiting")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_limit.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index 79039afde34e..cefa25e0dbb0 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -58,17 +58,19 @@ static inline bool nft_limit_eval(struct nft_limit_priv *priv, u64 cost)
 static int nft_limit_init(struct nft_limit_priv *priv,
 			  const struct nlattr * const tb[], bool pkts)
 {
+	u64 unit, tokens, rate_with_burst;
 	bool invert = false;
-	u64 unit, tokens;
 
 	if (tb[NFTA_LIMIT_RATE] == NULL ||
 	    tb[NFTA_LIMIT_UNIT] == NULL)
 		return -EINVAL;
 
 	priv->rate = be64_to_cpu(nla_get_be64(tb[NFTA_LIMIT_RATE]));
+	if (priv->rate == 0)
+		return -EINVAL;
+
 	unit = be64_to_cpu(nla_get_be64(tb[NFTA_LIMIT_UNIT]));
-	priv->nsecs = unit * NSEC_PER_SEC;
-	if (priv->rate == 0 || priv->nsecs < unit)
+	if (check_mul_overflow(unit, NSEC_PER_SEC, &priv->nsecs))
 		return -EOVERFLOW;
 
 	if (tb[NFTA_LIMIT_BURST])
@@ -77,18 +79,25 @@ static int nft_limit_init(struct nft_limit_priv *priv,
 	if (pkts && priv->burst == 0)
 		priv->burst = NFT_LIMIT_PKT_BURST_DEFAULT;
 
-	if (priv->rate + priv->burst < priv->rate)
+	if (check_add_overflow(priv->rate, priv->burst, &rate_with_burst))
 		return -EOVERFLOW;
 
 	if (pkts) {
-		tokens = div64_u64(priv->nsecs, priv->rate) * priv->burst;
+		u64 tmp = div64_u64(priv->nsecs, priv->rate);
+
+		if (check_mul_overflow(tmp, priv->burst, &tokens))
+			return -EOVERFLOW;
 	} else {
+		u64 tmp;
+
 		/* The token bucket size limits the number of tokens can be
 		 * accumulated. tokens_max specifies the bucket size.
 		 * tokens_max = unit * (rate + burst) / rate.
 		 */
-		tokens = div64_u64(priv->nsecs * (priv->rate + priv->burst),
-				 priv->rate);
+		if (check_mul_overflow(priv->nsecs, rate_with_burst, &tmp))
+			return -EOVERFLOW;
+
+		tokens = div64_u64(tmp, priv->rate);
 	}
 
 	if (tb[NFTA_LIMIT_FLAGS]) {
-- 
2.30.2

