Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B57A18A957
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2024 10:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724148093; cv=none; b=cMtR26CKKOwarVaHz8D0i+3R7/3WzdeVZu1pjXXNeyP0pCegnBg3sKuIIJ6cR3ZCwBeXfGbTpmhV/5+E4jaallCz/AcDrtLVVLlsww1taskD9k2wqgR1MVVpcOVkMw8HcX3bMDJO+wPam9Ov+jmMTk9Go+8xsvhMpQ/1I/hCFbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724148093; c=relaxed/simple;
	bh=XjI5JTnFyHRfVOBBdLJHgEGYgFdBApqiNzWDhYTfaHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6QmF4X1ZeYnIJjrIYakOqjckDI6bgiB/LFhKB02y4YQKMh2IZj0HyfU9pd2qMhBuigsf6cdYf278hcjDLyiteFuYm7VA4SKKE1PGKkgRAlRZvEa3e3XDSHZxibCHxZlPHN6WNxNSGX0PDg9AHJ72xgeJcHcbOcpRr4WLmxnwP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sgLg9-0004KX-40; Tue, 20 Aug 2024 12:01:29 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/3] netfilter: nf_tables: don't initialize registers in nft_do_chain()
Date: Tue, 20 Aug 2024 11:56:14 +0200
Message-ID: <20240820095619.6273-4-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
In-Reply-To: <20240820095619.6273-1-fw@strlen.de>
References: <20240820095619.6273-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

revert commit 4c905f6740a3 ("netfilter: nf_tables: initialize registers in
nft_do_chain()").

Previous patch makes sure that loads from uninitialized registers are
detected from the control plane. in this case rule blob auto-zeroes
registers.  Thus the explicit zeroing is not needed anymore.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index a48d5f0e2f3e..75598520b0fa 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -256,7 +256,7 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 	const struct net *net = nft_net(pkt);
 	const struct nft_expr *expr, *last;
 	const struct nft_rule_dp *rule;
-	struct nft_regs regs = {};
+	struct nft_regs regs;
 	unsigned int stackptr = 0;
 	struct nft_jumpstack jumpstack[NFT_JUMP_STACK_SIZE];
 	bool genbit = READ_ONCE(net->nft.gencursor);
-- 
2.44.2

