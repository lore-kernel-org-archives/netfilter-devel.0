Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A373E434E33
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2026 22:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786055749; cv=none; b=BSK8DIxDw2TdlP61RJUC4JFHCP3tErJ1lIrwMpwW94emmLSnV5unmP7PMbzctz2pzv+e/BqfiNLSEAv9wbjRjyEq1I7VwHAL9TLf2i7x7G4hLnf2l9MQQLiRY1HZVE2qtf+KpT5ZtiFiWzpChKBLJGrQK2mFBJ+7mw1xrbD02Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786055749; c=relaxed/simple;
	bh=ceg0r1O4Z68rTbyRgBCa+rjPK5p+DFDu3gOYtLTdIrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ew0wQBg/QUrHIkLa+WxjM4J9YbVFJRlahBSOEJQ6s9mH7ofJ8kmZpHMZ33cjNMu2uO9eQJDJh9P90RjBtmR6Y8xg0mRCpg6tn4HplezOPt0Dtw368SKP+1V2pulDBXpR5fpkG+ug3ZIGDQ1WW2YJlgFq/xXh63BOVHro44gBICY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ht3c37Kh; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ht3c37Kh"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B2E8D601B1;
	Fri,  7 Aug 2026 00:35:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786055743;
	bh=5/FYOwOg3aXJL6XHBJt62rndNBYYtLNsi6trT7oCBeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ht3c37KhNZdtDhwOavoDNbnluPpbBffdvi9lDSB7YBDdPCcIyfAYD9cpKI/t8YwdJ
	 3dL+omXSQWIke5ouZOPVzl/7c/65wNNtkRuv0dGEM6qaCvOaC1v6RLfaTJmQI2WEh+
	 /74/rpvg9ucpbSHe93xGPf0u/iDc2ESrKZVylnlVjdz0Bs6vy9TALDbNj0CqHJmioW
	 6lSPoAblWwgtvIpIa6BB0V+EUkM/AnSTYsUfOoDOeCymV0ZLvF3pFix1FTsi+YPAUQ
	 VtBtZ61cOlLmXHZdJKUO7cG3D+LHGGcmMmc0lwGkhiQw86X5p1emeX/8K1CtTLtUwe
	 7JF1IzXkQFRMg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo.bianconi@oss.qualcomm.com,
	lorenzo@kernel.org
Subject: [PATCH nf-next 4/7] netfilter: flowtable: rename ctx.tun.proto to ctx.tun.inner_proto
Date: Fri,  7 Aug 2026 00:35:32 +0200
Message-ID: <20260806223535.523098-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260806223535.523098-1-pablo@netfilter.org>
References: <20260806223535.523098-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For consistency with the tun.l3proto rename, use same name field.
No functional changes are intended.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index e1aa01763f33..ed90809b206e 100644
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
@@ -328,7 +328,7 @@ static bool nf_flow_ip4_tunnel_proto(struct nf_flowtable_ctx *ctx,
 		return false;
 
 	if (iph->protocol == IPPROTO_IPIP) {
-		ctx->tun.proto = iph->protocol;
+		ctx->tun.inner_proto = iph->protocol;
 		ctx->tun.hdr_size = size;
 		ctx->offset += ctx->tun.hdr_size;
 	}
@@ -353,7 +353,7 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flowtable_ctx *ctx,
 		return false;
 
 	if (ip6h->nexthdr == IPPROTO_IPV6) {
-		ctx->tun.proto = ip6h->nexthdr;
+		ctx->tun.inner_proto = ip6h->nexthdr;
 		ctx->tun.hdr_size = sizeof(*ip6h);
 		ctx->offset += ctx->tun.hdr_size;
 	}
@@ -367,8 +367,8 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flowtable_ctx *ctx,
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

