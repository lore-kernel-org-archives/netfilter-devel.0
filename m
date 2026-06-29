Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4AD4219E1
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 15:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782746137; cv=none; b=Zy1N5NHbDUD/TeuBKcUWv6xJM7Ja7PfIckRbrvAgecAZkyNaFo/DjV84x2fKF0OI3Nd+2HVBs7WXpCGBtoBpMlNJQbhLypJDh2KldyDReyauWZejBElQotMKXcD34rqBbYViuS6oPTRXhZNunPV8hmTbFYxRqrIHMgYmLzRrw8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782746137; c=relaxed/simple;
	bh=b8MeIBzuZzhF0LnscDM2vf9YNlTL+AJsahw8BkNAqeY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hzUcfbIt5XpozPXRgSTDZbM80h2CcNb5adQm7gq2ypskPgjuIwu9Rajuq9pnuIYPXpIfCbdsIPRFqCO9E2uf2E+TA5mPuDu7YoMO+DpIs7kVRL24sopBvEwt3weuot9VKmOtA3GNuaimtGdUdFjOg2KWhlQhuJ/OTK64i5q/WPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LrVmhoFZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LrVmhoFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D377B1F000E9;
	Mon, 29 Jun 2026 15:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782746136;
	bh=J3FNBor+/6OxxF4QydHanVPB/4c3OkAzebkYAih5GKs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LrVmhoFZcHdglvTAMI6eKXW6QeNOUg0rCjS7hZPdGotc7oalJHlfIyCyCWjn7jXOW
	 hLxJaeYH1oEwBXIV45r8qXm0OGkuYbF9nmk0MHAcj+vY+vUMIHnRi3MCUph9w0IXYi
	 o2uC6xXQRGgrbdVKYCXDZwOe4w71vLj/n/9yIa5AgGpv0dsxhIfJa9H0wahX8Cp4Ly
	 1Rmsu3YI1j57GT07UXUTJU6jZ3+w0tF7Bu9LGhCz2S5f3DF78oF8+s63qRiNOg/K1Z
	 cSiehsGa62xvDB91TsWTLAL/CgCk/xA680Iraxg5hSsa7JKc38+AyZ35x4HC5wxFt/
	 32rCD7lP8LJMw==
Date: Mon, 29 Jun 2026 17:15:34 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, chzhengyang2023@lzu.edu.cn
Subject: Re: [PATCH nf 2/3] netfilter: flowtable: IPIP tunnel hardware
 offload is not yet support
Message-ID: <akKMFhDgmpr2CyYP@lore-desk>
References: <20260629143936.61239-1-pablo@netfilter.org>
 <20260629143936.61239-3-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="e4WNeX/8VwbCclhn"
Content-Disposition: inline
In-Reply-To: <20260629143936.61239-3-pablo@netfilter.org>


--e4WNeX/8VwbCclhn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Jun 29, Pablo Neira Ayuso wrote:
> No driver supports for IPIP tunnels yet, give up early on setting up the
> hardware offload for this scenario.
>=20
> This patch adds a stub that can be enhanced to add more configuration
> that are currently not supported. As of now, the offload work is
> enqueued to the worker, then ignored if the hardware offload
> configuration is not supported.
>=20
> This can be updated later on to skip hardware offload work to be queued
> in case hardware offload does not support it.
>=20
> Fixes: d98103575dcd ("netfilter: flowtable: Add IP6IP6 rx sw acceleration=
")
> Fixes: ab427db17885 ("netfilter: flowtable: Add IPIP rx sw acceleration")
> Reported-by: Yuan Tan <yuantan098@gmail.com>
> Reported-by: Xin Liu <bird@lzu.edu.cn>
> Reported-by: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  net/netfilter/nf_flow_table_offload.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>=20
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flo=
w_table_offload.c
> index 002ec15d988b..3e87117e724b 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -1101,12 +1101,23 @@ nf_flow_offload_work_alloc(struct nf_flowtable *f=
lowtable,
>  	return offload;
>  }
> =20
> +static bool nf_flow_offload_unsupported(struct flow_offload *flow)
> +{
> +	if (flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.tun_num ||
> +	    flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.tun_num)
> +		return true;
> +
> +	return false;
> +}
> =20
>  void nf_flow_offload_add(struct nf_flowtable *flowtable,
>  			 struct flow_offload *flow)
>  {
>  	struct flow_offload_work *offload;
> =20
> +	if (nf_flow_offload_unsupported(flow))
> +		return;
> +
>  	offload =3D nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_REPLAC=
E);
>  	if (!offload)
>  		return;
> @@ -1119,6 +1130,9 @@ void nf_flow_offload_del(struct nf_flowtable *flowt=
able,
>  {
>  	struct flow_offload_work *offload;
> =20
> +	if (nf_flow_offload_unsupported(flow))
> +		return;
> +
>  	offload =3D nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_DESTRO=
Y);
>  	if (!offload)
>  		return;
> @@ -1133,6 +1147,9 @@ void nf_flow_offload_stats(struct nf_flowtable *flo=
wtable,
>  	struct flow_offload_work *offload;
>  	__s32 delta;
> =20
> +	if (nf_flow_offload_unsupported(flow))
> +		return;
> +
>  	delta =3D nf_flow_timeout_delta(flow->timeout);
>  	if ((delta >=3D (9 * flow_offload_get_timeout(flow)) / 10))
>  		return;
> --=20
> 2.47.3
>=20

--e4WNeX/8VwbCclhn
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCakKMFgAKCRA6cBh0uS2t
rKVFAQDeZjMMKDg+4bqL5ND9F99/+jQc5zSroBppJ7wTlvvhVQEA9+eruT0gKxdC
1R9fUMs0Qvz3P9UC3ft92ActrLSFJAs=
=w5dg
-----END PGP SIGNATURE-----

--e4WNeX/8VwbCclhn--
