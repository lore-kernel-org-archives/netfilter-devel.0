Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB9F1953AB
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2024 13:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719496711; cv=none; b=Gl6A0GLWwIEl6kGwTJNgVLYrNGffsVsvVnW4fBn7dwhyGV1ptCix4aF5xXJ8rhEp9VQCO0OkWxlVX4uPK+x6eF2VbHDjzbtxzj/zKfU0JdyCdyt6lk875btWr4p5qpq8HKOzggN+ehsOCj7e9/vayYRVhTY40hb25IebGZmN+Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719496711; c=relaxed/simple;
	bh=XjI5JTnFyHRfVOBBdLJHgEGYgFdBApqiNzWDhYTfaHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUajmQckbxMDWW/LmCs6x6x8Y/p7OtBt+tgLqqNj5rEh30XkEU0GJv1E+9WPqIjSR/p1Q6zgvevdyX7VYTHJsHSOkUN0N8EB7YRS99d/YuoYloBb2K8jN81VbyAQaejcfda1OZF4oBEkG17SO014wD16GwzifpaLNi+Nw6LffQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sMpds-0002As-Ig; Thu, 27 Jun 2024 15:58:28 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [RFC nf-next 4/4] netfilter: nf_tables: don't initialize registers in nft_do_chain()
Date: Thu, 27 Jun 2024 15:53:24 +0200
Message-ID: <20240627135330.17039-5-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
In-Reply-To: <20240627135330.17039-1-fw@strlen.de>
References: <20240627135330.17039-1-fw@strlen.de>
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

