Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F02029430;
	Tue,  9 Jun 2026 12:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781008266; cv=none; b=S7dZlbahup8VSOiEJyfyYINFbfS0kQ28NQ1t02LBxoAvx462FUBKw18C/c0w9eLZOVfLFpeS2PtrMhoLdny9QOyevUjhYUMX1lyeDNtqi9QlJQ6HMemypMPWkC/nf43wZ8FntBHKbMIDLuqc4JgRjEeuc+SKgeqHwyELvhcaBfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781008266; c=relaxed/simple;
	bh=YPwt4E1/e8himmYevZRXgTWF3kQYEVRHVJbGkTWZ8BI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p3lj9wpat9+SkXAQq8mSN5XKWkD9QvZNEaQe2oOTcK/sFAKlqgdfbLykd2RQijH9dH+QxCBv1IWzOVega71s79mChAn08Zv4TRLrJIvqfTJ2p9T829jwr2W3M7cWiJ2liFB4prMNZV5fjF9nIYXTSL62jvj1wb0DyCZDLmujFHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lPzkSg6f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lPzkSg6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094771F00893;
	Tue,  9 Jun 2026 12:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781008265;
	bh=XxGMHwpxpnnJ88QD7pD2AhEOfioYfC2UjFXsfe9cfiY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lPzkSg6f1t6qGPmiU2pqMH6rPHJwYIDfeMFT1q83mhwQedOLzr9k6Uf0bgQt9am3I
	 J3nysXosPdEFLd9drknpm+VKEqicMDpWzIS/Qe+kevtH2Om4Qz+aVgYot6gIq2l70c
	 z35PF09jIzVTL+pLbP9JEg+fhWE/wc/mCnvc/5TkljSL1ZEMdXbNEGxuB70Bxx+YF/
	 a84efvuJDDqSkZPEFcH433xZPXWQiR4jvLCgEZWCopY4hVg0b9RIHWg4jksEenG/J6
	 V/jzGI36VOc7jNHOcjuhhMEtnhEjWP/dZ/RDXH4eqWC+3Cduw8GrD00HGyp+1aVBqy
	 PLXso7lMEt/Og==
Date: Tue, 9 Jun 2026 14:31:03 +0200
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
Message-ID: <aigHh5cBKc12frX2@lore-desk>
References: <20260608-b4-nf_flow_ip6_tunnel_proto-update-v1-1-782c7052c8fd@kernel.org>
 <aidMPKrm9gOcPLW-@chamomile>
 <aifquGhK_Cijxq7m@lore-desk>
 <aif9kL38LKNcX1Xu@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="t5tthOR2Bt0x9qQ/"
Content-Disposition: inline
In-Reply-To: <aif9kL38LKNcX1Xu@chamomile>


