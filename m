Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A735D37B41E
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Aug 2026 09:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786093319; cv=none; b=WXR9K1qPHETbfqk4q1aubLB/5XYDN6cGztncw5UuN7DymVumSGcACI9T7Y0M+kaksYSjMQHGRAHitB+aLh/t11urui+jcoo55foUis9Z8fmsppuISdskW6MuXgOSOJwZUFF8rIEUgwv6smzvMESjoFpk6qeFXv3aPgEJf03KvYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786093319; c=relaxed/simple;
	bh=Dvq6K/eiQo1a20rMIdk15ulfygwLvlFzqkciK6w26yM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ufrVtV0kdVS+8Y7Wjo6Jbq/L+2X/c2jwg8bv3aKkXGbnxVrwFsAgV9+vba2flyEvdwrkxWUlHbylKiXJlaEm5bs9k2oVo9K3OLsLZr12u4hXsPsz4bjztPhuglR/zX5GaKMxGU3L/ATS6M7EfrnWXn6nk3AJ4hUHMP2WpcaWK50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LzjX1PLc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LzjX1PLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1451F000E9;
	Fri,  7 Aug 2026 09:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786093318;
	bh=KIyE4GZWPDOhyd90viu1yoV63t6BILiojCERezNc3L0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LzjX1PLcfVs5JAUo5w4YAMWjUUv/5C15WqJbL4ZzCaLuVQz1GWjwl/B92xqTM7pTT
	 OSHkRmieIyEhve2Tt/vZrF2XvQstUIVYyBGG8Oy1ITYWcNAtCIMJ3vKt1qje/4PIW8
	 TrxKUgUpLr/ECl0tmIZHXkZ1dAXr8d6/fPz6Wiv2QQ+empPKw5XGmOf7WYd0Xjk/B/
	 J6EETjDWsYMayrg5Vz1f+LDtVjU1+RsRwg7et4kmg/cwxu84Rlr4lIJx+UYnS+xih3
	 9cjNlD4gkuBDcKnUByWitikZSQ2c2PfceDYelBI9L6W9FjvsMgPoMlZINKbwHtN3PZ
	 Azf2SBspbQ3pA==
Date: Fri, 7 Aug 2026 11:01:56 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, lorenzo.bianconi@oss.qualcomm.com
Subject: Re: [PATCH nf-next 3/7] netfilter: flowtable: rename tun.l3_proto to
 tun.inner_proto
Message-ID: <anWfBPYIZcbHnoQj@lore-desk>
References: <20260806223535.523098-1-pablo@netfilter.org>
 <20260806223535.523098-4-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Z9Wl3+lF058YTw2p"
Content-Disposition: inline
In-Reply-To: <20260806223535.523098-4-pablo@netfilter.org>

