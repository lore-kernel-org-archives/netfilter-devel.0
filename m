Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF31218E91;
	Fri, 28 Nov 2025 00:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764289444; cv=none; b=qLACz2HcFelpGSjbXQxQfSZEwtbvSAB0hFY411Ig6emVhKt4yrcBrN53uLjIjXbA9ey6q/G2ngKqy85hajfmCwnMP3pvOjE5evTVSSv9gKYU599T1ZDxkyAP7oYkOWo/S1Z7Dtek8t1KGPCm9zpvbvj/kudtGIhffYzOt9rRh00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764289444; c=relaxed/simple;
	bh=iPK1tZPIwM2iz7NFPae808uZpwTMIuGVEbJ1BgK/5rY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNp9rnSH66HUFcgMSualHp1Q4ETif5BVr4PfET3AlvY0BvG2dYqfTXPV2+gSWGl0w/rNFRuLGwEliOHfud30tgNkyuTF0Vf/xPN8yJVlDknm0dqOE5ssITjHd9Q/P2w4tJ4atdxWOlW+62jqmOe92gFH7kxckaPQ2NDYXPS7/3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WTgcW9Vr; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WTgcW9Vr"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6894060275;
	Fri, 28 Nov 2025 01:23:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764289433;
	bh=WiXflUnXG2v2dzHPOIDGsAEUd9/+Ujbw2hWwElAWvnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WTgcW9VrKMyT+ivtlwsL/KEMfa5aAXgImWOsSlj/fDSWCh36bqKQHu1AtjQQ66tX8
	 IBPtCT4F8iT2ksmCodTYIjQt36xdttUKMYWu2qfkNSaFa+1sm3aghScyV0/yxdwiTB
	 8w35usT/zPv2RKp54GHSSUq1ahDlsqC5lp1QWhpx/glhctKJpAtY1gk/vkOJZLUjxE
	 6Lud6LHPThKLHoYBTDQ9RvXLkc+Y2cISnHf4guaJUaujInooBa3Hyc5b9bWu0SuXSY
	 Eusb61UVTNQseMacfB7F/8PRojSTbW0BrjBXnKlp0HS6gU/UxvJjzh6pM790EXf23g
	 mi+xFvNyQQIaA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 03/17] netfilter: flowtable: consolidate xmit path
Date: Fri, 28 Nov 2025 00:23:30 +0000
Message-ID: <20251128002345.29378-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128002345.29378-1-pablo@netfilter.org>
References: <20251128002345.29378-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use dev_queue_xmit() for the XMIT_NEIGH case. Store the interface index
of the real device behind the vlan/pppoe device, this introduces  an
extra lookup for the real device in the xmit path because rt->dst.dev
provides the vlan/pppoe device.

XMIT_NEIGH now looks more similar to XMIT_DIRECT but the check for stale
dst and the neighbour lookup still remain in place which is convenient
to deal with network topology changes.

Note that nft_flow_route() needs to relax the check for _XMIT_NEIGH so
the existing basic xfrm offload (which only works in one direction) does
not break.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |  1 +
 net/netfilter/nf_flow_table_core.c    |  1 +
 net/netfilter/nf_flow_table_ip.c      | 87 ++++++++++++++++-----------
 net/netfilter/nf_flow_table_path.c    |  7 +--
 4 files changed, 57 insertions(+), 39 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index e9f72d2558e9..7c330caae52b 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -141,6 +141,7 @@ struct flow_offload_tuple {
 	union {
 		struct {
 			struct dst_entry *dst_cache;
+			u32		ifidx;
 			u32		dst_cookie;
 		};
 		struct {
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 9441ac3d8c1a..98d7b3708602 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -132,6 +132,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
 	case FLOW_OFFLOAD_XMIT_NEIGH:
+		flow_tuple->ifidx = route->tuple[dir].out.ifindex;
 		flow_tuple->dst_cache = dst;
 		flow_tuple->dst_cookie = flow_offload_dst_cookie(flow_tuple);
 		break;
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 8cd4cf7ae211..eb4f6a11e779 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -333,19 +333,18 @@ static void nf_flow_encap_pop(struct sk_buff *skb,
 	}
 }
 
+struct nf_flow_xmit {
+	const void		*dest;
+	const void		*source;
+	struct net_device	*outdev;
+};
+
 static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
-				       const struct flow_offload_tuple_rhash *tuplehash,
-				       unsigned short type)
+				       struct nf_flow_xmit *xmit)
 {
-	struct net_device *outdev;
-
-	outdev = dev_get_by_index_rcu(net, tuplehash->tuple.out.ifidx);
-	if (!outdev)
-		return NF_DROP;
-
-	skb->dev = outdev;
-	dev_hard_header(skb, skb->dev, type, tuplehash->tuple.out.h_dest,
-			tuplehash->tuple.out.h_source, skb->len);
+	skb->dev = xmit->outdev;
+	dev_hard_header(skb, skb->dev, ntohs(skb->protocol),
+			xmit->dest, xmit->source, skb->len);
 	dev_queue_xmit(skb);
 
 	return NF_STOLEN;
@@ -424,10 +423,10 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	struct nf_flowtable_ctx ctx = {
 		.in	= state->in,
 	};
+	struct nf_flow_xmit xmit = {};
 	struct flow_offload *flow;
-	struct net_device *outdev;
+	struct neighbour *neigh;
 	struct rtable *rt;
-	__be32 nexthop;
 	int ret;
 
 	tuplehash = nf_flow_offload_lookup(&ctx, flow_table, skb);
@@ -454,25 +453,34 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rtable(tuplehash->tuple.dst_cache);
-		outdev = rt->dst.dev;
-		skb->dev = outdev;
-		nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
+		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.ifidx);
+		if (!xmit.outdev) {
+			flow_offload_teardown(flow);
+			return NF_DROP;
+		}
+		neigh = ip_neigh_gw4(rt->dst.dev, rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr));
+		if (IS_ERR(neigh)) {
+			flow_offload_teardown(flow);
+			return NF_DROP;
+		}
+		xmit.dest = neigh->ha;
 		skb_dst_set_noref(skb, &rt->dst);
