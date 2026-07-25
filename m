Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E795939D3FC
	for <netfilter-devel@vger.kernel.org>; Sat, 25 Jul 2026 10:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784976980; cv=none; b=rK50kGIN1ILjG3jF7YS7kslqyOwYTPcdGUarOcIsdrDlEWCbiwMPU0V2E5oPEGxzPZa6TrU4bMeoCdlO8nUmewNbKsIYPoAFWY76mSNg94FP/OZG97caGhrHkGdLPgSTRRe1+8Xs9JabiOPCREwNrWTIsjFH7k4ggzolqNxhYD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784976980; c=relaxed/simple;
	bh=I6zD/SlyVRADKP6OF9D0HFLDtBZWymj2dPCvndQHaZk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EdIaJk83egJOhq6CqZ5ybSuVoyyLFp9I2L+yet1+OcuC6hsuYDq3PSWltDiJyF3z47SpvxaPoqCIojNGuBQ3eZB/Zkyl88GBEKJ715BOA7MZ9DFnRz6Z03TBRR2lowBFUTD8RRxVEXBLQ5ZTwbpe8mDIx2FdtefGqnft99eoUZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bJQwmmfW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bJQwmmfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB4D1F000E9;
	Sat, 25 Jul 2026 10:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784976978;
	bh=ACgbRTFKPSsxEr2oTBSu3NCsGnjlp3UPhAsy1hvP0nw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bJQwmmfW3RGdBT2InLfliKHx5OzZW2CPEsJDN/NQCBQ6Bk0/NKVHO/8IP6oQtrYJZ
	 vuvFwtetAT7qSCeMcv9RkxZwh/Jey8vVCyX9RuaPwz5+MOTj2cVdohrpsGBwjeub9e
	 oKmX2Mv2nsCIgiHDoklC0k68NncJbUmMGM7yjl+hoNktfUvwN7UQbax5sAGCL5UqAT
	 9/W1nrmF77YV3W+IvboL9tGsvrm7IYe5FWjyrFYGL4nrUTQrnUxyWt/+3XT7mBPEQJ
	 D4kB/gLYywyK/e2jvTxlw0rMVG2AcgO7GIq0OQpDkRZxOcmW6XzfSezLNiBPlQ4wxb
	 w11xcIdFPZbzg==
Date: Sat, 25 Jul 2026 12:56:16 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 3/4] net: pass dst via net_device_path in
 dev_fill_forward_path()
Message-ID: <amSWUNHbPGVGlqBK@lore-desk>
References: <20260723174952.329650-1-pablo@netfilter.org>
 <20260723174952.329650-4-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="kWRq2p5l2BlWs/rl"
Content-Disposition: inline
In-Reply-To: <20260723174952.329650-4-pablo@netfilter.org>

--kWRq2p5l2BlWs/rl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Add dst_entry to tunnel device path, this will allow us to remove
> a duplicated route lookup.
>=20
> This is a preparation patch to retrieve the tunnel route directly
> from the .fill_forward_path. This new dst_entry in the tunnel will be
> used by a follow up patch.
>=20
> Since dst_release() works fine on NULL interface, this is still
> noop until the flowtable starts using this.
>=20
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

just few nits inline. Fixing them:

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  include/linux/netdevice.h |  1 +
>  net/core/dev.c            | 45 +++++++++++++++++++++++++++++++--------
>  2 files changed, 37 insertions(+), 9 deletions(-)
>=20
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 8db25b79573e..30dc78b4f1a3 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -902,6 +902,7 @@ struct net_device_path {
>  			};
> =20
>  			u8	l3_proto;
> +			struct dst_entry *dst;

nit: I guess if you move dst_entry pointer at the beginning of the tun stru=
ct
we avoid 7 bytes compiler padding.

>  		} tun;
>  		struct {
>  			enum {
> diff --git a/net/core/dev.c b/net/core/dev.c
> index c1c1be1a6962..fed101f54a8a 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -750,6 +750,23 @@ static struct net_device_path *dev_fwd_path(struct n=
et_device_path_stack *stack)
>  	return &stack->path[k];
>  }
> =20
> +static void dev_fill_forward_path_release(struct net_device_path_stack *=
stack)
> +{
> +	struct net_device_path *path;
> +	int k;
> +
> +	for (k =3D stack->num_paths; k >=3D 0; k--) {
> +		path =3D &stack->path[k];
> +		switch (path->type) {
> +		case DEV_PATH_TUN:
> +			dst_release(path->tun.dst);
> +			break;
> +		default:
> +			break;
> +		}
> +	}
> +}
> +
>  int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
>  			  struct net_device_path_stack *stack)
>  {
> @@ -765,28 +782,38 @@ int dev_fill_forward_path(const struct net_device *=
dev, const u8 *daddr,
>  	while (ctx.dev && ctx.dev->netdev_ops->ndo_fill_forward_path) {
>  		last_dev =3D ctx.dev;
>  		path =3D dev_fwd_path(stack);
> -		if (!path)
> -			return -1;
> +		if (!path) {
> +			ret =3D -1;

nit: I guess we can drop ret variable now since we do not use it in the ret=
urn
path.

> +			goto err_out;
> +		}
> =20
>  		memset(path, 0, sizeof(struct net_device_path));
>  		ret =3D ctx.dev->netdev_ops->ndo_fill_forward_path(&ctx, path);
>  		if (ret < 0)
> -			return -1;
> +			goto err_out;
> =20
> -		if (WARN_ON_ONCE(last_dev =3D=3D ctx.dev))
> -			return -1;
> +		if (WARN_ON_ONCE(last_dev =3D=3D ctx.dev)) {
> +			ret =3D -1;
> +			goto err_out;
> +		}
>  	}
> =20
>  	if (!ctx.dev)
> -		return ret;
> +		goto err_out;
> =20
>  	path =3D dev_fwd_path(stack);
> -	if (!path)
> -		return -1;
> +	if (!path) {
> +		ret =3D -1;
> +		goto err_out;
> +	}
>  	path->type =3D DEV_PATH_ETHERNET;
>  	path->dev =3D ctx.dev;
> =20
> -	return ret;
> +	return 0;
> +err_out:
> +	dev_fill_forward_path_release(stack);
> +
> +	return -1;
>  }
>  EXPORT_SYMBOL_GPL(dev_fill_forward_path);
> =20
> --=20
> 2.47.3
>=20

--kWRq2p5l2BlWs/rl
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCamSWUAAKCRA6cBh0uS2t
rD2vAQCRjjvhSQ4BkZCospYLhPI+tLKAjtez0KINfRKNlZU7DQD/f2VVZxw4CUrY
ostOkNMwmQ5zs+iJtoXV4E986ca11Ag=
=DTdQ
-----END PGP SIGNATURE-----

--kWRq2p5l2BlWs/rl--
