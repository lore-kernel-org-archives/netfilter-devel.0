Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0153EF675
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 15:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782746248; cv=none; b=fHDrkYu7aFH+JXkJ/M7LIyGHL4Qi0jl1aylV0dWhnaUveIGC4gTEYQXCWomxMlVjSH7wmae/d77s34wHnnyYFSJL3izHU7Ov53L3qop5a8Rxjnm8S0C9CXnisnlVtkyBwDw6Oy5vjllpHvFxKmGsuphdZ4EW9aA51vFgYzWw4jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782746248; c=relaxed/simple;
	bh=PqvnPOFDzFQEQ2VRUv4PKCJMMYqaoo3jQCd4Fo0U2Dg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tkAclQnzYQZ/RW50/8rMxRqZ0Uc3p0rlf3s4dUKkeJ6fz7/w8kfMGpb90Q6uMo0pt3D+KxNkSx3Z4wJ9mj3qppoF2yu+shO1/Tt5QlkGHPD3BTl02sw0nXzEqjijGwKRixkr+stWk0n0wGsp21tNcHNQzFMK+B2weedSWbt+hYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dlEN/APc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dlEN/APc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93A91F000E9;
	Mon, 29 Jun 2026 15:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782746247;
	bh=XOeDyT/vp/gpAR7WEkw5Y5O5ebf0kipeKR6CMqw8HkI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dlEN/APcA9SRZN09V/ZdyXYd57Lu7HSOwbAIBoHc9Sz4bW6g94UCymcs7rLfP8pYG
	 qJSvvzCBNiT4KdYjGIMV3gU8V8f76fXr/9LXWF2JaQnSlpG2o7GeUMUbdSQlN+syKk
	 yAeMZrLqo9mom266vbe54u+YhPZ7IawlMgsYP3FDh3gnskOKFmAXozmy95bWekxRhv
	 fPOxle36C+ylwpR1NnL5RkBmYEy6oFKg5nCVudZTxe9jaSPfMmwYNc8IvYw3Q6giFY
	 JWpzp+zxPUVv+3irmPiNgxOJszGKDxF/z2GKr3B1zqMl9H6MqjfjzOt0jH9ngLC4yi
	 zOnNnhPmsr80g==
Date: Mon, 29 Jun 2026 17:17:25 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, chzhengyang2023@lzu.edu.cn
Subject: Re: [PATCH nf 1/3] netfilter: flowtable: use dst in this direction
 when pushing IPIP header
Message-ID: <akKMhZo9OFQisGiw@lore-desk>
References: <20260629143936.61239-1-pablo@netfilter.org>
 <20260629143936.61239-2-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="YLPrUJcEln5zlbs6"
Content-Disposition: inline
In-Reply-To: <20260629143936.61239-2-pablo@netfilter.org>


