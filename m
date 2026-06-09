Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80873EFFC1;
	Tue,  9 Jun 2026 10:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781000892; cv=none; b=LXIqR+5MaOuAMzqekXk2uUZKQSdnWU39D3Mg+VMOYtnT8VuyqC9gX57iMoPnDkCJDi36/hyPKW2LWl5q9aEPWZ19HHgGutG4hX88YS/k9dP0ZqsEbiOZRPnt+vRlsXNSi87vOnPmGVEkNws5oqvBkKkpM0BS6bCgreJ7cA+ELtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781000892; c=relaxed/simple;
	bh=xWwLjY+d3Gh7XgmD1OnRU+c8waYevIfSLbDjWLaP47g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tHK/1LJ1oKwrNV1yzUFZankl8mZq0wM1zC5DmGEdt9ZxYeBApogvlFw+XZe8KxWV9yI8gFVB5HgZ74bApvMBUIuc18QKWR3CDhpMe2QWQDId0s1Mn381bvXn3MXySFDbyH7WZXdGPvTOH4sIwFs2D6Li9MCnmAOkm5TI+94gI1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TTnAwFR/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TTnAwFR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3D61F00893;
	Tue,  9 Jun 2026 10:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781000891;
	bh=Qit49/33uthr+olUmUKc5wGFm2ZXUZOhseASV9OXSLc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TTnAwFR/2BvccaN8RXgJnuPY8TRjY40b+HWHJJj8poJZFoplvQAG9ba3VYy9XtRHP
	 3g3Hn3TNyBj78KqsaaV93jruuFlVNX2dyEKAjOz03o82LoYj1rSqfuY3DNZawzAFjI
	 ceuE5aOQHDwfbZGWhzKQizTLirmVFcxJZ/kd2zJhEDwfhVNG95bV/OwOLBxuOBwzVT
	 VZ00OWy3QlkVqUOstxaiXs0+pFVUUdF+6QPDJUmcXdyBj1ukPuE/Rl5X8uGVjZNIri
	 xjkAIGBkhngfdDBzjab2Ud+Ti/DV/cCqetanltS9b+O+wRhYpppI5eEllVz2stRLiM
	 aCUTYFqI3RDHQ==
Date: Tue, 9 Jun 2026 12:28:08 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: flowtable: use pskb_may_pull() in
 nf_flow_ip6_tunnel_proto()
Message-ID: <aifquGhK_Cijxq7m@lore-desk>
References: <20260608-b4-nf_flow_ip6_tunnel_proto-update-v1-1-782c7052c8fd@kernel.org>
 <aidMPKrm9gOcPLW-@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yewHE/uM8fRf8hKj"
Content-Disposition: inline
In-Reply-To: <aidMPKrm9gOcPLW-@chamomile>


--yewHE/uM8fRf8hKj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Jun 09, Pablo Neira Ayuso wrote:
> Hi Lorenzo,
>=20
> On Mon, Jun 08, 2026 at 07:06:52PM +0200, Lorenzo Bianconi wrote:
> > Switch nf_flow_ip6_tunnel_proto() from skb_header_pointer() to
> > pskb_may_pull() for header validation, aligning it with the approach
> > used in nf_flow_ip4_tunnel_proto().
> > Move ctx->offset update inside the IPPROTO_IPV6 conditional block since
> > it should only be adjusted when a tunnel is actually detected.
> > While at it, use nexthdr instead of the hardcoded IPPROTO_IPV6 constant
> > when setting ctx->tun.proto.
> >=20
> > Fixes: d98103575dcdd ("netfilter: flowtable: Add IP6IP6 rx sw accelerat=
ion")
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  net/netfilter/nf_flow_table_ip.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_t=
able_ip.c
> > index 9c05a50d6013..2946399ab715 100644
> > --- a/net/netfilter/nf_flow_table_ip.c
> > +++ b/net/netfilter/nf_flow_table_ip.c
> > @@ -347,15 +347,15 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_fl=
owtable_ctx *ctx,
> >  				     struct sk_buff *skb)
> >  {
> >  #if IS_ENABLED(CONFIG_IPV6)
> > -	struct ipv6hdr *ip6h, _ip6h;
> > +	struct ipv6hdr *ip6h;
> >  	__be16 frag_off;
> >  	u8 nexthdr;
> >  	int hdrlen;
> > =20
> > -	ip6h =3D skb_header_pointer(skb, ctx->offset, sizeof(*ip6h), &_ip6h);
> > -	if (!ip6h)
> > +	if (!pskb_may_pull(skb, sizeof(*ip6h) + ctx->offset))
> >  		return false;
> > =20
> > +	ip6h =3D (struct ipv6hdr *)(skb_network_header(skb) + ctx->offset);
> >  	if (ip6h->hop_limit <=3D 1)
> >  		return false;
>=20
> Not shown in the patch, but is there still a corner case here that
> needs to be covered?
>=20
> ipv6_skip_exthdr() uses skb_header_pointer() internal, then another
> pskb_may_pull() is needed to make sure no other IPv6 extension header
> sits between the outer and the inner IPPROTO_IPV6 header, allowing to
> be in a non-linear area of the skb?       =20
>=20
> > @@ -367,9 +367,9 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flow=
table_ctx *ctx,
> > =20
>=20
> I mean:
>=20
>         if (!pskb_may_pull(skb, hdrlen))
>                 return false;
>=20
> where hdrlen is what ipv6_skip_exthdr() returns.
>=20
> Then, I think it should be safe to call skb_pull() on
> ctx->tun.hdr_size.
>=20
> Let me know, thanks.

I think you are right, here we need to run:

	if (!pskb_may_pull(skb, hdrlen))
		return false;

in order to be sure we can pull ctx->tun.hdr_size in nf_flow_ip_tunnel_pop(=
).
Doing so, we can roll-back to the original skb_header_pointer() to access t=
he
outer ip6 header here. What do you think?

Regards,
Lorenzo

>=20
> >  	if (nexthdr =3D=3D IPPROTO_IPV6) {
> >  		ctx->tun.hdr_size =3D hdrlen;
> > -		ctx->tun.proto =3D IPPROTO_IPV6;
> > +		ctx->tun.proto =3D nexthdr;
> > +		ctx->offset +=3D ctx->tun.hdr_size;
> >  	}
> > -	ctx->offset +=3D ctx->tun.hdr_size;
> > =20
> >  	return true;
> >  #else
> >=20
> > ---
> > base-commit: 9772589b57e44aedc240211c5c3f7a684a034d3a
> > change-id: 20260608-b4-nf_flow_ip6_tunnel_proto-update-8b64903825b4
> >=20
> > Best regards,
> > --=20
> > Lorenzo Bianconi <lorenzo@kernel.org>
> >=20

--yewHE/uM8fRf8hKj
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCaifquAAKCRA6cBh0uS2t
rK/WAP0U7OK/wfRFK/tcbhrI2iJS5+E65xe2Vf1TG9P++3A5sgEAtzWvE/DOWDHb
qTqf7sEkudyyc/5VkJCnK7ODxtpSzgU=
=iAF4
-----END PGP SIGNATURE-----

--yewHE/uM8fRf8hKj--
