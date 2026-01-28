Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047B22FD699;
	Wed, 28 Jan 2026 15:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614940; cv=none; b=trFW+7FV5y5cGypQ/SKKj7u98L4HajeQuvyMVqy6dUs4dNZxITY1/gpHEmsNIXtKqRN0GMziLDjSzC6xtK4h9sBvOvPHPu0iBr9pl/eIPFMx+YK7aOYcmhzeuZCK0ffL6zy6pQ6lZmSWwH/tKB06JQprJJ88fbm+KxgoZ54+vUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614940; c=relaxed/simple;
	bh=+FH7jnlEoHS41qVWaZ+yzrqv8JDXR7lupv6uILCo0To=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdHtqjB929P1tkJiBqWcn1YNyZPLhgcqd5xopDWHyCX5BRrqYTOiu+Crf+fpvZSNoM7eTYe8K2naWTJuVVoMX0qNlUhbCfOHPkUqSjWq1Q92be51xyy5VBG2z1sK2AO+0fg3wwipxp9eOD3+NaRJ8kPeQNvq0I2GGl33c+kT4qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D2A3960520; Wed, 28 Jan 2026 16:42:15 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 4/9] netfilter: flowtable: Add IP6IP6 tx sw acceleration
Date: Wed, 28 Jan 2026 16:41:50 +0100
Message-ID: <20260128154155.32143-5-fw@strlen.de>
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

Introduce sw acceleration for tx path of IP6IP6 tunnels relying on the
netfilter flowtable infrastructure.
IP6IP6 tx sw acceleration can be tested running the following scenario
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
  - net-next: (baseline)                  ~93Gbps
  - net-next + IP6IP6 flowtbale support:  ~98Gbps

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_flow_table_ip.c | 108 ++++++++++++++++++++++++++++++-
 1 file changed, 106 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 51c64b3d4e50..3fdb10d9bf7f 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -14,6 +14,7 @@
 #include <net/ip.h>
 #include <net/ipv6.h>
 #include <net/ip6_route.h>
+#include <net/ip6_tunnel.h>
 #include <net/neighbour.h>
 #include <net/netfilter/nf_flow_table.h>
 #include <net/netfilter/nf_conntrack_acct.h>
@@ -637,6 +638,97 @@ static int nf_flow_tunnel_v4_push(struct net *net, struct sk_buff *skb,
 	return 0;
 }
 
