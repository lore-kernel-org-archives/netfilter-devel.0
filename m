Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F18C2FD665;
	Wed, 28 Jan 2026 15:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614934; cv=none; b=XM+jk5H7vwvAFfPJkiRZNk6JbaLJ55qw7eQf1FkhbU2pnD6XROI2QSJdo1QSvskshgDExMJ9j3xpJGFe9f+ihSmYGErAWzSWCXeje6fHCUI0G+6VqQAxvBN6LP+ULVRcMC5QaT8QHo+T8rvixlmorGSmw/Yg2jypBCa2Md034O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614934; c=relaxed/simple;
	bh=AChJVcIGe86kCMPNQotUohEzisSPoNNoAaOcn1LctMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dz802664ymTIcFioak/iXtv0kYzrGZcextRjczDtCk1RIRkiwGNGZJhsPQSoVn5Wzd9ScAcEEtBHLQHsr/1oU+3Su2K06o2+qXvVl5T9fW7sYkAX+PnMxT06zvuFujZUJKY34kQ+NZxkbX31VqYOxRxl1bqw55hJF2GLJPmVE1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 776AC60520; Wed, 28 Jan 2026 16:42:11 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 3/9] netfilter: flowtable: Add IP6IP6 rx sw acceleration
Date: Wed, 28 Jan 2026 16:41:49 +0100
Message-ID: <20260128154155.32143-4-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128154155.32143-1-fw@strlen.de>
References: <20260128154155.32143-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo@kernel.org>

Introduce sw acceleration for rx path of IP6IP6 tunnels relying on the
netfilter flowtable infrastructure. Subsequent patches will add sw
acceleration for IP6IP6 tunnels tx path.
IP6IP6 rx sw acceleration can be tested running the following scenario
where the traffic is forwarded between two NICs (eth0 and eth1) and an
IP6IP6 tunnel is used to access a remote site (using eth1 as the underlay
device):

ETH0 -- TUN0 <==> ETH1 -- [IP network] -- TUN1 (2001:db8:3::2)

$ip addr show
6: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:00:22:33:11:55 brd ff:ff:ff:ff:ff:ff
    inet6 2001:db8:1::2/64 scope global nodad
       valid_lft forever preferred_lft forever
7: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:11:22:33:11:55 brd ff:ff:ff:ff:ff:ff
    inet6 2001:db8:2::1/64 scope global nodad
       valid_lft forever preferred_lft forever
8: tun0@NONE: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1480 qdisc noqueue state UNKNOWN group default qlen 1000
    link/tunnel6 2001:db8:2::1 peer 2001:db8:2::2 permaddr ce9c:2940:7dcc::
    inet6 2002:db8:1::1/64 scope global nodad
       valid_lft forever preferred_lft forever

$ip -6 route show
2001:db8:1::/64 dev eth0 proto kernel metric 256 pref medium
2001:db8:2::/64 dev eth1 proto kernel metric 256 pref medium
2002:db8:1::/64 dev tun0 proto kernel metric 256 pref medium
default via 2002:db8:1::2 dev tun0 metric 1024 pref medium

$nft list ruleset
table inet filter {
        flowtable ft {
                hook ingress priority filter
                devices = { eth0, eth1 }
        }

        chain forward {
                type filter hook forward priority filter; policy accept;
                meta l4proto { tcp, udp } flow add @ft
        }
}

Reproducing the scenario described above using veths I got the following
results:
- TCP stream received from the IPIP tunnel:
  - net-next: (baseline)                  ~ 81Gbps
  - net-next + IP6IP6 flowtbale support:  ~112Gbps

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv6/ip6_tunnel.c            | 27 +++++++++++
 net/netfilter/nf_flow_table_ip.c | 83 +++++++++++++++++++++++++++-----
 2 files changed, 97 insertions(+), 13 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index c1f39735a236..f68f6f110a3e 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1828,6 +1828,32 @@ int ip6_tnl_encap_setup(struct ip6_tnl *t,
 }
 EXPORT_SYMBOL_GPL(ip6_tnl_encap_setup);
 
