Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA342ECD3A;
	Fri, 19 Jun 2026 11:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781870112; cv=none; b=Erlbs+DHNJkXshHRd1nItCTCTFcJl8UsxxJDf1JGjZOxEyGhJuaqPT3mTfK1b2agTm6ds9xnIs+bnivnZQ5Nz0UUEqlYOl+a7PVyjng7sSHG/SbJaacbCnQ1cfpF2+qCP1YenEq6b2lBPk9WeytvDUZluApgR//fwowfHgN6jE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781870112; c=relaxed/simple;
	bh=9j64UnNpYuU64n5ULFhTdoRQq3R6+QKq4d0AAN1mv6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxPycCR9hBtRObsChvDhW05+Em/mLbmNWPo7JUHvcC4p1Y2ByVYz1cKrEwUlPVuzlpkgP/LKnVVCSXlja4R1860sTbLatJDeHKT26kRSnKxZ54gfJJKW5Owbj3kiNkr1WvCJMnfCDXuG9QHlfIUqaBbsB3CTgw+5kZregI8Pvw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mg+TwvhR; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mg+TwvhR"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8557B601B1;
	Fri, 19 Jun 2026 13:55:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781870104;
	bh=11hW//Ju2GWtkdVmhs2OR1rGa9OzCnEEfvwFfaWcjY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mg+TwvhRi3yzYiAHK0w8Y3KxcPU/j5lNQ6/Sk9VIdYMXFAY63omNp5Ra9yDp/tW0j
	 CuxDcKHhunG3fYdONIKphHqGsn3aBtiA5FYgUC/TkpdLr8pJmr8RQjAyKGY5By1uP6
	 KpbpriM7lB7Oyt2CqZys8kimdM8VdxBKAF8FcJHFtbjim+aMHgG/WK7nX58d8mR2db
	 MG30zySy9jBKj9Ze6hOCtwYNY+H3s4dlLZ2Q9KhK+JEQi1c2J1RdCufzUZZTTc2AOQ
	 99I0MvZuWVQYZ83UDnuWwkUGAOMBb7QuhtxMw6HaOaoOparoeMbrO8NBnv1iEw5N3m
	 uVfIkshDRSgdw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 04/16] netfilter: flowtable: fix and simplify IP6IP6 tunnel handling
Date: Fri, 19 Jun 2026 13:54:39 +0200
Message-ID: <20260619115452.93949-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619115452.93949-1-pablo@netfilter.org>
References: <20260619115452.93949-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo@kernel.org>

Fix nf_flow_ip6_tunnel_proto() to use pskb_may_pull() instead of
skb_header_pointer() to ensure the outer IPv6 header is in the skb
headroom, which is required for subsequent packet processing. Move
ctx->offset update inside the IPPROTO_IPV6 conditional block since it
should only be adjusted when an IP6IP6 tunnel is actually detected.
Simplify the rx path by removing ipv6_skip_exthdr() and checking
ip6h->nexthdr directly, as the flowtable fast path only handles simple
IP6IP6 encapsulation without extension headers.
Drop the tunnel encapsulation limit destination option support from the
tx path to match, since the rx path no longer handles extension headers.
Remove the encap_limit parameter from nf_flow_offload_ipv6_forward(),
nf_flow_tunnel_ip6ip6_push() and nf_flow_tunnel_v6_push(), along with
the ipv6_tel_txoption struct and related headroom/MTU adjustments.

Fixes: d98103575dcdd ("netfilter: flowtable: Add IP6IP6 rx sw acceleration")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/ip6_tunnel.c                         |  7 ++
 net/netfilter/nf_flow_table_ip.c              | 80 +++++--------------
 .../selftests/net/netfilter/nft_flowtable.sh  |  8 +-
 3 files changed, 30 insertions(+), 65 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index d7c90a8533ec..bf8e40af60b0 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1851,6 +1851,13 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
 	struct dst_entry *dst;
 	int err;
 
+	if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT)) {
+		/* encaplimit option is currently not supported is
+		 * sw-acceleration path.
+		 */
+		return -EOPNOTSUPP;
+	}
+
 	dst = ip6_route_output(dev_net(ctx->dev), NULL, &fl6);
 	if (!dst->error) {
 		path->type = DEV_PATH_TUN;
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 9c05a50d6013..e7a3fb2b2d94 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -347,29 +347,23 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flowtable_ctx *ctx,
 				     struct sk_buff *skb)
 {
 #if IS_ENABLED(CONFIG_IPV6)
-	struct ipv6hdr *ip6h, _ip6h;
-	__be16 frag_off;
-	u8 nexthdr;
-	int hdrlen;
+	struct ipv6hdr *ip6h;
 
-	ip6h = skb_header_pointer(skb, ctx->offset, sizeof(*ip6h), &_ip6h);
-	if (!ip6h)
+	if (!pskb_may_pull(skb, sizeof(*ip6h) + ctx->offset))
 		return false;
 
+	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + ctx->offset);
 	if (ip6h->hop_limit <= 1)
 		return false;
 
