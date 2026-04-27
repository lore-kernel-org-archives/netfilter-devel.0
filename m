Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA3A322527
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2026 15:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777302307; cv=none; b=BsYNkqjF4vV+so0OSqAbCklW9mxjQWIw6UE6MjncLLaI2qiNRDtTesyfypYoMZTsr6M173ksHIgWiM9+tfhKi87thJ3PjwHHQ4HI5gRH9iMc9xRgtH/eZQakxYhhzcpJKZ5hz1HsR7mEGpZ6aXWJ7FsiMV6YmH4YQ6rLRtWN56Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777302307; c=relaxed/simple;
	bh=GExkixpSy0Tc9Bs1MPUi6H8QuO2zghzq6iRs0ynBpK0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=EC7N+4wRMZRsMMo8TDWxZaBkB8DgRBbPp+C3QAyAa1V7vhvrO6aaXvYiWZH37f5/AXJe6+9+qDCIvd1K+ASpyWMaKzedAT2QekM2WZg5JkBJ3T7ZV6x5wXO1iJkr5zKBR6BevcZ7uovmNJ7bCf2xaK93obdW0O6XT97lFQjfseU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lLpofRDl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lLpofRDl"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9E5B760178
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2026 17:05:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777302303;
	bh=l2ZZU+mRkXoa4cz3nO+vTZTAGRtHiVpmWLmYIBXn0Q8=;
	h=From:To:Subject:Date:From;
	b=lLpofRDlnxWMGluB7TSiD40fzYxVNbkJ81RJf8j9nL/RZS4WggC7LgkvyZPDWpR7z
	 f5pc/ISGqyTBwbtgbPpk4G7HvOvzA1kBCiLYX3eB/ZTg883jrAV3BpBRCSuLkYf7d6
	 UHqNBD8fnCBPmord1bYKn9qqH9dTkKz51Pes1xh492DeHgf810oAVjsYGEqhFqwRdC
	 OPQzFa7tzZeMOJYwYblGL/PjOVBIcRWdw8Y9YmqniSyQhWrhVGirmzqQuCSoGea7SG
	 hZPYbAezeEezQQxjfsODNzdTTIU1WKFpAuEC7BYqzPMzLR4gRPkBQVLq8vTuDErPFN
	 D3FFFm5V4gM8A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v6 1/3] netfilter: nft_fwd_netdev: add device and headroom validate with neigh forwarding
Date: Mon, 27 Apr 2026 17:04:58 +0200
Message-ID: <20260427150500.13754-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
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
v6: no changes

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