+static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
+				     struct net_device_path *path)
+{
+	struct ip6_tnl *t = netdev_priv(ctx->dev);
+	struct flowi6 fl6 = {
+		.daddr = t->parms.raddr,
+	};
+	struct dst_entry *dst;
+	int err;
+
+	dst = ip6_route_output(dev_net(ctx->dev), NULL, &fl6);
+	if (!dst->error) {
+		path->type = DEV_PATH_TUN;
+		path->tun.src_v6 = t->parms.laddr;
+		path->tun.dst_v6 = t->parms.raddr;
+		path->tun.l3_proto = IPPROTO_IPV6;
+		path->dev = ctx->dev;
+		ctx->dev = dst->dev;
+	}
+
+	err = dst->error;
+	dst_release(dst);
+
+	return err;
+}
+
 static const struct net_device_ops ip6_tnl_netdev_ops = {
 	.ndo_init	= ip6_tnl_dev_init,
 	.ndo_uninit	= ip6_tnl_dev_uninit,
@@ -1836,6 +1862,7 @@ static const struct net_device_ops ip6_tnl_netdev_ops = {
 	.ndo_change_mtu = ip6_tnl_change_mtu,
 	.ndo_get_stats64 = dev_get_tstats64,
 	.ndo_get_iflink = ip6_tnl_get_iflink,
+	.ndo_fill_forward_path = ip6_tnl_fill_forward_path,
 };
 
 #define IPXIPX_FEATURES (NETIF_F_SG |		\
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index ddfaddfa57be..51c64b3d4e50 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -156,12 +156,14 @@ struct nf_flowtable_ctx {
 	} tun;
 };
 
