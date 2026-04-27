Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F97931F98B
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2026 15:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777302308; cv=none; b=i8geO6Hsa2DrcuOTTAkSsZ2YEwMFsHjObfgz/wTjfMT9UiwKwbh9iKPCncsBZoo9VA2IsjatypNEciQWMXaR8wL5Lb1+iPM5pGv8BasnBIelL6OtqjAyChOH2vnrE/T07tsdGDPWGxGqWi/FByT3oS5TlFk/Q1UY0vzbVLzhbns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777302308; c=relaxed/simple;
	bh=+o9lRJiwLvjUUTVmmChwvZpLGipGAkQRAeqR7pf/n08=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMXbIQwziBTH1MOhcuAL0VtpWMwVAx5q2ogAbaGFrAb/oIxnXL7ml+4SR5OFszURXC3s5zbnel2NwS5JKIsLFa717t8DGTpbxgkr4NIjrAqhFaJ9opI8tLJ0u1c/p1+JnnFOKEHCUOebpMVM910bYmA9mnxZRHfljozJROLaigo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dgpudO23; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dgpudO23"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9B7DA60254
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2026 17:05:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777302304;
	bh=DTm8/y9EdR+sWf0X9Kb/4I/BsEC7MdwNf2XTVP9IoF8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=dgpudO23sjg+ZsjECcSxRZhD7M7SJFTwETQcVqWGF4x6JUJaOA9Iutx7tHO2R2Mg+
	 J3w+4wgdGi6DNGvSer62zwkNQEam5b5Syvm9iedoVGsAi325HvI/Q1X5RiDein9oAv
	 TwZCYByN4boUblnUOek7lia4Ps0ARuLDPREh08KBFJoWCmh0w0Jl1UsW31+jwaCFli
	 NOrKOfNXeN7I1TxGKMo1OF20+nf1Jj6JQNfCKGyN/PyZQYIn6Fy2HdXrUJVwYyiyHT
	 Ly7sVDCtrCZlKozvxeN6MeZHbjG/ZaQSxsjL0+ZxJs1QJMfv8HI7tquiDtemTyN6H2
	 +hbGaU1fzYWlQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v6 2/3] netfilter: nft_fwd_netdev: add device and headroom validate with neigh forwarding
Date: Mon, 27 Apr 2026 17:04:59 +0200
Message-ID: <20260427150500.13754-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260427150500.13754-1-pablo@netfilter.org>
References: <20260427150500.13754-1-pablo@netfilter.org>
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

Moreover, check for headroom and call skb_expand_head() like in the IP
output path to ensure there is sufficient headroom when forwarding this
via neigh_xmit().

Fixes: d32de98ea70f ("netfilter: nft_fwd_netdev: allow to forward packets via neighbour layer")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v6: use similar idiom that is used in the IP output path.

 net/netfilter/nft_fwd_netdev.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 2cc809303ce8..c484a757cfb5 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -102,6 +102,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 	struct sk_buff *skb = pkt->skb;
 	int nhoff = skb_network_offset(skb);
 	struct net_device *dev;
+	unsigned int hh_len;
 	int neigh_table;
 
 	switch (priv->nfproto) {
@@ -153,8 +154,19 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 	}
 
 	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
-	if (dev == NULL)
-		return;
+	if (dev == NULL) {
+		verdict = NF_DROP;
+		goto out;
+	}
+
+	hh_len = LL_RESERVED_SPACE(dev);
+	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
+		skb = skb_expand_head(skb, hh_len);
+		if (!skb) {
+			verdict = NF_DROP;
+			goto out;
+		}
+	}
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
-- 
2.47.3