-	nexthdr = ip6h->nexthdr;
-	hdrlen = ipv6_skip_exthdr(skb, sizeof(*ip6h) + ctx->offset, &nexthdr,
-				  &frag_off);
-	if (hdrlen < 0)
+	if (ipv6_ext_hdr(ip6h->nexthdr))
 		return false;
 
-	if (nexthdr == IPPROTO_IPV6) {
-		ctx->tun.hdr_size = hdrlen;
-		ctx->tun.proto = IPPROTO_IPV6;
+	if (ip6h->nexthdr == IPPROTO_IPV6) {
+		ctx->tun.proto = ip6h->nexthdr;
+		ctx->tun.hdr_size = sizeof(*ip6h);
+		ctx->offset += ctx->tun.hdr_size;
 	}
-	ctx->offset += ctx->tun.hdr_size;
 
 	return true;
 #else
@@ -648,25 +642,19 @@ static int nf_flow_tunnel_v4_push(struct net *net, struct sk_buff *skb,
 	return 0;
 }
 
-struct ipv6_tel_txoption {
-	struct ipv6_txoptions ops;
-	__u8 dst_opt[8];
-};
-
 static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
 				      struct flow_offload_tuple *tuple,
-				      struct in6_addr **ip6_daddr,
-				      int encap_limit)
+				      struct in6_addr **ip6_daddr)
 {
 	struct ipv6hdr *ip6h = (struct ipv6hdr *)skb_network_header(skb);
-	u8 hop_limit = ip6h->hop_limit, proto = IPPROTO_IPV6;
 	struct rtable *rt = dst_rtable(tuple->dst_cache);
 	__u8 dsfield = ipv6_get_dsfield(ip6h);
 	struct flowi6 fl6 = {
 		.daddr = tuple->tun.src_v6,
 		.saddr = tuple->tun.dst_v6,
-		.flowi6_proto = proto,
+		.flowi6_proto = IPPROTO_IPV6,
 	};
+	u8 hop_limit = ip6h->hop_limit;
 	int err, mtu;
 	u32 headroom;
 
@@ -674,41 +662,18 @@ static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
 	if (err)
 		return err;
 
-	skb_set_inner_ipproto(skb, proto);
+	skb_set_inner_ipproto(skb, IPPROTO_IPV6);
 	headroom = sizeof(*ip6h) + LL_RESERVED_SPACE(rt->dst.dev) +
 		   rt->dst.header_len;
-	if (encap_limit)
-		headroom += 8;
 	err = skb_cow_head(skb, headroom);
 	if (err)
 		return err;
 
 	skb_scrub_packet(skb, true);
 	mtu = dst_mtu(&rt->dst) - sizeof(*ip6h);
-	if (encap_limit)
-		mtu -= 8;
 	mtu = max(mtu, IPV6_MIN_MTU);
 	skb_dst_update_pmtu_no_confirm(skb, mtu);
 
-	if (encap_limit > 0) {
-		struct ipv6_tel_txoption opt = {
-			.dst_opt[2] = IPV6_TLV_TNL_ENCAP_LIMIT,
-			.dst_opt[3] = 1,
-			.dst_opt[4] = encap_limit,
-			.dst_opt[5] = IPV6_TLV_PADN,
-			.dst_opt[6] = 1,
-		};
-		struct ipv6_opt_hdr *hopt;
-
-		opt.ops.dst1opt = (struct ipv6_opt_hdr *)opt.dst_opt;
-		opt.ops.opt_nflen = 8;
-
-		hopt = skb_push(skb, ipv6_optlen(opt.ops.dst1opt));
-		memcpy(hopt, opt.ops.dst1opt, ipv6_optlen(opt.ops.dst1opt));
-		hopt->nexthdr = IPPROTO_IPV6;
-		proto = NEXTHDR_DEST;
-	}
-
 	skb_push(skb, sizeof(*ip6h));
 	skb_reset_network_header(skb);
 
@@ -716,7 +681,7 @@ static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
 	ip6_flow_hdr(ip6h, dsfield,
 		     ip6_make_flowlabel(net, skb, fl6.flowlabel, true, &fl6));
 	ip6h->hop_limit = hop_limit;
-	ip6h->nexthdr = proto;
+	ip6h->nexthdr = IPPROTO_IPV6;
 	ip6h->daddr = tuple->tun.src_v6;
 	ip6h->saddr = tuple->tun.dst_v6;
 	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(*ip6h));
@@ -729,12 +694,10 @@ static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
 
 static int nf_flow_tunnel_v6_push(struct net *net, struct sk_buff *skb,
 				  struct flow_offload_tuple *tuple,
-				  struct in6_addr **ip6_daddr,
-				  int encap_limit)
+				  struct in6_addr **ip6_daddr)
 {
 	if (tuple->tun_num)
-		return nf_flow_tunnel_ip6ip6_push(net, skb, tuple, ip6_daddr,
-						  encap_limit);
+		return nf_flow_tunnel_ip6ip6_push(net, skb, tuple, ip6_daddr);
 
 	return 0;
 }
