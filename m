Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1209361DC0
	for <netfilter-devel@vger.kernel.org>; Sat, 25 Jul 2026 10:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784974824; cv=none; b=rVtqSYjK/PIF+7DzhkW3V226N73GwLBBT6SoZH0689ngOncRlmE8Ty4397yNAiYZE/Fe+L968p6I3MzNOVyuh21nDkLtniAmMA+8ARRLNOJD3Q6LO6sEaT2gKbMGTyvQ+lq9X2x8TIOHH2SawWrj4CZXo9QjXPPqZUIKGVv2ekc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784974824; c=relaxed/simple;
	bh=kVsq7boLNREQZPIZNHjrp/Yg5N/Rt4lJcB+PB1kzxQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n/itKqX9tZ7vQH7BVTPvgYrNT79UMSnBtI6iJKe9cNnNL6jcklOgJSU2oApcYuo8YRJugp0KKL3BPcHfockrFtAnvusZFxFxrIuSE5fOvArqGP1Gvy3ltL2pZ+JIrrjlJsBYNtm3zMol6vsTBVxatMBAwzTcWrXizCFpTLVXCLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HFtPLviC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HFtPLviC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8BE1F000E9;
	Sat, 25 Jul 2026 10:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784974822;
	bh=cQcnJ8VbNC3bEtTdIqtDxh4IrlLaZloPAK9h8iWia98=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HFtPLviC6WdRU+I0a0+NxB7M6RZr9wnwbq79xn5o7eKAP8Y6s4n3I8DWtSL/ZQyZV
	 7MGj7FwecN5fLpP7CthsiqsMkfLioxhn1FrbsshAMpnLxalqtTkWm993uEj0dd1vfC
	 kCbLTtZ9sXWjP0C3MMwKLyGvB+yykNP/q7ntC8xBGhmz4fzgKvUpvmB5OUPA9XR8uh
	 UzqczFxEWaBMBkKYIMUhHZT1MiqxPJuETaOqxLKhLvujYyMbhThl/kHKgbjriMFWlL
	 rdFkAqEumC17G1j9A+x4LKkeVzBMnCt9W3n2+wRxNcLLO5sN5Yc4RVDsn0nRIGmXSU
	 WB3YJBModNQtg==
Date: Sat, 25 Jul 2026 12:20:20 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 1/4] netfilter: flowtable: consolidate net_device
 field in nft_forward_info struct
Message-ID: <amSN5P0T6PB_ji6C@lore-desk>
References: <20260723174952.329650-1-pablo@netfilter.org>
 <20260723174952.329650-2-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9p5TnO9YbXbJKKhX"
Content-Disposition: inline
In-Reply-To: <20260723174952.329650-2-pablo@netfilter.org>

--9p5TnO9YbXbJKKhX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> info->indev and info->outdev refer to the same device, a single
> info->dev field is sufficient.
>=20
> While at it, remove unused router parameter from the flowtable path
> discovery function.
>=20
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  net/netfilter/nf_flow_table_path.c | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
>=20
> diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_t=
able_path.c
> index 98c03b487f52..261bb44d08eb 100644
> --- a/net/netfilter/nf_flow_table_path.c
> +++ b/net/netfilter/nf_flow_table_path.c
> @@ -42,8 +42,7 @@ static bool nft_is_valid_ether_device(const struct net_=
device *dev)
>  	return true;
>  }
> =20
> -static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
> -				     const struct dst_entry *dst_cache,
> +static int nft_dev_fill_forward_path(const struct dst_entry *dst_cache,
>  				     const struct nf_conn *ct,
>  				     enum ip_conntrack_dir dir, u8 *ha,
>  				     struct net_device_path_stack *stack)
> @@ -76,8 +75,7 @@ static int nft_dev_fill_forward_path(const struct nf_fl=
ow_route *route,
>  }
> =20
>  struct nft_forward_info {
> -	const struct net_device *indev;
> -	const struct net_device *outdev;
> +	const struct net_device *dev;
>  	struct id {
>  		__u16	id;
>  		__be16	proto;
> @@ -109,7 +107,7 @@ static int nft_dev_path_info(const struct net_device_=
path_stack *stack,
>  		case DEV_PATH_VLAN:
>  		case DEV_PATH_PPPOE:
>  		case DEV_PATH_TUN:
> -			info->indev =3D path->dev;
> +			info->dev =3D path->dev;
>  			if (is_zero_ether_addr(info->h_source))
>  				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
> =20
> @@ -179,10 +177,9 @@ static int nft_dev_path_info(const struct net_device=
_path_stack *stack,
>  			return -1;
>  		}
>  	}
> -	info->outdev =3D info->indev;
> =20
>  	if (nf_flowtable_hw_offload(flowtable) &&
> -	    nft_is_valid_ether_device(info->indev))
> +	    nft_is_valid_ether_device(info->dev))
>  		info->xmit_type =3D FLOW_OFFLOAD_XMIT_DIRECT;
> =20
>  	return 0;
> @@ -255,17 +252,16 @@ static int nft_dev_forward_path(const struct nft_pk=
tinfo *pkt,
>  	unsigned char ha[ETH_ALEN];
>  	int i;
> =20
> -	if (nft_dev_fill_forward_path(route, dst, ct, dir, ha, &stack) < 0 ||
> +	if (nft_dev_fill_forward_path(dst, ct, dir, ha, &stack) < 0 ||
>  	    nft_dev_path_info(&stack, &info, ha, &ft->data) < 0)
>  		return -ENOENT;
> =20
> -	if (!nft_flowtable_find_dev(info.indev, ft))
> +	if (!nft_flowtable_find_dev(info.dev, ft))
>  		return -ENOENT;
> =20
> -	if (info.outdev)
> -		route->tuple[dir].out.ifindex =3D info.outdev->ifindex;
> +	route->tuple[!dir].in.ifindex =3D info.dev->ifindex;
> +	route->tuple[dir].out.ifindex =3D info.dev->ifindex;
> =20
> -	route->tuple[!dir].in.ifindex =3D info.indev->ifindex;
>  	for (i =3D 0; i < info.num_encaps; i++) {
>  		route->tuple[!dir].in.encap[i].id =3D info.encap[i].id;
>  		route->tuple[!dir].in.encap[i].proto =3D info.encap[i].proto;
> --=20
> 2.47.3
>=20

--9p5TnO9YbXbJKKhX
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCamSN5AAKCRA6cBh0uS2t
rIuvAQC56LiDtKAIkWQhJZKCSmBOz08RDUaqzcUird9IL4fAmAD+MO6ve2Kcvv40
GTxamTWG05uI4WevbjfWZzHnJbnxNAY=
=BVM0
-----END PGP SIGNATURE-----

--9p5TnO9YbXbJKKhX--
