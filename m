Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EBC36D517
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Aug 2026 09:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786093375; cv=none; b=DNbZDXAesRVI4/66bDzi8pOVqmQFwdByYSqcX2bLD2F9P7vTZf3LnpPb+Jp3eWKqKppLfyKbyyBICPuVjULIU4yGhnFnJ0jz5A7PwDjUN0ZGm9kvC6UFfgyxfUt1rfsgm8ceHoq4oq3S9gC+T91s2hSbk1iBfWehMBlnQGxB32w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786093375; c=relaxed/simple;
	bh=mrtiHCJC7YC9s0v9hnaReoRj2RpTwKL4dtWRoDq8Uxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c0gAFQE1uiKq9tsmlMy8nawl47/JQZD1DkWJUbNY6GdfoccYhYRGouNUyPSWjA+4g1qxib7FJqbJIDNULlmx68V3lc11c2dEiMUEk2WtcvQie9gSi5RcHq6fx7uySIcZM07i+hIQj6ETvtZs4uckio17/4Dgp1enlRHmeTwItLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dT0GEsfX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dT0GEsfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74461F000E9;
	Fri,  7 Aug 2026 09:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786093374;
	bh=KZo6GnnEjEj2sgmkkSiTWRTwN2S2jGjwdK0C2sk6It0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dT0GEsfXjy19UZLzQD+KxKlJR7bpHw+BoUWUSozV7Sz3l091G/fHDXBgJnJRYJ8k8
	 fdSWuUj8W+8zvkyrg68UByJ5ZzGx5VcSGTnywwcJh1BYJ/tcGxUxbMLmWl4zau+mrF
	 eRpepFX3LGPtZS+zpuuIBRHfb7p4nMDjjY4p/f90txWaYzkra/eQ6s9OXz1J9lFjA0
	 9XugyfEbkNFhqIVKwJShErZAX6MWebLMfB8tqw8oEduGMYLRUCszSDNpzZY3mhOx4Y
	 bResQviYjqIjtDq43yBRtEpeZKFizh0MCltEytQqgqM0r3Fv2KeuZXAa0BldF70L4Q
	 FIkxV/XdOPVpw==
Date: Fri, 7 Aug 2026 11:02:52 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, lorenzo.bianconi@oss.qualcomm.com
Subject: Re: [PATCH nf-next 4/7] netfilter: flowtable: rename ctx.tun.proto
 to ctx.tun.inner_proto
Message-ID: <anWfPBLT8x2GHqVs@lore-desk>
References: <20260806223535.523098-1-pablo@netfilter.org>
 <20260806223535.523098-5-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="eKIZDs6X+rZaJUX3"
Content-Disposition: inline
In-Reply-To: <20260806223535.523098-5-pablo@netfilter.org>

--eKIZDs6X+rZaJUX3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> For consistency with the tun.l3proto rename, use same name field.
> No functional changes are intended.
>=20
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  net/netfilter/nf_flow_table_ip.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>=20
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_tab=
le_ip.c
> index e1aa01763f33..ed90809b206e 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -153,7 +153,7 @@ struct nf_flowtable_ctx {
>  		/* Tunnel IP header size */
>  		u32 hdr_size;
>  		/* IP tunnel protocol */
> -		u8 proto;
> +		u8 inner_proto;
>  	} tun;
>  };
> =20
> @@ -194,7 +194,7 @@ static void nf_flow_tuple_encap(struct nf_flowtable_c=
tx *ctx,
>  	switch (inner_proto) {
>  	case htons(ETH_P_IP):
>  		iph =3D (struct iphdr *)(skb_network_header(skb) + offset);
> -		if (ctx->tun.proto =3D=3D IPPROTO_IPIP) {
> +		if (ctx->tun.inner_proto =3D=3D IPPROTO_IPIP) {
>  			tuple->tun.dst_v4.s_addr =3D iph->daddr;
>  			tuple->tun.src_v4.s_addr =3D iph->saddr;
>  			tuple->tun.inner_proto =3D IPPROTO_IPIP;
> @@ -202,7 +202,7 @@ static void nf_flow_tuple_encap(struct nf_flowtable_c=
tx *ctx,
>  		break;
>  	case htons(ETH_P_IPV6):
>  		ip6h =3D (struct ipv6hdr *)(skb_network_header(skb) + offset);
> -		if (ctx->tun.proto =3D=3D IPPROTO_IPV6) {
> +		if (ctx->tun.inner_proto =3D=3D IPPROTO_IPV6) {
>  			tuple->tun.dst_v6 =3D ip6h->daddr;
>  			tuple->tun.src_v6 =3D ip6h->saddr;
>  			tuple->tun.inner_proto =3D IPPROTO_IPV6;
> @@ -328,7 +328,7 @@ static bool nf_flow_ip4_tunnel_proto(struct nf_flowta=
ble_ctx *ctx,
>  		return false;
> =20
>  	if (iph->protocol =3D=3D IPPROTO_IPIP) {
> -		ctx->tun.proto =3D iph->protocol;
> +		ctx->tun.inner_proto =3D iph->protocol;
>  		ctx->tun.hdr_size =3D size;
>  		ctx->offset +=3D ctx->tun.hdr_size;
>  	}
> @@ -353,7 +353,7 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flowta=
ble_ctx *ctx,
>  		return false;
> =20
>  	if (ip6h->nexthdr =3D=3D IPPROTO_IPV6) {
> -		ctx->tun.proto =3D ip6h->nexthdr;
> +		ctx->tun.inner_proto =3D ip6h->nexthdr;
>  		ctx->tun.hdr_size =3D sizeof(*ip6h);
>  		ctx->offset +=3D ctx->tun.hdr_size;
>  	}
> @@ -367,8 +367,8 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flowta=
ble_ctx *ctx,
>  static void nf_flow_ip_tunnel_pop(struct nf_flowtable_ctx *ctx,
>  				  struct sk_buff *skb)
>  {
> -	if (ctx->tun.proto !=3D IPPROTO_IPIP &&
> -	    ctx->tun.proto !=3D IPPROTO_IPV6)
> +	if (ctx->tun.inner_proto !=3D IPPROTO_IPIP &&
> +	    ctx->tun.inner_proto !=3D IPPROTO_IPV6)
>  		return;
> =20
>  	skb_pull(skb, ctx->tun.hdr_size);
> --=20
> 2.47.3
>=20

--eKIZDs6X+rZaJUX3
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCanWfPAAKCRA6cBh0uS2t
rNG5AQCDDtQqSbhb+Cc7D2mrt0VCrMtcja6K2U8wQOJorj8tpAD/f41L3ln6FmtD
ubkdywaK083KjR/yX808uM78ZLeC/w0=
=aT47
-----END PGP SIGNATURE-----

--eKIZDs6X+rZaJUX3--
