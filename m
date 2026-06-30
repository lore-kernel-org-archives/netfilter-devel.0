Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59278387363
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Jun 2026 09:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782812463; cv=none; b=V9o+mG1zEPX0noBwkK7fcPMPXjaQw02klsYRv/ctMHv5UEzKPCXVyTiNjU6bQl9bf/OdI4cCEu5jKznshpFcGPfeZiKeLWpFKD/htFpP2KE3yeef25G/7re/L0+BFK9VZg7u9fSYATR5b99/DCwqVOECBeBjp9kiJY/TGt+pCU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782812463; c=relaxed/simple;
	bh=ZK/3X5HwtUZTT2y5eSThsR43sGrXLmjwdf5NWi0N63Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NXRJCSRf5xNUCt0Girjm7/UusYxVzR1BqHvReKtQfpLUjEHEjrkrqHv54pVoJID8kSzgksKsW7LJxdg+MZvgAKG2uYMbzwdWPTPNtTQEokw48oyYk/3MAmL211Dgg//G0MjUMDgOOFCOv6IQQ7iNitx3UYyz5bQibPn1dYFVeRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mFxdhZTs; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mFxdhZTs"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 33A026058B;
	Tue, 30 Jun 2026 11:41:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782812460;
	bh=FL9wofaTJkVtjFliZO7zb/AGDs0TeDDj2Dgk6r3H3t4=;
	h=From:To:Cc:Subject:Date:From;
	b=mFxdhZTsmeUuTxpKo/v3a3AF7Q3Cbh0+EYha5nKZwLTuuHUD8i6rd8BXwpLBe6j3V
	 JbGHeAgkW4TC1e3zU/Nozy1pQ9MOXAyNW4PQEESfGgwX76VMEUDHl7YYrNtcxM8V4P
	 +zlye553R+QvwfINooSQQEtYn8gym0QHAMCcJYWM5vQCADtBO4mC5J7aemJLz830y5
	 OAyugPOHogmlgH4HhWxoNrM7wEka7scXz7+jhxm2Ctv5+IItU4ftTY2TTe9IRsGhbO
	 jxrLdT25fQcCCC9VxpFmVvmpqwjG+Whe/Eh/U01zXHGDCsNo0Q1288NrVCvweaha7B
	 /UQm1jYHuqoGg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo@kernel.org,
	chzhengyang2023@lzu.edu.cn
Subject: [PATCH nf,v2 1/3] netfilter: flowtable: use dst in this direction when pushing IPIP header
Date: Tue, 30 Jun 2026 11:40:54 +0200
Message-ID: <20260630094056.97038-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When pushing the IPIP header, the route of the other direction is used
to calculate the headroom, use the route in this direction. Accessing
the other tuple to set the IP source and destination is fine because
this tuple does not provide such information to avoid storing redundant
information. However, this tuple already provides the dst for this
direction, this went unnoticed because this bug affects headroom and
iph->frag_off only at this stage.

Fixes: d30301ba4b07 ("netfilter: flowtable: Add IPIP tx sw acceleration")
Fixes: 93cf357fa797 ("netfilter: flowtable: Add IP6IP6 tx sw acceleration")
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes

 net/netfilter/nf_flow_table_ip.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 29e93ac1e2e4..089f2bc19972 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -590,10 +590,10 @@ static int nf_flow_pppoe_push(struct sk_buff *skb, u16 id,
 
 static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *skb,
 				    struct flow_offload_tuple *tuple,
-				    __be32 *ip_daddr)
+				    struct dst_entry *dst, __be32 *ip_daddr)
 {
 	struct iphdr *iph = (struct iphdr *)skb_network_header(skb);
-	struct rtable *rt = dst_rtable(tuple->dst_cache);
+	struct rtable *rt = dst_rtable(dst);
 	u8 tos = iph->tos, ttl = iph->ttl;
 	__be16 frag_off = iph->frag_off;
 	u32 headroom = sizeof(*iph);
@@ -636,21 +636,22 @@ static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *skb,
 
 static int nf_flow_tunnel_v4_push(struct net *net, struct sk_buff *skb,
 				  struct flow_offload_tuple *tuple,
-				  __be32 *ip_daddr)
+				  struct dst_entry *dst,  __be32 *ip_daddr)
 {
 	if (tuple->tun_num)
-		return nf_flow_tunnel_ipip_push(net, skb, tuple, ip_daddr);
+		return nf_flow_tunnel_ipip_push(net, skb, tuple, dst, ip_daddr);
 
 	return 0;
 }
 
 static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
 				      struct flow_offload_tuple *tuple,
+				      struct dst_entry *dst,
 				      struct in6_addr **ip6_daddr)
 {
 	struct ipv6hdr *ip6h = (struct ipv6hdr *)skb_network_header(skb);
-	struct rtable *rt = dst_rtable(tuple->dst_cache);
 	__u8 dsfield = ipv6_get_dsfield(ip6h);
+	struct rtable *rt = dst_rtable(dst);
 	struct flowi6 fl6 = {
 		.daddr = tuple->tun.src_v6,
 		.saddr = tuple->tun.dst_v6,
@@ -696,10 +697,11 @@ static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
 
 static int nf_flow_tunnel_v6_push(struct net *net, struct sk_buff *skb,
 				  struct flow_offload_tuple *tuple,
+				  struct dst_entry *dst,
 				  struct in6_addr **ip6_daddr)
 {
 	if (tuple->tun_num)
-		return nf_flow_tunnel_ip6ip6_push(net, skb, tuple, ip6_daddr);
+		return nf_flow_tunnel_ip6ip6_push(net, skb, tuple, dst, ip6_daddr);
 
 	return 0;
 }
@@ -842,7 +844,8 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	other_tuple = &flow->tuplehash[!dir].tuple;
 	ip_daddr = other_tuple->src_v4.s_addr;
 
-	if (nf_flow_tunnel_v4_push(state->net, skb, other_tuple, &ip_daddr) < 0)
+	if (nf_flow_tunnel_v4_push(state->net, skb, other_tuple,
+				   tuplehash->tuple.dst_cache, &ip_daddr) < 0)
 		return NF_DROP;
 
 	switch (tuplehash->tuple.xmit_type) {
@@ -1158,6 +1161,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	ip6_daddr = &other_tuple->src_v6;
 
 	if (nf_flow_tunnel_v6_push(state->net, skb, other_tuple,
+				   tuplehash->tuple.dst_cache,
 				   &ip6_daddr) < 0)
 		return NF_DROP;
 
-- 
2.47.3

