Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A8F2D877A;
	Wed, 10 Jun 2026 16:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781108199; cv=none; b=uGBBC1vMzxpAXD8dN6e+6jLQXr1mxkEUrwB0mQ9Spmz6sRGeqbik1DnkLipNHwIC1ZBe40qSfE9uciORSiMrw/72GL5Ptqf49rJPRlgI9BJxCfc1IxwJK3G47z72Q65o0hrYSDKYbs9bmk4slKrr7MK+jJeOxjz6nwQHldfkx2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781108199; c=relaxed/simple;
	bh=zQ/gtcRUgNTLMbxojjmxcZlJvAss/i6Tv65StmTyrBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LyTvfMjzsUZZfC3Yz0wieK0+N3hYzG+6WXgg1hWbuyI7HaV0MejJUhgYnaniBdHcWBinA+qI/til6kyB/9PM0TWnHkWhhrPDYZTtUWtIokPvTuM1pAMg2SFOvvfYgOHaim+4zdcKYOjWLQ/ZzPDTStuk85PWWVgQsJ936oCDO7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gBYa9uHj; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gBYa9uHj"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B7B4E601BD;
	Wed, 10 Jun 2026 18:16:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781108196;
	bh=Y56sZ6oRlT62ETdu0hwz7Ce/xM3Ief31yEXajHM2cP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gBYa9uHjCLIAL90coUtU/1W+U4y/lLbA/bF3JP/pLIUiNAjlhl2VUhFiNyl5y5VsU
	 vCniWiaOBcuZo6JNJ00nBDkD/q3bfYEyqkbgsX2QXoTeRw9yDPxiUBHihloptnDG65
	 j4/WSFQ+Yp8AGWFfJKUVMHH3K/uijysL8FXCotzJ77o6Y2g+eArDCd9hP7JyPSq69K
	 uZprNmikBIcoBFnZQDLVzwEXvFLby5XZwIlSBSdANZj6+tvdm1XuWJrnfyMXk0TEKY
	 I6XppgxOAo/sL2D9NW4K32cPN+JJAL8O0kbDpAQGYhhYV6V6xYmBFgsnFc1A+lnKam
	 OY20Gg9gccQBQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 2/8] netfilter: nf_tables_offload: drop device refcount on error
Date: Wed, 10 Jun 2026 18:16:22 +0200
Message-ID: <20260610161629.214092-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260610161629.214092-1-pablo@netfilter.org>
References: <20260610161629.214092-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Reported by sashiko:
If nft_flow_action_entry_next() returns NULL, dev reference leaks.

Fixes: c6f85577584b ("netfilter: nf_tables_offload: add nft_flow_action_entry_next() and use it")
Reported-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_dup_netdev.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index 3b0a70e154cd..3d88ef927f31 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -74,16 +74,18 @@ int nft_fwd_dup_netdev_offload(struct nft_offload_ctx *ctx,
 	struct flow_action_entry *entry;
 	struct net_device *dev;
 
-	/* nft_flow_rule_destroy() releases the reference on this device. */
 	dev = dev_get_by_index(ctx->net, oif);
 	if (!dev)
 		return -EOPNOTSUPP;
 
 	entry = nft_flow_action_entry_next(ctx, flow);
-	if (!entry)
+	if (!entry) {
+		dev_put(dev);
 		return -E2BIG;
+	}
 
 	entry->id = id;
+	/* nft_flow_rule_destroy() releases the reference on this device. */
 	entry->dev = dev;
 
 	return 0;
-- 
2.47.3

