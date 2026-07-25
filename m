Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0833939B6
	for <netfilter-devel@vger.kernel.org>; Sat, 25 Jul 2026 11:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784977507; cv=none; b=b8rM6g57Z4zFAvsJH+Fe+J7VVEiuXpKTAEjySzoHLgvAd2KG0FB6E6B0XXMbudDjfiHxqVvr0NL9pCC7/W5k+/2AjCpphYr8VuzuZ1mXxzmoBMbMnIWBntPVPS+ts3ofkEQ5OqEZ5ODNjPBMkjImAl73cKDxZ2KKY6XLFoDdfHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784977507; c=relaxed/simple;
	bh=k0n/ypd2e2x0CEDZWtP4OnopLDyvorxrx3X5LyK4ppM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nk+U70HrfGSivk0gL+tSr4JmtwzeUigv4xxCeWqTykQ76qTHF7VwOcsagp8ZpP/v+OHLvly0ibZ8MEdfy2UpBq4nX1HwDw0SQHGMjxY0mpPiv512ALMO7QPOuFGEF6pKlJgoEjO8iGr478qPykHtTadRcgEWNMqRBD5vm5bjm4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eiwdx4j/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eiwdx4j/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82AED1F000E9;
	Sat, 25 Jul 2026 11:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784977506;
	bh=RNsbrdYfK08wAKqV7WGgVaMaATui5n+9wCaMWDh1RYE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eiwdx4j/IOPTVy7cfAw/WnZujteHBeve2dmXU2mkAQXfgDPSfAK0joMq09RtVPyc7
	 LpuewbkQOGcNgxdqqwHlHysbsmJ3HBLK2ABeHr7NL/W1P0oQlHA03YSUMoyURgr8R/
	 4qyDemrZvgOW1nnknIrG2PxfY1xU9s3GgmxulLG+lb8G9+lQBa4xy3ZqFlz5lqE/qj
	 9bQI/tSahXLuns8svqXK1pfv8bn3dmj5+IvFmezk5eq43ztzwSDMYfxSJiHcUJm1Lr
	 AnqPTHCoTwVu6DBT8FbKEcBZAYecHEwsfQL+RAg15h4+gpMc4GTLVIGDiDVcOJPXRt
	 tPKKi37DH+y1g==
Date: Sat, 25 Jul 2026 13:05:03 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 4/4] netfilter: flowtable: release tunnel route
 on error when building forward path
Message-ID: <amSYX4uSAaHHJWZR@lore-desk>
References: <20260723174952.329650-1-pablo@netfilter.org>
 <20260723174952.329650-5-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/s1sPBZN7mwKCzQC"
Content-Disposition: inline
In-Reply-To: <20260723174952.329650-5-pablo@netfilter.org>

