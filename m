Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B66C44A40B
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Aug 2026 09:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786093808; cv=none; b=FyVLLgxVM8AyS8Es1jBTClw9wfob3Hnj8fZL5j3tNQKCU0SNHrS8kQA4p7kikU723rGI3ZYK8qZdwYtpil2IL2drtzau5ZN+3bCljt0rCBuyQwTNHY6ZpVYY0usdbwIiWacEqvR7hzjKdU5ojt80H7TFlA2fpsut+IK89abQ9GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786093808; c=relaxed/simple;
	bh=hsDoMYCaTNzGWWa1BS+ThsEcgL9bBpu0kNHaE/Iw/Pk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V58kCcEQeJdXtdIsMhLgx4TwDQn1qRYd2mbYVbIEZny6hjZn8eb2J47yEez4QfQBwFWsHsLBbEyWqO6m/i9KWchXOQvWH5sQv83uI0xPtSysQRKOLX2bgvryKk1hiyK1GotPxQIOrpJg1B/FpvdsjFp9lHGa80bWHRd1t1Mm5ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DdAHDQjK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DdAHDQjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34F11F000E9;
	Fri,  7 Aug 2026 09:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786093807;
	bh=8wAqjV1guwH7nGJtIisjr5UWWsHP4E0asOkCD/6bkCA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DdAHDQjKWxkq23rNhQUObrxSoRH4+K8iyBmpf8q7PtjMp0hLsbfJqhVI1jvMcqgq7
	 B5EJfXjMlUvA094hJTVQoWEB40WUiQwSROpLkcEml3DnndwGare517bXc/5FqbWJyn
	 Az15nF9C7pAR87CKb9dWw+wWecayj9Et1ThZS9VVtrBWigR6i8Nh/6xkCD0LfDMes/
	 o1dLuOAR0NtW6F10ejJhyeqXtfrnfcoToMy61HNOjFBkP+LCUoVjRtukLJiH65ElTK
	 r+MSkW2IiikaoHaRshxm7YCIrMxqC4OFx6u4dgT/5pWO83y4uYqdp3FF23RQurGew8
	 d5BZv6c9/Xbwg==
Date: Fri, 7 Aug 2026 11:10:04 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, lorenzo.bianconi@oss.qualcomm.com
Subject: Re: [PATCH nf-next 5/7] netfilter: flowtable: store ethertype in
 flowtable context
Message-ID: <anWg7P5MeunmMdnP@lore-desk>
References: <20260806223535.523098-1-pablo@netfilter.org>
 <20260806223535.523098-6-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7U24hR4pTH/Pm6nn"
Content-Disposition: inline
In-Reply-To: <20260806223535.523098-6-pablo@netfilter.org>

