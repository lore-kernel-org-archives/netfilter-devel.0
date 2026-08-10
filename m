Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DC844331C;
	Mon, 10 Aug 2026 19:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786390851; cv=none; b=BeCDu5R+hKlL8ZtPzUScJIY92JqKDfLXbmZO0u11ll6O7JwMcF5ra2xCw0Z5fZDFUkRSYrjQhwu+rngPiz1R8v3CG1pzeh6urzXCIfHUCz7WgjKqp76hrIvPn8Hzy8fQ8XpOsm7G75vbOn3DJxJiPJdL7NOZiRF8/m60ywIWO8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786390851; c=relaxed/simple;
	bh=Jmg5XzpYC+l+9UxwjJYnt7T25lzFVjTzW1QLjH4Lals=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XiX1dCiH7QqO4y8Qntinv9tPjw8u+PkecdEy7AjAD9p4yoMHqG+/h0zEovil2kVRO1RQf/3UauwEfTlUwa9cwOsi96MJtvnFmnoupglevTd6f4FWWYQ5i93yhPFJGNkkawx4aTsUyug6BEpQ42kzMJYbnleIebQX3dGrUobCx+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=wEVVN9OJ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="wEVVN9OJ"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C6778601BC;
	Mon, 10 Aug 2026 21:40:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786390831;
	bh=QBk90xVOQKi0CCH+rG3f69+aGVYWA/Zm2Yok3nSXLXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wEVVN9OJL0PJJixeRnBBD2Sc0pbHluZvtGpTTVyIBpCBEY+9vofM4PxSeSrm2TP3N
	 X/LP3Fc89+ca3I5wF0v/1uy5gTZIgNtGJ8Ktx0ib3rUfYnZGlCBcJtlONXjTkEcP/c
	 Maj2kakJUKd9uk2kVYn8Q9CHimGafXb98fsUULfHtItHQncNKx/1VS98AvvsXG1R0x
	 yRpxFfG8uAuepeO1AUalKTODp1k34C5ZfDYULrROYe47B731cWmDd3P7DMZY7diN3v
	 qWQUCpuBrRQ3LMaxC7x6rQnVjnIRGMlI9QGpnwdPKEKZzSrjmt3HuSidE/Rpn35PXZ
	 f1Kt5DKvkcAjA==
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
Subject: [PATCH net-next 05/12] netfilter: flowtable: rename ctx.tun.proto to ctx.tun.inner_proto
Date: Mon, 10 Aug 2026 21:40:08 +0200
Message-ID: <20260810194015.932627-6-pablo@netfilter.org>
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

For consistency with the tun.l3proto rename, use same name field.
No functional changes are intended.

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index a03946a5c2e7..7692ae7aa853 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -153,7 +153,7 @@ struct nf_flowtable_ctx {
 		/* Tunnel IP header size */
 		u32 hdr_size;
 		/* IP tunnel protocol */
-		u8 proto;
+		u8 inner_proto;
 	} tun;
 };
 
@@ -194,7 +194,7 @@ static void nf_flow_tuple_encap(struct nf_flowtable_ctx *ctx,
 	switch (inner_proto) {
 	case htons(ETH_P_IP):
 		iph = (struct iphdr *)(skb_network_header(skb) + offset);
-		if (ctx->tun.proto == IPPROTO_IPIP) {
+		if (ctx->tun.inner_proto == IPPROTO_IPIP) {
 			tuple->tun.dst_v4.s_addr = iph->daddr;
 			tuple->tun.src_v4.s_addr = iph->saddr;
 			tuple->tun.inner_proto = IPPROTO_IPIP;
@@ -202,7 +202,7 @@ static void nf_flow_tuple_encap(struct nf_flowtable_ctx *ctx,
 		break;
 	case htons(ETH_P_IPV6):
 		ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
-		if (ctx->tun.proto == IPPROTO_IPV6) {
+		if (ctx->tun.inner_proto == IPPROTO_IPV6) {
 			tuple->tun.dst_v6 = ip6h->daddr;
 			tuple->tun.src_v6 = ip6h->saddr;
 			tuple->tun.inner_proto = IPPROTO_IPV6;
@@ -329,7 +329,7 @@ static bool nf_flow_ip4_tunnel_proto(struct nf_flowtable_ctx *ctx,
 		return false;
 
 	if (iph->protocol == IPPROTO_IPIP) {
-		ctx->tun.proto = iph->protocol;
+		ctx->tun.inner_proto = iph->protocol;
 		ctx->tun.hdr_size = size;
 		ctx->offset += ctx->tun.hdr_size;
 	}
@@ -354,7 +354,7 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flowtable_ctx *ctx,
 		return false;
 
 	if (ip6h->nexthdr == IPPROTO_IPV6) {
-		ctx->tun.proto = ip6h->nexthdr;
+		ctx->tun.inner_proto = ip6h->nexthdr;
 		ctx->tun.hdr_size = sizeof(*ip6h);
 		ctx->offset += ctx->tun.hdr_size;
 	}
@@ -368,8 +368,8 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flowtable_ctx *ctx,
 static void nf_flow_ip_tunnel_pop(struct nf_flowtable_ctx *ctx,
 				  struct sk_buff *skb)
 {
-	if (ctx->tun.proto != IPPROTO_IPIP &&
-	    ctx->tun.proto != IPPROTO_IPV6)
+	if (ctx->tun.inner_proto != IPPROTO_IPIP &&
+	    ctx->tun.inner_proto != IPPROTO_IPV6)
 		return;
 
 	skb_pull(skb, ctx->tun.hdr_size);
-- 
2.47.3

