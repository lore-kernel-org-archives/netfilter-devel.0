Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F4733DEFC;
	Fri,  1 May 2026 12:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777638166; cv=none; b=QTD+Q/xYDEPvmPijZ2FTeobdptXnnID0aZaRPH2MWYMHO/CjsFB1mEhbqWLUTjuxblOkTVN0EO29lQ2KBzo7FuzvsRyFaM0Yr2/CBeyHUJ5lCrhhwJsTiZvEz7DNZcD73pPQQMYGuqjdPLJww20UYHLKIqVs5WgwuLgCjPCq7WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777638166; c=relaxed/simple;
	bh=bhiKm6M74xm031cVP6+ToqroBKbknE/Nv2ppBGtPndA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kt7z9KdyiGy1fpoWH7oGTjBc42m/hbAYCO3uBtY/iLRGDdaT/QHKi2ECjoHOLK+7SrEPyCJjvBgpLY2tCm4CHpKbLDydT5PY+/4FNkoU4PI7qGH9YhQMdUbFTjLn87rnu+YpnO0rdk5tp32VuDH3MJgGcHdW9tfRvoGrd7vg29Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vivOYYYa; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vivOYYYa"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3D5676017E;
	Fri,  1 May 2026 14:22:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777638163;
	bh=6Fbmlx9W1FFkks5H2o6ltT3KOGrIEtVpn4vAhzuEI7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vivOYYYanONMjDcIg2O57jlbHZMIwc0P6aMSgijIqgHSXNeJzl2K6f8Pis28adh6g
	 91rbsdS/S80gcMoy5UJQKfhNnzdIbKKtRqfBh9rDsuNmpJ4T47ZLxUXoaPb3WzeF5c
	 VcOZawwygriGeeqS0ASWAYRJ7GdQQKbzLHdOK57q32kPK4s4ZYDsDU85alhASSDMVo
	 8c2UzhpLaaImJuGrERP2JNyG2YpmjyOJoqZZnwGfIwcWig7wgHB3ZWqZ2IU1AJqJ1M
	 tIT8CloORRceSbwuXlwvW6jj0nfjYkgN8K88ZCLyYIt+mXiNk1k8r9UsU3kuu2vGp8
	 mdzwHwIzI0gpA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 01/14] netfilter: replace skb_try_make_writable() by skb_ensure_writable()
Date: Fri,  1 May 2026 14:22:24 +0200
Message-ID: <20260501122237.296262-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260501122237.296262-1-pablo@netfilter.org>
References: <20260501122237.296262-1-pablo@netfilter.org>
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
to include the mac header. The flowtable is fine since it already uses
the transport offset.

Fixes: d32de98ea70f ("netfilter: nft_fwd_netdev: allow to forward packets via neighbour layer")
Fixes: 7d2086871762 ("netfilter: nf_flow_table: move ipv4 offload hook code to nf_flow_table")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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
index 4bce36c3a6a0..2cc809303ce8 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -100,6 +100,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 	int oif = regs->data[priv->sreg_dev];
 	unsigned int verdict = NF_STOLEN;
 	struct sk_buff *skb = pkt->skb;
+	int nhoff = skb_network_offset(skb);
 	struct net_device *dev;
 	int neigh_table;
 
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

