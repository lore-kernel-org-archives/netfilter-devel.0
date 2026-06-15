Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264893DA7D4;
	Mon, 15 Jun 2026 09:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781515654; cv=none; b=J+py+xzLmaHpj5aYYdaQdveJYlo38B9j+ghkWa4WFkBxe+Kub0paqilXO2VDoG1rDgvDmhRwVEpik+zRUxmHLYPV89+9V3OyHgHdedho20NDPQch7anZ5KTImBzuvrftvig50XA7J/i2mzljjoeXruHilIx06NyNrJoXeX2rBCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781515654; c=relaxed/simple;
	bh=UZ9BYVNtjtgZwukx1GOZPb93PDVTmK9M1EXoruYiulE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T/K1arVju7ij6zFfVM0QNojlxGlyXv0KZb3Vsu65APW7L5NEBeKvMev4Y4gHYSSVu34V7wMYadYZofdGBtIm/uCn8u4RDPwcYZrGwDiOVHOmdUwNvwLCPz+TX4UlZRltzWeaUIp4lemxfaWa24qaKRFbUpQerFY+pTszpM9cowY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aCz9mX0d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aCz9mX0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717B81F000E9;
	Mon, 15 Jun 2026 09:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781515653;
	bh=ZEcxff0/VTWOysmE51CxgyAAzzKf0arB5db1sO6Z2bw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aCz9mX0dzlIDDBkQzgfTGqFGSMPouFXY9uqsi0Rgxoy+rrQ4qEBvvX9akYD29flte
	 346v2oLg6grvcvKDBLGMaNFQuaW1uSGrYvmzBR94MOMgYyWK5QMxkJhcHVlSbFYZ1o
	 9Hkzmmcj417tPBMY/Z4eaB6t+AuTVybAM/ROMv376dSD0u5jU8yke0WBwbkPeuq2R3
	 q4OzfNwtMElvUH4QbLnWir6hwmm+sDXPMFdDo+haZa179m2SFoqZHpBSKgYlb+HpNi
	 EvAePbMIYq+/5zPbylGHVSLWUEqYq+N0Dxdmp2gYZ1R0K+19O9rF8ESoiW2IS0/mTs
	 NnJIj+7TIeFNQ==
Date: Mon, 15 Jun 2026 11:27:30 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, fw@strlen.de, horms@kernel.org
Subject: Re: [PATCH net-next 09/11] netfilter: flowtable: bail out if forward
 path cannot be discovered
Message-ID: <ai_Fgq_iBWNLKLro@lore-desk>
References: <20260614114605.474783-1-pablo@netfilter.org>
 <20260614114605.474783-10-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2voAxdxRxTDZPDqb"
Content-Disposition: inline
In-Reply-To: <20260614114605.474783-10-pablo@netfilter.org>


