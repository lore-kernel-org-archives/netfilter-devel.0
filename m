Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C263E44FE
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Jun 2026 10:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781778662; cv=none; b=B78x5WIOuG8QNadrKjyKhLZ+1uT3kgDaQFkYMmIcSyiJTvoYLz+reNFG6aR2VWbiJYlW5dOHsS8b3Q9+jTiSIbJ1tQjcCUA/8ScV7EcoLYUD5vVxYTocgY+dgmJa0+p9TLAyvo8qOkYbWdDg/8nynHU0G3Wwp3i9Gn3NptdBxDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781778662; c=relaxed/simple;
	bh=gjWRJCHTsdnS7AJV6Pog2tuR87MSjeFrxPSpPEVUets=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UaGhPHngWVXkm90vF9SLkKuyUJT/vpeEA2PRxPfQcGaOgLZXi0FU5MLL10mI80AvZ019EJCpunGZBKXX5u4QG5xTx6JprfHM8iOOO3sBgvQsFXVwqdX42H1v75Wj/pAR/2U36Ha9EzSAMo7CmoOrkVeJi0mtR1592ww7D6Sm6B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EVCqBfga; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EVCqBfga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46ED31F000E9;
	Thu, 18 Jun 2026 10:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781778660;
	bh=HT+kx3oPR35tk3Vj7uGO8uj+nUmYlWuyEfEtKm2pJhc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EVCqBfgajbL5iTkYtp5dbw55FoEAET/q8ZUkR1caqFBwOYHEBDgSFLP1Fx6UWmG63
	 t5EO8CQaWEglV60Gj1J6/K2/WNzctILR0qyuZZVxBM0O9GIPUBQshrgPOwK3iP9jhH
	 Fh+jJ6VNbfXJ2L1ziihnqfjDZq7cf5s6lFQ4LF9zZvs6oIDvH4qwC9zqMYISTzRneF
	 jM/dClfaFrWsl/PhJ22GHnq9LoqGVJwqZHChPUDBi30pWILEnQ0VFgV3x+pSzPqrAC
	 mzG/34baSxGsnx9CS8kll4oOWp3t1Kmy8arHw/JnhhOsJstXsM6ogUYXi15/q2Cb4x
	 BTU25ga0EJhfA==
Date: Thu, 18 Jun 2026 12:30:58 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
	phil@nwl.cc, yuantan098@gmail.com, yifanwucs@gmail.com,
	tomapufckgml@gmail.com, bird@lzu.edu.cn, chzhengyang2023@lzu.edu.cn
Subject: Re: [PATCH nf v2 1/1] netfilter: nf_flow_table: separate tunnel
 route state from direct xmit
Message-ID: <ajPI4gA8VORUknoA@lore-desk>
References: <7016923271a6bb3e26f9a21757922d3c5b1a7487.1781683535.git.chzhengyang2023@lzu.edu.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="FhyDSjEE23MQLLmj"
Content-Disposition: inline
In-Reply-To: <7016923271a6bb3e26f9a21757922d3c5b1a7487.1781683535.git.chzhengyang2023@lzu.edu.cn>


--FhyDSjEE23MQLLmj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Jun 18, Ren Wei wrote:
> From: Zhengyang Chen<chzhengyang2023@lzu.edu.cn>
>=20
> When a flow tuple carries tunnel metadata and uses
> FLOW_OFFLOAD_XMIT_DIRECT, the transmit path may still need route state
> for tunnel push. However, the current tuple layout stores direct xmit
> L2 state and route state in overlapping runtime storage.
>=20
> As a result, a tuple may keep tun_num set while the tunnel push path
> later reads tuple->dst_cache, even though a direct xmit tuple only has
> out.ifidx/out.h_source/out.h_dest stored in that area. This leads to
> invalid dst usage and can trigger a crash in the tunnel transmit path.
>=20
> Fix this by moving dst_cache and dst_cookie out of the runtime union so
> that they can be shared by neighbour, xfrm, and direct tunnel flows.
> For FLOW_OFFLOAD_XMIT_DIRECT tuples carrying tunnel metadata, preserve
> route state in these shared fields and release it through the common
> dst release path.
>=20
> Keep dst validation on the forwarding tuple before the packet is
> modified, and validate the tunnel consumer tuple from the same early
> control point. This preserves protection for current NEIGH/XFRM users
> of tuplehash->tuple.dst_cache while avoiding the late-check fallback
> after decap, NAT, and TTL updates.
>=20
> Hardware offload rule construction still assumes that direct xmit flows
> do not carry tunnel route state, so reject that combination there for
> now to avoid undefined offload behaviour.
>=20
> Fixes: d30301ba4b07 ("netfilter: flowtable: Add IPIP tx sw acceleration")
> Cc: stable@vger.kernel.org
> Reported-by: Yuan Tan <yuantan098@gmail.com>
> Reported-by: Yifan Wu <yifanwucs@gmail.com>
> Reported-by: Juefei Pu <tomapufckgml@gmail.com>
> Reported-by: Xin Liu <bird@lzu.edu.cn>
> Signed-off-by: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>
> Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
> ---
> changes in v2:
>   - Move dst_cache and dst_cookie out of the runtime union instead of
>     introducing dedicated tunnel dst fields
>   - Reuse the shared dst_cache/dst_cookie storage for DIRECT tunnel
>     flows
>   - Simplify dst release through the common dst_cache path
>   - Update Fixes: to d30301ba4b07 ("netfilter: flowtable: Add IPIP tx sw
>     acceleration")
>   - v1 Link: https://lore.kernel.org/all/3947a39286d335b6136bbee26f8bf44b=
23471c69.1780580352.git.chzhengyang2023@lzu.edu.cn/
>=20
>  include/net/netfilter/nf_flow_table.h |  4 ++--
>  net/netfilter/nf_flow_table_core.c    | 12 ++++++++----
>  net/netfilter/nf_flow_table_ip.c      | 19 +++++++++++++++++++
>  net/netfilter/nf_flow_table_offload.c |  3 +++
>  4 files changed, 32 insertions(+), 6 deletions(-)
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
> index 785d8c244a77..252b081319a7 100644
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

Hi Ren Wei,

If I read the code correctly flow_tuple->tun and flow_tuple->tun_num are set
according to route->tuple[].in.tun and route->tuple[].in.num_tuns. Moreover,
route->tuple[].in.tun/route->tuple[].in.num_tuns are set just in
nft_dev_forward_path() that is executed only for FLOW_OFFLOAD_XMIT_NEIGH
entries. Am I missing something here?
Moreover, can you please add a selftest for this case in
tools/testing/selftests/net/netfilter/nft_flowtable.sh? Thanks.

Regards,
Lorenzo

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
> index 9c05a50d6013..b125868ab1fb 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -299,6 +299,11 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff=
 *skb, unsigned int mtu)
