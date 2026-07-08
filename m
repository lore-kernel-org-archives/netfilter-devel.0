Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8905C3AB5B8;
	Wed,  8 Jul 2026 08:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783498683; cv=none; b=AFDzbq8sNe923SH3jmhvZ9ZwbHC5694Q1L/2ZXiryz4ZLboHjaMF9d49TdZ5DSZNi2OZpzJd3Ha/InCWUfdlv8C338at5JCq5Eygxkd1h6+1e0l4XefLDkUIL9GSqoQ3I9w8D+wiHAkcGJrcBxrF789onkt0RUibQy5+OAjOl3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783498683; c=relaxed/simple;
	bh=IOp4ADjo0lhhLGWkZ1OUALRZpZmzVGqP5oZpOV9pSk0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lmguIrEyqwpKiAf8C+dFiwpbG3pss1i/iXtdVO4fuAo8HSFo1woOexDOPikE3XQJkt5/Tai1ggmU0IsMNx6WoEVQRhEmd5tatw5qfT/d/VWCdAnK00yruDwKFknl89ruUOo+4zKJ/Inf/37q/lakn9pErgLvtkgwzuSv8vLd97c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YhPnM10a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YhPnM10a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABAB91F000E9;
	Wed,  8 Jul 2026 08:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783498681;
	bh=Nm52Xlrw1GluHl4mcq4+4Pp2e2HBmEU2CFEZNaVo9gI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YhPnM10a9gwlKMBNycSZUM39DOUl9zyRQXQ1wVzwd8qDtzBS4/kf0Qs1WVXhaadDQ
	 LNtTMKeIQzPf95tCxGqavdjN9ptDFWSCrxVt6OQTrBWl7i3c8NZl/q23pyYKRKvXip
	 lR1lbJ5J5/6ND3wXMbQQAbNC8GMtWtWWBQKhxQss7Yo/HnpiPEkSGm2Bx6HEz4usW/
	 16llHLVN7Aj+uQtbN1SRDjK63it1I6ffHly8O7CH3Y+YYf5LPkdjLy1spE9ChW4XJV
	 gTERzkKKKoJDl9n/10ggCw1QZDzQSdBnguf2iMh/MRrlnJ6qktrEcTbWdeKaWTNqEP
	 83xqSULzzJC+A==
Date: Wed, 8 Jul 2026 10:17:58 +0200
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
Message-ID: <ak4HthcJhms-_tfT@lore-desk>
References: <20260703-b4-flowtable-sw-accel-ip6ip-v4-0-00398cd12382@kernel.org>
 <20260703-b4-flowtable-sw-accel-ip6ip-v4-5-00398cd12382@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Oz9APxSaQ2vAwgoj"
Content-Disposition: inline
In-Reply-To: <20260703-b4-flowtable-sw-accel-ip6ip-v4-5-00398cd12382@kernel.org>


--Oz9APxSaQ2vAwgoj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

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

commenting on sashiko's report:
https://sashiko.dev/#/patchset/20260703-b4-flowtable-sw-accel-ip6ip-v4-0-00=
398cd12382%40kernel.org

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

- Does this handle NBMA (ISATAP/6to4/6rd) SIT tunnels correctly? For these
  tunnels, tiph->daddr is typically 0 since the remote destination is resol=
ved
  per-packet.
  If we unconditionally query the routing table here with tiph->daddr, it
  will route to 0.0.0.0, causing the flow offload tuple to use 0.0.0.0 as t=
he
  outer encapsulation destination. Could this result in all offloaded traff=
ic
  for these tunnels being silently dropped?
  - I will fix it in v5

> +	if (IS_ERR(rt))
> +		return PTR_ERR(rt);
> +
> +	path->type =3D DEV_PATH_TUN;
> +	path->tun.src_v4.s_addr =3D tiph->saddr;
> +	path->tun.dst_v4.s_addr =3D tiph->daddr;
> +	path->tun.l3_proto =3D IPPROTO_IPV6;

- Is it safe to hardcode path->tun.l3_proto to IPPROTO_IPV6 here?
  SIT tunnels can also support IPv4 payloads. If an IPv4 flow is offloaded
  over a SIT tunnel, the flow tuple will erroneously record the payload as
  IPv6. During encapsulation, nf_flow_tunnel_ipip_push() might then parse
  the inner IPv4 header as an IPv6 header, which could corrupt TOS and TTL
  extraction.
  - I will fix it in v5

> +	path->tun.encap_proto =3D AF_INET;
> +	path->dev =3D ctx->dev;
> +
> +	ctx->dev =3D rt->dst.dev;
> +	ip_rt_put(rt);
> +
> +	return 0;
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

- This isn't a bug introduced by this patch, but is it correct to calculate
  the headroom using rt->dst.dev?
  The rt variable is derived from the reply direction tuple, so rt->dst.dev
  points to the internal ingress device (e.g. eth0) rather than the egress
  underlay device (e.g. eth1).
  If the physical egress device requires more headroom than the internal
  device, this allocation might be too small and trigger an skb_under_panic
  during encapsulation.
  - This is already fixed by a Pablo's fix

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

- Since ctx.tun.proto can now be IPPROTO_IPV6 for an inner IPv6 packet
  encapsulated in IPv4, is it safe to unconditionally cast the route to
  rtable and initialize IPCB(skb) here?
  - This is not a real problem since IP tunnel flowtable acceleration is not
    supported for FLOW_OFFLOAD_XMIT_XFRM xmit_type.

Regards,
Lorenzo

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

--Oz9APxSaQ2vAwgoj
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCak4HtgAKCRA6cBh0uS2t
rGpOAQDCkU3Vscylv74eHnaaoL0n+IhBoXjPk01p6STMIWJHlwD/WI3QrHCtFS9G
4OFbvq1Mlh6WhzD625CmYluuRt3z5w0=
=WL9c
-----END PGP SIGNATURE-----

--Oz9APxSaQ2vAwgoj--