-static void nf_flow_tuple_encap(struct sk_buff *skb,
+static void nf_flow_tuple_encap(struct nf_flowtable_ctx *ctx,
+				struct sk_buff *skb,
 				struct flow_offload_tuple *tuple)
 {
 	__be16 inner_proto = skb->protocol;
 	struct vlan_ethhdr *veth;
 	struct pppoe_hdr *phdr;
+	struct ipv6hdr *ip6h;
 	struct iphdr *iph;
 	u16 offset = 0;
 	int i = 0;
@@ -188,13 +190,25 @@ static void nf_flow_tuple_encap(struct sk_buff *skb,
 		break;
 	}
 
-	if (inner_proto == htons(ETH_P_IP)) {
+	switch (inner_proto) {
+	case htons(ETH_P_IP):
 		iph = (struct iphdr *)(skb_network_header(skb) + offset);
-		if (iph->protocol == IPPROTO_IPIP) {
+		if (ctx->tun.proto == IPPROTO_IPIP) {
 			tuple->tun.dst_v4.s_addr = iph->daddr;
 			tuple->tun.src_v4.s_addr = iph->saddr;
 			tuple->tun.l3_proto = IPPROTO_IPIP;
 		}
+		break;
+	case htons(ETH_P_IPV6):
+		ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
+		if (ctx->tun.proto == IPPROTO_IPV6) {
+			tuple->tun.dst_v6 = ip6h->daddr;
+			tuple->tun.src_v6 = ip6h->saddr;
+			tuple->tun.l3_proto = IPPROTO_IPV6;
+		}
+		break;
+	default:
+		break;
 	}
 }
 
@@ -265,7 +279,7 @@ static int nf_flow_tuple_ip(struct nf_flowtable_ctx *ctx, struct sk_buff *skb,
 	tuple->l3proto		= AF_INET;
 	tuple->l4proto		= ipproto;
 	tuple->iifidx		= ctx->in->ifindex;
-	nf_flow_tuple_encap(skb, tuple);
+	nf_flow_tuple_encap(ctx, skb, tuple);
 
 	return 0;
 }
@@ -328,10 +342,45 @@ static bool nf_flow_ip4_tunnel_proto(struct nf_flowtable_ctx *ctx,
 	return true;
 }
 
-static void nf_flow_ip4_tunnel_pop(struct nf_flowtable_ctx *ctx,
-				   struct sk_buff *skb)
+static bool nf_flow_ip6_tunnel_proto(struct nf_flowtable_ctx *ctx,
+				     struct sk_buff *skb)
 {
-	if (ctx->tun.proto != IPPROTO_IPIP)
+#if IS_ENABLED(CONFIG_IPV6)
+	struct ipv6hdr *ip6h, _ip6h;
+	__be16 frag_off;
+	u8 nexthdr;
+	int hdrlen;
+
+	ip6h = skb_header_pointer(skb, ctx->offset, sizeof(*ip6h), &_ip6h);
+	if (!ip6h)
+		return false;
+
+	if (ip6h->hop_limit <= 1)
+		return false;
+
+	nexthdr = ip6h->nexthdr;
+	hdrlen = ipv6_skip_exthdr(skb, sizeof(*ip6h) + ctx->offset, &nexthdr,
+				  &frag_off);
+	if (hdrlen < 0)
+		return false;
+
+	if (nexthdr == IPPROTO_IPV6) {
+		ctx->tun.hdr_size = hdrlen;
+		ctx->tun.proto = IPPROTO_IPV6;
+	}
+	ctx->offset += ctx->tun.hdr_size;
+
+	return true;
+#else
+	return false;
+#endif /* IS_ENABLED(CONFIG_IPV6) */
+}
+
+static void nf_flow_ip_tunnel_pop(struct nf_flowtable_ctx *ctx,
+				  struct sk_buff *skb)
+{
+	if (ctx->tun.proto != IPPROTO_IPIP &&
+	    ctx->tun.proto != IPPROTO_IPV6)
 		return;
 
 	skb_pull(skb, ctx->tun.hdr_size);
@@ -366,8 +415,16 @@ static bool nf_flow_skb_encap_protocol(struct nf_flowtable_ctx *ctx,
 		break;
 	}
 
-	if (inner_proto == htons(ETH_P_IP))
+	switch (inner_proto) {
+	case htons(ETH_P_IP):
 		ret = nf_flow_ip4_tunnel_proto(ctx, skb);
+		break;
+	case htons(ETH_P_IPV6):
+		ret = nf_flow_ip6_tunnel_proto(ctx, skb);
+		break;
+	default:
+		break;
+	}
 
 	return ret;
 }
@@ -399,8 +456,9 @@ static void nf_flow_encap_pop(struct nf_flowtable_ctx *ctx,
 		}
 	}
 
-	if (skb->protocol == htons(ETH_P_IP))
-		nf_flow_ip4_tunnel_pop(ctx, skb);
+	if (skb->protocol == htons(ETH_P_IP) ||
+	    skb->protocol == htons(ETH_P_IPV6))
+		nf_flow_ip_tunnel_pop(ctx, skb);
 }
 
 struct nf_flow_xmit {
@@ -848,7 +906,7 @@ static int nf_flow_tuple_ipv6(struct nf_flowtable_ctx *ctx, struct sk_buff *skb,
 	tuple->l3proto		= AF_INET6;
 	tuple->l4proto		= nexthdr;
 	tuple->iifidx		= ctx->in->ifindex;
-	nf_flow_tuple_encap(skb, tuple);
+	nf_flow_tuple_encap(ctx, skb, tuple);
 
 	return 0;
 }
@@ -906,8 +964,7 @@ nf_flow_offload_ipv6_lookup(struct nf_flowtable_ctx *ctx,
 {
 	struct flow_offload_tuple tuple = {};
 
-	if (skb->protocol != htons(ETH_P_IPV6) &&
-	    !nf_flow_skb_encap_protocol(ctx, skb, htons(ETH_P_IPV6)))
+	if (!nf_flow_skb_encap_protocol(ctx, skb, htons(ETH_P_IPV6)))
 		return NULL;
 
 	if (nf_flow_tuple_ipv6(ctx, skb, &tuple) < 0)
-- 
2.52.0