--t5tthOR2Bt0x9qQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, Jun 09, 2026 at 12:28:08PM +0200, Lorenzo Bianconi wrote:
> > On Jun 09, Pablo Neira Ayuso wrote:
> > > Hi Lorenzo,
> > >=20
> > > On Mon, Jun 08, 2026 at 07:06:52PM +0200, Lorenzo Bianconi wrote:
> > > > Switch nf_flow_ip6_tunnel_proto() from skb_header_pointer() to
> > > > pskb_may_pull() for header validation, aligning it with the approach
> > > > used in nf_flow_ip4_tunnel_proto().
> > > > Move ctx->offset update inside the IPPROTO_IPV6 conditional block s=
ince
> > > > it should only be adjusted when a tunnel is actually detected.
> > > > While at it, use nexthdr instead of the hardcoded IPPROTO_IPV6 cons=
tant
> > > > when setting ctx->tun.proto.
> > > >=20
> > > > Fixes: d98103575dcdd ("netfilter: flowtable: Add IP6IP6 rx sw accel=
eration")
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > ---
> > > >  net/netfilter/nf_flow_table_ip.c | 10 +++++-----
> > > >  1 file changed, 5 insertions(+), 5 deletions(-)
> > > >=20
> > > > diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_fl=
ow_table_ip.c
> > > > index 9c05a50d6013..2946399ab715 100644
> > > > --- a/net/netfilter/nf_flow_table_ip.c
> > > > +++ b/net/netfilter/nf_flow_table_ip.c
> > > > @@ -347,15 +347,15 @@ static bool nf_flow_ip6_tunnel_proto(struct n=
f_flowtable_ctx *ctx,
> > > >  				     struct sk_buff *skb)
> > > >  {
> > > >  #if IS_ENABLED(CONFIG_IPV6)
> > > > -	struct ipv6hdr *ip6h, _ip6h;
> > > > +	struct ipv6hdr *ip6h;
> > > >  	__be16 frag_off;
> > > >  	u8 nexthdr;
> > > >  	int hdrlen;
> > > > =20
> > > > -	ip6h =3D skb_header_pointer(skb, ctx->offset, sizeof(*ip6h), &_ip=
6h);
> > > > -	if (!ip6h)
> > > > +	if (!pskb_may_pull(skb, sizeof(*ip6h) + ctx->offset))
> > > >  		return false;
> > > > =20
> > > > +	ip6h =3D (struct ipv6hdr *)(skb_network_header(skb) + ctx->offset=
);
> > > >  	if (ip6h->hop_limit <=3D 1)
> > > >  		return false;
> > >=20
> > > Not shown in the patch, but is there still a corner case here that
> > > needs to be covered?
> > >=20
> > > ipv6_skip_exthdr() uses skb_header_pointer() internal, then another
> > > pskb_may_pull() is needed to make sure no other IPv6 extension header
> > > sits between the outer and the inner IPPROTO_IPV6 header, allowing to
> > > be in a non-linear area of the skb?       =20
> > >=20
> > > > @@ -367,9 +367,9 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_=
flowtable_ctx *ctx,
> > > > =20
> > >=20
> > > I mean:
> > >=20
> > >         if (!pskb_may_pull(skb, hdrlen))
> > >                 return false;
> > >=20
> > > where hdrlen is what ipv6_skip_exthdr() returns.
> > >=20
> > > Then, I think it should be safe to call skb_pull() on
> > > ctx->tun.hdr_size.
> > >=20
> > > Let me know, thanks.
> >=20
> > I think you are right, here we need to run:
> >=20
> > 	if (!pskb_may_pull(skb, hdrlen))
> > 		return false;
> >=20
> > in order to be sure we can pull ctx->tun.hdr_size in nf_flow_ip_tunnel_=
pop().
> > Doing so, we can roll-back to the original skb_header_pointer() to acce=
ss the
> > outer ip6 header here. What do you think?
>=20
> Yes, initial skb_header_pointer() then pskb_may_pull(skb, hdrlen) to
> ensure the entire should be fine.
>=20
> I think this need one more fix: This needs to resort to classic path
> if there are intermediate extension headers sitting in between the
> outer and inner headers in IP6IP6, ie. ipv6_ext_hdr() =3D=3D true. Those
> extensions need to be handled by the IPv6 stack.

In my setup we have just a single Destination Option extension header (60)
between the outer and the inner IPV6 headers. In order to check if we have
other extensions headers other than Destination Option (and if so, send the
packet the networking stack) I guess we need to implement something similar
to ipv6_skip_exthdr(), agree?

>=20
> nf_flow_ip6_tunnel_proto() needs to be fixed to deal with this.=20

Do you want to do it with a dedicated patch or do you prefer to do it in th=
is
one?

> And I suspect nf_flow_ip4_tunnel_proto() with IP options have the same
> problem, the flowtable need to resort to the classic stack path.

In the IPv4 case, if the packet has options nf_flow_ip4_tunnel_proto() will
return false and so the packet will be sent to the networking stack.

Regards,
Lorenzo

>=20
> Thanks.

--t5tthOR2Bt0x9qQ/
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCaigHhwAKCRA6cBh0uS2t
rPNnAQD2clizkaYI6q2SFGurL+WaRcTj9ESoJPOBP5XDNnQQPgEA4QlU2M0raNY/
mga/LSvbwjDT18SqisXEtc2EE4WSlww=
=B8ir
-----END PGP SIGNATURE-----

--t5tthOR2Bt0x9qQ/--
