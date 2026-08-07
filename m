Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0660E44238E
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Aug 2026 09:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786093989; cv=none; b=mmljRcSzHEyw0oglgcFiDVJcYkZ84iVzJTKDFnQ09JiV6W7mt7HVRAhewDkQscuRK27QpqDWukRXQ3iwO4q0Tqkk7NNw252jCQ69Otv+s/lCsy5ymmPeNpTZTBh8Td23zkyKlm4rdehbYr4uB9UiuEWo1O/Jo7ZvyU17bKJV8mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786093989; c=relaxed/simple;
	bh=iwU7qHYsZidg9Yyi3UH0ITepLubbQQNQlVucyGFpE/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kJUEXy0kIgEZhvnLDVuoY60hcZl3RQxws8Abjv2Q2AnvD2CD2qlHJKzhEUWHaDF3mfQIVPZaNPHa3upenIMUCMq6TBWhtz0E6zlXMHXvTzwNZxJJ03CHqJrBpr5PC++UUuSLIyLtEdcoktX8fXXRnIn0VDU5UGgyp0POs1WwJNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GGiVSLIH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GGiVSLIH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFA21F000E9;
	Fri,  7 Aug 2026 09:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786093987;
	bh=bEhO/MwSFhXkG9QDicJlSNkECJESmEIeNDQnG6NDvZk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GGiVSLIHmW59x7W8U5h2w+uuwnOUbizb8TOE9L88RgCX2iSGy21Rl7FU8R588OnKt
	 GMuav6Q8dKGpczkIHE4o5e07CUofJ7UeCM34rC/GhJwvUlBQcRyvcPE/EtW/5JG6qd
	 gw6KtPaJMUAooUiZ1RJEw5kXRYZvf5NQQdv1UwT0jtqBo397LhwRI3zLudK/84YdQ+
	 3aNVWwlAJnf4PbwrgJujN7ujZ45Y1g75BLMer9qD62LlX8KuJg930hldg9G0VzayNw
	 YDw4OVXdRBRkDXEModIcldV0S5S+VDr3Wwtb0msPMB13bm4/bSndUN+zUFnu/FL0jU
	 IaCMj8DujSs0A==
Date: Fri, 7 Aug 2026 11:13:05 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, lorenzo.bianconi@oss.qualcomm.com
Subject: Re: [PATCH nf-next 6/7] netfilter: flowtable: move ipv4 and ipv6
 xmit path to function
Message-ID: <anWhoSwYThFBuS2h@lore-desk>
References: <20260806223535.523098-1-pablo@netfilter.org>
 <20260806223535.523098-7-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="FGQT9BbQSpeZIlVp"
Content-Disposition: inline
In-Reply-To: <20260806223535.523098-7-pablo@netfilter.org>

