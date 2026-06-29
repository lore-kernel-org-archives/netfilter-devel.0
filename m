Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634401A680C
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 15:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782746038; cv=none; b=XJll57N3ajiwBxgXbHuewLlSkUy3Gp9XpvpqZCC3DyNW46rW3Ru5Pmf6w9xukSJaT0xQBVXZOxdpcZqsot8H6kJ5Fpj8foWjMSamGWiDeZWykARuhKpWIYP6DvYb7WaTtRHIRBGLSggtAeAvsUILSsi0wVW9HFhffKw0pEt8yDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782746038; c=relaxed/simple;
	bh=6q2oxVkX7x093PDj3dumgAlkDdjTv9NT/nOcWdGXyLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jLu4O/MB3lEYiUzT20CQZHrQMeBTN2ZCOhpgbXi3XqNLDHaruqnOp2E17VJCpzEwxXwYo65Om1X70RgxnreoJUspCRgIIx/d+Tfnqa20qkjyn3m3hleFICu/8iiZlzVQ27iX6YWWN4x+95pe5m3Pkm1PWgvRSb5aL3tE1Pd9aIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gkrf1/2z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gkrf1/2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DA31F000E9;
	Mon, 29 Jun 2026 15:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782746035;
	bh=1F50sLDaioh9qyhhgcpCtALEMxm0ot25sV14gYM8T8E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Gkrf1/2zrMq2EhcWk5j2k7LvQUI1yeVq0bMN87rZuAE/4OIYn5q4VfkBiJ4Y0Trd8
	 pnO5EOzAZ/maw6IjLjUNB/VtZcSbM3dbuFvnRycZew8dMNr+Lc9/OpZguxsngI5/aC
	 85mYToG72m/+1yXWr9Kd81eOn6/Gonfts6SP0kgr4mbdrWiMMod26HwAwEYbqEYq9c
	 rA/n36VMAOImeX/U8WYFkxn6lwniq90Hfq5IYfj8yB9smDAe+m9l9aIrdZkmC2PBLZ
	 EuO7t5mVga6MWLYH8ELUUk/c6pSWh2OOGCXX2MTsvcMuSIGIFuNVjBU0bbCX66QyyW
	 G7oJOUT+n8zVg==
Date: Mon, 29 Jun 2026 17:13:52 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, chzhengyang2023@lzu.edu.cn
Subject: Re: [PATCH nf 3/3] netfilter: flowtable: support IPIP tunnel with
 direct xmit
Message-ID: <akKLsIf-NSC75B1Q@lore-desk>
References: <20260629143936.61239-1-pablo@netfilter.org>
 <20260629143936.61239-4-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="iRvw2yk06a3kI9FP"
Content-Disposition: inline
In-Reply-To: <20260629143936.61239-4-pablo@netfilter.org>


--iRvw2yk06a3kI9FP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Jun 29, Pablo Neira Ayuso wrote:
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
> ---
>  include/net/netfilter/nf_flow_table.h |  4 ++--
>  net/netfilter/nf_flow_table_core.c    | 15 +++++++++++----
>  net/netfilter/nf_flow_table_ip.c      |  3 +--
>  3 files changed, 14 insertions(+), 8 deletions(-)
>=20
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilte=
r/nf_flow_table.h
> index 7b23b245a5a8..369f6a717811 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -155,11 +155,11 @@ struct flow_offload_tuple {
>  					tun_num:2,
>  					in_vlan_ingress:2;
>  	u16				mtu;
> +	struct dst_entry		*dst_cache;
> +	u32				dst_cookie;

nit: if you swap dst_cache and dst_cookie we can avoid a 4 bytes padding ho=
le.

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
> index 99c5b9d671a0..6f195ccf222a 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -127,12 +127,21 @@ static int flow_offload_fill_route(struct flow_offl=
oad *flow,
> =20
>  	switch (route->tuple[dir].xmit_type) {
>  	case FLOW_OFFLOAD_XMIT_DIRECT:
> +		if (flow_tuple->tun_num) {
> +			flow_tuple->dst_cache =3D dst;
> +			flow_tuple->dst_cookie =3D
> +				flow_offload_dst_cookie(flow_tuple);
> +		} else {
> +			flow_tuple->dst_cache =3D NULL;
> +			flow_tuple->dst_cookie =3D 0;

nit: since we use kmem_cache_zalloc() in flow_offload_alloc() do we need th=
e else
branch?

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
> @@ -152,9 +161,7 @@ static int flow_offload_fill_route(struct flow_offloa=
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

--iRvw2yk06a3kI9FP
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCakKLsAAKCRA6cBh0uS2t
rNA2AQCCP7+SrFuru7mMsavgygOr9UqqJ36y8KUWgarYFU3CsgEAx2TYPy99Rudn
DMPlk25fOgNXLJPol7Zblxh50Z8Wrwg=
=KsK0
-----END PGP SIGNATURE-----

--iRvw2yk06a3kI9FP--