--2voAxdxRxTDZPDqb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> If forward path discovery fails for any reason or netdevice is not
> registered for this flowtable, then bail out to classic forwarding path
> rather than providing incomplete forwarding path.
>=20
> Update the existing forward path parser functions to report an error
> so the flow_offload expressions gives up on setting up the flowtable
> entry.
>=20
> Link: https://sashiko.dev/#/patchset/20260607094954.48892-15-pablo%40netf=
ilter.org?part=3D14
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Tested-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  net/netfilter/nf_flow_table_path.c | 81 +++++++++++++++++-------------
>  1 file changed, 46 insertions(+), 35 deletions(-)
>=20
> diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_t=
able_path.c
> index a3e6b82f2f8e..1e7e216b9f89 100644
> --- a/net/netfilter/nf_flow_table_path.c
> +++ b/net/netfilter/nf_flow_table_path.c
> @@ -90,9 +90,9 @@ struct nft_forward_info {
>  	enum flow_offload_xmit_type xmit_type;
>  };
> =20
> -static void nft_dev_path_info(const struct net_device_path_stack *stack,
> -			      struct nft_forward_info *info,
> -			      unsigned char *ha, struct nf_flowtable *flowtable)
> +static int nft_dev_path_info(const struct net_device_path_stack *stack,
> +			     struct nft_forward_info *info,
> +			     unsigned char *ha, struct nf_flowtable *flowtable)
>  {
>  	const struct net_device_path *path;
>  	int i;
> @@ -120,19 +120,17 @@ static void nft_dev_path_info(const struct net_devi=
ce_path_stack *stack,
> =20
>  			/* DEV_PATH_VLAN, DEV_PATH_PPPOE and DEV_PATH_TUN */
>  			if (path->type =3D=3D DEV_PATH_TUN) {
> -				if (info->num_tuns) {
> -					info->indev =3D NULL;
> -					break;
> -				}
> +				if (info->num_tuns)
> +					return -1;
> +
>  				info->tun.src_v6 =3D path->tun.src_v6;
>  				info->tun.dst_v6 =3D path->tun.dst_v6;
>  				info->tun.l3_proto =3D path->tun.l3_proto;
>  				info->num_tuns++;
>  			} else {
> -				if (info->num_encaps >=3D NF_FLOW_TABLE_ENCAP_MAX) {
> -					info->indev =3D NULL;
> -					break;
> -				}
> +				if (info->num_encaps >=3D NF_FLOW_TABLE_ENCAP_MAX)
> +					return -1;
> +
>  				info->encap[info->num_encaps].id =3D
>  					path->encap.id;
>  				info->encap[info->num_encaps].proto =3D
> @@ -151,22 +149,23 @@ static void nft_dev_path_info(const struct net_devi=
ce_path_stack *stack,
> =20
>  			switch (path->bridge.vlan_mode) {
>  			case DEV_PATH_BR_VLAN_UNTAG_HW:
> +				if (info->num_encaps =3D=3D 0)
> +					return -1;
> +
>  				info->ingress_vlans |=3D BIT(info->num_encaps - 1);
>  				break;
>  			case DEV_PATH_BR_VLAN_TAG:
> -				if (info->num_encaps >=3D NF_FLOW_TABLE_ENCAP_MAX) {
> -					info->indev =3D NULL;
> -					break;
> -				}
> +				if (info->num_encaps >=3D NF_FLOW_TABLE_ENCAP_MAX)
> +					return -1;
> +
>  				info->encap[info->num_encaps].id =3D path->bridge.vlan_id;
>  				info->encap[info->num_encaps].proto =3D path->bridge.vlan_proto;
>  				info->num_encaps++;
>  				break;
>  			case DEV_PATH_BR_VLAN_UNTAG:
> -				if (info->num_encaps =3D=3D 0) {
> -					info->indev =3D NULL;
> -					break;
> -				}
> +				if (info->num_encaps =3D=3D 0)
> +					return -1;
> +
>  				info->num_encaps--;
>  				break;
>  			case DEV_PATH_BR_VLAN_KEEP:
> @@ -175,8 +174,7 @@ static void nft_dev_path_info(const struct net_device=
_path_stack *stack,
>  			info->xmit_type =3D FLOW_OFFLOAD_XMIT_DIRECT;
>  			break;
>  		default:
> -			info->indev =3D NULL;
> -			break;
> +			return -1;
>  		}
>  	}
>  	info->outdev =3D info->indev;
> @@ -184,6 +182,8 @@ static void nft_dev_path_info(const struct net_device=
_path_stack *stack,
>  	if (nf_flowtable_hw_offload(flowtable) &&
>  	    nft_is_valid_ether_device(info->indev))
>  		info->xmit_type =3D FLOW_OFFLOAD_XMIT_DIRECT;
> +
> +	return 0;
>  }
> =20
>  static bool nft_flowtable_find_dev(const struct net_device *dev,
> @@ -241,11 +241,11 @@ static int nft_flow_tunnel_update_route(const struc=
t nft_pktinfo *pkt,
>  	return 0;
>  }
> =20
> -static void nft_dev_forward_path(const struct nft_pktinfo *pkt,
> -				 struct nf_flow_route *route,
> -				 const struct nf_conn *ct,
> -				 enum ip_conntrack_dir dir,
> -				 struct nft_flowtable *ft)
> +static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
> +				struct nf_flow_route *route,
> +				const struct nf_conn *ct,
> +				enum ip_conntrack_dir dir,
> +				struct nft_flowtable *ft)
>  {
>  	const struct dst_entry *dst =3D route->tuple[dir].dst;
>  	struct net_device_path_stack stack;
> @@ -253,15 +253,16 @@ static void nft_dev_forward_path(const struct nft_p=
ktinfo *pkt,
>  	unsigned char ha[ETH_ALEN];
>  	int i;
> =20
> -	if (nft_dev_fill_forward_path(route, dst, ct, dir, ha, &stack) >=3D 0)
> -		nft_dev_path_info(&stack, &info, ha, &ft->data);
> +	if (nft_dev_fill_forward_path(route, dst, ct, dir, ha, &stack) < 0 ||
> +	    nft_dev_path_info(&stack, &info, ha, &ft->data) < 0)
> +		return -ENOENT;
> +
> +	if (!nft_flowtable_find_dev(info.indev, ft))
> +		return -ENOENT;
> =20
>  	if (info.outdev)
>  		route->tuple[dir].out.ifindex =3D info.outdev->ifindex;
> =20
> -	if (!info.indev || !nft_flowtable_find_dev(info.indev, ft))
> -		return;
> -
>  	route->tuple[!dir].in.ifindex =3D info.indev->ifindex;
>  	for (i =3D 0; i < info.num_encaps; i++) {
>  		route->tuple[!dir].in.encap[i].id =3D info.encap[i].id;
> @@ -285,6 +286,8 @@ static void nft_dev_forward_path(const struct nft_pkt=
info *pkt,
>  		route->tuple[dir].xmit_type =3D info.xmit_type;
>  	}
>  	route->tuple[dir].out.needs_gso_segment =3D info.needs_gso_segment;
> +
> +	return 0;
>  }
> =20
>  int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *=
ct,
> @@ -329,11 +332,19 @@ int nft_flow_route(const struct nft_pktinfo *pkt, c=
onst struct nf_conn *ct,
>  	nft_default_forward_path(route, this_dst, dir);
>  	nft_default_forward_path(route, other_dst, !dir);
> =20
> -	if (route->tuple[dir].xmit_type	=3D=3D FLOW_OFFLOAD_XMIT_NEIGH)
> -		nft_dev_forward_path(pkt, route, ct, dir, ft);
> -	if (route->tuple[!dir].xmit_type =3D=3D FLOW_OFFLOAD_XMIT_NEIGH)
> -		nft_dev_forward_path(pkt, route, ct, !dir, ft);
> +	if (route->tuple[dir].xmit_type	=3D=3D FLOW_OFFLOAD_XMIT_NEIGH &&
> +	    nft_dev_forward_path(pkt, route, ct, dir, ft) < 0)
> +		goto err_dst_release;
> +
> +	if (route->tuple[!dir].xmit_type =3D=3D FLOW_OFFLOAD_XMIT_NEIGH &&
> +	    nft_dev_forward_path(pkt, route, ct, !dir, ft) < 0)
> +		goto err_dst_release;
> =20
>  	return 0;
> +
> +err_dst_release:
> +	dst_release(route->tuple[dir].dst);
> +	dst_release(route->tuple[!dir].dst);
> +	return -ENOENT;
>  }
>  EXPORT_SYMBOL_GPL(nft_flow_route);
> --=20
> 2.47.3
>=20
>=20

--2voAxdxRxTDZPDqb
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCai/FggAKCRA6cBh0uS2t
rDTHAQCArWt33TG4YPKD4wQMsPJrZ2iuR/QsuNtnJpKuTNejyQEAyYaX9EG5r1xw
xkD3SKGHOSEdTeWYssd2l2biomnPNg8=
=5HXU
-----END PGP SIGNATURE-----

--2voAxdxRxTDZPDqb--
