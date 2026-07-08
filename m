Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5203F6606;
	Wed,  8 Jul 2026 10:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783506852; cv=none; b=nD/Uf8cmRzCXOHUtrm5pG0WQCENVLstmz1JdtuDV5G/c4crD/giZxoNlF95RCll51S4Cg1J16CxHhtqR8qr0N+Kz0/oHVNs1GCldDJp45xtCL1R/iWAfK1S21aZq7pSGJkteiMtXXvqBKeGt1YNaOA/QMeF9KJxHYvVa8Yz+iIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783506852; c=relaxed/simple;
	bh=kO9MH9U9Ll8GRijT80us/3aIUVPVcob9amL9ysABxik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W9Xg8/jLAd8BNBwucNH46luOECmel6I/VgHMslBtCLmRDA2paY8cjIcmObgC6Xyn6hbuf/ygfHL5+TwGxW+0DV0Nj0s5owjP4rAX1lBrV1RWDJTxu18tvmk+j06GSqswlO5zw2sxjRt3Nvgh+kH0QhRaNWiFZL5YOUHI41962l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gR6Usnq7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gR6Usnq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B961F000E9;
	Wed,  8 Jul 2026 10:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783506841;
	bh=4XQ0wLbsM/AS7qA52MIZH67Ua3KezvjkhA2tS6lMiJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gR6Usnq7B8n7kg/b2ZH5jlJH3PyqWYzHUTSp20hBE553UOQt9GxZpMb4t9WXHASxG
	 l6A7OnZXV+TBBy0EclhYaH8vtpACh3VS8FHx+UtTNa95QO4U7HWtuRq8Pl/TYwaKbf
	 iK8VTDe8oWTGDtJo52d7lCmiT8mD2bCA3NuTrRvj84Kf1j6IsO3lqOjF/Dz/jDnYAy
	 9V63U9XVD+G2xWim6WusbSa9bLyMVnSOFS/7VZAkEm7Q2Sjy5Xq1w0xaI8V5HiIVVe
	 5EU1tMceL7ytYksChrm8KZfAGetucCXFr37cVwuwyJFhw5c7mzvhnI9jrfD82v6XMe
	 SNCe4+xTeV/8w==
Date: Wed, 8 Jul 2026 12:33:58 +0200
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
Subject: Re: [PATCH nf-next v4 5/6] net: netfilter: Add SIT tunnel flowtable
 acceleration
Message-ID: <ak4nltE006uDesMl@lore-desk>
References: <20260703-b4-flowtable-sw-accel-ip6ip-v4-0-00398cd12382@kernel.org>
 <20260703-b4-flowtable-sw-accel-ip6ip-v4-5-00398cd12382@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="NkuvXEfgx3dvazRZ"
Content-Disposition: inline
In-Reply-To: <20260703-b4-flowtable-sw-accel-ip6ip-v4-5-00398cd12382@kernel.org>


--NkuvXEfgx3dvazRZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

commenting on sashiko's report:
https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260703-b4-flowtable-s=
w-accel-ip6ip-v4-0-00398cd12382%40kernel.org

