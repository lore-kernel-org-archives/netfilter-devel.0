Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5F514F10F
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2024 20:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732046836; cv=none; b=Q0OODi9NZ9oMRWLxj8QsDcs/yNPbBGAhtA2E2Z0vA0RUBoz83aqygR1qoHnaHzsg3E10oX6wRT0d+DwPrZqEtQlhw3hXs51ad4ia7CJIJf95BPsZZ3a77Jm+V/WEEpZrgm+TkEO4qXsbht3qY5dGl6plY2MAipI2DZvrrtiX02k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732046836; c=relaxed/simple;
	bh=tCKA6zBzXAY6QCOK+f0YAHd587GhveMF2fJsZ5irSyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cnb9qTlmKnwS7x5MAEsg7AX4pkc25mhD7rp2JnJmxZvOmthpPYcx6SghVsdfKqpIg3j4DAtfQ9ZTAJBwPGlFfyzwndT1P49xTgE8+IZ5jOreY/kqOi36BfsKhnYKDK9xorv7FSibAks6qGU5MwQPmwEEXRleKf9HyWoU4RunQ0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=UC1IpG9y; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="UC1IpG9y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mRmlOJh/dLDp+6S48HVg+bNgSzc/Vsa0MADvNMAbbF8=; b=UC1IpG9ydwHJlRgnPde9GC+naf
	5YGDce3lH1Uc2VGCj7cv5XA/6E6+dATRKGSlFd0itnbKY2lMJOcXh/NjYRnCbq/4AwlPjeMzXd+p/
	7KLDlq4e+fHQ9KQ+RsXUZG4OkAJBfKyHtULVUa+XeIJjW+MnIvPa7zVQjzdhKnwaXuU2rwlEs1Js5
	FUUPytkiWC20F5K2SK6zmExnfmYQF4FydVxAyw+gad50zKGDdPIJWAtHkq4Fu4eGIAgeggElAQz4M
	XFcRpEPUbIKasms68b3tmJwcaSPH69755RbzhR8Am6g/0ZvQ+IKBa7SYbM0Q+dSl5JDArODQqe+kK
	MFflsiXw==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1tDUV3-009seU-3B;
	Tue, 19 Nov 2024 20:07:02 +0000
Date: Tue, 19 Nov 2024 20:07:00 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Phil Sutter <phil@nwl.cc>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Eric Garver <eric@garver.life>
Subject: Re: [PATCH iptables] nft: fix interface comparisons in `-C` commands
Message-ID: <20241119200700.GA3017153@celephais.dreamlands>
References: <20241118135650.510715-1-jeremy@azazel.net>
 <ZzyQn9E0cPi7t98b@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="boLsS7SF5yc/aHp5"
Content-Disposition: inline
In-Reply-To: <ZzyQn9E0cPi7t98b@orbyte.nwl.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--boLsS7SF5yc/aHp5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2024-11-19, at 14:20:31 +0100, Phil Sutter wrote:
> On Mon, Nov 18, 2024 at 01:56:50PM +0000, Jeremy Sowden wrote:
> > Remove the mask parameters from `is_same_interfaces`.  Add a test-case.
>=20
> Thanks for the fix and test-case!
>=20
> Some remarks below:
>=20
> [...]
> >  bool is_same_interfaces(const char *a_iniface, const char *a_outiface,
> > -			unsigned const char *a_iniface_mask,
> > -			unsigned const char *a_outiface_mask,
> > -			const char *b_iniface, const char *b_outiface,
> > -			unsigned const char *b_iniface_mask,
> > -			unsigned const char *b_outiface_mask)
> > +			const char *b_iniface, const char *b_outiface)
> >  {
> >  	int i;
> > =20
> >  	for (i =3D 0; i < IFNAMSIZ; i++) {
> > -		if (a_iniface_mask[i] !=3D b_iniface_mask[i]) {
> > -			DEBUGP("different iniface mask %x, %x (%d)\n",
> > -			a_iniface_mask[i] & 0xff, b_iniface_mask[i] & 0xff, i);
> > -			return false;
> > -		}
> > -		if ((a_iniface[i] & a_iniface_mask[i])
> > -		    !=3D (b_iniface[i] & b_iniface_mask[i])) {
> > +		if (a_iniface[i] !=3D b_iniface[i]) {
> >  			DEBUGP("different iniface\n");
> >  			return false;
> >  		}
> > -		if (a_outiface_mask[i] !=3D b_outiface_mask[i]) {
> > -			DEBUGP("different outiface mask\n");
> > -			return false;
> > -		}
> > -		if ((a_outiface[i] & a_outiface_mask[i])
> > -		    !=3D (b_outiface[i] & b_outiface_mask[i])) {
> > +		if (a_outiface[i] !=3D b_outiface[i]) {
> >  			DEBUGP("different outiface\n");
> >  			return false;
> >  		}
>=20
> My draft fix converts this to strncmp() calls, I don't think we should
> inspect bytes past the NUL-char. Usually we parse into a zeroed
> iptables_command_state, but if_indextoname(3P) does not define output
> buffer contents apart from "shall place in this buffer the name of the
> interface", so it may put garbage in there (although unlikely).

Seems reasonable.  I was so focussed on the masks and bit-twiddling that
I lost sight of the fact that the code is looping to compare strings. :)

> Another thing is a potential follow-up: There are remains in
> nft_arp_post_parse() and ipv6_post_parse(), needless filling of the mask
> buffers. They may be dropped along with the now unused mask fields in
> struct xtables_args.

Yes, I spotted those.  I couldn't see how they were used, but I was
reasonably sure that they weren't related to this bug, so I stopped
looking.

> WDYT?

Agreed on both counts.  Shall I incorporate your suggestions and send a
v2 or do you have something already prepared?

J.

--boLsS7SF5yc/aHp5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmc879QACgkQKYasCr3x
BA1P+xAAzyQXaIWCy/BUcciGQC6a8pWucOW5jebIMOm88qBv3m8E04L961Xma/e0
UNzXcXVE2hquD2J/U4lxo500JXUBvlmqVL4MO1rFuMJuonnor4F3jTvyL6TrqPxQ
SzWS6X4/kAVw65n2sQ2yMjvh2MFzh9AUT1LiS7R3RX4flFuc9aDfFrY/4zxOr3pT
vjMyeqfPtAJfjDAqCgxTuPJhpAaNYRZaYodthnf+YdnO5h0lSJx2VsHWlXfbT5EI
/f5QQHmJkxhrJ0VZzgcs7zFrjRg9mLGYHR6fBQLKCPiodBdgrDDaejUAZQB2Ema/
2mMawwqUQJKBXjp0XI+IuaMzZ56GQ8lHkY2Pvw4cHYPoY7l6YjK0/HWJlO7NvJJZ
SOhUqHCH/Rgwj2w6eNcwESbzZH6OnTVEEsqMM/sCdXI5rqnEHZTHVwtuVxxBEaoQ
gTZaI/Bn5KS2tQK+JMbi5G6DzJU2f/nhXc+oWdk6qGhOx8DxuAJGq927uBYbjqGz
39K5FiAMwpXOpdBhW4HzNDRgnzs41bKvk8wEAKsmO3OR9eEYX3GHPmV3flkurrpE
WA4jY1mSS2mwttYF4z6NzXrNzf/E2LGHypkbnU3K4EJuvaJ0EIl/wVPbNHz0eal3
fcw7hG/WQluAxWED72KswBZ3Bh9//EZfRltXLr/xFeSFzEDjBG0=
=6UML
-----END PGP SIGNATURE-----

--boLsS7SF5yc/aHp5--
