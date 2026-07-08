Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FD138757D;
	Wed,  8 Jul 2026 10:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783505469; cv=none; b=dcWfb9JN/jiv1ymJpE/jKOb/KLSDh7XM9mNz8RVW/z66F6DOhr9G+vGLgwZrBAESgm3B4M+VcPgDb3ojnFclOiBnUMJ7zaiOOXswQZnav1x8+Bqfjo+7KnJuJ2yKwMEccVdP2+MOo5VufNBg9sFkHEVzk5anZEwXJBowJGXb0/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783505469; c=relaxed/simple;
	bh=VN4wdorPbJn7LKuZSkoijw3XCZuVeBNzpg5V9ritcek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t3Ugixs6NSRhyta6WOD22wPh69um8erjNg91VrnJcDZh7iOjTYITPevWRuZcecz8QgcG4Dz7VimmsLFYh0Av0L6YreVLGmxbhLk3fLMCDSPIjCD0cwhxNgyrljTZg12Dwzf7xdF8aR5qjFLVf76mW8Nl6ETYmHtwf680gGw1pBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HLHZ9S3F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HLHZ9S3F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573491F000E9;
	Wed,  8 Jul 2026 10:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783505467;
	bh=fnvM6VIkH/O3GtE8QuoBt1olq68uY/0ehgfdP7Zgo+c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HLHZ9S3Fo1Zu+A003xNStW7PnM7q4/zy9SmSPdlCQ+ny9+17u1OhwB24Hc+Ai/vkl
	 JKouml4wVs1abEexEItXEkAkMEAoXvJznkmTKNF+XS+bVWjSOfDHyrQKmqTS5eng+T
	 S4DQemVBrYDRpE1o/UxZ44sKz2m9dI9OLBqoIsT2CwgMkwZ1+gchcI8kBtpP+LaXGl
	 CGIwOMEGlbOv96WMB08t6GpccmmiDkjchJmnxfdeCJ9tz0F0ay8exyRSiivXC6EUIu
	 1aSKiQ98eUTLJ+sG33gxZdJ0BKslo24JoFXX5/mZV5Mhkru2RY/QKZluTUTXSHr9mr
	 shFF9NLQiPZgw==
Date: Wed, 8 Jul 2026 12:11:05 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Felix Fietkau <nbd@nbd.name>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Simon Horman <horms@kernel.org>, David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH nf-next v4 3/6] net: netfilter: Add IPv4 over IPv6 tunnel
 flowtable acceleration
Message-ID: <ak4iOYYR65kdTDAm@lore-desk>
References: <20260703-b4-flowtable-sw-accel-ip6ip-v4-0-00398cd12382@kernel.org>
 <20260703-b4-flowtable-sw-accel-ip6ip-v4-3-00398cd12382@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4ZyhlbNkCqH2Htu9"
Content-Disposition: inline
In-Reply-To: <20260703-b4-flowtable-sw-accel-ip6ip-v4-3-00398cd12382@kernel.org>


--4ZyhlbNkCqH2Htu9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

commenting on sashiko's report:
https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260703-b4-flowtable-s=
w-accel-ip6ip-v4-0-00398cd12382%40kernel.org

