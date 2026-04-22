Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFED329E79
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Apr 2026 09:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776851092; cv=none; b=Db9zWLJyOKsY/E4Bw2oEbk3hk2isfIpBoNm5eEyrMANW5JjDdkz6hZ6kLgXnzebrab4x4waMvBrhY5iHGZu20P5C1wiRq9NB7uPFrhK0XExnh7EJu8MSkwe4cMwkA1Cp7gnm2sNAR1v6l/iI6fzh+0WbKUE9TD9ueieMtT5RIxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776851092; c=relaxed/simple;
	bh=SwwR4LLGQ9t/T+Zx6MQR9NAQu4Rl7qqkiCWkkk8W+7U=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=mxT3BIct1snN/6gE2v71rkqlFAEEEnLs2pZz++n6Thc6gRgXY7jsWJH24zNcLgmqwwnXZbcBtag5jyo7dAppf8Ea+oqr/3d55xc4f0n+k4wVCJ1CaZwy+gq2b8Ib+ZYZeNi9yZ0dG8DrrbU9GbXpNu4HW8NUIrV3AX9Hrt6QFoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GsWv3p5t; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GsWv3p5t"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8F6D5600B9
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Apr 2026 11:44:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776851088;
	bh=C9X1uafuiWZLMlltcrL5HhxfZLBVc7P5ipF+/AJdayA=;
	h=From:To:Subject:Date:From;
	b=GsWv3p5tKOmLM+tlph9d952wgVqd9l2zn/5IRMEeNBtsQaWwq04P3ttkzoDdjsAF0
	 zDr4t17nLur2lABdR+zJW/n/GcH3sZr7bJuiYZoSdnyKCh45t9Ckdh/CDHKKxhWZ11
	 qsyRpardquUOTx034fPSN26pv7vjXQ7oY86n3yZlpSmZe0a5Z79Nt9Y+LRnQBlGtQT
	 djIWZ4LbGGzIrJC/gFULSScAmLKKEBQNa37WA/8zExMWfCE7TYd1tXSAHWZBG4r5zm
	 Q+cOu/IpDONzs3U0jEUkAeYlnyp7oiSdyHpEIk8pOj9PMM1cmYofX7/U+/2RfLJfEX
	 IX6sDXjCxOlNQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2 1/3] netfilter: replace skb_try_make_writable() by skb_ensure_writable()
Date: Wed, 22 Apr 2026 11:44:42 +0200
Message-ID: <20260422094444.198178-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

skb_try_make_writable() only works on clones and uncloned packets might
have their network header in paged fragments.

nft_fwd needs to work for the ingress and egress hooks, but the egress
hook where skb->data points to the mac header, use skb_network_offset()
to deal include the mac header. The flowtable path only works in the
ingress hook, it does not need this same handling as nft_fwd does.

Fixes: d32de98ea70f ("netfilter: nft_fwd_netdev: allow to forward packets via neighbour layer")
Fixes: 7d2086871762 ("netfilter: nf_flow_table: move ipv4 offload hook code to nf_flow_table")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: - update ipv6 flowtable forwarding too to use skb_ensure_writable()
    - add skb_network_offset() to include mac header in nft_fwd so this
      works for egress path too.

 net/netfilter/nf_flow_table_ip.c | 4 ++--
 net/netfilter/nft_fwd_netdev.c   | 5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index fd56d663cb5b..dbd7644fdbeb 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -524,7 +524,7 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 		return 0;
 	}
 
-	if (skb_try_make_writable(skb, thoff + ctx->hdrsize))
+	if (skb_ensure_writable(skb, thoff + ctx->hdrsize))
 		return -1;
 
 	flow_offload_refresh(flow_table, flow, false);
@@ -1037,7 +1037,7 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 		return 0;
 	}
 
-	if (skb_try_make_writable(skb, thoff + ctx->hdrsize))
+	if (skb_ensure_writable(skb, thoff + ctx->hdrsize))
 		return -1;
 
 	flow_offload_refresh(flow_table, flow, false);
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 4bce36c3a6a0..516287ce7f9b 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -98,6 +98,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 	struct nft_fwd_neigh *priv = nft_expr_priv(expr);
 	void *addr = &regs->data[priv->sreg_addr];
 	int oif = regs->data[priv->sreg_dev];
+	int nhoff = skb_network_offset(skb);
 	unsigned int verdict = NF_STOLEN;
 	struct sk_buff *skb = pkt->skb;
 	struct net_device *dev;
@@ -111,7 +112,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 			verdict = NFT_BREAK;
 			goto out;
 		}
-		if (skb_try_make_writable(skb, sizeof(*iph))) {
+		if (skb_ensure_writable(skb, nhoff + sizeof(*iph))) {
 			verdict = NF_DROP;
 			goto out;
 		}
@@ -132,7 +133,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 			verdict = NFT_BREAK;
 			goto out;
 		}
-		if (skb_try_make_writable(skb, sizeof(*ip6h))) {
+		if (skb_ensure_writable(skb, nhoff + sizeof(*ip6h))) {
 			verdict = NF_DROP;
 			goto out;
 		}
-- 
2.47.3

