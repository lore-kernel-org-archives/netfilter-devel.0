Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109D83B637A
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2026 12:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777293427; cv=none; b=Z/6Pe8M4ahBbkrH4oSljKSwfgCqf7ZKtJuwUHt9aamOfBYq3LnyK8mcOyLAoFMFWP0hdde9YpRtLA4AMgFL96f/E4QrsDCKrGwy1nckmrx+nhRPBsOFTs2vOYq49GG6I754fHRmt1WQdnhESqgg8MubWeil6J9Uvdm03rDA/PVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777293427; c=relaxed/simple;
	bh=YAHDj6OrMxAA7NeBV0yqj38YpnxdAl8VWbsE+s1EVEk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1EHyoWzEYo6V6DRhiTbNzZtXThzbGtBPVnUgVur3A3BBgoZ7xX4ChpJOfecCZCms7zDO5FDtPKRWUm3TtdOdistR5fnFdh6u4nIrAYyxpGVGzoqWFj6wEJPgIkEZjxnfujuUhmQWc7JNb5l595HJxrPfl1cpYCLr0xiFe9Yt/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rALDie6K; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rALDie6K"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3C1FC60181
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2026 14:36:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777293419;
	bh=IYahGO1JvXj4O7AaxKnasc2U4IVAPVVPf90rIZQP5bA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=rALDie6KzyPFYrA0+PlgKxxoq0Z0NKY44oE8kAjsfaGdxyNtuWmvtxDRUkcmNakGh
	 OiGUwvcOLjZuHpyMlr5YKp7X9BHRKjAuGMscjK8DXqQE72GnfRpOQzEnWMAESaLx6M
	 47Nbo8RYeTFkq03rJ6i3NZxfoBGchc+ZrlH5XygiCX6sDrzVhsRHjv0bnnLjkGQEZI
	 VvBJxzVJ3tch5U8gQShJXuu04Df1pxljJaHCd4qjIJgrBSr2KH3tii88rLJsdYtadc
	 DEWBdDuyJofaVDFLeNP5UjeOUh16VSfH5J2iqN1hHf1ZNGP0Ms639MXtYy8PWONXUH
	 ONg5LW2idbw6g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v5 2/3] netfilter: nft_fwd_netdev: add device and headroom validate with neigh forwarding
Date: Mon, 27 Apr 2026 14:36:52 +0200
Message-ID: <20260427123653.9103-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260427123653.9103-1-pablo@netfilter.org>
References: <20260427123653.9103-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ttl field has been decremented already and evaluation of this rule
would proceed, just drop this packet instead if there is no destination
device to forwards this packet. This is exactly what nf_dup already does
in this case.

Moreover, use skb_cow_head() to ensure there is sufficient headroom when
forwarding this via neigh_xmit().

Fixes: d32de98ea70f ("netfilter: nft_fwd_netdev: allow to forward packets via neighbour layer")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v5: rewrite patch title and add skb_cow_head() call

 net/netfilter/nft_fwd_netdev.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 2cc809303ce8..94d6397f10a8 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -153,8 +153,15 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 	}
 
 	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
-	if (dev == NULL)
-		return;
+	if (dev == NULL) {
+		verdict = NF_DROP;
+		goto out;
+	}
+
+	if (skb_cow_head(skb, LL_RESERVED_SPACE(dev))) {
+		verdict = NF_DROP;
+		goto out;
+	}
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
-- 
2.47.3

