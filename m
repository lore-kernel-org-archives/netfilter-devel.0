Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B662411A0A;
	Mon, 10 Aug 2026 19:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786390851; cv=none; b=tFN2zQcWlAppTVyNvD4zxK7Bqz+r/qM6MZ9NZOnuIXHU54B7m70u/qgwgj6OepDVDkJ43u6X4PdULeqCr86m0G5yt0hc5mN4hPeStn7st9/MS2FqHwREF6OAKXpSPBPMELvSzzwuqp6N9NtvE2kkAIYGx21Lv8nz4LKCDRp1XdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786390851; c=relaxed/simple;
	bh=IdTeB6DNj9QJX9HsnYiTMODXiIglgfBMy4RRl1w+Yes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OhkFlzYQHBgFkv76cRM5PRtV1C+2Hrd9VlvsC4xecXiKzRBaqE+3IJuE5hxEqR1oPq85wmEXUHfwqC3uKGbaZ9Ilk/V/AXHj4wE+n78yLs9hNuIzi+lk/03GeR7M5zEuemAgepNa+xq17nj13f06KgVdqG9FSTU8TNzA2pTikLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=A3axtZLA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="A3axtZLA"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B6366601C0;
	Mon, 10 Aug 2026 21:40:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786390835;
	bh=LF3MtaZ6U1lAd/fAhIPgAH1LvciL6zCMVjH8neVND5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A3axtZLAk353cyHS00awTfCHcXitdJhk5KQw7DtUgIhd8gwokIzW/uf6QvPPEeWKt
	 nZDSu5n7JBDV4t/R9eJmOpGkI4Wv6c5UzZ+goxVnA4241YPODk5iY8xGG8lEU4AfZd
	 zj/fc+YOoj/AR+9zyjrUtR9N0tK6xVfsQATUQU9teDLrMv6nnZnVdNR+rE45S9O4Rq
	 0WdBpPJQDXpz/3u0c+4YGUn52Z7HxtDwoeWcwxwq47zl8CtbR3I4Po/UVTJBiOxifu
	 jZ3nlt8W9aTsSghIL2Rx5lqhKqBt5JjR5ymMsie0xWC6nMwslk9uhDRQ2i0J2HdXk6
	 YOnMVWwkGPCtQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 08/12] netfilter: flowtable: detach layer 2 encapsulation parser from lookup
Date: Mon, 10 Aug 2026 21:40:11 +0200
Message-ID: <20260810194015.932627-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260810194015.932627-1-pablo@netfilter.org>
References: <20260810194015.932627-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the layer 2 encapsulation header parser out of the lookup function
to prepare for IPv4 over IPv6 and SIT.

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index ff45f17f3c4a..c8c29a9a1684 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -459,12 +459,6 @@ nf_flow_offload_lookup(struct nf_flowtable_ctx *ctx,
 {
 	struct flow_offload_tuple tuple = {};
 
-	if (!nf_flow_skb_encap_protocol(ctx, skb))
-		return NULL;
-
-	if (unlikely(ctx->ether_type != htons(ETH_P_IP)))
-		return NULL;
-
 	if (nf_flow_tuple_ip(ctx, skb, &tuple) < 0)
 		return NULL;
 
@@ -877,6 +871,12 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	};
 	int ret;
 
+	if (!nf_flow_skb_encap_protocol(&ctx, skb))
+		return NF_ACCEPT;
+
+	if (unlikely(ctx.ether_type != htons(ETH_P_IP)))
+		return NF_ACCEPT;
+
 	tuplehash = nf_flow_offload_lookup(&ctx, flow_table, skb);
 	if (!tuplehash)
 		return NF_ACCEPT;
@@ -1117,12 +1117,6 @@ nf_flow_offload_ipv6_lookup(struct nf_flowtable_ctx *ctx,
 {
 	struct flow_offload_tuple tuple = {};
 
-	if (!nf_flow_skb_encap_protocol(ctx, skb))
-		return NULL;
-
-	if (unlikely(ctx->ether_type != htons(ETH_P_IPV6)))
-		return NULL;
-
 	if (nf_flow_tuple_ipv6(ctx, skb, &tuple) < 0)
 		return NULL;
 
@@ -1206,6 +1200,12 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	};
 	int ret;
 
+	if (!nf_flow_skb_encap_protocol(&ctx, skb))
+		return NF_ACCEPT;
+
+	if (unlikely(ctx.ether_type != htons(ETH_P_IPV6)))
+		return NF_ACCEPT;
+
 	tuplehash = nf_flow_offload_ipv6_lookup(&ctx, flow_table, skb);
 	if (!tuplehash)
 		return NF_ACCEPT;
-- 
2.47.3

