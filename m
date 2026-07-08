Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F27E41CB36;
	Wed,  8 Jul 2026 15:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783525161; cv=none; b=heBpYIpTPbRO6tstr20WJk0v0I7Ef0jhJzJx5OaLPdwwp4r6uqjI8Lgu3o4MnpMHTUo5wzRA//Whz+8ZiVzFsJj+JHT483+JYuupb5taxSfP8KYb80EDwCV1gey6ci9p9xMLekQ3x5wHe3JaCO/BGKv9jg4oce+xSMTKFc6fHUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783525161; c=relaxed/simple;
	bh=wSb+ip3Mc/5nkIYnq5+tfHczbFcOv3FTGxgnAf/rIMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aF5v75H/USys9PA+WjNzOtb9ocKsud7ghAVMU0ED50hignMlfC+q8O+tDw+gdA3xJnFrBKTRM2KpYI+xsxjjdX95VUIVZ0GkjFmp50Get0fNognirDOmhsFHWIdvDfcBmPJHbNXrdJLmJbZeOnXvXGlX6YBRMfzvSbRo4XRsyp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mxR5NGzL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mxR5NGzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BDE1F000E9;
	Wed,  8 Jul 2026 15:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783525159;
	bh=mfOCuRwUrrtswsWzGs1Toevf3b2ceH8hRYr3ZiAdkZQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mxR5NGzLKTqm5Ss35IWkaGeq8FhRNzjFehrLfLMzCq2X3OGOuL4hMmDDIlEVKwRuj
	 dEfzEGCmQmDgIR/OrJZEpk8qaddgF+LpWc4pG3JRW9Aqod/0VgbRRzhBxrDUoTyzcR
	 XkG09nt4Xcgk0giAmoE6xVzi2/JBq8WcgHtBaRpNyX3t2d7U2g8IMarn7C0oSYzmPW
	 5r5VGEb1/L/I4I7YG8tY+hQOI5WHLBXg8mj9c94SG6whUqXI8L5HO6jUA+5cvl+UjF
	 lCi1/E/jrPHKNMGeNm9elsQ0MNXqEHSAdNDIu28ZLx1LLrHogIOmFHzkUs98kRv3p8
	 p5KvhsiNEFE0Q==
Date: Wed, 8 Jul 2026 17:39:17 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: David Ahern <dsahern@kernel.org>
Cc: Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ipip: use tunnel parameters for
 fill_forward_path route lookup
Message-ID: <ak5vJVq-WDD_rGPT@lore-desk>
References: <20260708-ipip-route-lookup-fill_forward_path-v1-1-b77df74822ed@kernel.org>
 <9badfd3b-f9f7-49b8-9c34-980b17c22794@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="t18WP0Dp1flYLeRW"
Content-Disposition: inline
In-Reply-To: <9badfd3b-f9f7-49b8-9c34-980b17c22794@kernel.org>


--t18WP0Dp1flYLeRW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Jul 08, David Ahern wrote:
> On 7/8/26 5:25 AM, Lorenzo Bianconi wrote:
> > Pass source address, DSCP and output interface from the tunnel
> > configuration to ip_route_output() in ipip_fill_forward_path(), aligning
> > the route lookup with the slow path in ipip_tunnel_xmit().
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  net/ipv4/ipip.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
> > index b643194f57d2..d1aa048a6099 100644
> > --- a/net/ipv4/ipip.c
> > +++ b/net/ipv4/ipip.c
> > @@ -360,8 +360,9 @@ static int ipip_fill_forward_path(struct net_device=
_path_ctx *ctx,
> >  	const struct iphdr *tiph =3D &tunnel->parms.iph;
> >  	struct rtable *rt;
> > =20
> > -	rt =3D ip_route_output(dev_net(ctx->dev), tiph->daddr, 0, 0, 0,
> > -			     RT_SCOPE_UNIVERSE);
> > +	rt =3D ip_route_output(dev_net(ctx->dev), tiph->daddr, tiph->saddr,
> > +			     inet_dsfield_to_dscp(tiph->tos),
> > +			     tunnel->parms.link, RT_SCOPE_UNIVERSE);
> >  	if (IS_ERR(rt))
> >  		return PTR_ERR(rt);
> > =20
> >=20
> > ---
> > base-commit: 155c68aef2397f8c5d72ef10acf48ae159bf1869
> > change-id: 20260708-ipip-route-lookup-fill_forward_path-6a8a1f45084c
> >=20
> > Best regards,
>=20
> This and the ipv6 version seem correct to me. Please add test cases for
> both.

I guess we already have selftests for them in:
https://github.com/torvalds/linux/blob/master/tools/testing/selftests/net/n=
etfilter/nft_flowtable.sh#L584

Regards,
Lorenzo


--t18WP0Dp1flYLeRW
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCak5vJQAKCRA6cBh0uS2t
rK1QAQCqA1g9GXfic0L+jsNjYqA1stEPAY82SAaW5CzXDSrkQQEAgNNxio32btHE
bWmQpuijB1G5Lc+2XLQGYVG6uSa92wc=
=jggN
-----END PGP SIGNATURE-----

--t18WP0Dp1flYLeRW--