--/s1sPBZN7mwKCzQC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> nft_flow_tunnel_update_route() can lazy fail, leaving an incomplete
> forward path set ip. The route lookup also happens twice, once from
> dev_fill_forward_path() and again in this aforementioned function.
>=20
> Update ipip and ip6ip6 not to release the dst_entry and pass it on
> via the tunnel forward path information.
>=20
> In case of failure when setting up the forwarding path, release the
> tunnel dst that was provided via dev_fill_forward_path().
>=20
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  net/ipv4/ipip.c                    |  2 +-
>  net/ipv6/ip6_tunnel.c              |  2 +-
>  net/netfilter/nf_flow_table_path.c | 62 ++++++++----------------------
>  3 files changed, 18 insertions(+), 48 deletions(-)
>=20
> diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
> index d1aa048a6099..0a4fa1351dd7 100644
> --- a/net/ipv4/ipip.c
> +++ b/net/ipv4/ipip.c
> @@ -370,10 +370,10 @@ static int ipip_fill_forward_path(struct net_device=
_path_ctx *ctx,
>  	path->tun.src_v4.s_addr =3D tiph->saddr;
>  	path->tun.dst_v4.s_addr =3D tiph->daddr;
>  	path->tun.l3_proto =3D IPPROTO_IPIP;
> +	path->tun.dst =3D &rt->dst;
>  	path->dev =3D ctx->dev;
> =20
>  	ctx->dev =3D rt->dst.dev;
> -	ip_rt_put(rt);
> =20
>  	return 0;
>  }
> diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> index bf8e40af60b0..312de4a6e160 100644
> --- a/net/ipv6/ip6_tunnel.c
> +++ b/net/ipv6/ip6_tunnel.c
> @@ -1864,12 +1864,12 @@ static int ip6_tnl_fill_forward_path(struct net_d=
evice_path_ctx *ctx,
>  		path->tun.src_v6 =3D t->parms.laddr;
>  		path->tun.dst_v6 =3D t->parms.raddr;
>  		path->tun.l3_proto =3D IPPROTO_IPV6;
> +		path->tun.dst =3D dst;
>  		path->dev =3D ctx->dev;
>  		ctx->dev =3D dst->dev;
>  	}
> =20
>  	err =3D dst->error;
> -	dst_release(dst);
> =20
>  	return err;
>  }
> diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_t=
able_path.c
> index 8f04a4487897..9f6fc29c4e16 100644
> --- a/net/netfilter/nf_flow_table_path.c
> +++ b/net/netfilter/nf_flow_table_path.c
> @@ -82,6 +82,7 @@ struct nft_forward_info {
>  	} encap[NF_FLOW_TABLE_ENCAP_MAX];
>  	u8 num_encaps;
>  	struct flow_offload_tunnel tun;
> +	struct dst_entry *tun_dst;
>  	u8 num_tuns;
>  	u8 ingress_vlans;
>  	u8 h_source[ETH_ALEN];
> @@ -124,15 +125,16 @@ static int nft_dev_path_info(const struct net_devic=
e_path_stack *stack,
>  			/* DEV_PATH_VLAN, DEV_PATH_PPPOE and DEV_PATH_TUN */
>  			if (path->type =3D=3D DEV_PATH_TUN) {
>  				if (info->num_tuns)
> -					return -1;
> +					goto err_out;
> =20
>  				info->tun.src_v6 =3D path->tun.src_v6;
>  				info->tun.dst_v6 =3D path->tun.dst_v6;
>  				info->tun.l3_proto =3D path->tun.l3_proto;
> +				info->tun_dst =3D path->tun.dst;
>  				info->num_tuns++;
>  			} else {
>  				if (info->num_encaps >=3D NF_FLOW_TABLE_ENCAP_MAX)
> -					return -1;
> +					goto err_out;
> =20
>  				info->encap[info->num_encaps].id =3D
>  					path->encap.id;
> @@ -153,13 +155,13 @@ static int nft_dev_path_info(const struct net_devic=
e_path_stack *stack,
>  			switch (path->bridge.vlan_mode) {
>  			case DEV_PATH_BR_VLAN_UNTAG_HW:
>  				if (info->num_encaps =3D=3D 0)
> -					return -1;
> +					goto err_out;
> =20
>  				info->ingress_vlans |=3D BIT(info->num_encaps - 1);
>  				break;
>  			case DEV_PATH_BR_VLAN_TAG:
>  				if (info->num_encaps >=3D NF_FLOW_TABLE_ENCAP_MAX)
> -					return -1;
> +					goto err_out;
> =20
>  				info->encap[info->num_encaps].id =3D path->bridge.vlan_id;
>  				info->encap[info->num_encaps].proto =3D path->bridge.vlan_proto;
> @@ -167,7 +169,7 @@ static int nft_dev_path_info(const struct net_device_=
path_stack *stack,
>  				break;
>  			case DEV_PATH_BR_VLAN_UNTAG:
>  				if (info->num_encaps =3D=3D 0)
> -					return -1;
> +					goto err_out;
> =20
>  				info->num_encaps--;
>  				break;
> @@ -177,7 +179,7 @@ static int nft_dev_path_info(const struct net_device_=
path_stack *stack,
>  			info->xmit_type =3D FLOW_OFFLOAD_XMIT_DIRECT;
>  			break;
>  		default:
> -			return -1;
> +			goto err_out;
>  		}
>  	}
> =20
> @@ -189,6 +191,11 @@ static int nft_dev_path_info(const struct net_device=
_path_stack *stack,
>  		return -1;
> =20
>  	return 0;
> +err_out:
> +	if (info->num_tuns)
> +		dst_release(info->tun_dst);
> +
> +	return -1;
>  }
> =20
>  static bool nft_flowtable_find_dev(const struct net_device *dev,
> @@ -208,44 +215,6 @@ static bool nft_flowtable_find_dev(const struct net_=
device *dev,
>  	return found;
>  }
> =20
> -static int nft_flow_tunnel_update_route(const struct nft_pktinfo *pkt,
> -					struct flow_offload_tunnel *tun,
> -					struct nf_flow_route *route,
> -					enum ip_conntrack_dir dir)
> -{
> -	struct dst_entry *cur_dst =3D route->tuple[dir].dst;
> -	struct dst_entry *tun_dst =3D NULL;
> -	struct flowi fl =3D {};
> -
> -	switch (nft_pf(pkt)) {
> -	case NFPROTO_IPV4:
> -		fl.u.ip4.daddr =3D tun->dst_v4.s_addr;
> -		fl.u.ip4.saddr =3D tun->src_v4.s_addr;
> -		fl.u.ip4.flowi4_iif =3D nft_in(pkt)->ifindex;
> -		fl.u.ip4.flowi4_dscp =3D ip4h_dscp(ip_hdr(pkt->skb));
> -		fl.u.ip4.flowi4_mark =3D pkt->skb->mark;
> -		fl.u.ip4.flowi4_flags =3D FLOWI_FLAG_ANYSRC;
> -		break;
> -	case NFPROTO_IPV6:
> -		fl.u.ip6.daddr =3D tun->dst_v6;
> -		fl.u.ip6.saddr =3D tun->src_v6;
> -		fl.u.ip6.flowi6_iif =3D nft_in(pkt)->ifindex;
> -		fl.u.ip6.flowlabel =3D ip6_flowinfo(ipv6_hdr(pkt->skb));
> -		fl.u.ip6.flowi6_mark =3D pkt->skb->mark;
> -		fl.u.ip6.flowi6_flags =3D FLOWI_FLAG_ANYSRC;
> -		break;
> -	}
> -
> -	nf_route(nft_net(pkt), &tun_dst, &fl, false, nft_pf(pkt));
> -	if (!tun_dst)
> -		return -ENOENT;
> -
> -	route->tuple[dir].dst =3D tun_dst;
> -	dst_release(cur_dst);
> -
> -	return 0;
> -}
> -
>  static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
>  				struct nf_flow_route *route,
>  				const struct nf_conn *ct,
> @@ -270,12 +239,13 @@ static int nft_dev_forward_path(const struct nft_pk=
tinfo *pkt,
>  		route->tuple[!dir].in.encap[i].proto =3D info.encap[i].proto;
>  	}
> =20
> -	if (info.num_tuns &&
> -	    !nft_flow_tunnel_update_route(pkt, &info.tun, route, dir)) {
> +	if (info.num_tuns) {
>  		route->tuple[!dir].in.tun.src_v6 =3D info.tun.dst_v6;
>  		route->tuple[!dir].in.tun.dst_v6 =3D info.tun.src_v6;
>  		route->tuple[!dir].in.tun.l3_proto =3D info.tun.l3_proto;
>  		route->tuple[!dir].in.num_tuns =3D info.num_tuns;
> +		dst_release(route->tuple[dir].dst);
> +		route->tuple[dir].dst =3D info.tun_dst;
>  	}
> =20
>  	route->tuple[!dir].in.num_encaps =3D info.num_encaps;
> --=20
> 2.47.3
>=20

--/s1sPBZN7mwKCzQC
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCamSYXwAKCRA6cBh0uS2t
rNQaAQDJZTKjZI0SFKy8edhL8PqW625/3Ptx1HBM9xJ0oTvXtgEAkU7WXtw6AtTJ
q5qHzvA40gASm6YdAgdo0YNDA99Z3Qw=
=4I2m
-----END PGP SIGNATURE-----

--/s1sPBZN7mwKCzQC--