> Introduce sw flowtable acceleration for the TX/RX paths of
> IPv4 over IPv6 tunnels, relying on the netfilter flowtable
> infrastructure.
> The feature can be tested with a forwarding scenario between two
> NICs (eth0 and eth1), where an IPv4 over IPv6 tunnel is used to
> reach a remote site via eth1 as the underlay device:
>=20
>     ETH0 -- TUN0 <=3D=3D> ETH1 -- [IP network] -- TUN1 (2001:db8:2::2)
>=20
> [IP configuration]
>=20
> 6: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state U=
P group default qlen 1000
>     link/ether 00:00:22:33:11:55 brd ff:ff:ff:ff:ff:ff
>     inet 192.168.0.2/24 scope global eth0
>        valid_lft forever preferred_lft forever
> 7: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state U=
P group default qlen 1000
>     link/ether 00:11:22:33:11:55 brd ff:ff:ff:ff:ff:ff
>     inet6 2001:db8:2::1/64 scope global nodad
>        valid_lft forever preferred_lft forever
> 8: tun0@NONE: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1480 qdisc noqueue stat=
e UNKNOWN group default qlen 1000
>     link/tunnel6 2001:db8:2::1 peer 2001:db8:2::2 permaddr ce9c:2940:7dcc=
::
>     inet 192.168.100.1/24 scope global tun0
>        valid_lft forever preferred_lft forever
>=20
> $ ip route show
> default via 192.168.100.2 dev tun0
> 192.168.0.0/24 dev eth0 proto kernel scope link src 192.168.0.2
> 192.168.100.0/24 dev tun0 proto kernel scope link src 192.168.100.1
>=20
> $ ip -6 route show
> 2001:db8:2::/64 dev eth1 proto kernel metric 256 pref medium
>=20
> $ nft list ruleset
> table inet filter {
>     flowtable ft {
>         hook ingress priority filter
>         devices =3D { eth0, eth1 }
>     }
>=20
>     chain forward {
>         type filter hook forward priority filter; policy accept;
>         meta l4proto { tcp, udp } flow add @ft
>     }
> }
>=20
> When reproducing this scenario using veth interfaces, the following
> results were observed:
>=20
> - TCP stream received from IPv4 over IPv6 tunnel:
>   - net-next (baseline):                ~126 Gbps
>   - net-next + IP6IP flowtable support: ~138 Gbps
>=20
> - TCP stream transmitted to IPv4 over IPv6 tunnel:
>   - net-next (baseline):                ~127 Gbps
>   - net-next + IP6IP flowtable support: ~140 Gbps
>=20
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  net/netfilter/nf_flow_table_core.c |  16 +++-
>  net/netfilter/nf_flow_table_ip.c   | 161 ++++++++++++++++++++++++++-----=
------
>  net/netfilter/nf_flow_table_path.c |  10 ++-
>  3 files changed, 133 insertions(+), 54 deletions(-)
>=20
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_t=
able_core.c
> index 99c5b9d671a0..18f89e6fb435 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -76,9 +76,14 @@ struct flow_offload *flow_offload_alloc(struct nf_conn=
 *ct)