--7U24hR4pTH/Pm6nn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Add a new field to store the ethertype of the packet, skipping layer 2
> encapsulation. Store the ether_type in the context after parsing the
> layer 2 header for the first time and then use it later on.
>=20
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  net/netfilter/nf_flow_table_ip.c | 47 +++++++++++++++++++-------------
>  1 file changed, 28 insertions(+), 19 deletions(-)
>=20
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_tab=
le_ip.c
> index ed90809b206e..4437f3a13cb2 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -147,6 +147,7 @@ static bool ip_has_options(unsigned int thoff)
> =20
>  struct nf_flowtable_ctx {
>  	const struct net_device	*in;
> +	__be16			ether_type;
>  	u32			offset;
>  	u32			hdrsize;
>  	struct {
> @@ -161,7 +162,6 @@ static void nf_flow_tuple_encap(struct nf_flowtable_c=
tx *ctx,
>  				struct sk_buff *skb,
>  				struct flow_offload_tuple *tuple)
>  {
> -	__be16 inner_proto =3D skb->protocol;
>  	struct vlan_ethhdr *veth;
>  	struct pppoe_hdr *phdr;
>  	struct ipv6hdr *ip6h;
> @@ -179,19 +179,17 @@ static void nf_flow_tuple_encap(struct nf_flowtable=
_ctx *ctx,
>  		veth =3D (struct vlan_ethhdr *)skb_mac_header(skb);
>  		tuple->encap[i].id =3D ntohs(veth->h_vlan_TCI);
>  		tuple->encap[i].proto =3D skb->protocol;
> -		inner_proto =3D veth->h_vlan_encapsulated_proto;
>  		offset +=3D VLAN_HLEN;
>  		break;
>  	case htons(ETH_P_PPP_SES):
>  		phdr =3D (struct pppoe_hdr *)skb_network_header(skb);
>  		tuple->encap[i].id =3D ntohs(phdr->sid);
>  		tuple->encap[i].proto =3D skb->protocol;
> -		inner_proto =3D *((__be16 *)(phdr + 1));
>  		offset +=3D PPPOE_SES_HLEN;
>  		break;
>  	}
> =20
> -	switch (inner_proto) {
> +	switch (ctx->ether_type) {
>  	case htons(ETH_P_IP):
>  		iph =3D (struct iphdr *)(skb_network_header(skb) + offset);
>  		if (ctx->tun.inner_proto =3D=3D IPPROTO_IPIP) {
> @@ -376,10 +374,10 @@ static void nf_flow_ip_tunnel_pop(struct nf_flowtab=
le_ctx *ctx,
>  }
> =20
>  static bool nf_flow_skb_encap_protocol(struct nf_flowtable_ctx *ctx,
> -				       struct sk_buff *skb, __be16 proto)
> +				       struct sk_buff *skb)
>  {
> -	__be16 inner_proto =3D skb->protocol;
>  	struct vlan_ethhdr *veth;
> +	__be16 ether_type;
>  	bool ret =3D false;
> =20
>  	switch (skb->protocol) {
> @@ -388,22 +386,27 @@ static bool nf_flow_skb_encap_protocol(struct nf_fl=
owtable_ctx *ctx,
>  			return false;
> =20
>  		veth =3D (struct vlan_ethhdr *)skb_mac_header(skb);
> -		if (veth->h_vlan_encapsulated_proto =3D=3D proto) {
> -			ctx->offset +=3D VLAN_HLEN;
> -			inner_proto =3D proto;
> -			ret =3D true;
> -		}
> +		ctx->ether_type =3D veth->h_vlan_encapsulated_proto;
> +		ctx->offset +=3D VLAN_HLEN;
> +		ret =3D true;
>  		break;
>  	case htons(ETH_P_PPP_SES):
> -		if (nf_flow_pppoe_proto(skb, &inner_proto) &&
> -		    inner_proto =3D=3D proto) {
> -			ctx->offset +=3D PPPOE_SES_HLEN;
> -			ret =3D true;
> -		}
> +		if (!nf_flow_pppoe_proto(skb, &ether_type))
> +			return false;
> +
> +		ctx->ether_type =3D ether_type;
> +		ctx->offset +=3D PPPOE_SES_HLEN;
> +		ret =3D true;
> +		break;
> +	case htons(ETH_P_IP):
> +	case htons(ETH_P_IPV6):
> +		ctx->ether_type =3D skb->protocol;
>  		break;
> +	default:
> +		return false;
>  	}
> =20
> -	switch (inner_proto) {
> +	switch (ctx->ether_type) {
>  	case htons(ETH_P_IP):
>  		ret =3D nf_flow_ip4_tunnel_proto(ctx, skb);
>  		break;
> @@ -455,7 +458,10 @@ nf_flow_offload_lookup(struct nf_flowtable_ctx *ctx,
>  {
>  	struct flow_offload_tuple tuple =3D {};
> =20
> -	if (!nf_flow_skb_encap_protocol(ctx, skb, htons(ETH_P_IP)))
> +	if (!nf_flow_skb_encap_protocol(ctx, skb))
> +		return NULL;
> +
> +	if (unlikely(ctx->ether_type !=3D htons(ETH_P_IP)))
>  		return NULL;
> =20
>  	if (nf_flow_tuple_ip(ctx, skb, &tuple) < 0)
> @@ -1101,7 +1107,10 @@ nf_flow_offload_ipv6_lookup(struct nf_flowtable_ct=
x *ctx,
>  {
>  	struct flow_offload_tuple tuple =3D {};
> =20
> -	if (!nf_flow_skb_encap_protocol(ctx, skb, htons(ETH_P_IPV6)))
> +	if (!nf_flow_skb_encap_protocol(ctx, skb))
> +		return NULL;
> +
> +	if (unlikely(ctx->ether_type !=3D htons(ETH_P_IPV6)))
>  		return NULL;
> =20
>  	if (nf_flow_tuple_ipv6(ctx, skb, &tuple) < 0)
> --=20
> 2.47.3
>=20

--7U24hR4pTH/Pm6nn
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCanWg7AAKCRA6cBh0uS2t
rMeaAPoDIQGDy/kk8swiUfhibdhBglNMxuVokL7yHTkHComMQQEAiUm2UKxKw2Ws
AMKtcYkHiTk4UPolugS5+TSHJQyVqgM=
=GjS4
-----END PGP SIGNATURE-----

--7U24hR4pTH/Pm6nn--
