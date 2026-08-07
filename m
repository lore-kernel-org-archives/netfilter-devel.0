Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5993E3346A8
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Aug 2026 09:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786093231; cv=none; b=WLLaRSpPAO3tDySd190LFQY8CqLC5VynuadZFqJYcKYW1H1FCzM5ZvWy/rs7IE0TjbT+m6LL79Rq4CZuZDrK1oIH3ZEfVMq9cbzpGWDsDoA37cg9afNaLzLf1/34c6W6FmEuOXLjIn9mBh72/9KuSsIMX4vIg6Je3xRYuDhv7YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786093231; c=relaxed/simple;
	bh=HpQJ6ScqRET77mJ9eypLApJN9/0A2otGW60Pd2zmOd4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a94A7mmZE/Z/UHruly+Z4fLEeiu2bEkMOto+RXpJVqvFKJ6bYHIwOkQy/uJyAo/jP2ZMISsrjuA3AiUmTCP91O9FFBd5ubMBZD3BN65JFX4JCptx+INZKqIVKfyO8QGpif2g2o+9/pVLMbv4saCQ+vmFMEHAvCabBT/ElgXlOMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ovidvj6d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ovidvj6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672781F000E9;
	Fri,  7 Aug 2026 09:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786093229;
	bh=8/SrVsEsGaeBo5qSBX31YDymuW5fM9Z/A4YrBG5Yv1I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ovidvj6dCKAkkwZftavRA5W/joAWVkrCqvFlughg283i5I9CobdlD/Ew810TFBwDB
	 PY9DvWfguRBgBBT7eJjQ+4yVNSkKiAwZS8QN0mWSWL3pNhzqG8DWa28OUoDaQni+kT
	 SbfbNlUECzopvT3DWmHT6lGuNvz+2wermJMEERcbqI/EgKNMlqy8IDR+x8S9w6lglA
	 dIFY9Ls+eZg0PDZ2LnNwRaWz27X64BqyxQEcnPDzVVgeuuFkZyaffaUSNpAPlB7u5Q
	 KgDObxTfloMSNx9IMLCV0s92+xDGS0wQeRGv69wfasWJqiaEpOpBxl3+u7SZBTCqBX
	 +Qbl7RnxkniNg==
Date: Fri, 7 Aug 2026 11:00:27 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, lorenzo.bianconi@oss.qualcomm.com
Subject: Re: [PATCH nf-next 2/7] net: netfilter: add ether_type to
 net_device_path_ctx and use it
Message-ID: <anWeq32DcHjUwMfV@lore-desk>
References: <20260806223535.523098-1-pablo@netfilter.org>
 <20260806223535.523098-3-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="t8m0gOoUTdlBy+Jv"
Content-Disposition: inline
In-Reply-To: <20260806223535.523098-3-pablo@netfilter.org>

--t8m0gOoUTdlBy+Jv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Add an ether_type field to struct net_device_path_ctx to reject IPv4
> over IPv6 and vice-versa, this is currently not support. Otherwise,
> incorrect dst_entry family can be reached from datapath.
>=20
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  include/linux/netdevice.h          | 1 +
>  net/ipv4/ipip.c                    | 3 +++
>  net/ipv6/ip6_tunnel.c              | 3 +++
>  net/netfilter/nf_flow_table_path.c | 6 ++++--
>  4 files changed, 11 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 4319b949f405..d9962c50bd60 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -939,6 +939,7 @@ struct net_device_path_stack {
>  struct net_device_path_ctx {
>  	const struct net_device *dev;
>  	u8			daddr[ETH_ALEN];
> +	__be16			ether_type;
> =20
>  	int			num_vlans;
>  	struct {
> diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
> index fb7d96f99b06..62a374079bfc 100644
> --- a/net/ipv4/ipip.c
> +++ b/net/ipv4/ipip.c
> @@ -360,6 +360,9 @@ static int ipip_fill_forward_path(struct net_device_p=
ath_ctx *ctx,
>  	const struct iphdr *tiph =3D &tunnel->parms.iph;
>  	struct rtable *rt;
> =20
> +	if (ctx->ether_type !=3D cpu_to_be16(ETH_P_IP))
> +		return -EOPNOTSUPP;
> +
>  	if (tunnel->collect_md)
>  		return -EOPNOTSUPP;
> =20
> diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> index d80020bc2620..3bfaa98e7f33 100644
> --- a/net/ipv6/ip6_tunnel.c
> +++ b/net/ipv6/ip6_tunnel.c
> @@ -1849,6 +1849,9 @@ static int ip6_tnl_fill_forward_path(struct net_dev=
ice_path_ctx *ctx,
>  	struct flowi6 fl6;
>  	int err;
> =20
> +	if (ctx->ether_type !=3D cpu_to_be16(ETH_P_IPV6))
> +		return -EOPNOTSUPP;
> +
>  	if (t->parms.flags & (IP6_TNL_F_USE_ORIG_TCLASS |
>  			      IP6_TNL_F_USE_ORIG_FLOWLABEL |
>  			      IP6_TNL_F_USE_ORIG_FWMARK))
> diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_t=
able_path.c
> index 0cbde535b8ba..5f166da3b09b 100644
> --- a/net/netfilter/nf_flow_table_path.c
> +++ b/net/netfilter/nf_flow_table_path.c
> @@ -44,13 +44,15 @@ static bool nft_is_valid_ether_device(const struct ne=
t_device *dev)
> =20
>  static int nft_dev_fill_forward_path(const struct dst_entry *dst_cache,
>  				     const struct nf_conn *ct,
> -				     enum ip_conntrack_dir dir, u8 *ha,
> +				     enum ip_conntrack_dir dir,
> +				     u8 *ha, __be16 ether_type,
>  				     struct net_device_path_stack *stack)
>  {
>  	const void *daddr =3D &ct->tuplehash[!dir].tuple.src.u3;
>  	struct net_device *dev =3D dst_cache->dev;
>  	struct net_device_path_ctx ctx =3D {
>  		.dev =3D dev,
> +		.ether_type =3D ether_type,
>  	};
>  	struct neighbour *n;
>  	u8 nud_state;
> @@ -228,7 +230,7 @@ static int nft_dev_forward_path(const struct nft_pkti=
nfo *pkt,
>  	unsigned char ha[ETH_ALEN];
>  	int i;
> =20
> -	if (nft_dev_fill_forward_path(dst, ct, dir, ha, &stack) < 0 ||
> +	if (nft_dev_fill_forward_path(dst, ct, dir, ha, pkt->ethertype, &stack)=
 < 0 ||
>  	    nft_dev_path_info(&stack, &info, ha, ft) < 0)
>  		return -ENOENT;
> =20
> --=20
> 2.47.3
>=20

--t8m0gOoUTdlBy+Jv
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCanWeqwAKCRA6cBh0uS2t
rEpAAQCEFGaLMMsehBIWkIRtHGNTMeG4hW/YM2TzTGbNgrRyeAD/X1YhnhXrYJRI
hfzk8uShsVAL1qbZSdIc+DBUn4vOLgY=
=49JX
-----END PGP SIGNATURE-----

--t8m0gOoUTdlBy+Jv--