+struct ipv6_tel_txoption {
+	struct ipv6_txoptions ops;
+	__u8 dst_opt[8];
+};
+
+static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
+				      struct flow_offload_tuple *tuple,
+				      struct in6_addr **ip6_daddr,
+				      int encap_limit)
+{
+	struct ipv6hdr *ip6h = (struct ipv6hdr *)skb_network_header(skb);
+	u8 hop_limit = ip6h->hop_limit, proto = IPPROTO_IPV6;
+	struct rtable *rt = dst_rtable(tuple->dst_cache);
+	__u8 dsfield = ipv6_get_dsfield(ip6h);
+	struct flowi6 fl6 = {
+		.daddr = tuple->tun.src_v6,
+		.saddr = tuple->tun.dst_v6,
+		.flowi6_proto = proto,
+	};
+	int err, mtu;
+	u32 headroom;
+
+	err = iptunnel_handle_offloads(skb, SKB_GSO_IPXIP6);
+	if (err)
+		return err;
+
+	skb_set_inner_ipproto(skb, proto);
+	headroom = sizeof(*ip6h) + LL_RESERVED_SPACE(rt->dst.dev) +
+		   rt->dst.header_len;
+	if (encap_limit)
+		headroom += 8;
+	err = skb_cow_head(skb, headroom);
+	if (err)
+		return err;
+
+	skb_scrub_packet(skb, true);
+	mtu = dst_mtu(&rt->dst) - sizeof(*ip6h);
+	if (encap_limit)
+		mtu -= 8;
+	mtu = max(mtu, IPV6_MIN_MTU);
+	skb_dst_update_pmtu_no_confirm(skb, mtu);
+
+	if (encap_limit > 0) {
+		struct ipv6_tel_txoption opt = {
+			.dst_opt[2] = IPV6_TLV_TNL_ENCAP_LIMIT,
+			.dst_opt[3] = 1,
+			.dst_opt[4] = encap_limit,
+			.dst_opt[5] = IPV6_TLV_PADN,
+			.dst_opt[6] = 1,
+		};
+		struct ipv6_opt_hdr *hopt;
+
+		opt.ops.dst1opt = (struct ipv6_opt_hdr *)opt.dst_opt;
+		opt.ops.opt_nflen = 8;
+
+		hopt = skb_push(skb, ipv6_optlen(opt.ops.dst1opt));
+		memcpy(hopt, opt.ops.dst1opt, ipv6_optlen(opt.ops.dst1opt));
+		hopt->nexthdr = IPPROTO_IPV6;
+		proto = NEXTHDR_DEST;
+	}
+
+	skb_push(skb, sizeof(*ip6h));
+	skb_reset_network_header(skb);
+
+	ip6h = ipv6_hdr(skb);
+	ip6_flow_hdr(ip6h, dsfield,
+		     ip6_make_flowlabel(net, skb, fl6.flowlabel, true, &fl6));
+	ip6h->hop_limit = hop_limit;
+	ip6h->nexthdr = proto;
+	ip6h->daddr = tuple->tun.src_v6;
+	ip6h->saddr = tuple->tun.dst_v6;
+	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(*ip6h));
+	IP6CB(skb)->nhoff = offsetof(struct ipv6hdr, nexthdr);
+
+	*ip6_daddr = &tuple->tun.src_v6;
+
+	return 0;
+}
+
+static int nf_flow_tunnel_v6_push(struct net *net, struct sk_buff *skb,
+				  struct flow_offload_tuple *tuple,
+				  struct in6_addr **ip6_daddr,
+				  int encap_limit)
+{
+	if (tuple->tun_num)
+		return nf_flow_tunnel_ip6ip6_push(net, skb, tuple, ip6_daddr,
+						  encap_limit);
+
+	return 0;
+}
+
 static int nf_flow_encap_push(struct sk_buff *skb,
 			      struct flow_offload_tuple *tuple)
 {
@@ -914,7 +1006,7 @@ static int nf_flow_tuple_ipv6(struct nf_flowtable_ctx *ctx, struct sk_buff *skb,
 static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 					struct nf_flowtable *flow_table,
 					struct flow_offload_tuple_rhash *tuplehash,
-					struct sk_buff *skb)
+					struct sk_buff *skb, int encap_limit)
 {
 	enum flow_offload_tuple_dir dir;
 	struct flow_offload *flow;
@@ -925,6 +1017,12 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
 	mtu = flow->tuplehash[dir].tuple.mtu + ctx->offset;
+	if (flow->tuplehash[!dir].tuple.tun_num) {
+		mtu -= sizeof(*ip6h);
+		if (encap_limit > 0)
+			mtu -= 8; /* encap limit option */
+	}
+
 	if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
 		return 0;
 
@@ -977,6 +1075,7 @@ unsigned int
 nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 			  const struct nf_hook_state *state)
 {
+	int encap_limit = IPV6_DEFAULT_TNL_ENCAP_LIMIT;
 	struct flow_offload_tuple_rhash *tuplehash;
 	struct nf_flowtable *flow_table = priv;
 	struct flow_offload_tuple *other_tuple;
@@ -995,7 +1094,8 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (tuplehash == NULL)
 		return NF_ACCEPT;
 
-	ret = nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash, skb);
+	ret = nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash, skb,
+					   encap_limit);
 	if (ret < 0)
 		return NF_DROP;
 	else if (ret == 0)
@@ -1014,6 +1114,10 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	other_tuple = &flow->tuplehash[!dir].tuple;
 	ip6_daddr = &other_tuple->src_v6;
 
+	if (nf_flow_tunnel_v6_push(state->net, skb, other_tuple,
+				   &ip6_daddr, encap_limit) < 0)
+		return NF_DROP;
+
 	if (nf_flow_encap_push(skb, other_tuple) < 0)
 		return NF_DROP;
 
-- 
2.52.0