> Introduce sw flowtable acceleration for the TX/RX paths of
> SIT tunnels, relying on the netfilter flowtable infrastructure.
> The feature can be tested with a forwarding scenario between two
> NICs (eth0 and eth1), where a SIT tunnel is used to reach a remote
> site via eth1 as the underlay device:
>=20
>     ETH0 -- TUN0 <=3D=3D> ETH1 -- [IP network] -- TUN1 (192.168.2.2)
>=20
> [IP configuration]
>=20
> 6: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state U=
P group default qlen 1000
>     link/ether 00:00:22:33:11:55 brd ff:ff:ff:ff:ff:ff
>     inet6 2001:db8:1::2/64 scope global nodad
>        valid_lft forever preferred_lft forever
> 7: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state U=
P group default qlen 1000
>     link/ether 00:11:22:33:11:55 brd ff:ff:ff:ff:ff:ff
>     inet 192.168.2.1/24 scope global eth1
>        valid_lft forever preferred_lft forever
> 8: tun0@NONE: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1480 qdisc noqueue stat=
e UNKNOWN group default qlen 1000
>     link/sit 192.168.2.1 peer 192.168.2.2
>     inet6 2001:db8:200::1/64 scope global nodad
>        valid_lft forever preferred_lft forever
>=20
> $ ip route show
> 192.168.2.0/24 dev eth1 proto kernel scope link src 192.168.2.1
>=20
> $ ip -6 route show
> 2001:db8:1::/64 dev eth0 proto kernel metric 256 pref medium
> 2001:db8:200::/64 dev tun0 proto kernel metric 256 pref medium
> default via 2001:db8:200::2 dev tun0 metric 1024 pref medium
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
> - TCP stream received from SIT tunnel:
>   - net-next (baseline):                ~118 Gbps
>   - net-next + SIT flowtable support: ~148 Gbps
>=20
> - TCP stream transmitted to SIT tunnel:
>   - net-next (baseline):                ~131 Gbps
>   - net-next + SIT flowtable support: ~147 Gbps
>=20
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  net/ipv6/sit.c                   |  26 ++++
>  net/netfilter/nf_flow_table_ip.c | 290 +++++++++++++++++++++------------=
------
>  2 files changed, 182 insertions(+), 134 deletions(-)
>=20
> diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
> index a38b24fb8384..0ac6f7839878 100644
> --- a/net/ipv6/sit.c
> +++ b/net/ipv6/sit.c
> @@ -1365,6 +1365,31 @@ ipip6_tunnel_ctl(struct net_device *dev, struct ip=
_tunnel_parm_kern *p,
>  	}
>  }
> =20
> +static int ipip6_tunnel_fill_forward_path(struct net_device_path_ctx *ct=
x,
> +					  struct net_device_path *path)
> +{
> +	struct ip_tunnel *tunnel =3D netdev_priv(ctx->dev);
> +	const struct iphdr *tiph =3D &tunnel->parms.iph;
> +	struct rtable *rt;
> +
> +	rt =3D ip_route_output(dev_net(ctx->dev), tiph->daddr, 0, 0, 0,
> +			     RT_SCOPE_UNIVERSE);
> +	if (IS_ERR(rt))
> +		return PTR_ERR(rt);
> +
> +	path->type =3D DEV_PATH_TUN;
> +	path->tun.src_v4.s_addr =3D tiph->saddr;
> +	path->tun.dst_v4.s_addr =3D tiph->daddr;
> +	path->tun.l3_proto =3D IPPROTO_IPV6;
> +	path->tun.encap_proto =3D AF_INET;
> +	path->dev =3D ctx->dev;
> +
> +	ctx->dev =3D rt->dst.dev;
> +	ip_rt_put(rt);
> +
> +	return 0;

- Is tiph->daddr always meaningful here?  SIT supports several modes where
  tunnel->parms.iph.daddr is either zero or a placeholder and the real
  outer IPv4 endpoint is derived per-packet from the inner IPv6
  destination:
    - ISATAP (dev->priv_flags & IFF_ISATAP), resolved by
      ipip6_tunnel_dst_find(..., true)
    - 6rd / 6to4, resolved per-packet via try_6rd() / check_6rd()
    - NBMA / point-to-multipoint (tiph->daddr =3D=3D 0), resolved by
      ipip6_tunnel_dst_find(..., false)
  In these cases ip_route_output(daddr=3D0) will fall through to the default
  route, ctx->dev gets resolved to the wrong underlay, and every
  accelerated packet is encapsulated toward 0.0.0.0 (or a fixed unicast
  that does not match the flow) regardless of the actual inner
  destination.
  Compare ip6_tnl_fill_forward_path() which returns -EOPNOTSUPP when it
  detects unsupported tunnel features; would something equivalent make
  sense here, at least for !tiph->daddr, IFF_ISATAP, and 6rd configured
  tunnels?
  Does this path also need to consider tunnel->encap?  SIT supports FOU
  and GUE via ip_tunnel_encap(skb, &tunnel->encap, &protocol, &fl4) in the
  slow path, and there is no rejection here when tunnel->encap.type is
  not TUNNEL_ENCAP_NONE.  Once a SIT tunnel that was configured with
  encap fou/gue is attached to a flowtable, the fast path pushes a plain
  IPv4 outer header via nf_flow_tunnel_ipip_push() and skips the FOU/GUE
  encapsulation entirely.  ip6_tnl_fill_forward_path() has an
  -EOPNOTSUPP guard for its own analogous case (encaplimit); would a
  similar guard work here?
  The slow path in ipip6_tunnel_xmit() uses flowi4_init_output() with
  tunnel->parms.link (oif), tunnel->fwmark, tos & INET_DSCP_MASK, and
  tiph->saddr:
      flowi4_init_output(&fl4, tunnel->parms.link, tunnel->fwmark,
                         tos & INET_DSCP_MASK, RT_SCOPE_UNIVERSE,
                         IPPROTO_IPV6, 0, dst, tiph->saddr, ...);
  The call above passes 0 for saddr, dscp and oif and does not pass a
  fwmark.  For a SIT tunnel bound to a specific link, using fwmark-based
  policy routing, or configured with a source address, can the fast-path
  route lookup diverge from what the slow path would pick, so that
  rt->dst.dev (which becomes ctx->dev and drives the flowtable egress)
  ends up on a different underlay device than slow-path packets on the
  same tunnel?
  - I will fix it in v5.

- Is it safe to hardcode IPPROTO_IPV6 here?  sit_tunnel_xmit() dispatches
  on skb->protocol and legitimately supports ETH_P_IP (IPv4-in-IPv4 via
  IPPROTO_IPIP) and, if CONFIG_MPLS is set, ETH_P_MPLS_UC (IPPROTO_MPLS);
  ipip6_valid_ip_proto() also accepts both on the receive side.
  If flowtable acceleration engages for a flow whose inner payload is
  IPv4 or MPLS through a SIT device, the outer iph->protocol that
  nf_flow_tunnel_ipip_push() synthesises from tuple->tun.l3_proto will be
  IPPROTO_IPV6, and the receiver will drop or misparse the packet.
  ip6_tnl_fill_forward_path() selects l3_proto from ctx->ether_type
  (ETH_P_IP =3D> IPPROTO_IPIP, else IPPROTO_IPV6) =E2=80=94 would something=
 similar
  be appropriate here?
  - I will fix it in v5.

Regards,
Lorenzo

> +}
> +
>  static int
>  ipip6_tunnel_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
>  			    void __user *data, int cmd)
> @@ -1401,6 +1426,7 @@ static const struct net_device_ops ipip6_netdev_ops=
 =3D {
>  	.ndo_siocdevprivate =3D ipip6_tunnel_siocdevprivate,
>  	.ndo_get_iflink =3D ip_tunnel_get_iflink,
>  	.ndo_tunnel_ctl =3D ipip6_tunnel_ctl,
> +	.ndo_fill_forward_path =3D ipip6_tunnel_fill_forward_path,
>  };
> =20
>  static void ipip6_dev_free(struct net_device *dev)
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_tab=
le_ip.c
> index 4b6de16bd4f3..f02e71ae5448 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -338,7 +338,7 @@ static bool nf_flow_ip4_tunnel_proto(struct nf_flowta=
ble_ctx *ctx,
>  	if (iph->ttl <=3D 1)
>  		return false;
> =20
> -	if (iph->protocol =3D=3D IPPROTO_IPIP) {
> +	if (iph->protocol =3D=3D IPPROTO_IPIP || iph->protocol =3D=3D IPPROTO_I=
PV6) {
>  		ctx->tun.proto =3D iph->protocol;
>  		ctx->tun.hdr_size =3D size;
>  		ctx->offset +=3D ctx->tun.hdr_size;
> @@ -464,21 +464,6 @@ static void nf_flow_encap_pop(struct nf_flowtable_ct=
x *ctx,
>  		nf_flow_ip_tunnel_pop(ctx, skb);
>  }
> =20
> -static struct flow_offload_tuple_rhash *
> -nf_flow_offload_lookup(struct nf_flowtable_ctx *ctx,
> -		       struct nf_flowtable *flow_table, struct sk_buff *skb)
> -{
> -	struct flow_offload_tuple tuple =3D {};
> -
> -	if (!nf_flow_skb_encap_protocol(ctx, skb, htons(ETH_P_IP)))
> -		return NULL;
> -
> -	if (nf_flow_tuple_ip(ctx, skb, &tuple) < 0)
> -		return NULL;
> -
> -	return flow_offload_lookup(flow_table, &tuple);
> -}
> -
>  static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
>  				   struct nf_flowtable *flow_table,
>  				   struct flow_offload_tuple_rhash *tuplehash,
> @@ -606,19 +591,33 @@ static int nf_flow_tunnel_ipip_push(struct net *net=
, struct sk_buff *skb,
>  				    struct flow_offload_tuple *tuple,
>  				    __be32 *ip_daddr)
>  {
> -	struct iphdr *iph =3D (struct iphdr *)skb_network_header(skb);
>  	struct rtable *rt =3D dst_rtable(tuple->dst_cache);
> -	u8 tos =3D iph->tos, ttl =3D iph->ttl;
> -	__be16 frag_off =3D iph->frag_off;
> -	u32 headroom =3D sizeof(*iph);
> +	__be16 frag_off =3D 0;
> +	struct iphdr *iph;
> +	u8 tos =3D 0, ttl;
> +	u32 headroom;
>  	int err;
> =20
> +	if (tuple->tun.l3_proto =3D=3D IPPROTO_IPV6) {
> +		struct ipv6hdr *ip6h;
> +
> +		ip6h =3D (struct ipv6hdr *)skb_network_header(skb);
> +		tos =3D ipv6_get_dsfield(ip6h);
> +		ttl =3D ip6h->hop_limit;
> +	} else {
> +		iph =3D (struct iphdr *)skb_network_header(skb);
> +		frag_off =3D iph->frag_off;
> +		tos =3D iph->tos;
> +		ttl =3D iph->ttl;
> +	}
> +
>  	err =3D iptunnel_handle_offloads(skb, SKB_GSO_IPXIP4);
>  	if (err)
>  		return err;
> =20
> -	skb_set_inner_ipproto(skb, IPPROTO_IPIP);
> -	headroom +=3D LL_RESERVED_SPACE(rt->dst.dev) + rt->dst.header_len;
> +	skb_set_inner_ipproto(skb, tuple->tun.l3_proto);
> +	headroom =3D sizeof(*iph) + LL_RESERVED_SPACE(rt->dst.dev) +
> +		   rt->dst.header_len;
>  	err =3D skb_cow_head(skb, headroom);
>  	if (err)
>  		return err;
> @@ -629,6 +628,7 @@ static int nf_flow_tunnel_ipip_push(struct net *net, =
struct sk_buff *skb,
>  	/* Push down and install the IP header. */
>  	skb_push(skb, sizeof(*iph));
>  	skb_reset_network_header(skb);
> +	skb->protocol =3D htons(ETH_P_IP);
> =20
>  	iph =3D ip_hdr(skb);
>  	iph->version	=3D 4;
> @@ -723,16 +723,6 @@ static int nf_flow_tunnel_push(struct net *net, stru=
ct sk_buff *skb,
>  	}
>  }
> =20
> -static int nf_flow_tunnel_v6_push(struct net *net, struct sk_buff *skb,
> -				  struct flow_offload_tuple *tuple,
> -				  struct in6_addr **ip6_daddr)
> -{
> -	if (tuple->tun_num)
> -		return nf_flow_tunnel_ip6ip6_push(net, skb, tuple, ip6_daddr);
> -
> -	return 0;
> -}
> -
>  static int nf_flow_encap_push(struct sk_buff *skb,
>  			      struct flow_offload_tuple *tuple,
>  			      struct net_device *outdev)
> @@ -830,103 +820,6 @@ static unsigned int nf_flow_queue_xmit(struct net *=
net, struct sk_buff *skb,
>  	return NF_STOLEN;
>  }
> =20
> -unsigned int
> -nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
> -			const struct nf_hook_state *state)
> -{
> -	struct flow_offload_tuple_rhash *tuplehash;
> -	struct nf_flowtable *flow_table =3D priv;
> -	struct flow_offload_tuple *other_tuple;
> -	enum flow_offload_tuple_dir dir;
> -	struct nf_flowtable_ctx ctx =3D {
> -		.in	=3D state->in,
> -	};
> -	struct nf_flow_xmit xmit =3D {};
> -	struct in6_addr *ip6_daddr;
> -	struct flow_offload *flow;
> -	struct neighbour *neigh;
> -	struct rtable *rt;
> -	__be32 ip_daddr;
> -	int ret;
> -
> -	tuplehash =3D nf_flow_offload_lookup(&ctx, flow_table, skb);
> -	if (!tuplehash)
> -		return NF_ACCEPT;
> -
> -	ret =3D nf_flow_offload_forward(&ctx, flow_table, tuplehash, skb);
> -	if (ret < 0)
> -		return NF_DROP;
> -	else if (ret =3D=3D 0)
> -		return NF_ACCEPT;
> -
> -	if (unlikely(tuplehash->tuple.xmit_type =3D=3D FLOW_OFFLOAD_XMIT_XFRM))=
 {
> -		rt =3D dst_rtable(tuplehash->tuple.dst_cache);
> -		memset(skb->cb, 0, sizeof(struct inet_skb_parm));
> -		IPCB(skb)->iif =3D skb->dev->ifindex;
> -		IPCB(skb)->flags =3D IPSKB_FORWARDED;
> -		return nf_flow_xmit_xfrm(skb, state, &rt->dst);
> -	}
> -
> -	dir =3D tuplehash->tuple.dir;
> -	flow =3D container_of(tuplehash, struct flow_offload, tuplehash[dir]);
> -	other_tuple =3D &flow->tuplehash[!dir].tuple;
> -	ip_daddr =3D other_tuple->src_v4.s_addr;
> -
> -	if (nf_flow_tunnel_push(state->net, skb, other_tuple, &ip_daddr,
> -				&ip6_daddr) < 0)
> -		return NF_DROP;
> -
> -	switch (tuplehash->tuple.xmit_type) {
> -	case FLOW_OFFLOAD_XMIT_NEIGH: {
> -		struct dst_entry *dst;
> -
> -		xmit.outdev =3D dev_get_by_index_rcu(state->net, tuplehash->tuple.ifid=
x);
> -		if (!xmit.outdev) {
> -			flow_offload_teardown(flow);
> -			return NF_DROP;
> -		}
> -		if (other_tuple->tun.encap_proto =3D=3D AF_INET6 ||
> -		    ctx.tun.proto =3D=3D IPPROTO_IPV6) {
> -			struct rt6_info *rt6;
> -
> -			rt6 =3D dst_rt6_info(tuplehash->tuple.dst_cache);
> -			neigh =3D ip_neigh_gw6(rt6->dst.dev,
> -					     rt6_nexthop(rt6, ip6_daddr));
> -			dst =3D &rt6->dst;
> -		} else {
> -			rt =3D dst_rtable(tuplehash->tuple.dst_cache);
> -			neigh =3D ip_neigh_gw4(rt->dst.dev,
> -					     rt_nexthop(rt, ip_daddr));
> -			dst =3D &rt->dst;
> -		}
> -		if (IS_ERR(neigh)) {
> -			flow_offload_teardown(flow);
> -			return NF_DROP;
> -		}
> -		xmit.dest =3D neigh->ha;
> -		skb_dst_set_noref(skb, dst);
> -		break;
> -	}
> -	case FLOW_OFFLOAD_XMIT_DIRECT:
> -		xmit.outdev =3D dev_get_by_index_rcu(state->net, tuplehash->tuple.out.=
ifidx);
> -		if (!xmit.outdev) {
> -			flow_offload_teardown(flow);
> -			return NF_DROP;
> -		}
> -		xmit.dest =3D tuplehash->tuple.out.h_dest;
> -		xmit.source =3D tuplehash->tuple.out.h_source;
> -		break;
> -	default:
> -		WARN_ON_ONCE(1);
> -		return NF_DROP;
> -	}
> -	xmit.tuple =3D other_tuple;
> -	xmit.needs_gso_segment =3D tuplehash->tuple.needs_gso_segment;
> -
> -	return nf_flow_queue_xmit(state->net, skb, &xmit);
> -}
> -EXPORT_SYMBOL_GPL(nf_flow_offload_ip_hook);
> -
>  static void nf_flow_nat_ipv6_tcp(struct sk_buff *skb, unsigned int thoff,
>  				 struct in6_addr *addr,
>  				 struct in6_addr *new_addr,
> @@ -1111,8 +1004,16 @@ static int nf_flow_offload_ipv6_forward(struct nf_=
flowtable_ctx *ctx,
>  	flow =3D container_of(tuplehash, struct flow_offload, tuplehash[dir]);
> =20
>  	mtu =3D flow->tuplehash[dir].tuple.mtu + ctx->offset;
> -	if (flow->tuplehash[!dir].tuple.tun_num)
> +	switch (flow->tuplehash[!dir].tuple.tun.encap_proto) {
> +	case AF_INET:
> +		mtu -=3D sizeof(struct iphdr);
> +		break;
> +	case AF_INET6:
>  		mtu -=3D sizeof(*ip6h);
> +		break;
> +	default:
> +		break;
> +	}
> =20
>  	if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
>  		return 0;
> @@ -1146,6 +1047,25 @@ static int nf_flow_offload_ipv6_forward(struct nf_=
flowtable_ctx *ctx,
>  	return 1;
>  }
> =20
> +static struct flow_offload_tuple_rhash *
> +nf_flow_offload_lookup(struct nf_flowtable_ctx *ctx,
> +		       struct nf_flowtable *flow_table, struct sk_buff *skb)
> +{
> +	struct flow_offload_tuple tuple =3D {};
> +
> +	if (!nf_flow_skb_encap_protocol(ctx, skb, htons(ETH_P_IP)))
> +		return NULL;
> +
> +	if (ctx->tun.proto =3D=3D IPPROTO_IPV6) {
> +		if (nf_flow_tuple_ipv6(ctx, skb, &tuple) < 0)
> +			return NULL;
> +	} else if (nf_flow_tuple_ip(ctx, skb, &tuple) < 0) {
> +		return NULL;
> +	}
> +
> +	return flow_offload_lookup(flow_table, &tuple);
> +}
> +
>  static struct flow_offload_tuple_rhash *
>  nf_flow_offload_ipv6_lookup(struct nf_flowtable_ctx *ctx,
>  			    struct nf_flowtable *flow_table,
> @@ -1166,6 +1086,108 @@ nf_flow_offload_ipv6_lookup(struct nf_flowtable_c=
tx *ctx,
>  	return flow_offload_lookup(flow_table, &tuple);
>  }
> =20
> +unsigned int
> +nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
> +			const struct nf_hook_state *state)
> +{
> +	struct flow_offload_tuple_rhash *tuplehash;
> +	struct nf_flowtable *flow_table =3D priv;
> +	struct flow_offload_tuple *other_tuple;
> +	enum flow_offload_tuple_dir dir;
> +	struct nf_flowtable_ctx ctx =3D {
> +		.in	=3D state->in,
> +	};
> +	struct nf_flow_xmit xmit =3D {};
> +	struct in6_addr *ip6_daddr;
> +	struct flow_offload *flow;
> +	struct neighbour *neigh;
> +	struct rtable *rt;
> +	__be32 ip_daddr;
> +	int ret;
> +
> +	tuplehash =3D nf_flow_offload_lookup(&ctx, flow_table, skb);
> +	if (!tuplehash)
> +		return NF_ACCEPT;
> +
> +	if (ctx.tun.proto =3D=3D IPPROTO_IPV6)
> +		ret =3D nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash,
> +						   skb);
> +	else
> +		ret =3D nf_flow_offload_forward(&ctx, flow_table, tuplehash, skb);
> +	if (ret < 0)
> +		return NF_DROP;
> +	else if (ret =3D=3D 0)
> +		return NF_ACCEPT;
> +
> +	if (unlikely(tuplehash->tuple.xmit_type =3D=3D FLOW_OFFLOAD_XMIT_XFRM))=
 {
> +		rt =3D dst_rtable(tuplehash->tuple.dst_cache);
> +		memset(skb->cb, 0, sizeof(struct inet_skb_parm));
> +		IPCB(skb)->iif =3D skb->dev->ifindex;
> +		IPCB(skb)->flags =3D IPSKB_FORWARDED;
> +		return nf_flow_xmit_xfrm(skb, state, &rt->dst);
> +	}
> +
> +	dir =3D tuplehash->tuple.dir;
> +	flow =3D container_of(tuplehash, struct flow_offload, tuplehash[dir]);
> +	other_tuple =3D &flow->tuplehash[!dir].tuple;
> +	ip_daddr =3D other_tuple->src_v4.s_addr;
> +	ip6_daddr =3D &other_tuple->src_v6;
> +
> +	if (nf_flow_tunnel_push(state->net, skb, other_tuple, &ip_daddr,
> +				&ip6_daddr) < 0)
> +		return NF_DROP;
> +
> +	switch (tuplehash->tuple.xmit_type) {
> +	case FLOW_OFFLOAD_XMIT_NEIGH: {
> +		struct dst_entry *dst;
> +
> +		xmit.outdev =3D dev_get_by_index_rcu(state->net, tuplehash->tuple.ifid=
x);
> +		if (!xmit.outdev) {
> +			flow_offload_teardown(flow);
> +			return NF_DROP;
> +		}
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
> +		if (IS_ERR(neigh)) {
> +			flow_offload_teardown(flow);
> +			return NF_DROP;
> +		}
> +		xmit.dest =3D neigh->ha;
> +		skb_dst_set_noref(skb, dst);
> +		break;
> +	}
> +	case FLOW_OFFLOAD_XMIT_DIRECT:
> +		xmit.outdev =3D dev_get_by_index_rcu(state->net, tuplehash->tuple.out.=
ifidx);
> +		if (!xmit.outdev) {
> +			flow_offload_teardown(flow);
> +			return NF_DROP;
> +		}
> +		xmit.dest =3D tuplehash->tuple.out.h_dest;
> +		xmit.source =3D tuplehash->tuple.out.h_source;
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +		return NF_DROP;
> +	}
> +	xmit.tuple =3D other_tuple;
> +	xmit.needs_gso_segment =3D tuplehash->tuple.needs_gso_segment;
> +
> +	return nf_flow_queue_xmit(state->net, skb, &xmit);
> +}
> +EXPORT_SYMBOL_GPL(nf_flow_offload_ip_hook);
> +
>  unsigned int
>  nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
>  			  const struct nf_hook_state *state)
> @@ -1182,6 +1204,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buf=
f *skb,
>  	struct flow_offload *flow;
>  	struct neighbour *neigh;
>  	struct rt6_info *rt;
> +	__be32 ip_daddr;
>  	int ret;
> =20
>  	tuplehash =3D nf_flow_offload_ipv6_lookup(&ctx, flow_table, skb);
> @@ -1209,10 +1232,11 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_b=
uff *skb,
>  	dir =3D tuplehash->tuple.dir;
>  	flow =3D container_of(tuplehash, struct flow_offload, tuplehash[dir]);
>  	other_tuple =3D &flow->tuplehash[!dir].tuple;
> +	ip_daddr =3D other_tuple->src_v4.s_addr;
>  	ip6_daddr =3D &other_tuple->src_v6;
> =20
> -	if (nf_flow_tunnel_v6_push(state->net, skb, other_tuple,
> -				   &ip6_daddr) < 0)
> +	if (nf_flow_tunnel_push(state->net, skb, other_tuple, &ip_daddr,
> +				&ip6_daddr) < 0)
>  		return NF_DROP;
> =20
>  	switch (tuplehash->tuple.xmit_type) {
> @@ -1226,10 +1250,8 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_bu=
ff *skb,
>  		}
>  		if (other_tuple->tun.encap_proto =3D=3D AF_INET ||
>  		    ctx.tun.proto =3D=3D IPPROTO_IPIP) {
> -			__be32 ip_daddr =3D other_tuple->src_v4.s_addr;
>  			struct rtable *rt4;
> =20
> -			skb->protocol =3D htons(ETH_P_IP);
>  			rt4 =3D dst_rtable(tuplehash->tuple.dst_cache);
>  			neigh =3D ip_neigh_gw4(rt4->dst.dev,
>  					     rt_nexthop(rt4, ip_daddr));
>=20
> --=20
> 2.55.0
>=20

--NkuvXEfgx3dvazRZ
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCak4nlgAKCRA6cBh0uS2t
rOh5AP9fOGNYzlTp7AR2qFPq8VS8a6YuIHmKAzD1VpsxUjVTmwD8D+8nU13rcQk+
V1y0WA1OUphgiW0Tj3vJT8Xs7OmmRQI=
=0lEd
-----END PGP SIGNATURE-----

--NkuvXEfgx3dvazRZ--