-		neigh_xmit(NEIGH_ARP_TABLE, outdev, &nexthop, skb);
-		ret = NF_STOLEN;
 		break;
 	case FLOW_OFFLOAD_XMIT_DIRECT:
-		ret = nf_flow_queue_xmit(state->net, skb, tuplehash, ETH_P_IP);
-		if (ret == NF_DROP)
+		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
+		if (!xmit.outdev) {
 			flow_offload_teardown(flow);
+			return NF_DROP;
+		}
+		xmit.dest = tuplehash->tuple.out.h_dest;
+		xmit.source = tuplehash->tuple.out.h_source;
 		break;
 	default:
 		WARN_ON_ONCE(1);
-		ret = NF_DROP;
-		break;
+		return NF_DROP;
 	}
 
-	return ret;
+	return nf_flow_queue_xmit(state->net, skb, &xmit);
 }
 EXPORT_SYMBOL_GPL(nf_flow_offload_ip_hook);
 
@@ -719,9 +727,9 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	struct nf_flowtable_ctx ctx = {
 		.in	= state->in,
 	};
-	const struct in6_addr *nexthop;
+	struct nf_flow_xmit xmit = {};
 	struct flow_offload *flow;
-	struct net_device *outdev;
+	struct neighbour *neigh;
 	struct rt6_info *rt;
 	int ret;
 
@@ -749,24 +757,33 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rt6_info(tuplehash->tuple.dst_cache);
-		outdev = rt->dst.dev;
-		skb->dev = outdev;
-		nexthop = rt6_nexthop(rt, &flow->tuplehash[!dir].tuple.src_v6);
+		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.ifidx);
+		if (!xmit.outdev) {
+			flow_offload_teardown(flow);
+			return NF_DROP;
+		}
+		neigh = ip_neigh_gw6(rt->dst.dev, rt6_nexthop(rt, &flow->tuplehash[!dir].tuple.src_v6));
+		if (IS_ERR(neigh)) {
+			flow_offload_teardown(flow);
+			return NF_DROP;
+		}
+		xmit.dest = neigh->ha;
 		skb_dst_set_noref(skb, &rt->dst);
-		neigh_xmit(NEIGH_ND_TABLE, outdev, nexthop, skb);
-		ret = NF_STOLEN;
 		break;
 	case FLOW_OFFLOAD_XMIT_DIRECT:
-		ret = nf_flow_queue_xmit(state->net, skb, tuplehash, ETH_P_IPV6);
-		if (ret == NF_DROP)
+		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
+		if (!xmit.outdev) {
 			flow_offload_teardown(flow);
+			return NF_DROP;
+		}
+		xmit.dest = tuplehash->tuple.out.h_dest;
+		xmit.source = tuplehash->tuple.out.h_source;
 		break;
 	default:
 		WARN_ON_ONCE(1);
-		ret = NF_DROP;
-		break;
+		return NF_DROP;
 	}
 
-	return ret;
+	return nf_flow_queue_xmit(state->net, skb, &xmit);
 }
 EXPORT_SYMBOL_GPL(nf_flow_offload_ipv6_hook);
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index e525e3745651..e0c69fea2e0c 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -211,11 +211,11 @@ static void nft_dev_forward_path(struct nf_flow_route *route,
 	}
 	route->tuple[!dir].in.num_encaps = info.num_encaps;
 	route->tuple[!dir].in.ingress_vlans = info.ingress_vlans;
+	route->tuple[dir].out.ifindex = info.outdev->ifindex;
 
 	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
 		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
 		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
-		route->tuple[dir].out.ifindex = info.outdev->ifindex;
 		route->tuple[dir].out.hw_ifindex = info.hw_outdev->ifindex;
 		route->tuple[dir].xmit_type = info.xmit_type;
 	}
@@ -263,11 +263,10 @@ int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,
 	nft_default_forward_path(route, this_dst, dir);
 	nft_default_forward_path(route, other_dst, !dir);
 
-	if (route->tuple[dir].xmit_type	== FLOW_OFFLOAD_XMIT_NEIGH &&
-	    route->tuple[!dir].xmit_type == FLOW_OFFLOAD_XMIT_NEIGH) {
+	if (route->tuple[dir].xmit_type	== FLOW_OFFLOAD_XMIT_NEIGH)
 		nft_dev_forward_path(route, ct, dir, ft);
+	if (route->tuple[!dir].xmit_type == FLOW_OFFLOAD_XMIT_NEIGH)
 		nft_dev_forward_path(route, ct, !dir, ft);
-	}
 
 	return 0;
 }
-- 
2.47.3