--FGQT9BbQSpeZIlVp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Move the existing ipv4 and ipv6 transmit path to functions in
> preparation of the IPv4 over IPv6 and SIT support.
>=20
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Nice :)

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  net/netfilter/nf_flow_table_ip.c | 92 +++++++++++++++++++-------------
>  1 file changed, 54 insertions(+), 38 deletions(-)
>=20
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_tab=
le_ip.c
> index 4437f3a13cb2..18febca1dcef 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -800,33 +800,17 @@ static unsigned int nf_flow_queue_xmit(struct net *=
net, struct sk_buff *skb,
>  	return NF_STOLEN;
>  }
> =20
> -unsigned int
> -nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
> -			const struct nf_hook_state *state)
> +static int nf_flow_queue_xmit4(struct sk_buff *skb,
> +			       struct flow_offload_tuple_rhash *tuplehash,
> +			       const struct nf_hook_state *state)
>  {
> -	struct flow_offload_tuple_rhash *tuplehash;
> -	struct nf_flowtable *flow_table =3D priv;
>  	struct flow_offload_tuple *other_tuple;
>  	enum flow_offload_tuple_dir dir;
> -	struct nf_flowtable_ctx ctx =3D {
> -		.in	=3D state->in,
> -	};
>  	struct nf_flow_xmit xmit =3D {};
>  	struct flow_offload *flow;
>  	struct neighbour *neigh;
>  	struct rtable *rt;
>  	__be32 ip_daddr;
> -	int ret;
> -
> -	tuplehash =3D nf_flow_offload_lookup(&ctx, flow_table, skb);
> -	if (!tuplehash)
> -		return NF_ACCEPT;
> -
> -	ret =3D nf_flow_offload_forward(&ctx, flow_table, tuplehash, skb);
> -	if (ret < 0)
> -		return NF_DROP;
> -	else if (ret =3D=3D 0)
> -		return NF_ACCEPT;
> =20
>  	if (unlikely(tuplehash->tuple.xmit_type =3D=3D FLOW_OFFLOAD_XMIT_XFRM))=
 {
>  		rt =3D dst_rtable(tuplehash->tuple.dst_cache);
> @@ -879,6 +863,30 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *=
skb,
> =20
>  	return nf_flow_queue_xmit(state->net, skb, &xmit);
>  }
> +
> +unsigned int
> +nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
> +			const struct nf_hook_state *state)
> +{
> +	struct flow_offload_tuple_rhash *tuplehash;
> +	struct nf_flowtable *flow_table =3D priv;
> +	struct nf_flowtable_ctx ctx =3D {
> +		.in	=3D state->in,
> +	};
> +	int ret;
> +
> +	tuplehash =3D nf_flow_offload_lookup(&ctx, flow_table, skb);
> +	if (!tuplehash)
> +		return NF_ACCEPT;
> +
> +	ret =3D nf_flow_offload_forward(&ctx, flow_table, tuplehash, skb);
> +	if (ret < 0)
> +		return NF_DROP;
> +	else if (ret =3D=3D 0)
> +		return NF_ACCEPT;
> +
> +	return nf_flow_queue_xmit4(skb, tuplehash, state);
> +}
>  EXPORT_SYMBOL_GPL(nf_flow_offload_ip_hook);
> =20
>  static void nf_flow_nat_ipv6_tcp(struct sk_buff *skb, unsigned int thoff,
> @@ -1119,33 +1127,17 @@ nf_flow_offload_ipv6_lookup(struct nf_flowtable_c=
tx *ctx,
>  	return flow_offload_lookup(flow_table, &tuple);
>  }
> =20
> -unsigned int
> -nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
> -			  const struct nf_hook_state *state)
> +static int nf_flow_queue_xmit6(struct sk_buff *skb,
> +			       struct flow_offload_tuple_rhash *tuplehash,
> +			       const struct nf_hook_state *state)
>  {
> -	struct flow_offload_tuple_rhash *tuplehash;
> -	struct nf_flowtable *flow_table =3D priv;
>  	struct flow_offload_tuple *other_tuple;
>  	enum flow_offload_tuple_dir dir;
> -	struct nf_flowtable_ctx ctx =3D {
> -		.in	=3D state->in,
> -	};
>  	struct nf_flow_xmit xmit =3D {};
>  	struct in6_addr *ip6_daddr;
>  	struct flow_offload *flow;
>  	struct neighbour *neigh;
>  	struct rt6_info *rt;
> -	int ret;
> -
> -	tuplehash =3D nf_flow_offload_ipv6_lookup(&ctx, flow_table, skb);
> -	if (tuplehash =3D=3D NULL)
> -		return NF_ACCEPT;
> -
> -	ret =3D nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash, skb);
> -	if (ret < 0)
> -		return NF_DROP;
> -	else if (ret =3D=3D 0)
> -		return NF_ACCEPT;
> =20
>  	if (unlikely(tuplehash->tuple.xmit_type =3D=3D FLOW_OFFLOAD_XMIT_XFRM))=
 {
>  		rt =3D dst_rt6_info(tuplehash->tuple.dst_cache);
> @@ -1199,4 +1191,28 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_bu=
ff *skb,
> =20
>  	return nf_flow_queue_xmit(state->net, skb, &xmit);
>  }
> +
> +unsigned int
> +nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
> +			  const struct nf_hook_state *state)
> +{
> +	struct flow_offload_tuple_rhash *tuplehash;
> +	struct nf_flowtable *flow_table =3D priv;
> +	struct nf_flowtable_ctx ctx =3D {
> +		.in	=3D state->in,
> +	};
> +	int ret;
> +
> +	tuplehash =3D nf_flow_offload_ipv6_lookup(&ctx, flow_table, skb);
> +	if (!tuplehash)
> +		return NF_ACCEPT;
> +
> +	ret =3D nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash, skb);
> +	if (ret < 0)
> +		return NF_DROP;
> +	else if (ret =3D=3D 0)
> +		return NF_ACCEPT;
> +
> +	return nf_flow_queue_xmit6(skb, tuplehash, state);
> +}
>  EXPORT_SYMBOL_GPL(nf_flow_offload_ipv6_hook);
> --=20
> 2.47.3
>=20

--FGQT9BbQSpeZIlVp
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCanWhoQAKCRA6cBh0uS2t
rLhvAQD75tWt1w921wSm6ZGR/02hj9wwsjDbRMFtBuapc1GXbgEAuesMarEbU2wV
DDdg/qOojgC/Qtjg52I2FBWhvK08GAY=
=xzg+
-----END PGP SIGNATURE-----

--FGQT9BbQSpeZIlVp--