--YLPrUJcEln5zlbs6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Jun 29, Pablo Neira Ayuso wrote:
> When pushing the IPIP header, the route of the other direction is used
> to calculate the headroom, use the route in this direction. Accessing
> the other tuple to set the IP source and destination is fine because
> this tuple does not provide such information to avoid storing redundant
> information. However, this tuple already provides the dst for this
> direction, this went unnoticed because this bug affects headroom and
> iph->frag_off only at this stage.
>=20
> Fixes: d30301ba4b07 ("netfilter: flowtable: Add IPIP tx sw acceleration")
> Fixes: 93cf357fa797 ("netfilter: flowtable: Add IP6IP6 tx sw acceleration=
")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  net/netfilter/nf_flow_table_ip.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
>=20
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_tab=
le_ip.c
> index 29e93ac1e2e4..089f2bc19972 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -590,10 +590,10 @@ static int nf_flow_pppoe_push(struct sk_buff *skb, =
u16 id,
> =20
>  static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *skb,
>  				    struct flow_offload_tuple *tuple,
> -				    __be32 *ip_daddr)
> +				    struct dst_entry *dst, __be32 *ip_daddr)
>  {
>  	struct iphdr *iph =3D (struct iphdr *)skb_network_header(skb);
> -	struct rtable *rt =3D dst_rtable(tuple->dst_cache);
> +	struct rtable *rt =3D dst_rtable(dst);
>  	u8 tos =3D iph->tos, ttl =3D iph->ttl;
>  	__be16 frag_off =3D iph->frag_off;
>  	u32 headroom =3D sizeof(*iph);
> @@ -636,21 +636,22 @@ static int nf_flow_tunnel_ipip_push(struct net *net=
, struct sk_buff *skb,
> =20
>  static int nf_flow_tunnel_v4_push(struct net *net, struct sk_buff *skb,
>  				  struct flow_offload_tuple *tuple,
> -				  __be32 *ip_daddr)
> +				  struct dst_entry *dst,  __be32 *ip_daddr)
>  {
>  	if (tuple->tun_num)
> -		return nf_flow_tunnel_ipip_push(net, skb, tuple, ip_daddr);
> +		return nf_flow_tunnel_ipip_push(net, skb, tuple, dst, ip_daddr);
> =20
>  	return 0;
>  }
> =20
>  static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *s=
kb,
>  				      struct flow_offload_tuple *tuple,
> +				      struct dst_entry *dst,
>  				      struct in6_addr **ip6_daddr)
>  {
>  	struct ipv6hdr *ip6h =3D (struct ipv6hdr *)skb_network_header(skb);
> -	struct rtable *rt =3D dst_rtable(tuple->dst_cache);
>  	__u8 dsfield =3D ipv6_get_dsfield(ip6h);
> +	struct rtable *rt =3D dst_rtable(dst);
>  	struct flowi6 fl6 =3D {
>  		.daddr =3D tuple->tun.src_v6,
>  		.saddr =3D tuple->tun.dst_v6,
> @@ -696,10 +697,11 @@ static int nf_flow_tunnel_ip6ip6_push(struct net *n=
et, struct sk_buff *skb,
> =20
>  static int nf_flow_tunnel_v6_push(struct net *net, struct sk_buff *skb,
>  				  struct flow_offload_tuple *tuple,
> +				  struct dst_entry *dst,
>  				  struct in6_addr **ip6_daddr)
>  {
>  	if (tuple->tun_num)
> -		return nf_flow_tunnel_ip6ip6_push(net, skb, tuple, ip6_daddr);
> +		return nf_flow_tunnel_ip6ip6_push(net, skb, tuple, dst, ip6_daddr);
> =20
>  	return 0;
>  }
> @@ -842,7 +844,8 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *s=
kb,
>  	other_tuple =3D &flow->tuplehash[!dir].tuple;
>  	ip_daddr =3D other_tuple->src_v4.s_addr;
> =20
> -	if (nf_flow_tunnel_v4_push(state->net, skb, other_tuple, &ip_daddr) < 0)
> +	if (nf_flow_tunnel_v4_push(state->net, skb, other_tuple,
> +				   tuplehash->tuple.dst_cache, &ip_daddr) < 0)
>  		return NF_DROP;
> =20
>  	switch (tuplehash->tuple.xmit_type) {
> @@ -1158,6 +1161,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buf=
f *skb,
>  	ip6_daddr =3D &other_tuple->src_v6;
> =20
>  	if (nf_flow_tunnel_v6_push(state->net, skb, other_tuple,
> +				   tuplehash->tuple.dst_cache,
>  				   &ip6_daddr) < 0)
>  		return NF_DROP;
> =20
> --=20
> 2.47.3
>=20

--YLPrUJcEln5zlbs6
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCakKMhQAKCRA6cBh0uS2t
rNzSAQD30B1hEHMa5C5mLE/PBpxGngdLrJQfeZ/Is4GkGpTW3AEA75vLeTPmdLym
74zeXYQbmicBKXhAB4wZ6NWmPqu34As=
=pDAt
-----END PGP SIGNATURE-----

--YLPrUJcEln5zlbs6--
