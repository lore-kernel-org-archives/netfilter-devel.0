Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA204218B1
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 14:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782743993; cv=none; b=dMPHrfXtEG2BkVGG1k8AwHSfB4Epqtq2ZljbfzppBbCqZRdT1sGgEGa/DuTvfJ+VdpCvGKfV+eHcoTo2c3ey2hLQkJBQNuTC6irsfGOC42jBEyuCgaisX3mXtVrViMR1X8mwe7qVebFcDHLJZTC9V1cxLV1TSA5vewx0P1pqwiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782743993; c=relaxed/simple;
	bh=lhxe+a9lkJEpxBQYJZDGuLrOGadBP3GaM/RM8E7+YK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0YANY+FaCYdnhfP64JcP8JA2V5C88DMeZaibeWddAd5unxn3cqEYdPx1GxRmVPhsFt4ysowvf/jbq9fToJDEHhInEZaFNOCiHvXfnzLLVXTueVQbFyXW9cLZlku+pIJxUg3BRuMje/KhouCKwaYIfxkY7EpsGBwPscFdy2kG3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kbjrb3md; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kbjrb3md"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0C02960589;
	Mon, 29 Jun 2026 16:39:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782743982;
	bh=X/hUXl0oZP3+IUOh7Ltflb3LYEP/ZhGd1eovIy6pFs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kbjrb3md9Kg7s+eIozIUt27eR82vANBmkf0XVGBBzYLd4BP48WFELiBKGHlpDKJFm
	 5u5taYjVARsooakXpOpQTFTA+Ia3oLixmnkQYYVqKQPx15MprefcRGWMuA6aFrK+g8
	 a/i32UUURWpn+YYaUgQQuOwQxg5vD8rs+iwg5UL3QVDjotqSY7cvIsS2jOElBKCbPt
	 0EM5PvHBvlJ4fJAeh/9NpTk6ztQ6AvvsCE4ZDw83KqR/DgJYxOwaQDmgpilTxWZS4M
	 xQhjVd30bX5kInANIk6M+ihi3JpAEB6T7ssyL1td0sjx2Zt2TaHofRZvTVZYhm00Sy
	 0tto5Lgn7CvxQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: chzhengyang2023@lzu.edu.cn,
	lorenzo@kernel.org
Subject: [PATCH nf 1/3] netfilter: flowtable: use dst in this direction when pushing IPIP header
Date: Mon, 29 Jun 2026 16:39:34 +0200
Message-ID: <20260629143936.61239-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629143936.61239-1-pablo@netfilter.org>
References: <20260629143936.61239-1-pablo@netfilter.org>
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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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

