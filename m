Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC3024A29;
	Thu,  7 Mar 2024 02:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709777757; cv=none; b=dVaxWoYfb/NFZIBIyX0E9djFGHzp2N9jsdyg+BG7cKjUVfVd2cHjcBGcvIz8MuqpcDdELMXQjP5A0QuKArlqFYY/toOJl1A5yQmuba98gixPr50vmjqHtEkMcJueGMw1g+8kHD8hFL0V3aLbUQs7F6U+pnu5o4q7ogko9qVgwag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709777757; c=relaxed/simple;
	bh=O7kVmgaOjDTbKK37xzjEqaudYKRAJ4rqri8ZauDBfgg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cRZVYhVFib73e2ARNiNVpNYI69KeB9bIbn8W9WV1jZ5r1EPxwZhLaHBcf8ZXtagUI/pEaEapw05bO2i1DLScq8KcABO/F/ro5B/djsrvRa8CpcspNxHmLLQELWy4KXhhr73G+NTpG+3vGkj5EnOLDCIS47Xcpa+3EUHM0WxFxUI=
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
Subject: [PATCH net 1/5] netfilter: nf_tables: disallow anonymous set with timeout flag
Date: Thu,  7 Mar 2024 03:15:41 +0100
Message-Id: <20240307021545.149386-2-pablo@netfilter.org>
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

Anonymous sets are never used with timeout from userspace, reject this.
Exception to this rule is NFT_SET_EVAL to ensure legacy meters still work.

Cc: stable@vger.kernel.org
Fixes: 761da2935d6e ("netfilter: nf_tables: add set timeout API support")
Reported-by: lonial con <kongln9170@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7e938c7397dd..bd21067f25cf 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5001,6 +5001,9 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 		if ((flags & (NFT_SET_EVAL | NFT_SET_OBJECT)) ==
 			     (NFT_SET_EVAL | NFT_SET_OBJECT))
 			return -EOPNOTSUPP;
+		if ((flags & (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT | NFT_SET_EVAL)) ==
+			     (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT))
+			return -EOPNOTSUPP;
 	}
 
 	desc.dtype = 0;
-- 
2.30.2

