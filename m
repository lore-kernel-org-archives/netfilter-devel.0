Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E3D3BFAD0
	for <netfilter-devel@vger.kernel.org>; Sat, 25 Jul 2026 10:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784975150; cv=none; b=pl1Mv8LXUeKDUJv98UzmXZPry60AzJUbPgSPya7vEtykq8Hho1odYtgi/noFZ5qSUd6FTfM1EkQSvda4iY3eO35lwpLgAfuRXayWEiImLCbIzJiPV8xrpZZQlRa/9jC1Wd6iwBRZ/d+KZMmLJOEl6/sVOlKxSAZpaB1FieDtZTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784975150; c=relaxed/simple;
	bh=hrlpWjyZb3qLQtqj31Rx1O5nk4IfJlHtqof9vtpUQIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mI8msTGyw8izbpJG3Qa6mydahIarLqY00Aedkovfmpd7DK05EhR5WVhzGaR7Rg9s6p9I7om0h2Nv0KcRDdMPnBSGZU0uRW1Gw/1erGpfINAmNy2dqe587idWpuQaydRKKt9zuYycvH/gnQiUzq9eIKKTtb75HfDYlycj+vgBpyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HEb4jyBY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HEb4jyBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C541F000E9;
	Sat, 25 Jul 2026 10:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784975146;
	bh=6JyWfyHPypsTq1fVSbOL47XzCL+JbxO6IXTEH8/hGqw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HEb4jyBYBBU2CDa/fjSM07ftfA3TCnrNhpr4UhOxJpkDQCGZKfC5iJfrPqTsxIQyu
	 PCGJJoqE7I6tpM5Ed7s3Dpew/n7EwiQIy880u68BFkYUDqx4mwMMKYHkzA2EECz0lT
	 u918TQc+yGMGRle7fIIMRbZ4NNb68H2lnrZSpD8kZ5Qkevwtt8DGPPt0FI0uj504/M
	 Ff/AxKXPaEpT5CZgVA65VvHmxTqIZlFiSeAucS0QBxbCzombdK5KDy+xxUrLKZDque
	 cnAbnL1W9ppNrtHbzJ5KKOKPtNGoUbuXRxIrquMOKKGD+tjMxyY2lzx11tZ5zRgIAd
	 cS6MPmt5x1bPw==
Date: Sat, 25 Jul 2026 12:25:43 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 2/4] netfilter: flowtable: consolidate flowtable
 device check
Message-ID: <amSPJ4SY8Keb0EEa@lore-desk>
References: <20260723174952.329650-1-pablo@netfilter.org>
 <20260723174952.329650-3-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VZkZOSGPiCnWcAlo"
Content-Disposition: inline
In-Reply-To: <20260723174952.329650-3-pablo@netfilter.org>

--VZkZOSGPiCnWcAlo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Check that device belongs to the flowtable right after the flowtable
> discovery path. This is a preparation patch to obtain the dst entry
> from the .fill_forward_path in tunnels.
>=20
> No functional changes are intended.
>=20
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  net/netfilter/nf_flow_table_path.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
>=20
> diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_t=
able_path.c
> index 261bb44d08eb..8f04a4487897 100644
> --- a/net/netfilter/nf_flow_table_path.c
> +++ b/net/netfilter/nf_flow_table_path.c
> @@ -90,9 +90,12 @@ struct nft_forward_info {
>  	enum flow_offload_xmit_type xmit_type;
>  };
> =20
> +static bool nft_flowtable_find_dev(const struct net_device *dev,
> +				   struct nft_flowtable *ft);
> +
>  static int nft_dev_path_info(const struct net_device_path_stack *stack,
>  			     struct nft_forward_info *info,
> -			     unsigned char *ha, struct nf_flowtable *flowtable)
> +			     unsigned char *ha, struct nft_flowtable *ft)
>  {
>  	const struct net_device_path *path;
>  	int i;
> @@ -178,10 +181,13 @@ static int nft_dev_path_info(const struct net_devic=
e_path_stack *stack,
>  		}
>  	}
> =20
> -	if (nf_flowtable_hw_offload(flowtable) &&
> +	if (nf_flowtable_hw_offload(&ft->data) &&
>  	    nft_is_valid_ether_device(info->dev))
>  		info->xmit_type =3D FLOW_OFFLOAD_XMIT_DIRECT;
> =20
> +	if (!nft_flowtable_find_dev(info->dev, ft))
> +		return -1;
> +
>  	return 0;
>  }
> =20
> @@ -253,10 +259,7 @@ static int nft_dev_forward_path(const struct nft_pkt=
info *pkt,
>  	int i;
> =20
>  	if (nft_dev_fill_forward_path(dst, ct, dir, ha, &stack) < 0 ||
> -	    nft_dev_path_info(&stack, &info, ha, &ft->data) < 0)
> -		return -ENOENT;
> -
> -	if (!nft_flowtable_find_dev(info.dev, ft))
> +	    nft_dev_path_info(&stack, &info, ha, ft) < 0)
>  		return -ENOENT;
> =20
>  	route->tuple[!dir].in.ifindex =3D info.dev->ifindex;
> --=20
> 2.47.3
>=20

--VZkZOSGPiCnWcAlo
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCamSPJwAKCRA6cBh0uS2t
rG8UAPwIJHhfLiKzLcdVr3pJwOS11yLsTz85OQ1z90H61WH0ZgEAstAdCavhYmHf
ZflV00x9aAQcecXKdK6GeCnii8GAnQs=
=jt8V
-----END PGP SIGNATURE-----

--VZkZOSGPiCnWcAlo--
