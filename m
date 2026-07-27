Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80079377EA2
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 12:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785156143; cv=none; b=KPWtY6HQEcrQcqWUK+T3yhFXyuL/5HvJDsbInljhSNuwrPP7V2r2H923dXKxf0f2QXBrdLla+x8VjsgcoAZemSOW1UrrtH4rk+0U2Gkmur7Gh2wAgpygI6yuiuFMUx84OB0I1fgJTLWuVlPE+5r73+djiFMPjqNjsdRnLHiMtEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785156143; c=relaxed/simple;
	bh=9lMK4EAY/OxS9o94Q+2u+dX3DYua1wZL5n97WkeqWGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FP0XLovT+HKjTcC6b08eJSdUmGxIUYWSJDE2xr9o2QgoCW5FEtsp+jhz9SCE8JaF2EIkwwq3ueM1n9+lL9BxbMcePHofk+WvtYlozcQKu6adYFDlccq47xx/RmX8ehfEbrefJHij6llUArmvVGxmpsXl/hm1am41y16rO/veYn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bF5bdmPg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bF5bdmPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C991F000E9;
	Mon, 27 Jul 2026 12:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785156142;
	bh=SdX6ckSR8oD3ZC6ik2ci8PTN8St3zOAnFrbtJ+h9LA0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bF5bdmPgobWNHOuyLZhQTKiuI7KBfSSKZGgnmVV/Q2TdVifiT2GvhuPf9mx0AHKX1
	 V2+StHQMGW0PagSv3OmgRGpCT/SxMsVMKYev6RTJxGLFNttewTjWO70ltHQMX1AUv/
	 4ST/3cbYs+9SyzH7o19kHxRTYGvgefTk7K0MWr0CHIOYhbEB1XSXpoFRVxB8LmKswL
	 WFvVnyizXMYYoj11K9xfjNpbFhhNcfHjymVuNeRMkVYFJ9E+lUTCKFB8uiGSxaDRpP
	 8RG0DBZUxnFoomz3WQchC5Yo5prSHiehH5YMnvY2LbQnVoP6rSv7x+cMp5WEffYDob
	 3AZxpO9kyUz9w==
Date: Mon, 27 Jul 2026 14:42:19 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next,v2 3/5] net: do not advance stack index from
 dev_fwd_path()
Message-ID: <amdSK06EPRaTk4Ra@lore-desk>
References: <20260727115932.88335-1-pablo@netfilter.org>
 <20260727115932.88335-3-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zLR4u8pp0NeOQJ3H"
Content-Disposition: inline
In-Reply-To: <20260727115932.88335-3-pablo@netfilter.org>

--zLR4u8pp0NeOQJ3H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Update stack index from dev_fill_forward_path() instead, once the
> forward path slot has been populated.
>=20
> Adjust existing drivers that recycle dev_fill_forward_path() as a
> way to reach the mtk SoC WDMA info.
>=20
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
> v2: new in this series to address sashiko report on possible access
>     to uninitialized path in stack in case tunnel route reference
>     need to be dropped.
>=20
>  drivers/net/ethernet/airoha/airoha_ppe.c        | 2 +-
>  drivers/net/ethernet/mediatek/mtk_ppe_offload.c | 2 +-
>  net/core/dev.c                                  | 6 ++++--
>  3 files changed, 6 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ether=
net/airoha/airoha_ppe.c
> index e4c3644dd6ec..72755ca974fa 100644
> --- a/drivers/net/ethernet/airoha/airoha_ppe.c
> +++ b/drivers/net/ethernet/airoha/airoha_ppe.c
> @@ -292,7 +292,7 @@ static int airoha_ppe_get_wdma_info(struct net_device=
 *dev, const u8 *addr,
>  	if (err)
>  		return err;
> =20
> -	path =3D &stack.path[stack.num_paths - 1];
> +	path =3D &stack.path[stack.num_paths];
>  	if (path->type !=3D DEV_PATH_MTK_WDMA)
>  		return -EINVAL;
> =20
> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/ne=
t/ethernet/mediatek/mtk_ppe_offload.c
> index cc8c4ef8038f..7dab360b8be3 100644
> --- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> +++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> @@ -107,7 +107,7 @@ mtk_flow_get_wdma_info(struct net_device *dev, const =
u8 *addr, struct mtk_wdma_i
>  	if (err)
>  		return err;
> =20
> -	path =3D &stack.path[stack.num_paths - 1];
> +	path =3D &stack.path[stack.num_paths];
>  	if (path->type !=3D DEV_PATH_MTK_WDMA)
>  		return -1;
> =20
> diff --git a/net/core/dev.c b/net/core/dev.c
> index c1c1be1a6962..ca65d1dcd604 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -742,9 +742,9 @@ EXPORT_SYMBOL_GPL(dev_fill_metadata_dst);
> =20
>  static struct net_device_path *dev_fwd_path(struct net_device_path_stack=
 *stack)
>  {
> -	int k =3D stack->num_paths++;
> +	int k =3D stack->num_paths;
> =20
> -	if (k >=3D NET_DEVICE_PATH_STACK_MAX)
> +	if (k + 1 >=3D NET_DEVICE_PATH_STACK_MAX)

nit: do we really need k in this case? (ignore the comment if you do not
need to repost).

Regards,
Lorenzo

>  		return NULL;
> =20
>  	return &stack->path[k];
> @@ -773,6 +773,7 @@ int dev_fill_forward_path(const struct net_device *de=
v, const u8 *daddr,
>  		if (ret < 0)
>  			return -1;
> =20
> +		stack->num_paths++;
>  		if (WARN_ON_ONCE(last_dev =3D=3D ctx.dev))
>  			return -1;
>  	}
> @@ -785,6 +786,7 @@ int dev_fill_forward_path(const struct net_device *de=
v, const u8 *daddr,
>  		return -1;
>  	path->type =3D DEV_PATH_ETHERNET;
>  	path->dev =3D ctx.dev;
> +	stack->num_paths++;
> =20
>  	return ret;
>  }
> --=20
> 2.47.3
>=20

--zLR4u8pp0NeOQJ3H
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCamdSKwAKCRA6cBh0uS2t
rNs0AP9FYu5DYLNtjjEb+43U2Gjg9EcgXMl/hIZ6zyaHIb94JgD9EpZDVClchyE4
BCBG6YogF5ivwTCeAF8SG02dnh/CNA0=
=Cu2/
-----END PGP SIGNATURE-----

--zLR4u8pp0NeOQJ3H--
