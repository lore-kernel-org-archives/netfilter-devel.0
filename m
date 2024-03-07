Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9AE55672;
	Thu,  7 Mar 2024 02:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709777757; cv=none; b=GV2S9cERai2q0XQSIH1cmK4Pk1zmVdf5+60K4oJKfKDsLLtxu4vBGNQQFXjHCbmJOO2zgNhHy+0Nx8dvNjxIFc+GFrLNTP+obxUo7iHCiV0IfJIWGHIW/lqspiV1EI8KFYecEqJ0E7TyxLUojrysObT0lVR20X7jR5S0axjo47c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709777757; c=relaxed/simple;
	bh=VxB1xRTgYnm1p/MZtBGL8PhiIL4pvQBvJMSuKwyrBPw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SwJYQMO0xxm9SSMRrRjfbHt6rxFsrxlmipI6Y9UVLeYkhIMZZpIUBu+uKzcwntW3m5Sgd0RMYhO0Y5vGq2qCD1ZJZ2/PoOFl19j06j0mBwvx5OyJqoY28M+jMyZXaqQpFg0C9oorr+ZouGrn7Fe1sWXzGnbUUePv4CZeD+iZy/c=
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
Subject: [PATCH net 2/5] netfilter: nf_tables: reject constant set with timeout
Date: Thu,  7 Mar 2024 03:15:42 +0100
Message-Id: <20240307021545.149386-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240307021545.149386-1-pablo@netfilter.org>
References: <20240307021545.149386-1-pablo@netfilter.org>
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

Cc: stable@vger.kernel.org
Fixes: 761da2935d6e ("netfilter: nf_tables: add set timeout API support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bd21067f25cf..fb07455143a5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5004,6 +5004,9 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 		if ((flags & (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT | NFT_SET_EVAL)) ==
 			     (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT))
 			return -EOPNOTSUPP;
+		if ((flags & (NFT_SET_CONSTANT | NFT_SET_TIMEOUT)) ==
+			     (NFT_SET_CONSTANT | NFT_SET_TIMEOUT))
+			return -EOPNOTSUPP;
 	}
 
 	desc.dtype = 0;
-- 
2.30.2

