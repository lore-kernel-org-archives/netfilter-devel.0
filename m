Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C9C25B09F
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Jun 2026 10:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782814777; cv=none; b=I2Bdic1gmeM/gtHnwv6p76GmdFvQoHelQjD1Tdka/q30ESR15DFPFOdaZzyrMfpcI3KHmdUa7rEiUspgkxTWFYYW284cy994K6d3qVs826T+0woldRjT7mA7Q/5FwEeAQWgcz6pDKhw0UMmTLWWUOnjmL1d/eLm4cx7xYJ9YaZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782814777; c=relaxed/simple;
	bh=a+off5lGSu7ooNbC/Ay62sXK4B4wp7eIBsAMn9q8/PU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SeNjfpq81IhbHcdj40zocajYxrPkeRYPGZMnR6nLKL4mE33CMWKMDGU/Z0wCWYy8CoHqxnd0sfKqJ7X5SCQWei8ht/PzBQ9f9uAGJaExIlYA4uCiVd/RA/q3nLOeVH1L0lUrRsbYbz3Wcz81xJ9ii05BX9naN9gWbYygSzzDGBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g121OvA7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g121OvA7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E581F000E9;
	Tue, 30 Jun 2026 10:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782814775;
	bh=dBdmvwbKSYirF5S0Zs5NAzSNO50TEfBsm/Np4Ms7cng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g121OvA7rlR3Xitoa/o2kWkVxzjAV8hNf35SRGAYNMqCl/8Eh9LdWd/EYT2dAIZ2F
	 RzyydBdBf37GzGPcvcJPVusn+vOUKKAYamdT4SmBTQDEj6sTOKfCUqUgUZzTNGugDi
	 LAvzPl05h+EquwNsfjCJiIcZkv6FUCSuh+uJYGsCvz70DmBQlYEWQt+E1z/7Bp/3qG
	 WUWiM79q33KcwrupRQqdhNdzRRNG3s1PCk/FGHmjtTr+vZ4PLUxxwikN5ppn2sTUaj
	 AyGcspfs8x/rsePNGWSSq4AxLog8eDNa9JSS/sioL5iVdueF1gwP4IXryaXoB2VRbP
	 s/CU26GcE1Yfg==
Date: Tue, 30 Jun 2026 12:19:33 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, chzhengyang2023@lzu.edu.cn
Subject: Re: [PATCH nf,v2 3/3] netfilter: flowtable: support IPIP tunnel with
 direct xmit
Message-ID: <akOYNVomeWJOcPOb@lore-desk>
References: <20260630094056.97038-1-pablo@netfilter.org>
 <20260630094056.97038-3-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3wxqNX4LahmuM0EJ"
Content-Disposition: inline
In-Reply-To: <20260630094056.97038-3-pablo@netfilter.org>