--Z9Wl3+lF058YTw2p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> This field refers to the inner protocol that is encapsulated by the
> tunnel header, just a comestic change. No functional changes are
> expected.
>=20
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  include/linux/netdevice.h             | 2 +-
>  include/net/netfilter/nf_flow_table.h | 2 +-
>  net/ipv4/ipip.c                       | 2 +-
>  net/ipv6/ip6_tunnel.c                 | 2 +-
>  net/netfilter/nf_flow_table_ip.c      | 6 +++---
>  net/netfilter/nf_flow_table_path.c    | 4 ++--
>  6 files changed, 9 insertions(+), 9 deletions(-)
>=20
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index d9962c50bd60..68ccb5868070 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -902,7 +902,7 @@ struct net_device_path {
>  				struct in6_addr	dst_v6;
>  			};
> =20
> -			u8	l3_proto;
> +			u8	inner_proto;
>  		} tun;
>  		struct {
>  			enum {
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilte=
r/nf_flow_table.h
> index a090ec3ffef2..f2e2771f188f 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -117,7 +117,7 @@ struct flow_offload_tunnel {
>  		struct in6_addr	dst_v6;
>  	};
> =20
> -	u8	l3_proto;
> +	u8	inner_proto;
>  };
> =20
>  struct flow_offload_tuple {
> diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
> index 62a374079bfc..1630325c77d3 100644
> --- a/net/ipv4/ipip.c
> +++ b/net/ipv4/ipip.c
> @@ -378,7 +378,7 @@ static int ipip_fill_forward_path(struct net_device_p=
ath_ctx *ctx,
>  	path->type =3D DEV_PATH_TUN;
>  	path->tun.src_v4.s_addr =3D tiph->saddr;
>  	path->tun.dst_v4.s_addr =3D tiph->daddr;
> -	path->tun.l3_proto =3D IPPROTO_IPIP;
> +	path->tun.inner_proto =3D IPPROTO_IPIP;
>  	path->tun.dst =3D &rt->dst;
>  	path->dev =3D ctx->dev;
> =20
> diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> index 3bfaa98e7f33..7b54919232ba 100644
> --- a/net/ipv6/ip6_tunnel.c
> +++ b/net/ipv6/ip6_tunnel.c
> @@ -1872,7 +1872,7 @@ static int ip6_tnl_fill_forward_path(struct net_dev=
ice_path_ctx *ctx,
>  		path->type =3D DEV_PATH_TUN;
>  		path->tun.src_v6 =3D fl6.saddr;
>  		path->tun.dst_v6 =3D fl6.daddr;
> -		path->tun.l3_proto =3D IPPROTO_IPV6;
> +		path->tun.inner_proto =3D IPPROTO_IPV6;
>  		path->tun.dst =3D dst;
>  		path->dev =3D ctx->dev;
>  		ctx->dev =3D dst->dev;
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_tab=
le_ip.c
> index 0b314b10e705..e1aa01763f33 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -197,7 +197,7 @@ static void nf_flow_tuple_encap(struct nf_flowtable_c=
tx *ctx,
>  		if (ctx->tun.proto =3D=3D IPPROTO_IPIP) {
>  			tuple->tun.dst_v4.s_addr =3D iph->daddr;
>  			tuple->tun.src_v4.s_addr =3D iph->saddr;
> -			tuple->tun.l3_proto =3D IPPROTO_IPIP;
> +			tuple->tun.inner_proto =3D IPPROTO_IPIP;
>  		}
>  		break;
>  	case htons(ETH_P_IPV6):
> @@ -205,7 +205,7 @@ static void nf_flow_tuple_encap(struct nf_flowtable_c=
tx *ctx,
>  		if (ctx->tun.proto =3D=3D IPPROTO_IPV6) {
>  			tuple->tun.dst_v6 =3D ip6h->daddr;
>  			tuple->tun.src_v6 =3D ip6h->saddr;
> -			tuple->tun.l3_proto =3D IPPROTO_IPV6;
> +			tuple->tun.inner_proto =3D IPPROTO_IPV6;
>  		}
>  		break;
>  	default:
> @@ -611,7 +611,7 @@ static int nf_flow_tunnel_ipip_push(struct net *net, =
struct sk_buff *skb,
>  	iph->version	=3D 4;
>  	iph->ihl	=3D sizeof(*iph) >> 2;
>  	iph->frag_off	=3D ip_mtu_locked(&rt->dst) ? 0 : frag_off;
> -	iph->protocol	=3D tuple->tun.l3_proto;
> +	iph->protocol	=3D tuple->tun.inner_proto;
>  	iph->tos	=3D tos;
>  	iph->daddr	=3D tuple->tun.src_v4.s_addr;
>  	iph->saddr	=3D tuple->tun.dst_v4.s_addr;
> diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_t=
able_path.c
> index 5f166da3b09b..1e55644f2edb 100644
> --- a/net/netfilter/nf_flow_table_path.c
> +++ b/net/netfilter/nf_flow_table_path.c
> @@ -133,7 +133,7 @@ static int nft_dev_path_info(struct net_device_path_s=
tack *stack,
> =20
>  				info->tun.src_v6 =3D path->tun.src_v6;
>  				info->tun.dst_v6 =3D path->tun.dst_v6;
> -				info->tun.l3_proto =3D path->tun.l3_proto;
> +				info->tun.inner_proto =3D path->tun.inner_proto;
>  				info->tun_dst =3D path->tun.dst;
>  				info->num_tuns++;
>  			} else {
> @@ -245,7 +245,7 @@ static int nft_dev_forward_path(const struct nft_pkti=
nfo *pkt,
>  	if (info.num_tuns) {
>  		route->tuple[!dir].in.tun.src_v6 =3D info.tun.dst_v6;
>  		route->tuple[!dir].in.tun.dst_v6 =3D info.tun.src_v6;
> -		route->tuple[!dir].in.tun.l3_proto =3D info.tun.l3_proto;
> +		route->tuple[!dir].in.tun.inner_proto =3D info.tun.inner_proto;
>  		route->tuple[!dir].in.num_tuns =3D info.num_tuns;
>  		dst_release(route->tuple[dir].dst);
>  		route->tuple[dir].dst =3D info.tun_dst;
> --=20
> 2.47.3
>=20

--Z9Wl3+lF058YTw2p
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCanWfBAAKCRA6cBh0uS2t
rN7EAP9KqWeLvjSB54yOHtoLixkXxKaLrFfbNeHFGVLdvvRYiQEAkuqk7cKL+8rR
x2v5XRFsNKDdU9UEyyAEk7qjNQ/s1gA=
=PT6T
-----END PGP SIGNATURE-----

--Z9Wl3+lF058YTw2p--
