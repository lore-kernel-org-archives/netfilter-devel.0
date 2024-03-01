Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B82363A1A2
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2024 02:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709259974; cv=none; b=n9K8X/x10TFhBVap7XVhTENNvhAcMFqgCw5ZvPklKEHxBG6dL1HyrFC0GBr00bk78/xbr32e1X/sRL22LxZeHJunS0KjTusd1/TVrLXeNMsx+puvIRHGx/Kk3PoE8WycbMGZh7KziQbleiy4c7zzc4P/Uo+x93Idns1ElJQltH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709259974; c=relaxed/simple;
	bh=+OuT+gMPgnnr39uKnC2kyr2MceJB3LmTvj9YnoUVAVY=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=h0KCuQfX6RXGqxNlTbB1hqH/84QKkqDB0sDY1LgGVlmH7+Dvxg+L2mtj08uBwVxBc3eQcAB+gjmRycI2QTeozoaTQqY78eWG8wXqZHcDcDpF+pQyyYZ6ewmp86nRF+DPU2JSotZwf9QJahyjyWIScij2hB7CEjbCDyIom6gJxYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2 1/2] netfilter: nf_tables: disallow anonymous set with timeout flag
Date: Fri,  1 Mar 2024 03:26:04 +0100
Message-Id: <20240301022605.146412-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Anonymous sets are never used with timeout from userspace, reject this.
Exception to this rule is NFT_SET_EVAL to ensure legacy meters still work.

Fixes: 761da2935d6e ("netfilter: nf_tables: add set timeout API support")
Reported-by: lonial con <kongln9170@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: allow NFT_SET_EVAL so meters (and use of nft_set_hash) is still possible

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

