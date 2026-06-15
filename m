Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD213932E4;
	Mon, 15 Jun 2026 09:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781515122; cv=none; b=YeouX9QYXPM7ZY9LhKXp8Gi9neo7xuqr2abmsj63INnaIbLBoJWqOJtFHwIC4uc0BVHLO6fGxp0NT/7JJix71rhDkxfX7DsTsohgqSSs6LATKJ1ggme0IIzFuOp0BCVkm1FYoCz/8xRLAyymb8KxUXh2SXAbbXSK6yNhHuvAyCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781515122; c=relaxed/simple;
	bh=OnSYF1pHkEV2T04VBjQE5Q50mKp4Lg0Mqilm00UB8O0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=S4dP3C43kcMmfNOSbeSB9ijkbJzTSoG5Z/HMEZ0m5pRgRaVeUC+YyDlO2hI5t9n8ccqt8Hw9rqJTuoDBvQ37y0pjLpGT5heLbkYR5ef9UFMZuHEUUB65a81nSSlzinrs/WwKhX54OQuKe8w6klaLiH4fqe2W67ceG8dqKlpAKu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FBG7se9R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FBG7se9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69AC1F000E9;
	Mon, 15 Jun 2026 09:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781515121;
	bh=IYSYT0akrNtBSTc3XQEfDwkWdMSJk+gAzuVeOTJyTvU=;
	h=From:Date:Subject:To:Cc;
	b=FBG7se9RHHJorsKGW8KgGDxNvEqiHGaSxZ30z/LBPvJofUPMA7JIu7WLn5i3jWTRo
	 aJyg/3e0scvEPd2PT6M571OJh+KrNhvPFAd+33EFHA+u6EXE1/+4IG/8BLeJJjnqNN
	 53G7/NIennSO9PgLRkymwjFfVk5rm4WKbJHn8M9mvYyyJ349+JMNwxxjAMU9Y/ZjAr
	 +ckkSNz89Mz9XPbo6yUz93D4TjQDnDaX/J3ebGRpr5d+OJW8XpOzB7q/KBdL3gabXQ
	 eVNUcX3IDZXAWHnquJv9k/TvtKW7+np8m4+F18sQIq8fNWnL+OznZI2zxEgz5YyW/D
	 oZuWNuC25JDjw==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Mon, 15 Jun 2026 11:18:25 +0200
Subject: [PATCH nf v2] netfilter: flowtable: fix and simplify IP6IP6 tunnel
 handling
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-b4-nf_flow_ip6_tunnel_proto-update-v2-1-a92e1a40ffc6@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/5WNWw6CMBREt2LutzWlQql+uQ9DGh630Eja5ragh
 rB3G3bg55mZzNkgIlmMcD9tQLjaaL3LIM4n6KfWjcjskBkEF5JLrlhXMme0mf1b2yB1WpzDWQf
 yybMlDG1CpjpZ3vhViaorIR8FQmM/h+QJzkCTs8nG5Ol7eNfiaP5RrAUrWK1EX/NK9MoMjxdSX
 l08jdDs+/4Do55aStkAAAA=
X-Change-ID: 20260608-b4-nf_flow_ip6_tunnel_proto-update-8b64903825b4
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, David Ahern <dsahern@kernel.org>, 
 Ido Schimmel <idosch@nvidia.com>, Shuah Khan <shuah@kernel.org>, 
 Lorenzo Bianconi <lorenzo@kernel.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
X-Mailer: b4 0.14.3

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
---
Changes in v2:
- Drop tunnel encapsulation limit destination option support.
- Do not allow IPv6 extension headers in nf_flow_ip6_tunnel_proto().
- Link to v1: https://lore.kernel.org/r/20260608-b4-nf_flow_ip6_tunnel_proto-update-v1-1-782c7052c8fd@kernel.org
---
 net/ipv6/ip6_tunnel.c                              |  7 ++
 net/netfilter/nf_flow_table_ip.c                   | 80 +++++-----------------
 .../selftests/net/netfilter/nft_flowtable.sh       |  8 +--
 3 files changed, 30 insertions(+), 65 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 9d1037ac082f..bf1e77f95f18 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1850,6 +1850,13 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
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

---
base-commit: 1fad1796b9411217fa77b6a497ed76b999205487
change-id: 20260608-b4-nf_flow_ip6_tunnel_proto-update-8b64903825b4

Best regards,
-- 
Lorenzo Bianconi <lorenzo@kernel.org>

