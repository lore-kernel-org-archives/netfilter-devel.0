Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D8C53A8CB
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2024 02:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709259974; cv=none; b=RDRC3Oqzkf/t0xaKNJHp6vuiBs3zIySGfU0Rg27o85D/90zK7dwQWL743teVmqXz7ZRO1B5rjPhgB1JZYaHdJgerTibNxvUWEGyc/Ndv8fn/Ger6ik6ivIgjIm5bsfS5HDuS8bbOVcnGyk/T1PY6QibkqZ3ecp8PqtKSWBXVhBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709259974; c=relaxed/simple;
	bh=eVPBNCHcyNLx+2DgzurhgjuXUE8uTcqVlZtV7ttakkA=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oI+l7udFAe6YuubMbp14fzLX+XsG03vA7kpa2pV6+6Q5/f5l1kxlRXK/oIE41JVF9SqH5OtXc8dmiVRnGy6EjdT341gjr1gm9ZVmJmcykbf6ASmXs45PUyn2t7Cy1QAOVSCoySc1A3Klq3DnlwfOa5Lo7QHFPHpCZBWI5ugl8WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2 2/2] netfilter: nf_tables: reject constant set with timeout
Date: Fri,  1 Mar 2024 03:26:05 +0100
Message-Id: <20240301022605.146412-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240301022605.146412-1-pablo@netfilter.org>
References: <20240301022605.146412-1-pablo@netfilter.org>
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
v2: no changes, just a full revamp in this series

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

