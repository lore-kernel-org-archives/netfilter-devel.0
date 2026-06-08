Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F30B335BA7;
	Mon,  8 Jun 2026 12:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780921266; cv=none; b=ZDTg1rtof0xR/2CWe4pEfldj9ggO7MeC4oxtL17H/KrHxEnuIo3ENZovDJtLHUn21CTobLfF31sP+8XVXkNbrtLh4Ic5u14o/W/gi7BxGEey3XbOY2v7Z1vSCoj5Q0+soakqy4Eo5H3cLt1qmX/nYuZgXt2WfJoC9R5WWBUB28s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780921266; c=relaxed/simple;
	bh=kPdSJVerO5eKGnqmr8AeSvLcHMZxo00cEgjVY3kRSoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GxlygvIVjd8CCBrSsvhIneZ0ym7wUAwmXaH51b16Cwx7lPWmwH3CtMhJnVDCQrU6/TcCWWruhtpe4+uqDJVxU43jx3xgNmvha8lQiKLckaf9U1mNIMZaV/7CufOJecl+iUR/RSIBAm4Fuygi1tcMwaHMV2j1uU73ISoOhULVn24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dsjDgQz3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dsjDgQz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC49A1F00893;
	Mon,  8 Jun 2026 12:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780921265;
	bh=8y/Xygmhj9oZT1geF0DOtdpKjFIhSo/CYHFg0TrUQ4s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dsjDgQz31uZ+SLcZEaa7RLw/gnEzWO5l/RUGDqdky0C9i1tJkQA4MDHWT8OQ6lTN6
	 mPMOkD/aBJtRdNTbQOTOND97WJTgpOh6TNc67b56ymoW91VlzpAqcLldAufJSlSc+z
	 jklka1DB5Shd1uYkNqWrsKADi2BbJUwSEWJ2SUGx0BfRX/K17tUVATqtu3Ymz5qjdO
	 Y3dHH4as8jdPvqZWdMc2V7HtBsOp5+/a+3EAg2nI5nP8lJEZ4awiPuBp4monumjkpX
	 H1e2VvTRnRokL7bjKG3tKD1aCWoknXT5fcpHdtEao7zhiYdPUOoy3enP45XmNHbegZ
	 4rzv13iZVMtfw==
Date: Mon, 8 Jun 2026 14:21:02 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: flowtable: Validate iph->ihl in
 nf_flow_ip4_tunnel_proto()
Message-ID: <aiazro1IFB39rqBV@lore-desk>
References: <20260605-nf_flow_ip4_tunnel_proto-update-v1-1-9de42230f080@kernel.org>
 <aiVADSnC6rBgpUnz@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="GSeP1wfRQ6QZ01M2"
Content-Disposition: inline
In-Reply-To: <aiVADSnC6rBgpUnz@chamomile>


--GSeP1wfRQ6QZ01M2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Hi Lorenzo,
>=20
> Thanks for your patch, comments below.
>=20
> On Fri, Jun 05, 2026 at 06:47:48PM +0200, Lorenzo Bianconi wrote:
> > Add sanity check for iph->ihl field in nf_flow_ip4_tunnel_proto routine.
> > Moreover, similar to nf_flow_ip6_tunnel_proto(), rely on
> > skb_header_pointer() to validate skb header layout.
> >=20
> > Fixes: ab427db178858 ("netfilter: flowtable: Add IPIP rx sw acceleratio=
n")
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  net/netfilter/nf_flow_table_ip.c | 14 ++++++++------
> >  1 file changed, 8 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_t=
able_ip.c
> > index 9c05a50d6013..9684c19da37a 100644
> > --- a/net/netfilter/nf_flow_table_ip.c
> > +++ b/net/netfilter/nf_flow_table_ip.c
> > @@ -319,15 +319,17 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_b=
uff *skb,
> >  static bool nf_flow_ip4_tunnel_proto(struct nf_flowtable_ctx *ctx,
> >  				     struct sk_buff *skb)
> >  {
> > -	struct iphdr *iph;
> > +	struct iphdr *iph, _iph;
> >  	u16 size;
> > =20
> > -	if (!pskb_may_pull(skb, sizeof(*iph) + ctx->offset))
> > +	iph =3D skb_header_pointer(skb, ctx->offset, sizeof(*iph), &_iph);
>=20
> I think we have to update nf_flow_ip6_tunnel_proto() to call
> pskb_may_pull() instead, given that this calls skb_pull() later on to
> pull the tunnel header and this ensures that the IP header this will
> pull will be in a linear area.

ack, I will fix it in v2.

Regards,
Lorenzo

>=20
> > +	if (!iph)
> >  		return false;
> > =20
> > -	iph =3D (struct iphdr *)(skb_network_header(skb) + ctx->offset);
> > -	size =3D iph->ihl << 2;
> > +	if (iph->ihl < 5)
> > +		return false;
> > =20
> > +	size =3D iph->ihl << 2;
> >  	if (ip_is_fragment(iph) || unlikely(ip_has_options(size)))
> >  		return false;
> > =20
> > @@ -335,9 +337,9 @@ static bool nf_flow_ip4_tunnel_proto(struct nf_flow=
table_ctx *ctx,
> >  		return false;
> > =20
> >  	if (iph->protocol =3D=3D IPPROTO_IPIP) {
> > -		ctx->tun.proto =3D IPPROTO_IPIP;
> > +		ctx->tun.proto =3D iph->protocol;
> >  		ctx->tun.hdr_size =3D size;
> > -		ctx->offset +=3D size;
> > +		ctx->offset +=3D ctx->tun.hdr_size;
> >  	}
> > =20
> >  	return true;
> >=20
> > ---
> > base-commit: 4aacf509e537a711fa71bca9f234e5eb6968850e
> > change-id: 20260605-nf_flow_ip4_tunnel_proto-update-b31f7bff6fb9
> >=20
> > Best regards,
> > --=20
> > Lorenzo Bianconi <lorenzo@kernel.org>
> >=20

--GSeP1wfRQ6QZ01M2
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCaiazrgAKCRA6cBh0uS2t
rJJ7AQC2AhgmTUHELl6TNKQllTfrmvwK9U1mDHuuuQPH6tDzSgD/a/8oyeq4L115
tURpzEE8HmAjEqUAFDEH8cM4Su0dqwM=
=SzBT
-----END PGP SIGNATURE-----

--GSeP1wfRQ6QZ01M2--