> =20
>  static inline bool nf_flow_dst_check(struct flow_offload_tuple *tuple)
>  {
> +	if (tuple->tun_num &&
> +	    tuple->xmit_type =3D=3D FLOW_OFFLOAD_XMIT_DIRECT &&
> +	    !dst_check(tuple->dst_cache, tuple->dst_cookie))
> +		return false;
> +
>  	if (tuple->xmit_type !=3D FLOW_OFFLOAD_XMIT_NEIGH &&
>  	    tuple->xmit_type !=3D FLOW_OFFLOAD_XMIT_XFRM)
>  		return true;
> @@ -482,6 +487,7 @@ static int nf_flow_offload_forward(struct nf_flowtabl=
e_ctx *ctx,
>  				   struct flow_offload_tuple_rhash *tuplehash,
>  				   struct sk_buff *skb)
>  {
> +	struct flow_offload_tuple *other_tuple;
>  	enum flow_offload_tuple_dir dir;
>  	struct flow_offload *flow;
>  	unsigned int thoff, mtu;
> @@ -507,6 +513,12 @@ static int nf_flow_offload_forward(struct nf_flowtab=
le_ctx *ctx,
>  		return 0;
>  	}
> =20
> +	other_tuple =3D &flow->tuplehash[!dir].tuple;
> +	if (other_tuple->tun_num && !nf_flow_dst_check(other_tuple)) {
> +		flow_offload_teardown(flow);
> +		return 0;
> +	}
> +
>  	if (skb_ensure_writable(skb, thoff + ctx->hdrsize))
>  		return -1;
> =20
> @@ -1091,6 +1103,7 @@ static int nf_flow_offload_ipv6_forward(struct nf_f=
lowtable_ctx *ctx,
>  					struct flow_offload_tuple_rhash *tuplehash,
>  					struct sk_buff *skb, int encap_limit)
>  {
> +	struct flow_offload_tuple *other_tuple;
>  	enum flow_offload_tuple_dir dir;
>  	struct flow_offload *flow;
>  	unsigned int thoff, mtu;
> @@ -1119,6 +1132,12 @@ static int nf_flow_offload_ipv6_forward(struct nf_=
flowtable_ctx *ctx,
>  		return 0;
>  	}
> =20
> +	other_tuple =3D &flow->tuplehash[!dir].tuple;
> +	if (other_tuple->tun_num && !nf_flow_dst_check(other_tuple)) {
> +		flow_offload_teardown(flow);
> +		return 0;
> +	}
> +
>  	if (skb_ensure_writable(skb, thoff + ctx->hdrsize))
>  		return -1;
> =20
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flo=
w_table_offload.c
> index 002ec15d988b..e3ace6435074 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -820,6 +820,9 @@ nf_flow_offload_rule_alloc(struct net *net,
> =20
>  	tuple =3D &flow->tuplehash[dir].tuple;
>  	other_tuple =3D &flow->tuplehash[!dir].tuple;
> +	if (other_tuple->tun_num &&
> +	    other_tuple->xmit_type =3D=3D FLOW_OFFLOAD_XMIT_DIRECT)
> +		goto err_flow_match;
>  	if (other_tuple->xmit_type =3D=3D FLOW_OFFLOAD_XMIT_NEIGH)
>  		other_dst =3D other_tuple->dst_cache;
> =20
> --=20
> 2.43.0
>=20

--FhyDSjEE23MQLLmj
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCajPI4gAKCRA6cBh0uS2t
rHwAAQCMSHUj973A83/DQ6whRH8xG8zPdyuT2hagTunYp9U9iwEAx9fYiiGRqFaI
8UzAfbhNkfWI1Ulw/L/LYAlChD+Gswg=
=H5xr
-----END PGP SIGNATURE-----

--FhyDSjEE23MQLLmj--