>  }
>  EXPORT_SYMBOL_GPL(flow_offload_alloc);
> =20
> -static u32 flow_offload_dst_cookie(struct flow_offload_tuple *flow_tuple)
> +static u32 flow_offload_dst_cookie(struct flow_offload_tuple *flow_tuple,
> +				   u8 tun_encap_proto)
>  {
> -	if (flow_tuple->l3proto =3D=3D NFPROTO_IPV6)
> +	bool dst_v6;
> +
> +	dst_v6 =3D tun_encap_proto ? tun_encap_proto =3D=3D NFPROTO_IPV6
> +				 : flow_tuple->l3proto =3D=3D NFPROTO_IPV6;
> +	if (dst_v6)
>  		return rt6_get_cookie(dst_rt6_info(flow_tuple->dst_cache));
> =20
>  	return 0;
> @@ -99,10 +104,12 @@ static int flow_offload_fill_route(struct flow_offlo=
ad *flow,
>  				   enum flow_offload_tuple_dir dir)
>  {
>  	struct flow_offload_tuple *flow_tuple =3D &flow->tuplehash[dir].tuple;
> +	u8 l3proto, encap_proto =3D route->tuple[!dir].in.tun.encap_proto;
>  	struct dst_entry *dst =3D nft_route_dst_fetch(route, dir);
>  	int i, j =3D 0;
> =20
> -	switch (flow_tuple->l3proto) {
> +	l3proto =3D encap_proto ? encap_proto : flow_tuple->l3proto;
> +	switch (l3proto) {
>  	case NFPROTO_IPV4:
>  		flow_tuple->mtu =3D ip_dst_mtu_maybe_forward(dst, true);
>  		break;
> @@ -138,7 +145,8 @@ static int flow_offload_fill_route(struct flow_offloa=
d *flow,
>  	case FLOW_OFFLOAD_XMIT_NEIGH:
>  		flow_tuple->ifidx =3D route->tuple[dir].out.ifindex;
>  		flow_tuple->dst_cache =3D dst;
> -		flow_tuple->dst_cookie =3D flow_offload_dst_cookie(flow_tuple);
> +		flow_tuple->dst_cookie =3D flow_offload_dst_cookie(flow_tuple,
> +								 encap_proto);
>  		break;
>  	default:
>  		WARN_ON_ONCE(1);
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_tab=
le_ip.c
> index cf2c74e3fd56..4b6de16bd4f3 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -191,27 +191,27 @@ static void nf_flow_tuple_encap(struct nf_flowtable=
_ctx *ctx,
>  		break;
>  	}
> =20
> -	switch (inner_proto) {
> -	case htons(ETH_P_IP):
> -		iph =3D (struct iphdr *)(skb_network_header(skb) + offset);
> -		if (ctx->tun.proto =3D=3D IPPROTO_IPIP) {
> +	if (ctx->tun.proto =3D=3D IPPROTO_IPIP || ctx->tun.proto =3D=3D IPPROTO=
_IPV6) {
> +		switch (inner_proto) {
> +		case htons(ETH_P_IP):
> +			iph =3D (struct iphdr *)(skb_network_header(skb) +
> +					       offset);
>  			tuple->tun.dst_v4.s_addr =3D iph->daddr;
>  			tuple->tun.src_v4.s_addr =3D iph->saddr;
> -			tuple->tun.l3_proto =3D IPPROTO_IPIP;
> +			tuple->tun.l3_proto =3D ctx->tun.proto;
>  			tuple->tun.encap_proto =3D AF_INET;
> -		}
> -		break;
> -	case htons(ETH_P_IPV6):
> -		ip6h =3D (struct ipv6hdr *)(skb_network_header(skb) + offset);
> -		if (ctx->tun.proto =3D=3D IPPROTO_IPV6) {
> +			break;
> +		case htons(ETH_P_IPV6):
> +			ip6h =3D (struct ipv6hdr *)(skb_network_header(skb) +
> +						  offset);
>  			tuple->tun.dst_v6 =3D ip6h->daddr;
>  			tuple->tun.src_v6 =3D ip6h->saddr;
> -			tuple->tun.l3_proto =3D IPPROTO_IPV6;
> +			tuple->tun.l3_proto =3D ctx->tun.proto;
>  			tuple->tun.encap_proto =3D AF_INET6;
> +			break;
> +		default:
> +			break;
>  		}
> -		break;
> -	default:
> -		break;
>  	}
>  }
> =20
> @@ -363,7 +363,7 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flowta=
ble_ctx *ctx,
>  	if (ipv6_ext_hdr(ip6h->nexthdr))
>  		return false;
> =20
> -	if (ip6h->nexthdr =3D=3D IPPROTO_IPV6) {
> +	if (ip6h->nexthdr =3D=3D IPPROTO_IPIP || ip6h->nexthdr =3D=3D IPPROTO_I=
PV6) {
>  		ctx->tun.proto =3D ip6h->nexthdr;
>  		ctx->tun.hdr_size =3D sizeof(*ip6h);
>  		ctx->offset +=3D ctx->tun.hdr_size;
> @@ -384,6 +384,10 @@ static void nf_flow_ip_tunnel_pop(struct nf_flowtabl=
e_ctx *ctx,
> =20
>  	skb_pull(skb, ctx->tun.hdr_size);
>  	skb_reset_network_header(skb);
> +	if (ctx->tun.proto =3D=3D IPPROTO_IPIP)
> +		skb->protocol =3D htons(ETH_P_IP);
> +	else
> +		skb->protocol =3D htons(ETH_P_IPV6);
>  }
> =20
>  static bool nf_flow_skb_encap_protocol(struct nf_flowtable_ctx *ctx,
> @@ -489,8 +493,16 @@ static int nf_flow_offload_forward(struct nf_flowtab=
le_ctx *ctx,
>  	flow =3D container_of(tuplehash, struct flow_offload, tuplehash[dir]);
> =20
>  	mtu =3D flow->tuplehash[dir].tuple.mtu + ctx->offset;
> -	if (flow->tuplehash[!dir].tuple.tun_num)
> +	switch (flow->tuplehash[!dir].tuple.tun.encap_proto) {
> +	case AF_INET:
>  		mtu -=3D sizeof(*iph);
> +		break;
> +	case AF_INET6:
> +		mtu -=3D sizeof(struct ipv6hdr);
> +		break;
> +	default:
> +		break;
> +	}
> =20
>  	if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
>  		return 0;
> @@ -636,56 +648,57 @@ static int nf_flow_tunnel_ipip_push(struct net *net=
, struct sk_buff *skb,
>  	return 0;
>  }
> =20
> -static int nf_flow_tunnel_v4_push(struct net *net, struct sk_buff *skb,
> -				  struct flow_offload_tuple *tuple,
> -				  __be32 *ip_daddr)
> -{
> -	if (tuple->tun_num)
> -		return nf_flow_tunnel_ipip_push(net, skb, tuple, ip_daddr);
> -
> -	return 0;
> -}
> -
>  static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *s=
kb,
>  				      struct flow_offload_tuple *tuple,
>  				      struct in6_addr **ip6_daddr)

- This helper is still named nf_flow_tunnel_ip6ip6_push() but now also
  encapsulates IPv4 inner packets inside an IPv6 outer header, branching on
  tuple->tun.l3_proto and writing that value into ip6h->nexthdr rather than
  hard-coding IPPROTO_IPV6.
  Would a name like nf_flow_tunnel_ip6_push() (or splitting the inner-family
  preamble into a small helper) better reflect that this now covers both
  6-in-6 and 4-in-6 encapsulation?
  - I will fix it in v5.

>  {
> -	struct ipv6hdr *ip6h =3D (struct ipv6hdr *)skb_network_header(skb);
> -	struct rtable *rt =3D dst_rtable(tuple->dst_cache);
> -	__u8 dsfield =3D ipv6_get_dsfield(ip6h);
> +	struct dst_entry *dst =3D tuple->dst_cache;
>  	struct flowi6 fl6 =3D {
>  		.daddr =3D tuple->tun.src_v6,
>  		.saddr =3D tuple->tun.dst_v6,
>  		.flowi6_proto =3D IPPROTO_IPV6,
>  	};
> -	u8 hop_limit =3D ip6h->hop_limit;
> +	u8 hop_limit, dsfield;
> +	struct ipv6hdr *ip6h;
>  	int err, mtu;
>  	u32 headroom;
> =20
> +	if (tuple->tun.l3_proto =3D=3D IPPROTO_IPIP) {
> +		struct iphdr *iph =3D (struct iphdr *)skb_network_header(skb);
> +
> +		dsfield =3D ipv4_get_dsfield(iph);
> +		hop_limit =3D iph->ttl;
> +	} else {
> +		ip6h =3D (struct ipv6hdr *)skb_network_header(skb);
> +		dsfield =3D ipv6_get_dsfield(ip6h);
> +		hop_limit =3D ip6h->hop_limit;
> +	}
> +
>  	err =3D iptunnel_handle_offloads(skb, SKB_GSO_IPXIP6);
>  	if (err)
>  		return err;
> =20
> -	skb_set_inner_ipproto(skb, IPPROTO_IPV6);
> -	headroom =3D sizeof(*ip6h) + LL_RESERVED_SPACE(rt->dst.dev) +
> -		   rt->dst.header_len;
> +	skb_set_inner_ipproto(skb, tuple->tun.l3_proto);
> +	headroom =3D sizeof(*ip6h) + LL_RESERVED_SPACE(dst->dev) +
> +		   dst->header_len;
>  	err =3D skb_cow_head(skb, headroom);
>  	if (err)
>  		return err;
> =20
>  	skb_scrub_packet(skb, true);
> -	mtu =3D dst_mtu(&rt->dst) - sizeof(*ip6h);
> +	mtu =3D dst_mtu(dst) - sizeof(*ip6h);
>  	mtu =3D max(mtu, IPV6_MIN_MTU);
>  	skb_dst_update_pmtu_no_confirm(skb, mtu);
> =20
>  	skb_push(skb, sizeof(*ip6h));
>  	skb_reset_network_header(skb);
> +	skb->protocol =3D htons(ETH_P_IPV6);
> =20
>  	ip6h =3D ipv6_hdr(skb);
>  	ip6_flow_hdr(ip6h, dsfield,
>  		     ip6_make_flowlabel(net, skb, fl6.flowlabel, true, &fl6));
>  	ip6h->hop_limit =3D hop_limit;
> -	ip6h->nexthdr =3D IPPROTO_IPV6;
> +	ip6h->nexthdr =3D tuple->tun.l3_proto;
>  	ip6h->daddr =3D tuple->tun.src_v6;
>  	ip6h->saddr =3D tuple->tun.dst_v6;
>  	ipv6_hdr(skb)->payload_len =3D htons(skb->len - sizeof(*ip6h));
> @@ -696,6 +709,20 @@ static int nf_flow_tunnel_ip6ip6_push(struct net *ne=
t, struct sk_buff *skb,
>  	return 0;
>  }
> =20
> +static int nf_flow_tunnel_push(struct net *net, struct sk_buff *skb,
> +			       struct flow_offload_tuple *tuple,
> +			       __be32 *ip_daddr, struct in6_addr **ip6_daddr)
> +{
> +	switch (tuple->tun.encap_proto) {
> +	case AF_INET:
> +		return nf_flow_tunnel_ipip_push(net, skb, tuple, ip_daddr);
> +	case AF_INET6:
> +		return nf_flow_tunnel_ip6ip6_push(net, skb, tuple, ip6_daddr);
> +	default:
> +		return 0;
> +	}
> +}
> +
>  static int nf_flow_tunnel_v6_push(struct net *net, struct sk_buff *skb,
>  				  struct flow_offload_tuple *tuple,
>  				  struct in6_addr **ip6_daddr)

- The IPv4 hook now goes through the family-aware nf_flow_tunnel_push()
  dispatcher while the IPv6 hook still calls the narrow
  nf_flow_tunnel_v6_push() wrapper below.
  Would it be preferable to route both hooks through nf_flow_tunnel_push()
  so that the two entry points share the same abstraction?
  - I will fix it in v5.

> @@ -815,6 +842,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *s=
kb,
>  		.in	=3D state->in,
>  	};
>  	struct nf_flow_xmit xmit =3D {};
> +	struct in6_addr *ip6_daddr;
>  	struct flow_offload *flow;
>  	struct neighbour *neigh;
>  	struct rtable *rt;
> @@ -844,25 +872,41 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff =
*skb,
>  	other_tuple =3D &flow->tuplehash[!dir].tuple;
>  	ip_daddr =3D other_tuple->src_v4.s_addr;
> =20
> -	if (nf_flow_tunnel_v4_push(state->net, skb, other_tuple, &ip_daddr) < 0)
> +	if (nf_flow_tunnel_push(state->net, skb, other_tuple, &ip_daddr,
> +				&ip6_daddr) < 0)

- ip6_daddr is left uninitialized here, then its address is passed to
  nf_flow_tunnel_push() below. nf_flow_tunnel_push() only writes through
  ip6_daddr in the AF_INET6 case; the AF_INET and default cases leave the
  pointer untouched:
      switch (tuple->tun.encap_proto) {
      case AF_INET:
              return nf_flow_tunnel_ipip_push(net, skb, tuple, ip_daddr);
      case AF_INET6:
              return nf_flow_tunnel_ip6ip6_push(net, skb, tuple, ip6_daddr);
      default:
              return 0;
      }
  The symmetric IPv6 hook explicitly pre-initialises the corresponding
  pointer with ip6_daddr =3D &other_tuple->src_v6 before the push call. Sho=
uld
  the IPv4 hook mirror that pattern here?
  - I will fix it in v5.

>  		return NF_DROP;
> =20
>  	switch (tuplehash->tuple.xmit_type) {
> -	case FLOW_OFFLOAD_XMIT_NEIGH:
> -		rt =3D dst_rtable(tuplehash->tuple.dst_cache);
> +	case FLOW_OFFLOAD_XMIT_NEIGH: {
> +		struct dst_entry *dst;
> +
>  		xmit.outdev =3D dev_get_by_index_rcu(state->net, tuplehash->tuple.ifid=
x);
>  		if (!xmit.outdev) {
>  			flow_offload_teardown(flow);
>  			return NF_DROP;
>  		}
> -		neigh =3D ip_neigh_gw4(rt->dst.dev, rt_nexthop(rt, ip_daddr));
> +		if (other_tuple->tun.encap_proto =3D=3D AF_INET6 ||
> +		    ctx.tun.proto =3D=3D IPPROTO_IPV6) {
> +			struct rt6_info *rt6;
> +
> +			rt6 =3D dst_rt6_info(tuplehash->tuple.dst_cache);
> +			neigh =3D ip_neigh_gw6(rt6->dst.dev,
> +					     rt6_nexthop(rt6, ip6_daddr));
> +			dst =3D &rt6->dst;
> +		} else {
> +			rt =3D dst_rtable(tuplehash->tuple.dst_cache);
> +			neigh =3D ip_neigh_gw4(rt->dst.dev,
> +					     rt_nexthop(rt, ip_daddr));
> +			dst =3D &rt->dst;
> +		}
>  		if (IS_ERR(neigh)) {
>  			flow_offload_teardown(flow);
>  			return NF_DROP;
>  		}
>  		xmit.dest =3D neigh->ha;
> -		skb_dst_set_noref(skb, &rt->dst);
> +		skb_dst_set_noref(skb, dst);
>  		break;
> +	}
>  	case FLOW_OFFLOAD_XMIT_DIRECT:
>  		xmit.outdev =3D dev_get_by_index_rcu(state->net, tuplehash->tuple.out.=
ifidx);
>  		if (!xmit.outdev) {
> @@ -1112,8 +1156,12 @@ nf_flow_offload_ipv6_lookup(struct nf_flowtable_ct=
x *ctx,
>  	if (!nf_flow_skb_encap_protocol(ctx, skb, htons(ETH_P_IPV6)))
>  		return NULL;
> =20
> -	if (nf_flow_tuple_ipv6(ctx, skb, &tuple) < 0)
> +	if (ctx->tun.proto =3D=3D IPPROTO_IPIP) {
> +		if (nf_flow_tuple_ip(ctx, skb, &tuple) < 0)
> +			return NULL;
> +	} else if (nf_flow_tuple_ipv6(ctx, skb, &tuple) < 0) {
>  		return NULL;
> +	}
> =20
>  	return flow_offload_lookup(flow_table, &tuple);
>  }
> @@ -1140,7 +1188,11 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_bu=
ff *skb,
>  	if (tuplehash =3D=3D NULL)
>  		return NF_ACCEPT;
> =20
> -	ret =3D nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash, skb);
> +	if (ctx.tun.proto =3D=3D IPPROTO_IPIP)
> +		ret =3D nf_flow_offload_forward(&ctx, flow_table, tuplehash, skb);
> +	else
> +		ret =3D nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash,
> +						   skb);
>  	if (ret < 0)
>  		return NF_DROP;
>  	else if (ret =3D=3D 0)
> @@ -1164,21 +1216,38 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_b=
uff *skb,
>  		return NF_DROP;
> =20
>  	switch (tuplehash->tuple.xmit_type) {
> -	case FLOW_OFFLOAD_XMIT_NEIGH:
> -		rt =3D dst_rt6_info(tuplehash->tuple.dst_cache);
> +	case FLOW_OFFLOAD_XMIT_NEIGH: {
> +		struct dst_entry *dst;
> +
>  		xmit.outdev =3D dev_get_by_index_rcu(state->net, tuplehash->tuple.ifid=
x);
>  		if (!xmit.outdev) {
>  			flow_offload_teardown(flow);
>  			return NF_DROP;
>  		}
> -		neigh =3D ip_neigh_gw6(rt->dst.dev, rt6_nexthop(rt, ip6_daddr));
> +		if (other_tuple->tun.encap_proto =3D=3D AF_INET ||
> +		    ctx.tun.proto =3D=3D IPPROTO_IPIP) {
> +			__be32 ip_daddr =3D other_tuple->src_v4.s_addr;
> +			struct rtable *rt4;
> +
> +			skb->protocol =3D htons(ETH_P_IP);
> +			rt4 =3D dst_rtable(tuplehash->tuple.dst_cache);
> +			neigh =3D ip_neigh_gw4(rt4->dst.dev,
> +					     rt_nexthop(rt4, ip_daddr));
> +			dst =3D &rt4->dst;
> +		} else {
> +			rt =3D dst_rt6_info(tuplehash->tuple.dst_cache);
> +			neigh =3D ip_neigh_gw6(rt->dst.dev,
> +					     rt6_nexthop(rt, ip6_daddr));
> +			dst =3D &rt->dst;
> +		}
>  		if (IS_ERR(neigh)) {
>  			flow_offload_teardown(flow);
>  			return NF_DROP;
>  		}
>  		xmit.dest =3D neigh->ha;
> -		skb_dst_set_noref(skb, &rt->dst);
> +		skb_dst_set_noref(skb, dst);
>  		break;
> +	}
>  	case FLOW_OFFLOAD_XMIT_DIRECT:
>  		xmit.outdev =3D dev_get_by_index_rcu(state->net, tuplehash->tuple.out.=
ifidx);
>  		if (!xmit.outdev) {
> diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_t=
able_path.c
> index caaf48c5fd2a..5e84b7f18a26 100644
> --- a/net/netfilter/nf_flow_table_path.c
> +++ b/net/netfilter/nf_flow_table_path.c
> @@ -216,12 +216,13 @@ static int nft_flow_tunnel_update_route(const struc=
t nft_pktinfo *pkt,
>  	struct dst_entry *tun_dst =3D NULL;
>  	struct flowi fl =3D {};
> =20
> -	switch (nft_pf(pkt)) {
> +	switch (tun->encap_proto) {
>  	case NFPROTO_IPV4:
>  		fl.u.ip4.daddr =3D tun->dst_v4.s_addr;
>  		fl.u.ip4.saddr =3D tun->src_v4.s_addr;
>  		fl.u.ip4.flowi4_iif =3D nft_in(pkt)->ifindex;
> -		fl.u.ip4.flowi4_dscp =3D ip4h_dscp(ip_hdr(pkt->skb));
> +		if (nft_pf(pkt) =3D=3D NFPROTO_IPV4)
> +			fl.u.ip4.flowi4_dscp =3D ip4h_dscp(ip_hdr(pkt->skb));
>  		fl.u.ip4.flowi4_mark =3D pkt->skb->mark;
>  		fl.u.ip4.flowi4_flags =3D FLOWI_FLAG_ANYSRC;
>  		break;
> @@ -229,13 +230,14 @@ static int nft_flow_tunnel_update_route(const struc=
t nft_pktinfo *pkt,
>  		fl.u.ip6.daddr =3D tun->dst_v6;
>  		fl.u.ip6.saddr =3D tun->src_v6;
>  		fl.u.ip6.flowi6_iif =3D nft_in(pkt)->ifindex;
> -		fl.u.ip6.flowlabel =3D ip6_flowinfo(ipv6_hdr(pkt->skb));
> +		if (nft_pf(pkt) =3D=3D NFPROTO_IPV6)
> +			fl.u.ip6.flowlabel =3D ip6_flowinfo(ipv6_hdr(pkt->skb));
>  		fl.u.ip6.flowi6_mark =3D pkt->skb->mark;
>  		fl.u.ip6.flowi6_flags =3D FLOWI_FLAG_ANYSRC;
>  		break;

- This changes route-family selection from nft_pf(pkt) to tun->encap_proto
  and gates the DSCP and flowlabel inputs on nft_pf(pkt) matching the outer
  family, so cross-family flows now pass zero DSCP or flowlabel into the
  flowi used for the FIB lookup.
  Setups that use policy routing keyed on TOS/DSCP or flow label may see
  different route selection than before. The changelog describes the
  IPv4-over-IPv6 feature and its benchmarks but does not mention this
  behavioural change on tunnel route selection.
  Could this behavioural change be called out in the commit message so it
  is discoverable during bisection and stable-tree evaluation?
  - I will fix commit logs in v5.

Regards,
Lorenzo

>  	}
> =20
> -	nf_route(nft_net(pkt), &tun_dst, &fl, false, nft_pf(pkt));
> +	nf_route(nft_net(pkt), &tun_dst, &fl, false, tun->encap_proto);
>  	if (!tun_dst)
>  		return -ENOENT;
> =20
>=20
> --=20
> 2.55.0
>=20

--4ZyhlbNkCqH2Htu9
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCak4iOQAKCRA6cBh0uS2t
rKvEAPwIpeTab9ylRSvjZwl38+VU1fCXCut57q4LG0el0Ssy4QEAm3kUuwy7knaY
P/pckLriBy8Ny6U9BknTi393uXjxQAM=
=fFr6
-----END PGP SIGNATURE-----

--4ZyhlbNkCqH2Htu9--