@@ -1089,7 +1052,7 @@ static int nf_flow_tuple_ipv6(struct nf_flowtable_ctx *ctx, struct sk_buff *skb,
 static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 					struct nf_flowtable *flow_table,
 					struct flow_offload_tuple_rhash *tuplehash,
-					struct sk_buff *skb, int encap_limit)
+					struct sk_buff *skb)
 {
 	enum flow_offload_tuple_dir dir;
 	struct flow_offload *flow;
@@ -1100,11 +1063,8 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
 	mtu = flow->tuplehash[dir].tuple.mtu + ctx->offset;
-	if (flow->tuplehash[!dir].tuple.tun_num) {
+	if (flow->tuplehash[!dir].tuple.tun_num)
 		mtu -= sizeof(*ip6h);
-		if (encap_limit > 0)
-			mtu -= 8; /* encap limit option */
-	}
 
 	if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
 		return 0;
@@ -1158,7 +1118,6 @@ unsigned int
 nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 			  const struct nf_hook_state *state)
 {
-	int encap_limit = IPV6_DEFAULT_TNL_ENCAP_LIMIT;
 	struct flow_offload_tuple_rhash *tuplehash;
 	struct nf_flowtable *flow_table = priv;
 	struct flow_offload_tuple *other_tuple;
@@ -1177,8 +1136,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (tuplehash == NULL)
 		return NF_ACCEPT;
 
-	ret = nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash, skb,
-					   encap_limit);
+	ret = nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash, skb);
 	if (ret < 0)
 		return NF_DROP;
 	else if (ret == 0)
@@ -1198,7 +1156,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	ip6_daddr = &other_tuple->src_v6;
 
 	if (nf_flow_tunnel_v6_push(state->net, skb, other_tuple,
-				   &ip6_daddr, encap_limit) < 0)
+				   &ip6_daddr) < 0)
 		return NF_DROP;
 
 	switch (tuplehash->tuple.xmit_type) {
diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
index 7a34ef468975..08ad07500e8a 100755
--- a/tools/testing/selftests/net/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
@@ -592,7 +592,7 @@ ip -net "$nsr1" link set tun0 up
 ip -net "$nsr1" addr add 192.168.100.1/24 dev tun0
 ip netns exec "$nsr1" sysctl net.ipv4.conf.tun0.forwarding=1 > /dev/null
 
-ip -net "$nsr1" link add name tun6 type ip6tnl local fee1:2::1 remote fee1:2::2
+ip -net "$nsr1" link add name tun6 type ip6tnl local fee1:2::1 remote fee1:2::2 encaplimit none
 ip -net "$nsr1" link set tun6 up
 ip -net "$nsr1" addr add fee1:3::1/64 dev tun6 nodad
 
@@ -601,7 +601,7 @@ ip -net "$nsr2" link set tun0 up
 ip -net "$nsr2" addr add 192.168.100.2/24 dev tun0
 ip netns exec "$nsr2" sysctl net.ipv4.conf.tun0.forwarding=1 > /dev/null
 
-ip -net "$nsr2" link add name tun6 type ip6tnl local fee1:2::2 remote fee1:2::1 || ret=1
+ip -net "$nsr2" link add name tun6 type ip6tnl local fee1:2::2 remote fee1:2::1 encaplimit none || ret=1
 ip -net "$nsr2" link set tun6 up
 ip -net "$nsr2" addr add fee1:3::2/64 dev tun6 nodad
 
@@ -651,7 +651,7 @@ ip -net "$nsr1" route change default via 192.168.200.2
 ip netns exec "$nsr1" sysctl net.ipv4.conf.tun0/10.forwarding=1 > /dev/null
 ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif tun0.10 accept'
 
-ip -net "$nsr1" link add name tun6.10 type ip6tnl local fee1:4::1 remote fee1:4::2
+ip -net "$nsr1" link add name tun6.10 type ip6tnl local fee1:4::1 remote fee1:4::2 encaplimit none
 ip -net "$nsr1" link set tun6.10 up
 ip -net "$nsr1" addr add fee1:5::1/64 dev tun6.10 nodad
 ip -6 -net "$nsr1" route delete default
@@ -670,7 +670,7 @@ ip -net "$nsr2" addr add 192.168.200.2/24 dev tun0.10
 ip -net "$nsr2" route change default via 192.168.200.1
 ip netns exec "$nsr2" sysctl net.ipv4.conf.tun0/10.forwarding=1 > /dev/null
 
-ip -net "$nsr2" link add name tun6.10 type ip6tnl local fee1:4::2 remote fee1:4::1 || ret=1
+ip -net "$nsr2" link add name tun6.10 type ip6tnl local fee1:4::2 remote fee1:4::1 encaplimit none || ret=1
 ip -net "$nsr2" link set tun6.10 up
 ip -net "$nsr2" addr add fee1:5::2/64 dev tun6.10 nodad
 ip -6 -net "$nsr2" route delete default
-- 
2.47.3

