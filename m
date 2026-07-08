Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556EA4218B6;
	Wed,  8 Jul 2026 14:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783519444; cv=none; b=p5XM7B1OKkRHw+88e9OuOs4+gOdPR4i8qws5uge7MlXOfQH+Hh8FBirIL59e94u8m8OC+N4CEOwccn+oysgAmj429CLS4cWkgnyMseyHNy8NneuDCFz/NlY+OW9gaeP+qn3GRP/2vgx6tTZjXJz5K6THkghPZh9gKyza7dPiZaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783519444; c=relaxed/simple;
	bh=9KYFpw/ED8UYnIoYqC4JydgklQ2i+NLm/DzGieNc5NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cycDosJ70LZNSehNr90xzZBX2KTDSYmcpCXV+1nPKtnpj5pT7W/Chd3IvvZ/o6LnOcmeKd4GjBdjHiQSKbJjlcFBI5Z7/74CHu5dohbkrDhppd12cpFG7C0HG1MBPdWnMVKoCrGK0mheXkJtqyvCw/92rEOSREWkHtFAq54i+pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E142E607B9; Wed, 08 Jul 2026 16:04:01 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 10/17] netfilter: flowtable: use dst in this direction when pushing IPIP header
Date: Wed,  8 Jul 2026 16:03:02 +0200
Message-ID: <20260708140309.19633-11-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260708140309.19633-1-fw@strlen.de>
References: <20260708140309.19633-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

When pushing the IPIP header, the route of the other direction is used
to calculate the headroom, use the route in this direction. Accessing
the other tuple to set the IP source and destination is fine because
this tuple does not provide such information to avoid storing redundant
information. However, this tuple already provides the dst for this
direction, this went unnoticed because this bug affects headroom and
iph->frag_off only at this stage.

Fixes: d30301ba4b07 ("netfilter: flowtable: Add IPIP tx sw acceleration")
Fixes: 93cf357fa797 ("netfilter: flowtable: Add IP6IP6 tx sw acceleration")
Cc: stable@vger.kernel.org
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.54.0