--3wxqNX4LahmuM0EJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> The combination of IPIP tunnel with direct xmit, eg. bridge device,
> breaks because no dst_entry is provided to check the skb headroom and to
> set the iph->frag_off field. This leads to invalid dst usage and can
> trigger a crash in the tunnel transmit path.
>=20
> Fix this by moving dst_cache and dst_cookie out of the runtime union so
> that they can be shared by neighbour, xfrm, and direct tunnel flows.
> For FLOW_OFFLOAD_XMIT_DIRECT tuples carrying tunnel metadata, preserve
> route state in these shared fields and release it through the common
> dst release path.
>=20
> Since dst_entry is now available to the three supported xmit modes and
> dst_release() already deals with NULL dst, remove the xmit type check
> in nft_flow_dst_release(). Moreover, skip the check if the dst entry
> is NULL in nf_flow_dst_check() which is now the case for the direct
> xmit case.
>=20
> Based on patch from Rein Wei <n05ec@lzu.edu.cn>.
>=20
> Fixes: d30301ba4b07 ("netfilter: flowtable: Add IPIP tx sw acceleration")
> Reported-by: Yuan Tan <yuantan098@gmail.com>
> Reported-by: Xin Liu <bird@lzu.edu.cn>
> Reported-by: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>
> Reported-by: Ren Wei <n05ec@lzu.edu.cn>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
> v2: - reorder dst_cookie and dst_cache to fix a 4-byte hole in struct
>     - remove unnecessary zeroing on dst_cookie and dst_cache, struct is a=
lready zeroed at init
>     Both updates per Lorenzo Bianconi's comment.
>=20
>  include/net/netfilter/nf_flow_table.h |  5 +++--
>  net/netfilter/nf_flow_table_core.c    | 12 ++++++++----
>  net/netfilter/nf_flow_table_ip.c      |  3 +--
>  3 files changed, 12 insertions(+), 8 deletions(-)
>=20
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilte=
r/nf_flow_table.h
> index dc5c9b48e65a..ce414118962f 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -155,11 +155,12 @@ struct flow_offload_tuple {
>  					tun_num:2,
>  					in_vlan_ingress:2;
>  	u16				mtu;
> +	u32				dst_cookie;
> +	struct dst_entry		*dst_cache;
> +
>  	union {
>  		struct {
> -			struct dst_entry *dst_cache;
>  			u32		ifidx;
> -			u32		dst_cookie;
>  		};
>  		struct {
>  			u32		ifidx;
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_t=
able_core.c
> index d06ce0848b68..2a829b5e8240 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -127,12 +127,18 @@ static int flow_offload_fill_route(struct flow_offl=
oad *flow,
> =20
>  	switch (route->tuple[dir].xmit_type) {
>  	case FLOW_OFFLOAD_XMIT_DIRECT:
> +		if (flow_tuple->tun_num) {
> +			flow_tuple->dst_cache =3D dst;
> +			flow_tuple->dst_cookie =3D
> +				flow_offload_dst_cookie(flow_tuple);
> +		}
>  		memcpy(flow_tuple->out.h_dest, route->tuple[dir].out.h_dest,
>  		       ETH_ALEN);
>  		memcpy(flow_tuple->out.h_source, route->tuple[dir].out.h_source,
>  		       ETH_ALEN);
>  		flow_tuple->out.ifidx =3D route->tuple[dir].out.ifindex;
> -		dst_release(dst);
> +		if (!flow_tuple->tun_num)
> +			dst_release(dst);
>  		break;
>  	case FLOW_OFFLOAD_XMIT_XFRM:
>  	case FLOW_OFFLOAD_XMIT_NEIGH:
> @@ -152,9 +158,7 @@ static int flow_offload_fill_route(struct flow_offloa=
d *flow,
>  static void nft_flow_dst_release(struct flow_offload *flow,
>  				 enum flow_offload_tuple_dir dir)
>  {
> -	if (flow->tuplehash[dir].tuple.xmit_type =3D=3D FLOW_OFFLOAD_XMIT_NEIGH=
 ||
> -	    flow->tuplehash[dir].tuple.xmit_type =3D=3D FLOW_OFFLOAD_XMIT_XFRM)
> -		dst_release(flow->tuplehash[dir].tuple.dst_cache);
> +	dst_release(flow->tuplehash[dir].tuple.dst_cache);
>  }
> =20
>  void flow_offload_route_init(struct flow_offload *flow,
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_tab=
le_ip.c
> index 089f2bc19972..0b78decce8a9 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -299,8 +299,7 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff =
*skb, unsigned int mtu)
> =20
>  static inline bool nf_flow_dst_check(struct flow_offload_tuple *tuple)
>  {
> -	if (tuple->xmit_type !=3D FLOW_OFFLOAD_XMIT_NEIGH &&
> -	    tuple->xmit_type !=3D FLOW_OFFLOAD_XMIT_XFRM)
> +	if (!tuple->dst_cache)
>  		return true;
> =20
>  	return dst_check(tuple->dst_cache, tuple->dst_cookie);
> --=20
> 2.47.3
>=20

--3wxqNX4LahmuM0EJ
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCakOYNQAKCRA6cBh0uS2t
rPwFAP9BEAwsbvVqN5zh0NdbfrRTIAbG7RUnKCHcJJQa7yKGPgEAueYSokbDbpb3
2yUrPvqwSTtZVLxBAbsPuu6bcCpA2AE=
=atYx
-----END PGP SIGNATURE-----

--3wxqNX4LahmuM0EJ--
