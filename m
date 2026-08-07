Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080DB35838A
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Aug 2026 09:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786094128; cv=none; b=g/3h6t5kTPConJ6e/yhCBPXGSUTjed3gw46LdHyTTV1T89BWtOTJeOLC58S+0ad6MPSAl9rxVM/9MtF6YOaEPIim7eyuKdxbXAuGS/kSrqldZ6N+VkEeUPE8MdstjoJ3G8tuLjuGroSTJEjqWvrX/likKGMtH2FqvmwRFX+a5Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786094128; c=relaxed/simple;
	bh=6wvwkI7i0w+QiYtmoPUqrMr67TdoJGH7WzBK9doIAuA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FYI29ibqt7+C0CWn2NsfSD2NjKOOtrWpwS0N7aToA0UTLnZi078kESdGMglhHiauZzKxY/+ljtOLCCtDRWjrzKePcTL1JSll9aI90UyO0bbNw9ce0TsQghVGS/ydplYECvCdxs0pSvVOvjfWW00YmOcJbq+63ksnegs8ZFcYBjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ijEh4jxH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ijEh4jxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044951F000E9;
	Fri,  7 Aug 2026 09:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786094126;
	bh=5eitBm5AnryORoG8j/pZeSi7lSXmm2uCD+eYIsnofP8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ijEh4jxHPnC7XvrJ7y9BOmsnmQ1ya7HL3H/E1uQZsr8Y2tZZTK5Zj3kz5PR8lyLkf
	 lC4XO0UET0N9pgvj4NeV6GP6YGpMN3FCpXGCIBHV1K5o5o8orIdYS1hO1fYnFGpyQ8
	 +rOXh8WY+aLzkplAabKv8IIFNKxVppQzU91HCxmAGLTcQsqgQRCiL5BoIlSCxSJ7IQ
	 Adl9/3T5wI21Yl0RnhOHy8yjY9AZ2dotad0MX3o96DLwv/xGX0c14DpfbwaFJ95ocW
	 kWGI+QUfhwQxBqsJtvMyhsedwFdRor7eBTCQ34wG0EzSgdxdCBcidKABWJab7gd/Rr
	 gDRdNYyyZMu1A==
Date: Fri, 7 Aug 2026 11:15:24 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, lorenzo.bianconi@oss.qualcomm.com
Subject: Re: [PATCH nf-next 7/7] netfilter: flowtable: detach layer 2
 encapsulation parser from lookup
Message-ID: <anWiLPajNl3QbXTj@lore-desk>
References: <20260806223535.523098-1-pablo@netfilter.org>
 <20260806223535.523098-8-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="C7dkEEx4HMwEAAyA"
Content-Disposition: inline
In-Reply-To: <20260806223535.523098-8-pablo@netfilter.org>

--C7dkEEx4HMwEAAyA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Move the layer 2 encapsulation header parser out of the lookup function
> to prepare for IPv4 over IPv6 and SIT.
>=20
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  net/netfilter/nf_flow_table_ip.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
>=20
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_tab=
le_ip.c
> index 18febca1dcef..af534000a287 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -458,12 +458,6 @@ nf_flow_offload_lookup(struct nf_flowtable_ctx *ctx,
>  {
>  	struct flow_offload_tuple tuple =3D {};
> =20
> -	if (!nf_flow_skb_encap_protocol(ctx, skb))
> -		return NULL;
> -
> -	if (unlikely(ctx->ether_type !=3D htons(ETH_P_IP)))
> -		return NULL;
> -
>  	if (nf_flow_tuple_ip(ctx, skb, &tuple) < 0)
>  		return NULL;
> =20
> @@ -875,6 +869,12 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *=
skb,
>  	};
>  	int ret;
> =20
> +	if (!nf_flow_skb_encap_protocol(&ctx, skb))
> +		return NF_ACCEPT;
> +
> +	if (unlikely(ctx.ether_type !=3D htons(ETH_P_IP)))
> +		return NF_ACCEPT;
> +
>  	tuplehash =3D nf_flow_offload_lookup(&ctx, flow_table, skb);
>  	if (!tuplehash)
>  		return NF_ACCEPT;
> @@ -1115,12 +1115,6 @@ nf_flow_offload_ipv6_lookup(struct nf_flowtable_ct=
x *ctx,
>  {
>  	struct flow_offload_tuple tuple =3D {};
> =20
> -	if (!nf_flow_skb_encap_protocol(ctx, skb))
> -		return NULL;
> -
> -	if (unlikely(ctx->ether_type !=3D htons(ETH_P_IPV6)))
> -		return NULL;
> -
>  	if (nf_flow_tuple_ipv6(ctx, skb, &tuple) < 0)
>  		return NULL;
> =20
> @@ -1203,6 +1197,12 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_bu=
ff *skb,
>  	};
>  	int ret;
> =20
> +	if (!nf_flow_skb_encap_protocol(&ctx, skb))
> +		return NF_ACCEPT;
> +
> +	if (unlikely(ctx.ether_type !=3D htons(ETH_P_IPV6)))
> +		return NF_ACCEPT;
> +
>  	tuplehash =3D nf_flow_offload_ipv6_lookup(&ctx, flow_table, skb);
>  	if (!tuplehash)
>  		return NF_ACCEPT;
> --=20
> 2.47.3
>=20

--C7dkEEx4HMwEAAyA
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCanWiLAAKCRA6cBh0uS2t
rOBQAPsEcLquMkaHIuujP9zdAQ9oSOzi5axY1JsCro6yxWxYTAD/aAlA671glNPE
ASsNUlpjUZeL7T531fVoK8lO6QdagwQ=
=UChC
-----END PGP SIGNATURE-----

--C7dkEEx4HMwEAAyA--
